Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64595 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754582AbcI1X6u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 19:58:50 -0400
From: Thomas Pedersen <twp@qca.qualcomm.com>
To: ath10k <ath10k@lists.infradead.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <twp@qca.qualcomm.com>
Subject: [PATCH 4/4] mac80211: mesh: decrease max drift
Date: Wed, 28 Sep 2016 16:56:31 -0700
Message-ID: <20160928235631.9197-5-twp@qca.qualcomm.com> (sfid-20160929_015853_808488_58FF195B)
In-Reply-To: <20160928235631.9197-1-twp@qca.qualcomm.com>
References: <20160928235631.9197-1-twp@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old value was 30ms, which means mesh sync will treat
any value below as merely TSF drift. This isn't really
reasonable (typical drift is < 10us/s) since people
probably want to adjust TSF in smaller increments (for ie.
beacon collision avoidance) without mesh sync fighting
back.

Change max drift adjustment to 0.8ms, so manual TSF
adjustments can be made in 1ms increments, with some
margin.

Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>
---
 net/mac80211/mesh_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 22ca43c..faca22c 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -28,7 +28,7 @@
  * could be, for instance, in case a neighbor is restarted and its TSF counter
  * reset.
  */
-#define TOFFSET_MAXIMUM_ADJUSTMENT 30000		/* 30 ms */
+#define TOFFSET_MAXIMUM_ADJUSTMENT 800		/* 0.8 ms */
 
 struct sync_method {
 	u8 method;
-- 
2.10.0.297.gf6727b0
