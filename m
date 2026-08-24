Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0230B43C045
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581477; cv=none; b=j6LBWuRj+ev21DTAG9nNbOLlQ1KFRKWDtT29IRz6xZzILfrYw1f7bynL4Z2d8NgbkbHb8ORLE8lyqHJudohntiCvMo55JR8SrN6UHf8uePv9L3wIR47fkakbkZnNFWqP57IEuPITvCNBh4+jKDssvCcg7x6kyPToAedAwwt8OYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581477; c=relaxed/simple;
	bh=ogyBKpcQ5BF8V++IYgH0md1vVjjUWy2iqk+hxadukC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf8TVO5B9gy9H1jKt7rbJK6vSghkBEEvIdZ7wMEJ45IxrmGdJJNqCL/CColL/rg4dfYkvEgBjdY789yKYT2WII+XuwN2xZCWhUiLajDt2OyCvo2G3xEvUYqTwHBpBu5jNTJMVXTtU+UicrrCg6SQ3F8tndEQ2lllz67VVaGwyJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=bNujwIck; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="bNujwIck"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so630602366b.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581473; x=1788186273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z+s09lJoW19HOfjqPgOsY+MAuN3xrwX1WGWVvclfdOM=;
        b=bNujwIckdwMYCDZML22LA3Wk4t4eyvR1u6sZyP1u23zmc1k4dQn230UWeTDRzgydLZ
         ULI6GnPx+n8N75VnkHPwAIWP/Sal8osTI4gnAPx0HIidR5nAbKwIE1giYuipaXleTCl3
         eDKn2/+y8dfzot1EieCyKjw4HLA3k3RLO3wsDVgAlXxi0g6IR71gwF4xEdth0LOVZk3S
         UnrTcB9hOE0/PGhyX/QJQqKC+S9CMPEroS0wLQWa/5nA7LYjHPrqqKfxXbI9WIFtMGj+
         rn8NsdEWxhzgWrJZZb9qwYcYVGZ/SBCqtff6kOGhXi9h9iIrUNgfQxB+TmsOpgwNYw4V
         CtXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581473; x=1788186273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z+s09lJoW19HOfjqPgOsY+MAuN3xrwX1WGWVvclfdOM=;
        b=pwx9bDMdE9CLypEyfQlMySdKrLG6xsNEkBmT71U4R60BLQ7McG+02Jdlq1hWmtya6g
         E9807BWnRpLYLw3MDNr6rIT4EPbM2lWr1/tGYYvplQitO6n++alMJpxkS1sahc9UOz9z
         8nY8CPu6/MIswzGMrTrH3D1zYrThLPacToVKvRm0rqxqg61fNQv+WXJwC+tsB3NQdV9w
         qvRIQP4cSMGFlojOuAwgQNIcF28dguS675qP4KJwGdCiIsr8uJSIUbw1inHRPB4HNGyY
         c85iiATtYYpC3kMMzsS3Ni56g8qmIRQxn6V+tq1s6vbdCIlgxWd/w+JBBs24mQBd8i8U
         ptBg==
X-Gm-Message-State: AFuF++kvUhQm5pXvdQ3hq8zreTv4soZavEwtVwzWL7sHl8g0AdicKUNa
	rXg6TkooJmwTZsNW81+mTuGBtpnp3xlBqzIl475BwHiM4IEDkS2mYrdJLJdbFuBx6yc2KzjIfrf
	lrPjWt4U+
