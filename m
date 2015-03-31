Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:32787 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbbCaKdE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 06:33:04 -0400
Received: by lajy8 with SMTP id y8so9215384laj.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 03:33:03 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v6 1/7] ath10k: allow empty ssid vdev config
Date: Tue, 31 Mar 2015 10:26:20 +0000
Message-Id: <1427797586-5132-2-git-send-email-michal.kazior@tieto.com> (sfid-20150331_123310_434569_D9DCFC20)
In-Reply-To: <1427797586-5132-1-git-send-email-michal.kazior@tieto.com>
References: <1427797586-5132-1-git-send-email-michal.kazior@tieto.com>
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
index 7bfb45492027..ac3b4fd5b752 100644
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
index 4778031b8635..da2fc1d99291 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4244,8 +4244,6 @@ ath10k_wmi_op_gen_vdev_start(struct ath10k *ar,
 	const char *cmdname;
 	u32 flags = 0;
 
-	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
-		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->hidden_ssid && !arg->ssid))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
-- 
2.1.4

