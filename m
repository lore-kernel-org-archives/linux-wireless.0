Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:33241 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1KTTJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 14:09:54 -0500
Subject: [PATCH] brcm80211: smac: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.289.camel@localhost.localdomain> (sfid-20111120_201022_690680_9B7F3D49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c 2011-11-07 19:39:05.641131954 +0100
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c 2011-11-08 10:44:56.761349456 +0100
@@ -1561,11 +1561,10 @@ int brcms_ucode_init_buf(struct brcms_in
 			if (le32_to_cpu(hdr->idx) == idx) {
 				pdata = wl->fw.fw_bin[i]->data +
 					le32_to_cpu(hdr->offset);
-				*pbuf = kmalloc(len, GFP_ATOMIC);
+				*pbuf = kmemdup(pdata, len, GFP_ATOMIC);
 				if (*pbuf == NULL)
 					goto fail;
 
-				memcpy(*pbuf, pdata, len);
 				return 0;
 			}
 		}
