Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790252;
	b=IZR2wLnl/PlQWXlcnHnHt8Sa2C2+TEniB0Iklgn8YwaiQCOWhLqGNYKhSyxO/R1awi7q
	 UL7NKT68NTXBRmM9AsAEvc1Iko0YyXx7DpyTkh/YSB+/wkS2lqFuNlzxDQiM2jYOegfIj
	 aJY9sehFPQ/L6iI7aIg0Bvak77UZ6EHUNUpL7gStT4QEKvmYaZlFlv5FjqqV01CfxkH4a
	 57JSVKcyXhG1jWiI/E7ZyqLCiyEkGGHd4L/M+t8UMUhXfzgQ+2h52QRuN0IvXmdevq6hj
	 Pc5voElMD7i3YMLpfUukebLpX3VnvUchDmUUe1eJgN14tsrL9E0uQLluTbMCu2oq0OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790252;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=W8Tbj15l65wdrQ6nP1bdM5KDmeBZZQ0e1b03QxB4foY=;
	b=OqFGGC0Y0LFnLQusLJ/k3dnnT+aWAmnPawwP2nwuPQVXdyrhPMOrcaZaJ/t6+uHp/HZj
	 ohBXvl7aJygLqbn3gwsfHkJzgittaZ8FYj2LAQRN+UQXCf9HUiLuC4Od1XZBUcfG8YVj2
	 7Y8uDRyaU/+HENbluJkWlIHZBJ0WtIgxuU98rLBFKMnvAYk4q06In6vtng6CqtyzWAzRc
	 ErOF4JOZr+qrVnBTPIoFBp1961j2NmKF1hdJj/7rsERdrdNXiI2I9I0C93l/eu41XN7vw
	 kht9lcgWpO3oy9+fEPeQetkjFLsh+B7PfCcQZFT+VVTOz/m1VouYN5+1PLlB1dRCdow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x6kxLp6+;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20020606A328
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 11:04:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20020606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x6kxLp6+
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso4826625e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 03:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793790250; x=1794395050; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W8Tbj15l65wdrQ6nP1bdM5KDmeBZZQ0e1b03QxB4foY=;
        b=x6kxLp6+6OdHly5ZjwbVKxcP5nNxoiBGXacIlAc0bItDupUMHNN3wxAKO/SK6wXwCv
         ZS8bJuOyDtL/3ETRewTitB5b0bLZZrkIYmBtGfiaMr/Oe1fzEX6qhI8e5c+nEb8+aRMv
         fg+JZuc2M6ooueTPGzkXHedrOHw+nOdusL1FhG++ekipJH7kjXjZs0zzZLisCBD424xv
         tLooMNYvxFRoLV/CKo7KTneOEm2fE2H/TBcSDQVu1ewGGKpvyDo8geX54Zvv7a40I5z4
         TyqkhgvcOfqRMaG4InFMSmGtqEO0ss2/15WUXwuW1yeG9Efa1TQ3q4jOfrIJeYUxFkva
         6dpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793790250; x=1794395050;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W8Tbj15l65wdrQ6nP1bdM5KDmeBZZQ0e1b03QxB4foY=;
        b=w2EXS2rDpCDl82Ijg4yvPoHRyDCxv8QsK8NYYCqMq2TDzRbmjUPL25+i9nUlUwl9J3
         /gosV+GJA7CWAK0BukEdazgT4XK/PVYp0xbkv6jmOHnrT0H+RzKZe3lC8j7l5HURArun
         W6fOwx5e2sF35ZWIXbWzne5x88NAtrRwkUeuIJnkECk7RjnSjUNjABHws6hEwIhiHqyY
         ewpbV/QxoU1kd8rBWsRNvDp9O531EY6AtgSFwJjYRvUFnHtS8rBWa0n6VXZ6Blbhw3nq
         WRtU7mZwyK1EWM1xmBhOEI7RgajvRyDkKX4ryoX7b+xpHt4k1Onc46BQNKIt5KeDNcZw
         MHaA==
X-Forwarded-Encrypted: i=1; AKwUvBxryQqT7nUCZzRLXWQKzqx7t/G58IK/qKBIjfD+mgs30rdrz7iOkd07nREtK84iMzZQ78TLUhP+if0rE8gv1Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z+Z6M+r86rIszUPSWnOn4RlzEpHmt//XhjTfPH/Ea7dhAV3kSyx
	fFf6CGYEb+LJ3g1RQoQw5vkhlTEiw5c6K07BzfYptk0IQLOa8f7web4=
