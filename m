Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792951893;
	b=ZeMuG6L2dqaTT0mJWs4y4jMRmp8L14EsY++SzVMf8nSX0c9rYc2ZWja6dYzK9AIJesvG
	 IRJ+8Pi/LOBMELLSjFSQL6XAqNe5cp9pk648CkmTP4WDrC/s9vP7e/7tfF09l0N7iWo1s
	 dpfmK+7ebEoz2wUSXdxmnB+kiSN8wlsDqdDXzPFgB6rVzaIj35jLSCMr3ewjLy7ySTGhy
	 ROJt8KHossiIjL5tP3npqoBvYgp+9lS7eECtN3VoT9dWcsy8jOIOD3TXLANHdfODZR4eB
	 qZMePH5YRrBNXbN0lpMprQa2OpJWK0cwD6+E3FDKEDiPNeB9aBbOxivqCrzg/4/JDpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792951893;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9WjZ53v91Udvhflq6T6n2CXMPqhGqv+vK8tOndZRFq4=;
	b=5ihLd07p6Ol3UHFXa3cAMEpyPMPwQ8KgoA416SQ0fzgZDmAkNxnBepDPc8UtAuTwLVGE
	 vqjJm5XPTXYj8yHRXUW9lvHnGuT0KEXef744981szgdWd16tUNeM5Fd5k4k6KlEEWJmq7
	 56Df7w8mcJyZ6L1ez1lzasqyco1plFGXhH4pVH04jPqkYKDWJVTqOLGTup09OmDI3Lryc
	 BYCZesPvzgMoJ8Wcnm/AVG/LFyaGi4SA05a9izn8BAl01boMPmDlERuqNR1XMOvZXVkp7
	 IskaDiYmwFzeTYxilgpP8TZ7gca6ZBM0/cBkcDxfmYgrUl2zm9wOfkbMEZGmmIGTCnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GPqgI25X;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBF2606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:11:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DBF2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GPqgI25X
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so1969765f8f.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 11:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792951892; x=1793556692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9WjZ53v91Udvhflq6T6n2CXMPqhGqv+vK8tOndZRFq4=;
        b=GPqgI25XFIOUIFfWoKmMCvrk5cFUmTbN3D7T+zxUCZKFzIUj5qgVISTCWBCCSZ/JD9
         413WsihAwqO1RITYGxNBoXS+AjxFnRv2IvxW2wUQ0h2FekFtk3DGccJddtacCoNXHHH9
         mVF2D127o5jSz5IvhxJTpp9/F6uBYURYDJLFza4HeDm1jfD6dvunn8InUErpOf3Rku8R
         oRzI44pgSrZYmRq1rYCvxDT/i0HgO6XJkjD1cliD2+C0Yo1t2fPpji1fQ3dE0JjYACO1
         uWPDcsq+cZtNTqyE0LIj2Jl+vRDgnJU1YnuJrwcJjhpDz9z+Luj2YfzwdC+d/IOlr0W3
         IWpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792951892; x=1793556692;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9WjZ53v91Udvhflq6T6n2CXMPqhGqv+vK8tOndZRFq4=;
        b=1MxBQAuT14UkpqymO4vfQpgC5Nvqi7rDkIxLay5cd7i9KdWt6kMG4T96iDz8jOcLbJ
         551mD+NbjG1sjgSINCwhhe8sM8gC/ldeHFBZyM+AgtilNoCWj7lwLD0ieGYNVp+raEgI
         PK6nmzLuVrxCrd+P2LgMbQdMDMNazajZjFdS9BjlAPjb45u4jKeLnQ6fz1U8ieIcRZ9N
         3IUjzG9alowQgp6iQyyRoi9SUGZRfScX7M09SfTbJCCB3aWcj1XgGDCQjSNvoEfsxRG2
         WT4ikZtpupiwRGmof4BmgILdis4km3+Zeh96EBwILNldCOIKQC8s/7/HQqg/TTD6NNmQ
         ME+Q==
X-Gm-Message-State: AFq9FYK6LLGpb5FKOovMNgBKU4ypqsWMZvCzFbEOgwM+eDD404ZwB2RL
	v6ob2X2d7Kv3WEh0rwm3FlafbhztY0c07Qw07NqJoB20XD4SU4ovmdsFU0Fq
X-Gm-Gg: AYBFou1zXMhv9jf5uJTcMTzld14rGkIvxleymT9tXjGWnPz41k8P9UcGgAVOiGCyB8f
	pFJIVKtTLsiqgulDR5PoMIbdTM9NAqoRfbFLHYaZmGf+QvzmbVwsTkxGrWVNresHuEnC2J6R1wh
	IOCm5tgdR+dWJILwaks0NPuc153seNJ1ZebfNy/uyWahHdW+U83yANi3R5fUm8HGrGKHhF3/1Tr
	USGJBf6qd28DtvDoEOG7xUrJiMvh0+JsnTUl62TmV4WqIoppgcng2ZSK0SwGH1PJ/GuYvJ9qkN1
	3yz/8Fcrx5zS1+pIceBEEY0RSJt9H77vdVvXnp+Dyb/paXeSvIaAEJuG+jvL+xT7TNmhvdKMG6c
	FJVJeKBjFcOXJgbkRuB7oLddLZ0eLqlJn5RoZPySjGBG9te/UKOAzU0tcyQ/cAS4OOzFldcPuX2
	K6aoPCLF74SaNE69EYa8liTjx4Vhmez54xgLYjW2QhQnF+/kKABa2GGsOxX9zv60THURucwU2mv
	3mvssnhuHeH2oqJRs8cZAuqnC7sMwHTUoEt1g==
X-Received: by 2002:a05:600c:6749:b0:4a2:e0c:2b10 with SMTP id 5b1f17b1804b1-4a35aca32e1mr76300305e9.19.1792951891663;
        Sun, 25 Oct 2026 11:11:31 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0aa097sm152124885e9.3.2026.10.25.11.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 11:11:31 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	briannorris@chromium.org
Subject: [PATCH wireless] wifi: mwifiex: validate scan response TLV sizes before indexed access
Date: Sun, 25 Oct 2026 18:11:30 +0000
Message-ID: <20261025181130.3711823-1-tristan@talencesecurity.com>
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

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 23 ++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index bdd4b8465863b..4c4bbd4b3b73b 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2208,6 +2208,8 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	}
 
 	for (idx = 0; idx < scan_rsp->number_of_sets && bytes_left; idx++) {
+		chan_band = NULL;
+		fw_tsf = 0;
 		/*
 		 * If the TSF TLV was appended to the scan results, save this
 		 * entry's TSF value in the fw_tsf field. It is the firmware's
@@ -2215,17 +2217,28 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		 * received.
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

