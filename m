Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:57437 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbbBWVay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 16:30:54 -0500
Date: Mon, 23 Feb 2015 23:30:50 +0200
From: Jouni Malinen <j@w1.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: AR9462 problems connecting again..
Message-ID: <20150223213050.GA23232@w1.fi> (sfid-20150223_223056_998835_E3E6970C)
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
 <CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
 <CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
 <CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
 <CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
 <CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
 <CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
 <CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
 <20150223171700.GA29730@w1.fi>
 <CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2015 at 12:06:09PM -0800, Linus Torvalds wrote:
> On Mon, Feb 23, 2015 at 9:17 AM, Jouni Malinen <j@w1.fi> wrote:
> > mac80211: Do not encrypt EAPOL frames before peer has used the key
> 
> Hmm. This patch does not seem to make a difference. I thought it did
> at first, but then removed the wpa_supplicant debugging, and got the
> same failures.

Interesting. That would seem to imply that this AP does not like
something about the EAPOL-Key msg 4/4 from the station during the faster
timing (no wpa_supplicant debug) and would even be unable to accept the
responses during retransmissions.. I'm not sure what could cause that.
Is there anything that the AP could provide as far as logging is
concerned?

How far is the station from the AP? Would it be possible to see whether
the behavior changes if you were within, say, five meters or so? This
should allow the higher transmit rate proposed by minstrel_ht to work
pretty reliably and that could confirm if this is indeed related to too
high a rate being used here and then for some reason being unable to
fall back to a sufficiently low rate to work at higher distance.

It would be useful if you can capture the 802.11 frame exchange from a
failed connection case with an external wireless sniffer. It sounds
like this should be doable with iwlwifi and while I haven't tested this
myself, I'd assume something like this would do the trick (this is
assuming that the interface is not being used at the time, e.g., with
wpa_supplicant):

sudo iw dev wlan0 set type monitor
sudo ip link set wlan0 up
sudo iw dev wlan0 set freq 2462 HT20
sudo dumpcap -i wlan0 -w /tmp/wlan0.pcap

# test connection and stop dumpcap after the failure
# and "sudo ip link set wlan0 down; sudo iw dev wlan0 set type station"
# to restore normal station mode

-- 
Jouni Malinen                                            PGP id EFC895FA
