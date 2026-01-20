Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7EC3A7F56
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2026 20:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768939878; cv=none; b=oS+mjdzxtgxlQ8lOpiyXhPrZijCbclcibiSLREDF8FuSpK+FSMt/ZS2PoPrcnhTD/gn/AOQ3eGRpoEnk/FSWB9dP8A0KVh30SbNrjevt48DHSkxVfu+ymREKWE29FMLgJYj+mKREKZGIh71xjo99yKXbrqE278X4VSAv9nXRzgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768939878; c=relaxed/simple;
	bh=TLNQoSMEXU+RP58h/Pkr0CHJOfR6d2qGRa1L3YyZGmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeVfD56SPy+Bicosx8gzJEoe4tda+P0dVfer3agGBwl/jRyzrbZrD/CxunmZ425RK5r0rAGdcwVTDjf3TrIKM/X+GlhQGX69ak+0qjKxEA8TwEdnZ85mlOF5MYShGBsVcjB65gxy/5MGPW+cFgg65krXw0Z+XXhkgzyefGF6fvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zacbowling.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mTDg4Re8; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zacbowling.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mTDg4Re8"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1220154725fso224557c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2026 12:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768939873; x=1769544673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMeBYNgptE+VTvskSTsKlJV1FmbWFGB7NRFg6t+m7Ik=;
        b=mTDg4Re8Q1Qg9GdHRJm3KRDgpYVK6uCHjAvXu+EaLzcjR6nMuax5pnEe6ajKqnJg0l
         oq2xhXf6AMjJq/Pe57T0bkXE9CaVwlzoiMw79q/FHGXpmikwUKXW0xYpEAUtHrzrF14I
         kBqvb9T/OqIhnw+crdgnzoFhx7C/Jod9Vws0yyJMAXWmkOey3HWxn7ExohtgqWLUKhu3
         OFOyNZz1W4I5A8qJsOTpdEBi4TUzZN+cgYPRV9lt9rHpqVQCr/9MUqDQlQoSGHnATIt9
         DJi90fSK9ye6a0XYeWNaq9wRsBpajsA0yuJnemEs6KAIrfvvRTJJtRSfuHJggxuCjlm3
         QnbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768939873; x=1769544673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMeBYNgptE+VTvskSTsKlJV1FmbWFGB7NRFg6t+m7Ik=;
        b=duP2XnGt5EQRSPsGcdnc4as4l6vUkJz1pyR3bzc2ygx5f1vt9bdMJZN7dbxTVlFt7c
         47KlNbrjeVrKBk8RkLBbLZc63mNxVy+P9Q3AjWq8za0nx4RB4M+nKcIYf49QdWYMa/Hj
         qdefIq28/fd6oP+4EN7R3DyMFOnXg1AX9+qMdpFoPCjIPO7EakFmEBZqS9nZ+b4WtMs/
         mA14ki3PqYa8C4pJb5x/sc26FntlQG3AtNP5Tf0+uLNkvAqm7KfiwilaaPhTT/OEvO6v
         ligmQxhjEYfU1xomFPdtun85wG3e6UHiGkjNWIKK3lVz1ISdGf3gFgBd554RtI+rn7De
         ROKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSC0t8V06v9IsuF+Q4eAZVDGNbTODLiMOW2INQIgjqByWt5STwA7E9B3RKOEh4xE+GutUJKITc3zdC6mffWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YycIrlLd0Ih+S+N/PZhAc0LaNTCWxhEMGX68cGPjKrOIlimMFRC
	xUw/UxB79mAC6aASFq4xTnBsx20HCG9zlzyQqatoDbC7yZOA0xspVapE
