Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792523763;
	b=mvVscuExQ/hTBF/z2ADZcVlwEGJVHPo5Wh8DDd/kvGgaIYrdOwcEcEnbvW/ZeavgETrj
	 gVJ4juYrQlCy1e7IIp2IO0WDA2H26b7PgFNU6O8mPoWDqqKcSEwdObMcy7Tzo1H6AHaUN
	 UEbDz62REQOHH1pU1hU7pwxcog9tse8uAYTnecEN2pIpOonHmXH+6klobtlp/dBhugF99
	 VZP9mYG8KS4zFs44DFrJOTpv43EdVX2FYiBZOJRiD1r7QT4/fw7C5aQD0TkCyA9Q50/1w
	 /bNrgdjmhjv6DfwPv40zBIHR3vI1Uae5Z5tKnO3J7sD4fe753AlbRFVZDuj3XDJYocQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792523763;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=rUBxrQOgUlEswmxtd++Iy4KjUau7aWkHYzp/PeXcZ3g=;
	b=REjZEdo505gXeuIiACs1ysEw2prjqpl2yIJz3m1upzkGP2kyK40cqARZZyB7HYGiiqWZ
	 WFPCdRKY7/0BuTCaSM9Vt0Gp/BNUpTVDT6HKHKPygXLBBkp7eqeP49rtUX9dhQSFBWiBa
	 Zoxvly2ovLDWI1KiMItJX8B1cGHIrBpqGDeY8yEo14A3U8/iMnwsLzQAOyRc03cgOh2vZ
	 HG3E5ddYmVbMQbHvsTSjAs0khsaiCMAUOwiBZESbfSLAbQ02rsQ55yuy9AMsRvvHEqr3y
	 Sdx16zaQYPQg2MotX1UouPl8NVyzThHqBXow7P8qu3PEPimAyg1oEaMuQGPgdCFQj4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="aY3gv/bH";
	arc=none smtp.remote-ip=95.215.58.225
Received: from mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885F4606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 19:16:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 885F4606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aY3gv/bH
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lw+t75FwRLjeMhJnNzMlndW0v6yjeCQr5HI2l/gOvaQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792523758; v=1; x=1793128558;
 b=aY3gv/bHVOHntPRPOB2o+HLJbggVPhSRWDtI2wqRDJ6NQtlTqmGsZV80Wet43qPM300SMyTl
 S6OVPI1KTUh2rLsd/V4BIuDiXz5bW/EtuJaCbhSS8dxokV9aKv+cYUXJIAUMaT9AmPAPnda5wbW
 3q4mu9UfW6T3o7YOF/NDNKck=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id eecc7a7145419b5d;
	Tue, 20 Oct 2026 19:15:58 +0000
X-Mizu-Trace-ID: eecc7a7145419b5d
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next] wifi: rtw88: sdio: limit the high queue to DTIM delivery
Date: Tue, 20 Oct 2026 19:15:42 +0000
Message-ID: <20261020191542.17207-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In AP mode every broadcast and multicast (bmc) frame is sent through the
high queue, which the hardware only drains after a DTIM beacon. Only a
few frames leave per DTIM, so steady multicast traffic builds a backlog
that holds the TX pages the other queues need. Unicast traffic then
stalls for seconds and clients can no longer renew their DHCP lease.

