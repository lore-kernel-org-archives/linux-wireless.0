Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43597 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2CQTXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2012 15:23:08 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>,
	Ronald Wahl <ronald.wahl@raritan.com>
Subject: [PATCH] rtlwifi: rtl8192c: Prevent sleeping from invalid context in rtl8192cu
Date: Sat, 17 Mar 2012 14:22:50 -0500
Message-Id: <1332012170-5480-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120317_202313_299940_0A3AB636)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When driver rtl8192cu is used with the debug level set to 3 or greater,
the result is "sleeping function called from invalid context" due to
an rcu_read_lock() call in the DM refresh routine in driver rtl8192c.
This lock is not necessary as the USB driver does not use the struct
being protected, thus the lock is set only when a PCI interface is
active.

This bug is reported in https://bugzilla.kernel.org/show_bug.cgi?id=42775.

Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
Cc: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

John,

This patch was tested, and the entry at b.k.o has been marked "resolved with code fix".

Larry
---

 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index cb5535c..8646ff2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -1201,13 +1201,18 @@ static void rtl92c_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 				 "PreState = %d, CurState = %d\n",
 				 p_ra->pre_ratr_state, p_ra->ratr_state);
 
-			rcu_read_lock();
-			sta = ieee80211_find_sta(mac->vif, mac->bssid);
+			/* Only the PCI card uses sta in the update rate table
+			 * callback routine */
+			if (rtlhal->interface == INTF_PCI) {
+				rcu_read_lock();
+				sta = ieee80211_find_sta(mac->vif, mac->bssid);
+			}
 			rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
 					p_ra->ratr_state);
 
 			p_ra->pre_ratr_state = p_ra->ratr_state;
-			rcu_read_unlock();
+			if (rtlhal->interface == INTF_PCI)
+				rcu_read_unlock();
 		}
 	}
 }
-- 
1.7.7

