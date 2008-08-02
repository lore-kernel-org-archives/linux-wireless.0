Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:40276 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYHBF0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 01:26:24 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1466365ika.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 22:26:23 -0700 (PDT)
To: David Miller <davem@davemloft.net>
Subject: [PATCH] rt2x00: Fix compile warning
Date: Sat, 2 Aug 2008 07:49:08 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808020749.08431.IvDoorn@gmail.com> (sfid-20080802_072628_873802_7FB3BB97)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00usb_vendor_request_large_buff is write-only, so it is
safe to make the argument a const.

Fixes compile warning:
drivers/net/wireless/rt2x00/rt73usb.c: In function 'rt73usb_load_firmware':
drivers/net/wireless/rt2x00/rt73usb.c:916: warning: passing argument 5 of 'rt2x00usb_vendor_request_large_buff' discards qualifiers from pointer target typ

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00usb.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 933e6cc..8d76bb2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_buff);
 
 int rt2x00usb_vendor_request_large_buff(struct rt2x00_dev *rt2x00dev,
 					const u8 request, const u8 requesttype,
-					const u16 offset, void *buffer,
+					const u16 offset, const void *buffer,
 					const u16 buffer_length,
 					const int timeout)
 {
@@ -134,7 +134,7 @@ int rt2x00usb_vendor_request_large_buff(struct rt2x00_dev *rt2x00dev,
 
 	mutex_lock(&rt2x00dev->usb_cache_mutex);
 
-	tb  = buffer;
+	tb  = (char *)buffer;
 	off = offset;
 	len = buffer_length;
 	while (len && !status) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index ee3875f..3b4a674 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -185,7 +185,7 @@ int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
  */
 int rt2x00usb_vendor_request_large_buff(struct rt2x00_dev *rt2x00dev,
 					const u8 request, const u8 requesttype,
-					const u16 offset, void *buffer,
+					const u16 offset, const void *buffer,
 					const u16 buffer_length,
 					const int timeout);
 
-- 
1.5.6.1

