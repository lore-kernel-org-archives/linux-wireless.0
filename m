Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([84.10.57.10]:37136 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbdDFDtF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 23:49:05 -0400
Message-Id: <679bea0b3868e3b8fa64c7948eb7cdbfb405d514.1491450385.git.mirq-linux@rere.qmqm.pl> (sfid-20170406_054914_383870_FD45B264)
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH v2] NFC: pn533: use constant off-stack buffer for sending acks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Michael Thalmeier <michael.thalmeier@hale.at>
Date: Thu,  6 Apr 2017 05:49:02 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix for WARN:

usb 3-2.4.1: NFC: Exchanging data failed (error 0x13)
llcp: nfc_llcp_recv: err -5
llcp: nfc_llcp_symm_timer: SYMM timeout
------------[ cut here ]------------
WARNING: CPU: 1 PID: 26397 at .../drivers/usb/core/hcd.c:1584 usb_hcd_map_urb_for_dma+0x370/0x550
transfer buffer not dma capable
[...]
Workqueue: events nfc_llcp_timeout_work [nfc]
Call Trace:
 ? dump_stack+0x46/0x5a
 ? __warn+0xb9/0xe0
 ? warn_slowpath_fmt+0x5a/0x80
 ? usb_hcd_map_urb_for_dma+0x370/0x550
 ? usb_hcd_submit_urb+0x2fb/0xa60
 ? dequeue_entity+0x3f2/0xc30
 ? pn533_usb_send_ack+0x5d/0x80 [pn533_usb]
 ? pn533_usb_abort_cmd+0x13/0x20 [pn533_usb]
 ? pn533_dep_link_down+0x32/0x70 [pn533]
 ? nfc_dep_link_down+0x87/0xd0 [nfc]
[...]
usb 3-2.4.1: NFC: Exchanging data failed (error 0x13)
llcp: nfc_llcp_recv: err -5
llcp: nfc_llcp_symm_timer: SYMM timeout

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
v2:
	- "un-moved" other declarations
	- rebased against nfc-next
---
 drivers/nfc/pn533/i2c.c | 2 +-
 drivers/nfc/pn533/usb.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 2c2fb9cfe10a..8f60ce039b0d 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -51,7 +51,7 @@ static int pn533_i2c_send_ack(struct pn533 *dev, gfp_t flags)
 {
 	struct pn533_i2c_phy *phy = dev->phy;
 	struct i2c_client *client = phy->i2c_dev;
-	u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
+	static const u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
 	/* spec 6.2.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
 	int rc;
 
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 000159ea9c5f..8ed203ea21ea 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -148,11 +148,11 @@ static int pn533_submit_urb_for_ack(struct pn533_usb_phy *phy, gfp_t flags)
 static int pn533_usb_send_ack(struct pn533 *dev, gfp_t flags)
 {
 	struct pn533_usb_phy *phy = dev->phy;
-	u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
+	static const u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
 	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
 	int rc;
 
-	phy->out_urb->transfer_buffer = ack;
+	phy->out_urb->transfer_buffer = (u8 *)ack;
 	phy->out_urb->transfer_buffer_length = sizeof(ack);
 	rc = usb_submit_urb(phy->out_urb, flags);
 
-- 
2.11.0
