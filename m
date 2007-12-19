Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:44868 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXLSQKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:23 -0500
Subject: [PATCH 119/48] libertas: handle HOST_AWAKE event by sending WAKEUP_CONFIRM command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50tw-00020E-42@pmac.infradead.org> (sfid-20071219_161029_459601_E3CA4FBB)
Date: Wed, 19 Dec 2007 15:32:04 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 13:26:42 -0500

lbs_send_confirmwake() is a bit ugly but matches the way we confirm
sleep. We'll deal with that whole thing later.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmdresp.c |   30 +++++++++++++++++++++++++++++-
 drivers/net/wireless/libertas/dev.h     |    1 +
 drivers/net/wireless/libertas/host.h    |    1 +
 3 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index c05fef0..8f9eda4 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -773,6 +773,30 @@ done:
 	return ret;
 }
 
+static int lbs_send_confirmwake(struct lbs_private *priv)
+{
+	struct cmd_header *cmd = &priv->lbs_ps_confirm_wake;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_HOST);
+
+	cmd->command = cpu_to_le16(CMD_802_11_WAKEUP_CONFIRM);
+	cmd->size = cpu_to_le16(sizeof(*cmd));
+	cmd->seqnum = cpu_to_le16(++priv->seqnum);
+	cmd->result = 0;
+
+	lbs_deb_host("SEND_WAKEC_CMD: before download\n");
+
+	lbs_deb_hex(LBS_DEB_HOST, "wake confirm command", (void *)cmd, sizeof(*cmd));
+
+	ret = priv->hw_host_to_card(priv, MVMS_CMD, (void *)cmd, sizeof(*cmd));
+	if (ret)
+		lbs_pr_alert("SEND_WAKEC_CMD: Host to Card failed for Confirm Wake\n");
+
+	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
+	return ret;
+}
+
 int lbs_process_event(struct lbs_private *priv)
 {
 	int ret = 0;
@@ -821,9 +845,13 @@ int lbs_process_event(struct lbs_private *priv)
 
 		break;
 
+	case MACREG_INT_CODE_HOST_AWAKE:
+		lbs_deb_cmd("EVENT: HOST_AWAKE\n");
+		lbs_send_confirmwake(priv);
+		break;
+
 	case MACREG_INT_CODE_PS_AWAKE:
 		lbs_deb_cmd("EVENT: awake\n");
-
 		/* handle unexpected PS AWAKE event */
 		if (priv->psstate == PS_STATE_FULL_POWER) {
 			lbs_deb_cmd(
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 465080f..fe50457 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -263,6 +263,7 @@ struct lbs_private {
 	u8 needtowakeup;
 
 	struct PS_CMD_ConfirmSleep lbs_ps_confirm_sleep;
+	struct cmd_header lbs_ps_confirm_wake;
 
 	struct assoc_request * pending_assoc_req;
 	struct assoc_request * in_progress_assoc_req;
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index bdf9017..4c03e12 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -74,6 +74,7 @@
 #define CMD_802_11_GET_AFC			0x003d
 #define CMD_802_11_AD_HOC_STOP			0x0040
 #define CMD_802_11_HOST_SLEEP_CFG		0x0043
+#define CMD_802_11_WAKEUP_CONFIRM		0x0044
 #define CMD_802_11_HOST_SLEEP_ACTIVATE		0x0045
 #define CMD_802_11_BEACON_STOP			0x0049
 #define CMD_802_11_MAC_ADDRESS			0x004d
-- 
1.5.3.4

