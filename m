Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933594AbXCPLkk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 07:40:40 -0400
Message-ID: <45FA8210.7080709@redhat.com>
Date: Fri, 16 Mar 2007 12:40:00 +0100
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: breed@users.sourceforge.net, dcbw@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH 1/3] airo: Don't check for NULL before kfree()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's unnecessary to check for NULL before calling kfree().

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index a8c2bfe..71ac1f1 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2740,8 +2740,6 @@ static int airo_networks_allocate(struct airo_info *ai)
 
 static void airo_networks_free(struct airo_info *ai)
 {
-	if (!ai->networks)
-		return;
 	kfree(ai->networks);
 	ai->networks = NULL;
 }



