Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E597404E
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792123038; cv=none; b=sgeMAt149nyFfk++px/BhTEQ1pm+ZEKf6yNgHbWzLUIaIoOyCZ0wnjKJTZ01oMpmvdHjkNVKfZHEhta8sk7pFfIiqA7xoZIg9IdshPcJjcvFV69y9eOyl+RgalESOg3hn+7xpoG2kR0V9Q9RtVwCdWpyIO2IIlWjerNWlQHrp9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792123038; c=relaxed/simple;
	bh=iJhBL98JNFiELTqdPWSOI3Md3JwWfVOFvaoo0t51kx8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WJvCMdYDK9YHUwJ6aZrYz6UvcNT0cuG1dXsKBtTVySHkXz1rUoMM05YzpEty5yGbblVX6HW9DP2wqN6Fk2qoVDpAm6nfdxM8I6RSm2nLaLAY02geuRoBgzUJ7MEbfyAeg4NsJ9MyJ5zQp6CmHVwgC+D3aB7DT1hfmhurf4pM8s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fE1J3SiC; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fE1J3SiC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=AZ
	xZp6T6vTN1h3ZHxw73aRmV1MvW5ibAgey2mVabHQE=; b=fE1J3SiCdf8ja0zvzv
	sMi+08Y0gAgaaSNmvrytA9x/VpkEiEWtJKXpDyGZTCIbQ0tK5X9KH/gj4ZwqfoMT
	OX4Pts077+pQQQHsn42rQW+S/DGcV5/OBXiLSkqCoSDWQiUYZ5VpVOXtleu61bOk
	4ecQLO3xtOvC3HdBREuIH7J6A=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3V7qVoNFqpLLEAQ--.51895S2;
	Fri, 16 Oct 2026 11:57:11 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org
Cc: stf_xl@wp.pl
Subject: [PATCH] wifi: rt2x00: rt61pci: trim RX skb to reported frame length
Date: Fri, 16 Oct 2026 11:57:06 +0800
Message-ID: <20261016035706.1706-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3V7qVoNFqpLLEAQ--.51895S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7urWrCrW5Ar48ZFy5KrWxJFb_yoW8XryrpF
	s8GrW09ryqyF17A34fAw4ftw15Xan5Ary7Kr48J3yS9rWYg3WrKFW0gFyIqws8GF4vgF12
	va10y3W2gFZ8J3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UC2NNUUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC-RdcBmrRoJcKYgAA3U

rt61pci_fill_rxdone() reports rxdesc.size from the 12-bit
DATABYTE_COUNT field but, unlike the USB drivers, does not trim the skb
to that length.  rt2x00lib_rxdone() then computes the 802.11 header
length from the untrimmed skb and can call rt2x00crypto_rx_insert_iv()
while skb->len does not match rxdesc.size.

Trim the skb at the end of rt61pci_fill_rxdone(), matching rt2500usb and
rt73usb, so the skb length is correct before the header length is
computed and before any IV/ICV data is reinserted.

Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
 drivers/net/wireless/ralink/rt2x00/rt61pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index d4783658b..b2ee0cc14 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -2051,6 +2051,14 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 		rxdesc->dev_flags |= RXDONE_SIGNAL_BITRATE;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
+
+	/*
+	 * Trim the skb to the reported frame length.  rt2x00lib_rxdone()
+	 * computes the 802.11 header length from the skb before calling
+	 * rt2x00crypto_rx_insert_iv(), and that function requires skb->len
+	 * to match rxdesc.size.
+	 */
+	skb_trim(entry->skb, rxdesc->size);
 }
 
 /*

-- 
2.34.1

