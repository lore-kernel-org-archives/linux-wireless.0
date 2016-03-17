Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:23612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419AbcCQNDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:03:21 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/4] ieee80211: support parsing Fine Timing Measurement action frame
Date: Thu, 17 Mar 2016 15:02:53 +0200
Message-Id: <1458219775-24450-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_140325_439363_E9818ECC)
In-Reply-To: <1458219775-24450-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1458219775-24450-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add definition for Fine Timing Measurement (FTM) frame format
as defined in IEEE802.11-REVmcD5.0 section 9.6.8.33

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/linux/ieee80211.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 3b1f6ce..bf9706c 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -7,6 +7,7 @@
  * Copyright (c) 2005, Devicescape Software, Inc.
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
  * Copyright (c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright (c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1011,6 +1012,16 @@ struct ieee80211_mgmt {
 					u8 tpc_elem_length;
 					struct ieee80211_tpc_report_ie tpc;
 				} __packed tpc_report;
+				struct {
+					u8 action_code;
+					u8 dialog_token;
+					u8 follow_up;
+					u8 tod[6];
+					u8 toa[6];
+					__le16 tod_error;
+					__le16 toa_error;
+					u8 variable[0];
+				} __packed ftm;
 			} u;
 		} __packed action;
 	} u;
-- 
2.5.0

