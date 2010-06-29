Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29640 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab0F2GiP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 02:38:15 -0400
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <mcgrof@kernel.org>
CC: <linux-wireless@vger.kernel.org>,
	<linux-bluetooth@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] compat: Fix panic caused by NULL pointer derefence in rtnl_fill_ifinfo
Date: Tue, 29 Jun 2010 12:08:07 +0530
Message-ID: <1277793487-9071-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get stats netdev ops is blindy called for older kernels (< 2.6.29) and
so assigning a NULL pointer from netdev_attach_ops causes a NULL pointer
dereference.

By default, netdev alloc provides an internal stats reference. So fill
this only if ndo_get_stats is defined.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 compat/compat-2.6.29.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
index f94aed8..2e7e623 100644
--- a/compat/compat-2.6.29.c
+++ b/compat/compat-2.6.29.c
@@ -35,7 +35,8 @@ void netdev_attach_ops(struct net_device *dev,
 	dev->change_mtu = ops->ndo_change_mtu;
 	dev->set_mac_address = ops->ndo_set_mac_address;
 	dev->tx_timeout = ops->ndo_tx_timeout;
-	dev->get_stats = ops->ndo_get_stats;
+	if (ops->ndo_get_stats)
+		dev->get_stats = ops->ndo_get_stats;
 	dev->vlan_rx_register = ops->ndo_vlan_rx_register;
 	dev->vlan_rx_add_vid = ops->ndo_vlan_rx_add_vid;
 	dev->vlan_rx_kill_vid = ops->ndo_vlan_rx_kill_vid;
-- 
1.7.0.4

