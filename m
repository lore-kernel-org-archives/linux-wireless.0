Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080974D9566
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 17:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580100; cv=none; b=oERkMQhoLFqlhriC2ZSjdogRQa/j+dKfJ/m7k6XcAEZKUgLZaLtJSTZFHxODn6m1uyctyb1Z+rCX6EdFTEyv1XJMmauVUk5Z/xwmgG/h94imRRyHPau2ccBiyYsDMml7Pw/ksAnar+fV7U2bwsNTSKxYJXxiqZt+gI5DUTDlKaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580100; c=relaxed/simple;
	bh=vfPgszcrKMkOdEiihjECb4jnRWMn9BoIETfDExylycs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXTIKRsr8R5/ZOxR8kr0C1yhuWNHKXwCBAF8rpLXGxnCloY9swniyGZ6fTJ/haW1p+xzNrMqKha9bZbrql5Q8S7pQ0iql9yV2xEnT3iWeRc8B2P5XG9CPO/x+UbAYIvy7agnMYh6Ol1bjK11Vcw08aHaAFje3v//H+4mQ5Hf3qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FNAu4/xG; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FNAu4/xG"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d391aso8915775e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789580082; x=1790184882; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EXWmb7VjjlkNtn1q70BvaaY3UDnd0CfPKSfQaqn3n2k=;
        b=FNAu4/xGxulIBRs/0kFJf7a2BYLWyLH8Ui09Gy6NQYKQX/14DScyW77uLKWAVQoFIV
         AWwSBIlVmQvk0ac+q2HW4Ps98Wgk9thQXe64WXzkVTkRLhX/yFLx/C948BM/A7B7XZNE
         aTIxua+aHaERYrjHyereN+fnSN9VSSRwLrtc5Ml7NcCHBvOEmAb6AONolgw7fbBcDgAR
         aQB7O3kYFvZUTACTVeM7Um5OljEKpDLK2XAfPtOp394skWEN0femRjwxUx1XHGz5iZHc
         6zU6I3HVVuglk3AGlcofyYtUEi3Ow5au+M3tt6GurXBLCnaTgLYA1wxyWCqmx/S4jF5h
         b9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789580082; x=1790184882;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EXWmb7VjjlkNtn1q70BvaaY3UDnd0CfPKSfQaqn3n2k=;
        b=DRdM3bof2cdELURFfAZ2CX1Sw2Gfs6rGMDQJbmEF9+oe4dw9O4wi6i7PhyDx8YeSjs
         VOWy8a+wK5Q/1KAfzgcaev2VsIVpwpUH433YK/uFCQvRl6VCicB0Gdtm6rPkXPSDwAHa
         sBZFgUeZXK9+Z/DNeyKOTloN3cpV9yU6xrp9Tdu+CC4TrqIWEOAZ3966t+Ag28zt01bO
         LrIzDnN5SKDuofYxBL4E0/+yj7SPD+W+7AtaGAA7BZBCI/aGrJ5YdRhwXd0Dqg5ANnwp
         oJM4LvCAmdCFgP3e3J+tvtRRmIX6DlCLpRLynAi9yhZ6dxz8mDYp1JMMWEqzInYfZvHm
         0FRQ==
X-Gm-Message-State: AFuF++l8w1Qni1mKyTsz7NKNAxrTFYB6cS+WzEOPqbxKfPdowRTrysX8
	7ZOSrpLLsO02/HrtDnKDCz0JtVK4i5w8FoZYbK3S4fAa6bitCBOF1/o=
X-Gm-Gg: AYBFou0fcZ0g8UVIBxG5AjBLlhVPN8ut52yPavHTsBRiMKX53t0vQGD8xZiigVlBpAl
	mEmBffBPtGWKTGADTWDWeLiN0Iy84j/S9W+KTBg8Ec6qcvMVz0UNyJYbM3CSIan46/jre5ycR/E
	g8Xxpm+pYFOMxZa0wfxCoyiFHaAXjqvzl5Z8ueJi4uSW23y2nZSJ3wtJgIFEQyrOK58euexPRBl
	5Mx6AhbhivqzBsXRpl85zcSy1m6wIG3jJQtXjwrsA8BPwKtCqnGZ0YLb+IzGvmQFfpypyoULx9x
	3uPOEXR5N6jqyiODoQaNlvFL1yr3ZolV7brSM1flRFukDVVz646+sN/EZI2MBsjxtBlHU/S0z2E
	1rdckl/XY9tAocXNdZGIljiUmbdCtmRGVRfMtCmsGesnNFXjVRb26XBhWjEL8cUCE3FHxqLaxlI
	nvgYgRwuzzvLr6t2QB3SIzMe/uDGBcP8BVTNvLagisBhBfTLwvLdb+1DSwl1G2tfcwovdyqJNjA
	dJnB+vf6H+8nVDvWvdQnUjN8dXdFYfRD0ZSUFTD2m/LWFVs4w+1oUbjYQz+hKLdiPCowyA8kgtl
	up/AW+WnpkPveq8=
X-Received: by 2002:a05:600c:c8f:b0:49c:fc6c:be15 with SMTP id 5b1f17b1804b1-49eb733c62dmr44718705e9.27.1789580081884;
        Wed, 16 Sep 2026 10:34:41 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:f23c:f0c3:c09d:d6d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27ce2sm8987544f8f.20.2026.09.16.10.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 10:34:41 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"John W . Linville" <linville@tuxdriver.com>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	stable@vger.kernel.org
Subject: [PATCH ath-next v4 7/8] wifi: ath9k_htc: pass CRC-tagged spectral samples to the FFT parser
Date: Wed, 16 Sep 2026 20:34:28 +0300
Message-ID: <20260916173429.403889-8-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
References: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The AR9271 firmware reports a frame that failed its CRC as a CRC error
even when the PHY error bit is set too, so spectral samples received
under interference reach the host as CRC errors, and the host passes
only PHY errors to the FFT parser. ath9k reordered the same check in
commit 3a325565c7fa ("ath9k: reorder error codes for spectral"); the
firmware never followed.

While a scan is active, also pass a CRC error frame of FFT report size
to the parser, with the PHY error code it expects. The parser rejects a
frame without the spectral bit in its trailer. A monitor interface with
FIF_FCSFAIL no longer sees those frames.

Fixes: 83fb287ecd8a ("ath9k_htc: process rx spectral packets")
Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bed7ea2425a0..23d1ef2407a4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -969,6 +969,25 @@ static void rx_status_htc_to_ath(struct ath_rx_status *rx_stats,
 	convert_htc_flag(rx_stats, rxstatus);
 }
 
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
@@ -1052,6 +1071,16 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		goto rx_next;
 	}
 
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
-- 
2.55.0

