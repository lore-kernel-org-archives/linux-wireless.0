Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792586609;
	b=V5SSkfSsiQ+TbpHG5ud8FclPEzwA2uG5cVFqvcgGju7A7Hv4KnEUq/TaSbXdgGq0DcA7
	 4mcUlmdNOLJbHtDg28fxUvx31lnRTDjwhlDBD7QgSWvAH0sN3hh6L77dfvXAxF352xtQC
	 yiqJ9LO4STPpZqqHlTM6HFu75dDXw6J4ul50B23H4QBwQDcaISj8S52faqcwvkEEkJvXG
	 xiVFUPkHuGvDZ0f5RWBN58MTSXYBhyHiPSVR9+M2XN+ORJw7htNoDuWGeRHb4KGRJqhNV
	 5zLC+tBxWeGx+7uhMukTkYO6IH2WhvhWchMcmnBt1I2r4Vid8HI66ycmYDx1YH5LYIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792586609;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=yVNZZSadGNkiHgwUejJ+oZ1AP8pZeT+yOgCQ2Ky1I1Q=;
	b=zuEWeuQMteY7BHtCgiwqw3FNlNEMhr1kESVYFQGHKArnf7TLCfULMj2TXbdcawazyilm
	 9jeadxDh9rWCFLCUZWdmfbOgA8MZ9tBMANRGmyS2J8eB6Bpg1kTEO4LIVWPxbl7Ec/D34
	 D8aIy+mbKxt0Fo8upIEUmjAgxpJC12R/XiSbruZMt0JK4KLgH+gHKh2MEafxpqR7nBv6H
	 1vf8n2Oer05G+bpTmrKYKgNSqmW/q2AhWfYHW3yYxHLjYuodHG1wNrEhJ9VI6aMiIwkVn
	 FXdwUDNYi7Obn5XDM24Jo48kyPgip4qmXMSiZu+xV7MRXxF1mzhVrj30gKeVzrKJICw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PTq7V0aH;
	arc=none smtp.remote-ip=95.215.58.15
Received: from mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E828B606A31F
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 12:43:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E828B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PTq7V0aH
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2b7UP5bVvJTyTHBJgSMPXtUQxJU1oE51X65jYwd0Cq0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792586605; v=1; x=1793191405;
 b=PTq7V0aH4/t3yAC9ErS3WfFmvOqDuihn0NoERQcWRHOuYKpSUSOnwxG05SwJdfb4WkbffMjY
 MR2jvebDIk+ux0xszyYpH4+cagdrkIcDHNdOgf0mPewByAdocWUNsLFzSI6ylPfti1fILvUeXRI
 nmLdVbnk+2rwokJg0RMuzfkM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8664990cce9aee91;
	Wed, 21 Oct 2026 12:43:25 +0000
X-Mizu-Trace-ID: 8664990cce9aee91
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue decision to tx.c
Date: Wed, 21 Oct 2026 12:43:17 +0000
Message-ID: <20261021124318.15993-1-luka.gejak@linux.dev>
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

USB decides in usb.c which broadcast and multicast (bmc) frames may use
the high queue. SDIO needs the same decision, so move the helpers to
tx.c behind a single exported rtw_tx_bmc_use_hiq() and keep the budget
state in struct rtw_dev.

No functional change.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/main.c |  3 ++
 drivers/net/wireless/realtek/rtw88/main.h |  5 ++
 drivers/net/wireless/realtek/rtw88/tx.c   | 59 +++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/tx.h   |  4 ++
 drivers/net/wireless/realtek/rtw88/usb.c  | 64 ++---------------------
 drivers/net/wireless/realtek/rtw88/usb.h  |  5 --
 6 files changed, 74 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0f23498b5c96..b72173964bdd 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2177,6 +2177,9 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 
 	spin_lock_init(&rtwdev->txq_lock);
 	spin_lock_init(&rtwdev->tx_report.q_lock);
