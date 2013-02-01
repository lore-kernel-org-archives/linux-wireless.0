Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:39621 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab3BATCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 14:02:05 -0500
Received: by mail-we0-f177.google.com with SMTP id d7so3257607wer.22
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2013 11:02:03 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 1 Feb 2013 11:02:00 -0800
Message-ID: <CAJ-Vmom4nwFJK+zaPsrs5ZfoJiJKueUn2xV4vYVRYqJyP90_hA@mail.gmail.com> (sfid-20130201_200210_378076_668E6AE8)
Subject: [ath9k] spectral scan update: HT40
From: Adrian Chadd <adrian@freebsd.org>
To: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I've been tinkering with the HT40 spectral scan data (in FreeBSD,
obviously :-) and I can finally state that I have it working and
working reliably.

The notes:

* The "MAC does silly things to the spectral scan payload" problem
there is in HT40 too, so you need similar correction code for that.
I've not yet committed that to FreeBSD, but I will soon.
* The HT40 lower and upper FFT bins in the radar / spectral scan are
just that - lower and upper halves of a 40MHz wide FFT.
* .. but the RSSI in the RX descriptor is Primary and Extension
channel RSSI, so you need to match them up correctly with what's
"lower" and "upper" - ie, in HT40- mode, the primary RSSI is the
upper, and the extension RSSI is lower.
* .. and yes, this means you calculate the bin power separately for
the lower and upper bins.
* On AR928x chips, the spectral scan FFT is done on chain 0. I don't
think that's changed in AR93xx series chips. So, use RSSI and NF from
chain 0, don't use the combined RSSI figures.
* RSSI can be below 0 dB, so make sure you factor that in.
* IIRC, RSSI from the RX header is in half-dB increments, so make sure
you factor that in.
* Because of the MAC corruption bug, you can't disable "short report"
- otherwise you don't know whether the spectral scan data results are
corrupted or not. So yes, you have to enable short report and thus you
get one result at a time in a PHY error.

I've mostly working code in FreeBSD's subversion tree -
http://svn.freebsd.org/base/user/adrian/ath_radar_stuff/ - look in
lib/libradarpkt and src/fft_eval .

I've begun fleshing out some documentation about spectral scan -
https://wiki.freebsd.org/dev/ath_hal%284%29/SpectralScan

I'm going to work on the invalid packet length detection and
correction, based on what our reference driver does and what Zefir has
done. But once that's done, the basic data parsing and power
calculation bits are done - I'll work on exporting it in a
jquery-compatible fashion over a network socket so people (read: not
me :-) can write some visualisation apps using HTML/javascript. That
way both Linux and FreeBSD (and whoever else!) wifi hackers can
leverage the same visualisation apps when hacking on this stuff.

HTH,



Adrian
