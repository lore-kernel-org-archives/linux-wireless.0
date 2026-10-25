Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792953382;
	b=UF5x8K15yHWi0ouAnYkyNrIGWzYc6o8H67dGtZRWnVesr+IVlYCeUtaNJywub02GBCF9
	 AciIZJSRdT2lObf2E5BsOH/A17OaefMGKDhwOe9fXttVzwJi3wHuXc7dAf+zkCDlL5rmx
	 c1c4plpbgK+E+rmY/mXjQ5UfXGUHpMtrKHxfeitqb7qxqirvv8YIWscq8zcobNZ4dtBMF
	 NvXZ6iTXgyvnzInCPyO+QhmRWVY2QOLYrzOsjCa97IQcR/tjCa4I2/ccI/HXRGcQykosZ
	 UyaxKfAxtqpkXbZLP/vGclpgwakci4A25xTx5EzzPpN7xEfIWYQCANY+exDpvnq35BA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792953382;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=31EP1o5OjqqD4mpc+ubvdp77bMY467Ey02aK0y37VeE=;
	b=Gy3dN4Aj11ZoniZPC9365p+LrBqJlt0KKnUjVn44F/S0ed0ZPRZBbu0Hn57oFPQfq6Zr
	 DJ9RrMyiuobXfR3Vxvt4Djpj3T6mWUqgrPaqb/z/Ed7MAbQG/foKT/iiJhQF/ci7Jt4kP
	 zmmb2b0p2c0PZP4CiDA/FtrajqstrFanpZt/tyzrC1KgfrJP47jnPUuCyIvJcqlYpNZwR
	 NBjLAkPbvBJELfPpu1UNWlj4nQuc4M6JbkYZwAKS5Au2ZOBzsqJAEYu1aR7gGAR2r0l6U
	 CmYeTgyA20Od9Quw/E62mfObgyjWEnJ4EohXS/oGAFPMYMyvq8Z0+iG+sRE0/wf5ZEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VIaFz5Ue;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.44
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E1B606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61E1B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VIaFz5Ue
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-48ed0b68895so1249193fac.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 11:36:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792953381; cv=none;
        d=google.com; s=arc-20260327;
        b=Nnj1Yf/AOXta4cXpTivI3xQpUchgHeyqYX/AcP/t6MG9gIP2uKn++qTfIdpce7Q00q
         5NiKmElICvtO19cMX0VAzdxGu0Z1t4x/Boxl+3Ma05LUE0WIWSos/SvEXt6vB3ZRSgBR
         vcTNXo1AdHkqk+8h3jfAyg2/MHMNSGKYAfoyS0lZKgKDdUvhIue7oVCaDARfh3lgBTW7
         LKRu/ggWpsMpU3f7Qi11bNrSyomejhSRSu1c07AnUGuuB9sKFGY1ACFKzbkk5fJcE2AC
         8GkzbVKwzoFg4uvT/G381pYtdjf5JeDTtnl274EoVFKiiGG+JJLA+pEeeSoGaSCIphBS
         B6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=31EP1o5OjqqD4mpc+ubvdp77bMY467Ey02aK0y37VeE=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=HOJH0O/MeuwNDfuxgKLAI/0UerhX05dbKmovMYUEy5Bk/dA4DbEBjcBbkNiqONdIOJ
         nxDVGbHEbPypOjBdT75Ho/qO4nhpsnTDRieI8Rh44yn0CjmelkH0gw8GVEw0h3EvZUL5
         R0WM5kGaoOpBvtTpK7iTRH58XEPlLg8xH8Ld4dAKvLajbb5w+vQ3cBM3xEOlhWQEctoV
         tjVZKSBgHuUWFxDkkj7xEgcqDVgUF28xyAMH1NN2PSy3+d2o9Cp01sWDZ2UVLdjOUY+I
         vCYWjelKZ0K6fZQ+Ha1FsVdDZJ6D/Hqho2qBVJODMxBGqBWQyNbSo1le/wiytsWsuL4g
         yTpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792953381; x=1793558181; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=31EP1o5OjqqD4mpc+ubvdp77bMY467Ey02aK0y37VeE=;
        b=VIaFz5Ue+7a45MfBVl74zq2j+f3+YaRWrwGJI/00aLUrgjUXoNd0R4MD1kpZHEIIhL
         v3XxsaXfRiKDRv9/DB/2T1yWHqnfLxb3hPZc6WpC2sanY8m4B/1jxdfV1xR2yOTEt9n6
         q1v0oS3ZAORzycaljCdOjLbufwtdmIAbDQ81XDldGvus5C+eVfHt4mWM8lbp8/WJeDlW
         CaS0keyZfKYuu+30Ei0WY0JziuCdZGnlKAdfdB7FFli7Uix6wB21HnMH5/EGhppCFd5K
         PFqb/vSchX9BX0U1EZmYrhp5xEaYr1duEkShgHVLasmpp0f7PpYtjQhsJBq/HkB/4KMD
         rAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792953381; x=1793558181;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=31EP1o5OjqqD4mpc+ubvdp77bMY467Ey02aK0y37VeE=;
        b=XfxGnGeEyXoCOvXAT5ExzxCgb5pCQTq5Om4qrykc9EKE98riW9xa8a3NnRanylsLo7
         keAXAJiP7wKchbH+1fuu6+3lq+FJT3kzAqZoSHiHu009insiHoHXIX7MSGHxBhlfOnxI
         xTZPQiZF/lgkosjGdFTk2qzkDAoRXBVdSgtWgcjionWcbZsEIvxXDaaQz0vjrgPxFDb+
         jWVidsYaBwX83laWB2jBaF7w/DWfJl0mnD0mK7QjXmiF24kwLcAYTH/wVsaM3XUbL9rP
         F8my2IEd2o5dF984/rQSFHHHktqmxCmonlhmy62BTON2G0YiC9JxUUj6zMORzJ14IbCx
         ZPrw==
