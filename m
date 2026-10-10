Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BC33BA22E
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 10:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791629291; cv=none; b=mnBJMaMhPF7u74NRqCCi8JrxtmsQfLcOD5e6DyAtoDD83ED1TIFClIKjOQs4/AhytrqmN5yR0T5+18JAWV+5lwnykxTIdYMNihb+YdxWg1RFCOHlMBbrrUh1b26igai8fuyzVt0YZWKaIE1hzz5r3e09Edis2oynRk0a2Qhv6rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791629291; c=relaxed/simple;
	bh=7NWvbpIQWi3qzTqFd0LyYidZnr4cu+18lgerSulajfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lVWf3eE4tJoTQrp7C5zZCFsEfIBfxP0LCLrtExv3he/8uPjSjxl4AzATOES+cvBwj3gfe8zCvNqdy0L0kR/JA45c5w/JAAKCpzOv0Rmi4khU5HaBSisJtEyCMyib6SYnpXEUhhxXnI01Hf1aospk3Be8DQZ0KSDn15+FBfiAKb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gkq0qAVG; arc=none smtp.client-ip=74.125.229.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gkq0qAVG"
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-3535a54c09bso252160eec.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 03:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791629289; x=1792234089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QaSdzpcAMrjh6Y9ok04vrYGf1sEpZ5LikVoH84PMQAo=;
        b=Gkq0qAVG9jdFlPp7TqjDCp8trMnfWlUqemew9XTRovf7Mpvu43fTf0de6k3Bd+kYYU
         bxaaKq9h6LbydZIW35WrwcQJx1Bl9nXAgjvIQh1n0LxLfSRpK53GpHMM+CtMMtkLFgYZ
         rIrIrGg1L/KhoYlMoQH486tK9pyBCxc904A6G82m8md1XueAzgBLB/M1j3tV7TM3DYpT
         Y4ErGm0lsbYKdQFqu5y4QooIAAY2ZO9B9W771JxPhPYyz7xkM5rxYrF+C7u8SJPOhyTS
         59M4BCVCwsv7S6X9Sz7mZUrt4inYkbFG0Xlidl2ei3/471UQa7uYGlS4n1C/IqCaNgsr
         qojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791629289; x=1792234089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QaSdzpcAMrjh6Y9ok04vrYGf1sEpZ5LikVoH84PMQAo=;
        b=pvu/45En1WkdD/DwdfNLnP95ymELhfvVZuTJGmL4mbKGpKBijyBck8XhTnlIhVW6Tn
         FKYqzZl6f0jilOZX2wsD+SmG0KTu4E4T/DP7E3PMHYNoxImt7vjszQvUkXJQS31BB7cq
         fAfKfacCIJf+uQCaGElfjZgdckzlkU7KPWMqqMer/3/7vecy+kQZuv2qvhLAOUpV+/90
         e/80nMCr+WW+nY4acXK//qoWoH/t0URddOYciiwIXm/8YwP11XAc2I7PWzH5sEMsoEpT
         8xeudg3B10nw9d9PgiJbrP7hPUJjeJRXzdnW91FlBripvPlonlrNFPzZPExiZo+s3Uzs
         pIcg==
X-Gm-Message-State: AFq9FYLp6Dth1kczezjQvRP4zbAZ8k8LSr3PqC5mKIQD12Vl4EdSRtL8
	TvQZ1mimVuCbpFANH5rqe9FgSCrQtwouMAHiLMpG9V5QiA/9NoeqHw7XpB87WRiT
X-Gm-Gg: AYBFou0mUQ/mVymId9Bdzk9eDcMl4Rqlz8lT+EvF01s/kdParWPz/ZSEcokw0sn4z5w
	2yyZvp5DKmCO0qEMOaPmQGIjiMrDFZP2R1/o6Zd8VSyE6Ed4ml+3Xv2N3Jnsi+hOnRtBOfi33g1
	25fjdxG8ELtvP9y9qzVQHFftPCpms9ai/OAMm0z0uNgrYLGWooZUmNdSKg/3QJXCtPfmnyRiV7T
	rSOpzusAfj/2aKhRNZMwcdBgBUpNW1IFxFj7Ehhq8dx/txZM7ELDwqJvc+eaYynqLkCKLNBZBxQ
	+yEMdJJTd/+FzXrTaDPw9MeZ7QgOExDTrWceBSepUMR/cZNqq91YlYDtP6GHPXZGhLA3ndycSHb
	QJlAlTB3Qv0hO6kxKPv5EJNmDSpAEx8xK4f/PVfuicpJ4aGxLDCsi5nhbhWsj8aeADolsx2lVYr
	nJINFwJV0D317WN7QQC1KsFLTP1YrTRLbnbVv5FZ91hg0Xiw3Ja/faL6yN0RtOcPaU2bTfX3Qx/
	8Dk0z2zC6G7MHV/s2G8bntx8hk=
X-Received: by 2002:a05:701b:4586:20b0:169:b1b1:1445 with SMTP id a92af1059eb24-16a5dbfe73dmr5319479c88.31.1791629289039;
        Sat, 10 Oct 2026 03:48:09 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a567bd18sm13046184c88.21.2026.10.10.03.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:48:08 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luka.gejak@linux.dev,
	rtl8821cerfe2@gmail.com,
	straube.linux@gmail.com,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH v2] wifi: rtw88: 8723b: avoid converting RX SNR twice
Date: Sat, 10 Oct 2026 10:47:53 +0000
Message-ID: <3c89d2ac770c659eacd532134c89b4725be9ab97.1791627615.git.dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtw8723b_query_phy_status_ofdm() divides the SNR report by two when
filling pkt_stat->rx_snr, then shifts it again when updating
dm_info->rx_snr. This halves the SNR used for diagnostics and average
statistics.

Store the raw report in pkt_stat->rx_snr and convert it only when
updating dm_info->rx_snr, as the other chip drivers do.

Fixes: d726c70ce082 ("wifi: rtw88: 8723b: add the RTL8723B chip driver")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v2:
- Store the raw SNR report in pkt_stat->rx_snr and keep the shift when
  updating dm_info->rx_snr.

 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
index 8bb9c03d769c..18bd2b108ccb 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
@@ -1280,7 +1280,7 @@ static void rtw8723b_query_phy_status_ofdm(struct rtw_dev *rtwdev, void *phy_raw
 	pkt_stat->rx_power[RF_PATH_A] = (val_s8 * 2) - 110;
 
 	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
-	pkt_stat->rx_snr[RF_PATH_A] = (s8)(phy_status->path_rxsnr[RF_PATH_A] / 2);
+	pkt_stat->rx_snr[RF_PATH_A] = phy_status->path_rxsnr[RF_PATH_A];
 
 	/* signal power reported by HW */
 	val_s8 = phy_status->cck_sig_qual_ofdm_pwdb_all >> 1;
