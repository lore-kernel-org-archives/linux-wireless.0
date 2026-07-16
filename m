Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9868B379EFF
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784219123; cv=none; b=m9VUzSWD/6MWUVzRnKHFMbIb1BteqoAr2cqJu0WhtfTrxFuCzLvBte5kpNq/ooNrDTWTC5+7owZEUQz9AGurnAR2O+0AOlzbyFcr87KFKiVEmOoXhz1+OUGF2jaR4bDk6HNRIWLc+ARkmCg1QzqpgOI29sNUwi/NfaM0QyIcyXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784219123; c=relaxed/simple;
	bh=4CPW5b7K7pWIDEETkd1lpdofQroaGErs1xlq/gmjxWI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=PaA9S+yBDb7w9s8paZanlLKt/b0fqi09uaBlH65pYsuAAaCCIG2B2QW7f2INczDjI7lgBr2JxWh4wCbUDLXMKMLSMgDiXpAeaZgbRMMfQ68PLITgN/nDgAYXBZKPfGNEGm11X/Fk6Yoz01SadKGJxwZepKRCdHLUdKdgFeHKPpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VFWIjBHe; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VFWIjBHe"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso495359a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 09:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784219122; x=1784823922; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7QjVN0B7Sf4bom6cy6/CS1jzJRC2l2ZaheSobQTYPio=;
        b=VFWIjBHe7jK8962+U9Mp6Kwdwry1GSS0pHQ6YrkezNUq2JiP5SiuP07+slTy3HIlsc
         oKlekvyJz/FKN0Uz8O8LKOhX1j07GYjXRVVi21z43ZzePn+f3wFgrpfEM4scOcOLWK2h
         L6KKNFIYmafxMRwi9biVyBgjGm4/kmdModk+lBpL4QCQem9gf+tOzg/T0jdaQoI1viFy
         kfN06+wgDtdVQ1qUZ1+fabwx4P5xRVitvdVHTt3j0sp3TmIHrZULcbLVXSgcwPDMvtN2
         Y8qQ2sGfH5m+/aOfC0xZ2h1Wj2dSSJolzA8Of9tqAluALNmxM2ZFDnDOqtg8HbEvycQV
         waqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784219122; x=1784823922;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7QjVN0B7Sf4bom6cy6/CS1jzJRC2l2ZaheSobQTYPio=;
        b=KquiYCcLpxmO9y9EtO/X/iP2vj/sKLENUKHc6603HKBa0RZqF6Pr5lyGHcXoTbA4MG
         JqidVMzcgizD5kFO6xnKammb6coCVh1ARCdMPdHJPaqQZsEnwUWZ82KQCivew6hTgV+O
         Yyx4CjxWVhidpCMjNH6DlvYbwQ0Hmh7mSc8O9meywIHYCzuDk3y0rYeMtomO9uz1tQpk
         Gu4DWafvAW0u47PDm4FrEC+EZy5VfSLYXOznLtsy2KL9cm4aKeKzsGU8N1vT4gbkPpQ5
         eG/7jqwXb+Yi/ixM9GRu4birlSqpfdQPrn4ifj8hN7xsYlZOssygD9vWafGJ1VonUf3V
         ewPA==
X-Forwarded-Encrypted: i=1; AHgh+RoKDY+BkxJVAdShUHHtCgQUZIOx465Fr3MdqV/Mb9As5eMVgH3+egx5LSxvLtHSpnF44kLCR0qWQBzXFCrjFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTXaXpnv24lsXpXBSBJcQyryOQ3WW9Piz0bzk+azRVLMFzddKb
	PpYA1ZY+hIGkWfeDpPetfsbzfk91bYU8/khJjJ8FpiM080jNGqq1CXBp
X-Gm-Gg: AfdE7clyXu4cQzEgikzihmc6XBDmzcQFt02CfH981F9IyClrakHG9N7VlgipkHX1+xJ
	Fm7TpeTd5gpwEL5jv2nY05nOz0WpWQxGostnpwC3VFpkCKAgTpCLsiGKOdr97tN5MeYgUyBZ61C
	F+q1q6O6DfwOcjHavpXk8QIu49x8Pg7niMNApa9l8PnDNn5bm28M1ujyHSWOTIWJ31Vpgcxqx0k
	hPM475IKc4MewbYO0XbcB6gHeeHm28bmLdL9pQ/2WdCAyHyZPlanZyw4ECmgxKsLBE+LtAdr7sD
	NpYG0jdJvY4D57w5uWyV9BQLcbGVJH55P+26wF2v+1l4mEZsZapq1xHbxy1Z+jXC/fESy6FDktj
	9YFJLZYm0pwTE0eRMsVrMXXjvCgU5xKjqyKaXr5FN6WffWTipNuRm7T+3yfUJwu0xC4tkIMtISa
	5RngDyI+DrplU5vOlGb2d1cSOFA0gyaKzZKg+PG7hXT0o5laDUKs2DawzWT44d7Kxh3BNsdGA2b
	no19XC/Pp4=
X-Received: by 2002:a17:90b:268a:b0:38d:e442:901e with SMTP id 98e67ed59e1d1-38e4676edcemr252375a91.27.1784219121817;
        Thu, 16 Jul 2026 09:25:21 -0700 (PDT)
Received: from [192.168.1.45] ([45.64.226.73])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6f0fcdsm13401269eec.30.2026.07.16.09.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 09:25:21 -0700 (PDT)
From: Prashant Rahul <prashantrahul23@gmail.com>
Date: Thu, 16 Jul 2026 21:55:10 +0530
Subject: [PATCH] wifi: mt76: mt7921: fix memory leak when skb_linearize
 fails in mcu rx event
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-mt7921-mem-leak-v1-1-6e9c0ea19f63@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQ5AMBBA0avIrE3SqURxFbGoGkwo0opIxN01l
 m/x/wORg3CEJnsg8CVR9i2B8gzcbLeJUYZk0EqXylCJ/jS1JvTscWW7oC0q1zsaKio0pOoIPMr
 9H9vufT+KAS/7YQAAAA==
X-Change-ID: 20260716-mt7921-mem-leak-a38cbc1d8132
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-wireless@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, 
 Prashant Rahul <prashantrahul23@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1673;
 i=prashantrahul23@gmail.com; h=from:subject:message-id;
 bh=4CPW5b7K7pWIDEETkd1lpdofQroaGErs1xlq/gmjxWI=;
 b=owEBbQKS/ZANAwAKAWw+kajX8DhtAcsmYgBqWQXsV/w68cO9EKUlxqIpVZZtXkCX80D6dDxmD
 aGf8enZNumJAjMEAAEKAB0WIQRS5esR6MP3hQs0SsxsPpGo1/A4bQUCalkF7AAKCRBsPpGo1/A4
 bdceD/9HRbFIUqlRohA+MNVpogcl2J0qVq6PkEnpD+GkH7o7uXwvTr5omWzmRqdNb33V5b4Fe2K
 c7OJF/5NoVkMxl6Qpc35kmyjgwc6XTpUewiJRb79q3tPiZV0GG8QuRVtllKz831mDYmPk+Redck
 4H5KTYrsr8LIf9Xso8dlfOJN0ERKdNUzEwDPcyLSuH+m/xuIDs3ez5Y5IKNCanUcpVK5onVkMFk
 0hudLISYFa8W/s9wIKM6pSuqHZ5JqWA5SYbsh6Wvq8H9DLcMa9uYgDbd7cN1rUF9ZfOWg7BLDXY
 z616o9dBYz8yUev0+lQAM2omnXDbaKRnEOoF+FKv21HScW3bH8AGZJLoAPJgoeMGHIysFEtpdEI
 +85iKhG2ybdPp5FL+I+AteyRTxrnH+O1mpS5AoFksYcv/qEQaIM2R8LePjvtSwTPk13dGVwdm3P
 3MY/2bz9TLpgdi51R4hn89CJiCZ48nVMUKABUTky/G80vg4b/pyYsa6jNuT5wEhVgYOFXqz3qko
 GfYjZThToIzvU+crLj4s49Zh7/ceI//3hrH84W6MAL3FM2jjNXBihLDv077WFmv4/AXOEWbVsHs
 qtnO5CTz3MKT9+K0Dq36YNx07UYI1d6sNTiBka3HlCEkxRXgRR3zbIId2eZH3SiKscIsUTumMjr
 pli4IGgKPuxzQxA==
X-Developer-Key: i=prashantrahul23@gmail.com; a=openpgp;
 fpr=52E5EB11E8C3F7850B344ACC6C3E91A8D7F0386D

The ownership of sk_buff skb is passed to mt7921_queue_rx_skb, each
path inside it under the switch case handles cleaning of skb and it
is true for mt7921_mcu_rx_event as well.

mt7921_mcu_rx_event, on a success path, either queues skb via
mt76_mcu_rx_event or cleans it immediately inside
mt7921_mcu_uni_rx_unsolicited_event.

However inside mt7921_mcu_rx_event, if skb_linearize fails, the function
returns immediately and never bothers cleaning skb which leaks skb.

Since skb is fully owned at this point, it is safe to call
dev_kfree_skb which fixes the leak.

Granted, the skb_linearize failure is rare as it can only fail under
heavy memory usage, but at the same time, leaking memory under heavy
memory usage can worsen the OOM condition.

Signed-off-by: Prashant Rahul <prashantrahul23@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 25b9437250f7b..fb18d3b4e27ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -351,8 +351,10 @@ void mt7921_mcu_rx_event(struct mt792x_dev *dev, struct sk_buff *skb)
 {
 	struct mt76_connac2_mcu_rxd *rxd;
 
-	if (skb_linearize(skb))
+	if (skb_linearize(skb)) {
+		dev_kfree_skb(skb);
 		return;
+	}
 
 	rxd = (struct mt76_connac2_mcu_rxd *)skb->data;
 

---
base-commit: b8809969e1d7a591e0f49dd464a5d04b3cf02ab1
change-id: 20260716-mt7921-mem-leak-a38cbc1d8132

Best regards,
-- 
Prashant Rahul <prashantrahul23@gmail.com>

