Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab3FLOqQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 10:46:16 -0400
Date: Wed, 12 Jun 2013 16:48:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jake Edge <jake@lwn.net>
Subject: [PATCH 5/4] Revert "iwl4965: workaround connection regression on
 passive channel"
Message-ID: <20130612144825.GC2698@redhat.com> (sfid-20130612_164619_411986_A5E68606)
References: <1371048290-8015-1-git-send-email-sgruszka@redhat.com>
 <1371048290-8015-4-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371048290-8015-4-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit dd9c46408fdc07098333655ff27edf8cac8d9fcf.

With "iwl{4965,3495): workaround for firmware frame tx rejection"
patches we can enable IEEE80211_HW_REPORTS_TX_ACK_STATUS again.

Tested-by: Jake Edge <jake@lwn.net>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 1c44bb5..d287fd2 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5759,7 +5759,8 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
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

