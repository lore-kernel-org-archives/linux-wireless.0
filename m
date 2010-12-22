Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62281 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab0LVO2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:28:47 -0500
Received: by wwi17 with SMTP id 17so5127759wwi.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:28:46 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 18/18] wl1271: Enable AP-mode
Date: Wed, 22 Dec 2010 16:27:37 +0200
Message-Id: <1293028057-6212-19-git-send-email-arik@wizery.com>
In-Reply-To: <1293028057-6212-1-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indicate support for the NL80211_IFTYPE_AP interface mode to enable AP
mode operation.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a9f95c6..ee5b262 100644
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
@@ -3097,7 +3100,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 	wl->hw->wiphy->max_scan_ssids = 1;
 	/*
 	 * Maximum length of elements in scanning probe request templates
-- 
1.7.1

