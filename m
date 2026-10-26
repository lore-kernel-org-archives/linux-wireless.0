Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.102
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793032717;
	b=AKNbwSeZUpmNL7TRRIMAzm6jw2/yueM8kIileah0ddmHAlV1jrSa9xHwhXM5JstueWA9
	 4k9SiC7d6Wp0hqeoBDHxDlt9/zmnAFYpQ8d/GbPM+IQowKsEWhjgu6C1FHhr6fyLBPkyd
	 x2KeHaxMgWV1M0TpafL/nRgfx/uDlU7OKdNfI8kTPNZxPlh7BT+aGC3sn41gp+rO1sVb1
	 2N4HJkrHUvsE/Wx5cZsl16QgFmfKm6fCqSuFjInKJTPcT9zrCJFMycxwV5IQV3S+p3pWv
	 m4G66O9K0MzTeuqP3Cruzzw4/2ZmO1mHjv3HxTQ2HxqNalUBBc3pn0A08CW7fPR17vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793032717;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+w88iybKeXNrtW8pKIrFsCOA83kx7qTurOttkKyyo/4=;
	b=mXQ3mPcKtsmy9o3Jed/K3h/WyeROSJpbPFO/jBOEmnIEiZBGLC/IK9GUP4sAjRtxdOVA
	 AopEJVFdMeJqxvQAemkRAapx9eH3+7y4PiA/p67r1SGOkUwVrKiVS6dLAmaccZYM7G6Xn
	 o3d+T0WlsoeLGOss95CqNLw9bWyFJjrr+Sw88QhYPaJRXvdWFJuZ1AxIx7ZP4dejyFbsp
	 95r6YrsZG0FYhrt5je6U9aMW4Z96Z+8Mr0IaPlrIzXzjCLQGI3nNa6lVmbMvndlzCPqes
	 N9xo8Hpqdzn3Koejwfc8NVhkIrYWNdF7rPuLLqVfqiJDd0YAlOA2iAFUW5aQh9AFo9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=AnzrvmNR;
	arc=none smtp.remote-ip=91.218.175.102
Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EDF606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 16:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9EDF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=AnzrvmNR
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GxQVAOOAdcXelYjfVik8S9AVFCrwrK8we11hgm+pev0=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793032713; v=1; x=1793637513;
 b=AnzrvmNRswuOfbH/oCwurliza+EmeKqfsJ1q/EmmeLqZenci4fiFbY94SRdAquLOR1KhFLOS
 aRU7HhO3nOF/re6NQpUkui9xstA1Vhv/zf03uYLyMST0tTqqvimJi63wFiQI1Yz8xhK3Mg8Sn5O
 ouWjAiTQfjwXGANx+rOzqOTqK+FER0Ms+xSjyGvJP0eluW+h/HgT4zE5CYxM1YH6cXgTm4uGgO4
 /TVgwSVfv6d5dtSiYNAm3baVEYWtgtiSwyruoiABQpxRKWKIuzolXR7dvjRNJstSatfmLG3hUI1
 QTUTrRys8+WzIDVbZzQUxgzKuMr9iWk6zMgXrRaxeL34Q==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e633de21fb908b9f;
	Mon, 26 Oct 2026 16:38:33 +0000
X-Mizu-Trace-ID: e633de21fb908b9f
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: mac80211: fix channel changes for active monitors
Date: Mon, 26 Oct 2026 09:38:31 -0700
Message-ID: <20261026163831.585260-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260901025525.4017-1-matheus.aalmeida@inf.ufrgs.br>
References: <20260901025525.4017-1-matheus.aalmeida@inf.ufrgs.br>
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

My Tested-by missed a crash. Move a passive monitor to another channel,
add an active monitor on it, take both down, active first, and the
kernel crashes. owly (AirDrop for Linux) sets its monitors up this
way. On hwsim, with the station interface down:

  modprobe mac80211_hwsim radios=1 channels=2
  iw phy phy0 interface add hmon type monitor
  ip link set hmon up
  iw dev hmon set freq 2437
  iw phy phy0 interface add amon0 type monitor flags active
  ip link set amon0 up
  iw dev amon0 set freq 2437
  ip link set amon0 down
  ip link set hmon down

  WARNING: net/mac80211/driver-ops.c:374 at drv_unassign_vif_chanctx+0x285/0x290
  WARNING: drivers/net/wireless/virtual/mac80211_hwsim_main.c:282 at mac80211_hwsim_unassign_vif_chanctx+0x113/0x130 [mac80211_hwsim]
  Oops: general protection fault, probably for non-canonical address 0xdead000000000122: 0000 [#1] SMP NOPTI
  RIP: 0010:ieee80211_free_chanctx+0x39/0xd0

Moving it makes the virtual monitor's chanctx shared and the active
monitor joins it. a1dc648aa76d stopped counting the virtual monitor,
so the active one leaving frees it. This fixes it:

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -216,11 +216,17 @@ int ieee80211_chanctx_refcount(struct ieee80211_local *local,
 			       struct ieee80211_chanctx *ctx)
 {
 	struct ieee80211_chanctx_user_iter iter;
+	struct ieee80211_sub_if_data *sdata;
 	int num = 0;
 
 	for_each_chanctx_user_all(local, ctx, &iter)
 		num++;
 
+	sdata = wiphy_dereference(local->hw.wiphy, local->monitor_sdata);
+	if (sdata &&
+	    rcu_access_pointer(sdata->vif.bss_conf.chanctx_conf) == &ctx->conf)
+		num++;
+
 	/*
 	 * This ctx is in the process of getting used,
 	 * take it into consideration

It crashes on hwsim, mt7921e, mt7925u and mt76x2u. With this nothing
does and the active monitor keeps its channel.

Was it rejected for the approach, or would a v2 with this make sense?

Thanks for the channel fix, Matheus.

Devin
