Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4D63B52E7
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 07:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786950094; cv=none; b=t57OJDCXNNFL7ZidJUwyaMOPsTOCA5nmJtXstXR73qw5dQRgQ6hpnXX03q/EF7VyWL8dYdF24QgwByoKXjnK0vnEi12uE60A/HxGcFHP49NeGfAPLWfK1huPdRbG2916impTS3ojSS1OhgaJTvGUyq7xr/sXVyodoL1nfgbLPjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786950094; c=relaxed/simple;
	bh=6kWVZxkaJrP2alMq9sRei0KuXnZM3rimkkYv/KPNMvE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NV4RFzPGdlsvObLB53No3L2wApAB7vvSS5X0QOnEc/s8jd8KE/6uLpnNLLcnxS3XMdMQs8TDRsOKTmfunKQuGQLP28OoJvXgwjpz6PbF8f3hlHSYz2jSishghhr2N/MHvfsNkHu8jszrg9ldaiKBCQSNnJC/3x50eZ7kXOL+Kds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hRiygVua; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hRiygVua"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aebe49b227so568998e87.2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 00:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786950091; x=1787554891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8nFik9rvis0EY9a3fH4rtoEYKyrkMbT6h34IIsACnTo=;
        b=hRiygVuaNNZpWHnxb2rx572ozj//Zv+wx09ny3d0S3fT+ag37gYAn8vBZbP8pAf4+p
         QXMZ1ZR5sRKDlOwJi41xT/jEyQdAEaL3t68iSyYF5dAbo6BMdYatPDbGCaE1HIGZ3CRp
         zADl2JhzBcU0Qiq9UMB1rZj/SmtN6uXBHH+SwcibvWYVu3MsRqXV3U9h1FDASlB0aUfS
         o6WGY6DXW/JuzDeX1vGC9VycoXhxKEslpA5Jio7bXxl7b0y55wHYUqvMQ6BJRzBUczXB
         bv6UxYXFakSPF0dz8PyuRjf25W/Y5B5E04psG8ajqk2aahHp+BYdmhAjcTdijBkD0cOt
         3Swg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786950091; x=1787554891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8nFik9rvis0EY9a3fH4rtoEYKyrkMbT6h34IIsACnTo=;
        b=lshjxN5cRabZ8i4R045xnnrkO5wDJ+YBmbb7MiYeSFBgkPizH+CZXIiygSObtjttjW
         +GlyRPmbfEXbhm2TpCEd4bfIoV07+meVp24fuRga0tKJPngRBR1zpSc79UiPrLAhBvFe
         a71ks+p1R599tQ56no0K2Zlm66Z+B+b+E1/xoFudWnF3wWYu6tchsdqj8YzC/Ss+PmYk
         1tlecV8LWnQW611S4XUJbpRBGv+dynFM9QrdCP0GOeR5aASHIkbaTb6zoIRRFAGtbo+f
         xt4Qn9u6dXyT+oyeelUsRexA2SsWvyipbEINTHBDghZIAB7d8bvuyJY700KK1nNKjAic
         IOAg==
X-Forwarded-Encrypted: i=1; AHgh+RqguvtFwJ8b0KIHMVxIdWVH5PMs2cFzsDndJDagY8dRZLN3fRID4Itq+uBdJT2F23JBEa1dNz3+LmzmQybuFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZtllVG+ubWH2RzcUkk7shx0+ow2VlozgOjwhPQG5SW6eFfs0l
	4LVNtbBbc7j+SOCF8VaoUkAxSbdp5+ZUZHFbtuzT+rJk1jPU9CC5iGeQ
X-Gm-Gg: AR+sD13tUGJp9RLXFegJ1qzDOO4RkPx1eFvKO2uiXFmBRZJPm7jMcMn7URB3CasD2VJ
	JN/kxU75LtsCoT5+x2cfSzRNoN6O7msrq3xzu4syrzAtTOHFJDvL1tDQjOeWrcQwUE8jsPRvEy9
	quGIBNZulvASzhofW5mK2f5V7jul1S3HyKjUV336E+ap3pKVTQSZDIE3qbNKe8RI4TXaZ7lQJ6i
	X9ZuwL/02o1S6mP5RAM2gxUaxFMWM1+Lxco6svxb7ayEL/AN1XcePelk2E231fQMSuD2Oc53DR5
	qB8k0axNC8qlo7z6MLfwxlnKTgb9bWrdg0BsChGOxmJdD4qEa7hnHY8H/Ude8+qeF5POCdEFlXQ
	g+9m3fSFxJxvWUtXsBSiZWjfqAk+Qu7nU1yzp8t6Ma5QUruCoUKz7tm+DVI2knZfAsdgy1/0UvR
	3om7qpcg7kR+AOLFrTW2OhJcP6lZsYcyp+AaN8GzK1d81cmS7EEMAda4MDQFOfbBynoiJ/8WSfM
	J0=
X-Received: by 2002:a05:6512:63d2:10b0:5b4:59a3:c67 with SMTP id 2adb3069b0e04-5b459a30ec9mr1732291e87.3.1786950089145;
        Mon, 17 Aug 2026 00:01:29 -0700 (PDT)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b46cfa87f8sm141201e87.33.2026.08.17.00.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 00:01:27 -0700 (PDT)
From: Dmitriy Okunev <dokunevdmitriy@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	lvc-project@linuxtesting.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Kees Cook <kees@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>,
	Daniel Kim <dekim@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.10/5.15/6.1] wifi: brcmfmac: initialize SDIO data work before cleanup
Date: Mon, 17 Aug 2026 10:01:12 +0300
Message-ID: <20260817070112.4828-1-dokunevdmitriy@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 2a665946e0407a05a3f81bd56a08553c446498e0 upstream.

brcmf_sdio_probe() stores the newly allocated bus in sdiodev->bus before
allocating the ordered workqueue. If that allocation fails, the function
jumps to fail and calls brcmf_sdio_remove().

brcmf_sdio_remove() unconditionally cancels bus->datawork. Initialize the
work item before the first failure path that can reach brcmf_sdio_remove(),
so the cleanup path always observes a valid work object.

This issue was found by our static analysis tool and then confirmed by
manual review of the probe error path and the remove-time work drain. The
problem pattern is an early setup failure that reaches a cleanup helper
which cancels an embedded work item before its initializer has run.

A QEMU PoC forced alloc_ordered_workqueue() to fail at the same point in
brcmf_sdio_probe(), before INIT_WORK(&bus->datawork) is reached. The
resulting fail path calls brcmf_sdio_remove(), and DEBUG_OBJECTS reports
the invalid work drain with brcmf_sdio_probe() and brcmf_sdio_remove() in
the stack.

Fixes: 9982464379e8 ("brcmfmac: make sdio suspend wait for threads to freeze")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260619064401.1048976-1-runyu.xiao@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 6ac2132c3064..5338d93e5b22 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4438,6 +4438,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->sdiodev = sdiodev;
 	sdiodev->bus = bus;
 	skb_queue_head_init(&bus->glom);
+	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
 	bus->txbound = BRCMF_TXBOUND;
 	bus->rxbound = BRCMF_RXBOUND;
 	bus->txminmax = BRCMF_TXMINMAX;
@@ -4451,7 +4452,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		goto fail;
 	}
 	brcmf_sdiod_freezer_count(sdiodev);
-	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
 	bus->brcmf_wq = wq;
 
 	/* attempt to attach to the dongle */
-- 
2.53.0

