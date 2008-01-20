Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:45268 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796AbYATAOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 19:14:49 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 11/14] [rndis_host] Add rndis_link_change function pointer to
	'struct rndis_data'.
To: linux-wireless@vger.kernel.org
Cc: bjd@jooz.net, dbrownell@users.sourceforge.net,
	netdev@vger.kernel.org
Date: Sun, 20 Jan 2008 02:14:43 +0200
Message-ID: <20080120001443.25718.2173.stgit@fate.lan> (sfid-20080120_001452_395668_ACDFC381)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Callback to signal link state changes to rndis_wext.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/usb/rndis_host.c |   24 ++++++++++++++++++++----
 drivers/net/usb/usbnet.h     |    3 +++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 22e5ca1..c295fa1 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -148,10 +148,26 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf)
 					request_id, xid);
 				/* then likely retry */
 			} else switch (buf->msg_type) {
-			case RNDIS_MSG_INDICATE: {	/* fault */
-				// struct rndis_indicate *msg = (void *)buf;
-				dev_info(&info->control->dev,
-					"rndis fault indication\n");
+			case RNDIS_MSG_INDICATE: {	/* fault/event */
+				struct rndis_indicate *msg = (void *)buf;
+				int state = 0;
+
+				switch (msg->status) {
+				case RNDIS_STATUS_MEDIA_CONNECT:
+					state = 1;
+				case RNDIS_STATUS_MEDIA_DISCONNECT:
+					dev_info(&info->control->dev,
+						"rndis media %sconnect\n",
+						!state?"dis":"");
+					if (dev->driver_info->rndis_link_change)
+						dev->driver_info->rndis_link_change(
+							dev, state);
+					break;
+				default:
+					dev_info(&info->control->dev,
+						"rndis indication: 0x%08x\n",
+						le32_to_cpu(msg->status));
+				}
 				}
 				break;
 			case RNDIS_MSG_KEEPALIVE: {	/* ping */
diff --git a/drivers/net/usb/usbnet.h b/drivers/net/usb/usbnet.h
index 2bc5f76..5f5b309 100644
--- a/drivers/net/usb/usbnet.h
+++ b/drivers/net/usb/usbnet.h
@@ -119,6 +119,9 @@ struct driver_info {
 	/* rndis minidriver early initialization code, can sleep */
 	int	(*rndis_early_init)(struct usbnet *dev);
 
+	/* called when link state changes, state: 0=disconnect, 1=connect */
+	void	(*rndis_link_change)(struct usbnet *dev, int state);
+
 	/* for new devices, use the descriptor-reading code instead */
 	int		in;		/* rx endpoint */
 	int		out;		/* tx endpoint */

