Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:53247 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753055AbdKFOEi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 09:04:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rt2x00: use monotonic timestamps for frame dump
Date: Mon,  6 Nov 2017 15:03:59 +0100
Message-Id: <20171106140412.1532617-1-arnd@arndb.de> (sfid-20171106_150506_400794_07E0C355)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 uses the deprecated do_gettimeofday() function to get a timestamp
for its debugfs "dump" file interface.

The timestamp is using an unsigned 32-bit value, so we could make it
work until 2106 by using ktime_get_real_ts64(), but it seems better to
use monotonic times, as we normally want for timestamps.

Since this is an interface change, I'm incrementing the
DUMP_HEADER_VERSION number, so user space can figure out whether the
timestamps are monotonic or not. Most likely the tools won't care either
way.

Generally speaking, ABI version numbers and in particular changing them
is a bad idea. However since this is in debugfs, we don't put any
API stability rules on the interface according to
Documentation/filesystems/debugfs.txt, and we can take the easy way
out here; anyone using the frame dump feature can probably work out
the differences here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c | 7 ++++---
 drivers/net/wireless/ralink/rt2x00/rt2x00dump.h  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
index 51520a0e2138..f4fdad2ed319 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
@@ -164,13 +164,13 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	struct sk_buff *skbcopy;
 	struct rt2x00dump_hdr *dump_hdr;
-	struct timeval timestamp;
+	struct timespec64 timestamp;
 	u32 data_len;
 
 	if (likely(!test_bit(FRAME_DUMP_FILE_OPEN, &intf->frame_dump_flags)))
 		return;
 
-	do_gettimeofday(&timestamp);
+	ktime_get_ts64(&timestamp);
 
 	if (skb_queue_len(&intf->frame_dump_skbqueue) > 20) {
 		rt2x00_dbg(rt2x00dev, "txrx dump queue length exceeded\n");
@@ -200,7 +200,8 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr->queue_index = entry->queue->qid;
 	dump_hdr->entry_index = entry->entry_idx;
 	dump_hdr->timestamp_sec = cpu_to_le32(timestamp.tv_sec);
-	dump_hdr->timestamp_usec = cpu_to_le32(timestamp.tv_usec);
+	dump_hdr->timestamp_usec = cpu_to_le32(timestamp.tv_nsec /
+					       NSEC_PER_USEC);
 
 	if (!(skbdesc->flags & SKBDESC_DESC_IN_SKB))
 		skb_put_data(skbcopy, skbdesc->desc, skbdesc->desc_len);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dump.h b/drivers/net/wireless/ralink/rt2x00/rt2x00dump.h
index 4c0e01b5d515..3b14eef0b646 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dump.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dump.h
@@ -106,7 +106,7 @@ enum rt2x00_dump_type {
  */
 struct rt2x00dump_hdr {
 	__le32 version;
-#define DUMP_HEADER_VERSION	2
+#define DUMP_HEADER_VERSION	3
 
 	__le32 header_length;
 	__le32 desc_length;
-- 
2.9.0
