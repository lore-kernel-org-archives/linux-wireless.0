Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:49048 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590AbYATAOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 19:14:38 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 09/14] [usbnet] add driver_priv pointer to 'struct usbnet'
To: linux-wireless@vger.kernel.org
Cc: bjd@jooz.net, dbrownell@users.sourceforge.net,
	netdev@vger.kernel.org
Date: Sun, 20 Jan 2008 02:14:32 +0200
Message-ID: <20080120001432.25718.30378.stgit@fate.lan> (sfid-20080120_001443_415981_9213E503)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a private data pointer to usbnet for rndis_wext module to use.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/usb/usbnet.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/usbnet.h b/drivers/net/usb/usbnet.h
index 29ab92e..0b4bf09 100644
--- a/drivers/net/usb/usbnet.h
+++ b/drivers/net/usb/usbnet.h
@@ -31,6 +31,7 @@ struct usbnet {
 	struct usb_interface	*intf;
 	struct driver_info	*driver_info;
 	const char		*driver_name;
+	void			*driver_priv;
 	wait_queue_head_t	*wait;
 	struct mutex		phy_mutex;
 	unsigned char		suspend_count;

