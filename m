Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FB5374A0B
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766399; cv=none; b=rbrteobXr4Y5qGGpgEhEC5ZxVCbCVf9Qx3OePqXGSwUuxF+7pL63pk2oJpvB2lrG/htXPiaUSwp5LywP3OSpe1vd7IsJmltnE+nyoy66p5Lf5hH66cBQFx1HFyGekeqhFGrp4833r6Bau/lgjqVVWOy6ucjYphvEtJXs8dst55I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766399; c=relaxed/simple;
	bh=quQhfjxfTjs15mezp6pqs+iFMc8So3jhILmHW3H41ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDmbEU3yCF8SiY6DNhcZtT0NLbh7EAX11yMpxrGUAbZ/GsBmCk9iw0sXZmYFyPal8b4k6rEwfWC+xmlvXekbdCuNz59rTnWXqCWUI490bS7iVGDrU/EWxw/p02pC2LwKUDFhw8IZowrj6mV1Ch3uZOzcoJ1eUJ731vya5jI3g7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=P8LV4Ejo; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="P8LV4Ejo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SIeYbr6n8pzik4/KN8WDQDSXphZsiQ59fQCg9on86tQ=;
	t=1785766398; x=1786975998; b=P8LV4EjoSJnheAk5yPzMx6g4+aHI2m8GTryPL5Wy/wfpxq8
	F4v8S9D2L0AxRrIiRtOeXH/H0cR8Ys8uWw8euEFdTTgcX0tlmjtYsuQ0/bWwRI/8nno8AN5BQ//LZ
	Uf53ETsSbJbVeGf+Hz3PBBpVjD2RUC1xqwEsfmKN6YMu0XPUEMpxFE8qb0e1eILfIdbb7XfNwIZ52
	WmGiRJqP5pbWyBAqOKpMoecZu8WSWKmAouj28ZwFELtrIiLYf9EXAcdsX/Lpl8DgNoeewJGue3Eld
	js/6bCeXlkrGLUG+hXmQ2b0bP6cmDer4+E7CPWe9hwkXsFfyxzCnRCxSwAtSHe8Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqtPm-0000000G4Ws-2EH1;
	Mon, 03 Aug 2026 16:13:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/7] wifi: mac80211: tx: simplify control port frame transmission
Date: Mon,  3 Aug 2026 16:08:38 +0200
Message-ID: <20260803141309.292711-11-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803141309.292711-9-johannes@sipsolutions.net>
References: <20260803141309.292711-9-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_tx_control_port() already does most of the necessary work,
much of which is repeated by __ieee80211_subif_start_xmit(). Most
work in the latter function is completely unnecessary since these
are special frames we built directly here (long enough, etc.)

Call ieee80211_build_hdr() and ieee80211_xmit() directly instead.

It also means some errors can now be reported to userspace rather
than frames silently getting dropped, but that's a good thing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6c2ee181a3a7..772350f485dd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -6596,9 +6596,6 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	skb_reset_network_header(skb);
 	skb_reset_mac_header(skb);
 
-	if (local->hw.queues < IEEE80211_NUM_ACS)
-		goto start_xmit;
-
 	/* update QoS header to prioritize control port frames if possible,
 	 * prioritization also happens for control port frames send over
 	 * AF_PACKET
@@ -6611,24 +6608,31 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 		return err;
 	}
 
-	if (!IS_ERR(sta)) {
-		u16 queue = ieee80211_select_queue(sdata, sta, skb);
+	if (IS_ERR(sta))
+		sta = NULL;
 
-		skb_set_queue_mapping(skb, queue);
+	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, sta, skb));
 
-		/*
-		 * for MLO STA, the SA should be the AP MLD address, but
-		 * the link ID has been selected already
-		 */
-		if (sta && sta->sta.mlo)
-			memcpy(ehdr->h_source, sdata->vif.addr, ETH_ALEN);
+	/*
+	 * for MLO STA, the SA should be the AP MLD address, but
+	 * the link ID has been selected already
+	 */
+	if (sta && sta->sta.mlo)
+		memcpy(ehdr->h_source, sdata->vif.addr, ETH_ALEN);
+
+	skb = ieee80211_build_hdr(sdata, skb, flags, sta, ctrl_flags, cookie);
+	if (IS_ERR(skb)) {
+		rcu_read_unlock();
+		return PTR_ERR(skb);
 	}
-	rcu_read_unlock();
 
-start_xmit:
+	dev_sw_netstats_tx_add(dev, 1, skb->len);
+	ieee80211_tpt_led_trig_tx(local, skb->len);
+
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, skb->dev, flags, ctrl_flags, cookie);
+	ieee80211_xmit(sdata, sta, skb);
 	local_bh_enable();
+	rcu_read_unlock();
 
 	return 0;
 }
-- 
2.55.0

