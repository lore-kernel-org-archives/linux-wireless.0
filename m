Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4017405C3B;
	Mon, 20 Jul 2026 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784548285; cv=none; b=m4TJp7pR0nsIPrIIRgk0vnK93XzOcL14EgMItKyAyVieFN/iNqL3Yw9DmlOrqxcFW2w9gpdPGIizXEauRveNImpXnqkvtGd/zV9oTfubKzz6E2YS8yZpxjOBZ1sohxB8Vda7BoCDU63MFyvYUGyRySTazrnTwAw84BwVe2eaw5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784548285; c=relaxed/simple;
	bh=vrqjl7xj9tbN8anlV3EwPeSZ0vL9AZXbiHbEmbNQVxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rg/aubUrTZVGmHvaZnvRfnJve9jQn6r0uvRjH9ytXbfnhChhwJGGMmy4NYWr+NUAgDfFzefBRXAY5aPeHg+Oq9+udPKRmNpGdY9LZF6U0LZBeN+ip/Mxh7QYlU4GRneICCM8ySChBKknau83Jp0NyWAojAId/u8GU9ivOhLUz7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowADHND+3C15qdsGIAA--.52444S2;
	Mon, 20 Jul 2026 19:51:20 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Brian Norris <briannorris@chromium.org>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2] wifi: mwifiex: validate event lengths before copying bodies
Date: Mon, 20 Jul 2026 19:51:19 +0800
Message-ID: <20260720115119.80059-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADHND+3C15qdsGIAA--.52444S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4DJw43urWDWr1kJF4DCFg_yoW5Xw1xpa
	nxCrZYgw48twnrZ3yfJF18A3Wqga1rAr97CFWkZw1rur4rG3WSva40gFy0gr15Xw4vq34j
	yr1jq345Zr1DX37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU6v38UUU
	UU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

mwifiex event packets contain a four-byte event cause followed by the
event body. The USB and SDIO paths copy from data after that header using
the full packet length, so the source range extends four bytes beyond the
skb. The SDIO path also reads the event cause before validating the
packet and publishes oversized events without a copied body.

Reject SDIO events that are shorter than the header or larger than the
event buffer limit, using the same skb-release path for both failures.
Retain the equivalent USB bounds and copy only the bytes after the event
header in both paths.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
Changes since v1: https://lore.kernel.org/all/20260704011317.50900-1-pengpeng@iscas.ac.cn/
- reject both short and oversized SDIO events through one cleanup path
- copy only the body length in the SDIO and USB paths
- rebase onto v7.2-rc4

 drivers/net/wireless/marvell/mwifiex/sdio.c | 15 +++++++++++----
 drivers/net/wireless/marvell/mwifiex/usb.c  |  3 ++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index f039d6f19183..4101bf1edca1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1712,12 +1712,19 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 	case MWIFIEX_TYPE_EVENT:
 		mwifiex_dbg(adapter, EVENT,
 			    "info: --- Rx: Event ---\n");
+		if (skb->len < MWIFIEX_EVENT_HEADER_LEN ||
+		    skb->len > MAX_EVENT_SIZE) {
+			mwifiex_dbg(adapter, ERROR,
+				    "EVENT: invalid skb->len %u\n", skb->len);
+			dev_kfree_skb_any(skb);
+			return -1;
+		}
+
 		adapter->event_cause = get_unaligned_le32(skb->data);
 
-		if ((skb->len > 0) && (skb->len  < MAX_EVENT_SIZE))
-			memcpy(adapter->event_body,
-			       skb->data + MWIFIEX_EVENT_HEADER_LEN,
-			       skb->len);
+		memcpy(adapter->event_body,
+		       skb->data + MWIFIEX_EVENT_HEADER_LEN,
+		       skb->len - MWIFIEX_EVENT_HEADER_LEN);
 
 		/* event cause has been saved to adapter->event_cause */
 		adapter->event_received = true;
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index f4b94a1054f6..a6ed82e7228b 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -110,7 +110,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 			}
 
 			memcpy(adapter->event_body, skb->data +
-			       MWIFIEX_EVENT_HEADER_LEN, skb->len);
+			       MWIFIEX_EVENT_HEADER_LEN,
+			       skb->len - MWIFIEX_EVENT_HEADER_LEN);
 
 			adapter->event_received = true;
 			adapter->event_skb = skb;

