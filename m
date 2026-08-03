Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8564937FF75
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 10:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753876; cv=none; b=mozFqRvZMgtuznlfXe/5HACDrtB+JHSY4m9J0myDc95wJnaZl2nbjb1ncD9dGbUjhhBKxhv9BbvKevND+WbIOWD7kAch+1P1IGZvHFzLuwzsCJ9Gq9ShWgG7CpCM+5iA2PF7iLpfSLSY2Z8WVeFuxEnnAUWnED3Jdey8VBXin2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753876; c=relaxed/simple;
	bh=tMpC1xzdo63lqopHFPlw01oLOuykRATWAu2nX08wIec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qr/+2SO7Gbcl/38SUi/JShylmIOfgWNdDLqcknVBQO0IlKBEHdl//8SZ1cs9KY9a8t59Px6qhVuXEe0gIHnjlZa8B4TzSYWb4zJLLlsnp792MJiRi2DsxCodo8dr08wmzjjpeM6SsYC5UVtjMBWFzFQb25AEKzlyKHsAfYdg/Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f0pZr/Ey; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f0pZr/Ey"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49552f516beso405145e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 03:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785753873; x=1786358673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fe47mFnGJrnj7q96fsdIDjsBMpDbZQXw/JGM6RT1ooQ=;
        b=f0pZr/Ey3JhQIvvRc3kq+T+IZnZkjDMWwHayn1NA5CcFslDkyEBcC1SAX/jW8Rbsw4
         iAXW4hyxhC9d6tLRIaGCFy/7kWhKZtinAOC5t5eY2ZhrH1SdK+86yxjq0VPcqbs+apeL
         usn5yfbROiiTiQz3xp5nFcb54wBW/ndRkxxTVYsuEkm5oY4QcqWWMTsuTlKv3LgTIe19
         GwH0HZl3n7D93iYiCsTD2ptoZZR9+/mxejKXFDQYjWryAq/F3cdcn3DwC94AmFkd7LQR
         1VP57f9Otq6SkvP6mlSTx7x8yfHnZ0TiaMhCutTfr9tlOE43DKtGSojgnWGb40+KyKSF
         66NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785753873; x=1786358673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fe47mFnGJrnj7q96fsdIDjsBMpDbZQXw/JGM6RT1ooQ=;
        b=cF6+2kE1BVEYHYwhoXpzmre8MzXMJdsZI7D7wYGLcrLEPTo+4ROC9iXO8KWS1LGIMg
         LCGP8BFb2dgNlKUM7kJ0VQ2Up9gdnmY6WEsNesRkw4S61lRJubbB7rwkqfgBEaNfrk0i
         SnTNrg+dxgFYZCtQ+dAJtWpHtMQ4AoxtZlus24MxfeGYm5JiEf7G7i/qO3guGMNu46XG
         LcrwuuFtRmqh4xPByzMYdajlTbzzemu1JkOpe5xUsli6NWY5ZuWDPn98HHzCPoe5sa07
         b0Est0tqfAJVGhEMD4VjE4p07JogA4NpCqwqqeM+ihAKdsl9aCAdMykxbdtMJahZSrRj
         NaiQ==
X-Forwarded-Encrypted: i=1; AHgh+RpaynN9mbfeszOHKbAvhbNRb+g8P3PnbjBjrIg9Y3f9GH3o7QfEUqppEvl5YnxPKExrIUmd9GVpMdy7c+u75A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyM47oRz3oRRn+aBxnFiWZFd/JW0PI3BRZshOBtS/8mS3ABgtGI
	YTYum92Hwhb3BWq+qt6BBMSmIh29ZbSdPIFquhBkDUFRVbAKGfGConCvTPj3HnJY
X-Gm-Gg: AR+sD12kr8R7vzHGbdBPeEQtMWhwfWQszWi78QwrITxoSDGp38d0jZPGWb8HLD3HKFd
	t4yk09bL+jQu5FNKi4Jgdl+BfbxnyQ9DrEgvm7vTYPaVzv5Na90sbDtbCUF9md/pPl483/vTojc
	s5UOh2N0S3DpLKySZsHWBFhubIUf8mF5EWmbp4CSvJyhRjFS6CUzDs4qS5c1/Arw7aftp5vwiFT
	mzqdcDmZxBYmBNvzkY1RfMzonYKpltM+NHagISCyzUEsBd3YOtwhN0wPWfa9vwHKoeBrZjAjLbP
	oGhRf2+EOJVT090TZEt2xJjZe6r0Qjy+EbblQFGFyt07r0DeUPd0FbhzrC6Wv6mhXcXjuinN/xf
	AJKV6MV7Cpf3fgBfe7tbZq+qtYdGdvPjyfucvWUT9HYZTYb1saenOKqCJP2DijXfKr26AirK9dq
	qW9DIzhLARbmNwgZH0zHkFkatXjHdbF3Qwpf7JAJMJKXIo3m6t2N5CcJfY+yByNzUhPjlVt/7jD
	+ZUpXepqWuEoN9QyI7nQzk=
X-Received: by 2002:a05:600c:4687:b0:495:650b:4c61 with SMTP id 5b1f17b1804b1-4980c68e3f1mr104460385e9.3.1785753872457;
        Mon, 03 Aug 2026 03:44:32 -0700 (PDT)
Received: from thomas-precision3591.. ([2a04:cec0:101e:c128:347c:a6c3:e6c1:747])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-49807b5f0c3sm199352955e9.5.2026.08.03.03.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 03:44:32 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <kvalo@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	linux-wireless@vger.kernel.org (open list:QUALCOMM ATHEROS ATH9K WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] ath9k_htc: fix possibly missing barrier in ath9k_htc_rxep()
Date: Mon,  3 Aug 2026 12:44:22 +0200
Message-ID: <20260803104424.25880-1-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath9k_rx_init() initialises the rx buffer and its lock then calls a
memory barrier and then sets the priv->rx.initialized flag. However,
ath9k_htc_rxep() reads that flag and imidiatly takes the lock. This may
cause the lock to be taken while not fully initialized.

Add a barrier to prevent speculative read of the lock before checking
the initized flag.

Fixes: b0ec7e55fce6 ("ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bed7ea2425a0..97d61f3f0aad 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1145,6 +1145,12 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	if (!data_race(priv->rx.initialized))
 		goto err;
 
+	/*
+	 * Make sure all the ath9k_rx_init() memory writes are visible before
+	 * proceeding.
+	 */
+	smp_rmb();
+
 	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
 	list_for_each_entry(tmp_buf, &priv->rx.rxbuf, list) {
 		if (!tmp_buf->in_process) {
-- 
2.43.0

