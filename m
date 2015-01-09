Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:33586 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbbAILOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 06:14:48 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so7350932wes.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 03:14:47 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 2/8] ath10k: allow empty ssid vdev config
Date: Fri,  9 Jan 2015 12:14:03 +0100
Message-Id: <1420802049-11962-3-git-send-email-michal.kazior@tieto.com> (sfid-20150109_121453_774893_0B886F6A)
In-Reply-To: <1420802049-11962-1-git-send-email-michal.kazior@tieto.com>
References: <1420802049-11962-1-git-send-email-michal.kazior@tieto.com>
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
index df3ddb9..ea7fe78 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1295,8 +1295,6 @@ ath10k_wmi_tlv_op_gen_vdev_start(struct ath10k *ar,
 	void *ptr;
 	u32 flags = 0;
 
-	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
-		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->hidden_ssid && !arg->ssid))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 1570feb..cf90f86 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4092,8 +4092,6 @@ ath10k_wmi_op_gen_vdev_start(struct ath10k *ar,
 	const char *cmdname;
 	u32 flags = 0;
 
-	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
-		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->hidden_ssid && !arg->ssid))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
-- 
1.8.5.3

