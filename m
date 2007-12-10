Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55260 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXLJPpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:47 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 14/48] libertas: fix data packet size errors
Message-Id: <E1J1kpI-0006lF-Pz@shinybook.infradead.org> (sfid-20071210_154550_499795_89BA9879)
Date: Mon, 10 Dec 2007 10:45:48 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Thu, 6 Dec 2007 13:50:30 +0100

I wondered about junk bytes at the end when using "lbsdebug +hex +host"
until I noticed that firmware for the CF card sends my extranous bytes.
It says "I have 20 bytes", I take 20 bytes, but the last 8 bytes of this
are just data junk.

Also, in the new lbs_cmd() where was a size miscalulation
that made itself clear after fixing this bug.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmdresp.c |    2 +-
 drivers/net/wireless/libertas/if_cs.c   |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 6a43de7..22a6973 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -882,7 +882,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
 
 	if (adapter->cur_cmd->pdata_size) {
 		struct cmd_ds_gen *r = (struct cmd_ds_gen *)resp;
-		u16 sz = cpu_to_le16(resp->size);
+		u16 sz = cpu_to_le16(resp->size) - S_DS_GEN;
 		if (sz > *adapter->cur_cmd->pdata_size) {
 			lbs_pr_err("response 0x%04x doesn't fit into "
 				"buffer (%d > %d)\n", respcmd,
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 54b1ba3..8508260 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -373,6 +373,9 @@ static int if_cs_receive_cmdres(struct lbs_private *priv, u8 *data, u32 *len)
 	if (*len & 1)
 		data[*len-1] = if_cs_read8(priv->card, IF_CS_C_CMD);
 
+	/* This is a workaround for a firmware that reports too much
+	 * bytes */
+	*len -= 8;
 	ret = 0;
 out:
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d, len %d", ret, *len);
-- 
1.5.3.4

