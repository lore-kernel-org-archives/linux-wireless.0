Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53087 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab0L1Rhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:37:45 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so4306524eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:37:44 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 18/18] wl1271: Enable AP-mode
Date: Tue, 28 Dec 2010 19:36:48 +0200
Message-Id: <1293557808-27068-19-git-send-email-arik@wizery.com>
In-Reply-To: <1293557808-27068-1-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indicate support for the NL80211_IFTYPE_AP interface mode to enable AP
mode operation.

Disable 11a when operating in AP-mode (unsupported for now).

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c |    4 +++-
 drivers/net/wireless/wl12xx/main.c |    5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index b2f0f64..f2a3513 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -233,7 +233,9 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	 */
 	if (wl->nvs_len == sizeof(struct wl1271_nvs_file) ||
 	    wl->nvs_len == WL1271_INI_LEGACY_NVS_FILE_SIZE) {
-		if (wl->nvs->general_params.dual_mode_select)
+		/* for now 11a is unsupported in AP mode */
+		if (wl->bss_type != BSS_TYPE_AP_BSS &&
+		    wl->nvs->general_params.dual_mode_select)
 			wl->enable_11a = true;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ed06aee..5bd6879 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1073,6 +1073,9 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		wl->bss_type = BSS_TYPE_IBSS;
 		wl->set_bss_type = BSS_TYPE_STA_BSS;
 		break;
+	case NL80211_IFTYPE_AP:
+		wl->bss_type = BSS_TYPE_AP_BSS;
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		goto out;
@@ -3136,7 +3139,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 	wl->hw->wiphy->max_scan_ssids = 1;
 	/*
 	 * Maximum length of elements in scanning probe request templates
-- 
1.7.1

