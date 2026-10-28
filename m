Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202192;
	b=WnsUr5yLf/CiLq6UbAwTjIY6CwG0dpS8x9Khyj1btb1HBIcCkCMJROMhhdheowLN0dsc
	 gUKHmhUpgmg7RgG2hOIfWjlH5NESimlGtKY4uzLgg4Dib1r5tvm+GACgZdwWeAU4J9vSs
	 tcd0us+0pG9xbknHcfAQ2ewzWvP45Pj5EMJugFMBTK8E7RSPIs2IOsBSsK3lzmQBLP2tV
	 gq1tyVmxnQTAwjgSVcJw1XjZYDCPeahCAzBB0VLugmCbczy1m76KnyUu//DG7TjCdpLqG
	 OLyBk3MdSuhqEHUTyTrOHjf27LQT/a2JAT4K7UzLl9YeLM+7It2e3iRB5g9fK6Z7yPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202192;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SFYhMa3ZM3Q66wk0IyD7WJMaPv043t/z5qbF1QAWEiI=;
	b=osHa2m19MCBkAZxUmj/R2jSg99shGD/2wJPsQRNLIBJqODkskrEU/x7ohRXqO7ps9TAz
	 dcl+byFc23kINPVQ7JTyu6vukNeVVt5PdNtc+Dd9aLA8QR148mhH/KA1cesIIr1GZ9jPl
	 w+M/50FNMEKxg5PCp61QIfEY1o/Ghm0JBkJzeb4imsPhHH7ZdgfgLzAbEK1Dqf7uvoffe
	 VvlMMbcQe1wlQrY9RDMvhVaqDlr1Mw9tVKRi3mIS5HlAabCXjLEW8VdUtZ5nRbbsMzgW2
	 hHb2P7Y79v9Gbn0kFC3OWAIqcaMCcyFHIXbI7O2/d2it1qCvjWxPb2PTCE+Ud2XoOnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nebusec.ai;
	spf=pass smtp.mailfrom=nebusec.ai;
	dkim=pass header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=n4NT6Q2o;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC582606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 15:43:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC582606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=n4NT6Q2o
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so950017a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 08:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1793202191; x=1793806991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SFYhMa3ZM3Q66wk0IyD7WJMaPv043t/z5qbF1QAWEiI=;
        b=n4NT6Q2oQPrCts2tLXEUTm9o4YFr7j3Com90n2VAcEZeDPqvBdAbEN+ojPlj5dudRo
         jsnsCL/vYv8PhCq2eWEu43gd9m4CTnIl0/mepFZS8HjqLy4bmaQkDtqnVGxgq3AOhILE
         WySfMWjazU6Oc3ATZo6pvmFrElgFVrirvtp5KyDeyYFsftjRhJ7UfR9oWFfSV5Qf9JkD
         conGgStOv+Eqz24i/ZLuqGt60/Pshr37JOlWfJK/zAoQVFnnp4vNEsQd01enkI5MW0Wj
         foeCVtaSYsoAPzyDqA8UmMZyP1u/1x0kMD51SjkmTBEI3I2MzvzpSv5GHVcAZB8jcYFC
         JpcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202191; x=1793806991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SFYhMa3ZM3Q66wk0IyD7WJMaPv043t/z5qbF1QAWEiI=;
        b=xj8YrzCyt2LFaOjL9nKXi0EtcdSLQM64uUvi3r1yqE16pM4rIvcqXM7A9xjnDsBElv
         X2NgEwkHX2LBeuWLPeNzguBqde/68r2e7N87yeTA1rudRm8JsGDKIx36jk3/205yLLZr
         rfJfruo7XfYu5s0UMRhYFPvCUgvwK5ENWFJuuj9FUuqFc7k64KhgeIQng/DCZfJ61rR5
         0ND6R4ruJLY1jPqNTNq2mxjsGlZqxeQXdT9L0RRt7qr3NpUsK3YoEtctTAgK3uM2IepC
         NiPRTXHMlL6fd00rPNW2C10aebypEufD4giuBwURwYkR3rxEp5pKsK67GP8ct+kRk/aX
         JEJg==
X-Gm-Message-State: AFq9FYIkdlOQfy01BHAdSceC26aqRewfhh8S/+he4mRSLK1xxxDppjeK
	AyvUSjXU1giLwcc2vj+A/nwGFV86/nTDfoIJNn6X5N/vktW8AK2PLpTHmBHpUXaLPJfwQC/i3q2
	OOUA8KQ==
X-Gm-Gg: AYBFou1Ue1kMKuj6OxNqdC3xlO4Q+23t/MX0xU7F3j3x8r+Ql5vS98gluQbRc7LJ7Xo
	uWMaRexyxtFF9jTe0GP0RhvPWlqMtPkO03E1kTAtecQZidExOKLWVRaCZwZirOw1SP1nwFNH0qQ
	N0IePNc9fYYs4yl9LfySI11U6msellJAd3gIrkvEsNqmqLytAsRK2tyoNtOPNWLyw7hvMvLIrNK
	WgJh0w3x8Ktv+WzO2nsPO95aZqhC8XdSuRwB2z5f5qS8Wm4ZxSWhdtg4jexVE/KwQJREU08HLGc
	nd8fdHoztkoDwqLcoHIWeSc6167QJZ4AJNzlykqSydBGd8Z7kC2Fe3r1A3seaGQlhAlPShnXdWs
	41O+O/uvgyGJ12MsbVPNAt5lZsivdjbC8MAkRKQnI4rzNaXw/dFU/nzrhsINy3p3SjfXD3eXvSd
	e2f9/DBVbsP7PSck+itK1kSLaxI0l8bmaG8FBhsKkwFQ6pH3eM2JFr0OUMTJP6yUvdEvnJ2hNIa
	3FGGqHAB/YIy/MVwYqd+DF9ASbwf80rccog5a2jyVv0M8WTb/JYTCelvNlLkkkFjJV2zUHTDepD
	SDySXna2IPaABef68V4K/1wtazBndG+Xgph4shPZvg==
