Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:48861 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943Ab1AaSuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:50:37 -0500
Subject: [PATCH 22/22] zd1211rw: add useful debug output
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:50:31 +0200
Message-ID: <20110131185031.10044.29389.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 5cedfea..4e6c06a 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -411,8 +411,10 @@ static void int_urb_complete(struct urb *urb)
 	case -ENOENT:
 	case -ECONNRESET:
 	case -EPIPE:
+		dev_dbg_f(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
 		return;
 	default:
+		dev_dbg_f(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
 		goto resubmit;
 	}
 
@@ -613,6 +615,7 @@ static void handle_rx_packet(struct zd_usb *usb, const u8 *buffer,
 
 static void rx_urb_complete(struct urb *urb)
 {
+	int r;
 	struct zd_usb *usb;
 	struct zd_usb_rx *rx;
 	const u8 *buffer;
@@ -627,6 +630,7 @@ static void rx_urb_complete(struct urb *urb)
 	case -ENOENT:
 	case -ECONNRESET:
 	case -EPIPE:
+		dev_dbg_f(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
 		return;
 	default:
 		dev_dbg_f(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
@@ -668,7 +672,9 @@ static void rx_urb_complete(struct urb *urb)
 	}
 
 resubmit:
-	usb_submit_urb(urb, GFP_ATOMIC);
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+	if (r)
+		dev_dbg_f(urb_dev(urb), "urb %p resubmit error %d\n", urb, r);
 }
 
 static struct urb *alloc_rx_urb(struct zd_usb *usb)
@@ -1001,6 +1007,7 @@ int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r) {
+		dev_dbg_f(zd_usb_dev(usb), "error submit urb %p %d\n", urb, r);
 		usb_unanchor_urb(urb);
 		skb_unlink(skb, &tx->submitted_skbs);
 		goto error;

