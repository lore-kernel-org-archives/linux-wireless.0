Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:39634 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753655AbXKWKvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 05:51:55 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com
Subject: ath5k signal/noise fixes
Date: Fri, 23 Nov 2007 19:52:00 +0900
Message-Id: <1195815123-22375-1-git-send-email-bruno@thinktube.com> (sfid-20071123_105200_317854_FDC43811)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


hello!

the next 3 patches contain fixes for the signal/noise level calibration and
reporting of ath5k.  i split them up because i'm not 100% sure of the second
two.

  1) fixes the reading of the noise floor register and puts it into one function.

  2) also enables noise floor calibration for rf511x.

  3) saves the read noise floor and exports signal/noise and "quality" to
  mac80211/wext.

i'm also not sure if what we call noise calibration in this case really is an
calibration or just a reading of the values?

is ath5k_hw the right place to store the noise_floor?

the values reported, especially the noise seems a bit high, it's around -77 in
the A bands and around -92 in G bands (thats with an AR5215/RF5111/2111), so we
might have some more tweaking to do. since i add the RSSI to get the signal
quality in dBm it seems a bit too high too.

this comment from madwifi leads me to believe this is the correct thing to do:

 * rx_rssi is in units of dbm above the noise floor.  This value
 * is measured during the preamble and PLCP; i.e. with the initial
 * 4us of detection.  The noise floor is typically a consistent
 * -96dBm absolute power in a 20MHz channel

at least we have some values to play with now :)

ah, and they are based on my last debugging and logging, patches (although
there are not huge dependencies).

bruno
