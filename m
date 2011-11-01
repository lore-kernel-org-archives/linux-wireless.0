Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56287 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1KAGoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 02:44:17 -0400
Subject: [PATCH v2 3/7] ath6kl: reset CONNECT_PEND and CONNECTED flags in
	ath6kl_cfg80211_stop()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Nov 2011 08:44:13 +0200
Message-ID: <20111101064413.6798.44046.stgit@localhost6.localdomain6> (sfid-20111101_074419_035184_FD91F80B)
In-Reply-To: <20111101064140.6798.7006.stgit@localhost6.localdomain6>
References: <20111101064140.6798.7006.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise first connection establish after cutpower suspend will
fail.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 94038cb..565cdbe 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2151,6 +2151,8 @@ void ath6kl_cfg80211_stop(struct ath6kl *ar)
 		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
 
 	vif->sme_state = SME_DISCONNECTED;
+	clear_bit(CONNECTED, &vif->flags);
+	clear_bit(CONNECT_PEND, &vif->flags);
 
 	/* disable scanning */
 	if (ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0xFFFF, 0, 0,

