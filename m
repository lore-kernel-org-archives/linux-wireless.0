Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7596 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbXGCPXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:06 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:00 +0200
Subject: [PATCH] libertas: remove adapter->nullpktinterval
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.00751.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No code ever initialized this variable, so it was 0 because of kzalloc().
But no other code changes it, making it rather useless.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/cmd.c |    3 +--
 drivers/net/wireless/libertas/dev.h |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 72e76e4..f5d4971 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -73,8 +73,7 @@ static int wlan_cmd_802_11_ps_mode(wlan_private * priv,
 
 		psm->locallisteninterval =
 		    cpu_to_le16(adapter->locallisteninterval);
-		psm->nullpktinterval =
-		    cpu_to_le16(adapter->nullpktinterval);
+		psm->nullpktinterval = 0;
 		psm->multipledtim =
 		    cpu_to_le16(priv->adapter->multipledtim);
 		break;
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index d324eeb..2d203c6 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -313,7 +313,6 @@ struct _wlan_adapter {
 
 	struct PS_CMD_ConfirmSleep libertas_ps_confirm_sleep;
 	u16 locallisteninterval;
-	u16 nullpktinterval;
 
 	struct assoc_request * pending_assoc_req;
 	struct assoc_request * in_progress_assoc_req;
-- 
1.5.2.1

