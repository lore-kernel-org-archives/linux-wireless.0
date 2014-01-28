Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:1587 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaA1QIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 11:08:52 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCHv2] ath6kl: remove useless ibss_joined notification on ibss_leave
Date: Tue, 28 Jan 2014 17:07:36 +0100
Message-Id: <1390925256-3994-1-git-send-email-antonio@meshcoding.com> (sfid-20140128_170855_787638_B4A32F74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When leaving an IBSS there is no need to send cfg80211 a
fake notification about "having joined a cell with zero
BSSID".
This operation has the only effect to create a BSS object
that is not going to be used.

Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
---

Change from v1:
- remove the correct line!

 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index eba32f5..d40a8ef 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -866,8 +866,6 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 				   "%s: ath6k not in ibss mode\n", __func__);
 			return;
 		}
-		memset(bssid, 0, ETH_ALEN);
-		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
 		return;
 	}
 
-- 
1.8.5.3

