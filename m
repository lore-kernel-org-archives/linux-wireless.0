Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583423AFCE8
	for <linux-wireless@vger.kernel.org>; Tue, 19 May 2026 23:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779235045; cv=none; b=uV5rvgAVDep/IdNwOKI1Ivw7Rro95aGnmorqZryIkIfIdBAaWbGKF+OzfH7s4zLCcoGP0TakWYrMxxS4T9IfBKoLUa3KeIKw5WiMZrydOO4WjRT52/IfIC7j4BakcNviJnWV1THflDS1fVJM9TLSTCJIs/aAMIn/aj34HBerzXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779235045; c=relaxed/simple;
	bh=QvDQQgxMlWe/NUUFRvDVO+G5N8HLQaZdguGH3FEQcqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MCspxtDgt2uHhiz7jUFFRkc0mYolbbj/9A4IFYZ/M8xgxmbd2fATWeXlYlAbw0iXPaVidvZ4ZX+z7tjD4GXczD8cfPE2zCmYtDmvqVuDOaLaKmq1aRUZIXQwUyfH5zt63QrAD87yk2+fg9eDiL7AsGTuLiglQwJ0FEl9TZH19sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=WrOZ6bBS; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="WrOZ6bBS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1779235041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMO4XGKe9tJXICUR0USBAX2E9zLMBYajvIK0HLgJ5KM=;
	b=WrOZ6bBSquFqxaSvtRHPCQwGiwSrQGG+xkrQRe7VcCplByyYK6JfR+Z7fav4fKFzW+pg6n
	d0ksXkV1F3ev3T2/kyofk8fWaLCvoRxk4euavdsLl+2AtPOBb6LdH5PGMjM/r1QPGHHuyH
	EqgWu+zAWm+UrNgNOL97BMOuOfaZajxPvdIqM0zrJf1/HL4JKeErdkrWTZsYGmpRz3h9px
	4CdMIrLfx8IKrhYdWHc8cnIIA3hVq3D+ePqLDmZxLX/dq5tHkYmJiNKCOn4BGOVwELIyKk
	nOtTDrCnJtZw3ADdb3iamHri5YXn1AcveRqqvW7qFcbrqDsntDKc4UJ/p5WGoA==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>,
	fjhhz1997@gmail.com
Subject: [PATCH v4] wifi: mac80211: fix monitor mode frame capture for real chanctx drivers
Date: Tue, 19 May 2026 16:57:13 -0700
Message-ID: <20260519235713.49109-2-lucid_duck@justthetip.ca>
In-Reply-To: <20260519235713.49109-1-lucid_duck@justthetip.ca>
References: <20260518170147.13885-1-lucid_duck@justthetip.ca>
 <20260519235713.49109-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: 傅继晗 <fjhhz1997@gmail.com>

Commit d594cc6f2c58 ("wifi: mac80211: restore non-chanctx injection
behaviour") restored the monitor injection fallback for drivers using
chanctx emulation but explicitly deferred drivers that transitioned
to real chanctx ops. mt76 falls in that category and still drops
every injected frame when monitor coexists with another interface.

When the monitor has no chanctx of its own, fall back to the only
chanctx in flight if there is exactly one. Refuse if multiple are
present: picking arbitrarily would inject on an unrelated channel.
Emulated and real chanctx drivers both flow through this fallback,
since emulation always presents zero or one chanctx in
local->chanctx_list.

Reran the airgeddon evil-twin flow (hostapd AP + coexisting monitor
VIF on the same phy + aireplay-ng deauth from the monitor) on
mt7921e PCIe and mt7921u USB across 2.4 GHz and 5 GHz, and on a
Kali VM with MT7921U passthrough as the closest match to the
original reporter's setup. None reproduced the hang seen against
the earlier attempt at this fix
(<20251216111909.25076-2-johannes@sipsolutions.net>) or against v1
on lore in March.

Cc: stable@vger.kernel.org # 6.9+
Reported-by: Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>
Closes: https://github.com/morrownr/USB-WiFi/issues/682
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Signed-off-by: 傅继晗 <fjhhz1997@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
v4:
  - Drop the dedicated local->emulate_chanctx branch. Emulation always
    presents zero or one chanctx in local->chanctx_list, so the
    single-chanctx walk handles that path too.
  - Real-chanctx TX path is unchanged, so v3 Tested-by carries.

v3:
  - Replace list_is_singular() + list_first_entry() with
    list_first_or_null_rcu() and an rcu_access_pointer() check
    that the entry is the only one in the list. The v2 pair
    re-read ->next without RCU between the singularity check
    and the entry fetch, racing list_del_rcu() of the sole entry
    (rculist.h).

v2:
  - First respin under my submitter signoff; preserves fjh1997
    authorship.
  - Verification matrix; airgeddon evil-twin flow on mt7921e/
    mt7921u/Kali-VM does not reproduce the hang reported against
    the v1 attempt at this fix.

 net/mac80211/tx.c | 16 ++++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 933c86ca21c3..a8c5d3a2b1f0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2407,12 +2407,18 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 				rcu_dereference(tmp_sdata->vif.bss_conf.chanctx_conf);
 	}
 
-	if (chanctx_conf)
+	if (chanctx_conf) {
 		chandef = &chanctx_conf->def;
-	else if (local->emulate_chanctx)
-		chandef = &local->hw.conf.chandef;
-	else
-		goto fail_rcu;
+	} else {
+		struct ieee80211_chanctx *ctx;
+
+		ctx = list_first_or_null_rcu(&local->chanctx_list,
+					     struct ieee80211_chanctx, list);
+		if (!ctx ||
+		    rcu_access_pointer(ctx->list.next) != &local->chanctx_list)
+			goto fail_rcu;
+		chandef = &ctx->conf.def;
+	}
 
 	/*
 	 * If driver/HW supports IEEE80211_CHAN_CAN_MONITOR we still
-- 
2.54.0
