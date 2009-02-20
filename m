Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23960 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZBTElr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 23:41:47 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 20:41:47 -0800
Date: Thu, 19 Feb 2009 20:41:00 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <reinette.chatre@intel.com>, <yi.zhu@intel.com>,
	<samuel.ortiz@intel.com>
CC: <linux-wireless@vger.kernel.org>
Subject: iwlwifi bug when extending a channel struct
Message-ID: <20090220044100.GG4740@tesla> (sfid-20090220_054153_283898_F281F8B4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I ran into an issue with iwlagn when working on some patches for cfg80211.
Initially I thought it was my own patches (even though they didn't touch
iwlagn) due to some horrible memory corruption issue. As it turns out it
was my patches but I can reproduce this with this simple patch below.

diff --git a/include/net/wireless.h b/include/net/wireless.h
index d815aa8..64a1925 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -82,6 +82,7 @@ struct ieee80211_channel {
 	int max_power;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
+	bool bug;
 };
 
 /**

What ends up happening is the wiphy's band channels get all mangled up:

                Frequencies:
                        * 2412 MHz [1] (14.0 dBm)
                        * 2 MHz [-481] (disabled)
                        * 32 MHz [-475] (0.0 dBm) (passive scanning, no IBSS, radar detection)
                        * 255 MHz [-430] (0.0 dBm)
                        * 14 MHz [-478] (0.0 dBm)
                        * 0 MHz [-481] (2442.0 dBm)
                        * 0 MHz [-481] (8.0 dBm)
                        * 0 MHz [-481] (16.0 dBm) (no IBSS)
                        * 0 MHz [-481] (255.0 dBm) (passive scanning, radar detection)
                        * 2462 MHz [11] (14.0 dBm)
                        * 0 MHz [-481] (0.0 dBm)

                Frequencies:
                        * 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
                        * 40 MHz [-473] (disabled)
                        * 38 MHz [-473] (disabled)
                        * 255 MHz [-430] (0.0 dBm) (passive scanning, no IBSS)
                        * 15 MHz [-478] (0.0 dBm)
                        * 30 MHz [-475] (5300.0 dBm)
                        * 0 MHz [-481] (64.0 dBm)
                        * 0 MHz [-481] (disabled)
                        * 0 MHz [-481] (disabled)
                        * 5785 MHz [157] (16.0 dBm) (passive scanning, no IBSS)
                        * 161 MHz [-449] (disabled)
                        * 54 MHz [-470] (0.0 dBm)
                        * 0 MHz [-481] (0.0 dBm)

If I revert this patch I get what I would expect:

                Frequencies:
                        * 2412 MHz [1] (14.0 dBm)
                        * 2417 MHz [2] (14.0 dBm)
                        * 2422 MHz [3] (14.0 dBm)
                        * 2427 MHz [4] (14.0 dBm)
                        * 2432 MHz [5] (14.0 dBm)
                        * 2437 MHz [6] (14.0 dBm)
                        * 2442 MHz [7] (14.0 dBm)
                        * 2447 MHz [8] (14.0 dBm)
                        * 2452 MHz [9] (14.0 dBm)
                        * 2457 MHz [10] (14.0 dBm)
                        * 2462 MHz [11] (14.0 dBm)

                Frequencies:
                        * 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
                        * 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
                        * 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
                        * 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
                        * 5260 MHz [52] (15.0 dBm) (passive scanning, no IBSS, radar detection)
                        * 5280 MHz [56] (15.0 dBm) (passive scanning, no IBSS, radar detection)
                        * 5300 MHz [60] (15.0 dBm) (passive scanning, no IBSS, radar detection)
                        * 5320 MHz [64] (15.0 dBm) (passive scanning, no IBSS, radar detection)
                        * 5745 MHz [149] (16.0 dBm) (passive scanning, no IBSS)
                        * 5765 MHz [153] (16.0 dBm) (passive scanning, no IBSS)
                        * 5785 MHz [157] (16.0 dBm) (passive scanning, no IBSS)
                        * 5805 MHz [161] (16.0 dBm) (passive scanning, no IBSS)
                        * 5825 MHz [165] (16.0 dBm) (passive scanning, no IBSS)


I have a patch in my queue which adds a new element to ieee80211_channel but
unfortunately it cannot get merged until this is fixed. I tried to look into it
but I didn't see anything immediately obvious.

  Luis
