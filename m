Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:58395 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316AbYAYWvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 17:51:37 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 10/14] [rndis_host] Add early_init function pointer to 'struct
	rndis_data'.
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, bjd@jooz.net, david-b@pacbell.net
Date: Sat, 26 Jan 2008 00:51:28 +0200
Message-ID: <20080125225128.11716.59998.stgit@fate.lan> (sfid-20080125_225147_002625_D0C9028C)
In-Reply-To: <20080125225032.11716.77713.stgit@fate.lan>
References: <20080125225032.11716.77713.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function pointer is for 'subminidrivers' that need to do work on device 
right after minidriver has initialized hardware.

For example, rndis_wlan setting device specific configuration parameters
with OID_GEN_RNDIS_CONFIG_PARAMETER right after rndis_host has 
initialized hardware with RNDIS_INIT.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/usb/rndis_host.c |    6 ++++++
 drivers/net/usb/usbnet.h     |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 1d6bf0a..0813903 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -336,6 +336,12 @@ int generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->hard_mtu, tmp, dev->rx_urb_size,
 		1 << le32_to_cpu(u.init_c->packet_alignment));
 
+	/* module has some device initialization code needs to be done right
+	 * after RNDIS_INIT */
+	if (dev->driver_info->early_init &&
+			dev->driver_info->early_init(dev) != 0)
+		goto halt_fail_and_release;
+
 	/* Get designated host ethernet address */
 	reply_len = ETH_ALEN;
 	retval = rndis_query(dev, intf, u.buf, OID_802_3_PERMANENT_ADDRESS,
diff --git a/drivers/net/usb/usbnet.h b/drivers/net/usb/usbnet.h
index 0b4bf09..25b63d3 100644
--- a/drivers/net/usb/usbnet.h
+++ b/drivers/net/usb/usbnet.h
@@ -116,6 +116,11 @@ struct driver_info {
 	struct sk_buff	*(*tx_fixup)(struct usbnet *dev,
 				struct sk_buff *skb, gfp_t flags);
 
+	/* early initialization code, can sleep. This is for minidrivers
+	 * having 'subminidrivers' that need to do extra initialization
+	 * right after minidriver have initialized hardware. */
+	int	(*early_init)(struct usbnet *dev);
+
 	/* for new devices, use the descriptor-reading code instead */
 	int		in;		/* rx endpoint */
 	int		out;		/* tx endpoint */