X-Received: by 2002:a17:90b:3587:b0:3ad:eb4c:26fb with SMTP id 98e67ed59e1d1-3ae57f639aamr1450434a91.23.1793202190858;
        Wed, 28 Oct 2026 08:43:10 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e7dbe1esm40793a91.5.2026.10.28.08.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:43:09 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	nbd@nbd.name,
	linville@tuxdriver.com,
	sumit.garg@kernel.org,
	vega@nebusec.ai,
	petalzu987@gmail.com,
	weir@nebusec.ai
Subject: [PATCH 1/1] wifi: mac80211: drain rate-control debugfs before free
Date: Wed, 28 Oct 2026 23:43:01 +0800
Message-ID: <773d5d8738fd971c81dd6fff2547134060e4021e.1793108147.git.petalzu987@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1793108147.git.petalzu987@gmail.com>
References: <cover.1793108147.git.petalzu987@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zixuan Chai <petalzu987@gmail.com>

The fixed_rate_idx debugfs file refers to Minstrel private state, and
rate_ctrl_alg reads local->rate_ctrl. Teardown can free these objects
while a debugfs callback is still active, allowing the callback to use
freed state.

Remove both debugfs files synchronously before clearing the rate-control
pointer or freeing algorithm state. Reject new interface additions once
unregistration starts, so no interface can attach while rate control is
being deinitialized.

On notifier-registration failure, remove interfaces under RTNL, then
drop RTNL before deinitializing rate control. Keep the wiphy registered
until the debugfs callbacks have drained, then unregister it.

Fixes: 5b5e87314efb ("mac80211: minstrel: remove unnecessary debugfs cleanup code")
Fixes: bddb2afcb6c5 ("mac80211: add back lost debugfs files")
Fixes: 75636525fbfa ("mac80211: revamp virtual interface handling")
Fixes: 52e04b4ce5d0 ("mac80211: fix race in ieee80211_register_hw()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
 net/mac80211/debugfs.c     | 2 +-
 net/mac80211/ieee80211_i.h | 2 ++
 net/mac80211/iface.c       | 4 ++++
 net/mac80211/main.c        | 5 +++++
 net/mac80211/rate.c        | 7 ++++---
 5 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index e38631d7cfb42..20d1db583f94b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -654,7 +654,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
-	DEBUGFS_ADD(rate_ctrl_alg);
+	local->debugfs.rate_ctrl_alg = DEBUGFS_ADD(rate_ctrl_alg);
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD(misc);
 #ifdef CONFIG_PM
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9374c2942489c..4243be432ccb9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1535,6 +1535,7 @@ struct ieee80211_local {
 
 	/* device is started */
 	bool started;
+	bool unregistering;
 
 	/* device is during a HW reconfig */
 	bool in_reconfig;
@@ -1698,6 +1699,7 @@ struct ieee80211_local {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
 		struct dentry *rcdir;
+		struct dentry *rate_ctrl_alg;
 		struct dentry *keys;
 	} debugfs;
 	bool force_tx_status;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5f0c482bd4a5a..6047614ec7804 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2278,6 +2278,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ASSERT_RTNL();
 	lockdep_assert_wiphy(local->hw.wiphy);
 
+	if (local->unregistering)
+		return -ENODEV;
+
 	if (type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN) {
 		int size = ALIGN(sizeof(*sdata) + local->hw.vif_data_size,
 				 sizeof(void *));
@@ -2490,6 +2493,7 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	LIST_HEAD(unreg_list);
 
 	ASSERT_RTNL();
+	local->unregistering = true;
 
 	/* Before destroying the interfaces, make sure they're all stopped so
 	 * that the hardware is stopped. Otherwise, the driver might still be
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6408e8464338d..b34fbe74cff96 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1679,7 +1679,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
 #endif
+	rtnl_lock();
+	ieee80211_remove_interfaces(local);
+	rtnl_unlock();
+	rate_control_deinitialize(local);
 	wiphy_unregister(local->hw.wiphy);
+	goto fail_rate;
  fail_wiphy_register:
  fail_band:
 	rtnl_lock();
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index e910f03af7775..8e90c134f1db1 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -281,13 +281,15 @@ rate_control_alloc(const char *name, struct ieee80211_local *local)
 static void rate_control_free(struct ieee80211_local *local,
 			      struct rate_control_ref *ctrl_ref)
 {
-	ctrl_ref->ops->free(ctrl_ref->priv);
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 	debugfs_remove_recursive(local->debugfs.rcdir);
 	local->debugfs.rcdir = NULL;
+	debugfs_remove(local->debugfs.rate_ctrl_alg);
+	local->debugfs.rate_ctrl_alg = NULL;
 #endif
 
+	local->rate_ctrl = NULL;
+	ctrl_ref->ops->free(ctrl_ref->priv);
 	kfree(ctrl_ref);
 }
 
@@ -1038,6 +1040,5 @@ void rate_control_deinitialize(struct ieee80211_local *local)
 	if (!ref)
 		return;
 
-	local->rate_ctrl = NULL;
 	rate_control_free(local, ref);
 }
-- 
2.34.1

