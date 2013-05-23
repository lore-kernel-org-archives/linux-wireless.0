Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106Ab3EWMT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 08:19:56 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jake Edge <jake@lwn.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFT/RFC 4/4] Revert "iwl4965: workaround connection regression on passive channel"
Date: Thu, 23 May 2013 14:21:00 +0200
Message-Id: <1369311660-15378-5-git-send-email-sgruszka@redhat.com> (sfid-20130523_141958_645085_3AF22DBC)
In-Reply-To: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit dd9c46408fdc07098333655ff27edf8cac8d9fcf.
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 72b8c4e..b083502 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5760,7 +5760,8 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	hw->flags =
 	    IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_AMPDU_AGGREGATION |
 	    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC | IEEE80211_HW_SPECTRUM_MGMT |
-	    IEEE80211_HW_SUPPORTS_PS | IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | IEEE80211_HW_SUPPORTS_PS |
+	    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 	if (il->cfg->sku & IL_SKU_N)
 		hw->flags |=
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-- 
1.7.11.7

