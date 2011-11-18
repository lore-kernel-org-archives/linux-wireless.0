Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1KRIWl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:41 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8Mfa9022797
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:41 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 51/77] iwlegacy: remove il_ieee80211_get_hw_conf
Date: Fri, 18 Nov 2011 09:22:13 +0100
Message-Id: <1321604559-10707-51-git-send-email-sgruszka@redhat.com> (sfid-20111118_092246_629019_F9141FFE)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c    |    2 +-
 drivers/net/wireless/iwlegacy/4965.c        |    2 +-
 drivers/net/wireless/iwlegacy/common.c      |    2 +-
 drivers/net/wireless/iwlegacy/iwl-helpers.h |    6 ------
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index ae60410..cd7ae58 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2759,7 +2759,7 @@ void il3945_post_associate(struct il_priv *il)
 
 	il_scan_cancel_timeout(il, 200);
 
-	conf = il_ieee80211_get_hw_conf(il->hw);
+	conf = &il->hw->conf;
 
 	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	il3945_commit_rxon(il, ctx);
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index ed2c617..6833a3c 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -2184,7 +2184,7 @@ static void il4965_post_associate(struct il_priv *il)
 
 	il_scan_cancel_timeout(il, 200);
 
-	conf = il_ieee80211_get_hw_conf(il->hw);
+	conf = &il->hw->conf;
 
 	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	il_commit_rxon(il, ctx);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 7062574..bbf674d 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -3514,7 +3514,7 @@ il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
 	u16 beacon_int;
 	struct ieee80211_vif *vif = ctx->vif;
 
-	conf = il_ieee80211_get_hw_conf(il->hw);
+	conf = &il->hw->conf;
 
 	lockdep_assert_held(&il->mutex);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-helpers.h b/drivers/net/wireless/iwlegacy/iwl-helpers.h
index 0e64003..eb5a287 100644
--- a/drivers/net/wireless/iwlegacy/iwl-helpers.h
+++ b/drivers/net/wireless/iwlegacy/iwl-helpers.h
@@ -38,12 +38,6 @@
 #define IL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
 
-static inline struct ieee80211_conf *il_ieee80211_get_hw_conf(
-	struct ieee80211_hw *hw)
-{
-	return &hw->conf;
-}
-
 /**
  * il_queue_inc_wrap - increment queue idx, wrap back to beginning
  * @idx -- current idx
-- 
1.7.1

