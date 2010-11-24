Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:2326 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868Ab0KXQAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 11:00:54 -0500
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: hs4233@mail.mn-solutions.de
Cc: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH 1/2] libertas: fix memory corruption in lbs_remove_card()
Message-Id: <20101124160049.8058D9D401B@zog.reactivated.net>
Date: Wed, 24 Nov 2010 16:00:49 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"priv" is stored at the end of the wiphy structure, which is freed
during the call to lbs_cfg_free(). It must not be touched afterwards.

Remove the unnecessary NULL assignment causing this memory corruption.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

Please apply for 2.6.37

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 46b88b1..fcd1bbf 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -915,8 +915,6 @@ void lbs_remove_card(struct lbs_private *priv)
 
 	lbs_free_adapter(priv);
 	lbs_cfg_free(priv);
-
-	priv->dev = NULL;
 	free_netdev(dev);
 
 	lbs_deb_leave(LBS_DEB_MAIN);
-- 
1.7.3.2

