Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:42757 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbYDITid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 15:38:33 -0400
Received: from localhost (perninha.conectiva.com.br [127.0.0.1])
	by perninha.conectiva.com.br (Postfix) with ESMTP id E2DD53EA7
	for <linux-wireless@vger.kernel.org>; Wed,  9 Apr 2008 16:38:34 -0300 (BRT)
Received: from perninha.conectiva.com.br ([127.0.0.1])
	by localhost (perninha.conectiva.com.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id MNKsv4hyPhSt for <linux-wireless@vger.kernel.org>;
	Wed,  9 Apr 2008 16:38:34 -0300 (BRT)
Received: from fox.conectiva (fox.conectiva [10.0.2.195])
	by perninha.conectiva.com.br (Postfix) with ESMTP id 8ED013EA5
	for <linux-wireless@vger.kernel.org>; Wed,  9 Apr 2008 16:38:34 -0300 (BRT)
Received: from gotham.conectiva (gotham.conectiva [10.0.2.23])
	by fox.conectiva (Postfix) with ESMTP id 1824C2F547
	for <linux-wireless@vger.kernel.org>; Wed,  9 Apr 2008 16:38:32 -0300 (BRT)
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Add missing priv->vif assignments
Date: Wed, 9 Apr 2008 16:38:31 -0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804091638.31525.herton@mandriva.com.br> (sfid-20080409_203838_327788_773779FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds missing priv->vif assignments after "mac80211: don't use
interface indices in drivers" change. As rtl8180, rtl8187 also needs
priv->vif to be set, as without this an oops can happen in rtl8187_tx
function (priv->vif is passed to ieee80211_rts_duration).

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl8187_dev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index c03834d..d5787b3 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -546,6 +546,8 @@ static int rtl8187_add_interface(struct ieee80211_hw *dev,
 		return -EOPNOTSUPP;
 	}
 
+	priv->vif = conf->vif;
+
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	for (i = 0; i < ETH_ALEN; i++)
 		rtl818x_iowrite8(priv, &priv->map->MAC[i],
@@ -560,6 +562,7 @@ static void rtl8187_remove_interface(struct ieee80211_hw *dev,
 {
 	struct rtl8187_priv *priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->vif = NULL;
 }
 
 static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
-- 
1.5.4.3


-- 
[]'s
Herton
