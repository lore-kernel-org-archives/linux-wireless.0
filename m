Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793723192;
	b=cCYM+8YoLVmQanmsqGQuT4cQn/uqEokbuU+nAAUIgS5DYmk8jpHFtQmtqqXoEe9tjU4V
	 oIU0Pj28pXLhNcE3+tvm+NEIgA0A+Ys+4D3dcLKv7j0mERhJZnPLjn6BOkvWspvIkb6ek
	 02d/bDo0BUr5KxT/6Sqg1BWjos/CQOUrxAqRi2LmlUHZt4X2TxyCN/psPH3yr7aFF957u
	 TFjho+q7Lyc8PIx8ZrlL5r9ToHc6cmqXcP2LoqfPTw/umbbvEtMXnSWoAB5G5LTJ19NSx
	 oclw5rEgpO2OVeJEeLypeHdhGxq6UE5FBJdMeiEd6ng73cMfRAdAkxS9xfJS/sb+/Fg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723192;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Message-Id:
	 In-Reply-To:References:Subject:MIME-Version:Content-Type:Importance:
	 User-Agent:X-Mailer:X-Zoho-Virus-Status:X-Zoho-AV-Stamp;
	bh=zCw7Xbz5zcSKtviW3A+koyateGcAfHH1zbxvtcOCrk8=;
	b=E7iMZ5ilC5z8KF3uRyx0f1amhGw5Rjq9SZLO5XzpfO4QyQj749mSF0S0wQBmnmuiVg7d
	 GVhqGpkZXxi8VHD7A56xMZ0iJenspZbOgd5N+K4kaVslTUX2x4j8molErdbrGuCZo9/uD
	 gqUZu/cAVi+ZDCQpVsAK5sAE2l2RNbsrP872vm3EJLbtjFT77ZxcAQUDg65ZR+J/Nb/Cp
	 hXtWYxZFZcb3C9SJA2IqQTFr3Ayc5UDiuEEhNS9uWLGO7dDLEW6uAAR9u3KKv9zSaEL8P
	 Ds3jJUcGSaxU1bTEoY3ClPupvj7PHRrak2trDZA/PuObVYwhlQtmVCOJhJE3JGf4fsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=zohomail header.b="ikxqyV+/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.11
