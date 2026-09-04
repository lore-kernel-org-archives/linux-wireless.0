Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908CB382F1E
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548401; cv=none; b=Q7tSSWzYoO26ojRCwXCWVztYIv1YnpPjcifm3LHw25sWJmEtozygAZ+eL3UIIDFuUWmOoxIihfSjQDDHNLQZLO35SeIkw7OSMq+5QLi4+meEOVUSUuQDwqK3YHnPkxEWAUpEZi0/S4LOQQaaItmLdDD+ycqEZ3RoiW+2O5Vkef0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548401; c=relaxed/simple;
	bh=QfIOm9qjscdWeWlm04aDK//HpPrtUmsRY+AmxoetIe8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J3ch5t0QDt4XnoLSk4o1oVgZiFlZc+btiN2AUifT8vZh2ikvntmPp330aAzzu/h8oSqchke0nKeC3x57O0gEEOez9qolHWnXcdoNQsMLM8XQ0KnP2/4LvUr5j8oV286AmfEYTiugI6vg6uknfldEC7nsWe/K+3MDxCgB9Xuebrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tfon+UEt; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tfon+UEt"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f96c5b722so935788f8f.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788548396; x=1789153196; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ejK+DzZdkjdTSZQ6HpLTpLuVFk/6KLPxLDA+OP9jq3o=;
        b=Tfon+UEtBWMtGM6GrsprOJLv7FY7idUqS59Gd653woEv7OmIMi/xkIeqkKVtOyz+wY
         kYmgHTeZW9BGhLvWXVbne9s9ozXiAA1hyHz2QTHcmwdYs3GVRVq59x3VW5+TSqd0TAJz
         iCTkrlj1pqS2V3eQn8vE7mQaiKtKGQ6yW98tSoRXh8Je+lYD/3N5mG3REOKZU5I2SyUy
         5Hrf2nTr6RQn54cNNJVK1phH6Fq+8GRA5icMXrPMst4mVRbLk7nRz2uRhR+ZHfdOTNxd
         WGghj6Gb0aXxoLR0D4eSsPw6zu5HiY5NNkx+B+VvxLUWUkrGT/1x2vvHS14UJURbk153
         bHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788548396; x=1789153196;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ejK+DzZdkjdTSZQ6HpLTpLuVFk/6KLPxLDA+OP9jq3o=;
        b=aQMt1s8AyAqztFRUqkPH/CKMNv8RGhsMgPYJLpHdvHh9EGnp+fAW+c/uu1PsY0nJGJ
         PSt1CNPgRBgr4/VJ1RVoqdV6UQpv/+BcMTTjZRMS9d46+haDdT69RdDECNCSpqKPlOOD
         MS7eG8RLdE6bH51cEKACJebK/mcr1LaKEiOppwliVsPGPXBVMBF4eeUpIG+F2R0tRwo5
         s1CpWi6R7pF3V20P4Ez1lHNJ18GepKhbLfQR2uURhAWFpeqI2A2UYv6v5tkukR9P569+
         E5xmiQgTym+haoYOZeXOKfPWtb1OkfvHl3I0/vbIvvbMxvJuKkW1/f54MNxE7SfxMg4p
         FmUg==
X-Forwarded-Encrypted: i=1; AKwUvByYgYvX+KitCpz+o6dyNZRyvuX/8acIXIvfpYOHTRJaEfa/tB+ArtDCw8m9BDkyeotHukHSAI+9p/Z+OIcFxg==@vger.kernel.org
X-Gm-Message-State: AFuF++kUUEkoc15VYi1o4XZ/V++SBt5IKi8jkuvmbvYr1Ti5Kzmi/ROr
	jd5aUgWkc+4ju982MnioUDdn1lJTs1ibNoUo77Tc/9cojP3g/e9A643+HZqV
