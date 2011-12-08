Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:57287 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1LHP3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 10:29:32 -0500
Subject: [PATCH 4/6] ath6kl: fix value of WOW_FILTER_SSID
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 08 Dec 2011 17:29:25 +0200
Message-ID: <20111208152925.16924.61689.stgit@x201> (sfid-20111208_162935_654413_9B217EAB)
In-Reply-To: <20111208152824.16924.31984.stgit@x201>
References: <20111208152824.16924.31984.stgit@x201>
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

