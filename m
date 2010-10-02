Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44480 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0JBA0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 20:26:16 -0400
Received: by bwz11 with SMTP id 11so2573222bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 17:26:15 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Saqeb Akhter <saqeb.akhter@gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
Date: Sat, 2 Oct 2010 02:26:06 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com> <201010020052.35855.chunkeey@googlemail.com> <AANLkTinfZdNCRNEmuaOot7_NadmbDN0UU5WbUX1pApYb@mail.gmail.com>
In-Reply-To: <AANLkTinfZdNCRNEmuaOot7_NadmbDN0UU5WbUX1pApYb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010020226.08493.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 October 2010 01:56:06 Saqeb Akhter wrote:
> Yes carl9170 (from 9/23).
wow, that's old. Luis posted a "special" compat-wireless release
for carl9170:

"See Announcement: Re: Compat-wireless release for 2010-10-01 v2 with RX filter for carl9170 on -p release"
http://www.orbit-lab.org/kernel/compat-wireless-2.6/2010/10/compat-wireless-2010-10-01-p.tar.bz2

---
> output iw dev wlan2 scan
> 
> BSS 30:46:9a:10:49:f7 (on wlan2) -- associated
> 	TSF: 90703162427 usec (1d, 01:11:43)
> 	freq: 5200
> 	beacon interval: 100
> 	capability: ESS ShortSlotTime (0x0401)
> 	signal: -53.00 dBm
> 	last seen: 672 ms ago
> 	SSID: sakhter-5g
> 	Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0
> 	DS Parameter set: channel 40
> 	HT capabilities:
> 		Capabilities: 0x1ce
> 			HT20/HT40
> 			SM Power Save disabled
> 			RX HT40 SGI
> 			TX STBC
> 			RX STBC 1-stream
> 			Max AMSDU length: 7935 bytes
> 			No DSSS/CCK HT40
> 		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
> 		Minimum RX AMPDU time spacing: 1/2 usec (0x02)
> 		HT RX MCS rate indexes supported: 0-15

> 		HT TX MCS rate indexes are undefined
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Now that's interesting, apparently Netgear's AP can't send HT (802.11n) frames!

But that's not your problem, it's the missing WMM extension.

Your AP should (additionally) display:
        WMM:     * Parameter version 1
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec


But since it doesn't, mac80211 does not enable ht.

Maybe a new firmware for the router would fix the issue?

Regards,
	Chr
