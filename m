Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:36018 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbbHEEzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 00:55:08 -0400
Received: by labgo9 with SMTP id go9so20902205lab.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2015 21:55:05 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: initialize fw_features var
Date: Wed,  5 Aug 2015 06:55:37 +0200
Message-Id: <1438750537-27781-1-git-send-email-michal.kazior@tieto.com> (sfid-20150805_065513_864860_7C3DE49F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If firmware did not have any feature flags set the
var would be left with values found on the stack
(i.e. garbage) yielding print string like this:

  (...) features \xffffffa6m:^R\xfffffffbԂ\xffffffc4^E

Fixes: b27bc5a40f91 ("ath10k: dump fw features during probing")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 1a33bf04b7b7..f7aa1c73b481 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(ath10k_info);
 
 void ath10k_print_driver_info(struct ath10k *ar)
 {
-	char fw_features[128];
+	char fw_features[128] = {};
 
 	ath10k_core_get_fw_features_str(ar, fw_features, sizeof(fw_features));
 
-- 
2.1.4

