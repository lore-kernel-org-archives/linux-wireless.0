Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:44913 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbaDANuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 09:50:10 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ray_cs: replace del_timer by del_timer_sync
Date: Tue,  1 Apr 2014 15:49:18 +0200
Message-Id: <1396360159-16244-3-git-send-email-Julia.Lawall@lip6.fr> (sfid-20140401_155214_572141_CB6097CF)
In-Reply-To: <1396360159-16244-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1396360159-16244-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use del_timer_sync to ensure that the timer is stopped on all CPUs before
the driver exits.

This change was suggested by Thomas Gleixner.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier i,t,ex;
@@
struct t i = { .remove = ex, };

@@
identifier r.ex;
@@
ex(...) {
  <...
- del_timer
+ del_timer_sync
    (...)
  ...>
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/net/wireless/ray_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index cbf0a58..8330fa3 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -343,7 +343,7 @@ static void ray_detach(struct pcmcia_device *link)
 	ray_release(link);
 
 	local = netdev_priv(dev);
-	del_timer(&local->timer);
+	del_timer_sync(&local->timer);
 
 	if (link->priv) {
 		unregister_netdev(dev);

