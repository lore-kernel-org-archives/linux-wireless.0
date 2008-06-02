Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:32949 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYFBPmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 11:42:09 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/4] rndis_wlan: update carrier flag when link state changes
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Mon, 02 Jun 2008 18:35:29 +0300
Message-ID: <20080602153529.22793.91132.stgit@nanoha.lan> (sfid-20080602_174215_993401_5AF0C2F2)
In-Reply-To: <20080602153521.22793.4271.stgit@nanoha.lan>
References: <20080602153521.22793.4271.stgit@nanoha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver wasn't updating netif_carrier on link state changes but assumed
link layer was always up.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index aaeeec8..c281c0b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2215,6 +2215,8 @@ static void rndis_wext_worker(struct work_struct *work)
 	int ret, offset;
 
 	if (test_and_clear_bit(WORK_LINK_UP, &priv->work_pending)) {
+		netif_carrier_on(usbdev->net);
+
 		info = kzalloc(assoc_size, GFP_KERNEL);
 		if (!info)
 			goto get_bssid;
@@ -2253,6 +2255,8 @@ get_bssid:
 	}
 
 	if (test_and_clear_bit(WORK_LINK_DOWN, &priv->work_pending)) {
+		netif_carrier_off(usbdev->net);
+
 		evt.data.flags = 0;
 		evt.data.length = 0;
 		memset(evt.ap_addr.sa_data, 0, ETH_ALEN);
@@ -2574,6 +2578,7 @@ static int rndis_wext_bind(struct usbnet *dev, struct usb_interface *intf)
 	/* turn radio on */
 	priv->radio_on = 1;
 	disassociate(dev, 1);
+	netif_carrier_off(dev->net);
 
 	/* because rndis_command() sleeps we need to use workqueue */
 	priv->workqueue = create_singlethread_workqueue("rndis_wlan");

