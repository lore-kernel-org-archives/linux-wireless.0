Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6806 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdJEGJg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 02:09:36 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix sending wmi cmd during the tdls teardown
Date: Thu, 5 Oct 2017 11:42:06 +0530
Message-ID: <1507183926-711-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20171005_080939_891658_CD70AC8E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@codeaurora.org>

The current firmware 10.4-3.5.1-00035 on QCA9888 supports
TDLS explicit mode, it expects WMI_TDLS_ENABLE_PASSIVE
for tdls setup and WMI_TDLS_DISABLE for tdls teardown.

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 38a97086708b..cad2e42dcef6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7870,7 +7870,8 @@ static int ath10k_wmi_10_4_op_get_vdev_subtype(struct ath10k *ar,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	if (test_bit(WMI_SERVICE_TDLS_EXPLICIT_MODE_ONLY, ar->wmi.svc_map))
+	if (test_bit(WMI_SERVICE_TDLS_EXPLICIT_MODE_ONLY, ar->wmi.svc_map) &&
+	    state == WMI_TDLS_ENABLE_ACTIVE)
 		state = WMI_TDLS_ENABLE_PASSIVE;
 
 	if (test_bit(WMI_SERVICE_TDLS_UAPSD_BUFFER_STA, ar->wmi.svc_map))
-- 
1.7.9.5
