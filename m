Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40069 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423AbcBRHae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 02:30:34 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/24] staging: wilc1000: removes potential null dereference
Date: Thu, 18 Feb 2016 16:27:16 +0900
Message-ID: <1455780455-21365-5-git-send-email-leo.kim@atmel.com> (sfid-20160218_083042_700047_B9B574BC)
In-Reply-To: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
References: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the error reported by smatch.
 - wilc_wfi_cfgoperations.c:674 scan() error:
   potential null dereference 'strHiddenNetwork.net_info'.  (kmalloc returns null)
 - wilc_wfi_cfgoperations.c:1164 add_key() error:
   potential null dereference 'g_key_gtk_params.key'.  (kmalloc returns null)
 - wilc_wfi_cfgoperations.c:1201 add_key() error:
   potential null dereference 'g_key_ptk_params.key'.  (kmalloc returns null)

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d4705b7..ce3d0f7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -665,6 +665,8 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 		if (request->n_ssids >= 1) {
 			strHiddenNetwork.net_info = kmalloc(request->n_ssids * sizeof(struct hidden_network), GFP_KERNEL);
+			if (!strHiddenNetwork.net_info)
+				return -ENOMEM;
 			strHiddenNetwork.n_ssids = request->n_ssids;
 
 
@@ -1154,6 +1156,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_key_gtk_params.key_len = params->key_len;
 					g_key_gtk_params.seq_len = params->seq_len;
 					g_key_gtk_params.key =  kmalloc(params->key_len, GFP_KERNEL);
+					if (!g_key_gtk_params.key)
+						return -ENOMEM;
 					memcpy(g_key_gtk_params.key, params->key, params->key_len);
 					if (params->seq_len > 0) {
 						g_key_gtk_params.seq =  kmalloc(params->seq_len, GFP_KERNEL);
@@ -1191,6 +1195,8 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					g_key_ptk_params.key_len = params->key_len;
 					g_key_ptk_params.seq_len = params->seq_len;
 					g_key_ptk_params.key =  kmalloc(params->key_len, GFP_KERNEL);
+					if (!g_key_ptk_params.key)
+						return -ENOMEM;
 					memcpy(g_key_ptk_params.key, params->key, params->key_len);
 					if (params->seq_len > 0) {
 						g_key_ptk_params.seq =  kmalloc(params->seq_len, GFP_KERNEL);
-- 
1.9.1