X-Gm-Message-State: AFq9FYKBPn91fqBQ58oSslEKPsa1jVpeAkt3ftuHHsCMjVB4IH3I7XGR
	com6VwvSrtPIKBk6gjd1QRv0OCJeGQODRY/GEhX0K4C3jYvhG3VPZGJVj7JR7bnLI1LZWaWxzAy
	gQmUKo8/ZT6A9cLpTekOEtC0mFN0KkjoQvc0RCdhsTTVH8l0=
X-Gm-Gg: AYBFou2BvfCDoT9VbprwCY4ZpSiasYCBLYKkYnHWfmS6wJrvBv2hMd3v1zq/c+4oUnW
	6Oi48Ku0Kj3maiMe5vOv8To6cUH/Kv8TOpIjlX/gLf6QiGQHE6EjV9HbSuNV0nDX/r83f8mb9Nf
	V+WjhpXRwlDaTiYdDdk+T9+b98lFmjODkZKKeWQ+RwjjyFH7HANT7pSl8a3vusoQoN0mMrBVCca
	VT0cAA3+KAlsqy/L2hfGFK/N3zog8JDAGiSnhoYOCvAmR5EERlXZp5I0YWUfiFdlmEYs5Vu5yFX
	uGrMEPhpc08lNAP/GkMPIDtZwax9ACItbBtB5BsIv84CXj6ru4Qp64iJnGiBFlJkKaT7o2PcEp0
	HyabiP23O3GnKSZ0qE2QWrBKjs6nMCk0fCvsUlg==
X-Received: by 2002:a05:6870:5b9c:b0:48f:e3f5:c41a with SMTP id
 586e51a60fabf-4a83f697a53mr3011231fac.59.1792953381251; Sun, 25 Oct 2026
 11:36:21 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: CryoSlayer <npetr9395@gmail.com>
