Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34669 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcFYSiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 14:38:17 -0400
Received: by mail-oi0-f68.google.com with SMTP id s17so23970698oih.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 11:38:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Andrianov <andrianov@ispras.ru>
Subject: [PATCH 4/6] rtlwifi: rtl8723be: Fix potential race condition
Date: Sat, 25 Jun 2016 13:37:45 -0500
Message-Id: <1466879867-2499-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_203830_531075_36271F33)
In-Reply-To: <1466879867-2499-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1466879867-2499-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag rfchange_inprogress in struct rtl_ps_ctl is protected by a spinlock
in most routines but not in rtl8723be_dm_watchdog(), which could
lead to a race condition. The necessary locking to prevent this condition
is added.

Reported-by: Pavel Andrianov <andrianov@ispras.ru>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pavel Andrianov <andrianov@ispras.ru>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
index 3a81cdb..9a4715ab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
@@ -1279,6 +1279,7 @@ void rtl8723be_dm_watchdog(struct ieee80211_hw *hw)
 	if (ppsc->p2p_ps_info.p2p_ps_mode)
 		fw_ps_awake = false;
 
+	spin_lock(&rtlpriv->locks.rf_ps_lock);
 	if ((ppsc->rfpwr_state == ERFON) &&
 		((!fw_current_inpsmode) && fw_ps_awake) &&
 		(!ppsc->rfchange_inprogress)) {
@@ -1294,5 +1295,6 @@ void rtl8723be_dm_watchdog(struct ieee80211_hw *hw)
 		rtl8723be_dm_check_txpower_tracking(hw);
 		rtl8723be_dm_dynamic_txpower(hw);
 	}
+	spin_unlock(&rtlpriv->locks.rf_ps_lock);
 	rtlpriv->dm.dbginfo.num_qry_beacon_pkt = 0;
 }
-- 
2.1.4

