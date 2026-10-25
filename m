Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792952135;
	b=te5NiCCtQPVSWYPn/C94th5IWtwmvx/S5pKZcA8psgkjHp5R90BIfFMYbRKnwJ2aKLES
	 BOpd7fkH8M+gW2SKPxi/kSjUk7oDeAEOvxzznrDLya+2Cg4hSjAe8WvkHxLfSse0rlpzM
	 JmqoFaQfJiAsZpXV9YN9SV/0OTOy+2b5XPy/v9HTN4Hcx5WbIwJXmL/ERDgIiJEts8K96
	 Hvjh3gIrp/u98HtiR+xhm6KdYbPrKFAhLFDzHJ9rI4lCpRU8+u6atud9DrlEGaoluAikI
	 PhtivDAy/MTfQPoNyDMqImGtiG7CaT4I8UXdNMUDOgzAk1N0s6P/NefZIEJ4JrmU9SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792952135;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=04oWWzfIpYNAPZyDmdd+igxHJmbJK3/MT7SSmprnQO0=;
	b=cWFwUeeLB3QylfXtwcYvNW8QtaD1pZrEieRmzcinJY1V1E8vXgJ6XxYumPuXhRN38NXN
	 zZiILAygnWGL/Rr/rJKQVi73PNgvI2w/qgOCxjhzqeLPINbQEft9BhlVX7f7ZXyjmBv3t
	 Cx3DRyLZEGkWQOdyCNZHuDFerJBnKuyivwGm4dLaA47z0VtnN0lISzLUqGu0DAB7Rst6C
	 QQXqdgfxh/0B1Gk39knVkWSEMLEp6DNxp6X0lNkKPClsl8EDnsvSoDb9+QPR0yXAedbI1
	 Plb2Ws2qpyEEWZIrfGRfKbzM+2bzV7A65+rF3a9klXGQaGl4eQzpPwGF08SroXW4ThQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ItefY2w7;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5BF606A31E
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:15:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B5BF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ItefY2w7
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so13411765e9.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 11:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792952133; x=1793556933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=04oWWzfIpYNAPZyDmdd+igxHJmbJK3/MT7SSmprnQO0=;
        b=ItefY2w77k/Kqn+lPWITcS5PXxUcOwecuNSjmwxQxuuPVK1Dk1Uzf7RgqufcqAlpj+
         Y5DQS5qS1u8yBmkgfZc4TRTeK/zv9x9fVCOXuEES3AeuXaHZ/erTJpXyKEEmRIMIRpxZ
         h1bYSRj+NM15ERmDza9UiiLvIuZ1OBcdiMNKoZz6l6cV7JgU91rCTsHOLirTiypNZCYM
         VdrhcTfuGkh+6/l0NogEc6ETClwPKjDrE7tjJiJ4fZYQdjLYswnKXUl4lMHtKkzpBlMf
         VFKLpkAvw1F4tzXLq14o74rRXMru+0AWVg7lMzmrDLSX1yxDCuFVTlrsJlJ81kkYmuIj
         HJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792952133; x=1793556933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=04oWWzfIpYNAPZyDmdd+igxHJmbJK3/MT7SSmprnQO0=;
        b=W2fpdmLnsf070QxoZkyAEBGKgvVxO+6e1wO4MVkO5KzdHJjKW4X6DoJwPPRCI2faBU
         RwDRr1EAmxS6LC4QwAHVwbkg/eUn30txU2cVPb4MRboZF9skdISEXb/1s5gXBahDzOeK
         wXUXqpSTQdHJqk1+qMjyrMKK7+j/q2pfqNLeLzlQULOKkU2WRKRZ2nTKp3OqFgZAlQWz
         BL6xoMoUqkb+EO9/Idk4kxGms3EUlKba+vQa1j50cXiLm3G93JGl8XzxUzJAQWttRPc4
         6wtJQG7SDhXhJFFIOvk9mlXAglk4XFxevQ0Q+ZA0TvkQ4+D0hxw62vyPhEcV3Ii6ZwwV
         yn0g==
X-Gm-Message-State: AFq9FYJ3NbHc5dKhwbt31xxaF2IyOWncK01DI7Ye0Cwbxmpgbteei1H2
	K0mJh7a01mINqhnbHDAT13VLmPWkeVlaDI/q0fXJXHd/EPsrAieBaT3JYTiI
