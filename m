Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:48531 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaGVT1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:17 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so111981wev.41
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:16 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/20] iwlwifi: mvm: fix wrong offset while reading from NVM
Date: Tue, 22 Jul 2014 22:26:36 +0300
Message-Id: <1406057211-31752-5-git-send-email-egrumbach@gmail.com> (sfid-20140722_212730_312454_D6CAC7C1)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

As part of thermal throttling, some data is being read from NVM.
The offset is in words, but was addressed as in octets. fixed.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 8685615..0c4ff3a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -140,9 +140,9 @@ static u16 iwl_mvm_dts_get_ptat_deviation_offset(struct iwl_mvm *mvm)
 
 	/* TODO: move parsing to NVM code */
 	calib = mvm->nvm_sections[NVM_SECTION_TYPE_CALIBRATION].data;
-	ptat = calib[OTP_DTS_DIODE_DEVIATION];
-	pa1 = calib[OTP_DTS_DIODE_DEVIATION + 1];
-	pa2 = calib[OTP_DTS_DIODE_DEVIATION + 2];
+	ptat = calib[OTP_DTS_DIODE_DEVIATION * 2];
+	pa1 = calib[OTP_DTS_DIODE_DEVIATION * 2 + 1];
+	pa2 = calib[OTP_DTS_DIODE_DEVIATION * 2 + 2];
 
 	/* get the median: */
 	if (ptat > pa1) {
-- 
1.8.3.2

