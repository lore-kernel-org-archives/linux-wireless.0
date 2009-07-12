Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:43926 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZGLWIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 18:08:41 -0400
Received: by ewy26 with SMTP id 26so2195008ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2009 15:08:39 -0700 (PDT)
Message-ID: <4A5A5F3F.80100@gmail.com>
Date: Mon, 13 Jul 2009 00:10:07 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arlan: inverted logic?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inverted logic

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Usually the inverted occurs see:

s="[[:space:]]*"
em='!'

git grep -E -n -A1 "if$s\($s$em?${s}netif_running$s\(" |
grep -B1 "[-]EBUSY" | less

Is my patch correct? please review.

diff --git a/drivers/net/wireless/arlan-main.c b/drivers/net/wireless/arlan-main.c
index d84caf1..4ac519f 100644
--- a/drivers/net/wireless/arlan-main.c
+++ b/drivers/net/wireless/arlan-main.c
@@ -1022,7 +1022,7 @@ static int arlan_mac_addr(struct net_device *dev, void *p)
 	ARLAN_DEBUG_ENTRY("arlan_mac_addr");
 	return -EINVAL;
 
-	if (!netif_running(dev))
+	if (netif_running(dev))
 		return -EBUSY;
 	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
 
