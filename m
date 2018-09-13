Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38111 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbeIMTzY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 15:55:24 -0400
Received: by mail-lj1-f194.google.com with SMTP id p6-v6so4838446ljc.5
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2018 07:45:34 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 1/2] ath10k: add default value for num_peers in WMI TLV init
Date: Thu, 13 Sep 2018 16:45:05 +0200
Message-Id: <20180913144506.8272-1-erik.stromdahl@gmail.com> (sfid-20180913_164537_692435_83AEB349)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hw_params value will only be used if it was explicitly set in the
global hw_params array.

This makes it possible to have the num_peers member unset.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 2640bc389f1d..e8e4ec5443e7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1569,7 +1569,10 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 
 	cfg->num_vdevs = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
 
-	cfg->num_peers = __cpu_to_le32(ar->hw_params.num_peers);
+	if (ar->hw_params.num_peers)
+		cfg->num_peers = __cpu_to_le32(ar->hw_params.num_peers);
+	else
+		cfg->num_peers = __cpu_to_le32(TARGET_TLV_NUM_PEERS);
 	cfg->ast_skid_limit = __cpu_to_le32(ar->hw_params.ast_skid_limit);
 	cfg->num_wds_entries = __cpu_to_le32(ar->hw_params.num_wds_entries);
 
-- 
2.18.0