X-Gm-Gg: AYBFou045d/5R99KNThw2WUcKFaaKS/QWIfvmnNjU0Q2g7mlJnxfv1/okciMnQ5ZzOl
	IBqs8QKt1Aag8B+9kHzSTc1qsxzFaPbmCdeLxMTkGAXfbqivGZPSnxEFbSEdBK23munzrfF1VA6
	U/dx/JN+YTifAdJSfEjzrnJnQiSlouYfzXV8bza6yszXtGQTDn79+1kMW8h0S6B+bhsrS7XAwEO
	Y4IBzgBeI8JxaYhxoYg1+7rBzmW1N/HASXL7i1wuskY4YNFbCqc44eUUewCsZeYUuTZv+eHGJhY
	h1wYEmbQEu2vf8XlWWYvdGZ0ZIZA4GW/KwTXTw8YoLZaXO1EdVgLgBsIDyhoyE0Icdbbs0YNxLN
	M3V9wNqgVmlEi4g6WKtOIGlWRqG+Jfib9Mb9/M7J+Za1jQcCgmqKUN/w+SagwRMBIoCtI/PuvR2
	36XfQrTwG0QS8svKA1Vik356ORkh7AfojKQltIIOCbyvTcuMXqOubjgnK1sRcgqT2TjroxiIWIB
	LRz1q5NzqHUTjT3iRx2gSycxNoaa7BOQ37LdEwQqo++0LG/gSdPX8xos3z9Uo6lPv4YIreQkofS
	IIbXxe68LPg=
X-Received: by 2002:a05:600c:674f:b0:4a2:1655:87db with SMTP id 5b1f17b1804b1-4ac1228a434mr377260735e9.0.1793790250163;
        Wed, 04 Nov 2026 03:04:10 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b43c748105sm43888435e9.6.2026.11.04.03.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:04:09 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	linux-wireless@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v2 wireless] wifi: wfx: validate num_tx_confs in rx_helper before use
Date: Wed,  4 Nov 2026 11:04:08 +0000
Message-ID: <20261104110408.986252-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

rx_helper() reads num_tx_confs from a firmware multi-transmit
confirmation and uses it to update tx_buffers_used before the message
is dispatched to wfx_hif_multi_tx_confirm(), which iterates over the
tx_conf_payload flexible array.  Neither path checks that the message
is large enough to hold the claimed number of entries.

Add a struct_size() check in rx_helper() before num_tx_confs is first
used, so that both the buffer accounting and the subsequent iteration
operate on validated data.

Fixes: 9bca45f3d692 ("staging: wfx: allow to send 802.11 frames")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
Changes in v2:
- Moved validation from wfx_hif_multi_tx_confirm() in hif_rx.c to
  rx_helper() in bh.c, where num_tx_confs is first used for buffer
  accounting, so the check fires before any side effects (Jérôme Pouiller)
- Used struct_size() for overflow-safe payload length computation

 drivers/net/wireless/silabs/wfx/bh.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/silabs/wfx/bh.c b/drivers/net/wireless/silabs/wfx/bh.c
index 0071659bc9c98..d4c904324edb7 100644
--- a/drivers/net/wireless/silabs/wfx/bh.c
+++ b/drivers/net/wireless/silabs/wfx/bh.c
@@ -99,11 +99,23 @@ static int rx_helper(struct wfx_dev *wdev, size_t read_len, int *is_cnf)
 
 	if (!(hif->id & HIF_ID_IS_INDICATION)) {
 		(*is_cnf)++;
-		if (hif->id == HIF_CNF_ID_MULTI_TRANSMIT)
-			release_count =
-				((struct wfx_hif_cnf_multi_transmit *)hif->body)->num_tx_confs;
-		else
+		if (hif->id == HIF_CNF_ID_MULTI_TRANSMIT) {
+			const struct wfx_hif_cnf_multi_transmit *body =
+				(const struct wfx_hif_cnf_multi_transmit *)hif->body;
+			size_t needed = struct_size(body, tx_conf_payload,
+						   body->num_tx_confs);
+
+			if (le16_to_cpu(hif->len) < sizeof(*hif) + needed) {
+				dev_err(wdev->dev,
+					"invalid num_tx_confs %d for msg len %d\n",
+					body->num_tx_confs,
+					le16_to_cpu(hif->len));
+				goto err;
+			}
+			release_count = body->num_tx_confs;
+		} else {
 			release_count = 1;
+		}
 		WARN(wdev->hif.tx_buffers_used < release_count, "corrupted buffer counter");
 		wdev->hif.tx_buffers_used -= release_count;
 	}
-- 
2.47.3

