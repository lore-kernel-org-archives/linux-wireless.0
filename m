Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D30D4A485A
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454930; cv=none; b=TMzLyYH90zOKnY7dhiisuFZm9haZKO23hvNb4NpJcAEc2ZBerN8g30V4TV9gwgoutjVplv5ynY5cvcUCTmhaq9qDGuX2v+mRpluYbI6xQ9pq314gYkWtjSV8iPQSeJhiuK/U38xJ6bOp1CwJKxgho6uBjdZQsLQNG5a2Vubv/2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454930; c=relaxed/simple;
	bh=AVHAQurUFoKLaCFRgHat+OT5W056v68rqof4kJKHpNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hyFH39qNTGL9of27xX0j4xqABC8OApBi4wX6JPysozjSY+IpldJm196BA1eIIucfcom3Quim84Kqky47cuUZ3mW7Ua4nkZpzUnvVg/a5yD8v4ZBk3Fm6hBCb5epGuIV+1SQspnnQ1eQunOXnBPSjc67Kxu63ORNyLEId0AizG6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ebTqvEYy; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebTqvEYy"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3a1585728b5so1390711fa.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 10:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788454925; x=1789059725; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jSz/5wb7TEZcgXuwlReXoBOs2iB73sql8zD/zqL37Pc=;
        b=ebTqvEYyG7Es9pDvepmzcwL86epacu6Cv49N/j8+uYpFragsLCOTohJp5NSjCberTp
         Lao1rFnQARIJRsTFQTuSEcDDSb9IFKnNu2t1l6YRFWS//51m/tpzne/6VanWATkk5hG6
         2N86S9JQgn3YmUmXnPEjGdBB38TWWUYGbqk1o9qkEdnQX6QFgO/sYZuyK0MEk7cyphb2
         I9qPeR6w6WliKIAJCybb7Qcxvh1JKKk46g64HiAYVldDpiHSI9kjTbog0VQD/Nb3TTQn
         4bSH0aRdrrX2qg+Qo3K6yajPTjUqdHL7o7RULWI2I6kVaF/fGnRJzk5UFk2zppP4/VrG
         8yUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788454925; x=1789059725;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jSz/5wb7TEZcgXuwlReXoBOs2iB73sql8zD/zqL37Pc=;
        b=aIS1azoLrMBU3SzYGwuTvyExNFYr0wcRfOQkFBAOD5Wj3zgj2dl788cqMzl0uVLzQQ
         7a1XzWfZxLNOdPuMDx7lYWXxEwPKAAITO90K1Z9zsVzT7kwc318vZrWz4+XhMOyeyaaU
         XUB0NFXBQ8METrNAZWhzk+qD+0jDYapAQi4F7dkUpYBMXp2oZSeV6qsV+ZvLWZwLqh04
         ETcDjJUobWj15DXM82cYOsjkkuU4mwmMYUA3qdjp2rT+EOP3C4pWhTYVPHjZDHizLp3K
         ncxlzoI6FsUoHcnSNm0UpvFyDpDqygKRrlWuUWhk3hWpK7bY44f741gs+IJBaADHyGqK
         SepQ==
X-Forwarded-Encrypted: i=1; AKwUvBw8NK75qmf5WjUXxZsr4tx54c+8g3YAiVwT4BCKBexDe4KsKACJ3FBo3F8bykvB1XApruRJGcnkMuf6e5VqjA==@vger.kernel.org
X-Gm-Message-State: AFuF++mT13acrplSw0o3kt6C6/S0L01yh0XqWaoZ198uJ6GwaufxLjXb
	F468AUgtMiIskRwuRYKn6QEsG5w7Gal2SfCjrlczywModxuyyEFIGcw=
X-Gm-Gg: AYBFou3YbfMP89qWBLERCGMveb1ZuEJe4MfKNk6oiiRfx12yvudFyQEJGeO271ZoGvq
	F3ykpO2FM1m3dkahDNl35MDv4FTMj4Usk+mrFRMKHrIdngDtBYt6hdJkQLjP8YhqMm0z6YEAbbl
	pRFfxqk8LD0yl7Z04NDShBjsZggimOuHynSfcjvOeEM5ZnAPQWDOqRBnURUetk57jCXHydTt1D7
	lgfaQ1BgST/dcTnz2e05KTIdzP8Krp4Gb41FOaRLVMnHg8747PRV85ryyV4SKzZsciRa0xHCcUN
	6NNbPsRPFPuoHIPysJvnhhlO1K/8a5IkTjU3AYqXGhY8jRV/BrFUhC8pMa+s8tts9iVExX0stoH
	SLiy+aERym9MtnZcP3coGl63YhEilMbCzbLHPibyfxJ5R5Zx6FSLzGBH8HoW9r/fcB05KX/NJfm
	apPiuYnxHfFpLWE16MCqopvih7UwDQ4pvJ64cKjHhjt8KUJ8+Ep1tGIVKD3EO7dalwE8NazeuOL
	gQjvqZ/f6T3jhtL9UDv2FbdBrdgh7TsWlnH3XdmD1lwqMItIi4DRNz4U5zt1haooWE5d1deUzua
	XFkv
