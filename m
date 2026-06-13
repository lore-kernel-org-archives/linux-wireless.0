Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5620C3839AA
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2026 22:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781390831; cv=none; b=Ts1mYHjB9GT46GrYAuHjOEzKFiPgUSqtZAhROLAX0CBUpOBRSaLYN30yAOT0QokmtlwTlZPG7iQOBp7mA/jS2obiDsf6M8U05bY1P3ilPMAQ5tftz6JX9JjFPMyUsUDt0J8gdiSIrlTndVwKF8Akb3MZuOG5wK3ItulR0MPuKn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781390831; c=relaxed/simple;
	bh=2Xbuext6+w9S9/vidg6qqjhs9OaZkIz1UM3qv3usY+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhIW9jo+wfrqgTJB7e+r5LS9IOxD+peOV2pwGNmG941zEW8nUWEQXZ9c9T83Ac/xMLHYE4K+HCNMQFGhAuu5MByShu/O3vDOWN0VsSdxsieJSHlx8FVWfgYqBRDYLGkn18cEWhpCZx9WK/X4m3x9Px0o1wD7PLbOAl4tAKjZmJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-13817614cd3so4551339c88.0
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2026 15:47:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781390829; x=1781995629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jq383hib0Hf2iZ2gQxzHf9bBmy71fNWICtP0Xddblzg=;
        b=JlfVDcGYQmSAWVL2fgBqwASCskN963yYdF+6p9gUEpomZOpnACAqnF7sB7u2OND4kL
         zf+7X4T8+dWX0S+G/9cCFWThDUsNT9dvfFC759JEPsYnrzFaBjBClIkt7DKr/k0BUkYM
         cRe5fsUq4v2tnpNiC1OxSKztVT4GyDzNLakbP/aOcgxWRulxOa3Mi3QX2rglBVniTWlz
         dmjO3cKzPdSxnjH1UOFvgxbLYK6idVxNgWXsQUZr3CK8cBrJDIYTE95h2VZ0tUN1G2ta
         9n5t4WluLrvB7DIS2tu2w8Zrbk+xWdqXL95grvq4v6erjDJS2sjoP01DRJsKDEpqryOt
         KF/Q==
X-Gm-Message-State: AOJu0YynVAgeO/5yOs/xL+VV/DJ9xEQDqt482jJxnxR9gJ3tmmRLgOo9
	wV12J9D7Cw54tphPRRO0Tbd2SjcSB5Mc2jazddakkIFOnyvoFsTczu06
X-Gm-Gg: Acq92OHiRdcNILJz77MGrDrdVE1kCizGQEEIrr8f9YjFe91RZYZzhQwT1lOW9f8kHYD
	MgUfIs1DXoA6O2UFZHRHIHHOyWz1r9zA3ohXlUMSyZkSuv3WZEjQwme8t9fECiNU902PABntGmt
	HP+xgrfGtck6O+lnLNEtoxuK0y8r/HurjSgveFFmBFgpI98+Nfz0tIZi4XcSOqzhg0Nmocs5bYa
	UUy/5/VCewOvRJUaAm686HMfZNg00wTq+r+WoYxLfTCSSCKAdqWIK7R7FjWC5gsD1li455lOd7j
	OLRJpCU5hULTD7Pe4MWWsi4KRrlGfJrjnS/jBOPTEA+A2zfuJSffFJe0ZZ2J9vPQoTq51/FUbQG
	oLnN26GmkK4BagH+eAQynaCILaUKA/1O5T0ypN7KqtKdF5+8IPwa/sNWU/fsO08Ewrq18F/lZRJ
	LdJwybkxDuIpI9B50qpUKDY/UtnIoU8n+DluFm7KAPRHAB3Y3rGGFicdQNMcLGweUbORsanXbJO
	W68snKxFaRKD9g/6d3bmq6Se77BFlpDquOYESH+
X-Received: by 2002:a05:7022:983:b0:136:58eb:a486 with SMTP id a92af1059eb24-1386f234e3fmr2419577c88.1.1781390829539;
        Sat, 13 Jun 2026 15:47:09 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.. (114-34-228-194.hinet-ip.hinet.net. [114.34.228.194])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b97bf09sm6345380c88.14.2026.06.13.15.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 15:47:09 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 1/5] wifi: mt76: usb: size RX page-pool pages from queue buffer
Date: Sat, 13 Jun 2026 17:46:51 -0500
Message-ID: <20260613224655.2405686-2-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260613224655.2405686-1-sean.wang@kernel.org>
References: <20260613224655.2405686-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

Use the RX queue buffer size to select the page-pool allocation order.
This lets USB devices use larger RX buffers without silently allocating
undersized order-0 pages.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 13c4e8abe281..6ff1eada6d09 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -628,6 +628,9 @@ int mt76_create_page_pool(struct mt76_dev *dev, struct mt76_queue *q)
 	if (!is_qrx && !mt76_queue_is_wed_tx_free(q))
 		return 0;
 
+	if (q->buf_size > PAGE_SIZE)
+		pp_params.order = get_order(q->buf_size);
+
 	switch (idx) {
 	case MT_RXQ_MAIN:
 	case MT_RXQ_BAND1:
-- 
2.43.0

