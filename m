Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:33327 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZFTDKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 23:10:23 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] ar9170usb: module link in sysfs
Date: Sat, 20 Jun 2009 05:10:24 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <45e8e6c40906191054k3fce4d27od827bdbf8ed76d09@mail.gmail.com>
In-Reply-To: <45e8e6c40906191054k3fce4d27od827bdbf8ed76d09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200906200510.24606.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Yurovsky reported that the driver forwarded erroneously the
parent device structure instead of the real thing, which of course
led to some dodgy sysfs links (at least?).

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
your usb(core) subsystem is probably built-in (rather than a module?),
so you won't have a "module" entry there.

BTW: currently, I don't have a device, please test!
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 754b1f8..1aec7af 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -779,7 +779,7 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 	aru->req_one_stage_fw = ar9170_requires_one_stage(id);
 
 	usb_set_intfdata(intf, aru);
-	SET_IEEE80211_DEV(ar->hw, &udev->dev);
+	SET_IEEE80211_DEV(ar->hw, &intf->dev);
 
 	init_usb_anchor(&aru->rx_submitted);
 	init_usb_anchor(&aru->tx_pending);