X-Gm-Gg: AR+sD11Y7VmPESIMsMabd0HdeI/JG6ixrZv1FQFNqwn80pVU47oOaU3sAYkK1pyx4jH
	JwnmQ8fQArMaBCLf4dsnbfVdjIrJ9usvogJ73hnh96+DwdKKK1okbZ10VpMZS6Hy63y21Fd7TLl
	9BaTwa2+Gk24FlRFBbFZsIBJF1fHSwD5aXQKyd+xiyZqimRMC56TOZaKgWtZNerV8aPzfJsFO/Z
	GIp8W1npwC7dtmInsbbzOlV0lS+tPG2NKlPY6aMJ0AJVfQaWiS3QT2jRi7GCTDbjx4fmQrLHd/B
	4xAsnL2KAx+QjpGacFZgj+xt9gXT84UHnHPnZDtw4blQ+QsWfib4UMfi1kGXk4+YZpYdSdrOkb6
	fNxG0vb0w1a45Ue3yUuqWumzrfByMMZrdplRgp4mLKjHXVtsHomBiFiY8xm7jayaAbnkLkZZk1J
	ftpcGTBHOXNCF9btXtW6FJ4C2pcXNUT/7kEfkdzR0rDjwl761wYkUwgzFFYeUDEaN05ZCZ23NY+
	i6Fw5uGljGyVRW06P3wxkIKrIUD5+w0rkZmt0TjLaKAs9eQmqC0Nno5SfYlDx+daJlVUp3Taqpt
	RGUsls0lNgpvNJQbnBDmKhI+kc30OUEOxLhIWZM8DuNh+cT+7t8HHddnY3YMYY8PAeqx/kPT2UT
	IrBnDZEMtqR9LOGqdvC15rqCMEYfiu1fzvEE0JuOX1OqBKBpacMB22xdPYEOTgr0OrqOqgCCa
X-Received: by 2002:a17:907:97c4:b0:c20:af9d:454a with SMTP id a640c23a62f3a-c2492621bf8mr2119993566b.16.1787581473076;
        Mon, 24 Aug 2026 07:24:33 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1329890866b.42.2026.08.24.07.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:32 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH ath-next v3 7/9] wifi: ath11k: charge received airtime to the station deficit
Date: Mon, 24 Aug 2026 16:23:48 +0200
Message-ID: <20260824142350.1757379-8-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824142350.1757379-1-julius@bairaktaris.de>
References: <20260824142350.1757379-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mac80211's airtime scheduler is configured to account both directions:
local->airtime_flags is AIRTIME_USE_TX | AIRTIME_USE_RX, and
ieee80211_sta_register_airtime() adds the received airtime to the same
deficit the transmit side subtracts from. ath11k passes zero for it, so
an access point serving a station that mostly uploads charges that
station nothing for the medium it occupies, and the deficit that decides
whose queue is served next describes half the traffic.

Register the duration the hardware reports for each received PPDU. It
arrives in the RXPCU PPDU end TLV on the monitor status ring, which is
subscribed for every radio, and ath11k already accumulates it as the
station's rx_duration. Charging it once per PPDU matches what the
transmit side registers, whereas an estimate rebuilt per MSDU counts the
preamble and the interframe space once for every subframe of an
aggregate: measured against one HE station, the per-MSDU estimate from
ieee80211_calc_rx_airtime() reports 16.9 s of receive airtime where the
hardware measured 6.8 s.

A PPDU that reports no TID is charged to BE, matching what the transmit
side does with a frame carrying no QoS control field; the value cannot be
masked into range because ppdu_info->tid is ffs() of the TID bitmap less
one, so a PPDU reporting none leaves 65535 and masking would select VO. A
PPDU from a peer with no station entry is not charged to anyone.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 28aaf39cf342..7ef58152719d 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5341,6 +5341,26 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 		arsta = ath11k_sta_to_arsta(peer->sta);
 		ath11k_dp_rx_update_peer_stats(arsta, ppdu_info);
 
+		/* The airtime a station spends transmitting is airtime it takes
+		 * from the others, so the fairness deficit is charged for it as
+		 * well. This is the duration the hardware measured for the
+		 * whole PPDU, which is what the transmit side registers too.
+		 *
+		 * ppdu_info->tid is ffs() of the TID bitmap less one, so a PPDU
+		 * that reports no TID leaves it at 65535; charge that airtime to
+		 * the same access category the transmit side gives a frame with
+		 * no QoS TID.
+		 */
+		if (ppdu_info->rx_duration) {
+			u8 tid = 0;
+
+			if (ppdu_info->tid < IEEE80211_NUM_TIDS)
+				tid = ppdu_info->tid;
+
+			ieee80211_sta_register_airtime(peer->sta, tid, 0,
+						       ppdu_info->rx_duration);
+		}
+
 		if (ath11k_debugfs_is_pktlog_peer_valid(ar, peer->addr))
 			trace_ath11k_htt_rxdesc(ar, skb->data, log_type, rx_buf_sz);
 
-- 
2.53.0

