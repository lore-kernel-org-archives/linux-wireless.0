Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:53341 "HELO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757982Ab2FUC7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 22:59:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Ying Luo <luoy@marvell.com>, Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.5] mwifiex: fix bugs in event handling code
Date: Wed, 20 Jun 2012 19:58:34 -0700
Message-Id: <1340247517-4593-3-git-send-email-bzhao@marvell.com> (sfid-20120621_045905_797589_A48BC89C)
In-Reply-To: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
References: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch ensures uniformity in event skb sent by interface code
(USB/PCIe/SDIO) which automatically fixes following bugs.

1) For USB interface, same buffer is reused for receiving cmd and
events from firmware. While handling events, we perform
skb_pull(skb, 4) to remove event header. Corresponding skb_push()
call is missing while submitting the buffer.
2) For PCIe interface, event skb is passed with event header.
Recently added uAP events EVENT_UAP_STA_ASSOC, EVENT_UAP_STA_DEAUTH
will not work for PCIe, as they assume event skb points to event body.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c      |    6 +++---
 drivers/net/wireless/mwifiex/sta_event.c |    9 ++++-----
 drivers/net/wireless/mwifiex/usb.c       |    6 +++---
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index e037747..fc8a9bf 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -978,10 +978,10 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 		dev_dbg(adapter->dev, "info: --- Rx: Event ---\n");
 		adapter->event_cause = *(u32 *) skb->data;
 
-		skb_pull(skb, MWIFIEX_EVENT_HEADER_LEN);
-
 		if ((skb->len > 0) && (skb->len  < MAX_EVENT_SIZE))
-			memcpy(adapter->event_body, skb->data, skb->len);
+			memcpy(adapter->event_body,
+			       skb->data + MWIFIEX_EVENT_HEADER_LEN,
+			       skb->len);
 
 		/* event cause has been saved to adapter->event_cause */
 		adapter->event_received = true;
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 4ace5a3..11e731f 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -406,9 +406,9 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_UAP_STA_ASSOC:
-		skb_pull(adapter->event_skb, MWIFIEX_UAP_EVENT_EXTRA_HEADER);
 		memset(&sinfo, 0, sizeof(sinfo));
-		event = (struct mwifiex_assoc_event *)adapter->event_skb->data;
+		event = (struct mwifiex_assoc_event *)
+			(adapter->event_body + MWIFIEX_UAP_EVENT_EXTRA_HEADER);
 		if (le16_to_cpu(event->type) == TLV_TYPE_UAP_MGMT_FRAME) {
 			len = -1;
 
@@ -433,9 +433,8 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 				 GFP_KERNEL);
 		break;
 	case EVENT_UAP_STA_DEAUTH:
-		skb_pull(adapter->event_skb, MWIFIEX_UAP_EVENT_EXTRA_HEADER);
-		cfg80211_del_sta(priv->netdev, adapter->event_skb->data,
-				 GFP_KERNEL);
+		cfg80211_del_sta(priv->netdev, adapter->event_body +
+				 MWIFIEX_UAP_EVENT_EXTRA_HEADER, GFP_KERNEL);
 		break;
 	case EVENT_UAP_BSS_IDLE:
 		priv->media_connected = false;
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 49ebf20..e6d796f 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -91,7 +91,6 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 			}
 			skb_copy_from_linear_data(skb, &tmp, sizeof(u32));
 			adapter->event_cause = le32_to_cpu(tmp);
-			skb_pull(skb, sizeof(u32));
 			dev_dbg(dev, "event_cause %#x\n", adapter->event_cause);
 
 			if (skb->len > MAX_EVENT_SIZE) {
@@ -99,8 +98,9 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 				return -1;
 			}
 
-			skb_copy_from_linear_data(skb, adapter->event_body,
-						  skb->len);
+			memcpy(adapter->event_body, skb->data +
+			       MWIFIEX_EVENT_HEADER_LEN, skb->len);
+
 			adapter->event_received = true;
 			adapter->event_skb = skb;
 			break;
-- 
1.7.0.2