USB had the same problem and was fixed by commit c710c7c2e038 ("wifi:
rtw88: usb: route bmc frames via the high queue only for DTIM delivery")
and the two commits that followed it. Use the same rule for SDIO. A bmc
frame goes to the high queue only when mac80211 asks for DTIM delivery
because a station is dozing, the frame is ARP, EAPOL or DHCP, and the
budget allows it. All other bmc frames go out on their access category
queue.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
  Tested on rtl8723bs with atk19 client. No regression in station mode.
  Note: this adds support for AP mode for rtl8723bs, as I states AP
  mode was left for future work.
- Broadcast ping round trip was 3.6 ms, it was ~104 ms before the
    patch.
  - During a 50 frames/s broadcast flood, the TX page pool didn't
    move and unicast was unaffected.
  - A DHCP renewal under that load got a lease on the first DISCOVER.
  - A dozing client received 18 of 20 broadcast ARP requests.

 drivers/net/wireless/realtek/rtw88/sdio.c | 69 +++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/sdio.h |  5 ++
 2 files changed, 74 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index dc2fd0f8f9ff..3cdffac5b5b0 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -6,9 +6,11 @@
  *   Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include <linux/ip.h>
 #include <linux/module.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/sdio_func.h>
+#include <linux/udp.h>
 #include "main.h"
 #include "mac.h"
 #include "debug.h"
@@ -26,6 +28,8 @@
 #define RTW_SDIO_TX_FIFO_HIWATER			16
 #define RTW_SDIO_TX_FIFO_LOWATER			8
 #define RTW_SDIO_TX_RETRY_DELAY			msecs_to_jiffies(1)
+#define RTW_SDIO_HIQ_REFILL_INTERVAL			(HZ / 10)
+#define RTW_SDIO_HIQ_BUDGET_MAX				16
 
 static bool rtw_sdio_is_bus_addr(u32 addr)
 {
@@ -1299,6 +1303,64 @@ static void rtw_sdio_8723bs_wake_tx_queue(struct rtw_dev *rtwdev,
 	ieee80211_wake_queue(rtwdev->hw, q_map);
 }
 
+static bool rtw_sdio_bmc_needs_dtim(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct udphdr *udphdr;
+
+	if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
+		return true;
+
+	if (skb->protocol == htons(ETH_P_ARP))
+		return true;
+
+	if (skb->protocol == htons(ETH_P_IP) &&
+	    ip_hdr(skb)->protocol == IPPROTO_UDP) {
+		udphdr = udp_hdr(skb);
+
+		return udphdr->dest == htons(67) || udphdr->dest == htons(68);
+	}
+
+	return false;
+}
+
+static bool rtw_sdio_hiq_take_budget(struct rtw_sdio *rtwsdio)
+{
+	unsigned long flags, elapsed, add;
+	bool ok;
+
+	spin_lock_irqsave(&rtwsdio->hiq_lock, flags);
+
+	elapsed = jiffies - rtwsdio->hiq_refill;
+	add = elapsed / RTW_SDIO_HIQ_REFILL_INTERVAL;
+	if (add) {
+		rtwsdio->hiq_budget = min_t(unsigned long,
+					    rtwsdio->hiq_budget + add,
+					    RTW_SDIO_HIQ_BUDGET_MAX);
+
+		/* keep the unfinished part of the interval for the next unit */
+		rtwsdio->hiq_refill = jiffies -
+				      elapsed % RTW_SDIO_HIQ_REFILL_INTERVAL;
+	}
+
+	ok = rtwsdio->hiq_budget > 0;
+	if (ok)
+		rtwsdio->hiq_budget--;
+
+	spin_unlock_irqrestore(&rtwsdio->hiq_lock, flags);
+
+	return ok;
+}
+
+static bool rtw_sdio_bmc_use_hiq(struct rtw_sdio *rtwsdio, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	return (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) &&
+	       rtw_sdio_bmc_needs_dtim(skb) &&
+	       rtw_sdio_hiq_take_budget(rtwsdio);
+}
+
 static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 			     struct rtw_tx_pkt_info *pkt_info,
 			     struct sk_buff *skb)
@@ -1308,6 +1370,9 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 	u16 q_map = skb_get_queue_mapping(skb);
 	struct rtw_sdio_tx_data *tx_data;
 
+	if (queue == RTW_TX_QUEUE_HI0 && !rtw_sdio_bmc_use_hiq(rtwsdio, skb))
+		queue = rtw_tx_ac_to_hwq(q_map);
+
 	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
 
 	tx_data = rtw_sdio_get_tx_data(skb);
@@ -1730,6 +1795,10 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	int i;
 
+	spin_lock_init(&rtwsdio->hiq_lock);
+	rtwsdio->hiq_budget = RTW_SDIO_HIQ_BUDGET_MAX;
+	rtwsdio->hiq_refill = jiffies;
+
 	rtwsdio->txwq = create_singlethread_workqueue("rtw88_sdio: tx wq");
 	if (!rtwsdio->txwq) {
 		rtw_err(rtwdev, "failed to create TX work queue\n");
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 6e7e6009744b..2083e6fb3fa9 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.h
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -174,6 +174,11 @@ struct rtw_sdio {
 	struct sk_buff_head tx_queue[RTK_MAX_TX_QUEUE_NUM];
 	bool tx_queue_stopped[RTK_MAX_TX_QUEUE_NUM];
 
+	/* protects hiq_budget and hiq_refill */
+	spinlock_t hiq_lock;
+	u32 hiq_budget;
+	unsigned long hiq_refill;
+
 	atomic_t free_pg_high;
 	atomic_t free_pg_normal;
 	atomic_t free_pg_low;
-- 
2.53.0

