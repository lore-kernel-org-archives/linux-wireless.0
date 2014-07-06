Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59245 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaGFJgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:25 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so3120386wgh.35
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:24 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/40] iwlwifi: remove wrong comment about alignment in iwl-fw-error-dump.h
Date: Sun,  6 Jul 2014 12:35:38 +0300
Message-Id: <1404639376-3792-2-git-send-email-egrumbach@gmail.com> (sfid-20140706_113628_857290_6DE5BC06)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

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
1.8.3.2

