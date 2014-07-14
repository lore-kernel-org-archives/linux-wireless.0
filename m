Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42156 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaGNGvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 02:51:09 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 2/7] wil6210: export FW/HW versions through debugfs
Date: Mon, 14 Jul 2014 09:49:38 +0300
Message-ID: <1405320583-5775-3-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140714_085114_911252_77D260CC)
In-Reply-To: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index a868c5e..7435b5a 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -986,6 +986,8 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 			   &wil->secure_pcp);
 	wil_debugfs_create_ulong("status", S_IRUGO | S_IWUSR, dbg,
 				 &wil->status);
+	debugfs_create_u32("fw_version", S_IRUGO, dbg, &wil->fw_version);
+	debugfs_create_x32("hw_version", S_IRUGO, dbg, &wil->hw_version);
 
 	wil6210_debugfs_create_ISR(wil, "USER_ICR", dbg,
 				   HOSTADDR(RGF_USER_USER_ICR));
-- 
1.7.6

