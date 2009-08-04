Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27203 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733AbZHDVsU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 17:48:20 -0400
Subject: [PATCH] rt2x00: fix memory corruption in rf cache, add a sanity
 check
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 17:48:16 -0400
Message-Id: <1249422496.3489.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change rt2x00_rf_read() and rt2x00_rf_write() to subtract 1 from the rf
register number.  This is needed because the rf registers are enumerated
starting with one.  The size of the rf register cache is just enough to
hold all registers, so writing to the highest register was corrupting
memory.  Add a check to make sure that the rf register number is valid.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

That's the issue reported by Michael Buesch:
http://marc.info/?l=linux-wireless&m=124886312314098&w=2

With this patch and the patch to stop works on unload, rt73usb seems
rock solid now. 

 drivers/net/wireless/rt2x00/rt2x00.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index cbec91e..ee9afab 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -836,13 +836,15 @@ struct rt2x00_dev {
 static inline void rt2x00_rf_read(struct rt2x00_dev *rt2x00dev,
 				  const unsigned int word, u32 *data)
 {
-	*data = rt2x00dev->rf[word];
+	BUG_ON(word < 1 || word > rt2x00dev->ops->rf_size / sizeof(u32));
+	*data = rt2x00dev->rf[word - 1];
 }
 
 static inline void rt2x00_rf_write(struct rt2x00_dev *rt2x00dev,
 				   const unsigned int word, u32 data)
 {
-	rt2x00dev->rf[word] = data;
+	BUG_ON(word < 1 || word > rt2x00dev->ops->rf_size / sizeof(u32));
+	rt2x00dev->rf[word - 1] = data;
 }
 
 /*



-- 
Regards,
Pavel Roskin