Received: from sender6-op-o11.zoho.com (sender6-op-o11.zoho.com [165.173.180.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73183606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73183606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=zohomail header.b=ikxqyV+/
ARC-Seal: i=1; a=rsa-sha256; t=1793723182; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=G1I47DdjILT+E3vuh1rBs6u2BdVDAi1UkI9LfLB7CyumFgPgIw9TQ25buekXZH6ne48LYKLBjM0N4NVWZyzCZoK1JK3UDBaWGfaTgayMbmCK46M3pE/9ajTB739G1BUlDRzF8XMsEqtV2S5eATHd/9uaFGBMGig3/Dvwttwr+TU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793723182; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=zCw7Xbz5zcSKtviW3A+koyateGcAfHH1zbxvtcOCrk8=; 
	b=RRbrHsOwQTXZYXj0HBEnE9GSqt6pCOi6PVn4lICcR9CSwzl5y7pWpuQoMYwcBUBNwopVyDdwY7ym0mH+bGyD2tSh9elCO/Ls7lZgsWuO4uhVK1GuzWXPqhU9vBCDHNIxEQcbpP+yC6bDQr+rEgkp4pjkl6SBF7YfnDUDfQuIz0k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=bob.beckett@collabora.com;
	dmarc=pass header.from=<bob.beckett@collabora.com>
DKIM-Signature: a=rsa-sha256; b=ikxqyV+/UH6gQaYOOR9WEFa+1ZRMIL4+HhufS5dMEIG8GRv/fhj5C+UhlOE6ckQjKhEdanH9O9QgHmYJV47zWtaFwahA0T5r/XMf2hWZRxFlYE85HQ+jr7sNWVQuSVjXZpdJTf5+vc/NGxH0F6/qKUcr1hR+DOvJL+2O6Yc8s/U=; c=relaxed/relaxed; s=zohomail; d=collabora.com; v=1; bh=zCw7Xbz5zcSKtviW3A+koyateGcAfHH1zbxvtcOCrk8=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1793723149867137.60083671115615; Tue, 3 Nov 2026 08:25:49 -0800 (PST)
Date: Tue, 03 Nov 2026 16:25:49 +0000
From: Robert Beckett <bob.beckett@collabora.com>
To: "Bernie Huang" <phhuang@realtek.com>
Cc: "Ping-Ke Shih" <pkshih@realtek.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luka Gejak" <luka.gejak@linux.dev>,
	"Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
	"Timlee" <timlee@realtek.com>,
	"matthew.leach@collabora.com" <matthew.leach@collabora.com>,
	"kernel@collabora.com" <kernel@collabora.com>
Message-Id: <1a1a23b2de6.dd9d2b0431720.4311994153284342881@collabora.com>
In-Reply-To: <527f96d6034f43d481c3bbacf0313f3a@realtek.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com> <20261021190529.3893821-1-bob.beckett@collabora.com> <90c40c3223c34562b2c171c52d987c2e@realtek.com> <1a163984687.46e4c9841111898.2085291868591283475@collabora.com> <527f96d6034f43d481c3bbacf0313f3a@realtek.com>
Subject: RE: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted,
 poisoning CCMP replay counter
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_1462835_954143849.1793723149798"
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-0.2.13.1.5.4/293.698.2

------=_Part_1462835_954143849.1793723149798
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit






From: Bernie Huang <phhuang@realtek.com>
To: "Robert Beckett"<bob.beckett@collabora.com>, "Ping-Ke Shih"<pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org"<linux-wireless@vger.kernel.org>, "Luka Gejak"<luka.gejak@linux.dev>, "Bitterblue Smith"<rtl8821cerfe2@gmail.com>, "Timlee"<timlee@realtek.com>, "matthew.leach@collabora.com"<matthew.leach@collabora.com>, "kernel@collabora.com"<kernel@collabora.com>
Date: Mon, 02 Nov 2026 09:27:43 +0000
Subject: RE: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted, poisoning CCMP replay counter

 > Bob Beckett <bob.beckett@collabora.com> wrote:
 > >  > > On Wed, 21 Oct 2026 07:30:58 +0000, Ping-Ke Shih
 > > <pkshih@realtek.com> wrote:
 > >  > > > Bob Beckett <bob.beckett@collabora.com> wrote:
 > >  > > > >
 > >  > > > > The AP's own PN sequence is consistent before and after the bad
 > > frame,  > > > > so the corruption happens on the receive side.
 > >  > > >
 > >  > > > Maybe this is a hint to make a patch to defer (drop) reporting weird
 > > packet,  > > > as Luka has fixed 3 of 4 problems.
 > >  >
 > >  > I quickly checked the debug patches, which seem not detect if PN sequence
 > > is  > correct after the bad frame, for example
 > >  >   seq     PN
 > >  >    1      101
 > >  >    2      99999   // bad frame. should be 102.
 > >  >    3      103     // not detect this
 > >  >
 > >  > Or I missed something?
 > > 
 > > if pn jumps, rtw_rx_pn_guard returns early before latching pn, so the next
 > > corrected pn would just be a regular increase and not get dropped.
 > > 
 > >  >
 > >  > > > > 4. For completeness: on these chips can RXBD_IDX or the
 > >  > > > >    buffer-descriptor RX tag ever be updated before the packet data
 > > DMA
 > >  > > > >    has completed, as described for WiFi 7 in rtw89 0bc7d1d4e63c?
 > >  > > >
 > >  > > > The RX tag in rtw88 located on memory allocated by
 > > dma_alloc_coherent(), and  > > > the RX tag must be set after packet data
 > > MAC completed.
 > >  >
 > >  > (fix typo:                          ... data DMA completed.)
 > >  >
 > >  > >
 > >  > > Understood that this is the design intent. My question was whether the
 > > host can  > > ever observe the tag before the data. dma_alloc_coherent()
 > > only makes the tag  > > visible to the CPU without cache maintenance; the
 > > payload is in a separate  > > streaming mapping (a SWIOTLB bounce buffer on
 > > this platform), so the order in  > > which the host sees them depends on the
 > > order of the device's PCIe writes.
 > >  > > Relaxed Ordering is enabled on the 8822CE here (DevCtl RlxdOrd+).
 > >  > > Does the 8822CE set the RO attribute on RX DMA writes, in particular the
 > > > > buffer-descriptor/tag update? If it does, the tag write may pass the payload
 > > > > writes.
 > >  > >
 > >  > > We are hoping to test this directly with the next round of tests. the
 > > rx_debug  > > option re-syncs a suspect buffer 100 us later, so late payload
 > > writes might  > > show up as changed bytes, and we can repeat the test with
 > > Relaxed Ordering  > > disabled.
 > >  >
 > >  > I'll check the behavior internally and get back to you.
 > >  >
 > >  >
 > >  >
 > > 
 > 
 > // Please ignore the previous two emails
 > 
 > Hi Bob,
 > 
 > Do you mind testing this patch?
 > Reproduce again with the same ftrace and sniffer logs
 > By the result we can differentiate which is the case:
 > (1) AP sends incorrect CCMP header (less likely)
 > (2) DMA incomplete, but later the correct data can be retrieved
 > (3) DMA incomplete, data never recovers
 > 
 > IIUC, our hardware writes payload first then the tag.
 > The RO attribute is never set in our TLP, so despite the configuration
 > space settings, PCIE RC shouldn't do reordering.
 > I am waiting for protocol analyzer to verify this, and will update 
 > later when I have the result.
 > If the buffer poisoning somehow changes the timing, and fail becomes
 > not reproducible, please let us know, thanks!
 > 

I can't test this yet, only an end cusomer is able to repro on their router so far.
I have the previous patches included in the next version going out to customers soon, but it takes time currently.
The good news is that I managed to find one of the affected routers on ebay France. It should be with me my end of the week and I'll be able to try reproducing the issue myself and debug much more quickly from then.
Once I have the device, I'll test with your patch and report back in due course.

------=_Part_1462835_954143849.1793723149798
Content-Type: application/octet-stream; 
	name=0001-wifi-rtw88-test-for-stale-packet.patch
Content-Transfer-Encoding: 7bit
X-ZM_AttachId: 140129044732830020
Content-Disposition: attachment; 
	filename=0001-wifi-rtw88-test-for-stale-packet.patch

From 41175f8e54a044a5a0e273e3ac9b91e8866fcdf0 Mon Sep 17 00:00:00 2001
From: Po-Hao Huang <phhuang@realtek.com>
Date: Mon, 2 Nov 2026 17:26:31 +0800
Subject: [PATCH] wifi: rtw88: test for stale packet

Fellow developers found evidence that DMA operations might
be incomplete during debugging. e.g. Rx tag is new but the
remaining Rx buffer is old data.
Since protocol anaylzer is not available at the moment,
write the Rx buffer to a magic number after each use, and check
for more convincing evidence for further troubleshooting.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 101 ++++++++++++++++++++++-
 1 file changed, 97 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 66d2e5f51444..815087789b93 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -15,6 +15,10 @@
 #include "debug.h"
 #include "mac.h"
 
+#define RTW_PCI_RX_POISON		0xDEADBEEF
+#define RTW_PCI_RX_POISON_LEN		256
+#define RTW_PCI_RX_POISON_TIMEOUT	100
+
 static bool rtw_disable_msi;
 static bool rtw_pci_disable_aspm;
 module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
@@ -207,6 +211,94 @@ static int rtw_pci_init_tx_ring(struct rtw_dev *rtwdev,
 	return 0;
 }
 
+static void rtw_pci_rx_poison(struct sk_buff *skb)
+{
+	memset32((u32 *)skb->data, RTW_PCI_RX_POISON,
+		 RTW_PCI_RX_POISON_LEN / 4);
+}
+
+static bool rtw_pci_rx_range_poisoned(struct rtw_dev *rtwdev,
+				      struct sk_buff *skb, u32 start, u32 len)
+{
+	u32 *word = (u32 *)skb->data;
+	u32 i, first = start / 4, last = DIV_ROUND_UP(start + len, 4);
+
+	if (!len)
+		return false;
+
+	for (i = first; i < last; i++)
+		if (READ_ONCE(word[i]) == RTW_PCI_RX_POISON) {
+			rtw_warn(rtwdev, "rx buffer still 0xdeadbeef\n");
+			return true;
+		}
+
+	return false;
+}
+
+static bool rtw_pci_rx_stale(struct rtw_dev *rtwdev, struct sk_buff *skb)
+{
+	struct rtw_rx_desc *rx_desc = (void *)skb->data;
+	u32 desc_sz = rtwdev->chip->rx_pkt_desc_sz;
+	u8 drv_info_sz, shift, enc_type;
+	struct ieee80211_hdr *hdr;
+	u32 pkt_len, offset, len;
+	bool is_c2h;
+	__le16 fc;
+
+	if (rtw_pci_rx_range_poisoned(rtwdev, skb, 0, desc_sz))
+		return true;
+
+	pkt_len = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_PKT_LEN);
+	drv_info_sz = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_DRV_INFO_SIZE);
+	shift = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_SHIFT);
+	offset = desc_sz + drv_info_sz * 8 + shift;
+	if (offset >= RTW_PCI_RX_POISON_LEN)
+		return false;
+
+	is_c2h = le32_get_bits(rx_desc->w2, RTW_RX_DESC_W2_C2H);
+	if (is_c2h) {
+		len = min_t(u32, pkt_len, 4);
+	} else if (pkt_len < sizeof(fc)) {
+		len = pkt_len;
+	} else {
+		if (rtw_pci_rx_range_poisoned(rtwdev, skb, offset, sizeof(fc)))
+			return true;
+
+		hdr = (struct ieee80211_hdr *)(skb->data + offset);
+		fc = hdr->frame_control;
+		len = ieee80211_hdrlen(fc);
+
+		enc_type = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_ENC_TYPE);
+		if (ieee80211_has_protected(fc) && enc_type == RX_DESC_ENC_AES)
+			len += IEEE80211_CCMP_HDR_LEN;
+		len = min(len, pkt_len);
+	}
+
+	len = min(len, RTW_PCI_RX_POISON_LEN - offset);
+
+	return rtw_pci_rx_range_poisoned(rtwdev, skb, offset, len);
+}
+
+static void rtw_pci_rx_sync_and_wait_fresh(struct rtw_dev *rtwdev,
+					   struct sk_buff *skb, dma_addr_t dma)
+{
+	ktime_t deadline = ktime_add_ms(ktime_get(), RTW_PCI_RX_POISON_TIMEOUT);
+
+	dma_sync_single_for_cpu(rtwdev->dev, dma, RTK_PCI_RX_BUF_SIZE,
+				DMA_FROM_DEVICE);
+
+	while (rtw_pci_rx_stale(rtwdev, skb)) {
+		if (!ktime_before(ktime_get(), deadline)) {
+			rtw_warn(rtwdev, "rx buffer still poisoned after %d ms\n",
+				 RTW_PCI_RX_POISON_TIMEOUT);
+			return;
+		}
+		udelay(1);
+		dma_sync_single_for_cpu(rtwdev->dev, dma, RTK_PCI_RX_BUF_SIZE,
+					DMA_FROM_DEVICE);
+	}
+}
+
 static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
 				 struct rtw_pci_rx_ring *rx_ring,
 				 u32 idx, u32 desc_sz)
