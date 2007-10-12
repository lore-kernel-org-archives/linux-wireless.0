Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51438 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756865AbXJLUtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 16:49:13 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] rtl8187: remove NICMAC setting in configure_filters callback
Date: Fri, 12 Oct 2007 16:45:12 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20071012204512.13393.84281.stgit@magic.sourmilk.net> (sfid-20071012_214915_385291_FE84E4EB)
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

NICMAC should always be set.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8187_dev.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 643919a..590f4b4 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -588,8 +588,6 @@ static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 
 	*total_flags = 0;
 
-	if (changed_flags & FIF_PROMISC_IN_BSS)
-		priv->rx_conf ^= RTL818X_RX_CONF_NICMAC;
 	if (changed_flags & FIF_ALLMULTI)
 		priv->rx_conf ^= RTL818X_RX_CONF_MULTICAST;
 	if (changed_flags & FIF_FCSFAIL)
@@ -602,8 +600,6 @@ static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 	if (mc_count > 0)
 		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
 
-	if (priv->rx_conf & RTL818X_RX_CONF_NICMAC)
-		*total_flags |= FIF_PROMISC_IN_BSS;
 	if (priv->rx_conf & RTL818X_RX_CONF_MULTICAST)
 		*total_flags |= FIF_ALLMULTI;
 	if (priv->rx_conf & RTL818X_RX_CONF_FCS)

