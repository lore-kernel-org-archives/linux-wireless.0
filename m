Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0909350EC1A
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788546208; cv=none; b=gBJh4TcnJHW0fkqLTZpcYqCSrx7C7Fc7MiGghf+Nlnuu0Ll2HJSC2viXLYI6d/meevBC8lxug25QedudBJDsty4z5fjBvFK0JFyxWi0VoSilgqiAG3XCQLxRxWDlIMVKvGRW6Tk+ZvgifJpFL9/Rq1WHEpvQjvk1h5AcBsr2Nt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788546208; c=relaxed/simple;
	bh=qLBwZLzyH8uzwDT2HdJvcx1jK0C3H7dUyAkrKzIoFKo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m9Fa2hlnSQf6oU2Q3LFaSHsGkPNicpkDrOKpactQO966gh8NTW+GtfQpWyeLMnJyR/6iD4QLjiv4fgEBFwex43HE8VZ7tvm4DrQexpyLvTSuya6wSUj0sywHG1ppsFtHjpygiqgf0qRLmnS18pDc3IVBTo6Ejc2bbrUz8GxNOck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pfOF03QG; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pfOF03QG"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5301db51586so18181661cf.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788546206; x=1789151006; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+rPF2baMygOE+6+zdwAm12933adxMnFxrc4psklCm6M=;
        b=pfOF03QGoJsVM8IvpxTDUMNz/NJ2w6Oqzcfv5ksHMTGGWQGUV8ZOwORS3vDKQ2EZXe
         L1hox1g7DGrKpSZG0gDi6PZ1/4v8nknwQWah0jO0Rfn/ROnbQ7w/9GpeYhMQJYNJR5mQ
         AJgJLyzvNqU9OaVY+kh0DflGGVONGi8qen9sAKDRFu5pquAUX2mnlAdGot2r6f+ZhlxC
         uCLKlRwsFg+dXrFPJahNDl/uv40kvWEz5Xd1mMX7uD1MOrqQHO8NRGdy1fiPV0yGmwGu
         yUOvg83pCZBi6DCy3bKldW45G6YBMHB6FAGncD312pF2bnvGFilD8X4U1NjxmDqbVxyG
         9Bew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788546206; x=1789151006;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+rPF2baMygOE+6+zdwAm12933adxMnFxrc4psklCm6M=;
        b=hcj6BToosnzj5xaj4KNR47wvI3d44kWSvILa/rA91fSQw8wbrcYrhusAd/Z1c+P70c
         Os1+IdlGFwLIddN4wzPM9jdJHeOg/nOufyIq4NXHUuIeGyuSDDBfZNvAeQfqtHdtMFFl
         okvZ3qP/0mP7iI6yx6siodmB9uDpGE+xZJsYjwK0NWVE4l4NWqHtP4JFR8NXepgt+IgC
         7rnkjL++08OP2Fpe3V+gA0sNGqiKixtpQvZebbvsjuvbU+M8PUzARhCJejCJPWhJt5eX
         2Z4PLk9w4sywbC1i618Ylw0CaJLT/Xev7MgeR1m/fNc5ykDxhFDp1Nwewyxnq8qNBRB5
         e6WQ==
X-Forwarded-Encrypted: i=1; AKwUvByBCxue98i/LBcITSbg0hl8F+Z7uaNBDazbU4HIwxOhCuTQJzD1YpeKLZJ+efuF/ZEH2dZAs2wXwYav5vKrnQ==@vger.kernel.org
X-Gm-Message-State: AFuF++loHxL4hvux+ZZ0lJPkbLiqtFu54tkDm/9ARr3GmWYHhUhbWTg2
	NMCfDcQ4lBjlcvSwHbbmk/3ViJz/JU+KJzT/x/UllY+DwrV27rN2PStrFWHs
X-Gm-Gg: AYBFou0aOPW1D8Zq5ZoG9gEK/Kv1uiml7uUhAVxTSznARVo7OqC1gdwhWswqRAQo7U5
	xnjvFB4yIWBOlQSy6WHDnrcBnlpy4Is7n3P6TIuENDkT58ZrVSi9UdFLBNgAjt3tbnOXVK6Gmfa
	I+1J2OuOg9NSvT+RUMK/IaYucF7/9jk1VK5e9n/DEHpURqAS1YDb73rDNGOJzDOCF2vNRYcPVMd
	glkim0AjHg6IkKnUOOlPJwD9dv8cf+lxs0W5sH9Htau4VFnIWznUCSJTzHPUNOQ171HcByYQW7W
	pZatC4p2lBH7fgt4FQuV6MwBGo/zVNK2xpy6t3jqvKeWP1Pnjgrn1V7X/Ftc7NX29m5eI0vWfbs
	P588Ub7vc8qar09HLrgByMsiEOAQCUBiLnMr6jIGyjVn00ZyU//ueYINxA83/Qm5G9AowaMEEdt
	4YvFWF6wgx0IM8P+kSPhxJYAYuGcVlP0gFBzYEDRjUcXYsah9UKohIgHTfJ3QL7T7GoqLSVg7Iv
	NtKj4bxBHEtmvoVf6q+5IzkLjdA0LFIFE6UQcNXyncDGPLx8Ul/jSqBXWIytkoo2OHCD/pze3tL
	KbrB
