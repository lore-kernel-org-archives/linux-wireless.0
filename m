Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398127;
	b=TXG3kjPh1D9AFK4ferdzhVl6sGQ/Mk/AuI91tDD6dpmu0Oys4Ev6rn4OMtAuM7bvA1AZ
	 +QRDiH64WQ3qPEbIZcjR+vRKM/BiQlzglBLj0wpf9HCC8DYl2bp4ydTs59as9ANbalSt5
	 e9IFsG7/X5j4aVflxxNj2VpyuGOrGLEZkRm4CzguBxymHnNTjiJayKFeqso4YPTJAdiqj
	 H1wdQsm1m8h9+rdzljpMuMUuH+DLDdPrHSlm8RP92EeV2rSWn4DzJmkKMHTEIb2tcf1cl
	 AwnWzbezlAUqlY+Yztqnq8NBHmtAJySydxaw/yYHwODRjUUnJ/OpEEJT13djTccW4JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5Y4WIvJDYTWJv68p7KaCr9/OdFM6n4ms38ALF2iW0Oc=;
	b=GVZQf1oW9hcmg68lBx8x0Ou3dxlyTDQzkQ35ZXE490v49Ekg7UuB2vEyl6fhA30ytyLU
	 zZpJLYjL1JV9dXoWh2EKivYxqTWM9JFjnmUzbfpmors/TyRJNICCE/Mp4ANVIweRNz1TI
	 ImMjRpX/DJp7RCTshG7jeaBpY2gvRjMN1ZbcEvqv4hnjh9e4GTeg1IHWQQ/E8hLQ6JnWq
	 IMx65ThCQsD74sr2SYUEPc8Gx8yfl3qTyy5t6osTXKxpgl/55lu8QcEkn0UVzP4AAVokN
	 mcUxR2vhD/BtdksLSuONHMehAq4OXu2iloxC8f8E1t51VWYGp1xoPjIvIm9DCLkDFXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WGqc7XOc;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D77F606A329
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D77F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WGqc7XOc
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2d6cf958bso6207585e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793398122; x=1794002922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5Y4WIvJDYTWJv68p7KaCr9/OdFM6n4ms38ALF2iW0Oc=;
        b=WGqc7XOc0E0qsd7/OwyF5TfYzrtkzudDHUIXfC3R5ZKXfviFMHazCARavIbMHu3OJD
         dFYAEoZPEsvtJcOjXNojB7QboDiA+WpiEoupeKNXCCVhruOfzLjSa4I9oT19O4MjV+Pg
         n0tT8YtK6Oc0j7j/Ba2usYKcEH9wGgtSFxyF3SgwtD2C0jQ0N1xy4q9m2Am/oyWBUZXh
         pyRvI5K2PNYmYMTMIteM6qt3R+y0Zbl5Gqak0Ao59FfwZH4w9+EBy9K2y1RFsISXJiun
         LN36Y9UJY2Y288iNhvHKaRj6CT7OSHGr5wWC6ElCAlfCTPgFfjmhaWx5P01l5e5ZKvsJ
         jjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793398122; x=1794002922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5Y4WIvJDYTWJv68p7KaCr9/OdFM6n4ms38ALF2iW0Oc=;
        b=Mp8ZDikHcOflhQfF/wVUlcUfMK/3sMSZBNDgopxsP6IwXg3CYf8ieYvYRz5jrmlR3m
         kM29KeQknBPlTIzqAEY9FhYC0wZGlPBGkfNbpOieA4PpjtxssY47fzc4MHllHcedoz+4
         3ry9A3sk5Owsz15scmd34VWCtUQt1Qs9rgcd8vb6zyQSBRaQ47HKKZSfz7IKvnqL5J7k
         nN2OuSlaBia1wYnr8bGMr2sWEDp/9b3Tu5lCnCXwG+QycUO0HOo8+QVpAUkwWyp1JaL0
         joPvAZgBwMAFa4ruisOXBNpQ7bsxuq97fmE/ft2fyXW+NmsVOJUqgb1SmsZskJ030SEo
         Y9+g==
