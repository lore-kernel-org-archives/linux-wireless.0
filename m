Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35307 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbcFYSiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 14:38:16 -0400
Received: by mail-oi0-f66.google.com with SMTP id d132so23953065oig.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 11:38:16 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Andrianov <andrianov@ispras.ru>
Subject: [PATCH 3/6] rtlwifi: rtl8192ee: Fix potential race condition
Date: Sat, 25 Jun 2016 13:37:44 -0500
Message-Id: <1466879867-2499-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_203829_178548_7B0E1EAE)
In-Reply-To: <1466879867-2499-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1466879867-2499-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag rfchange_inprogress in struct rtl_ps_ctl is protected by a spinlock
in most routines but not in rtl92ee_dm_watchdog(), which could
lead to a race condition. The necessary locking to prevent this condition
is added.

Reported-by: Pavel Andrianov <andrianov@ispras.ru>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pavel Andrianov <andrianov@ispras.ru>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
index 459f3d0..46efba0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
@@ -1219,6 +1219,7 @@ void rtl92ee_dm_watchdog(struct ieee80211_hw *hw)
 	if (ppsc->p2p_ps_info.p2p_ps_mode)
 		fw_ps_awake = false;
 
+	spin_lock(&rtlpriv->locks.rf_ps_lock);
 	if ((ppsc->rfpwr_state == ERFON) &&
 	    ((!fw_current_inpsmode) && fw_ps_awake) &&
 	    (!ppsc->rfchange_inprogress)) {
@@ -1233,4 +1234,5 @@ void rtl92ee_dm_watchdog(struct ieee80211_hw *hw)
 		rtl92ee_dm_dynamic_atc_switch(hw);
 		rtl92ee_dm_dynamic_primary_cca_ckeck(hw);
 	}
+	spin_unlock(&rtlpriv->locks.rf_ps_lock);
 }
-- 
2.1.4