X-Gm-Gg: AYBFou2sH8WoxflroDDzzzG7J3XDdHYRjR/w5x0rhcSU29Ij6j3NLUq9XONhFjfP/Od
	4xvOerwXd48zM3SmTegHwXKepLqwpT/Qyy4NdG/bcZBMEuWLkSBpKRrdc25iS2d7h67H06pPk4E
	21NaW2RD9Dkq1PqQyfj+Wqp+U4lbYz8Nhl9SDzDVVjLt7r63Vj+s5QH+fQliyJ4QJBhzWzdtqyc
	19/tISifywuR45Onvfx5MENuwEpf8WlkBumjj1SAQpO2J57oRdWB7ALaFTIQw3DdPIhDf8xmDfo
	VPr8m7B6mzCZHIfFoIJO3/O+tJQpXCF9QOwYcXaTvr5hQ7ynguCE7LPhQh3+MD7ZoLTy7dVecdG
	/obcsFIS3oemBeO4AkyXXicKpRsNR/SD1ZApyppfY0ZRZfxpNZd9k463OfPlCL+izC3z9VxRQI7
	Iw3I+WcJWarnglnosfcGS/pRqjevqdUApTMOyKcn8zYYog0EDv7ikMuo2sWN5VzDUDXviy2PtAN
	HkeHjPOJnr/pmK4ofESgt819hiRwJfsjKgdrg==
X-Received: by 2002:a05:600c:4704:b0:4a2:967:dfb8 with SMTP id 5b1f17b1804b1-4a35acb115cmr88717975e9.20.1792952133411;
        Sun, 25 Oct 2026 11:15:33 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a59d998sm143804225e9.15.2026.10.25.11.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 11:15:32 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	jeff.chen_1@nxp.com
Subject: [PATCH wireless] wifi: nxpwifi: validate scan response TLV sizes before indexed access
Date: Sun, 25 Oct 2026 18:15:31 +0000
Message-ID: <20261025181531.3744345-1-tristan@talencesecurity.com>
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

The scan response handler indexes into TSF and channel-band TLV arrays
using a loop counter derived from the number of BSS entries, but never
checks whether the TLV data is large enough. A firmware response with
fewer TLV entries than BSS entries leads to reads past the TLV buffer.

Add bounds checks that verify each indexed access falls within the
TLV data length before dereferencing. Initialize chan_band to NULL and
fw_tsf to zero at the start of each iteration so that a short TLV does
not leave stale values from the previous BSS entry. Gate the
neighbor-discovery branch on chan_band being non-NULL to prevent
dereferencing an uninitialized pointer when the bounds check rejects
the current entry.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/nxp/nxpwifi/scan.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/scan.c b/drivers/net/wireless/nxp/nxpwifi/scan.c
index 67d7ff2f10c59..304113b24e5cf 100644
--- a/drivers/net/wireless/nxp/nxpwifi/scan.c
+++ b/drivers/net/wireless/nxp/nxpwifi/scan.c
@@ -1993,23 +1993,36 @@ int nxpwifi_ret_802_11_scan(struct nxpwifi_private *priv,
 	}
 
 	for (idx = 0; idx < scan_rsp->number_of_sets && bytes_left; idx++) {
+		chan_band = NULL;
+		fw_tsf = 0;
 		/*
 		 * If a TSF TLV is present, save its TSF value in fw_tsf. This
 		 * is the firmware TSF at the time the beacon or probe response
 		 * was received.
 		 */
 		if (tsf_tlv)
-			memcpy(&fw_tsf, &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
-			       sizeof(fw_tsf));
+			if ((idx + 1) * TSF_DATA_SIZE <=
+			    le16_to_cpu(tsf_tlv->header.len))
+				memcpy(&fw_tsf,
+				       &tsf_tlv->tsf_data[idx *
+							  TSF_DATA_SIZE],
+				       sizeof(fw_tsf));
 
 		if (chan_band_tlv) {
-			chan_band = &chan_band_tlv->chan_band_param[idx];
-			radio_type = &chan_band->radio_type;
+			if ((idx + 1) * sizeof(*chan_band) <=
+			    le16_to_cpu(chan_band_tlv->header.len)) {
+				chan_band =
+					&chan_band_tlv->chan_band_param[idx];
+				radio_type = &chan_band->radio_type;
+			} else {
+				chan_band = NULL;
+				radio_type = NULL;
+			}
 		} else {
 			radio_type = NULL;
 		}
 
-		if (chan_band_tlv && adapter->nd_info) {
+		if (chan_band && chan_band_tlv && adapter->nd_info) {
 			adapter->nd_info->matches[idx] =
 				kzalloc(sizeof(*pmatch) + sizeof(u32),
 					GFP_ATOMIC);
-- 
2.47.3

