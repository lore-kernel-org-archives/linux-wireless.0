Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F6640EBB0
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 08:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786436835; cv=none; b=fePs7dNTFUc+mr0Ad1XtK2df93k5bugxyKhOGfuB8t3CU5nR3DJhy5Xvvt4/SP3kwN7mDf7xZq9RE4lWEtn0LYn9Rag92m+4U/ezUHCkkcOiqCiNTtIDpzbkjKxSnNah5YXMRgQoHZoDQ9Y02XC5kXNgpIX+Bc1P07N4sbUotdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786436835; c=relaxed/simple;
	bh=ok4xpuQbwDIqZ3qpbUpj7vT70ITusOHkGyK7XwCc8+w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SFe1buBZmwuhOFwlVjTTi6w2Uq5w9EjLgr0AK1ziWcXljaSiIhxAjbb1gcoob6Awnje4NE0Ll1K5Q5zhzzPuzUPsVVSwRiVAUQWkDLwLS8wgNACPlv6RXaWEymG1WQuqh4Gy1HMYg67Rk3sGHIjnRJW1Lw2NRqKdTORHVhO+d2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ohm9RiNb; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ohm9RiNb"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49802c418b5so26547985e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 01:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786436832; x=1787041632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3WNN0jBnqjNkMd8rlfEtTd2nbjLXRpa7uvLdlshlheE=;
        b=Ohm9RiNb9d7EF0IcEz4SKAyDBFnJEB/RbFNtXxK+Ed2mlDkTStJaW2WQJvgUjX6Xv0
         MXnB7MJ6/+LdrSXesd7kVUT4znetD2PVjac3c7KFupKgUfKqNPJmmm3QoVugnvuxfn5P
         CEDFG/Sim2KdANFd+fllqz9ClQZuqwW9Rwr86mWy2xaChysP8DrNvELRJL7o2O6w0Rpd
         sWs5iVReC/cjkldMLZS41f6iwXPZTvB0mDpEhZD5HjATJ0kYjOCPpjQ7IXvOwrxUspOy
         lSa0eVxtwzWVf+l15EyvI4xFV/9Uw5nsrCTAhKwrtRUUxwUkL5B81XNmS1S1+qaULR4a
         uRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786436832; x=1787041632;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3WNN0jBnqjNkMd8rlfEtTd2nbjLXRpa7uvLdlshlheE=;
        b=JW+rY/PZvnGI7UAuzLN5zrMdbw5LxMZ2C/CL9A2XwX1FaBr31hcDlxbARHnEmqVNMv
         Y42uJu2CbBUr8DQ0LmSPs/caTluTtgIHQ5jDyV6av33vEHMKtuBY5NZXt5LTQSQUvO5l
         vVmguPTQ56Q3SkEPVD036Ly72zs4on3vqWMwpNmYHj7yEDtSloXoFRNFwTZqAYIGfbsG
         7GL5V/UmNu2qPMKBomgq7fjj8/IpHKCdb2EB9BWgPEMIi5yxld11BzMo008g6/est5ou
         yqV7yxZ1KTyphSNlUnbNpByYssmJoXuD5H3/1VbnjBoNbY0vaSFHGD4vqYwbQ0zX/d6c
         tNsg==
X-Forwarded-Encrypted: i=1; AHgh+Rr6jdwyLGzcrmvA9nMrUS+fgCVsnQ3Xi833njrrwh2XeKDDjYiCM5LvLDxa+R2v+/CkV4fuopQnv9/VS2L0Zw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1kfUH++Ci693eX7Y/bpHWVmUuSAQzyxbZt/x9IXvJuRAtEsjd
	JpR4QWa0CJTUKPoe9OGkQMZE713WBxvCl+/LccycIOMJF5aYdCm2M/+B
