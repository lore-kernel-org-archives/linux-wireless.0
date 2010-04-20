Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13325 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab0DTJFo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 05:05:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Apr 2010 02:05:44 -0700
Subject: Re: [ath9k-devel] ath9k: corrupt frames forwarded to mac80211 as
 decrypted
From: Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Reply-To: ranga.ravuri@atheros.com
To: Johan Hovold <johan.hovold@lundinova.se>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100420082519.GB5288@lundinova.se>
References: <20100331191058.GD18913@lundinova.se>
	 <20100416104850.GA13329@lundinova.se>  <20100420082519.GB5288@lundinova.se>
Content-Type: text/plain
Date: Tue, 20 Apr 2010 14:40:51 +0530
Message-ID: <1271754651.14253.112.camel@ranga-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi 

Can you please tell us more about your test, 
what exactly is your test is ? 
What kind of traffic are you running 
what is your AP ?. 
Are you testing with aggregated traffic or non-aggregate legacy
traffic ?
Are you seeing only when CCMP is enabled or in WEP/TKIP also ?
Can you please set register 0x8120 bit 28 to 1 and test this again to
see that helps ?

thanks
Ranga

On Tue, 2010-04-20 at 13:55 +0530, Johan Hovold wrote:
> Hi again,
> 
> On Fri, Apr 16, 2010 at 12:48:50PM +0200, Johan Hovold wrote:
> > I now know why 802.11n receive stalls; ath9k is passing corrupt frames to
> > mac80211.
> [...]
> > An example of such a frame is:
> > 
> > 	00000000: 88 41 30 00 00 80 48 68 08 0f 00 21 6a 56 2c 36
> > 	00000010: 00 22 02 00 0b 63 20 52 00 00 20 21 21 05 00 20
> > 	00000020: 8a 39 7b 1f 0f 11 07 9e bd 53 80 33 3b 8c 98 00
> > 	00000030: ef 5f da 7c 9a d6 3d d7 59 ac e0 21 44 88 63 d7
> > 	00000040: 21 34 b7 9a 89 8e cf 9e 46 1c ee d6 81 56 25 59
> > 	00000050: d2 ec ac 33 e6 12 3d c5 02 61 2d 80 8d 30 44 1e
> > 	00000060: 79 74 79 79 62 25 ba ec 04 4d 54 dc
> > 
> > with associated status
> > 
> > 	rxstatus8 = 1e989103
> > 
> > Here nothing in the frame status indicates an error; the frame has no error
> > flags set, the frame-ok flag is set, and so on. Still the frame is indeed
> > corrupt; the last four octets of the CCMP-header (bytes 0x20..0x23) should
> > be {00,00,00,00} rather than {8a,39,7b,1f} as the correct PN is 0x0521 (not
> > 0x1f7b398a0521).
> > 
> > The corrupt frames all seem to have the upper half of the CCMP-header, data
> > and MIC corrupted, whereas the FCS (last four bytes) seem to be correct in the
> > sense that they match what I see in the air (and is verified by wireshark).
> > 
> > One explanation for all of this could be that the corrupt packet is what the
> > hardware is expected to return should it's processing fail (e.g. due to
> > checksum error). Then the problem is merely that the status field sometimes
> > get corrupted (some frames with corrupt PN do indeed come with matching
> > rxstatus). Comments in the code concerning corrupt status fields also point in
> > this direction.
> > 
> > Another explanation could be that the status is actually correct but for some
> > reason the returned frame is corrupted. Perhaps it's a combination of both
> > corrupt status and frame.
> > 
> > Any ideas about what may be going on here?
> 
> I'll answer my own question -- the status field is clearly corrupted.
> The bad frames all have status such as 
> 
> 	19fdb637
> 	9131f6d7
> 	87b3f0c1
> 	29de5e7b
> 	10c68ff3
> 	4c1a33c7
> 	9abd470b
> 
> where it should look something like 00030943. From inspection of
> returned frame status, I've come up with at way to catch these; I
> discard frames marked ok but with errors flags set or which have any of
> the reserved bits 19 through 28 (0x1ff80000) set.
> 
> My question is: Is the latter assumption correct? Can I expect bits
> 19..28 to be zero?
> 
> On my AR9820 hardware this seems to be case and I am able to catch all
> the corrupt frames and have 802.11n work perfectly. It also works fine
> with 802.11g/WEP/TKIP/CCMP.
> 
> As a side note, I also seem able to confirm my observation above that
> frames returned with non-corrupt status and decrypt error flag set
> indeed do have corrupt CCMP header, data and MIC. That is, this seem to
> be what hw is expected to return on (such) errors.
> 
> I'm responding to this mail with my fix (workaround).
> 
> I have also seen non-decrypted frames with decrypt busy flag set but
> without decrypt crc err set (frame is marked not ok). I'm not sure
> whether this is due to a bug or bit error (decrypt crc somehow got
> cleared) but I also propose a change to remedy this.
> 
> Thanks,
> Johan Hovold
> 
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel

