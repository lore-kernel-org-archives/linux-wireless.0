Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719768;
	b=2weDgvfmLy0BL00qu0O8AALZcQB3WKR77z4mtDVilQnYmShy6yJkMklVEPsRj0vsquNT
	 FXWl/Rtrg1TejmK8N3e5OtIjLIrfGWYq3eVbc9/wyDKoVu7+vUKO0opYtPRCaDrbt+5Dl
	 Kx5oEpcyqEgJRU/xQjYTMLU1Z5nAkbuyBlK75HwubqCyez3TuiNBX+6SMXEki1IWGRKrK
	 keWwjBJc+6Bh1jblpcy8/Ri4jJ3678GDlx0q0TnDMXwYVt2+af/23annK6l0AfPp/rqcw
	 ouFECZLyn7F4S7Zu9nmT0iGUuBdBnC2UZ0ovXFmpg0DVCaujveJ23QIHWPMegMf3HAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719768;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2vUkzddcPRj9+YilPLrADsvDxcJ3lBNdaDxsxHyC938=;
	b=LqtyUwqxZmrTPfOL8/lV2C9D2YWqAzdydDAX0YTuYr+qyZ8LfV5ASw9AN9jnJBWfev/V
	 co+TsKq1byC2roCiyn+6WntAvLAVUCyFf+yWKkVEiCxXpfBpcrDghaBH0Ozimpw5vQqW/
	 x5Io+o6pqzz8F4dViMlzgEpEyZctdIzy5h0G3MCJ18u0bEM3bQh4JW8oR8ZI4FUBkbh4P
	 KFOLa2EHbUyxxQ4+tly9V9yj5bR0xhE+CE5KuR2XdOWGjWKpNjoYGUQ7xNhLpwEmPT8Zr
	 /2ULzAFvOoQvptm9prEyc3rMe1pPMb3biu7f6pLltAybpedG5l8s41hqjYM+hd5icyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Wj2xCG2y;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54652606A328
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Wj2xCG2y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=2vUkzddcPRj9+YilPLrADsvDxcJ3lBNdaDxsxHyC938=;
	t=1793719768; x=1794929368; b=Wj2xCG2yWlsg0/hOjdRl8EZo3Jq5iaTZNUgKfp6Xrk2EQK6
	IQqZzOpDGMxmz6qHdfX3N1cX9cN4X3iUSdDH6+E4hEqMDdtBP5dRX6ZTF8PRa1IAEw7sw+LyG54Vb
	xbyNZPCfA+UuS5eRbz+S7K2QOz1c+++ydtG/gR2eJbB71WPXERuXg/dDIfFFdVJexY3SfSjNWb05L
	wvIRR0Hp/FzhZdPqseYob+QsVHMfPpCaSSxXuu3GHJevCPCXhL5dE/AL2ac83/U0P/nkn9p+j4CH6
	CwvdI1Ifyb4mmKaAfqEHO7FspSPOsChjPuum5cdRD5PSeLvSvCZPD3tTCECZoz7w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOGRx-00000003eXZ-3ggF;
	Tue, 03 Nov 2026 16:29:26 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 3/4] wifi: mac80211: remove redundant RCU critical sections
Date: Tue,  3 Nov 2026 16:29:15 +0100
Message-ID: <20261103162921.d87216986293.I456279ce9f5e70fb378fc668054057b49a79f005@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103152920.294873-6-johannes@sipsolutions.net>
References: <20261103152920.294873-6-johannes@sipsolutions.net>
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

From: Johannes Berg <johannes.berg@intel.com>

With the context analysis annotations it's now obvious
that the extra RCU critical sections aren't needed, so
remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 3 ---
 net/mac80211/tx.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b3df0f010b0d..4d145b3025fb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2975,7 +2975,6 @@ ieee80211_rx_mesh_data(struct ieee80211_sub_if_data *sdata, struct sta_info *sta
 		else
 			return RX_DROP_U_MESH_BAD_AE;
 
-		rcu_read_lock();
 		mppath = mpp_path_lookup(sdata, proxied_addr);
 		if (!mppath) {
 			mpp_path_add(sdata, proxied_addr, eth->h_source);
@@ -2992,8 +2991,6 @@ ieee80211_rx_mesh_data(struct ieee80211_sub_if_data *sdata, struct sta_info *sta
 		/* flush fast xmit cache if the address path changed */
 		if (update)
 			mesh_fast_tx_flush_addr(sdata, proxied_addr);
-
-		rcu_read_unlock();
 	}
 
 	/* Frame has reached destination.  Don't forward */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1df38c03d6de..f8dbed19b07e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -6566,7 +6566,6 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 		link = IEEE80211_LINK_UNSPECIFIED;
 	} else {
 		/* otherwise must be addressed from a link */
-		rcu_read_lock();
 		for (link = 0; link < ARRAY_SIZE(sdata->vif.link_conf); link++) {
 			struct ieee80211_bss_conf *link_conf;
 
@@ -6576,7 +6575,6 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			if (memcmp(link_conf->addr, hdr->addr2, ETH_ALEN) == 0)
 				break;
 		}
-		rcu_read_unlock();
 
 		if (WARN_ON_ONCE(link == ARRAY_SIZE(sdata->vif.link_conf)))
 			link = ffs(sdata->vif.active_links) - 1;
-- 
2.56.0

