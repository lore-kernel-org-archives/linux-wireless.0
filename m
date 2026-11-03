Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748414;
	b=XymkUAQoGhLPOC/9lUazpt0kJBzs4DecwhkyuIK1Xh5pH/DK2EdtU5a8apnT0TYqlCOi
	 FeURZtBDEhdl5om6emWgc403vKbwfaUyItNf3JNhvsS9FyDJuoivRamh34xMMtIjUoiYS
	 Tw5R7OMKj/1l0sLSWvcsof0EsD4e+tCWVK/HuLSwbOlXnI7AJDc59muaMkSBDUaSgD1nx
	 a76qmEBQikWCe0tsf8LT2IKLb2WKlt8GCNIshXyj37S2k1iKwbefhRirzWr5szSVIktOE
	 7VZCMKpwKKDL94U6cf+bHksjvPCiYc9XDVpURRDDl7JIhR3W4HrYJMCvkjkBGzQYULw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748414;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6GC1/D8rCTZG76ZRBb6JFA+whGRoK5mBSHc05PTJ2Kk=;
	b=fYIl9C9l8BWFTIw6grLw3XMCoptY3lnrQbolZv+yVSgHEhfSzeclT5QdpOreUFyVBcWb
	 xlaHRCxHWCF3uWyuGhAQn7SNRRzfEmUkfyxg3jzZUBbbYrd7AIPJgwt5UEsM3LJhdNG16
	 SmDC6W/buwmAn/CVqTQN4RoaW4HZ1Ka7TzId4KV9XYB1vCE6yOm+bALBIUR48wBYrpoNT
	 6BfWhhGOg/TRMeIPiV4IQfIIXrNUdzULRpweEvZFlcPQpkn81hWsvwuImATi+tKBt05tQ
	 yL7T35cdra2rDSr4/BFCtNnVdHHQSo1/zaPtj/HwZ25pwVcD4iVeS0U0KVARWYvRiQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O9Nn3YTE;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39917606A326
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 23:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39917606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O9Nn3YTE
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so408295e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 15:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793748411; x=1794353211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6GC1/D8rCTZG76ZRBb6JFA+whGRoK5mBSHc05PTJ2Kk=;
        b=O9Nn3YTE8dyOZfeNiT5qpPNlfOm3EpYECrP3B0GPokTicn25MDq/RklC3lk/43H4o2
         YwK5z7zAxc+yq5rl3ajLofqGchDVxhiHP4kdq85jIj5F70xyhoRXzXtkg2lW02UV/BF/
         0XtglXYfHNqnVdECtu8K0Y4rNO9WiqaDuopEEZCCIVpGbHrAY1EgS3Z4YZBYhlxmFVAv
         RKqPEJcilYuUi2qnG7qmEw7L9cNB3HppLx17T4mXPAvR49XenhXqZgIMr9MtTrfMk57w
         pj4Syrncp0XCTySp4/9eonuhN307DFVRjQIccB1QOecqL76g28Zlbl1dUvm7fhW8LcG8
         UTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793748411; x=1794353211;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6GC1/D8rCTZG76ZRBb6JFA+whGRoK5mBSHc05PTJ2Kk=;
        b=L09jz9fSwe01iXFpYqiEcv6UbFPdppuT2MJ8YW/52ErEPIn2fiuzKp6hTkicbkY05F
         9r9hhdHrq7WVOFZ9k+g8qm0ZoAs72s0XvNJIzCyqAmHNVd2e5Xi7fJiXjR68md7Ccj7w
         /4P5bQkuJJlKCPRDXfgo0takeUBhrTDc+IUY9P98hQPpfTdMGayWHxIF15dOlvkeUSF7
         hsFquUzTfptTFM5PntDgwgVHtCxKAN87tvyvzr020yWTxEgY3rDAxFFZZ7HptAU03pNt
         /AhD8M+MXkJugYAiXDa+sMtY+LgQhuQMr4pEe0msPfx2RrfP5oe6ZiV7jK9G3b/en57R
         kgHQ==
