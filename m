Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49407 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaCROqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:25 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so4776914eek.35
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:24 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/35] iwlwifi: mvm: don't fail completely if led mode is not supported
Date: Tue, 18 Mar 2014 16:45:26 +0200
Message-Id: <1395153939-23897-22-git-send-email-egrumbach@gmail.com> (sfid-20140318_154819_008583_30D50A3A)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Blink led mode is not supported by iwlmvm. This doesn't mean
that we should prevent any operation if it is selected by
the user.
Instead of failing without any notice to the user, fallback
to the default mode (RF mode) if the blink mode
is selected and print an error to inform the user.

Reported-by: Steven Haigh <netwiz@crc.id.au>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/led.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/led.c b/drivers/net/wireless/iwlwifi/mvm/led.c
index 6b4ea6b..e3b3cf4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/iwlwifi/mvm/led.c
@@ -94,6 +94,8 @@ int iwl_mvm_leds_init(struct iwl_mvm *mvm)
 	int ret;
 
 	switch (mode) {
+	case IWL_LED_BLINK:
+		IWL_ERR(mvm, "Blink led mode not supported, used default\n");
 	case IWL_LED_DEFAULT:
 	case IWL_LED_RF_STATE:
 		mode = IWL_LED_RF_STATE;
-- 
1.8.3.2

