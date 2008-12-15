Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54805 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYLOTnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 14:43:20 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Mon, 15 Dec 2008 20:43:21 +0100
Cc: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <4946A4C9.7040304@lwfinger.net>
In-Reply-To: <4946A4C9.7040304@lwfinger.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ZNrRJOiGzExbS1J"
Message-Id: <200812152043.21971.chunkeey@web.de> (sfid-20081215_204324_237422_7B0AB202)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_ZNrRJOiGzExbS1J
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 15 December 2008 19:41:13 Larry Finger wrote:
> Artur Skawina wrote:
> > I have a sinus 154 data usb adapter, which used to work w/ p54 in 2.6.27:
> 
> Can you bisect this problem?
Naa I guess its "p54: fix memory management".
872037115977dc07ae05e4b6b769bf8726da4e87

so tell us if this patch works.

Regards,
	Chr

--Boundary-00=_ZNrRJOiGzExbS1J
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="p54usb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54usb.patch"

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 9c2c651..3951ce2 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -314,6 +314,7 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
 	struct net2280_tx_hdr *hdr;
 	struct net2280_reg_write *reg;
 	int err = 0;
+	struct p54_hdr *pkg_hdr = (struct p54_hdr *) skb->data;
 
 	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
 	if (!reg)
@@ -336,10 +337,11 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
 	reg->addr = cpu_to_le32(P54U_DEV_BASE);
 	reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
 
+	
 	hdr = (void *)skb_push(skb, sizeof(*hdr));
 	memset(hdr, 0, sizeof(*hdr));
-	hdr->device_addr = ((struct p54_hdr *)skb->data)->req_id;
-	hdr->len = cpu_to_le16(skb->len + sizeof(struct p54_hdr));
+	hdr->device_addr = pkg_hdr->req_id;
+	hdr->len = cpu_to_le16(skb->len);
 
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),

--Boundary-00=_ZNrRJOiGzExbS1J--