@@ -219,7 +311,8 @@ static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	if (!skb)
 		return -EINVAL;
 
-	dma = dma_map_single(&pdev->dev, skb->data, buf_sz, DMA_FROM_DEVICE);
+	rtw_pci_rx_poison(skb);
+	dma = dma_map_single(&pdev->dev, skb->data, buf_sz, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(&pdev->dev, dma))
 		return -EBUSY;
 
@@ -241,7 +334,8 @@ static void rtw_pci_sync_rx_desc_device(struct rtw_dev *rtwdev, dma_addr_t dma,
 	struct rtw_pci_rx_buffer_desc *buf_desc;
 	int buf_sz = RTK_PCI_RX_BUF_SIZE;
 
-	dma_sync_single_for_device(dev, dma, buf_sz, DMA_FROM_DEVICE);
+	rtw_pci_rx_poison(rx_ring->buf[idx]);
+	dma_sync_single_for_device(dev, dma, buf_sz, DMA_BIDIRECTIONAL);
 
 	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
 						     idx * desc_sz);
@@ -1065,8 +1159,7 @@ static u32 rtw_pci_rx_napi(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		rtw_pci_dma_check(rtwdev, ring, cur_rp);
 		skb = ring->buf[cur_rp];
 		dma = *((dma_addr_t *)skb->cb);
-		dma_sync_single_for_cpu(rtwdev->dev, dma, RTK_PCI_RX_BUF_SIZE,
-					DMA_FROM_DEVICE);
+		rtw_pci_rx_sync_and_wait_fresh(rtwdev, skb, dma);
 		rx_desc = skb->data;
 		ret = rtw_rx_query_rx_desc(rtwdev, rx_desc,
 					   &pkt_stat, &rx_status);
-- 
2.25.1


------=_Part_1462835_954143849.1793723149798--


