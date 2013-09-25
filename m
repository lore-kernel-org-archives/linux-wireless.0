Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54073 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3IYR6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 13:58:16 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 7/8 V4] rtlwifi: rtl8188ee: Fix smatch warning in rtl8188ee/hw.c
Date: Wed, 25 Sep 2013 12:57:48 -0500
Message-Id: <1380131869-19185-8-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130925_224501_694349_EB936F0F)
In-Reply-To: <1380131869-19185-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1380131869-19185-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch lists the following:
  CHECK   drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
drivers/net/wireless/rtlwifi/rtl8188ee/hw.c:149 _rtl88ee_set_fw_clock_on() info: ignoring unreachable code.
drivers/net/wireless/rtlwifi/rtl8188ee/hw.c:149 _rtl88ee_set_fw_clock_on() info: ignoring unreachable code.

This info message is the result of a real error due to a missing break statement
in a "while (1)" loop.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> [3.10+]
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index b68cae3..e06971b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -143,6 +143,7 @@ static void _rtl88ee_set_fw_clock_on(struct ieee80211_hw *hw,
 		} else {
 			rtlhal->fw_clk_change_in_progress = false;
 			spin_unlock_bh(&rtlpriv->locks.fw_ps_lock);
+			break;
 		}
 	}
 
-- 
1.8.1.4

