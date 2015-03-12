Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:51231 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbbCLOf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 10:35:56 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/3] rt2x00usb: initialize the read value in case of failure
Date: Thu, 12 Mar 2015 15:35:44 +0100
Message-Id: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de> (sfid-20150312_153600_304688_C38A1595)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My understanding ist that rt2x00usb_register_read() is void and so the
reader is unaware of read errors and assumes that whatever was on the
stack as it was about to read.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/rt2x00/rt2x00usb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 8f85fbd5f237..569363da00a2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -199,7 +199,7 @@ static inline void rt2x00usb_register_read(struct rt2x00_dev *rt2x00dev,
 					   const unsigned int offset,
 					   u32 *value)
 {
-	__le32 reg;
+	__le32 reg = 0;
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
 				      USB_VENDOR_REQUEST_IN, offset,
 				      &reg, sizeof(reg));
@@ -219,7 +219,7 @@ static inline void rt2x00usb_register_read_lock(struct rt2x00_dev *rt2x00dev,
 						const unsigned int offset,
 						u32 *value)
 {
-	__le32 reg;
+	__le32 reg = 0;
 	rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
 				       USB_VENDOR_REQUEST_IN, offset,
 				       &reg, sizeof(reg), REGISTER_TIMEOUT);
-- 
2.1.4

