Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D0840B0E5
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766403; cv=none; b=Q8vDoUBaDwLl3WvKEcj8NGnN7vQfLAPeypFNUYkcAOrY4WiVOBc4S1V2GFodwtNAP7n5FfCm9Rsx06YuWBtkj6Xk+RumT3Qg6pcTimIBHITvgCE4NPUjzHP7ssM5NpnUcSoMGsGIcmF3TrBe1ZFpDQROjxSOOxzXEetE52uLeWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766403; c=relaxed/simple;
	bh=CXM6neQYb80TCLG+EW7H3geUePDUXLyFVS4xivDx2tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gg2BEpXJZ6fF2tip+OolqU++jAu7VLtXE8XOzBP1TQ1pk/r2lcjngM45syZRE+dN8OFMxnndHHgHFREOJ2kW+20stLSjxi3VHWEI+TgDWmUfODSrAIiq/WEZuTJjW0FL4gN68fIhlmccqC6pvjHLQE0VN1EVmarphaHR1MT8ujA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BFbRQgp1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BFbRQgp1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=0zhLGoWdZAHgkGpDMsNbGqdeWrhHgcelilqKSFWQFXs=;
	t=1785766401; x=1786976001; b=BFbRQgp1H5Gbo3DiIaVCjJo+Q0MFPoLsFik8YHPt1+qAxI8
	gRttB20iAaENSXB77e4S/3ndYMxLU+7CltPYt+Y1yjrpXrTnDPQ8fvHgb7YL0f68QAclV3QDKIJEX
	7b9rO7AvJUjsRhb+3AVoePXn88Lvg/UrzFU7McTqFWoQ9SAAY8jMIY3ArYzUaaFDgsl+9JMIdyULh
	DfeQ04L3MGUA2ThT3Q2DiHpeQ0ZaW/I6ejhGAq2UIOcGFmKJSQBnFbs36Fg2i5p+jPrJUAYhpieAU
	k+8XEEQ1/3+vOpgP57XOnm2L6VH9vwgl2o24MvSkJ5fGb2zUFUwaxrWYRE41A8xg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqtPp-0000000G4Ws-3eBz;
	Mon, 03 Aug 2026 16:13:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 5/7] wifi: mac80211: report multicast transmission from lookup_ra_sta()
Date: Mon,  3 Aug 2026 16:08:41 +0200
Message-ID: <20260803141309.292711-14-johannes@sipsolutions.net>
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

ieee80211_lookup_ra_sta() returns ERR_PTR(-ENOENT) both when the
802.11 frame will be is group addressed and when it's going to
an unknown station.

Keep reporting an ERR_PTR() for group addressed but set to NULL
for individually addressed frames so the callers can use it to
distinguish later. This is already explicitly the case for all
interface types except mesh, and callers already tolerate (but
don't distinguish) both cases.

Also change the ieee80211_lookup_ra_sta() to be static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  5 -----
 net/mac80211/tx.c          | 19 +++++++++++++++----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 85f72ad06ad7..f4ac945b5508 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2471,11 +2471,6 @@ static inline bool ieee80211_require_encrypted_assoc(__le16 fc,
 	return sta && sta->sta.epp_peer && ieee80211_is_assoc(fc);
 }
 
-/* sta_out needs to be checked for ERR_PTR() before using */
-int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
-			    struct sk_buff *skb,
-			    struct sta_info **sta_out);
-
 static inline void
 ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1d139c2506bb..cc0c6b46d19c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2504,9 +2504,16 @@ static inline bool ieee80211_is_tdls_setup(struct sk_buff *skb)
 	       skb->data[14] == WLAN_TDLS_SNAP_RFTYPE;
 }
 
-int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
-			    struct sk_buff *skb,
-			    struct sta_info **sta_out)
+/*
+ * Returns an error if the frame should be dropped, otherwise
+ * the *sta_out pointer is filled:
+ *  - valid sta pointer: frame goes to that station
+ *  - NULL: frame will be unicast to a yet unknown station
+ *  - ERR_PTR(-ENOENT): frame will be group addressed
+ */
+static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb,
+				   struct sta_info **sta_out)
 {
 	struct sta_info *sta;
 
@@ -2531,6 +2538,10 @@ int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
+		if (is_multicast_ether_addr(skb->data)) {
+			*sta_out = ERR_PTR(-ENOENT);
+			return 0;
+		}
 		/* determined much later */
 		*sta_out = NULL;
 		return 0;
@@ -2573,7 +2584,7 @@ int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 		return -EINVAL;
 	}
 
-	*sta_out = sta ?: ERR_PTR(-ENOENT);
+	*sta_out = sta;
 	return 0;
 }
 
-- 
2.55.0

