Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:42205 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1FTLmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 07:42:36 -0400
Subject: [PATCH 2/6] zd1211rw: make 'handle_rx_packet: invalid,
	small RX packet' message debug-only
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 20 Jun 2011 14:42:33 +0300
Message-ID: <20110620114233.964.66390.stgit@localhost6.localdomain6> (sfid-20110620_134239_373732_13C586B5)
In-Reply-To: <20110620114228.964.35459.stgit@localhost6.localdomain6>
References: <20110620114228.964.35459.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This message is should be debug-only as it tells almost nothing useful. It also
happens very often and just floods logs.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 631194d..621c2cc 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -579,8 +579,8 @@ static void handle_rx_packet(struct zd_usb *usb, const u8 *buffer,
 
 	if (length < sizeof(struct rx_length_info)) {
 		/* It's not a complete packet anyhow. */
-		printk("%s: invalid, small RX packet : %d\n",
-		       __func__, length);
+		dev_dbg_f(zd_usb_dev(usb), "invalid, small RX packet : %d\n",
+					   length);
 		return;
 	}
 	length_info = (struct rx_length_info *)

