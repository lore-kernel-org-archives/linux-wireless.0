Received: from mail-dy2-f9.google.com (mail-dy2-f9.google.com [74.125.229.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE9B38838F
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 03:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791516250; cv=none; b=powoXpwgvZLo3ZmBRNV1O9Y2X03eV8vpL5aCe9rig7tE7tWnlF0ZloJmrMdq9VtG4hQszd0/2uxjGpoPyqnmu4IDGWCD4nL/5Gusvob/pCOvFwL+LSFZIjomhfbqw6JpZiXUOM9lhpfk1dbZykwbBEWn7eSFw/7mrUkepI5zfd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791516250; c=relaxed/simple;
	bh=HfQYL1ospi0oIvaNO9H+9UdWuav+d2TWanvWl6r/Q8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZST+pK2hBdEDjshh9pIYtsXmC8E8OT2JTllakrW2LI4SNJuhFdHB+xyP1MrwpBsHfFVczQf5BuLFETHSuEd5/463OxmCiN4zsFvohTjn3Q4X4lhtzVKHuwObZ7s9vynU50+g/vVk+vuRiMx2KkLGrsJusndTMKoIF8xQDlyeSEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3/u3JFP; arc=none smtp.client-ip=74.125.229.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3/u3JFP"
Received: by mail-dy2-f9.google.com with SMTP id 5a478bee46e88-35148c9a73aso1840247eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 20:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791516238; x=1792121038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s4oOC1G3sbuDXwdYGrNRIiEKGDq7EtgjRVsujSOv4+4=;
        b=A3/u3JFPMjd5Sp/tikxJksHbvtyKiUcRu3rv4Wc0qlzkFsLJjCeNZaDVWu1GHkBn5d
         aMshgY/l80nvheTwpEaGJFA5g2dv16nRvjAuW6qsYSEKKjKIPRVcGqSr8hUblvcPsl8R
         6gI/0+BSHCI/+hrLI595e1aQ59Io5Zaqub5dgoIn3uhWV/E9nSxDjybldZHbIJdVsxVo
         39nB26zm0O4zKmZTbfwXYMUlYdQrNHLcFQsGLK4SJOB+GuSg3A2VnyVDoK0KDLpwUfzN
         7B+3VBewpzBKO4S6sP4nXl3kYU45mKnomWNUgZqKR/CWRK97gdK7Z81UMIzXYLXDhCoW
         XP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791516238; x=1792121038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s4oOC1G3sbuDXwdYGrNRIiEKGDq7EtgjRVsujSOv4+4=;
        b=pBVP2hT+l10Uwv3UZ0a3rq0H4+gUtPaOjrIu6GMBK9znSrHcBEt8AZdxWgALaQ5XB0
         WQxAI9vNszDjdxBWHA0Eyx5yw59eQeGaeRhf5FI4w1YI2Ow2GAlzQmY7y/FcIXYuGrhZ
         oZQ3+r9BZSyHEKepahDTCi+Ss2dgb9ejEc6T6RO9U+ykdUexHggtiW2jrsUgCbsbw5rC
         Wkx3CjKi2bjsjemDhlcyPFPreUj8aV//rK0ADORJe/gPCBXxrGfMEGhfM9T/p49B/0TS
         3lh6Q5ZyIZnEMtQDzrYHOdCZoEYI+7NFpuNf4fkIgBBuj0BARx933pUcpHaY8KsxO/je
         P/ZA==
X-Gm-Message-State: AFuF++mL6d/7o1Sr23GmtZs1MDNNO2i4B9Mgv5OU/Xr18KRqzVhJpxZj
	DB7z1ShtSyQ7V6naOC5m175B9j9rNhhbUHda740Pzl44hllqiASjw4DB
X-Gm-Gg: AYBFou2pSHhu4Q40qFcvs9YtLVZkDyo/zQdS2Erdh1u5YQQGzrGRGat6j5GOe9azn0p
	zNjyuV+xQufIFhIakSPMZlxtH67YDTyAKnq359oxPftoiqbWBTsiYlAeVWbLD6foanjjyB6pRbL
	ybjwaJBdqnjjaCo6YuAZB9B71wh5dfeOLF9JqfDNg5DQIq8oJnOXkeAiRnOL6+tDwD513l3GIcD
	wqAfYbjyLzUkEkZAE3XK5fHUwuNEL7W04jSVede+VQTx+SZHI1G4/Ia+ZeokKDF0MgLx5HScrt2
	ihrPGmHtxnHfuij4K79YuQui+9GFhTww5oNP9ROkSnNHwVJQdLPyJxgaPoNgoQN42Tnl82QRAA3
	KV2A8KQMS6GDxuIBuzWhlevcyyylFOATPzM2WXYUZEOEIM0GkWcAgMJvZH68DAL+8Wtsa/2QIph
	Sd9XPLrUxFCMzRp+Qe6Qck8Odl0is/mkzJKqPbiRqGW1RVBOAIZfMnoVCCbGE77eICJMpXWdLRF
	rnWWVIW59bYQIwJFE5VA8dBt+o=
X-Received: by 2002:a05:7022:7f0b:b0:13e:5b2a:e65c with SMTP id a92af1059eb24-16a57b13034mr854781c88.3.1791516237602;
        Thu, 08 Oct 2026 20:23:57 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a442956asm3304742c88.16.2026.10.08.20.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 20:23:56 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pchelkin@ispras.ru,
	mihaildimoski@gmail.com,
	tristan@talencesecurity.com,
	rtl8821cerfe2@gmail.com,
	dawei.feng@seu.edu.cn,
	learn.rahul.rai@gmail.com,
	branislav.klocok@orava.sk,
	timlee@realtek.com,
	kvalo@kernel.org,
	briannorris@chromium.org,
	yhchuang@realtek.com,
	sgruszka@redhat.com,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] wifi: rtw88: pci: preserve the RX ring DMA address on cleanup
Date: Fri,  9 Oct 2026 03:23:39 +0000
Message-ID: <20261009032339.31786-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtw_pci_init_rx_ring() stores the coherent ring DMA address in dma, but
reuses it for RX buffer DMA addresses during error cleanup. If
initialization fails after at least one buffer has been mapped,
dma_free_coherent() receives the last buffer's DMA address instead of
the ring's.

Use a separate variable for the buffer DMA addresses so the ring is
freed with the address returned by dma_alloc_coherent().

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 66d2e5f51444..10147375f3b2 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -298,11 +298,13 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 
 err_out:
 	for (i = 0; i < allocated; i++) {
+		dma_addr_t buf_dma;
+
 		skb = rx_ring->buf[i];
 		if (!skb)
 			continue;
-		dma = *((dma_addr_t *)skb->cb);
-		dma_unmap_single(&pdev->dev, dma, buf_sz, DMA_FROM_DEVICE);
+		buf_dma = *((dma_addr_t *)skb->cb);
+		dma_unmap_single(&pdev->dev, buf_dma, buf_sz, DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
 		rx_ring->buf[i] = NULL;
 	}
