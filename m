Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:6507 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYCCMXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 07:23:13 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: fix sanity check on sequence number in command response
Date: Mon, 3 Mar 2008 12:20:12 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803031220.12420.hs4233@mail.mn-solutions.de> (sfid-20080303_122315_812800_222DBFBF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <dwmw2@infradead.org>

Slightly more useful if we compare it against the sequence number of the
command we have outstanding, rather than comparing the reply with itself.
    
Doh. Pointed out by Sebastian Siewior
    
Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index e6b4b23..52d02f3 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -509,9 +509,9 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		     respcmd, le16_to_cpu(resp->seqnum), priv->upld_len, jiffies);
 	lbs_deb_hex(LBS_DEB_CMD, "CMD_RESP", (void *) resp, priv->upld_len);
 
-	if (resp->seqnum != resp->seqnum) {
+	if (resp->seqnum != priv->cur_cmd->cmdbuf->seqnum) {
 		lbs_pr_info("Received CMD_RESP with invalid sequence %d (expected %d)\n",
-			    le16_to_cpu(resp->seqnum), le16_to_cpu(resp->seqnum));
+			    le16_to_cpu(resp->seqnum), le16_to_cpu(priv->cur_cmd->cmdbuf->seqnum));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		ret = -1;
 		goto done;
