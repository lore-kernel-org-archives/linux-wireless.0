Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36816 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbcK0Th7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Nov 2016 14:37:59 -0500
Received: by mail-lf0-f68.google.com with SMTP id o20so7524650lfg.3
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2016 11:37:58 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH] ath10k: fix TLV set regdomain command
Date: Sun, 27 Nov 2016 20:37:20 +0100
Message-Id: <1480275440-9919-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20161127_203802_880211_E23AEBA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a typo bug in the current implementation of
ath10k_wmi_tlv_op_gen_pdev_set_rd.
The conformance test limits are not set up properly.

The two arguments ctl2g and ctl5g were not used at all.
Instead, the regdomain arguments rd2g and rd5g were used
for the ctl settings as well.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 97b536e..f304f66 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1313,8 +1313,8 @@ static int ath10k_wmi_tlv_op_pull_echo_ev(struct ath10k *ar,
 	cmd->regd = __cpu_to_le32(rd);
 	cmd->regd_2ghz = __cpu_to_le32(rd2g);
 	cmd->regd_5ghz = __cpu_to_le32(rd5g);
-	cmd->conform_limit_2ghz = __cpu_to_le32(rd2g);
-	cmd->conform_limit_5ghz = __cpu_to_le32(rd5g);
+	cmd->conform_limit_2ghz = __cpu_to_le32(ctl2g);
+	cmd->conform_limit_5ghz = __cpu_to_le32(ctl5g);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv pdev set rd\n");
 	return skb;
-- 
1.7.9.5
