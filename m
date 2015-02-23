Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:57327 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbbBWKhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 05:37:45 -0500
Date: Mon, 23 Feb 2015 12:37:41 +0200
From: Jouni Malinen <j@w1.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: AR9462 problems connecting again..
Message-ID: <20150223103741.GA3594@w1.fi> (sfid-20150223_113749_049441_8616847A)
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
 <CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
 <CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
 <CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
 <CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
 <CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
 <CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
 <CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2015 at 05:41:25PM -0800, Linus Torvalds wrote:
> Ok. Attached is what seems to be the relevant part of the
> wpa_supplicant.log file.
> 
> The datestamp has been changed so that it can be matched up with the
> dmesg, and I added empty lines for pauses when I was trying to figure
> out what the heck it was doing, but other than that it's the raw log.

> 14:07:16.059389: nl80211: Authenticate (ifindex=3)
> 14:07:16.390659: nl80211: MLME event 37; timeout with 20:9f:db:e7:80:80

I'm assuming this is unrelated to the issue of getting disconnected
after 4-way handshake, but anyway, something here prevent the simple
Authentication frame exchange from completing (i.e., either the AP did
not reply to these these frames or the response was lost for some
reason). The following attempt did you go through without issues.

> 14:07:19.478850: nl80211: Authenticate (ifindex=3)
> 14:07:19.493911: nl80211: Authenticate event

> 14:07:19.494223: nl80211: Associate (ifindex=3)
> 14:07:19.503237: nl80211: Associate event

> 14:07:19.504682: wlp1s0: WPA: RX message 1 of 4-Way Handshake from 20:9f:db:e7:80:80 (ver=2)
> 14:07:19.505850: wlp1s0: WPA: Sending EAPOL-Key 2/4
> 14:07:19.510108: wlp1s0: WPA: RX message 3 of 4-Way Handshake from 20:9f:db:e7:80:80 (ver=2)
> 14:07:19.510233: wlp1s0: WPA: Sending EAPOL-Key 4/4

So it looks like both the AP and the station are able to send and
receive EAPOL frames. EAPOL-Key message 1/4..3/4 worked fine. However,
I'm assuming msg 4/4 did not make it through for some reason.

> 14:07:19.510338: wlp1s0: WPA: Installing PTK to the driver
> 14:07:19.510405: wpa_driver_nl80211_set_key: ifindex=3 alg=3 addr=0x7f0ab41cad68 key_idx=0 set_tx=1 seq_len=6 key_len=16
> 14:07:19.510435:    addr=20:9f:db:e7:80:80

And this is where IEEE 802.11 RSN gets a bit messy.. The station
installs a key for encrypting all unicast frames to the AP now that it
believes 4-way handshake has been completed successfully.

> 14:07:19.511009: wlp1s0: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=16)

And same for a key to decrypt received broadcast/multicast frames.

> 14:07:19.511205: wlp1s0: WPA: Key negotiation completed with 20:9f:db:e7:80:80 [PTK=CCMP GTK=CCMP]
> 14:07:19.511223: wlp1s0: Cancelling authentication timeout
> 14:07:19.511238: wlp1s0: State: GROUP_HANDSHAKE -> COMPLETED
> 14:07:19.511253: wlp1s0: CTRL-EVENT-CONNECTED - Connection to 20:9f:db:e7:80:80 completed [id=0 id_str=]

As far as the station is concerned, everything looked fine until here
and connection was established successfully.

> 14:07:20.512476: wlp1s0: WPA: RX message 3 of 4-Way Handshake from 20:9f:db:e7:80:80 (ver=2)

However, the AP disagrees.. It looks like this specific AP uses a one
second timeout on EAPOL-Key timeouts. This EAPOL-Key frame was likely
unencrypted since the AP did not receive (or accept, but more likely not
receive) msg 4/4. We are currently allowing such unencrypted EAPOL
frames (but not other ethertypes) to get processed even when the
pairwise key has been configured.

> 14:07:20.512674: wlp1s0: WPA: Sending EAPOL-Key 4/4

And here's an attempt to reply.. Alas, this will likely go out encrypted
since we have the pairwise key configured and the AP will be dropping it
most likely since it would configure the pairwise key for this station
only after having receive valid 4/4.

> 14:07:20.513170: wpa_driver_nl80211_set_key: ifindex=3 alg=3 addr=0x7f0ab41cad68 key_idx=0 set_tx=1 seq_len=6 key_len=16

And station reconfigured the key..

> 14:07:21.513331: wlp1s0: WPA: RX message 3 of 4-Way Handshake from 20:9f:db:e7:80:80 (ver=2)
> 14:07:22.514320: wlp1s0: WPA: RX message 3 of 4-Way Handshake from 20:9f:db:e7:80:80 (ver=2)

These are the following two retries from AP, one second apart. Trying
EAPOL-Key frames four times in normal behavior, so based on timing here,
the issue is in AP not receiving (or accepting) msg 4/4.

> 14:07:23.542903: nl80211: Deauthenticate event

And this is the expected deauthentication by the AP after the last
EAPOL-Key frame retransmission failed to get a valid response.


So yes, this is a race condition of sorts. It is interesting if verbose
debugging in wpa_supplicant is enough to make this less likely to fail.
That will give some more time between the EAPOL-Key msg 4/4 transmission
(packet socket send() on the netdev) and pairwise key configuration
(netlink send). In theory, it could be possible to get even the first
EAPOL-Key msg 4/4 encrypted if the kernel operations for Data frame
transmission and nl80211 key configuration get reordered. Though, if
that were to be happening commonly, we would see significantly more
issues with this, so I'd assume this is not really the main issue here.

I'm not sure why the AP would not accept EAPOL-Key msg 4/4, so it would
be interesting to see a wireless capture log to confirm that the first
attempt of sending that out did indeed result in the frame going out and
doing so without encryption.


As far as making this issue less likely to cause connectivity issues, I
guess we could make mac80211 do a similar hack that some drivers use
here and force the EAPOL-Key msg 4/4 retransmissions to go out without
encryption even though the pairwise key was configured. I think it would
be nicer to control this from user space (i.e., wpa_supplicant could
indicate with the send command that the frame needs to go out without
encryption), but that is unfortunately not something that the current
mechanism used for sending out EAPOL frames in station mode supports.
mac80211 should be able to track this state if it were to look at which
EAPOL-Key frames has been exchanged and start encrypting them only after
the AP has transmitted an encrypted frame with the new pairwise key.
This is somewhat ugly, but doable. (Though, this would be yet another
justification for finally trying to come up with an alternative
mechanism for handling EAPOL frame TX/RX that is really a special case
for IEEE 802.1X.)

-- 
Jouni Malinen                                            PGP id EFC895FA