+	spin_lock_init(&rtwdev->hiq_lock);
+	rtwdev->hiq_budget = RTW_TX_HIQ_BUDGET_MAX;
+	rtwdev->hiq_refill = jiffies;
 
 	mutex_init(&rtwdev->mutex);
 	mutex_init(&rtwdev->hal.tx_power_mutex);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d59f6e323adf..c14c834c27fd 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2104,6 +2104,11 @@ struct rtw_dev {
 
 	struct rtw_tx_report tx_report;
 
+	/* protects hiq_budget and hiq_refill */
+	spinlock_t hiq_lock;
+	u32 hiq_budget;
+	unsigned long hiq_refill;
+
 	struct {
 		/* indicate the mail box to use with fw */
 		u8 last_box_num;
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 701ed7c4f3f7..82c1af94f1cc 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -2,6 +2,8 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include <linux/ip.h>
+#include <linux/udp.h>
 #include "main.h"
 #include "tx.h"
 #include "fw.h"
@@ -745,3 +747,60 @@ enum rtw_tx_queue_type rtw_tx_queue_mapping(struct sk_buff *skb)
 	return queue;
 }
 EXPORT_SYMBOL(rtw_tx_queue_mapping);
+
+static bool rtw_tx_bmc_needs_dtim(struct sk_buff *skb)
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
+static bool rtw_tx_hiq_take_budget(struct rtw_dev *rtwdev)
+{
+	unsigned long flags, elapsed, add;
+	bool ok;
+
+	spin_lock_irqsave(&rtwdev->hiq_lock, flags);
+
+	elapsed = jiffies - rtwdev->hiq_refill;
+	add = elapsed / RTW_TX_HIQ_REFILL_INTERVAL;
+	if (add) {
+		rtwdev->hiq_budget = min_t(unsigned long, rtwdev->hiq_budget + add,
+					   RTW_TX_HIQ_BUDGET_MAX);
+
+		/* keep the unfinished part of the interval for the next unit */
+		rtwdev->hiq_refill = jiffies - elapsed % RTW_TX_HIQ_REFILL_INTERVAL;
+	}
+
+	ok = rtwdev->hiq_budget > 0;
+	if (ok)
+		rtwdev->hiq_budget--;
+
+	spin_unlock_irqrestore(&rtwdev->hiq_lock, flags);
+
+	return ok;
+}
+
+bool rtw_tx_bmc_use_hiq(struct rtw_dev *rtwdev, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	return (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) &&
+	       rtw_tx_bmc_needs_dtim(skb) &&
+	       rtw_tx_hiq_take_budget(rtwdev);
+}
+EXPORT_SYMBOL(rtw_tx_bmc_use_hiq);
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index 168f48e87853..a68ba3b12159 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -10,6 +10,9 @@
 #define RTW_TX_PROBE_TIMEOUT_SHORT	msecs_to_jiffies(500)
 #define RTW_TX_PROBE_TIMEOUT_LONG	msecs_to_jiffies(2500)
 
+#define RTW_TX_HIQ_REFILL_INTERVAL	(HZ / 10)
+#define RTW_TX_HIQ_BUDGET_MAX		16
+
 struct rtw_tx_desc {
 	__le32 w0;
 	__le32 w1;
@@ -115,6 +118,7 @@ rtw_tx_write_data_h2c_get(struct rtw_dev *rtwdev,
 
 enum rtw_tx_queue_type rtw_tx_ac_to_hwq(enum ieee80211_ac_numbers ac);
 enum rtw_tx_queue_type rtw_tx_queue_mapping(struct sk_buff *skb);
+bool rtw_tx_bmc_use_hiq(struct rtw_dev *rtwdev, struct sk_buff *skb);
 
 static inline
 void fill_txdesc_checksum_common(u8 *txdesc, size_t words)
diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 715a2ce342d9..13adbd415158 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -2,10 +2,8 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
-#include <linux/ip.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/udp.h>
 #include <linux/usb.h>
 #include "main.h"
 #include "debug.h"
@@ -564,61 +562,10 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
 }
 
-static bool rtw_usb_bmc_needs_dtim(struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct udphdr *udphdr;
-
-	if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
-		return true;
-
-	if (skb->protocol == htons(ETH_P_ARP))
-		return true;
-
-	if (skb->protocol == htons(ETH_P_IP) &&
-	    ip_hdr(skb)->protocol == IPPROTO_UDP) {
-		udphdr = udp_hdr(skb);
-
-		return udphdr->dest == htons(67) || udphdr->dest == htons(68);
-	}
-
-	return false;
-}
-
-#define RTW_USB_HIQ_REFILL_INTERVAL	(HZ / 10)	/* one unit of budget per 100 ms */
-#define RTW_USB_HIQ_BUDGET_MAX		16
-
-static bool rtw_usb_hiq_take_budget(struct rtw_usb *rtwusb)
-{
-	unsigned long flags, elapsed, add;
-	bool ok;
-
-	spin_lock_irqsave(&rtwusb->hiq_lock, flags);
-
-	elapsed = jiffies - rtwusb->hiq_refill;
-	add = elapsed / RTW_USB_HIQ_REFILL_INTERVAL;
-	if (add) {
-		rtwusb->hiq_budget = min_t(unsigned long, rtwusb->hiq_budget + add,
-					   RTW_USB_HIQ_BUDGET_MAX);
-
-		/* keep the unfinished part of the interval for the next unit */
-		rtwusb->hiq_refill = jiffies - elapsed % RTW_USB_HIQ_REFILL_INTERVAL;
-	}
-
-	ok = rtwusb->hiq_budget > 0;
-	if (ok)
-		rtwusb->hiq_budget--;
-
-	spin_unlock_irqrestore(&rtwusb->hiq_lock, flags);
-
-	return ok;
-}
-
-static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
+static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_dev *rtwdev,
 					   struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	__le16 fc = hdr->frame_control;
 	u8 qsel;
 
@@ -626,8 +573,7 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
 		qsel = TX_DESC_QSEL_MGMT;
 	else if (is_broadcast_ether_addr(hdr->addr1) ||
 		 is_multicast_ether_addr(hdr->addr1))
-		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) &&
-		       rtw_usb_bmc_needs_dtim(skb) && rtw_usb_hiq_take_budget(rtwusb) ?
+		qsel = rtw_tx_bmc_use_hiq(rtwdev, skb) ?
 		       TX_DESC_QSEL_HIGH : skb->priority;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
@@ -647,7 +593,7 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
 	u8 *pkt_desc;
 	int ep;
 
-	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(rtwusb, skb);
+	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(rtwdev, skb);
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
 	ep = qsel_to_ep(rtwusb, pkt_info->qsel);
@@ -1088,10 +1034,6 @@ static int rtw_usb_init_tx(struct rtw_dev *rtwdev)
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 	int i;
 
-	spin_lock_init(&rtwusb->hiq_lock);
-	rtwusb->hiq_budget = RTW_USB_HIQ_BUDGET_MAX;
-	rtwusb->hiq_refill = jiffies;
-
 	rtwusb->txwq = create_singlethread_workqueue("rtw88_usb: tx wq");
 	if (!rtwusb->txwq) {
 		rtw_err(rtwdev, "failed to create TX work queue\n");
diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
index 94ff21dd0846..9b695b688b24 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -75,11 +75,6 @@ struct rtw_usb {
 	u8 out_ep[RTW_USB_EP_MAX];
 	int qsel_to_ep[TX_DESC_QSEL_MAX];
 
-	/* protects hiq_budget and hiq_refill */
-	spinlock_t hiq_lock;
-	u32 hiq_budget;
-	unsigned long hiq_refill;
-
 	struct workqueue_struct *txwq, *rxwq;
 
 	struct sk_buff_head tx_queue[RTW_USB_EP_MAX];
-- 
2.53.0

