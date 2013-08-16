Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3HPLHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 10/20] iwlwifi: mvm: remove unused fields of iwl_rs_rate_info
Date: Fri, 16 Aug 2013 13:07:00 +0200
Message-Id: <1376651230-1060-10-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130729_718780_697FBE74)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Some more cleanups of unused fields and their initializations.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 37 +++++++++++++++--------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h | 22 ---------------------
 2 files changed, 16 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 199f0cf..a69bd4c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -82,41 +82,36 @@ static const u8 ant_toggle_lookup[] = {
 	[ANT_ABC] = ANT_ABC,
 };
 
-#define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
+#define IWL_DECLARE_RATE_INFO(r, s, rp, rn)		       \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
 				    IWL_RATE_SISO_##s##M_PLCP, \
 				    IWL_RATE_MIMO2_##s##M_PLCP,\
 				    IWL_RATE_MIMO3_##s##M_PLCP,\
-				    IWL_RATE_##r##M_IEEE,      \
-				    IWL_RATE_##ip##M_INDEX,    \
-				    IWL_RATE_##in##M_INDEX,    \
 				    IWL_RATE_##rp##M_INDEX,    \
-				    IWL_RATE_##rn##M_INDEX,    \
-				    IWL_RATE_##pp##M_INDEX,    \
-				    IWL_RATE_##np##M_INDEX }
+				    IWL_RATE_##rn##M_INDEX }
 
 /*
  * Parameter order:
- *   rate, ht rate, prev rate, next rate, prev tgg rate, next tgg rate
+ *   rate, ht rate, prev rate, next rate
  *
  * If there isn't a valid next or previous rate then INV is used which
  * maps to IWL_RATE_INVALID
  *
  */
 static const struct iwl_rs_rate_info iwl_rates[IWL_RATE_COUNT] = {
-	IWL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),    /*  1mbps */
-	IWL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),          /*  2mbps */
-	IWL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
-	IWL_DECLARE_RATE_INFO(11, INV, 9, 12, 9, 12, 5, 18),      /* 11mbps */
-	IWL_DECLARE_RATE_INFO(6, 6, 5, 9, 5, 11, 5, 11),        /*  6mbps */
-	IWL_DECLARE_RATE_INFO(9, 6, 6, 11, 6, 11, 5, 11),       /*  9mbps */
-	IWL_DECLARE_RATE_INFO(12, 12, 11, 18, 11, 18, 11, 18),   /* 12mbps */
-	IWL_DECLARE_RATE_INFO(18, 18, 12, 24, 12, 24, 11, 24),   /* 18mbps */
-	IWL_DECLARE_RATE_INFO(24, 24, 18, 36, 18, 36, 18, 36),   /* 24mbps */
-	IWL_DECLARE_RATE_INFO(36, 36, 24, 48, 24, 48, 24, 48),   /* 36mbps */
-	IWL_DECLARE_RATE_INFO(48, 48, 36, 54, 36, 54, 36, 54),   /* 48mbps */
-	IWL_DECLARE_RATE_INFO(54, 54, 48, INV, 48, INV, 48, INV),/* 54mbps */
-	IWL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
+	IWL_DECLARE_RATE_INFO(1, INV, INV, 2),   /*  1mbps */
+	IWL_DECLARE_RATE_INFO(2, INV, 1, 5),     /*  2mbps */
+	IWL_DECLARE_RATE_INFO(5, INV, 2, 11),    /*5.5mbps */
+	IWL_DECLARE_RATE_INFO(11, INV, 9, 12),   /* 11mbps */
+	IWL_DECLARE_RATE_INFO(6, 6, 5, 11),      /*  6mbps */
+	IWL_DECLARE_RATE_INFO(9, 6, 6, 11),      /*  9mbps */
+	IWL_DECLARE_RATE_INFO(12, 12, 11, 18),   /* 12mbps */
+	IWL_DECLARE_RATE_INFO(18, 18, 12, 24),   /* 18mbps */
+	IWL_DECLARE_RATE_INFO(24, 24, 18, 36),   /* 24mbps */
+	IWL_DECLARE_RATE_INFO(36, 36, 24, 48),   /* 36mbps */
+	IWL_DECLARE_RATE_INFO(48, 48, 36, 54),   /* 48mbps */
+	IWL_DECLARE_RATE_INFO(54, 54, 48, INV),  /* 54mbps */
+	IWL_DECLARE_RATE_INFO(60, 60, 48, INV),  /* 60mbps */
 	/* FIXME:RS:          ^^    should be INV (legacy) */
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 917a48f..9ac7c0b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -39,13 +39,8 @@ struct iwl_rs_rate_info {
 	u8 plcp_siso;	/* uCode API:  IWL_RATE_SISO_6M_PLCP, etc. */
 	u8 plcp_mimo2;	/* uCode API:  IWL_RATE_MIMO2_6M_PLCP, etc. */
 	u8 plcp_mimo3;  /* uCode API:  IWL_RATE_MIMO3_6M_PLCP, etc. */
-	u8 ieee;	/* MAC header:  IWL_RATE_6M_IEEE, etc. */
-	u8 prev_ieee;    /* previous rate in IEEE speeds */
-	u8 next_ieee;    /* next rate in IEEE speeds */
 	u8 prev_rs;      /* previous rate used in rs algo */
 	u8 next_rs;      /* next rate used in rs algo */
-	u8 prev_rs_tgg;  /* previous rate used in TGG rs algo */
-	u8 next_rs_tgg;  /* next rate used in TGG rs algo */
 };
 
 #define IWL_RATE_60M_PLCP 3
@@ -120,23 +115,6 @@ enum {
 	IWL_RATE_MIMO3_INVM_PLCP = IWL_RATE_SISO_INVM_PLCP,
 };
 
-/* MAC header values for bit rates */
-enum {
-	IWL_RATE_6M_IEEE  = 12,
-	IWL_RATE_9M_IEEE  = 18,
-	IWL_RATE_12M_IEEE = 24,
-	IWL_RATE_18M_IEEE = 36,
-	IWL_RATE_24M_IEEE = 48,
-	IWL_RATE_36M_IEEE = 72,
-	IWL_RATE_48M_IEEE = 96,
-	IWL_RATE_54M_IEEE = 108,
-	IWL_RATE_60M_IEEE = 120,
-	IWL_RATE_1M_IEEE  = 2,
-	IWL_RATE_2M_IEEE  = 4,
-	IWL_RATE_5M_IEEE  = 11,
-	IWL_RATE_11M_IEEE = 22,
-};
-
 #define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
 
 #define IWL_INVALID_VALUE    -1
-- 
1.8.4.rc2

