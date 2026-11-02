Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793592723;
	b=QJS/k33sTYC9P/8hIZGf7ag2f05fTgN+UwQv6Am9RJYgNfqHyiRjvXR27vOhg9rdb8Hd
	 o7LV+TWDFcya4ztBY5+Gccx/lXx/kXhKVFml2VJpzHViPYhlG8wIK6bmc3Z8vOm8mDVQa
	 sELjM0Qn/NlRSUTwRBNAAOQvC5pfMTculPJ5zT1dWWbVRNnRHGfzppF/dOq66A2pi7rwX
	 LT+dDGn7H/4Wyn8aVJ7eXgcYrbN71hBEwPvbgXQNJ2nkiXAuA41nNn++MKrVIZ0vxaNnT
	 mZ2YwMt74cIp2iwk8GEI/3toZ15+sirNB5E9/Dk5PRgKgu12JXsmOmLHc0nmF/Jn/TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793592723;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UoVVCs4E0WqMtB/439e3ybc24ctA88xvXydp2Ix8gds=;
	b=dxZDZZIo5BkJ6mabTC+BK4QISQIJj5FqKLzNJHauliHs63R0tKa7Ci4bNCVI5c/EQaH3
	 32P2dc5U5C26Rp8PPvDe48BQsGsMolvEjcGUWLVrkVp1a8XjWDoU2gAk2hqogc6ESFDIS
	 oRJBV47514QNv30QghwOjMv9JrohPtx314hWk0jqKwo0dfFxoCVmEqNcO5Ki8clCBpjMM
	 X7kWzYIpFrjxE9LeyRMG8cSY+Eh7hA+muMVxfxPe5nP5ZFe1LTR4RUTcY23YVI4coWJ1S
	 g7yO11GM7aWfD2MxW4U3nfZdfc382+xgMqWs94cmh2bVAWWgSg7k4SDwgPCqVK09pKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Tc/9+/Ld";
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACC2606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 04:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1ACC2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tc/9+/Ld
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-170135e43c7so147185c88.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 20:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793592722; x=1794197522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UoVVCs4E0WqMtB/439e3ybc24ctA88xvXydp2Ix8gds=;
        b=Tc/9+/LdIC66EeckJPdBLvN9Rg1wU4pEN4l7rnCe3Z/gHKcDFU1y3neN14jG9ql81i
         W5/DMdYmOha3JI3QFuzqYwwl6m7CbFv0EAWX3qkWcen8pt6vZ6jptX3i4rBbZcmiy9xn
         d2HlbnbUSE7tpHxkSiMsGN/e4ulsAbKQe7EaFt+DVKPz60dAFcM+EiHLViGJFINg7S/z
         eW7cDkC2MPdjYjuVj9wngyd4LKVT3xSUN0McuKX/wk85J93UK4ZafZEsLdDTzikiIaOY
         78v/KEOxxmt9wBLgLlKInjZStqKwOXxNdKTDyyapCAwdvvMgLWKG/HJfjkfXk4FLmGLg
         6MDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793592722; x=1794197522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UoVVCs4E0WqMtB/439e3ybc24ctA88xvXydp2Ix8gds=;
        b=aKRBxA5suCeiTsH0o4uCOw/dqydBmtodcWkbu2x65M0k44IagaEGOxWE+T5PCVcE2d
         wCembSEMFUAoDFDPhd49kKcaYfZT0jct3H5QmkPxvCKGMkpK5NWswYgh9HJ/jr8Y+62F
         GBj7/hnVy+3IjnwQDguyv1uqMZvNTn8xv6HY4uBpZ75v2qlEbUTZ0NYYsgjlfOKD4em3
         t6UQou9hmbt7lGhY7RD5UM1pygTT2SxVXO1ATSGNjes+j+dBj0FRU/XhkcLRn7/xFN1b
         uhS8UzhnRMehi8UAE0y68mNQD2hQdvwUBrLVUDg9Zv0rxj+HzJ9ygpQOwPPg8ncgw7xV
         Y4wA==
X-Forwarded-Encrypted: i=1; AKwUvBxCzhiP28AVORFMjL+0tRKQXfk1ENFuv2tgsTdHTOpfQn8olnlEY48STFzg3OdGsuElw5aCTlXYImMZOJ/j1g==@vger.kernel.org
X-Gm-Message-State: AFq9FYIMqvtLIxRXgXJKepKjhY15eOvE3b9zESyQulF5ugXENc4BoNGN
	J8P+mol0rzz3iP7EPUORMYWVsn8kt8mcFoPJLzT8Fkf2129KgphL9mcO
