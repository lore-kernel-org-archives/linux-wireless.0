Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42498 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309AbZJFVQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 17:16:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/4] ipw2200: support ETHTOOL_GPERMADDR
Date: Tue,  6 Oct 2009 17:07:18 -0400
Message-Id: <1254863240-14780-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1254863240-14780-1-git-send-email-linville@tuxdriver.com>
References: <1254863240-14780-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 8d58e6e..61ef890 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11275,6 +11275,7 @@ static int ipw_up(struct ipw_priv *priv)
 		if (!(priv->config & CFG_CUSTOM_MAC))
 			eeprom_parse_mac(priv, priv->mac_addr);
 		memcpy(priv->net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
+		memcpy(priv->net_dev->perm_addr, priv->mac_addr, ETH_ALEN);
 
 		for (j = 0; j < ARRAY_SIZE(ipw_geos); j++) {
 			if (!memcmp(&priv->eeprom[EEPROM_COUNTRY_CODE],
-- 
1.6.2.5

