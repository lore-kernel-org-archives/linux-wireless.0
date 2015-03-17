Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34972 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbCQMdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 08:33:23 -0400
Received: by lbcgn8 with SMTP id gn8so5771138lbc.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2015 05:33:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 1/7] ath10k: allow empty ssid vdev config
Date: Tue, 17 Mar 2015 12:30:42 +0000
Message-Id: <1426595448-1630-2-git-send-email-michal.kazior@tieto.com> (sfid-20150317_133328_287908_43E89361)
In-Reply-To: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
References: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
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
index 3eec042..fa3eb1b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1486,8 +1486,6 @@ ath10k_wmi_tlv_op_gen_vdev_start(struct ath10k *ar,
 	void *ptr;
 	u32 flags = 0;
 
-	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
-		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->hidden_ssid && !arg->ssid))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 54430a1..7b3e6ca 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4286,8 +4286,6 @@ ath10k_wmi_op_gen_vdev_start(struct ath10k *ar,
 	const char *cmdname;
 	u32 flags = 0;
 
-	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
-		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->hidden_ssid && !arg->ssid))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
-- 
2.1.4

