Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793108933;
	b=njEjLgMctKnKyqBoStDxKX5JrakSSegA6fmrFiPWQRZILA/qQzLkAK+9ojhP/4GbGL8w
	 T+5wwXKoA2fGzRcx4ffUgjM89kN4ZYPK1nIoIp/sfwO96E+D2czrOeN6+sQLcgyp9tenk
	 39iqcJBqp+s4ycoVY7Q1anNRA70AgrBaNIee7RthKKwSxohlAPThY1O0gsqAANOfGv+T1
	 JRymCIAznu4v1WdL36dUsb9uMTzORZqiRfbJGyasmneicNAynmVxCtz+EBFZd1rL5LrLW
	 B3Q3ypki5Cd13apuQliMsuhWtEpl4+0Y5hXZuxqn0kAH4xAyVGGqsmJJqmSphZ3Qj+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108933;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/qxON7BB/zHPBPI1VVz0/2k/GXDEK+SecjrgKJo4Rzg=;
	b=xlx/27zqgV3Xlp9+7znM+a3NRWXUzHtdUBK7lPgDJMx95BmzAannDcgrMmXn0+KNrKhf
	 0fxBBhnIUSFH2zNx1uwk+a61X0D7YUiplMB5B9hC0VoHmrAMiYk+Qe1KglxgwYe4oB2PG
	 lKZgN6SU83k0TwSf2iReLv1+1pl53pZop8sgK7yJpLy29Lkm40snZk4LCnjD7/VpoYzpB
	 nMWRldfDMijdWzN685kgUe0NbE7J8nWKxK28GFBGBhdIoQsNJiF1sahUksRbVicTOJjeM
	 XgUOq2Rmfj9hmXNfq6tgUGssjuCk6PegHzYnkYAKWX1F0sFPavG/x+uQgI7p7QI458g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=DYlsa43x;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243C4606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=DYlsa43x
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=/qxON7BB/zHPBPI1VVz0/2k/GXDEK+SecjrgKJo4Rzg=; t=1793108931; x=1794318531; 
	b=DYlsa43xq7rRg8okUHQA7BPyNFM/kfo5EolSO1635RzChomCs5MCif8S7r4UguwEeqvoji7nffJ
	aS7sf0PC1eCpNa5twWXgS72F+fG0gTpVtl1u26+f2ummTZoHIMVRigZJAvEiqQFycEqoQUeeYHELI
	rmE5ga8r3ZJ2YaYEOCn/4nkVmiXXGq3uqWqPzvz0IiH2DjbzCuqxhRy4p8CcotrzRp5o0tymmqMaa
	cRBFgM+Tt+USaIdbc3BUFGxma6VeMWwa3MAO+gfQYyxFvFynRWjfry8aACiBbZKDG4CXUC0AcI+Wr
	gcYXIAzchDdU/y5f8Cz6sLCYhUF/KV+ytifg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1xLhXe-0000000D2iw-3xl6;
	Tue, 27 Oct 2026 14:48:43 +0100
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH linux-wireless 1/2] wifi: mac80211: do not switch to invalid link
Date: Tue, 27 Oct 2026 14:45:59 +0100
Message-ID: <20261027144558.7d7ed492e70a.Iaa63d80b6f13f871d1ee3cf1ce27118f72850ac0@changeid>
X-Mailer: git-send-email 2.56.0
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

Set the link_id in the SKB status to the invalid value of 0xf when the
link ID is not valid. Also update the test in ieee80211_rx_handlers to
correctly check this case. This avoids switching to an invalid link
during RX of a single frame (when updating the link is not needed).

It also means that the SKB link_id now has a more reasonable value as it
is possible to differentiate the non-valid case from the case where the
value is set to 0.

