Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984AbaJ1GP7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 02:15:59 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 4/7] iwlwifi: remove wrong comment about alignment in iwl-fw-error-dump.h
Date: Tue, 28 Oct 2014 08:11:23 +0200
Message-Id: <1414476686-3407-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141028_071621_773710_CA98AD75)
In-Reply-To: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit d4849277f92a0bfa08a988545ea527fc8e0c9571 upstream.

The chunks of data do not need to be multipliers of 4 nor
4-bytes aligned.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index ced5ba9..9fd860f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -92,8 +92,8 @@ enum iwl_fw_error_dump_type {
 /**
  * struct iwl_fw_error_dump_data - data for one type
  * @type: %enum iwl_fw_error_dump_type
- * @len: the length starting from %data - must be a multiplier of 4.
- * @data: the data itself padded to be a multiplier of 4.
+ * @len: the length starting from %data
+ * @data: the data itself
  */
 struct iwl_fw_error_dump_data {
 	__le32 type;
-- 
1.9.1

