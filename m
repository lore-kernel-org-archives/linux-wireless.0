Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:57345 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbbBWLFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 06:05:54 -0500
Date: Mon, 23 Feb 2015 13:05:50 +0200
From: Jouni Malinen <j@w1.fi>
To: wim torfs <wtorfs@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: AR9462 problems connecting again..
Message-ID: <20150223110550.GA4569@w1.fi> (sfid-20150223_120557_882403_8269219F)
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
 <CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
 <CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
 <CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
 <CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
 <CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
 <CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
 <CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
 <20150223103741.GA3594@w1.fi>
 <54EB0722.2030509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54EB0722.2030509@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2015 at 11:55:30AM +0100, wim torfs wrote:
> If it is the case that the 4-way handshake fails, then I have seen
> this issue before. The problem is that messages 1 to 4 are sent with
> the previous key. However, right after sending message 4/4, does
> wpa_supplicant set the new key. In some cases, such as in a high
> throughput environment, this could result that the key is set even
> before the last packet is sent out. As a result, the AP receives a
> packet which is encrypted with the wrong key, since it still listens
> with the old key.

The specific case here is not PTK rekeying, i.e., it is for the initial
4-way handshake, so there is no previous pairwise key in place. That
said, I guess it would be possible for some drivers to hit this even
with the initial PTK configuration if hardware acceleration is used for
encryption and the frame gets delayed sufficiently long while waiting
for medium access.

> A solution would be to adjust wpa_supplicant to wait for the
> transmission ack before it sets its key, however, this causes issues
> with the key reception and transmission count, which could be
> circumvented by copying the old counter values upon setting the new
> key, but this is a dirty hack. Another solution would require some
> more invasive operations, that is, the new key should somehow be
> linked to the message 4/4 and should only be set by the driver upon
> transmission of the message 4/4.

I've been thinking of adding EAPOL TX status reporting into
wpa_supplicant at least to make the debug log more helpful. However,
this does indeed cause issues for RX and I'm not really sure I'd like to
delay pairwise key configuration. The proper way of handling this would
be by doing what the standard really implies, i.e., configure the key
for RX only at first and then enable it for TX after EAPOL-Key msg 4/4
has been transmitted. Though, that should really be interpreted with
something like "enable for TX after the AP has used the key" due to this
possibility for retransmissions of EAPOL-Key 3/4. That said, there are
corner cases even with this design, e.g., due to the STA wanting to
transmit Data frames to the AP immediately after EAPOL-Key 4/4; those
should really be encrypted, so the behavior here would likely need to be
conditional on ethertype (RX-only for EAPOL, RX+TX for everything else).

Things get even messier with PTK rekeying when there would actually need
to be support for two keys (even with the same key index..) so that the
retransmitted EAPOL-Key 3/4 case could be detected and replied to in a
way that the AP understands the response. This gets unfortunately ugly
and I'd assume almost no station implements this in a way that would
handle all cases cleanly (i.e., just hope for msg 4/4 to go through and
reassociate as a backup plan if things fail..).

-- 
Jouni Malinen                                            PGP id EFC895FA
