Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD1D3B05AB;
	Fri, 31 Jul 2026 14:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785507613; cv=none; b=VJyCMdLaJ4VwTMOn7tpGOKvxD5aQSOzExc0sq5eLozk+qpON8SM6bcAcGVU6STOWH8T2QsORyI/qXKssaTZ4LD0TNRlphdIuHbsjPuevEyHhsK6v/ue+WFQKlD962NwUujg2Ny1yEfUc6QLonUzbW68LNrtSm8QSwajbIf+76i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785507613; c=relaxed/simple;
	bh=TplThfw0xWsJfnCgE9m6QFGMUa8qVHGHrM7i4pJsuqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZztnlAJ521YNzyYPdVJKePOXLfPD7P80flw1yR9fIFgB7ulOWkIegCBfjYgPFKAmB1Os8mLKCjvNzvlvBTipIvtJ1oAeTguPmdRt667Lc5aSAYJpVsRT/iU8umZHIyBKJHMG1eOrC9XQmFbd+kilGe5nuo1Zrlyr5V0m/sBlULs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowACXoD4Sr2xqjCBKAg--.35397S2;
	Fri, 31 Jul 2026 22:20:02 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Brian Norris <briannorris@chromium.org>
Cc: Jeff Chen <chunfan.chen@gmail.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH v4] wifi: mwifiex: validate event lengths before copying bodies
Date: Fri, 31 Jul 2026 22:20:02 +0800
Message-ID: <20260731141600.2-mwifiex-v4-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACXoD4Sr2xqjCBKAg--.35397S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4xKrW3XrWrtry8Zr4kXrb_yoW5tryrpa
	nxGrnYgw40qrnFqw1fJF18Aa4qga1rC3s7CFZ5Z3yruFWfJ3WrAay0gFWIgr1rXwsYq34U
	tw1jqw15Zr1DX37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUG0PhUUU
	UU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

mwifiex event packets contain a four-byte event cause followed by the
event body. The USB and SDIO paths copy from data after that header using
the full packet length, so the source range extends four bytes beyond the
skb. The SDIO path also reads the event cause before validating the
packet and publishes oversized events without a copied body.

Reject SDIO events that are shorter than the header or whose body exceeds
the event buffer. Discard them through the same free-and-break contract
used for unknown upload types. Retain USB's existing error path, apply the
same body-length upper bound there, and copy only the bytes after the event
header in both paths.

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
Changes since v3: https://lore.kernel.org/all/20260723103510.3-mwifiex-event-v3-pengpeng@iscas.ac.cn/
- compute the upper bound from the event body length, as requested by
  Jeff Chen
- apply the same body-length bound to USB and allow a full MAX_EVENT_SIZE
  body in both paths
- add Francesco Dolcini's Reviewed-by
- rebase onto the current tree

 drivers/net/wireless/marvell/mwifiex/sdio.c | 15 +++++++++++----
 drivers/net/wireless/marvell/mwifiex/usb.c  |  6 ++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index f039d6f19183..ccaf515d5597 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1712,12 +1712,19 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 	case MWIFIEX_TYPE_EVENT:
 		mwifiex_dbg(adapter, EVENT,
 			    "info: --- Rx: Event ---\n");
+		if (skb->len < MWIFIEX_EVENT_HEADER_LEN ||
+		    skb->len - MWIFIEX_EVENT_HEADER_LEN > MAX_EVENT_SIZE) {
+			mwifiex_dbg(adapter, ERROR,
+				    "EVENT: invalid skb->len %u\n", skb->len);
+			dev_kfree_skb_any(skb);
+			break;
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
index f4b94a1054f6..7f3d0f9f4fd6 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -102,7 +102,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 			mwifiex_dbg(adapter, EVENT,
 				    "event_cause %#x\n", adapter->event_cause);
 
-			if (skb->len > MAX_EVENT_SIZE) {
+			if (skb->len - MWIFIEX_EVENT_HEADER_LEN >
+			    MAX_EVENT_SIZE) {
 				mwifiex_dbg(adapter, ERROR,
 					    "EVENT: event body too large\n");
 				ret = -1;
@@ -110,7 +111,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 			}
 
 			memcpy(adapter->event_body, skb->data +
-			       MWIFIEX_EVENT_HEADER_LEN, skb->len);
+			       MWIFIEX_EVENT_HEADER_LEN,
+			       skb->len - MWIFIEX_EVENT_HEADER_LEN);
 
 			adapter->event_received = true;
 			adapter->event_skb = skb;
-- 
2.50.1

