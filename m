Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750965AbdG0LUv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 07:20:51 -0400
From: Stefano Brivio <sbrivio@redhat.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>, Jouni Malinen <j@w1.fi>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net] intersil/hostap: Fix outdated comment about dev->destructor
Date: Thu, 27 Jul 2017 13:20:15 +0200
Message-Id: <0824ed85fd45846da65fc919ae22df9d7ebf2f97.1501150507.git.sbrivio@redhat.com> (sfid-20170727_132057_860262_E57BF7D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After commit cf124db566e6 ("net: Fix inconsistent teardown and
release of private netdev state."), setting
'dev->needs_free_netdev' ensures device data is released, and
'dev->destructor' is not used anymore.

Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
Despite checkpatch.pl warning against unnecessary changes, this
outdated comment might lead to confusion -- making this change
actually necessary, perhaps.

 drivers/net/wireless/intersil/hostap/hostap_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_main.c b/drivers/net/wireless/intersil/hostap/hostap_main.c
index a3c066f90afc..012930d35434 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_main.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_main.c
@@ -125,8 +125,8 @@ void hostap_remove_interface(struct net_device *dev, int rtnl_locked,
 	else
 		unregister_netdev(dev);
 
-	/* dev->destructor = free_netdev() will free the device data, including
-	 * private data, when removing the device */
+	/* 'dev->needs_free_netdev = true' implies device data, including
+	 * private data, will be freed when the device is removed */
 }
 
 
-- 
2.9.4