X-Forwarded-Encrypted: i=1; AKwUvBw2v0fy1unfqBNmZTqhiJyMa/af+0KmNic4mRAcnduVKD8Kuh5updHGHABq7TOHQm1dfchlZsOEuBaAsZfj3A==@vger.kernel.org
X-Gm-Message-State: APuU4Z+CxKSkZ/y3Fovz8xCYmb+YlK5sc0bJY3MGVEpiqqwkjjtgNarB
	hLZMCTyWiylbgFLvI3lK1jBcI5El/DKCV6j8SZyWh5dGpDT9iWi1WOI=
X-Gm-Gg: AYBFou1YjyUqs++NuxLRFP0UDG2IONhN4xA+DWsLMloq1q/vbp71TARDozgwSwEPhE6
	xq+9N481XcYL8MfCinJdnOsNjWwyQVBbvf7O91R1XHIilUpk2W58hjUS+bZRPQR0wzaijTKebf0
	ZlErWAEKszZujJOyfQs469BH5cr86G/eIa5ufLsTQorrr9LSumFBCL4FvUg5Lkl9tlrOj2DduM3
	gGukjGvgY0mNPsthIjRfAxbEJXlqMWVBfO4LZQj1xWXqdFL9X3+C6WQsHzeWmsKwhFJjDypvMPz
	OEdF0LfVlYQBg9spHM7qYTf0GujyUMAqfhi2ydFNFMZwD5d8d4OI68qz4p7NQxy+A7d+B2FAn6/
	iw/bgDXg+1qwq2jxFs9iF8kbYx6UzWHLiAmn7ySOe5RxTbk0jVC9XI6anujnrqjeiwtSDU5EOtZ
	SBM4B5TFJOl+suRK7X9yNDTGD4rHBgAn7hPcML9V0bvaVQUAGHMhbIG01/GRPKbcypjougtgKnU
	lLTn8WV3Eks+mMstGwTliXRqhJ7WhW6W92O1VJCBEyijT4WqOvmx6ENk2xs00gZsWk/tbuL+NFa
	3s0V9Ghql0imyXXk1V0=
X-Received: by 2002:a05:600c:83c5:b0:4a1:78c5:79f5 with SMTP id 5b1f17b1804b1-4ac1970b976mr282294535e9.33.1793748411490;
        Tue, 03 Nov 2026 15:26:51 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b43c17ecdasm13822005e9.5.2026.11.03.15.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 15:26:50 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	linux-wireless@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless] wifi: wfx: validate num_tx_confs against message length
Date: Tue,  3 Nov 2026 23:26:50 +0000
Message-ID: <20261103232650.13350-1-tristmd@gmail.com>
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
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

wfx_hif_multi_tx_confirm() iterates over the tx_conf_payload flexible
array based on body->num_tx_confs, but does not check that the message
is actually large enough to contain that many entries. Add a check
comparing num_tx_confs against the available message payload before
iterating.

Fixes: 9bca45f3d692 ("staging: wfx: allow to send 802.11 frames")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/silabs/wfx/hif_rx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/silabs/wfx/hif_rx.c b/drivers/net/wireless/silabs/wfx/hif_rx.c
index 64ca8acb8e4f2..42417db66c128 100644
--- a/drivers/net/wireless/silabs/wfx/hif_rx.c
+++ b/drivers/net/wireless/silabs/wfx/hif_rx.c
@@ -62,8 +62,17 @@ static int wfx_hif_multi_tx_confirm(struct wfx_dev *wdev,
 				    const struct wfx_hif_msg *hif, const void *buf)
 {
 	const struct wfx_hif_cnf_multi_transmit *body = buf;
+	size_t needed;
 	int i;
 
+	needed = sizeof(*body) +
+		 body->num_tx_confs * sizeof(body->tx_conf_payload[0]);
+	if (le16_to_cpu(hif->len) < sizeof(*hif) + needed) {
+		dev_warn(wdev->dev, "invalid num_tx_confs %d for msg length %d\n",
+			 body->num_tx_confs, le16_to_cpu(hif->len));
+		return -EINVAL;
+	}
+
 	WARN(body->num_tx_confs <= 0, "corrupted message");
 	for (i = 0; i < body->num_tx_confs; i++)
 		wfx_tx_confirm_cb(wdev, &body->tx_conf_payload[i]);
-- 
2.47.3