X-Gm-Gg: AR+sD123OACEuFLnba/nyglxgOQ8s0bxrbdy7gFE2UAWMh7aIZwtbfF2McSdjIUauVc
	QK30uS/LnqnHOAbSzjZjOKvQ0kxPpc4RzlvUri+fokNMdz4D/IpxtrUtD5xLGhYjBwqwE1swmCf
	VSkGBn27nvVUE2CPGHcK+RUumY31+Mp4yLOX9h6SI+hh76nVnfTHjjKzsi4aIhvn8B0kaLq2oyF
	wlstmiXCTGu5ALfdfbMegE9dXnk7ubjVjDZfRCQMrNC/O27aGPByXbrKtJZNRfPWAyVcKrG5zm4
	D6jQak/+tMRibJCckVLzUG4ig60jCS9CMu63bxOyZPey+4hNhCIQoSSKt7RBRjjidkU/wXN4Thb
	sksb1EPxXbUntYqPNpRu+UOpqmwbUQ1Lpk3Uwa8nBNevVXpDq4gazeqUgd/4EnVvVyrf2I4xMBa
	2IUHCbtwyQqm4KAiLMilYF6b8zxjnUy0LwB71cC7VBiVnmAwAuX5dB9AMqmH+/bR9zymAm5sQKN
	sG3MS/oFoYiaqwttvAUAYmw6rzWSvO6m1TmufftOla+uiPTq5O8Zh1Esf70ZOYcl5HWyOyKUplb
	YnPGxxfcZP0gWld8kNtxIguzoHeyb8DY7P0hhKx+eM+al1np7wMgcUvbGAbppTQSGO9Y
X-Received: by 2002:a05:600c:4f49:b0:499:726c:d658 with SMTP id 5b1f17b1804b1-4997913bf43mr15555825e9.19.1786436831868;
        Tue, 11 Aug 2026 01:27:11 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a133-e401-bc8e-d36c-2d08-c5e0.310.pool.telefonica.de. [2a02:3100:a133:e401:bc8e:d36c:2d08:c5e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49977e89d68sm21853155e9.3.2026.08.11.01.27.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 11 Aug 2026 01:27:11 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Franky Lin <frankyl@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: brcmfmac: fix lost 802.1x TX completion wakeup
Date: Tue, 11 Aug 2026 10:27:02 +0200
Message-Id: <20260811082702.44521-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

brcmf_txfinalize() decrements pend_8021x_cnt before a lockless
waitqueue_active() check. atomic_dec() does not order the decrement
against the check.

The waiter can therefore observe a nonzero count while the waker observes
an empty queue, losing the final wakeup and delaying key installation
until the 950 ms timeout.

Add smp_mb__after_atomic() to order the decrement before the queue
check. wait_event_timeout() provides the matching barrier. LKMM confirms
that this forbids the lost-wakeup outcome.

Fixes: 21fff75d2fb6 ("brcmfmac: use wait_event_timeout for 8021x pending count")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
LKMM results with herdtools7 7.58:

  C brcmf-wakeup-buggy
  { atomic_t cnt = ATOMIC_INIT(1); }
  P0(atomic_t *cnt, int *wq)
  {
  	int r0;
  	atomic_dec(cnt);
  	r0 = READ_ONCE(*wq);
  }
  P1(atomic_t *cnt, int *wq)
  {
  	int r1;
  	WRITE_ONCE(*wq, 1);
  	smp_mb();
  	r1 = atomic_read(cnt);
  }
  exists (0:r0=0 /\ 1:r1=1)

The fixed variant adds smp_mb__after_atomic() immediately after
atomic_dec().

  Observation brcmf-wakeup-buggy Sometimes 1 3
  Observation brcmf-wakeup-fixed Never 0 3

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index dad6f4563d146..b192947ab4735 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -555,6 +555,8 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)

 	if (type == ETH_P_PAE) {
 		atomic_dec(&ifp->pend_8021x_cnt);
+		/* Order the decrement before waitqueue_active() */
+		smp_mb__after_atomic();
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
--
2.53.0
