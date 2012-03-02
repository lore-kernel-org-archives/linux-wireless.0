Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758679Ab2CBVXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:23:43 -0500
Date: Fri, 02 Mar 2012 15:23:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: ronald.wahl@raritan.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192c: Prevent sleeping from invalid context
 in rtl8192cu
Message-ID: <4f513a58.E0eEZJwAkXtCWjTf%Larry.Finger@lwfinger.net> (sfid-20120302_222350_870866_6C51E950)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
---

John,

This patch should be added to 3.3, which is why I Cc'd Stable; however,
as most people do not use the debug mode, it probably does not matter.
I'll leave it to your judgement.

Larry
---

 dm_common.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -1205,13 +1205,18 @@ static void rtl92c_dm_refresh_rate_adapt
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

