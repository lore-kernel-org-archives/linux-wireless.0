Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30FD3ECBDA
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 07:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792395230; cv=none; b=A1J8aXtup1kpRaeOS/MyN5XfzKIUZKDj47lhamEaRbtddI531af7kE+fIEsl5iHBK4vzb7njBvK4VynK2AmisT7iaQu/B51GvCsHNHbipl7ipJZKADKfXYUhCeYgk3WPhLNXJyQivnvoRDEgGH7uNQ4m9YRM/CzJtIBvpa9Oh4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792395230; c=relaxed/simple;
	bh=skVXBXhoa2RgapIGmRaVd1k3H3831eMZgXmdOmn1vjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iJzeDz5oD0U4QhXRwYv8QVXdL4r0AI82stKpE8Qm8/cdjH1FS4JFtjh/u9cp4Y4C03GESgR92yDLv9445mR8MWQgoqqkwOk4RxQBIE8SYk1Yx/sXBpdiI3HxwUgen2+fFT1sqG5+InN4bDc5KwjO0B2l2UKVDg2dKJH3WOEi/Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HIOWfCdw; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HIOWfCdw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=nc
	YQltmdOGxu7H2oORSGHTqL8dQ/hyGoMPVWHuWG2gY=; b=HIOWfCdwlVJSn3BGHf
	Vw3wj0b4GBJ5UqKHSAg7vdcD+HGEW9gjQ5xKUnkoXCUoEYNGcpRu4rxVTeMB5Uk0
	G29sfLmqT+7zaITVkl3AsAXOtgN29NaKTmTqA1cBwIiWqr6Z2RrGxpjxKA60t8EL
	az6hqqGJERGsaedZ2IbDE7LXk=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD313vXx9VqMgO2Aw--.14333S2;
	Mon, 19 Oct 2026 15:33:44 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org
Cc: stf_xl@wp.pl
Subject: [PATCH] wifi: rt2x00: rt61pci: trim RX skb to reported frame length
Date: Mon, 19 Oct 2026 15:33:40 +0800
Message-ID: <20261019073340.1063-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD313vXx9VqMgO2Aw--.14333S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7urWrCrW5Ar48ZFy5KrWxJFb_yoW8JF4xpF
	sxGryIkFyqyFnrZa4fAa4Sv3W5XanIyry2gr48J3yS9ryrK3WFgrW8WFyIqwn8Ka1vgFy2
	va1jy3W2qFZ8G3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jba93UUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC-hk44WrVx9nG7gAA33

rt61pci_fill_rxdone() reports rxdesc.size from the 12-bit
DATABYTE_COUNT field but, unlike the USB drivers, does not trim the skb
to that length.  rt2x00lib_rxdone() then computes the 802.11 header
length from the untrimmed skb and can call rt2x00crypto_rx_insert_iv()
while skb->len does not match rxdesc.size.

Trim the skb at the end of rt61pci_fill_rxdone(), matching rt2500usb and
rt73usb, so the skb length is correct before the header length is
computed and before any IV/ICV data is reinserted.

Signed-off-by: Heyang Tan <thy15333007817@163.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/ralink/rt2x00/rt61pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index d4783658b..bc0fb3cf9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -2051,6 +2051,7 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 		rxdesc->dev_flags |= RXDONE_SIGNAL_BITRATE;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
+	skb_trim(entry->skb, rxdesc->size);
 }
 
 /*

-- 
2.34.1