Add back the appropriate checks before trying to use the link_id for
access to arrays. These were removed in commit 4db13371e217 ("wifi:
mac80211: refactor RX link_id and station handling").

Finally, this also fixes the link_sta lookup to use the correct link ID,
rather than an old value from rx->link_id.

Fixes: 2d03b83ef762 ("wifi: mac80211: fix non-MLD link ID handling")
Fixes: 4db13371e217 ("wifi: mac80211: refactor RX link_id and station handling")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  3 ++-
 net/mac80211/ap.c      |  3 ++-
 net/mac80211/iface.c   |  7 +++++--
 net/mac80211/mlme.c    | 10 ++++++----
 net/mac80211/rx.c      | 28 ++++++++++++++++++++--------
 net/mac80211/scan.c    |  5 +++--
 6 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 76ff86ff9974..5962d1416bfe 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1772,7 +1772,8 @@ enum mac80211_rx_encoding {
  * @zero_length_psdu_type: radiotap type of the 0-length PSDU
  * @link_id: id of the link used to receive the packet. Set and used by
  *	mac80211 internally, it uses @freq set by the driver to identify the
- *	correct link per vif.
+ *	correct link per vif. Set to %IEEE80211_LINK_UNSPECIFIED for non-MLD
+ *	or if link information is not applicable.
  */
 struct ieee80211_rx_status {
 	u64 mactime;
diff --git a/net/mac80211/ap.c b/net/mac80211/ap.c
index 9a3122da84bc..eaad7b70b887 100644
--- a/net/mac80211/ap.c
+++ b/net/mac80211/ap.c
@@ -66,7 +66,8 @@ ieee80211_rx_eml_op_mode_notif(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	int opt_len = 0;
 
-	if (!ieee80211_vif_is_mld(&sdata->vif))
+	if (!ieee80211_vif_is_mld(&sdata->vif) ||
+	    status->link_id == IEEE80211_LINK_UNSPECIFIED)
 		return;
 
 	/* eMLSR and eMLMR can't be enabled at the same time */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d0b0a503b229..63a371c79183 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1712,8 +1712,11 @@ static void ieee80211_iface_process_skb(struct ieee80211_local *local,
 				break;
 
 			status = IEEE80211_SKB_RXCB(skb);
-			link_sta = wiphy_dereference(local->hw.wiphy,
-						     sta->link[status->link_id]);
+			if (status->link_id == IEEE80211_LINK_UNSPECIFIED)
+				link_sta = &sta->deflink;
+			else
+				link_sta = wiphy_dereference(local->hw.wiphy,
+							     sta->link[status->link_id]);
 			if (link_sta)
 				ieee80211_ht_handle_chanwidth_notif(local, sdata, sta,
 								    link_sta, chanwidth,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 15d7482a4a22..bcd942bae8f1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -11974,10 +11974,12 @@ void ieee80211_sta_rx_queued_frame(struct ieee80211_sub_if_data *sdata,
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
 	fc = le16_to_cpu(mgmt->frame_control);
 
-	link = sdata_dereference(sdata->link[rx_status->link_id],
-				 sdata);
-	if (!link)
-		return;
+	if (rx_status->link_id != IEEE80211_LINK_UNSPECIFIED) {
+		link = sdata_dereference(sdata->link[rx_status->link_id],
+					 sdata);
+		if (!link)
+			return;
+	}
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_BEACON:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 905fd70491ce..2568b0b95be6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4203,6 +4203,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 
 	while ((skb = __skb_dequeue(frames))) {
 		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+		int link_id;
 
 		/*
 		 * Most fields are valid across frames. However,
@@ -4211,18 +4212,27 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 		 * and link_sta accordingly.
 		 */
 		rx->skb = skb;
+		link_id = status->link_id == IEEE80211_LINK_UNSPECIFIED ? -1 : status->link_id;
 		if (ieee80211_vif_is_mld(&rx->sdata->vif) &&
-		    unlikely(rx->link_id != status->link_id)) {
+		    unlikely(rx->link_id != link_id)) {
+			rx->link_id = link_id;
+
+			if (link_id >= 0)
+				rx->link = rcu_dereference(rx->sdata->link[link_id]);
+			else
+				rx->link = &rx->sdata->deflink;
+
 			if (rx->sta) {
-				rx->link_sta =
-					rcu_dereference(rx->sta->link[rx->link_id]);
+				if (WARN_ON_ONCE(link_id < 0))
+					rx->link_sta = NULL;
+				else
+					rx->link_sta =
+						rcu_dereference(rx->sta->link[link_id]);
 
-				/* Link got disabled, just use deflink */
+				/* Link disabled or invalid, just use deflink */
 				if (!rx->link_sta)
 					rx->link_sta = &rx->sta->deflink;
 			}
-			rx->link_id = status->link_id;
-			rx->link = rcu_dereference(rx->sdata->link[status->link_id]);
 		}
 
 		if (WARN_ON_ONCE(!rx->link)) {
@@ -5156,7 +5166,8 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	}
 
 	status = IEEE80211_SKB_RXCB(skb);
-	status->link_id = rx->link_id < 0 ? 0 : rx->link_id;
+	status->link_id =
+		rx->link_id < 0 ? IEEE80211_LINK_UNSPECIFIED : rx->link_id;
 
 	ieee80211_rx_8023(rx, fast_rx, orig_len);
 
@@ -5227,7 +5238,8 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 	}
 
 	status = IEEE80211_SKB_RXCB(rx->skb);
-	status->link_id = rx->link_id < 0 ? 0 : rx->link_id;
+	status->link_id =
+		rx->link_id < 0 ? IEEE80211_LINK_UNSPECIFIED : rx->link_id;
 
 	if (ieee80211_is_s1g_beacon(hdr->frame_control)) {
 		ieee80211_invoke_rx_handlers(rx);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8a66d2e020f9..69eb991d9b5a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -214,8 +214,9 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		if (ieee80211_vif_is_mld(&scan_sdata->vif)) {
 			s8 link_id = rx_status->link_id;
 
-			link_conf =
-				rcu_dereference(scan_sdata->vif.link_conf[link_id]);
+			if (link_id != IEEE80211_LINK_UNSPECIFIED)
+				link_conf =
+					rcu_dereference(scan_sdata->vif.link_conf[link_id]);
 		} else {
 			link_conf = &scan_sdata->vif.bss_conf;
 		}
-- 
2.56.0

