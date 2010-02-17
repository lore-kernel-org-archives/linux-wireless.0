Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58460 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0BQTEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 14:04:20 -0500
Received: by vws11 with SMTP id 11so36528vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 11:04:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266433138.9050.27.camel@mj>
References: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
	 <4B7C35C9.30607@lwfinger.net>
	 <c2673ca61002171034q18edf1c2o817ac4e1ff367177@mail.gmail.com>
	 <1266431764.15836.8.camel@jlt3.sipsolutions.net>
	 <c2673ca61002171038u14c7ab2fnf2d3ce2067bd1fd8@mail.gmail.com>
	 <1266433138.9050.27.camel@mj>
Date: Wed, 17 Feb 2010 20:04:17 +0100
Message-ID: <c2673ca61002171104xddb6275t6d9e69878a8c5f82@mail.gmail.com>
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
From: okias <d.okias@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, herton@mandriva.com.br,
	htl10@users.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ok, sorry I tested it on x86_64. Here is correct patch:

>From c4dd3d87e090dd0b44dc030840f2ae1fd0bff729 Mon Sep 17 00:00:00 2001
From: David Heidelberger <d.okias@gmail.com>
Date: Wed, 17 Feb 2010 19:41:15 +0100
Subject: [PATCH] rtl8187: micro cleanup v3

---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 7ba3052..2cc6881 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1165,7 +1165,7 @@ static void rtl8187_bss_info_changed(struct
ieee80211_hw *dev,
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
-	u8 reg;
+	u8 reg = 0;

 	if (changed & BSS_CHANGED_BSSID) {
 		mutex_lock(&priv->conf_mutex);
@@ -1175,8 +1175,6 @@ static void rtl8187_bss_info_changed(struct
ieee80211_hw *dev,

 		if (priv->is_rtl8187b)
 			reg = RTL818X_MSR_ENEDCA;
-		else
-			reg = 0;

 		if (is_valid_ether_addr(info->bssid)) {
 			reg |= RTL818X_MSR_INFRA;
-- 
1.7.0
