Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:33962 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751601Ab1KHFoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 00:44:46 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/7] mwifiex: remove unnecessary free_priv handler
Date: Mon,  7 Nov 2011 21:41:11 -0800
Message-Id: <1320730872-25619-7-git-send-email-bzhao@marvell.com> (sfid-20111108_064449_480252_261F7018)
In-Reply-To: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
References: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Cfg80211 stack allocates private area for driver use in
struct cfg80211_bss. It will be freed by stack in bss_release().
Driver don't need to worry about it.

In mwifiex driver, we use the private area just to store band
information(u8). We don't allocate memory explicitly and store
it's pointer in bss->priv. Hence we don't have any cleanup work
to do in free_priv handler. Currently we try to free the allocated
private area in free_priv handler which is not correct.

This patch removes unnecessary free_priv handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 8a3f959..c650e60 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1535,11 +1535,6 @@ done:
 	return 0;
 }
 
-static void mwifiex_free_bss_priv(struct cfg80211_bss *bss)
-{
-	kfree(bss->priv);
-}
-
 /*
  * This function handles the command response of scan.
  *
@@ -1765,7 +1760,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					      cap_info_bitmap, beacon_period,
 					      ie_buf, ie_len, rssi, GFP_KERNEL);
 				*(u8 *)bss->priv = band;
-				bss->free_priv = mwifiex_free_bss_priv;
 
 				if (priv->media_connected && !memcmp(bssid,
 					priv->curr_bss_params.bss_descriptor
-- 
1.7.0.2

