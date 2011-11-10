Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56565 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884Ab1KJBde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/28] iwlwifi: set "echo" host command length
Date: Wed,  9 Nov 2011 16:39:21 -0800
Message-Id: <1320885571-19122-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023425_405579_378EF4B5)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"echo" host command has no data, set the length to 0

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f7b0048..f9e9170 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1434,6 +1434,7 @@ int iwl_cmd_echo_test(struct iwl_priv *priv)
 	int ret;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_ECHO,
+		.len = { 0 },
 		.flags = CMD_SYNC,
 	};
 
-- 
1.7.0.4