X-Gm-Gg: AYBFou21BWK0fRZRAlrOD0aaCkkIdAUqGtqTKguDdGGipiCzounLzBOXv4A5/pVjH/X
	CWhQhK7ibMma3C5ASpfRc5go7ArF6F2K/y9zK9PK1hkFfMN+aAEymPlyjRvNdOUYEqRURlO02U4
	4LxW5JtJuan27ZRqFTwdS91TlkaL6mrvRzda7j/xfQnJ4PpQgYhzqvoNsmx9n1rI5ox5rzK9NMY
	6JMTszx6Us315a3ITxn8qfDSH7jjol+AA1tuiRP0EeyFxEL8n9m5fVDN08VL1Xd8kT5jMQG8CT0
	7ErbAw1EbHwrNH8qUXwqmdIYxc6TyX7zWpwCplpExNxgT09YYSuUC7A9GRGo2vluXImCpHn5EgA
	AUfBqxRDUlZ4pQBhRIZraG87PhsSluLw5nd30c8bo5DXf1i8RxpcG0sh0rDXAjf6hramR4QZRrP
	PxCdBF+wOevF1YOLS/tqab2F+lETEpL4Pkvzo6+dVsd3Tgk5xuUp/RXCb9POyhZMCO6M8yEbC3I
	oIziMjMgkLDaGLnSb8hotEygIonbSST8aVpOOOS5xJpMsiNuI9GkgWhLpp9EVb1mid7td9llMJ9
	llN7
X-Received: by 2002:a05:6000:2c09:b0:484:3621:6341 with SMTP id ffacd0b85a97d-4858729b772mr9957701f8f.15.1788548395612;
        Fri, 04 Sep 2026 11:59:55 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d2693e8sm4752822f8f.3.2026.09.04.11.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:59:54 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: ath9k_htc: count length-discarded frames in the RX stats
Date: Fri,  4 Sep 2026 21:59:46 +0300
Message-ID: <20260904185946.813562-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_rx_prepare() drops short and malformed frames with a log message
and nothing counts them, so a burst of drops cannot be told apart from
a quiet link in the statistics. The recv debugfs file already prints
rx_len_err in its LENGTH-ERR line, but nothing increments it on
ath9k_htc.

Count the three length drops in rx_stats.rx_len_err so the existing
line reports them.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
Changes in v2:
- Sent on its own; in v1 this was patch 2/2 of "cope with lost WMI
  reads", which it has nothing to do with.
- Add Assisted-by, rewrite the commit message, rebase onto ath-next. No
  code change.

 drivers/net/wireless/ath/ath9k/htc.h          | 2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6c33e898b300..0bdb300f0ad7 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -328,6 +328,7 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 #define __STAT_SAFE(hif_dev, expr)	do { ((hif_dev)->htc_handle->drv_priv ? (expr) : 0); } while (0)
 #define CAB_STAT_INC(priv)		do { ((priv)->debug.tx_stats.cab_queued++); } while (0)
+#define RX_LEN_ERR_INC(priv)		((priv)->debug.rx_stats.rx_len_err++)
 #define TX_QSTAT_INC(priv, q)		do { ((priv)->debug.tx_stats.queue_stats[q]++); } while (0)
 
 #define TX_STAT_INC(hif_dev, c) \
@@ -383,6 +384,7 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 #define RX_STAT_ADD(hif_dev, c, a)	do { } while (0)
 
 #define CAB_STAT_INC(priv)
+#define RX_LEN_ERR_INC(priv)
 #define TX_QSTAT_INC(priv, c)
 
 static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bed7ea2425a0..3c1e4fad5ad1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -988,6 +988,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
 		ath_err(common, "Corrupted RX frame, dropping (len: %d)\n",
 			skb->len);
+		RX_LEN_ERR_INC(priv);
 		goto rx_next;
 	}
 
@@ -999,6 +1000,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		ath_err(common,
 			"Corrupted RX data len, dropping (dlen: %d, skblen: %d)\n",
 			rs_datalen, skb->len);
+		RX_LEN_ERR_INC(priv);
 		goto rx_next;
 	}
 
@@ -1011,6 +1013,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		ath_dbg(common, ANY,
 			"Short RX data len, dropping (dlen: %d)\n",
 			rs_datalen);
+		RX_LEN_ERR_INC(priv);
 		goto rx_next;
 	}
 

base-commit: 1d8e73163ef933624341075f576e2f36ef9133f7
-- 
2.55.0

