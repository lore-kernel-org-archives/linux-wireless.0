Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:60171 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0DWNFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 09:05:41 -0400
Received: by bwz25 with SMTP id 25so11181734bwz.28
        for <linux-wireless@vger.kernel.org>; Fri, 23 Apr 2010 06:05:39 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: rt2800lib: disable HT40 for now as it causes reception problems
Date: Fri, 23 Apr 2010 15:05:29 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201004231505.29689.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable HT40 support for now as it causes rx problems with HT40 capable
11n APs (when mac80211 enables HT40, rx is completely disfunctional).

Once the rt2800 HT code is capable of using HT40 we should enable the
flag again.

I only tested this patch with a rt305x SoC device, nevertheless the
patch disables HT40 also on PCI and USB rt2800 devices.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Using this patch I was able to associate a rt305x SoC device with my 11n
capable AP using WPA and the connection basically works although I see lots
of retried frames when sniffing the wireless traffic.

If someone already had success with rt2800 and HT40 capable APs we should
consider to only conditionally unset the HT40 flag for 305x SoC devices.

 drivers/net/wireless/rt2x00/rt2800lib.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2648f31..aa02ff6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2318,8 +2318,11 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	else
 		spec->ht.ht_supported = false;
 
+	/*
+	 * Don't set IEEE80211_HT_CAP_SUP_WIDTH_20_40 for now as it causes
+	 * reception problems with HT40 capable 11n APs
+	 */
 	spec->ht.cap =
-	    IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 	    IEEE80211_HT_CAP_GRN_FLD |
 	    IEEE80211_HT_CAP_SGI_20 |
 	    IEEE80211_HT_CAP_SGI_40 |
-- 
1.6.4.2

