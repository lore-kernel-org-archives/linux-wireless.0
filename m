Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44643 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab0BQWo6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 17:44:58 -0500
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
From: Pavel Roskin <proski@gnu.org>
To: okias <d.okias@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c2673ca61002171104xddb6275t6d9e69878a8c5f82@mail.gmail.com>
References: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
	 <4B7C35C9.30607@lwfinger.net>
	 <c2673ca61002171034q18edf1c2o817ac4e1ff367177@mail.gmail.com>
	 <1266431764.15836.8.camel@jlt3.sipsolutions.net>
	 <c2673ca61002171038u14c7ab2fnf2d3ce2067bd1fd8@mail.gmail.com>
	 <1266433138.9050.27.camel@mj>
	 <c2673ca61002171104xddb6275t6d9e69878a8c5f82@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Feb 2010 17:44:45 -0500
Message-Id: <1266446685.12365.14.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-17 at 20:04 +0100, okias wrote:
> ok, sorry I tested it on x86_64. Here is correct patch:

I'm sorry, but it's not a cleanup.  Initializing reg outside the block
gives a wrong impression that reg may be used outside the block.  Code
is safer is it's more readable, and it's more readable if the logic is
not spread around, but kept in one place.

Unnecessary initialization can prevent gcc from issuing warnings about
using uninitialized variables when the code changes.  Such warnings may
be useful to find real bugs.  I can give you a realistic example, but it
would be off-topic here.

A real cleanup would be to give reg the block scope and to refactor the
code where reg is written to the hardware:

--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1163,9 +1163,10 @@ static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
-	u8 reg;
 
 	if (changed & BSS_CHANGED_BSSID) {
+		u8 reg;
+
 		mutex_lock(&priv->conf_mutex);
 		for (i = 0; i < ETH_ALEN; i++)
 			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
@@ -1176,13 +1177,12 @@ static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
 		else
 			reg = 0;
 
-		if (is_valid_ether_addr(info->bssid)) {
+		if (is_valid_ether_addr(info->bssid))
 			reg |= RTL818X_MSR_INFRA;
-			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
-		} else {
+		else
 			reg |= RTL818X_MSR_NO_LINK;
-			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
-		}
+
+		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 
 		mutex_unlock(&priv->conf_mutex);
 	}

But I would never bother with that simply because wireless developers
have more important things to do.

I respectfully suggest that you do your exercises in C programming
elsewhere.

-- 
Regards,
Pavel Roskin
