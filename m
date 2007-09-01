Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8008 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXIAEgi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:36:38 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id ED055618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:36:37 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 25/35] Don't dump mib_mdomain while scanning,  it's done on device startup
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:36:37 -0400
Message-ID: <20070901043637.2498.60162.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 98960eb..b586522 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -3816,7 +3816,6 @@ static void at76_dwork_get_scan(struct work_struct *work)
 {
 	int status;
 	int ret;
-	struct mib_mdomain mdomain;
 	struct at76_priv *priv = container_of(work, struct at76_priv,
 					      dwork_get_scan.work);
 
@@ -3861,16 +3860,6 @@ static void at76_dwork_get_scan(struct work_struct *work)
 
 	case 1:
 		WARN_ON(!priv->international_roaming);
-		ret = at76_get_mib_mdomain(priv, &mdomain);
-		if (ret < 0)
-			err("at76_get_mib_mdomain returned %d", ret);
-		else
-			at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: channel_list %s "
-				 "tx_powerlevel %s", priv->netdev->name,
-				 hex2str(mdomain.channel_list,
-					 sizeof(mdomain.channel_list)),
-				 hex2str(mdomain.tx_powerlevel,
-					 sizeof(mdomain.tx_powerlevel)));
 		ret = at76_start_scan(priv, 0, 0);
 		if (ret < 0)
 			err("%s: %s: start_scan (IR) failed with %d",
