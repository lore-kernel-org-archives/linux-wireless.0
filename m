Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF92E3E6DF7;
	Fri, 14 Aug 2026 07:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786694241; cv=none; b=I8q1/ub4YpQnhRbfeMLe0D9iCWRbWOyjDbXDpfIHrqF/VpNUG4z4SSLTzt9FyM+ZcN8P5jaXsp9UUZx7Xj4O/OCL8mUCf+YTm2LkjrgNZxt6PNsQT9X9sRoRV/W9UnhM0tZL/R3Nfoz9wSU3EOO5ZJ/ctyzd7eHmoX719BInOIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786694241; c=relaxed/simple;
	bh=/sFaktxYBe3BwlSASUNIQbANjhK7fxjBztr7gLA2SD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TiPKJo9hiqaPblsABHaCKTg3QUKJ2zRl1Y0KQk+4xU6sCC6xuK1tS3cxdAVYAzVRolcIrodalnmqsOzg7YvBIdBMIz6JHg8hXcA+PGkpOUAkHfk+yi2WPIHnlmgyW15AnCpsD/9PKetCuNkaivB8zHBd9B+BSSVH9DmL3Yd8PGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowACHWe1cyn5q3pCeBQ--.62332S2;
	Fri, 14 Aug 2026 15:57:17 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2] wifi: ath9k: validate USB RX stream lengths before copying
Date: Fri, 14 Aug 2026 15:57:16 +0800
Message-ID: <20260814075716.18804-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACHWe1cyn5q3pCeBQ--.62332S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW5WFWfJw4DJF13Ar1fZwb_yoW5KFWrpF
	WSq3WayrW3XF1jyw4DG34fXF1Yga4Ig3yagFyxCw1avr1DAryqgryxKayjgrZ8AFWfAF48
	Zr4DXw4DZFyUu3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUsiSdUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

ath9k_hif_usb_rx_stream() parses records from one USB receive buffer
and also completes records split across two buffers. It checks the stream
tag and a packet length ceiling, but not every fixed header, current
payload extent or continuation extent before reading or copying.

Validate the fixed header and complete-record extent, bound a split
record to the capacity of two receive buffers, and require the next
buffer to contain the expected continuation. Clear all saved continuation
state when a malformed record is dropped.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
Changes since v1: https://lore.kernel.org/all/20260701053823.49801-1-pengpeng@iscas.ac.cn/
- validate fixed headers and complete records before copying
- prove the split-record path against two receive-buffer capacities
- clear every saved continuation field after success or rejection

Every RX parser branch was reviewed statically; malformed USB traffic was
not injected on ath9k hardware.

 drivers/net/wireless/ath/ath9k/hif_usb.c | 33 ++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 47f904e7e652..8d60779165ab 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -566,6 +566,18 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 	if (rx_remain_len != 0) {
 		struct sk_buff *remain_skb = hif_dev->remain_skb;
 
+		if (rx_remain_len < hif_dev->rx_pad_len ||
+		    rx_remain_len > len) {
+			dev_kfree_skb_any(remain_skb);
+			hif_dev->remain_skb = NULL;
+			hif_dev->rx_remain_len = 0;
+			hif_dev->rx_transfer_len = 0;
+			hif_dev->rx_pad_len = 0;
+			RX_STAT_INC(hif_dev, skb_dropped);
+			spin_unlock(&hif_dev->rx_lock);
+			return;
+		}
+
 		if (remain_skb) {
 			ptr = (u8 *) remain_skb->data;
 
@@ -579,11 +591,13 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			skb_put(remain_skb, rx_pkt_len);
 
 			skb_pool[pool_index++] = remain_skb;
-			hif_dev->remain_skb = NULL;
-			hif_dev->rx_remain_len = 0;
 		} else {
 			index = rx_remain_len;
 		}
+		hif_dev->remain_skb = NULL;
+		hif_dev->rx_remain_len = 0;
+		hif_dev->rx_transfer_len = 0;
+		hif_dev->rx_pad_len = 0;
 	}
 
 	spin_unlock(&hif_dev->rx_lock);
@@ -596,6 +610,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 		ptr = (u8 *) skb->data;
 
+		if (len - index < 4) {
+			RX_STAT_INC(hif_dev, skb_dropped);
+			goto invalid_pkt;
+		}
+
 		pkt_len = get_unaligned_le16(ptr + index);
 		pkt_tag = get_unaligned_le16(ptr + index + 2);
 
@@ -624,6 +643,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 		index = index + 4 + pkt_len + pad_len;
 
 		if (index > MAX_RX_BUF_SIZE) {
+			if (len < MAX_RX_BUF_SIZE || index > 2 * MAX_RX_BUF_SIZE) {
+				RX_STAT_INC(hif_dev, skb_dropped);
+				goto invalid_pkt;
+			}
+
 			spin_lock(&hif_dev->rx_lock);
 			nskb = __dev_alloc_skb(pkt_len + 32, GFP_ATOMIC);
 			if (!nskb) {
@@ -648,6 +672,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			hif_dev->remain_skb = nskb;
 			spin_unlock(&hif_dev->rx_lock);
 		} else {
+			if (index > len) {
+				RX_STAT_INC(hif_dev, skb_dropped);
+				goto invalid_pkt;
+			}
+
 			if (pool_index == MAX_PKT_NUM_IN_TRANSFER) {
 				dev_err(&hif_dev->udev->dev,
 					"ath9k_htc: over RX MAX_PKT_NUM\n");
-- 
2.50.1 (Apple Git-155)

