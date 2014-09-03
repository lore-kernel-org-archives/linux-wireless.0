Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:48130 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbaICT5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:04 -0400
Received: by mail-we0-f171.google.com with SMTP id u56so9223008wes.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:03 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/36] iwlwifi: don't export tracepoints unnecessarily
Date: Wed,  3 Sep 2014 22:56:11 +0300
Message-Id: <1409774184-24665-23-git-send-email-egrumbach@gmail.com> (sfid-20140903_215803_298114_C3E7ADD1)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The tracepoints that are only used in code linked with iwlwifi.ko,
as are the tracepoints, don't need to be exported, so don't.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index 23e7351..90987d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -36,15 +36,8 @@
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite8);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ioread32);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite32);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_rx);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_tx);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_event);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_error);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_cont_event);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_wrap_event);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_info);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_warn);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_crit);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_err);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dbg);
 #endif
-- 
1.9.1

