Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759351Ab2COKm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 06:42:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlegacy: fix BSSID setting
Date: Thu, 15 Mar 2012 11:42:49 +0100
Message-Id: <1331808169-2378-1-git-send-email-sgruszka@redhat.com> (sfid-20120315_114302_640316_202FACB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current commit 0775f9f90cdaf40fbf69b3192b3dddb2b3436f45
"mac80211: remove spurious BSSID change flag" exposed bug on iwlegacy,
that we do not set BSSID address correctly and then device was not able
to receive frames after successful associate.

On the way fix scan canceling comment. Apparently ->post_associate()
do cancel scan itself, but scan cancel on BSS_CHANGED_BSSID is needed.
I'm not sure why, but when I removed it, I had frequent auth failures:

 wlan4: send auth to 54:e6:fc:98:63:fe (try 1/3)
 wlan4: send auth to 54:e6:fc:98:63:fe (try 2/3)
 wlan4: send auth to 54:e6:fc:98:63:fe (try 3/3)
 wlan4: authentication with 54:e6:fc:98:63:fe timed out

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index e5ac047..f420928 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -5279,9 +5279,9 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		D_MAC80211("BSSID %pM\n", bss_conf->bssid);
 
 		/*
-		 * If there is currently a HW scan going on in the
-		 * background then we need to cancel it else the RXON
-		 * below/in post_associate will fail.
+		 * If there is currently a HW scan going on in the background,
+		 * then we need to cancel it, otherwise sometimes we are not
+		 * able to authenticate (FIXME: why ?)
 		 */
 		if (il_scan_cancel_timeout(il, 100)) {
 			D_MAC80211("leave - scan abort failed\n");
@@ -5290,14 +5290,10 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		}
 
 		/* mac80211 only sets assoc when in STATION mode */
-		if (vif->type == NL80211_IFTYPE_ADHOC || bss_conf->assoc) {
-			memcpy(il->staging.bssid_addr, bss_conf->bssid,
-			       ETH_ALEN);
+		memcpy(il->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
 
-			/* currently needed in a few places */
-			memcpy(il->bssid, bss_conf->bssid, ETH_ALEN);
-		} else
-			il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		/* FIXME: currently needed in a few places */
+		memcpy(il->bssid, bss_conf->bssid, ETH_ALEN);
 	}
 
 	/*
-- 
1.7.4.4

