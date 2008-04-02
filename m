Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:60859 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757922AbYDBTs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 15:48:28 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: reinette.chatre@intel.com
Cc: ipw2100-devel@lists.sourceforge.net
Subject: [PATCH] ipw2200: set MAC address on radiotap interface
Message-Id: <20080402193354.0E2DF9D4143@zog.reactivated.net> (sfid-20080402_204844_702594_11F31AAB)
Date: Wed,  2 Apr 2008 20:33:54 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit bada339ba24dee9e143bfb42e1dc61f146619846 enforces that all
interfaces have a valid MAC address before they are brought up.

ipw2200 does not assign a MAC address to it's radiotap interface, meaning
that the radiotap interface cannot be brought up in 2.6.24.
https://bugs.gentoo.org/show_bug.cgi?id=215714

Fix this by copying the MAC address from the real interface.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/ipw2200.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index a56d9fc..b34c275 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -11576,6 +11576,7 @@ static int ipw_prom_alloc(struct ipw_priv *priv)
 	priv->prom_priv->priv = priv;
 
 	strcpy(priv->prom_net_dev->name, "rtap%d");
+	memcpy(priv->prom_net_dev->dev_addr, priv->mac_addr, ETH_ALEN);
 
 	priv->prom_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
 	priv->prom_net_dev->open = ipw_prom_open;
-- 
1.5.4.5

