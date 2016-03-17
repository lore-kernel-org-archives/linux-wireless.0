Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:33383 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966640AbcCQSlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:16 -0400
Received: by mail-ob0-f193.google.com with SMTP id z10so5779440obg.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:15 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/9] rtlwifi: Fix Smatch warnings
Date: Thu, 17 Mar 2016 13:40:56 -0500
Message-Id: <1458240064-31422-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194120_029097_A419208D)
In-Reply-To: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch reports the following:

  CHECK   drivers/net/wireless/realtek/rtlwifi/pci.c
drivers/net/wireless/realtek/rtlwifi/pci.c:366 rtl_pci_check_buddy_priv() error: we previously assumed 'tpriv' could be null (see line 368)
drivers/net/wireless/realtek/rtlwifi/pci.c:1216 _rtl_pci_init_struct() warn: inconsistent indenting

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 39 +++++++++++++++---------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 283d608..1ac41b8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -359,30 +359,28 @@ static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	bool find_buddy_priv = false;
-	struct rtl_priv *tpriv = NULL;
+	struct rtl_priv *tpriv;
 	struct rtl_pci_priv *tpcipriv = NULL;
 
 	if (!list_empty(&rtlpriv->glb_var->glb_priv_list)) {
 		list_for_each_entry(tpriv, &rtlpriv->glb_var->glb_priv_list,
 				    list) {
-			if (tpriv) {
-				tpcipriv = (struct rtl_pci_priv *)tpriv->priv;
-				RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-					 "pcipriv->ndis_adapter.funcnumber %x\n",
-					pcipriv->ndis_adapter.funcnumber);
-				RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-					 "tpcipriv->ndis_adapter.funcnumber %x\n",
-					tpcipriv->ndis_adapter.funcnumber);
-
-				if ((pcipriv->ndis_adapter.busnumber ==
-				     tpcipriv->ndis_adapter.busnumber) &&
-				    (pcipriv->ndis_adapter.devnumber ==
-				    tpcipriv->ndis_adapter.devnumber) &&
-				    (pcipriv->ndis_adapter.funcnumber !=
-				    tpcipriv->ndis_adapter.funcnumber)) {
-					find_buddy_priv = true;
-					break;
-				}
+			tpcipriv = (struct rtl_pci_priv *)tpriv->priv;
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+				 "pcipriv->ndis_adapter.funcnumber %x\n",
+				pcipriv->ndis_adapter.funcnumber);
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+				 "tpcipriv->ndis_adapter.funcnumber %x\n",
+				tpcipriv->ndis_adapter.funcnumber);
+
+			if ((pcipriv->ndis_adapter.busnumber ==
+			     tpcipriv->ndis_adapter.busnumber) &&
+			    (pcipriv->ndis_adapter.devnumber ==
+			    tpcipriv->ndis_adapter.devnumber) &&
+			    (pcipriv->ndis_adapter.funcnumber !=
+			    tpcipriv->ndis_adapter.funcnumber)) {
+				find_buddy_priv = true;
+				break;
 			}
 		}
 	}
@@ -1213,7 +1211,8 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	/*Tx/Rx related var */
 	_rtl_pci_init_trx_var(hw);
 
-	/*IBSS*/ mac->beacon_interval = 100;
+	/*IBSS*/
+	mac->beacon_interval = 100;
 
 	/*AMPDU*/
 	mac->min_space_cfg = 0;
-- 
2.1.4