Date: Sun, 25 Oct 2026 23:36:10 +0500
X-Gm-Features: AclHuK_oC29YzgcQls71mSMkCViOD8kd4Y1jEizcJAQkNSNOCh29r-8uizcLuZ8
Message-ID: <CAEabPvL8adxViMwTFt6uwtocS+DiuYoh8zZoXeBs+huTT7TFMQ@mail.gmail.com>
Subject: [PATCH v2] wifi: rsi: fix missing offset bounds check in rsi_read_pkt()
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: CryoSlayer <npetr9395@gmail.com>
Date: Sun, 25 Oct 2026 12:00:00 +0500
Subject: [PATCH] wifi: rsi: fix missing offset bounds check in rsi_read_pkt()
 for SDIO path

The bounds check on the 'offset' field of an incoming frame descriptor
was only active for the USB code path (rcv_pkt_len == 0). In the SDIO
path rsi_read_pkt() is called with a non-zero rcv_pkt_len equal to
num_blks * 256, so the existing guard:

    if (!rcv_pkt_len && offset > RSI_MAX_RX_USB_PKT_SIZE - FRAME_DESC_SZ)
        goto fail;

was silently skipped, leaving 'offset' -- a u16 read verbatim from
device-controlled receive data -- unvalidated before it was used to
index into pktbuffer[8192].

Any rogue or compromised SDIO device could set bytes [2..3] of a frame
descriptor to an arbitrary value (0-65535). The subsequent calls to
rsi_get_queueno() and rsi_get_length() would then perform an
out-of-bounds read of up to 57 KB past the end of pktbuffer, leading
to a kernel oops or exposing heap memory to the driver.

Fix this by replacing the transport-specific guard with a single check
that always validates 'offset' against the actual number of bytes that
were read into the buffer for the current transport:

  - SDIO: rcv_pkt_len (= num_blks * 256, max 7936)
  - USB:  RSI_MAX_RX_USB_PKT_SIZE (= 3000)

Also add a check that 'actual_length' is non-zero and does not exceed
the remaining buffer length, preventing an infinite loop and a
subsequent out-of-bounds 'index' on a crafted packet.

Fixes: dad0d04fa0f6 ("rsi: Add RS9113 wireless driver")
Signed-off-by: Nikita Safronov <npetr9395@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c
b/drivers/net/wireless/rsi/rsi_91x_main.c
index xxxxxxx..xxxxxxx 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -157,6 +157,7 @@ int rsi_read_pkt(struct rsi_common *common, u8
*rx_pkt, s32 rcv_pkt_len)
     u8 *frame_desc = NULL, extended_desc = 0;
     u32 index, length = 0, queueno = 0;
     u16 actual_length = 0, offset;
+    u32 buf_sz;
     struct sk_buff *skb = NULL;
 #ifdef CONFIG_RSI_COEX
     u8 bt_pkt_type;
@@ -164,15 +164,22 @@ int rsi_read_pkt(struct rsi_common *common, u8
*rx_pkt, s32 rcv_pkt_len)

+    buf_sz = rcv_pkt_len ? (u32)rcv_pkt_len : RSI_MAX_RX_USB_PKT_SIZE;
+
     index = 0;
     do {
         frame_desc    = &rx_pkt[index];
         actual_length = *(u16 *)&frame_desc[0];
         offset        = *(u16 *)&frame_desc[2];
-        if (!rcv_pkt_len && offset >
-            RSI_MAX_RX_USB_PKT_SIZE - FRAME_DESC_SZ)
+
+        /* Validate actual_length to avoid infinite loop and
+         * out-of-bounds index on subsequent iterations.
+         */
+        if (actual_length == 0 || actual_length > buf_sz - index)
+            goto fail;
+
+        /* Validate offset for both USB and SDIO paths. */
+        if (offset > buf_sz - index - FRAME_DESC_SZ)
             goto fail;

         queueno = rsi_get_queueno(frame_desc, offset);
