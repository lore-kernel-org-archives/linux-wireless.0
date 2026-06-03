Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7274F481FAA
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 19:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514957; cv=none; b=VWrn/CxuwJqio9MNmcvJH8JWDSAtrJQ8ztp/6HyaCfeQKhvESr1ZdNcikyhIusFbhVxscvJ3QuxncqzhDAGvKy/MfBJ7x3sNED0SzBC54b8G9rTQDLxA5iyyYAMd+1imoQzVyrn5BVbfJYKHFFrY4vh1YQgHlk+9YYI0Bn4FO9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514957; c=relaxed/simple;
	bh=K0UShm0wX9kM27aczqt+wkwuJDTcapJCP3IpCNF9QY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kjp5LrcIeD7BMDpafIzqXOHBUVzV0Ujsj3I8mtHQrNtYGbjeg3YVWXrLu02fbUu4uZvDDX2OFvEneyWd9//1rTmIWhJkdK4e9U6w822y7Ml+y5GV3fxlI4ZC886d1vnZ+s6RuFZ5ZG10AHcOtuk3wP9QSyVgIR2o95IKvEd+l2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=gIrsFqv2; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="gIrsFqv2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1780514953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6jYdnhsZPIN06b4+M/gYm2TpSFUvcVNnHhzD77PSXOk=;
	b=gIrsFqv20/zyRVSqJr/HMTkn56Wd4fV62ZNYKjenUaY2r+iV5xFB6C1ZivjtNL/yxbi6mv
	RaGlJBu/GF9r7syMd6YKYKH+MqR4PIUI7NsqiCglJ/X0z6FIetrljJnUOvG6XK4COxoupn
	7G+zwiKSBadtwkEeXuzwv7IdbbE0SB+o8IWVNLPCeqKNNVXXFsNr+o3KuCkMqh+IzJuFmC
	iZBgzUlH8tXpafRzsKOgTSRg77uqsynlWQRgWoSZrp8q1hVS4H2OS5LlAhkpqMpPMgx3yl
	GFqqFg5kNJ5KNoH1dyYC7/dvIxS8au8kN2O1zUdhU0KrdniADOdlDgpL/yOpPw==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?=E5=82=85=E7=BB=A7=E6=99=97?= <fjhhz1997@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-kernel@vger.kernel.org,
	Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>,
	Brite <brite.airgeddon@gmail.com>,
	stable+noautosel@kernel.org
Subject: [PATCH v5 1/1] wifi: mac80211: fix monitor mode frame capture for real chanctx drivers
Date: Wed,  3 Jun 2026 12:28:54 -0700
Message-ID: <5c2760bd9bc34616bf7892848872522254dd1ce5.1780513445.git.lucid_duck@justthetip.ca>
In-Reply-To: <cover.1780513445.git.lucid_duck@justthetip.ca>
References: <20260519235713.49109-1-lucid_duck@justthetip.ca> <cover.1780513445.git.lucid_duck@justthetip.ca>
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

Cc: <stable+noautosel@kernel.org> # causes some older drivers to crash
Reported-by: Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>
Closes: https://github.com/morrownr/USB-WiFi/issues/682
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Signed-off-by: 傅继晗 <fjhhz1997@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
v5:
  - Use list_for_each_entry_rcu() to find the single chanctx instead
    of list_first_or_null_rcu() plus an rcu_access_pointer() check on
    ctx->list.next. That field is not an __rcu pointer, so the check
    tripped a sparse warning. No functional change.
  - Opt out of stable autoselect (the fix reintroduces the crash on
    older drivers) instead of Cc: stable # 6.9+.

v4:
  - Drop the dedicated local->emulate_chanctx branch. Emulation always
    presents zero or one chanctx in local->chanctx_list, so the
    single-chanctx walk handles that path too.
  - Real-chanctx TX path is unchanged, so v3 Tested-by carries.

v3:
  - Replace list_is_singular() + list_first_entry() with an RCU walk.
    The v2 pair re-read ->next without RCU between the singularity check
    and the entry fetch, racing list_del_rcu() of the sole entry
    (rculist.h).

v2:
  - First respin under my submitter signoff; preserves fjh1997
    authorship.
  - Verification matrix; airgeddon evil-twin flow on mt7921e/mt7921u/
    Kali-VM does not reproduce the hang reported against the v1 attempt
    at this fix.

 net/mac80211/tx.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 933c86ca21c3..cf336e92c072 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2407,10 +2407,20 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 				rcu_dereference(tmp_sdata->vif.bss_conf.chanctx_conf);
 	}
 
+	if (!chanctx_conf) {
+		struct ieee80211_chanctx *ctx;
+		bool first = true;
+
+		list_for_each_entry_rcu(ctx, &local->chanctx_list, list) {
+			if (!first)
+				goto fail_rcu;
+			chanctx_conf = &ctx->conf;
+			first = false;
+		}
+	}
+
 	if (chanctx_conf)
 		chandef = &chanctx_conf->def;
-	else if (local->emulate_chanctx)
-		chandef = &local->hw.conf.chandef;
 	else
 		goto fail_rcu;
 
-- 
2.54.0

