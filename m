Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A037D28686;
	Sun, 30 Aug 2026 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788093464; cv=none; b=jngDOlIHeMB0fxclMyNLAqOB7OLACpQQ4osbxx8N67zJrg8B86lwKJJdFu+llO5yogI7liR3ox/DLoKrSfnatAnsS8l6R9zNH/zmpgVuo778vLQ8Z8XrgelHLZsdG0GG1nRocqhLl/kEzpbzWR7InZSfmAQiYNOPh1QV8mJLx0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788093464; c=relaxed/simple;
	bh=Z7CMZS7Iuq7n7DX1pXPlGhYcGCqs9OOi6V69DXiOe5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kQA6vka9np1Y/9QtE14T262UYex4p577Tkb48zUe72WnF1z59SCAlx8FvbJzP03XmuFLJigomxnDy6H0gaIuxj+6MSZlQLjS+j2luixurJOJC2Ad7wGP0hvFhXyhk2ZK34lOT9E/XAM7U6RmegnA8ulDnCoSOCQNv7gpQBT/4LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowAAHDDoCJJRq53aaBg--.16982S2;
	Sun, 30 Aug 2026 20:37:22 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Felix Fietkau <nbd@nbd.name>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt76: mt7921: validate capability TLV extents
Date: Sun, 30 Aug 2026 20:37:18 +0800
Message-ID: <20260830123720.94876-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAHDDoCJJRq53aaBg--.16982S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1kZr4kZw1UCr43CF47XFb_yoWrGry8pF
	WYgrW5G3yUJrsFkwn5Arsxua98tas7trW3Ka45Z3WFq3sFyr18CFsaqFy0vrWak3ykGryf
	ZFWvv3Z5WrnFqaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The NIC capability walker can accept truncated generic TLV headers or
payloads, and its type-specific consumers read fixed payloads without
proving that the current TLV contains those bytes.

Reject malformed generic extents and require every known capability type
to provide its minimum payload before parsing or copying it.

Fixes: dab35009fc1c ("wifi: mt76: mt7921: move connac nic capability handling to mt7921")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 89 ++++++++++++++++---------
 1 file changed, 59 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index a118a301564c8..8e6be9f63659a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -515,21 +515,38 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	return ret;
 }
 
+struct mt7921_tx_resource {
+	__le32 version;
+	__le32 pse_data_quota;
+	__le32 pse_mcu_quota;
+	__le32 ple_data_quota;
+	__le32 ple_mcu_quota;
+	__le16 pse_page_size;
+	__le16 ple_page_size;
+	u8 pp_padding;
+	u8 pad[3];
+} __packed;
+
+struct mt7921_phy_cap {
+	u8 ht;
+	u8 vht;
+	u8 _5g;
+	u8 max_bw;
+	u8 nss;
+	u8 dbdc;
+	u8 tx_ldpc;
+	u8 rx_ldpc;
+	u8 tx_stbc;
+	u8 rx_stbc;
+	u8 hw_path;
+	u8 he;
+} __packed;
+
 static void mt7921_mcu_parse_tx_resource(struct mt76_dev *dev,
 					 struct sk_buff *skb)
 {
 	struct mt76_sdio *sdio = &dev->sdio;
-	struct mt7921_tx_resource {
-		__le32 version;
-		__le32 pse_data_quota;
-		__le32 pse_mcu_quota;
-		__le32 ple_data_quota;
-		__le32 ple_mcu_quota;
-		__le16 pse_page_size;
-		__le16 ple_page_size;
-		u8 pp_padding;
-		u8 pad[3];
-	} __packed * tx_res;
+	struct mt7921_tx_resource *tx_res;
 
 	tx_res = (struct mt7921_tx_resource *)skb->data;
 	sdio->sched.pse_data_quota = le32_to_cpu(tx_res->pse_data_quota);
@@ -545,20 +562,7 @@ static void mt7921_mcu_parse_tx_resource(struct mt76_dev *dev,
 static void mt7921_mcu_parse_phy_cap(struct mt76_dev *dev,
 				     struct sk_buff *skb)
 {
-	struct mt7921_phy_cap {
-		u8 ht;
-		u8 vht;
-		u8 _5g;
-		u8 max_bw;
-		u8 nss;
-		u8 dbdc;
-		u8 tx_ldpc;
-		u8 rx_ldpc;
-		u8 tx_stbc;
-		u8 rx_stbc;
-		u8 hw_path;
-		u8 he;
-	} __packed * cap;
+	struct mt7921_phy_cap *cap;
 
 	enum {
 		WF0_24G,
@@ -603,31 +607,56 @@ static int mt7921_mcu_get_nic_capability(struct mt792x_phy *mphy)
 		} __packed * tlv = (struct tlv_hdr *)skb->data;
 		int len;
 
-		if (skb->len < sizeof(*tlv))
-			break;
+		if (skb->len < sizeof(*tlv)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		skb_pull(skb, sizeof(*tlv));
 
 		len = le32_to_cpu(tlv->len);
-		if (skb->len < len)
-			break;
+		if (skb->len < len) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		switch (le32_to_cpu(tlv->type)) {
 		case MT_NIC_CAP_6G:
+			if (len < sizeof(skb->data[0])) {
+				ret = -EINVAL;
+				goto out;
+			}
 			phy->cap.has_6ghz = skb->data[0];
 			break;
 		case MT_NIC_CAP_MAC_ADDR:
+			if (len < ETH_ALEN) {
+				ret = -EINVAL;
+				goto out;
+			}
 			memcpy(phy->macaddr, (void *)skb->data, ETH_ALEN);
 			break;
 		case MT_NIC_CAP_PHY:
+			if (len < sizeof(struct mt7921_phy_cap)) {
+				ret = -EINVAL;
+				goto out;
+			}
 			mt7921_mcu_parse_phy_cap(phy->dev, skb);
 			break;
 		case MT_NIC_CAP_TX_RESOURCE:
-			if (mt76_is_sdio(phy->dev))
+			if (mt76_is_sdio(phy->dev)) {
+				if (len < sizeof(struct mt7921_tx_resource)) {
+					ret = -EINVAL;
+					goto out;
+				}
 				mt7921_mcu_parse_tx_resource(phy->dev,
 							     skb);
+			}
 			break;
 		case MT_NIC_CAP_CHIP_CAP:
+			if (len < sizeof(mphy->chip_cap)) {
+				ret = -EINVAL;
+				goto out;
+			}
 			memcpy(&mphy->chip_cap, (void *)skb->data, sizeof(u64));
 			break;
 		default:

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

