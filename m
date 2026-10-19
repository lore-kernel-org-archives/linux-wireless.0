Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2AC4E80C0
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 11:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792411073; cv=none; b=BGLYn4/VrKrfrBzSHMdruX2j+/QAhHU+OMYc63yE1CvrFYSWriqI9EAZdy6my8DFOEM4f8FANspdBSUWtaNoxqDQnsjPlhVDNSkNG7Aupjbu809ysoW/kBmsWxL5dyeldz4YZpLmTyhLTI4LB10COdvj2EM+TI2Y7vAwer59qZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792411073; c=relaxed/simple;
	bh=z8yD+vDQZfsxdws3aOWTkXf2kT1Io+seZPRobuI0uc4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C8YIK5UnZBO5mUmy9OsjwfJzi2HjBAumJojtpLyOAVZIZp77w3xwc5qZS0JTBSWvwP2Bp0DlnWHBxmUttBgOrBxptmBg5T3Hw0SsUxOx+XkQcLEkLvQQN7GuQpaTPJUfKyl1U74jMkdCtB0+jv41WAIUrOMxpQa6G2H4dpncQwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CNH9CFjH; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CNH9CFjH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ru
	RjFhVzynN6UKtWuEO8GRuFzxaExJjNdLECVhhKtRA=; b=CNH9CFjH1LuV3H/pxb
	bKGxg05g4QQFcQ7xoD3VICu7ghUzzbU6TSRNt7dVf2OgNr1ouml2OO2hGWt2OOQT
	yt56lGlFdv0XEJMiWFgdhwldN+2fGeT/NQP6FFN9pivTciEVRNDlQxxSzjUhzzku
	eCscwIrcAyWJ0cG7PIJF7a7Ao=
Received: from LAPTOP-137NTCJO (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgAXN523BdZqRfUfAw--.35084S2;
	Mon, 19 Oct 2026 19:57:44 +0800 (CST)
From: Jiaxin Li <18135327133@163.com>
To: linux-wireless@vger.kernel.org
Cc: Jiaxin Li <18135327133@163.com>
Subject: [PATCH] wifi: rtl8180: reject RX frames longer than MAX_RX_SIZE
Date: Mon, 19 Oct 2026 19:57:40 +0800
Message-ID: <20261019115740.572-1-18135327133@163.com>
X-Mailer: git-send-email 2.56.0.windows.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgAXN523BdZqRfUfAw--.35084S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF4DuF45Kw47Jw1fGFy5twb_yoWkKwb_ur
	y0krsrArykCF409rs0kF4kJrWvkrWUZa4xCr9IvFyIgryUZrZ5Aw1Fvry3GrWUCF1jkryU
	Jw4qqFyxJayvvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUbVHqUUUUUU==
X-CM-SenderInfo: zpryijyvtsliitt6il2tof0z/xtbC6hi-gGrWBbgZ5QAA3w

rtl8180_handle_rx() passes the 12-bit length field from the RX
descriptor to skb_put() without clamping it to MAX_RX_SIZE.  The skb was
allocated with dev_alloc_skb(MAX_RX_SIZE), so a descriptor length above
MAX_RX_SIZE extends the skb past its allocated tailroom.

Drop such frames before allocating the replacement RX skb.

Signed-off-by: Jiaxin Li <18135327133@163.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index 4a5989172..abd76741b 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -255,7 +255,12 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			goto done;
 		else {
 			struct ieee80211_rx_status rx_status = {0};
-			struct sk_buff *new_skb = dev_alloc_skb(MAX_RX_SIZE);
+			struct sk_buff *new_skb;
+
+			if (unlikely((flags & 0xFFF) > MAX_RX_SIZE))
+				goto done;
+
+			new_skb = dev_alloc_skb(MAX_RX_SIZE);
 
 			if (unlikely(!new_skb))
 				goto done;

-- 
2.34.1