X-Gm-Message-State: AFq9FYKkzAM2iSF7hw4VCNqclefS6D5pTn4QWlRLdFU0IuaD6vyoAumc
	m1ldAgu9lGHFIbCqzY7BOn48Fi8qZLykJIDbKGI8/8jsjQene1PTm0Z+
X-Gm-Gg: AYBFou1R5huFJjs5ZF1PM0f2RNqqlFP5ecqJYIdYuknadiWmXzCTo9pvOVv/vp0Mupp
	0j7n3x1cKzpEJIHTGOIwodppQk1Zkf/pd/BWyRji8fIiEOVcxN1QM1tbJoixnQwmGeGA79s+F1V
	4pGEiubFl9hM/hELLiiw/VU5MCcc9MP5b1IrIqEas9FHR+cjD2UYkuqBbeKNMhvz84r6TeNARaD
	8zVC1pzJskEiitzFzz0A/G3zY23FAXS86TUjhFgB9wUlb7vXN+UKIAoXxt9S0AysVLtnY5mpeis
	4IgtCjCykCWWDlamGSN9XGf8Zh95A8I0vIRq+7eQDcIdbLhe5zswGD9+ip0GOzpTD4Ji9Kzk9r4
	xasz1cemhEm8uXM1Jg588aePvKvp+ntdwbSJ9f6BV7wDJFoejqPS9bXfmm8eAg4Z7ybc0RJ4gn6
	e6iSfiOLJ0T+jLv8YDI8i4qSB6NCGS+nryz5iTauUHxKLg1qo1qTXIRhS1U6Iwyx47avs9XORHf
	ZJQgog7eEDjUvxR3ubEzaxqA98/dT9pibtLRannu0fPISjvF1vmiuqHdHYAUAbAqGe+fbd7kKjy
	YCqknFkWYF41sbVnJNG2jsptKcXwuQ1B2ih1tb+YoACdCyekiN5ddyP4JdemhqrhJS54R5qebti
	tBpu/w0F0dS9K4z6eYUICXkJSgJ9x2+CANeBT5sO5wrYNhyeLHjfi/iu4hQ==
X-Received: by 2002:a05:600c:474f:b0:4a1:f8cb:7d70 with SMTP id 5b1f17b1804b1-4ac1793ed87mr83381555e9.24.1793398122427;
        Fri, 30 Oct 2026 15:08:42 -0700 (PDT)
Received: from u1804.home.lan (152-43.dsl.iskon.hr. [89.164.152.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abe7706516sm56230305e9.0.2026.10.30.15.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 15:08:42 -0700 (PDT)
From: Goran Sustek <gsustek@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next 3/3] wifi: ath12k: name direct buffer ring modules 2 and 3
Date: Fri, 30 Oct 2026 23:08:24 +0100
Message-ID: <20261030220824.915760-4-gsustek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261030220824.915760-1-gsustek@gmail.com>
References: <20261030220824.915760-1-gsustek@gmail.com>
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

Qualcomm's WMI interface definition (WMI_DMA_RING_SUPPORTED_MODULE in
fw-api wmi_unified.h) lists direct buffer ring module 2 as CV upload
and module 3 as Wi-Fi radar. QCN9274 firmware WLAN.WBE.1.6-01243
advertises module 2.

Add both to enum wmi_direct_buffer_module so their capabilities are
kept instead of skipped. No ring is set up for them; that needs the
features themselves.

Tested as part of the series.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Signed-off-by: Goran Sustek <gsustek@gmail.com>
---
 drivers/net/wireless/ath/ath12k/wmi.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index b508aa759bd8..9444a1f29813 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -2378,6 +2378,8 @@ enum wmi_beacon_gen_mode {
 enum wmi_direct_buffer_module {
 	WMI_DIRECT_BUF_SPECTRAL = 0,
 	WMI_DIRECT_BUF_CFR = 1,
+	WMI_DIRECT_BUF_CV_UPLOAD = 2,
+	WMI_DIRECT_BUF_WIFI_RADAR = 3,
 
 	/* keep it last */
 	WMI_DIRECT_BUF_MAX
--
2.47.0
