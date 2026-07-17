Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E20E54B
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784251088; cv=none; b=XBvNG6NGHmICsUT4xFvVRho4UMLuaWhOwii8u8BaqY0AKLLaVmobzG4yy0O7qChsQea1AgJ0CQ/+v0ivLM1/A48jf3uRFgk0+sZMi+fTzjkMsXpc9fISzDglINkGwzM3M2z/MNdtUy8ANxyuaiICk+C9qpdB/ZANTTCIpBK140Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784251088; c=relaxed/simple;
	bh=ty9QL2kXsEHnuIRmFs0V/OlLa3HCmaD3lxXCydtUTGA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aEFRB40dnmWnGGYSOTOV7v3SimjTQ3vKVlU8sgsjixD461potB2P7cYJ+gUgAA8Ent+FlnvRcllEtX9lYXLPqkY2d7XUMXtAaUsCNukprW5xiueAnQCAQgMjrHRjnaJfXybE+OQPkbKhiFiq9nYL0tHlYVTiKXWwkaKwMqM4dMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=y15tUMuV; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="y15tUMuV"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso80524135ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 18:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1784251086; x=1784855886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bNdJZR+pl6DKuAuTwZ8giCeGjq3rXw9VrTpPCoia5dM=;
        b=y15tUMuVnClmMaMxeQcHutFy7CUsjDwtVK+CCXF4h0AAF6UK3WWCAz54tRVpubLiLc
         PtQej4JvFiByp9jTVMYbpHxftcyuaEysKoAVOq78DcZpoWG0m4NRaVr69xqekIIuIcW9
         bB8vdTQlHxzM0EjLGkd7oAFND9xuxyuitGY6sGcsHahVvKVOxbXaSPoK/6ZCt5zPgWl9
         mZ9pnJfJ3oMfK74w7JlsQhZV1Ols+fqDYFuJvQQtIjlGutt3qO6hEhLUnhShHxcTfSHZ
         wY5ULc8RfMkJ55tw5ruv4AuHpCMC30A0et/sglwFV+JyTm3bVuHHFex9ie43B4d5pHsk
         1Afg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784251086; x=1784855886;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bNdJZR+pl6DKuAuTwZ8giCeGjq3rXw9VrTpPCoia5dM=;
        b=aMjNu2jMwz5Mwh2BG8GPXloi5te8WgSe+gdH9pl7xDHj3WogZfRN+l59YrF0HO45n1
         gKVfrF44CoKhym2qFjoY4Fwtl9/a/J5Ae1z1Nm8jp49SjL8/5O18iLJSfA78WZKqQTtd
         AREJDUENR3VHfCTvGQ0Klyv6X9ppFRDSJZiPu0a+kq9a6Afwm8tvZACaHRtcW2p7iOJ3
         DpP1JmcaDayvNDTaPBhue6UAqdA/QscLz3CPwJ1z4sRzceMQjhncL6sh24e8Xc8CLa+8
         BlIpSTh4uUo9BlULGPTJvbxzXMiF7qAn+u55rJlFWMfeucwy9RDxUTj5TUDFsqhgVOKA
         7cog==
X-Gm-Message-State: AOJu0YyyKpdbuzGYT5Qfw2wqrceWn9z64USU8YDZ0Gd2XfTeMJEBFXbC
	7PiL9YJeXWn034m3zesP6H74FnDVZzFs2t4mFHVQOiHMWtwEttGSgOlqVtvcCoK5+E0=
X-Gm-Gg: AfdE7cl47p9+TV2JeZzSVb8InNQBnaOTRsDmP+FuxpHM6yM7Epxj1mK75gzOpdK+8ij
	dl3LR2OcA4H6rE6niVcay4Oa3o5OaLBSKakKUpNb/i/JM5JUH4i/zfxPDc6ru9wo1VF6x1G35jc
	zHPAo5F5rOeUige/rPmsBBAWLPSKcmCGd6CyjGOFSbuf5gz8iwL4/QgBOr9ragBSVAm3qKhAyuU
	dxpd+KBa7kX29f5wJTe+6vQ0geBxbLoXbQKhdCCsPhabJTicY1i9sOUn7do5woxtHFQIMUQZ81P
	mB5KDZHFXycFrBEdcIAAAl49Iga9+zaEJY+GkHnu7uDCjQzkW/j9Hy118ptr6D04qCm9lMot5gi
	8s7zsMYvwz9aBcQpBvR9REK1jK/2JiEVf6+8Fi7izjbClZIebDB3krX8gpX+qsLBu5rIAnrAUTH
	9F6TMfrjjaFebS0Q6+dwMPpoPpdqd0cbY0iSGBxhDE7auVf2vM9xlkEAhe
X-Received: by 2002:a17:903:a8f:b0:2cf:2f74:6703 with SMTP id d9443c01a7336-2cf3485768cmr5395525ad.11.1784251085877;
        Thu, 16 Jul 2026 18:18:05 -0700 (PDT)
Received: from mma-01490.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3448fba7sm1603875ad.6.2026.07.16.18.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 18:18:05 -0700 (PDT)
From: Andrew Pope <andrew.pope@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	lachlan.hodges@morsemicro.com,
	simon@morsemicro.com,
	Andrew Pope <andrew.pope@morsemicro.com>
Subject: [PATCH wireless] mac80211: recalculate TIM when a station enters power save
Date: Fri, 17 Jul 2026 11:17:51 +1000
Message-Id: <20260717011751.79524-1-andrew.pope@morsemicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an AP buffers frames for a station on its per-station TXQs and the
station subsequently enters power save, sta_ps_start() records the
buffered TIDs in txq_buffered_tids but does not update the TIM. The
station's TIM bit is only ever set when a further frame is buffered
while the station is already asleep
(ieee80211_tx_h_unicast_ps_buf() -> sta_info_recalc_tim()).

If no further downlink frame arrives for that station the beacon
TIM never advertises the buffered traffic. A station relying on the
TIM then remains in doze indefinitely on top of a non-empty queue. Its
TXQs were removed from the scheduler's active list at PS entry, nothing
pages it, and the flow deadlocks until an unrelated event wakes the
station.

Recalculate the TIM at the end of sta_ps_start(), so traffic
already buffered at PS entry is advertised immediately.
sta_info_recalc_tim() already consults txq_buffered_tids, which is
updated above, and is safe in this context (it is already called
from equivalent paths such as the tx handlers and
ieee80211_handle_filtered_frame()).

Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue implementation")
Signed-off-by: Andrew Pope <andrew.pope@morsemicro.com>
---
 net/mac80211/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d9ea19be0..5e26be8e2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1717,6 +1717,8 @@ static void sta_ps_start(struct sta_info *sta)
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
 	}
+
+	sta_info_recalc_tim(sta);
 }
 
 static void sta_ps_end(struct sta_info *sta)
-- 
2.34.1

