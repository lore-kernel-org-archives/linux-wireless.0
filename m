Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:37524 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0EMFEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 01:04:31 -0400
From: Kiran Divekar <dkiran@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Date: Wed, 12 May 2010 22:04:28 -0700
Subject: [PATCH] libertas: Added callback functions to support SDIO
 suspend/resume.
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C04D61E8CEA@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In suspend() host sleep is activated using already configured
host sleep parameters through wol command, and in resume() host
sleep is cancelled. Earlier priv->fw_ready flag used to reset and
set in suspend and resume handler respectively. Since after suspend
only host goes into sleep state and firmware is always ready, those
changes in flag state are removed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/libertas/cmd.c     |   37 ++++++++++++--
 drivers/net/wireless/libertas/cmdresp.c |   30 ++---------
 drivers/net/wireless/libertas/decl.h    |    2 +-
 drivers/net/wireless/libertas/dev.h     |    6 ++
 drivers/net/wireless/libertas/ethtool.c |   15 +++---
 drivers/net/wireless/libertas/if_sdio.c |   58 ++++++++++++++++++++++
 drivers/net/wireless/libertas/if_usb.c  |    6 ++
 drivers/net/wireless/libertas/main.c    |   79 ++++++++++++++++++++++---------
 8 files changed, 172 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index cdb9b96..0fa6b0e 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -70,6 +70,8 @@ static u8 is_command_allowed_in_ps(u16 cmd)
 	switch (cmd) {
 	case CMD_802_11_RSSI:
 		return 1;
+	case CMD_802_11_HOST_SLEEP_CFG:
+		return 1;
 	default:
 		break;
 	}
@@ -185,6 +187,23 @@ out:
 	return ret;
 }
 
+static int lbs_ret_host_sleep_cfg(struct lbs_private *priv, unsigned long dummy,
+			struct cmd_header *resp)
+{
+	lbs_deb_enter(LBS_DEB_CMD);
+	if (priv->wol_criteria == EHS_REMOVE_WAKEUP) {
+		priv->is_host_sleep_configured = 0;
+		if (priv->psstate == PS_STATE_FULL_POWER) {
+			priv->is_host_sleep_activated = 0;
+			wake_up_interruptible(&priv->host_sleep_q);
+		}
+	} else {
+		priv->is_host_sleep_configured = 1;
+	}
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
