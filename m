Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61109 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaDMTUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:40 -0400
Received: by mail-wi0-f180.google.com with SMTP id q5so3132437wiv.13
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:39 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/47] iwlwifi: mvm: Fix warning message when exit thermal throttling
Date: Sun, 13 Apr 2014 22:19:35 +0300
Message-Id: <1397416802-32403-20-git-send-email-egrumbach@gmail.com> (sfid-20140413_213517_494664_D469D655)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

When NIC exit thermal throttling while having minimal tx-backoff
restriction, the warning message that indicate about that state
won't show up. Fixed.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 7a99fa3..cee4e72 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -484,7 +484,8 @@ void iwl_mvm_tt_handler(struct iwl_mvm *mvm)
 		IWL_WARN(mvm,
 			 "Due to high temperature thermal throttling initiated\n");
 		tt->throttle = true;
-	} else if (tt->throttle && !tt->dynamic_smps && tt->tx_backoff == 0 &&
+	} else if (tt->throttle && !tt->dynamic_smps &&
+		   tt->tx_backoff == tt->min_backoff &&
 		   temperature <= params->tx_protection_exit) {
 		IWL_WARN(mvm,
 			 "Temperature is back to normal thermal throttling stopped\n");
-- 
1.8.3.2

