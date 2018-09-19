Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33713 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731023AbeISLmx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:42:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 18/29] staging: wilc1000: rename 'wilc_mac_cfg' struct to 'wilc_cfg_str_vals'
Date: Wed, 19 Sep 2018 11:35:08 +0530
Message-ID: <1537337119-14952-19-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080636_024855_20B69528)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename 'wilc_mac_cfg' struct to 'wilc_cfg_str_vals' as its more
appropriate for structure to store the values of string configuration.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 14 +++++++-------
 drivers/staging/wilc1000/wilc_wlan_cfg.h |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 8f1e962..930a389 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -438,7 +438,7 @@ void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 
 int wilc_wlan_cfg_init(struct wilc *wl)
 {
-	struct wilc_mac_cfg *mac_cfg;
+	struct wilc_cfg_str_vals *str_vals;
 	int i = 0;
 
 	wl->cfg.b = kmemdup(g_cfg_byte, sizeof(g_cfg_byte), GFP_KERNEL);
@@ -457,20 +457,20 @@ int wilc_wlan_cfg_init(struct wilc *wl)
 	if (!wl->cfg.s)
 		goto out_w;
 
-	mac_cfg = kzalloc(sizeof(mac_cfg), GFP_KERNEL);
-	if (!mac_cfg)
+	str_vals = kzalloc(sizeof(str_vals), GFP_KERNEL);
+	if (!str_vals)
 		goto out_s;
 
-	wl->cfg.str_vals = mac_cfg;
+	wl->cfg.str_vals = str_vals;
 	/* store the string cfg parameters */
 	wl->cfg.s[i].id = WID_FIRMWARE_VERSION;
-	wl->cfg.s[i].str = mac_cfg->firmware_version;
+	wl->cfg.s[i].str = str_vals->firmware_version;
 	i++;
 	wl->cfg.s[i].id = WID_MAC_ADDR;
-	wl->cfg.s[i].str = mac_cfg->mac_address;
+	wl->cfg.s[i].str = str_vals->mac_address;
 	i++;
 	wl->cfg.s[i].id = WID_ASSOC_RES_INFO;
-	wl->cfg.s[i].str = mac_cfg->assoc_rsp;
+	wl->cfg.s[i].str = str_vals->assoc_rsp;
 	i++;
 	wl->cfg.s[i].id = WID_NIL;
 	wl->cfg.s[i].str = NULL;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 176eef1..e5ca6ce 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -27,7 +27,7 @@ struct wilc_cfg_str {
 	u8 *str;
 };
 
-struct wilc_mac_cfg {
+struct wilc_cfg_str_vals {
 	u8 mac_address[7];
 	u8 firmware_version[129];
 	u8 assoc_rsp[256];
@@ -38,7 +38,7 @@ struct wilc_cfg {
 	struct wilc_cfg_hword *hw;
 	struct wilc_cfg_word *w;
 	struct wilc_cfg_str *s;
-	struct wilc_mac_cfg *str_vals;
+	struct wilc_cfg_str_vals *str_vals;
 };
 
 struct wilc;
-- 
2.7.4
