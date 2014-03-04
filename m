Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51303 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaCDWya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 17:54:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH 6/9] rtlwifi: rtl8188ee: Fix too long disable of IRQs
Date: Tue,  4 Mar 2014 16:53:52 -0600
Message-Id: <1393973635-24799-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140304_235446_042273_CA560966)
In-Reply-To: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit f78bccd79ba3cd9d9664981b501d57bdb81ab8a4 entitled "rtlwifi:
rtl8192ce: Fix too long disable of IRQs", Olivier Langlois
<olivier@trillion01.com> fixed a problem caused by an extra long disabling
of interrupts. This patch makes the same fix for rtl8188ee.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index 6561805..bd2a26b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -1024,9 +1024,20 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 	bool rtstatus = true;
 	int err = 0;
 	u8 tmp_u1b, u1byte;
+	unsigned long flags;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Rtl8188EE hw init\n");
 	rtlpriv->rtlhal.being_init_adapter = true;
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
 
 	tmp_u1b = rtl_read_byte(rtlpriv, REG_SYS_CLKR+1);
@@ -1042,7 +1053,7 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 	if (rtstatus != true) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
 		err = 1;
-		return err;
+		goto exit;
 	}
 
 	err = rtl88e_download_fw(hw, false);
@@ -1050,8 +1061,7 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now..\n");
 		err = 1;
-		rtlhal->fw_ready = false;
-		return err;
+		goto exit;
 	} else {
 		rtlhal->fw_ready = true;
 	}
@@ -1134,10 +1144,12 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 	}
 	rtl_write_byte(rtlpriv, REG_NAV_CTRL+2,  ((30000+127)/128));
 	rtl88e_dm_init(hw);
+exit:
+	local_irq_restore(flags);
 	rtlpriv->rtlhal.being_init_adapter = false;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "end of Rtl8188EE hw init %x\n",
 		 err);
-	return 0;
+	return err;
 }
 
 static enum version_8188e _rtl88ee_read_chip_version(struct ieee80211_hw *hw)
-- 
1.8.4.5

