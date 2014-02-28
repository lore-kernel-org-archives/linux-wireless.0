Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43027 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaB1Dfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 22:35:30 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@alum.mit.edu>,
	Avery Pennarun <apenwarr@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/9] mwifiex: stop AP at shutdown time
Date: Thu, 27 Feb 2014 19:35:17 -0800
Message-ID: <1393558517-887-3-git-send-email-bzhao@marvell.com> (sfid-20140228_043533_674886_AC58C7E4)
In-Reply-To: <1393558517-887-1-git-send-email-bzhao@marvell.com>
References: <1393558517-887-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Deauth is sent to AP when the device is acting as station at
shutdown time. Similarly we should stop AP operation also.
mwifiex_deauthenticate() takes care closing the connection
based on provided interface type.

Add a new function to simplify the code.

Reported-by: Avery Pennarun <apenwarr@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c | 15 ++++++++++++++-
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/pcie.c |  7 +------
 drivers/net/wireless/mwifiex/sdio.c |  7 +------
 drivers/net/wireless/mwifiex/usb.c  |  8 ++------
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index e9bd435..89dc62a 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1443,7 +1443,20 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mwifiex_deauthenticate);
+
+/* This function deauthenticates/disconnects from all BSS. */
+void mwifiex_deauthenticate_all(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_private *priv;
+	int i;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (priv)
+			mwifiex_deauthenticate(priv, NULL);
+	}
+}
+EXPORT_SYMBOL_GPL(mwifiex_deauthenticate_all);
 
 /*
  * This function converts band to radio type used in channel TLV.
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6747405..85ce29c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -926,6 +926,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 void mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason);
 u8 mwifiex_band_to_radio_type(u8 band);
 int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac);
+void mwifiex_deauthenticate_all(struct mwifiex_adapter *adapter);
 int mwifiex_adhoc_start(struct mwifiex_private *priv,
 			struct cfg80211_ssid *adhoc_ssid);
 int mwifiex_adhoc_join(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index f56595c..9f1683b 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -211,7 +211,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	struct pcie_service_card *card;
 	struct mwifiex_adapter *adapter;
 	struct mwifiex_private *priv;
-	int i;
 
 	card = pci_get_drvdata(pdev);
 	if (!card)
@@ -230,11 +229,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 			mwifiex_pcie_resume(&pdev->dev);
 #endif
 
-		for (i = 0; i < adapter->priv_num; i++)
-			if ((GET_BSS_ROLE(adapter->priv[i]) ==
-			     MWIFIEX_BSS_ROLE_STA) &&
-			    adapter->priv[i]->media_connected)
-				mwifiex_deauthenticate(adapter->priv[i], NULL);
+		mwifiex_deauthenticate_all(adapter);
 
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index d5661a6..e0dcd3e 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -166,7 +166,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
 	struct mwifiex_private *priv;
-	int i;
 
 	pr_debug("info: SDIO func num=%d\n", func->num);
 
@@ -185,11 +184,7 @@ mwifiex_sdio_remove(struct sdio_func *func)
 		if (adapter->is_suspended)
 			mwifiex_sdio_resume(adapter->dev);
 
-		for (i = 0; i < adapter->priv_num; i++)
-			if ((GET_BSS_ROLE(adapter->priv[i]) ==
-						MWIFIEX_BSS_ROLE_STA) &&
-			    adapter->priv[i]->media_connected)
-				mwifiex_deauthenticate(adapter->priv[i], NULL);
+		mwifiex_deauthenticate_all(adapter);
 
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 		mwifiex_disable_auto_ds(priv);
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index f47a793..ae30c39 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -1026,7 +1026,6 @@ static void mwifiex_usb_cleanup_module(void)
 
 	if (usb_card && usb_card->adapter) {
 		struct mwifiex_adapter *adapter = usb_card->adapter;
-		int i;
 
 		/* In case driver is removed when asynchronous FW downloading is
 		 * in progress
@@ -1037,11 +1036,8 @@ static void mwifiex_usb_cleanup_module(void)
 		if (adapter->is_suspended)
 			mwifiex_usb_resume(usb_card->intf);
 #endif
-		for (i = 0; i < adapter->priv_num; i++)
-			if ((GET_BSS_ROLE(adapter->priv[i]) ==
-			     MWIFIEX_BSS_ROLE_STA) &&
-			    adapter->priv[i]->media_connected)
-				mwifiex_deauthenticate(adapter->priv[i], NULL);
+
+		mwifiex_deauthenticate_all(adapter);
 
 		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
 							  MWIFIEX_BSS_ROLE_ANY),
-- 
1.8.2.3

