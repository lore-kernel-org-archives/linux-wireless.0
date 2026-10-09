Received: from mail-dy2-f6.google.com (mail-dy2-f6.google.com [74.125.229.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C410125B084
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 01:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510627; cv=none; b=Al1cbBMjVjlg9F9vWLILDEo+OkRi9t0Vsub80caQZAsH0u/RTPxUbl92aD4FJFyAsZaQlFzAvtf/A4k63qcGF4p6Ha2r9hOCNf6FArkmgqh9p2Yb/EGe1i9BpWdoEWNrVT4wINYyDzrufkHDA05tgycyC8xmlf2rj0KcIsS2YOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510627; c=relaxed/simple;
	bh=s/mLc2JYZ08lN5x24bMO+b1/EM92HqyIhdkyHZszL9o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qj1bnkfieP42Q+DmBHCXz3NFoQXWofk4rYxuJlbCiQUg1ZKxRduPtCM61f1UzSLjUk8g1pmHPUtQlao0nLJsvbra4C94yzVWTJUCvz3We8HhhIY/86aeGKCHST9hYoOoOTEida3rI4+Qc4G2A8iHBYJretCSaCJuRz3myIaumyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HRoAsuoD; arc=none smtp.client-ip=74.125.229.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HRoAsuoD"
Received: by mail-dy2-f6.google.com with SMTP id 5a478bee46e88-33e48934fa8so2265515eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 18:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791510625; x=1792115425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WhHTyXZW81QBiMLsBQIivjraSKuuYTMoCEnOnmIA0xY=;
        b=HRoAsuoDIH1uAorXcBeVa2O+PFRZVohxp5hCw8J6DNUp6pRtj50aUTm2qtkvnMymkY
         gO/qYGDtdIcKvdKQ9sZoYU7hKlmDHmdLJYs9xD5uakN7NxQ+LmBxSLhEsqmz4r12ADSN
         9OeCDz4zo5XwTDRu0fW4FEPiXe2XTwWPG7DtUVthNPSI5/fP3xdkAK0GJVMbjeaDjjCI
         d8hPLGeRjfgt7RPLb1ZzzHBDoxHpHRuHlVIq1NgWV7T2B5Nxqi4Tbg3I8WMQ08g/uYet
         varP65/ATwRvbPRFYWX3gKWMv74+UM5Lh0R/xbCAgKTpNQ5GMwruXoqfvAJ+VHRPlSbZ
         MjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791510625; x=1792115425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WhHTyXZW81QBiMLsBQIivjraSKuuYTMoCEnOnmIA0xY=;
        b=NEBZpbRl1EAccvWms3PD4JRfxm9MoERJsPAGVDRLT0++Vh5SqqstJUsG+d4uONax6v
         IPKYgdVwGryhLYZA2/Asibdq8GjFdx7vvhsdugjk6CTjHtBQVtnjelCuds8P82CeW60q
         UGSKQ4Jm+cczkE5Cu9LGcVccLKV4OrRJNZFzjCCimUYkk1xHHw1LK797X7uBrySB0FqR
         veNYn3rcJrkrWrc5IHYOdOVM7gIMqWEnitkKNOIUpadrux7Q6Gj3Xug7FA7Uv4x5v8Ka
         z2lWNXoeHn2Ty+od2Zzf5+idlLMeoMl77v2XIutR874jBsK0y8iYH/7BqEm35GtDN6P3
         ENPg==
X-Gm-Message-State: AFuF++mrpAY8Lj3TtMdQR3FR7ZqgrFhAoxQgPHs51yTyIHiKwU/ihBJH
	WxtyPMojfeIH5A48XSfTOvjT38Z5bpQbzbXnUcDGu1KfXXz4Fuu9COg2
X-Gm-Gg: AYBFou2E+z28h9nyWxPBxEzPJGyDWQDGLMO7zkZ8q7lBrfLcbWH4VzM72J75jmT7jns
	zbjAY7jqzAvCvsiY8QoXU2eSAbNa9WVJFNO/5hwsEwn6Ywp6+iXXYdJgHzRIfuK9d71u3msoc2U
	nluM4n1fczhJ1GwUIdCTw2cW5X77QqqPzcIdV/6ctNpDiuVqGjY4gz0XppcPvo+65Qy6X83e1bo
	V+D9QAb7VDzfIU+qXC+x8fG9Zjbd3BFhWdDNkqfJKprqt882lbwRWokOEPsRzi8tYNbMkdtOYi6
	1iNSlaA6nX8RiOnvqvdRdRrOouADQTYfW8DxYjNRWPX06SWBGz0fcKOurEQNsk2h4uog+WKBi9w
	8AaZeBCuZ1LMvH78HVpAldHna3PppsOmYN0XTdJBtlRlxcK5OD7dzE+/1n2hmCfNb/krnlBTyp6
	xAOq8u71WZ9PYP0iYZfbceJ5hlmrAqiKZqoPNoJLIr5th+yXfVJojWUJ1j4YDGO2yRDOHOtlPU1
	LcHesq70r887O1fk0edGfy5D0akcehK+AkmJA==
X-Received: by 2002:a05:701b:4212:20b0:168:e942:4e62 with SMTP id a92af1059eb24-16a61789c56mr512934c88.40.1791510624763;
        Thu, 08 Oct 2026 18:50:24 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-16996eac537sm1903698c88.1.2026.10.08.18.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 18:50:24 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	phhuang@realtek.com,
	luka.gejak@linux.dev,
	rtl8821cerfe2@gmail.com,
	johannes.berg@intel.com,
	u.kleine-koenig@baylibre.com
Subject: [PATCH] wifi: rtw88: sdio: copy RX status after updating the frequency
Date: Fri,  9 Oct 2026 01:49:41 +0000
Message-ID: <20261009014941.29137-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtw_sdio_rx_skb() copies rx_status to the skb before calling
rtw_update_rx_freq_for_invalid(). If the frequency is corrected, the skb
still carries the old value when it is passed to mac80211.

Move the copy after the frequency update, as the PCI and USB RX paths
already do.

Fixes: 53ed4b25a79a ("wifi: rtw88: 8822c: Parse channel from IE to correct invalid hardware reports")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Built the rtw88 directory on arm64 with GCC 13.3.0 and W=1, with
RTW88_8723BS, RTW88_SDIO, RTW88_PCI and RTW88_USB enabled.

A userspace test of the old and new receive function, with helper calls
stubbed, confirmed that the corrected frequency reaches skb->cb.
No hardware testing.

 drivers/net/wireless/realtek/rtw88/sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index dc2fd0f8f9ff..7c22f0ba5329 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1332,8 +1332,6 @@ static void rtw_sdio_rx_skb(struct rtw_dev *rtwdev, struct sk_buff *skb,
 			    u32 pkt_offset, struct rtw_rx_pkt_stat *pkt_stat,
 			    struct ieee80211_rx_status *rx_status)
 {
-	*IEEE80211_SKB_RXCB(skb) = *rx_status;
-
 	if (pkt_stat->is_c2h) {
 		skb_put(skb, pkt_stat->pkt_len + pkt_offset);
 		rtw_fw_c2h_cmd_rx_irqsafe(rtwdev, pkt_offset, skb);
@@ -1346,6 +1344,7 @@ static void rtw_sdio_rx_skb(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	rtw_update_rx_freq_for_invalid(rtwdev, skb, rx_status, pkt_stat);
 	rtw_rx_stats(rtwdev, pkt_stat->vif, skb);
 
+	*IEEE80211_SKB_RXCB(skb) = *rx_status;
 	ieee80211_rx_irqsafe(rtwdev->hw, skb);
 }
 

base-commit: 83de3a16c7b37064a59305040ba9b0f93b832794
-- 
2.43.0

