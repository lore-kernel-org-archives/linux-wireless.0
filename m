Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6483546F1;
	Thu, 23 Jul 2026 02:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784774410; cv=none; b=NMQfMPYVbdmpqFuJIlDU2Wkb2g+SPDFkiwK0Dpm5g5TtVkMUlcYgr9Ebbe1AAa/TFdM7ItQY83HAcf/b680MCEz0t8vorbABVeb5iE4Ri+WNPRn0NsKNqnpC+L5tavXrlnlJF08UgucyTe58Z4QNVZftQypRbHaGF9USSLf3cLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784774410; c=relaxed/simple;
	bh=AZzaS4Si0X4xXpKamZ4eLgaQbDOLiKUAAerQWc9wzHU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=InYEE4ZlMOCz///oHIG1NgfMAejcJ603qeQKZ+kdzU6HY4M9auyz+5szrptLD8JiBgzJ5txF8u16HBsQf6E1tKRknh7diZbIjaxXUtsL/EPFO2cFCGkCSrAmj6fE6Hl4WKZPUBGMYJ5TMaswb6GvktFOpbHVZgx7KNgEM9+kgw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowADHzz0Ff2Fq1JvWAA--.25623S2;
	Thu, 23 Jul 2026 10:40:05 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Brian Norris <briannorris@chromium.org>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v3] wifi: mwifiex: validate event lengths before copying bodies
Date: Thu, 23 Jul 2026 10:40:05 +0800
Message-ID: <20260723103510.3-mwifiex-event-v3-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADHzz0Ff2Fq1JvWAA--.25623S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4DJw4DXFWxZw4xuF48Zwb_yoW5WF1xpw
	sxGr9Ygw40qrnFy34fJF18A3Z0ga1Fkr97GFWDZw1rurWfGw1fZay0gFWIgr1rXwsYq34j
	yw1jq345Zr1DX37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvj14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5o
	GQDUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

mwifiex event packets contain a four-byte event cause followed by the
event body. The USB and SDIO paths copy from data after that header using
the full packet length, so the source range extends four bytes beyond the
skb. The SDIO path also reads the event cause before validating the
packet and publishes oversized events without a copied body.

Reject SDIO events that are shorter than the header or larger than the
event buffer limit. Discard them through the same free-and-break contract
used for unknown upload types. Retain USB's existing error path and copy
only the bytes after the event header in both paths.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
Changes since v2: https://lore.kernel.org/all/20260720115119.80059-1-pengpeng@iscas.ac.cn/
- replace the new SDIO return -1 with free plus break as requested
- preserve USB's established error return contract
- rebase onto the current wireless tree

 drivers/net/wireless/marvell/mwifiex/sdio.c | 15 +++++++++++----
 drivers/net/wireless/marvell/mwifiex/usb.c  |  3 ++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index f039d6f19183..3588c36f64cf 100644
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
-- 
2.50.1 (Apple Git-155)

