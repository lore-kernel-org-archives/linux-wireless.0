Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:58839 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997Ab1AaStL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:49:11 -0500
Subject: [PATCH 13/22] zd1211rw: batch beacon config commands together
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:49:05 +0200
Message-ID: <20110131184904.10044.29906.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacon config function writes beacon to hw one write per byte. This is very
slow (usually taking more than 100ms to finish) and causes high CPU usage
when in AP-mode (kworker at ~50% on Intel Atom N270). By batching commands
together zd_mac_config_beacon() runtime can be lowered to 1/5th and lower
CPU usage to saner levels (<10% on Atom).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   40 ++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 78c8f8b..84ee1b8 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -602,11 +602,18 @@ static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
-	int r, ret;
+	int r, ret, num_cmds, req_pos = 0;
 	u32 tmp, j = 0;
 	/* 4 more bytes for tail CRC */
 	u32 full_len = beacon->len + 4;
 	unsigned long end_jiffies, message_jiffies;
+	struct zd_ioreq32 *ioreqs;
+
+	/* Alloc memory for full beacon write at once. */
+	num_cmds = 1 + zd_chip_is_zd1211b(&mac->chip) + full_len;
+	ioreqs = kmalloc(num_cmds * sizeof(struct zd_ioreq32), GFP_KERNEL);
+	if (!ioreqs)
+		return -ENOMEM;
 
 	mutex_lock(&mac->chip.mutex);
 
@@ -637,29 +644,31 @@ static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
 		msleep(20);
 	}
 
-	r = zd_iowrite32_locked(&mac->chip, full_len - 1, CR_BCN_FIFO);
-	if (r < 0)
-		goto release_sema;
+	ioreqs[req_pos].addr = CR_BCN_FIFO;
+	ioreqs[req_pos].value = full_len - 1;
+	req_pos++;
 	if (zd_chip_is_zd1211b(&mac->chip)) {
-		r = zd_iowrite32_locked(&mac->chip, full_len - 1,
-					CR_BCN_LENGTH);
-		if (r < 0)
-			goto release_sema;
+		ioreqs[req_pos].addr = CR_BCN_LENGTH;
+		ioreqs[req_pos].value = full_len - 1;
+		req_pos++;
 	}
 
 	for (j = 0 ; j < beacon->len; j++) {
-		r = zd_iowrite32_locked(&mac->chip, *((u8 *)(beacon->data + j)),
-					CR_BCN_FIFO);
-		if (r < 0)
-			goto release_sema;
+		ioreqs[req_pos].addr = CR_BCN_FIFO;
+		ioreqs[req_pos].value = *((u8 *)(beacon->data + j));
+		req_pos++;
 	}
 
 	for (j = 0; j < 4; j++) {
-		r = zd_iowrite32_locked(&mac->chip, 0x0, CR_BCN_FIFO);
-		if (r < 0)
-			goto release_sema;
+		ioreqs[req_pos].addr = CR_BCN_FIFO;
+		ioreqs[req_pos].value = 0x0;
+		req_pos++;
 	}
 
+	BUG_ON(req_pos != num_cmds);
+
+	r = zd_iowrite32a_locked(&mac->chip, ioreqs, num_cmds);
+
 release_sema:
 	/*
 	 * Try very hard to release device beacon semaphore, as otherwise
@@ -694,6 +703,7 @@ release_sema:
 				CR_BCN_PLCP_CFG);
 out:
 	mutex_unlock(&mac->chip.mutex);
+	kfree(ioreqs);
 	return r;
 }
 

