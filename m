Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:35252 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab3DLRj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 13:39:59 -0400
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
Subject: [PATCH v2 2/2] mwifiex: remove redundant initialization for bss_descriptor
Date: Fri, 12 Apr 2013 10:34:18 -0700
Message-ID: <1365788058-22508-2-git-send-email-bzhao@marvell.com> (sfid-20130412_194030_131476_0C52F1D1)
In-Reply-To: <1365788058-22508-1-git-send-email-bzhao@marvell.com>
References: <1365788058-22508-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialization of bss_descriptor is unnecessary as the entire
structure will be overwritten by a memcpy followed by.

Initialize disable_11ac flag properly by setting it to true in
mwifiex_fill_new_bss_desc().

Reported-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
v2: Initialize disable_11ac properly (Troy Kisky troy.kisky@boundarydevices.com)

 drivers/net/wireless/mwifiex/scan.c      |   29 -----------------------------
 drivers/net/wireless/mwifiex/sta_ioctl.c |    5 +++++
 2 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 37b24e8..9cf5d8f 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1500,36 +1500,7 @@ static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
 	if (ret)
 		goto done;
 
-	/* Update current bss descriptor parameters */
 	spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
-	priv->curr_bss_params.bss_descriptor.bcn_wpa_ie = NULL;
-	priv->curr_bss_params.bss_descriptor.wpa_offset = 0;
-	priv->curr_bss_params.bss_descriptor.bcn_rsn_ie = NULL;
-	priv->curr_bss_params.bss_descriptor.rsn_offset = 0;
-	priv->curr_bss_params.bss_descriptor.bcn_wapi_ie = NULL;
-	priv->curr_bss_params.bss_descriptor.wapi_offset = 0;
-	priv->curr_bss_params.bss_descriptor.bcn_ht_cap = NULL;
-	priv->curr_bss_params.bss_descriptor.ht_cap_offset = 0;
-	priv->curr_bss_params.bss_descriptor.bcn_ht_oper = NULL;
-	priv->curr_bss_params.bss_descriptor.ht_info_offset = 0;
-	priv->curr_bss_params.bss_descriptor.bcn_bss_co_2040 = NULL;
-	priv->curr_bss_params.bss_descriptor.bss_co_2040_offset = 0;
-	priv->curr_bss_params.bss_descriptor.bcn_ext_cap = NULL;
-	priv->curr_bss_params.bss_descriptor.ext_cap_offset = 0;
-	priv->curr_bss_params.bss_descriptor.beacon_buf = NULL;
-	priv->curr_bss_params.bss_descriptor.beacon_buf_size = 0;
-	priv->curr_bss_params.bss_descriptor.bcn_vht_cap = NULL;
-	priv->curr_bss_params.bss_descriptor.vht_cap_offset = 0;
-	priv->curr_bss_params.bss_descriptor.bcn_vht_oper = NULL;
-	priv->curr_bss_params.bss_descriptor.vht_info_offset = 0;
-	priv->curr_bss_params.bss_descriptor.oper_mode = NULL;
-	priv->curr_bss_params.bss_descriptor.oper_mode_offset = 0;
-
-	/* Disable 11ac by default. Enable it only where there
-	 * exist VHT_CAP IE in AP beacon
-	 */
-	priv->curr_bss_params.bss_descriptor.disable_11ac = true;
-
 	/* Make a copy of current BSSID descriptor */
 	memcpy(&priv->curr_bss_params.bss_descriptor, bss_desc,
 	       sizeof(priv->curr_bss_params.bss_descriptor));
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 27729cf..311d0b2 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -184,6 +184,11 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	else
 		bss_desc->bss_mode = NL80211_IFTYPE_STATION;
 
+	/* Disable 11ac by default. Enable it only where there
+	 * exist VHT_CAP IE in AP beacon
+	 */
+	bss_desc->disable_11ac = true;
+
 	return mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
 }
 
-- 
1.7.0.2

