Received: from mail.systemli.org (mail1.systemli.org [93.190.126.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0942637E5E9;
	Tue, 15 Sep 2026 19:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501891; cv=none; b=QW+VjxmNRvoR5h4DiXyUe7mlM4SyQjEyvJfoJOCmsLwZtxy20r32iy45vbso7yzCRXvqeLZr8JNOVKjDwG2STH+jbk3wY/JjgIwtWNOakR1IxY9oytyHIg39rTlgaNKKMDDUpXDkz5RzOGoZJQhXDtI3SvrsEQMRVP0/VInA8CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501891; c=relaxed/simple;
	bh=/LzEA/vfK9gBlWZYzjnqlgIBNIC6LZn4m26JyPUQNw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g7OGznVVKZ6nuCTVma2EGNNDq3QKY5GW+kl9RNhUZdvPxF2XQCzIftWSADZGiUULYqs6H1zX/hN7WDr+JXRrQoBZmU289O4crmemMa7IHO7Zvdnf7rnwwyCPtrZLhKCxDhn7tWVmn8ECPCO5yHG+qWDLl2DEnGthwugR9cuWOWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=systemli.org; spf=pass smtp.mailfrom=systemli.org; dkim=pass (2048-bit key) header.d=systemli.org header.i=@systemli.org header.b=pPYmGx7b; arc=none smtp.client-ip=93.190.126.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=systemli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=systemli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=systemli.org header.i=@systemli.org header.b="pPYmGx7b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
	s=default; t=1789501446;
	bh=VgOKdKh1SL/E+wcXifPjZ8hXUr7i0WUXSAq45A/JBs8=;
	h=From:To:Cc:Subject:Date:From;
	b=pPYmGx7b9KiXmZJ6El4YMx7he/Y0JNr0X/4xicQHrRwEm6NtdDs1Zyq5mgqdMY3Na
	 lJC+qSD9dp6VIOf26R6aIzKnkXo0Aebyh3dtS+mZyLY7PuTsigUQKRqwy5BL4LJvYC
	 g1RhBg/SG3/fc6Rq0/Dsg5Jw70rURVyeoW+Wx2QM4Tf1ZJVzC44GNtiM6+ySxITmIi
	 UUV9J71u65rJAwhtc44Hr9cMIgj8NvVmoXwi9GZXfwhHLR/wTDItLMN01Rwc3yUyqf
	 STkxghHNsZZ5JEhzs1XIzNBIHJf2s6/V5tPYWhFTQ3/CRdRzxDDKL+nRaP+RUALqJo
	 WSgnEHoQD1+1Q==
From: Nick Hainke <vincent@systemli.org>
To: linux-wireless@vger.kernel.org
Cc: Nick Hainke <vincent@systemli.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath9k: restore background spectral scan after reset
Date: Tue, 15 Sep 2026 21:43:27 +0200
Message-ID: <20260915194327.30397-1-vincent@systemli.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A reset leaves spectral_mode set to SPECTRAL_BACKGROUND, but resets the
spectral registers and receive filter. The driver therefore still reports
a background scan even though the hardware no longer produces FFT samples.

Re-trigger background spectral scanning after reset recovery so the
software and hardware state match again. Do not re-trigger spectral
scanning in disabled, manual, channel-scan, radar, or off-channel modes.

Assisted-by: Claude:opus-5
Signed-off-by: Nick Hainke <vincent@systemli.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 740a6fc7b067..00e587fe6ee3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -231,6 +231,17 @@ static bool ath_prepare_reset(struct ath_softc *sc)
 	return ret;
 }
 
+static void ath_restore_spectral_scan(struct ath_softc *sc, bool start)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	if (!start || sc->cur_chan->offchannel || sc->hw->conf.radar_enabled ||
+	    sc->spec_priv.spectral_mode != SPECTRAL_BACKGROUND)
+		return;
+
+	ath9k_cmn_spectral_scan_trigger(common, &sc->spec_priv);
+}
+
 static bool ath_complete_reset(struct ath_softc *sc, bool start)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -269,6 +280,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		ath_restart_work(sc);
 		ath_txq_schedule_all(sc);
 	}
+	ath_restore_spectral_scan(sc, start);
 
 	sc->gtt_cnt = 0;
 
-- 
2.55.0

