Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17504 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752823AbdBUOcX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 09:32:23 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 05/10] wil6210: missing reinit_completion in HALP voting
Date: Tue, 21 Feb 2017 16:32:03 +0200
Message-Id: <1487687528-12832-6-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170221_153228_193348_A3481744)
In-Reply-To: <1487687528-12832-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1487687528-12832-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After setting HALP ICR bit, we keep it set until HALP unvote.
Masking HALP ICR should protect the driver from hitting the HALP ICR
over and over again. However, in case there is another MISC ICR
we will read the HALP ICR and issue a completion. This can lead to
a case where HALP voting is completed immediately, as the completion
is already set.
Reinit the HALP completion before the actual vote will clear previous
completions and protect from such cases.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 21b7fac..dddde94 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1158,6 +1158,7 @@ void wil_halp_vote(struct wil6210_priv *wil)
 		    wil->halp.ref_cnt);
 
 	if (++wil->halp.ref_cnt == 1) {
+		reinit_completion(&wil->halp.comp);
 		wil6210_set_halp(wil);
 		rc = wait_for_completion_timeout(&wil->halp.comp, to_jiffies);
 		if (!rc) {
-- 
1.9.1
