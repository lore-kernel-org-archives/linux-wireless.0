Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015516;
	b=yCynFHNqG8AzjMq/JgUkXZmpXz1H+72bFwlvfRz8KbTSOV8odlEPdf8e2jEB+TSfBhy6
	 URGF0uapbxEb9HfxuqhbFoldSm9gldMXaadU5C442u72RliQjHXOCnedD1ZpY+coa5l3/
	 ZTUZL+U9o5dZUtsjGUEQyv5cRcC2Dhjfb3RkR5v6BzMhLaaYaEYGIQB0I8rYVA4VaVupc
	 LOsBVZqrQdemuoQwK93dvGH5uDCMYmnhTdcJStoRY9BhN5Pdy7Ean62nmF3tc80fGvj6G
	 FiVoz1gnIKl9IUDrV86y+kbcyrL3eYbiIqA8Fbs3JReRUsWdzv0wpLEmnw7q97MwQIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015516;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5Pa3mnu+39FvlAm5w7TWGGIoWJkBg9DRUtwyUQlBQd4=;
	b=PN08hiVFFXhfSmg2Bx699z0yDS5TuAkH4cfFm4A7nmCHm7tmjReRlNvf0tKoWMuugq93
	 HhTPdMdzJpBxoKZJRr5tCIMI9VH1vX/DORi6DAImWNZ4ZrlWQXjzCfb+WpsETTfiie4bm
	 TU32yn9abEhH1/lLxU4CNBMZRWc6epaC7tF+ODRiGchY6Unb3ItL+UPtAJQiWbxkNF9QC
	 0fyl0zhj9XrRTZu0qUayUuZvnkdkoAqLX+dkbrXqTYvUv9UBjQygF1P7nqyne9UCdmSPt
	 pI9UQv8nCro+8upiUoo6jeW4Vk2CsOEk0ArF7hMnk5Ta3JxMrIXBGGBL4X/ahutiKjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=vTsVvdip;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72358606A32C
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=vTsVvdip
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5Pa3mnu+39FvlAm5w7TWGGIoWJkBg9DRUtwyUQlBQd4=;
	t=1793015516; x=1794225116; b=vTsVvdip2xCpOYNJgsHvwCjolOzWUQBg85b2KnqpFmUQnVC
	INtZHD3TvKKWcQjtfJKuvrP5nKxzOS8A20VTUZdau/WNl6Qe7qszzD062aruOlwQdHLhP4+9TvHgH
	rNvXGG/mdT/ApvjNLsD9tzMPI1jVTSAOsZI4jyr501B4ug4rWyvQSF8FpMKw1XlAGdMm7EUuBMoNZ
	0Pdywv4UN7cyWJRTsOJ3VckhuOK5YfykDGYasAzqS/kUJ+re10fmkBvqTUf8CrkHHJvqRGyIjoyYA
	nxvuWsoZTYCnmMTiRde0dl+vc32Vf24kBm8BCWpacbiQen/6HMs+E6uJmcFdkwyg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xLJF3-0000000BDPs-3KlW;
	Mon, 26 Oct 2026 12:51:54 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 6/6] wifi: mac80211: remove force_synchronize from ieee80211_free_keys()
Date: Mon, 26 Oct 2026 12:48:40 +0100
Message-ID: <20261026125145.94ac0069a44b.I8d6d1ca4d1c7c1d1b937422c3ad596d2e8545c0a@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026115144.189706-8-johannes@sipsolutions.net>
References: <20261026115144.189706-8-johannes@sipsolutions.net>
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

The only reason for the force_synchronize here was for some
callers to amortize their own synchronize_rcu() with the one
required for keys, but keys no longer require one. Clean up
the argument.

It seems like this should require some callers to call it
themselves, but the original user was do_stop(), which now
has its own (again) anyway to ensure no frames go to the SKB
queue before purging it. See commit 7907c7d33c37 ("mac80211:
free all AP/VLAN keys at once") for the move into key code.

The other callers (AP_VLAN, NAN, mesh) didn't really care
at all, so we can just drop the argument.

Assisted-by: LLM
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 14 ++++----------
 net/mac80211/key.c   |  5 +----
 net/mac80211/key.h   |  3 +--
 net/mac80211/mesh.c  |  2 +-
 4 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 581a5d57e560..8bfd6bc9c9fe 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -614,8 +614,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 	case NL80211_IFTYPE_AP_VLAN:
 		list_del(&sdata->u.vlan.list);
 		RCU_INIT_POINTER(sdata->vif.bss_conf.chanctx_conf, NULL);
-		/* see comment in the default case below */
-		ieee80211_free_keys(sdata, true);
+		ieee80211_free_keys(sdata);
 		/* increased by AP value on ifup, so reset on ifdown */
 		sdata->crypto_tx_tailroom_needed_cnt = 0;
 		/* no need to tell driver */
@@ -662,7 +661,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		 * Free the remaining keys that might be associated with the
 		 * NAN interface, e.g., IGTK and BIGTK used for Tx.
 		 */
-		ieee80211_free_keys(sdata, true);
+		ieee80211_free_keys(sdata);
 		break;
 	case NL80211_IFTYPE_NAN_DATA:
 		RCU_INIT_POINTER(sdata->u.nan_data.nmi, NULL);
@@ -674,13 +673,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		 * Free the remaining keys, if there are any
 		 * (which can happen in AP mode if userspace sets
 		 * keys before the interface is operating)
-		 *
-		 * Force the key freeing to always synchronize_net()
-		 * to wait for the RX path in case it is using this
-		 * interface enqueuing frames at this very time on
-		 * another CPU.
 		 */
-		ieee80211_free_keys(sdata, true);
+		ieee80211_free_keys(sdata);
 		skb_queue_purge(&sdata->skb_queue);
 		skb_queue_purge(&sdata->status_queue);
 	}
@@ -906,7 +900,7 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 		wiphy_work_cancel(sdata->local->hw.wiphy, &sdata->work);
 
 	/* free extra data */
-	ieee80211_free_keys(sdata, false);
+	ieee80211_free_keys(sdata);
 
 	ieee80211_debugfs_remove_netdev(sdata);
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index b66168edab25..d1e3fe37d2e3 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -1229,8 +1229,7 @@ void ieee80211_free_key_list(struct ieee80211_local *local,
 		ieee80211_key_destroy(key);
 }
 
-void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
-			 bool force_synchronize)
+void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *vlan;
@@ -1252,8 +1251,6 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 
 	WARN_ON(!list_empty(&sdata->key_list));
 
-	if (force_synchronize)
-		synchronize_net();
 	list_for_each_entry_safe(key, tmp, &keys, list)
 		ieee80211_key_destroy(key);
 
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index b7afd6c90eb0..9f13d175623a 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -205,8 +205,7 @@ void ieee80211_remove_link_keys(struct ieee80211_link_data *link,
 				struct list_head *keys);
 void ieee80211_free_key_list(struct ieee80211_local *local,
 			     struct list_head *keys);
-void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
-			 bool force_synchronize);
+void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
 void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
 				    struct link_sta_info *link_sta);
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8f8814125375..5f523e14cf84 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1226,7 +1226,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata, -1);
-	ieee80211_free_keys(sdata, true);
+	ieee80211_free_keys(sdata);
 	mesh_path_flush_by_iface(sdata);
 
 	/* stop the beacon */
-- 
2.56.0

