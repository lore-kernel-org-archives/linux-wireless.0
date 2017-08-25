Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50646 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755073AbdHYIlL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 04:41:11 -0400
Date: Fri, 25 Aug 2017 11:40:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] rsi: update some comments
Message-ID: <20170825084037.gxgsieknkb5hxdfs@mwanda> (sfid-20170825_104117_787321_A16F6BC6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825082645.z2hiotefhzizb7sr@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions don't return -1 on failure.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 25331aa16e8e..e78e87e99804 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -754,7 +754,7 @@ static int rsi_mac80211_conf_tx(struct ieee80211_hw *hw,
  * @vif: Pointer to the ieee80211_vif structure.
  * @key: Pointer to the ieee80211_key_conf structure.
  *
- * Return: status: 0 on success, -1 on failure.
+ * Return: status: 0 on success, negative error codes on failure.
  */
 static int rsi_hal_key_config(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
@@ -1194,7 +1194,7 @@ static void rsi_set_min_rate(struct ieee80211_hw *hw,
  * @vif: Pointer to the ieee80211_vif structure.
  * @sta: Pointer to the ieee80211_sta structure.
  *
- * Return: 0 on success, -1 on failure.
+ * Return: 0 on success, negative error codes on failure.
  */
 static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
@@ -1306,7 +1306,7 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
  * @vif: Pointer to the ieee80211_vif structure.
  * @sta: Pointer to the ieee80211_sta structure.
  *
- * Return: 0 on success, -1 on failure.
+ * Return: 0 on success, negative error codes on failure.
  */
 static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
@@ -1426,7 +1426,7 @@ static int rsi_mac80211_set_antenna(struct ieee80211_hw *hw,
  * @tx_ant: Bitmap for tx antenna
  * @rx_ant: Bitmap for rx antenna
  * 
- * Return: 0 on success, -1 on failure.
+ * Return: 0 on success, negative error codes on failure.
  */
 static int rsi_mac80211_get_antenna(struct ieee80211_hw *hw,
 				    u32 *tx_ant, u32 *rx_ant)
@@ -1533,7 +1533,7 @@ static struct ieee80211_ops mac80211_ops = {
  * rsi_mac80211_attach() - This function is used to initialize Mac80211 stack.
  * @common: Pointer to the driver private structure.
  *
- * Return: 0 on success, -1 on failure.
+ * Return: 0 on success, negative error codes on failure.
  */
 int rsi_mac80211_attach(struct rsi_common *common)
 {
