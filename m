Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7F43A641D
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 15:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252531; cv=none; b=sAM/pUjxXKxldO51W+I9fYVB8yFg8AyxIVnaoaSgL53SZ8CsAFHhYmWbILT0EMIKBzAyUcTxiFy/YXSGNqyXUTeh4wym+2iErmSeKOvcWgTKjmze3Yprr/Cxyuu331ZsQgcpmAAX8bL05NzkBoBKyayjm3hSt84dXu2SOY8lwRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252531; c=relaxed/simple;
	bh=mAAQ60pPc+jfdJv8rP6ue7YB+HgmNSwW32B7IxcsMz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcG3YweXGGqbDqjOH+kvyNOdnQmakBW/xUlP1W6A+jdVUd/ie/xD+DNMuDIaSB2Su6sHUzVU23R3E48ShLDc7UYgFdnji8tQxERdLayywAqwjmIy/4+gtWWDBwPOoSrkhBv7RsHnU7MFdySq4e+EB27W1f2GW+cyquT3rYDMctg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k6evmcoc; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k6evmcoc"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a171b677d2so5043775e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 08:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792252523; x=1792857323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s+gAvbFcPWzZc+jGGj9PIkXWG7hyRgIBYDY75NCMqGA=;
        b=k6evmcocALxCGrZ94saGHs3/duRGcpkDOUGN7AV4xrLfDsMoZB7eRCsYqpJqYcTLgv
         XxE1cwViytwTwCQ8Aoff1zADh8DOL7+VYSzpiLSzyj6P60LT9W3kd7+A0aKsSL+5HsVr
         hxsMeDvwW8ZbmuzCNQ6gBHHObXmXTg4J3lNrzmTv1E4s1ajR2S5crOTRz5QTr5IXulyZ
         WpHBTeMSFpQ00MDSV0sLq5RZDHK3XhyRyf6cDMGPzvBFoCG3Wy4wzduhR+K1cfImQv52
         yQF1GyJiKMGMgcAKAICJn/64wksreVCzepwEJT44EwW/yhbNL3uKdkMl0O2XbONurSHz
         8ucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792252523; x=1792857323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s+gAvbFcPWzZc+jGGj9PIkXWG7hyRgIBYDY75NCMqGA=;
        b=k33HOKyCdh4z/bSgDihnbAkrD9mDxrBl/F4pI4uBcLGWIzF+hD11DEUAoJO7IDkcg0
         a82pL08Q6FglYHH2QI4wrJ99Q34TW+FRqnjsD9TwT7jPHXDzMt7wX+n4pywfeCUMGoSJ
         Xmhm7gBpKVUMmleztHPa1Yll/j28m9j23RYeaAOCc9noLKSj0YJmZEm2lO7GJmCr9H5z
         LYmfmD9Z5C7ceVXN/zCpEzHim5W2VJCMegUl/B9iwUHxH6B4hF1yM+i7boNsmSDY7Wrk
         etrl3s15aVOvzXrippnaazc8WRNNhE4ccIa1SXqU6KDZO65kTg7TGknqdt6Be7Eq0y9n
         eNqg==
X-Gm-Message-State: AFq9FYLEU19JZd412xQbANoQldefVXUHYA502d+hW5ozjlPROSqysgsY
	JnqzRWzkozQIhrQRFdnHPX85yN0Y+uyPVsntJ92Nj/ekVVU3VUmPAqdb
X-Gm-Gg: AYBFou0EMqlUbxjDRdZKF0d7wGsUtE0I9YeXLH5TeHMwFyuMQ0ZMnKj+QWFtDIkx3Lj
	4Fi9qwQ01K5PrvlUXihdXEUTGA0MXPLo5skKTkqBLFU2yRzYKomVtspjoXz0/aAoXoU/BKHOl8R
	Sbvfq/wRzL/59197UgEVGD3AQm2OOczA/w1yepQsUegPVTy3oew1qDdDMVMhwEbxSuudzONUuyG
	to64ddNEwiSdDLyxkHt6wKg3pmb93OB7LN8gxd4IrYdAqpczFgv6jArksEFbm+FeBJiwJY2oYdC
	mikfm3lIzPdEJP8JDfXWXKMyZQNqahoLPShi1fpdE4LpA9ztKK64ItBpge3+FLm9Ju6/cw5iz/4
	yQhPKg9dINEklLuWNjN5xmN+fHzU1h4jsHoDqG8BayOBXAQee5NiaDqriW+FO1DOgEoIvZkEcX+
	+9189FGADskZuxaQePdFXlCrqZkIDhm9wgg+go3yOUZN8PfR+xSXGsHG8BJbITlnZFTMkcWxdka
	k7OVQKN0Q7wu0auw0c=
X-Received: by 2002:a05:600c:870b:b0:4a1:d487:2dc8 with SMTP id 5b1f17b1804b1-4a1d760518amr63631815e9.18.1792252523373;
        Sat, 17 Oct 2026 08:55:23 -0700 (PDT)
Received: from potato ([31.176.162.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1dea678cdsm42335505e9.1.2026.10.17.08.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 08:55:22 -0700 (PDT)
From: Omer El Idrissi <omer.e.idrissi@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Omer El Idrissi <omer.e.idrissi@gmail.com>
Subject: [PATCH 2/2] mac80211: hide drv_get_stats tracepoint with ifdef guard
Date: Sat, 17 Oct 2026 17:55:09 +0200
Message-ID: <20261017155509.128114-3-omer.e.idrissi@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
References: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hide drv_get_stats tracepoint definition with CONFIG_MAC80211_DEBUGFS
which is the same config that enables net/mac80211/debugfs.c, where
the tracepoint is used in order to remove unused tracepoint warning
from UT=1.

Signed-off-by: Omer El Idrissi <omer.e.idrissi@gmail.com>
---
 net/mac80211/trace.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 562a4964afa3..6d80d23b7c4b 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -756,6 +756,8 @@ DEFINE_EVENT(local_sdata_evt, drv_sw_scan_complete,
 	TP_ARGS(local, sdata)
 );
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+
 TRACE_EVENT(drv_get_stats,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_low_level_stats *stats,
@@ -787,6 +789,8 @@ TRACE_EVENT(drv_get_stats,
 	)
 );
 
+#endif /* CONFIG_MAC80211_DEBUGFS */
+
 TRACE_EVENT(drv_get_key_seq,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_key_conf *key),
-- 
2.53.0