X-Gm-Gg: AY/fxX6IOrEv4opYhJQs+z6RdfWSgwtU/U4L8/1H4kC2vWY9s59uxSv2d4RR3/wJtbz
	7cUP0R7Gr5CGf93ffJE5qu+EWvy6wtGCNDAYyyEvKa8nbK6F+SkEVfKCR7dbgsRgaJxTqXnQ+Mo
	cDm/8JcfDvFucDFNUI+9QC40UQ2wb4sI/e8NxdOP5cVgGFWUT6sPesdy0ZfvvlYnsR8EMU6HXQM
	Df3/wlIkpiv8lDMejmCSXhjknH4O/ietRHZEMLvpCBWqhowiVK2d77HnPSjkl0iU++et7hB4mvJ
	rT5OUthopHatFX2FfC8ZJA9DtlDOWQR2PzkJwXv7/h+ohF8yl++AMtrPpXfzhnbpAC+/ctWdEHl
	l0sNSzB0EVoIL9yn+O8t2wYJ2KUq4Fr9j0X1RxR/t3R6EPn0JrWuZIuzCIYuD4iyXtJK6pVBFUM
	T6k4Vdj67mDMUTk2cf0+WE+TQgBbxM2cXzXCwgkyjboLuGPPf8LrPXupI/Ccc2MSoyT1scNrBS
X-Received: by 2002:a05:701b:2310:b0:123:3673:8459 with SMTP id a92af1059eb24-1233d0a82bbmr10840641c88.12.1768939873295;
        Tue, 20 Jan 2026 12:11:13 -0800 (PST)
Received: from zcache.home.zacbowling.com ([2001:5a8:60d:bc9:4a3c:9f7c:8037:90c1])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244ad7201fsm21982990c88.7.2026.01.20.12.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 12:11:11 -0800 (PST)
Sender: Zac Bowling <zbowling@gmail.com>
From: Zac <zac@zacbowling.com>
To: sean.wang@kernel.org
Cc: deren.wu@mediatek.com,
	kvalo@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux@frame.work,
	lorenzo@kernel.org,
	nbd@nbd.name,
	ryder.lee@mediatek.com,
	sean.wang@mediatek.com,
	zac@zacbowling.com,
	zbowling@gmail.com
Subject: [PATCH 11/13] wifi: mt76: mt7925: fix BA session teardown during beacon loss
Date: Tue, 20 Jan 2026 12:10:41 -0800
Message-ID: <20260120201043.38225-12-zac@zacbowling.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120201043.38225-1-zac@zacbowling.com>
References: <CAGp9LzrcvW18xKFL-oF3wxRmb73G6PN59Y2NSA2E5idva1wtKg@mail.gmail.com>
 <20260120201043.38225-1-zac@zacbowling.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zac Bowling <zac@zacbowling.com>

The ieee80211_stop_tx_ba_cb_irqsafe() callback was conditionally called
only when the MCU command succeeded. However, during beacon connection
loss, the MCU command may fail because the AP is no longer reachable.

If the callback is not called, mac80211's BA session state machine gets
stuck in an intermediate state. When mac80211 later tries to tear down
all BA sessions during disconnection, it hits a WARN in
__ieee80211_stop_tx_ba_session() due to the inconsistent state.

Fix by making the callback unconditional, matching the behavior of
mt7921 and mt7996 drivers. The MCU command failure is acceptable during
disconnection - what matters is that mac80211 is notified to complete
the session teardown.

Reported-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Zac Bowling <zac@zacbowling.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 7d68b08f445a..82c81c22e39c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1327,9 +1327,13 @@ mt7925_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 		mtxq->aggr = false;
 		clear_bit(tid, &msta->deflink.wcid.ampdu_state);
-		ret = mt7925_mcu_uni_tx_ba(dev, params, false);
-		if (!ret)
-			ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		/* MCU command may fail during beacon loss, but callback must
+		 * always be called to complete the BA session teardown in
+		 * mac80211. Otherwise the state machine gets stuck and triggers
+		 * WARN in __ieee80211_stop_tx_ba_session().
+		 */
+		mt7925_mcu_uni_tx_ba(dev, params, false);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
 	mt792x_mutex_release(dev);
-- 
2.52.0

