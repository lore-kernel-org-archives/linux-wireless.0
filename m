Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679DD3A6F1C
	for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2026 10:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774605781; cv=none; b=e8g7owJyxQqvlGHigX2T0cjJUNoh5ytn8oV25DkR6bsqKFsQJe2nZo0pwb+K/JLXL5ssbW+v2rEOf+TYIJwL1HO9YrrePHd+CJGiQjojqL/wPmz9ClZ/scCaL89TCdEJCZE6+G0/5trBxBl5lb/EG8LL0nnfXAJvsxcL3j/BDyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774605781; c=relaxed/simple;
	bh=8++rv44Zo9lc4YRRtEVA5R1EsDOTVZkDbukvWi6J6dI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K7+9OApLLjM8KenD//mGMo3GCrzBcKZ0KeWKTxRyxVfqOteZeuVfTdabF0Ffg0XypAgrwiuoo0q9EriqfSCNdTUQb4Xz/N82j01lf1PjC5RHrHjEjPMMMaDdZDfLUTe/FL21Sf9cn+vw8BmAfVhpJfM35wLe1TLZq0ORxX8l61A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CUrU9cSB; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CUrU9cSB"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so17204915e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2026 03:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774605779; x=1775210579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SLXE5YEAWcb3iffDgGvNVl9eXbiYGmULBIFt7lG4i4Y=;
        b=CUrU9cSBW+bbIuY1zjZw30orfSBh83ry7Ud3NwWxu27rOZ0u91dX1JmrYRBQyNLHIV
         rCU+6LXwS5McplJ9lxIU35vmoqcIc3XjNy0DO3JuZdhA7fOm9bqLd8ybGrhmptICzBDj
         qPrDd2/11ItjHACYuNLngL+GlmMsLHwdlI5rZunoh3oWdxwGJx+ytxKXtyvtyisrxz7/
         bop1kBCOpCBkdQkRdwBRbZwfIrJjy0UOc4IZk8fr+A2C2vQbcnSG6xGFGh3KRNMvg5a8
         d/FphLxzRFqX7qxa2kioDQYDmZh38S7Wqj36cT0qlWea6nnKtNFPO6XD4e8XTRQGanrC
         2bCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774605779; x=1775210579;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SLXE5YEAWcb3iffDgGvNVl9eXbiYGmULBIFt7lG4i4Y=;
        b=UVDFsfe3m9HgGKUL48Btrbe6YHZ0SZSU4SWf5kfK8I3rqhIdvNim2mrbrKgjAX9kx8
         drfk6021Zy74e6nWMGiozArxcgDmjVDBYTLW9T4y8dLxFAhwcr+4WEuZtAVfbKinUYUM
         8qwY+9xIpOqWHWCGBusr35dDns3Zj4337SlJu2/evJevNl1/TueQxNwwtehasUHJ1Jhj
         UzhCqNa+ouf8HcrLHcC55sonuBA5WZWxWPYPSR78D5aFtR0j44lh9HtAyKT2QXcSTy3C
         a5xGVNlWDvgSB3PjSrsdeXGEd0S0HZJaw3Yii5xC9lRYVzjKTK5P/9yS7YSTuywKVWgP
         ZtBg==
X-Gm-Message-State: AOJu0YzziIArnDWvlgrpzVzIXC03M1QCjaXrbmGRiNMqJ1/i5xl2OTm5
	/iUGDiI0QBsrnPpgrdvNFv5BD1WFO9c6v5YDlPY2Nx8ubMicoKwICt5m9Qp2kQ==
X-Gm-Gg: ATEYQzzkZNiW7aeNVOrKB/qcWLx8QUBpxW7hN/kK6n2HW3FcBayK3kG0cEdEsU6bb2i
	BXFqAs0Qqikh9m6y3sS3t+m4nidHUxtmTpHlwDEQA3AYAjvQv8pd5erLzI8WkqALlsb6O8SFhjD
	GhaTtaYpv+oU6wZqnc1no1hMzRj2wHwB1t2qGO9VVgCTAtY0cX1wpMLahaeKD9oRDGGqxAJa5cQ
	UDA9V7nzSehjQ6arEk/kOU/hEy2qlIfu+X+p0dc3qgEffiIwA5EnNamU6S/obfHbYJflILPMvpf
	mN2X1baH13TcFQ5kZib2UjZhNgD6DrL3GXrcaAtPNZWuwHD/6fqsUh0yqUzto8YP8oQFHFimbup
	wT9GANYpSe1eh6cRW1/zENKIxUhV5zBsuyKwunNk9aEArv+XheLGN+pMZc6lif4T6IbDe7yjTYJ
	F8A6JpyDPsoz49FVw6TiKHdMCCBMAPLMdL8Wn9jYay7H8uJSe7/lElbD3D
X-Received: by 2002:a05:600c:8715:b0:485:3bc7:a231 with SMTP id 5b1f17b1804b1-48728091c2cmr29640565e9.29.1774605778404;
        Fri, 27 Mar 2026 03:02:58 -0700 (PDT)
Received: from syracuse.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722c9134fsm142946985e9.9.2026.03.27.03.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 03:02:57 -0700 (PDT)
From: Nicolas Escande <nico.escande@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com
Subject: [PATCH] wifi: mac80211: handle VHT EXT NSS in ieee80211_determine_our_sta_mode()
Date: Fri, 27 Mar 2026 11:02:56 +0100
Message-ID: <20260327100256.3101348-1-nico.escande@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A station which has a NSS ratio on the number of streams it is capable of
in 160MHz VHT operation is supposed to use the 'Extended NSS BW Support'
as defined by section '9.4.2.156.2 VHT Capabilities Information field'.

This was missing in ieee80211_determine_our_sta_mode() and so we would
wrongfully downgrade our bandwidth when connecting to an AP that supported
160MHz with messages such as:

	[   37.638346] wlan1: AP XX:XX:XX:XX:XX:XX changed bandwidth in assoc response, new used config is 5280.000 MHz, width 3 (5290.000/0 MHz)

Fixes: 310c8387c638 ("wifi: mac80211: clean up connection process")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 810bea1aacc5..1f3f7fa79084 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6009,7 +6009,8 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 
 	if (is_5ghz &&
 	    !(vht_cap.cap & (IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
-			     IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))) {
+			     IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
+			     IEEE80211_VHT_CAP_EXT_NSS_BW_MASK))) {
 		conn->bw_limit = IEEE80211_CONN_BW_LIMIT_80;
 		mlme_link_id_dbg(sdata, link_id,
 				 "no VHT 160 MHz capability on 5 GHz, limiting to 80 MHz");
-- 
2.53.0

