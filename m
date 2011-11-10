Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46218 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935471Ab1KJPtk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:40 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 18/27] iwlwifi: set "echo" host command length
Date: Thu, 10 Nov 2011 06:55:18 -0800
Message-Id: <1320936927-9078-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_165038_839442_0E44D104)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
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

