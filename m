Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569AbZAHSSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/11] iwl3945: remove double defined 3945 tfd structures
Date: Thu,  8 Jan 2009 10:19:56 -0800
Message-Id: <1231438802-10991-6-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191840_222699_17104757)
In-Reply-To: <1231438802-10991-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-4-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch removes doubly defined struct iwl3945_tfd_frame_data
and struct iwl3945_tfd_frame.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 313b03b..a72aa1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -478,18 +478,6 @@ struct iwl_tfd {
 	__le32 __pad;
 } __attribute__ ((packed));
 
-struct iwl3945_tfd_frame_data {
-	__le32 addr;
-	__le32 len;
-} __attribute__ ((packed));
-
-struct iwl3945_tfd_frame {
-	__le32 control_flags;
-	struct iwl3945_tfd_frame_data pa[4];
-	u8 reserved[28];
-} __attribute__ ((packed));
-
-
 /* Keep Warm Size */
 #define IWL_KW_SIZE 0x1000	/* 4k */
 
-- 
1.5.4.3

