Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61081 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbaCDWy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 17:54:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH 5/9] rtlwifi: rtl8192se: Fix too long disable of IRQs
Date: Tue,  4 Mar 2014 16:53:51 -0600
Message-Id: <1393973635-24799-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140304_235443_641804_9DEC51A1)
In-Reply-To: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit f78bccd79ba3cd9d9664981b501d57bdb81ab8a4 entitled "rtlwifi:
rtl8192ce: Fix too long disable of IRQs", Olivier Langlois
<olivier@trillion01.com> fixed a problem caused by an extra long disabling
of interrupts. This patch makes the same fix for rtl8192se.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 7c4b39c..3015af1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -955,7 +955,7 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 tmp_byte = 0;
-
+	unsigned long flags;
 	bool rtstatus = true;
 	u8 tmp_u1b;
 	int err = false;
@@ -967,6 +967,16 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 	rtlpci->being_init_adapter = true;
 
+	/* As this function can take a very long time (up to 350 ms)
+	 * and can be called with irqs disabled, reenable the irqs
+	 * to let the other devices continue being serviced.
+	 *
+	 * It is safe doing so since our own interrupts will only be enabled
+	 * in a subsequent step.
+	 */
+	local_save_flags(flags);
+	local_irq_enable();
+
 	rtlpriv->intf_ops->disable_aspm(hw);
 
 	/* 1. MAC Initialize */
@@ -984,7 +994,8 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now... "
 			 "Please copy FW into /lib/firmware/rtlwifi\n");
-		return 1;
+		err = 1;
+		goto exit;
 	}
 
 	/* After FW download, we have to reset MAC register */
@@ -997,7 +1008,8 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	/* 3. Initialize MAC/PHY Config by MACPHY_reg.txt */
 	if (!rtl92s_phy_mac_config(hw)) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "MAC Config failed\n");
-		return rtstatus;
+		err = rtstatus;
+		goto exit;
 	}
 
 	/* because last function modify RCR, so we update
@@ -1016,7 +1028,8 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	/* 4. Initialize BB After MAC Config PHY_reg.txt, AGC_Tab.txt */
 	if (!rtl92s_phy_bb_config(hw)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "BB Config failed\n");
-		return rtstatus;
+		err = rtstatus;
+		goto exit;
 	}
 
 	/* 5. Initiailze RF RAIO_A.txt RF RAIO_B.txt */
@@ -1033,7 +1046,8 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 	if (!rtl92s_phy_rf_config(hw)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "RF Config failed\n");
-		return rtstatus;
+		err = rtstatus;
+		goto exit;
 	}
 
 	/* After read predefined TXT, we must set BB/MAC/RF
@@ -1122,8 +1136,9 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_ON);
 	rtl92s_dm_init(hw);
+exit:
+	local_irq_restore(flags);
 	rtlpci->being_init_adapter = false;
-
 	return err;
 }
 
-- 
1.8.4.5