X-Gm-Gg: AYBFou2XXGIQNcE5anb7b5X4DpmOYP7oJxBnRIvYu8hmfmZlHX9/bwNvuU1KqDtNBX8
	GzgCEfBCoT9LgpoSKzvHz2HXmmhdO4NY4KpYlxa3nPX8ge56JNFCf/l+m1ScaPZXyGQdkwRNwG5
	umPX+YBqtoXIbn2N51pK6vuvmbrXmemZhdHX7P+yl3pN7bFLIfa/64gTET3ZBDRsa962/+dhPGY
	5m7dSnkfj9K9rJ7r3VpfMLrh1+MnCbiFb9u2YuXjiavneNojDQBbgSpeZWwUqRQ1vzYHOvysFWl
	mDn20j3reXIJh30kpCw97V4/3EYoy28pf6F6GSBLmndlAs0u6K/luz63xm62R7v3in+R7ISqOJM
	6lVu2Sc3WDh1wHbRu5DuipYEuGSyqX8GIM5ns6qfh8X9u4Q7hNxn/CTzoPOUmoQNxpHznM9JQUr
	h8WZUvIrCaRCm9aO2P7ulD/mwUQ43uGbCryeDo36eZ9LEoUuHRbH22M00VSv9ko3g5Nn51ftUr3
	6i6fmq7DfeFam+09uyU+cR+xXX+BU94PEstVv48jgShMNkSrqEpPto4wGK3ypAvXMrPhXm+b/E8
	Id5YRzS1GJKnHSU1NCV9G7wTsc2V/Zww0Q+0TQPiULW+eEc+csSsRPGQB6pSAiNeXg==
X-Received: by 2002:a05:701b:4589:b0:19b:39f4:88c9 with SMTP id a92af1059eb24-1ac5bbb487bmr13511529c88.10.1793592722018;
        Sun, 01 Nov 2026 20:12:02 -0800 (PST)
Received: from localhost.localdomain ([2400:d802:dd7:8000:50b9:9b10:1e19:1f0a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1a13652csm33171098c88.17.2026.11.01.20.12.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 01 Nov 2026 20:12:01 -0800 (PST)
From: Yuqiang Sun <izaiahsun@gmail.com>
To: stas.yakovlev@gmail.com
Cc: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: libipw: Do not return NETDEV_TX_BUSY after consuming the skb
Date: Mon,  2 Nov 2026 12:11:55 +0800
Message-ID: <20261102041155.61680-1-izaiahsun@gmail.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the TKIP MSDU encryption is done in software (host_encrypt_msdu,
set by ipw2200), libipw_xmit() copies the frame into a new skb, frees
the original skb and goes on with the new one. If libipw_alloc_txb()
then fails, the function jumps to "failed" and returns NETDEV_TX_BUSY.
The core stack takes NETDEV_TX_BUSY as "skb not consumed" and requeues
the original skb, which has already been freed, so it is used after
free. The new skb is leaked.

Even without the swap, returning NETDEV_TX_BUSY from "failed" is wrong:
every jump there comes after skb_pull() removed the Ethernet header, so
a requeued skb is sent again without it.

Drop the frame on these errors instead: free the skb and return
NETDEV_TX_OK. Do not stop the queue either, since no frame is waiting
for it to be woken.

Fixes: 1264fc0498e1 ("[PATCH] ieee80211: Fix TKIP, repeated fragmentation problem, and payload_size reporting")
Cc: stable@vger.kernel.org
Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>
---

Notes:
    The bug was found with kbound, a research static analysis prototype.
    The patch and the changelog were written with the help of an AI coding
    assistant (Claude); I have reviewed them.
    
    Compile-tested only (x86_64 and arm64 allmodconfig, W=1, sparse): I do
    not have ipw2100/ipw2200 hardware, and there is no emulated device.

 drivers/net/wireless/intel/ipw2x00/libipw_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
index 6e16060834b8..d0352c8dc064 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
@@ -509,9 +509,9 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 
       failed:
 	spin_unlock_irqrestore(&ieee->lock, flags);
-	netif_stop_queue(dev);
+	dev_kfree_skb_any(skb);
 	dev->stats.tx_errors++;
-	return NETDEV_TX_BUSY;
+	return NETDEV_TX_OK;
 }
 EXPORT_SYMBOL(libipw_xmit);
 

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.53.0

