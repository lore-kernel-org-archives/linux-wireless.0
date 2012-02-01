Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15093 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2BAJEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 04:04:21 -0500
From: Chilam Ng <chilamng@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: initialize the 'nominal_phy' field in the 'wmi_create_pstream_cmd' struct for create_qos command
Date: Wed, 1 Feb 2012 01:03:37 -0800
Message-ID: <1328087017-6283-1-git-send-email-chilamng@qca.qualcomm.com> (sfid-20120201_100428_881187_30A9532B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nominal_phy field is uninitialized. Initialize it to min_phy_rate for create_qos

Signed-off-by: Chilam Ng <chilamng@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 6b546dc..c066c29 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1441,6 +1441,8 @@ static ssize_t ath6kl_create_qos_write(struct file *file,
 		return -EINVAL;
 	pstream.medium_time = cpu_to_le32(val32);
 
+	pstream.nominal_phy = ((le32_to_cpu(pstream.min_phy_rate) / 1000) / 1000);
+
 	ath6kl_wmi_create_pstream_cmd(ar->wmi, vif->fw_vif_idx, &pstream);
 
 	return count;
-- 
1.7.7.2

