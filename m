Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34220 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1LMMvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 07:51:54 -0500
Subject: [PATCH v2 4/6] ath6kl: fix value of WOW_FILTER_SSID
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2011 14:51:47 +0200
Message-ID: <20111213125147.10834.47043.stgit@localhost6.localdomain6> (sfid-20111213_135156_540471_A60BD9F4)
In-Reply-To: <20111213124923.10834.20626.stgit@localhost6.localdomain6>
References: <20111213124923.10834.20626.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the firmware engineers WOW_FILTER_SSID is actually the
second bit, not the first.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 4e4f0f7..cbde79c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1808,7 +1808,7 @@ struct wmi_set_ip_cmd {
 } __packed;
 
 enum ath6kl_wow_filters {
-	WOW_FILTER_SSID			= BIT(0),
+	WOW_FILTER_SSID			= BIT(1),
 	WOW_FILTER_OPTION_MAGIC_PACKET  = BIT(2),
 	WOW_FILTER_OPTION_EAP_REQ	= BIT(3),
 	WOW_FILTER_OPTION_PATTERNS	= BIT(4),

