Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35038 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752139AbZBYXgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 18:36:42 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Thu, 26 Feb 2009 00:36:39 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090225233639.289250@gmx.net> (sfid-20090226_003645_822320_ACBA6A58)
MIME-Version: 1.0
Subject: [PATCH] mac80211: Call commit() after interface up
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Call commit() after the interface is up again to initiate a new rejoin.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2acc416..d5faef0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -331,6 +331,8 @@ static int ieee80211_open(struct net_device *dev)
=20
 	netif_tx_start_all_queues(dev);
=20
+	ieee80211_commit(sdata);
+
 	return 0;
  err_del_interface:
 	local->ops->remove_interface(local_to_hw(local), &conf);

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
