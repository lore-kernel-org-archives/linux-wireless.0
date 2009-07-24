Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23615 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbZGXSNS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/14] iwlagn: fix null pointer access during ucode load on 1000
Date: Fri, 24 Jul 2009 11:13:12 -0700
Message-Id: <1248459194-10239-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Commit "iwlwifi: Handle new firmware file with ucode build number
in header" introduced new ucode header parsing routines, but
neglected to initialize these routines for 1000. The system thus goes
into infinite loop trying to load ucode, failing every time with a null
pointer exception as it tries to parse the header.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 80a2818..5f7c520 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -124,6 +124,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 };
 
 static struct iwl_ops iwl1000_ops = {
+	.ucode = &iwl5000_ucode,
 	.lib = &iwl1000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
-- 
1.5.6.3

