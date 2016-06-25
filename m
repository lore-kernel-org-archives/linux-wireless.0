Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33506 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbcFYSiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 14:38:19 -0400
Received: by mail-oi0-f68.google.com with SMTP id w141so24017518oia.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 11:38:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Andrianov <andrianov@ispras.ru>
Subject: [PATCH 6/6] rtlwifi: rtl8821ae: Fix potential race condition
Date: Sat, 25 Jun 2016 13:37:47 -0500
Message-Id: <1466879867-2499-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_203828_460249_126E02C8)
In-Reply-To: <1466879867-2499-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1466879867-2499-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag rfchange_inprogress in struct rtl_ps_ctl is protected by a spinlock
in most routines but not in rtl8821ae_dm_watchdog() which could
lead to a race condition. The necessary locking to prevent this condition
is added.

Reported-by: Pavel Andrianov <andrianov@ispras.ru>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pavel Andrianov <andrianov@ispras.ru>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index 17a6817..35c6f8a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -2949,6 +2949,7 @@ void rtl8821ae_dm_watchdog(struct ieee80211_hw *hw)
 	if (ppsc->p2p_ps_info.p2p_ps_mode)
 		fw_ps_awake = false;
 
+	spin_lock(&rtlpriv->locks.rf_ps_lock);
 	if ((ppsc->rfpwr_state == ERFON) &&
 	    ((!fw_current_inpsmode) && fw_ps_awake) &&
 	    (!ppsc->rfchange_inprogress)) {
@@ -2967,6 +2968,7 @@ void rtl8821ae_dm_watchdog(struct ieee80211_hw *hw)
 			rtl8821ae_dm_check_txpower_tracking_thermalmeter(hw);
 		rtl8821ae_dm_iq_calibrate(hw);
 	}
+	spin_unlock(&rtlpriv->locks.rf_ps_lock);
 
 	rtlpriv->dm.dbginfo.num_qry_beacon_pkt = 0;
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_DMESG, "\n");
-- 
2.1.4

