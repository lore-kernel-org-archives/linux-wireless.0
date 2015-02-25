Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:38241 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbBYKkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 05:40:45 -0500
Received: by lbiz11 with SMTP id z11so2915191lbi.5
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 02:40:43 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix ap u-apsd cmd on qca6174 w/ wmi-tlv
Date: Wed, 25 Feb 2015 11:39:36 +0100
Message-Id: <1424860776-11668-1-git-send-email-michal.kazior@tieto.com> (sfid-20150225_114049_314180_A9C79A36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The command was truncated so the parameter value
was seen in fw as 0. This caused U-APSD enabled
stations to be misconfigured and mistreated by AP.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f34baa0..af5d858 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2032,7 +2032,7 @@ ath10k_wmi_tlv_op_gen_set_ap_ps(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 	if (!mac)
 		return ERR_PTR(-EINVAL);
 
-	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*tlv) + sizeof(*cmd));
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.8.5.3

