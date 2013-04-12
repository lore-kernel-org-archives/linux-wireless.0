Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:37791 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632Ab3DLR7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 13:59:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Troy Kisky <troy.kisky@boundarydevices.com>,
	Doug Anderson <dianders@chromium.org>,
	Paul Stewart <pstew@chromium.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 1/2] mwifiex: fix use-after-free in beacon_ie processing
Date: Fri, 12 Apr 2013 10:34:17 -0700
Message-ID: <1365788058-22508-1-git-send-email-bzhao@marvell.com> (sfid-20130412_195940_080838_D19D4987)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

beacon_ie buffer is allocated in mwifiex_fill_new_bss_desc()
and the buffer pointer is saved in bss_desc->beacon_buf.
beacon_ie is freed before the function returns. However,
bss_desc->beacon_buf is still being accessed afterwards.

Fix it by freeing beacon_ie (bss_desc->beacon_buf) in
caller's scope.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: same as v1

 drivers/net/wireless/mwifiex/scan.c      |    8 ++++++++
 drivers/net/wireless/mwifiex/sta_ioctl.c |   14 +++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index e7f6dea..37b24e8 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1533,10 +1533,18 @@ static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
 	/* Make a copy of current BSSID descriptor */
 	memcpy(&priv->curr_bss_params.bss_descriptor, bss_desc,
 	       sizeof(priv->curr_bss_params.bss_descriptor));
+
+	/* The contents of beacon_ie will be copied to its own buffer
+	 * in mwifiex_save_curr_bcn()
+	 */
 	mwifiex_save_curr_bcn(priv);
 	spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
 
 done:
+	/* beacon_ie buffer was allocated in function
+	 * mwifiex_fill_new_bss_desc(). Free it now.
+	 */
+	kfree(bss_desc->beacon_buf);
 	kfree(bss_desc);
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index e6c9b2a..27729cf 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -140,12 +140,13 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 /*
  * This function fills bss descriptor structure using provided
  * information.
+ * beacon_ie buffer is allocated in this function. It is caller's
+ * responsibility to free the memory.
  */
 int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 			      struct cfg80211_bss *bss,
 			      struct mwifiex_bssdescriptor *bss_desc)
 {
-	int ret;
 	u8 *beacon_ie;
 	size_t beacon_ie_len;
 	struct mwifiex_bss_priv *bss_priv = (void *)bss->priv;
@@ -165,6 +166,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 
 	memcpy(bss_desc->mac_address, bss->bssid, ETH_ALEN);
 	bss_desc->rssi = bss->signal;
+	/* The caller of this function will free beacon_ie */
 	bss_desc->beacon_buf = beacon_ie;
 	bss_desc->beacon_buf_size = beacon_ie_len;
 	bss_desc->beacon_period = bss->beacon_interval;
@@ -182,10 +184,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	else
 		bss_desc->bss_mode = NL80211_IFTYPE_STATION;
 
-	ret = mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
-
-	kfree(beacon_ie);
-	return ret;
+	return mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
 }
 
 static int mwifiex_process_country_ie(struct mwifiex_private *priv,
@@ -349,6 +348,11 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 	}
 
 done:
+	/* beacon_ie buffer was allocated in function
+	 * mwifiex_fill_new_bss_desc(). Free it now.
+	 */
+	if (bss_desc)
+		kfree(bss_desc->beacon_buf);
 	kfree(bss_desc);
 	return ret;
 }
-- 
1.7.0.2

