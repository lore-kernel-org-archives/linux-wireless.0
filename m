Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35007 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbCXMpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:45:53 -0400
Received: by laae1 with SMTP id e1so26264813laa.2
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:45:52 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v5 1/7] ath10k: allow empty ssid vdev config
Date: Tue, 24 Mar 2015 12:43:07 +0000
Message-Id: <1427200993-7550-2-git-send-email-michal.kazior@tieto.com> (sfid-20150324_134557_587420_AB02A42E)
In-Reply-To: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
References: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to reject a valid
firmware configuration combination.

Since SSID isn't known early on it might make
sense to allow driver to start vdev without SSID
and restart it later.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 --
 drivers/net/wireless/ath/ath10k/wmi.c     | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 467d88c780c7..d4804645f8c2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1518,8 +1518,6 @@ ath10k_wmi_tlv_op_gen_vdev_start(struct ath10k *ar,
 	void *ptr;
 	u32 flags = 0;
 
-	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
-		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->hidden_ssid && !arg->ssid))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 1f47636f204b..3ef41105b95c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4248,8 +4248,6 @@ ath10k_wmi_op_gen_vdev_start(struct ath10k *ar,
 	const char *cmdname;
 	u32 flags = 0;
 
-	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
-		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->hidden_ssid && !arg->ssid))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
-- 
2.1.4

