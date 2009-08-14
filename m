Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55882 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbZHNLAf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 07:00:35 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -stable] rt2x00: fix memory corruption in rf cache, add a sanity check
Date: Fri, 14 Aug 2009 12:59:08 +0200
Message-Id: <1250247548-3429-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Roskin <proski@gnu.org>

Change rt2x00_rf_read() and rt2x00_rf_write() to subtract 1 from the rf
register number.  This is needed because the rf registers are enumerated
starting with one.  The size of the rf register cache is just enough to
hold all registers, so writing to the highest register was corrupting
memory.  Add a check to make sure that the rf register number is valid.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
I think nobody send this patch against stable yet. I have problem with
rt73usb memory corruption on 2.6.30, this patch solve it. Not sure if 
patch is also useful for 2.6.27. 

 drivers/net/wireless/rt2x00/rt2x00.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 84bd6f1..c242b54 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -814,13 +814,15 @@ struct rt2x00_dev {
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
1.6.2.5

