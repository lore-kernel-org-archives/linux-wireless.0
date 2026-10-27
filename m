Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793108933;
	b=jX7x0ONanlVAzA+DhcNhC4UAss3qlk1Eb+x3Do7LifMRyMZcjG81Is7+Q5EHUffpirHU
	 pRtRj1HyvvOjsGluurIFVaQaW+fQ9deqP94/xwXNvwoorxT7cpuVw4861EJrHS+mM1WQv
	 ViN4mwMGA7kcjFmkdI4LM3ebUVMe+GI5Rv1rhawYFpmCNXMmlC7F/dbFo9W85cLqbUu/B
	 JDdusxoPRhMuQrCiAdWhX5Zr2g8wBS1BmOw9oy0ruh3zpkST4hVCQ7DdYchBKqf7hZ422
	 rr0gAwjkJN0FLf377XtK33OpulLa8Mcu01hj2Y1TAGkZSuqGBlotbrT/TqCLqh5NrGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108933;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=NIbYrzvmG2o/H62ylQEk21Zx7HRu/UO47uc8CYvtXXw=;
	b=mLwQ1S0vC41u5gqXZEP2E81QhYXqtVmJFyupANvbWfeOPTnoFgkOMATNpXVNdxppOFDT
	 0vxT9gZr6Hi6guoD7sAjbmOcVus0hI928y5xVG9nYma26huLJtxB5ttRIUsLUIZTK7lOa
	 YnYuqNjEl5HTUINZ21YN3cN6ag7oDZUOw6TSVReaDt3ShZcSGEXQw4A9R0Rf4dJQNSxN7
	 vZg1uhxxL3QdGKv/h7A34q78Hyi6J85lyK1e03mHSLaZvyhL1paPDXmexhaxKBOqxG72p
	 l5mNIRgpLN8RqHl3woXoI5YxFn0XA9xZa61G878M6uWGFjuRl7fm8fXpxhAimhPMm7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=awWYeqW9;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5E1606A321
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 13:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=awWYeqW9
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NIbYrzvmG2o/H62ylQEk21Zx7HRu/UO47uc8CYvtXXw=;
	t=1793108931; x=1794318531; b=awWYeqW9HxuB0mFiFVMJLOHtiZMue7M7puAxWWwgTwDJABI
	j5WPdQgQkGP3QsrDxdnq/sLo1aw6/Pld7HmvhgPDA4sOwbr3TSfE7ceMS0gi5Moxb3stz0iuPFmPE
	jM+AZ3wzIveCH5k+hiXRG7DYcTn9AQkvRxuRAZYAB7b/ziN9iX4MELrySIUjT9avRszYvqCrhjcMc
	cOkxE1scOGt2ET4ZerQnMtS5eiPX2GXYow6zoDUkBrcmj7JMDTKB3if3lneWU5U2fk3UTnm+SSc/h
	qdU+tIWgRYZxb2RkC0ezHmKxtzVIdRGn1i3BeY8KSg0WpsV0xPWjM/7D0NhKFI7w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1xLhXf-0000000D2iw-3bm6;
	Tue, 27 Oct 2026 14:48:44 +0100
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH linux-wireless 2/2] wifi: mac80211: find STA for beacons belonging to non-TX BSS
Date: Tue, 27 Oct 2026 14:46:00 +0100
Message-ID: <20261027144558.84c3f2f79b01.I055996ff039ab5c2f441c93190809e598dbea333@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027144558.7d7ed492e70a.Iaa63d80b6f13f871d1ee3cf1ce27118f72850ac0@changeid>
References: <20261027144558.7d7ed492e70a.Iaa63d80b6f13f871d1ee3cf1ce27118f72850ac0@changeid>
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

From: Benjamin Berg <benjamin.berg@intel.com>

Resolve the APs station in case a beacon is received for a
non-transmitted BSS. This is important because the station has the key
information for beacon protection. Without this change, mac80211 will
not verify the beacon when connected to a non-transmitted BSSID.

Most hardware is not affected as the frames are already verified. But
for example the virtual hwsim driver is.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 65 +++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 2568b0b95be6..5f09a8766269 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5332,6 +5332,29 @@ static bool ieee80211_rx_valid_freq(int freq, struct ieee80211_link_data *link)
 	return freq == conf->def.chan->center_freq;
 }
 
+static struct ieee80211_link_data *
+ieee80211_link_from_freq(struct ieee80211_sub_if_data *sdata, int freq)
+{
+	struct ieee80211_link_data *link;
+
+	if (ieee80211_vif_is_mld(&sdata->vif)) {
+		struct ieee80211_chanctx_conf *conf;
+
+		for_each_link_data_rcu(sdata, link) {
+			conf = rcu_dereference(link->conf->chanctx_conf);
+			if (!conf || !conf->def.chan)
+				continue;
+
+			if (freq == conf->def.chan->center_freq)
+				return link;
+		}
+
+		return &sdata->deflink;
+	}
+
+	return &sdata->deflink;
+}
+
 /*
  * This is the actual Rx frames handler. as it belongs to Rx path it must
  * be called with rcu_read_lock protection.
@@ -5492,6 +5515,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		struct ieee80211_link_data *link = NULL;
+		const u8 *addr = hdr->addr2;
 
 		if (!ieee80211_sdata_running(sdata))
 			continue;
@@ -5503,16 +5527,32 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		link_sta = NULL;
 		link = NULL;
 
+		/*
+		 * Switch to do the STA lookup using the non-transmitted BSSID
+		 * for beacon frames from the transmitted BSSID. This ensures
+		 * that the keys for beacon protection are available during
+		 * later processing.
+		 */
+		if (ieee80211_is_beacon(fc) &&
+		    sdata->vif.type == NL80211_IFTYPE_STATION) {
+			link = ieee80211_link_from_freq(sdata, status->freq);
+
+			if (link->conf->nontransmitted &&
+			    ether_addr_equal(addr,
+					     link->conf->transmitter_bssid))
+				addr = link->conf->bssid;
+		}
+
 		/* Try to resolve the station */
 		if (!ieee80211_vif_is_mld(&sdata->vif)) {
-			sta = sta_info_get_bss(sdata, hdr->addr2);
+			sta = sta_info_get_bss(sdata, addr);
 
 			if (sta) {
 				link_sta = &sta->deflink;
 				link = &sdata->deflink;
 			}
 		} else {
-			link_sta = link_sta_info_get_bss(sdata, hdr->addr2);
+			link_sta = link_sta_info_get_bss(sdata, addr);
 
 			if (link_sta)
 				link = rcu_dereference(sdata->link[link_sta->link_id]);
@@ -5539,26 +5579,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		}
 
 		/* No station, try to resolve the link and RX */
-		if (ieee80211_vif_is_mld(&sdata->vif)) {
-			struct ieee80211_chanctx_conf *conf;
-			bool found = false;
-
-			for_each_link_data_rcu(sdata, link) {
-				conf = rcu_dereference(link->conf->chanctx_conf);
-				if (!conf || !conf->def.chan)
-					continue;
-
-				if (status->freq == conf->def.chan->center_freq) {
-					found = true;
-					break;
-				}
-			}
-
-			if (!found)
-				link = &sdata->deflink;
-		} else {
-			link = &sdata->deflink;
-		}
+		link = ieee80211_link_from_freq(sdata, status->freq);
 
 		if (rx_data_pending) {
 			ieee80211_prepare_and_rx_handle(&rx, skb, false);
-- 
2.56.0