X-Received: by 2002:a05:651c:2213:b0:3a3:52a7:3a1d with SMTP id 38308e7fff4ca-3a371a9f848mr225711fa.1.1788454925055;
        Thu, 03 Sep 2026 10:02:05 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a370548667sm1300861fa.9.2026.09.03.10.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 10:02:04 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath9k_htc: pass CRC-tagged spectral samples to the FFT parser
Date: Thu,  3 Sep 2026 20:02:00 +0300
Message-ID: <20260903170200.1093540-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The AR9271 firmware tests AR_CRCErr before AR_PHYErr when it fills in the
RX status, so a descriptor carrying both bits reaches the host as a CRC
error with no PHY error bit. ath9k had the same order and fixed it in
commit 3a325565c7fa ("ath9k: reorder error codes for spectral"), because
spectral samples under interference "seem to happen quite often" with a
bad CRC. The firmware never got that fix, and the host only hands PHY
errors to ath_cmn_process_fft(), so once the channel is busy enough the
scan keeps producing samples and the host drops every one of them as a
CRC error. Traced on a field receiver: 640 samples a second arriving
with rs_status 0x01, each ending in SPECTRAL_SCAN_BITMASK, CRC ERR
climbing at exactly the sample rate while PHY ERR stood still.

When a scan is active, give a CRC error whose length matches an FFT
report to the parser as well, with the PHY error code it expects. The
parser only accepts the frame if its magnitude fields agree with the
bins, so a genuine CRC-damaged frame of that size is rejected and falls
through to the normal path. The firmware order is fixed separately, but
the firmware in linux-firmware is 1.4.0 from 2015, so the host has to
cope with what the card sends.

Fixes: 83fb287ecd8a ("ath9k_htc: process rx spectral packets")
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bed7ea2425a0..f21cfc03426b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -969,6 +969,32 @@ static void rx_status_htc_to_ath(struct ath_rx_status *rx_stats,
 	convert_htc_flag(rx_stats, rxstatus);
 }
 
+/*
+ * The firmware reports a frame that failed its CRC as a CRC error even when
+ * the PHY error bit is set as well, so under interference spectral samples
+ * reach the host as CRC errors. A sample is recognisable by its size: the
+ * FFT report length for the channel width, plus or minus the two bytes the
+ * MAC may add or drop.
+ */
+static bool ath9k_htc_is_spectral_sample_len(struct ath9k_htc_priv *priv,
+					     u16 len)
+{
+	enum nl80211_channel_type chan_type;
+	u16 fft_len;
+
+	if (priv->spec_priv.spectral_mode == SPECTRAL_DISABLED)
+		return false;
+
+	chan_type = cfg80211_get_chandef_type(&priv->hw->conf.chandef);
+	if (chan_type == NL80211_CHAN_HT40MINUS ||
+	    chan_type == NL80211_CHAN_HT40PLUS)
+		fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
+	else
+		fft_len = SPECTRAL_HT20_TOTAL_DATA_LEN;
+
+	return len + 1 >= fft_len && len <= fft_len + 2;
+}
+
 static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 			     struct ath9k_htc_rxbuf *rxbuf,
 			     struct ieee80211_rx_status *rx_status)
@@ -1052,6 +1078,18 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		goto rx_next;
 	}
 
+	/*
+	 * Let the FFT parser decide whether a CRC error of sample size is a
+	 * sample; it validates the contents and returns 0 for anything else.
+	 */
+	if (unlikely(rx_stats.rs_status & ATH9K_RXERR_CRC) &&
+	    ath9k_htc_is_spectral_sample_len(priv, rs_datalen)) {
+		rx_stats.rs_phyerr = ATH9K_PHYERR_RADAR;
+		if (ath_cmn_process_fft(&priv->spec_priv, hdr, &rx_stats,
+					rx_status->mactime))
+			goto rx_next;
+	}
+
 	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, &rx_stats,
 			&decrypt_error, priv->rxfilter))
 		goto rx_next;

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.55.0