X-Received: by 2002:ac8:59d5:0:b0:530:430b:cce5 with SMTP id d75a77b69052e-53054a3a641mr76796551cf.47.1788546205540;
        Fri, 04 Sep 2026 11:23:25 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040646d59sm26172066d6.8.2026.09.04.11.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:23:24 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: ath9k_htc: pass CRC-tagged spectral samples to the FFT parser
Date: Fri,  4 Sep 2026 21:23:20 +0300
Message-ID: <20260904182320.792881-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The AR9271 firmware checks AR_CRCErr before AR_PHYErr when it fills in
the RX status, so a descriptor with both bits set reaches the host as a
CRC error without the PHY error flag. ath9k had the same order and
changed it in commit 3a325565c7fa ("ath9k: reorder error codes for
spectral"), because spectral samples received under interference often
carry a CRC error. The firmware was never updated, and the host passes
only PHY errors to ath_cmn_process_fft(), so on a busy channel the scan
keeps producing samples and the host drops all of them as CRC errors.

Observed on a deployed receiver: 640 frames per second with rs_status
0x01, each with SPECTRAL_SCAN_BITMASK set in the trailing radar_info,
while the recv CRC ERR counter grew at the sample rate and PHY ERR did
not move.

When a scan is active, also pass a CRC error frame to the parser when
its length is one an FFT report can have, one byte less to two bytes
more than the report length for the channel width, with the PHY error
code the parser expects. The parser still checks SPECTRAL_SCAN_BITMASK
in the trailer and returns a frame without it to the normal path. A
frame with the bit set is consumed whether or not its contents parse.
It had failed its CRC and was about to be dropped anyway; the only
visible change is that a monitor interface with FIF_FCSFAIL no longer
sees those frames.

The firmware can be fixed separately, but linux-firmware ships version
1.4.0 from 2015, so the host has to handle what that firmware sends.

Fixes: 83fb287ecd8a ("ath9k_htc: process rx spectral packets")
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
Changes in v2:
- Describe what the parser actually checks: after the forced error code
  its only remaining gate is SPECTRAL_SCAN_BITMASK; a frame passing it
  is consumed.
- Comment and length test now say the accepted window is one byte less
  to two bytes more than the report length, which is what the parser
  accepts; the test was already that, written as len + 1 >= fft_len.
- Pass the parser a copy of the rx status instead of changing the
  original in place.
- Add Assisted-by, rewrite the commit message, rebase onto ath-next.

 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bed7ea2425a0..b0b95444fc95 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -969,6 +969,32 @@ static void rx_status_htc_to_ath(struct ath_rx_status *rx_stats,
 	convert_htc_flag(rx_stats, rxstatus);
 }
 
+/*
+ * The firmware reports a frame that failed its CRC as a CRC error even when
+ * the PHY error bit is set as well, so under interference spectral samples
+ * reach the host as CRC errors. A sample is recognisable by its size: one
+ * byte less to two bytes more than the FFT report length for the channel
+ * width, the range the parser accepts.
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
+	return len >= fft_len - 1 && len <= fft_len + 2;
+}
+
 static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 			     struct ath9k_htc_rxbuf *rxbuf,
 			     struct ieee80211_rx_status *rx_status)
@@ -1052,6 +1078,21 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		goto rx_next;
 	}
 
+	/*
+	 * Hand a CRC error of sample size to the FFT parser with the error
+	 * code it expects. It returns 0 only for a frame without the spectral
+	 * bit in its trailer; anything else is consumed.
+	 */
+	if (unlikely(rx_stats.rs_status & ATH9K_RXERR_CRC) &&
+	    ath9k_htc_is_spectral_sample_len(priv, rs_datalen)) {
+		struct ath_rx_status sample_rs = rx_stats;
+
+		sample_rs.rs_phyerr = ATH9K_PHYERR_RADAR;
+		if (ath_cmn_process_fft(&priv->spec_priv, hdr, &sample_rs,
+					rx_status->mactime))
+			goto rx_next;
+	}
+
 	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, &rx_stats,
 			&decrypt_error, priv->rxfilter))
 		goto rx_next;

base-commit: 1d8e73163ef933624341075f576e2f36ef9133f7
-- 
2.55.0

