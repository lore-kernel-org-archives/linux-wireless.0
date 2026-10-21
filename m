Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792614030;
	b=1h+e3H4rfChee/vEaCIrjNGYO3tQIUAoK5teVxuraSBnGx2hvltd7H9exmKwgdyhfW/r
	 rfCDjbW+uof23BOjpgV7Qpsc6Df2FLTRLnzAKRtGaoV/FIPe5KEp9s/6YHDfth+HvQMZl
	 nFIxBgR13BCJ1rQA8f/b1bSGPK3vxrd+/pesB2Iu+XFNV9yN8jwgy5mY+8faRlzCvwq/A
	 8xdL37ATS9QSQFOs/wyCfyZHd8Yhq32Lf60sY/Rta4RTVy6FQ2aOpc+76mUzA9+1oYHBY
	 zwfhb30hKdkMkZ3ErQXaso7B43XyU08qGQp+6C2VBlMmnLh2eDuH2wM0dbonoJ4FoUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792614030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1dsbTRUUZAIHuOkmNlkVS28FEDkccXE9KFaKF3Qdc8Q=;
	b=BeQlxLQ+Ga6LAUcBpUfW5DUuq5Newvfqlzvyv88YLuMnYemt6D5jUdYOtZx7CHqwX02l
	 XBwOjLTrlY/LtNi8iE3HwVy9Hq4uLlqHKMDheFDVtDUfFfjr2DO1ug/ZDYDRYWNCKZkx0
	 giNys6MLMygGxXSZlGZQ9r3VQxMyougk0UUrqZbrhZNhzO8hut4xvu6d6+lKvvtfLxWVu
	 U5hyqCbi0FFCfwQLnlOZ/VkHs1ZNRUc3jDCzfvRosoUKCsKfdIhRLmZuMnMz+eCFZ7F8i
	 XE2ArkUVfRlvOoZ0IarNNqOw4nPtCnFOuMNasnYB9mlMp3IeYUOWzbaVcI7rHxSSfoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mind.be;
	spf=pass smtp.mailfrom=essensium.com;
	dkim=pass header.d=mind.be header.i=@mind.be header.a=rsa-sha256 header.s=google header.b=GP4KPKjQ;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC213606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 20:20:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC213606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mind.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=essensium.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mind.be header.i=@mind.be header.a=rsa-sha256 header.s=google header.b=GP4KPKjQ
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so8563455e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google; t=1792614027; x=1793218827; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1dsbTRUUZAIHuOkmNlkVS28FEDkccXE9KFaKF3Qdc8Q=;
        b=GP4KPKjQgmW4vmacn3ywjmdSbmhh1jgzFd3o5GJg50rP0gQ5mQJfwjQAzfZDMODVNU
         Wc29rKdL2SBtaNN5ZoN5ruOFLX0vvYAo89nKutSVgmO71DO+yilSrAXEu6NjjBLOiD3I
         Grgk96IimXsBmK2/eig4HVt6wCHeo5JqO3vUd3Gu4DVobB+kfzW7CiA6h4s9nISD05Va
         /ynOIZgQljR8296vQMhxzTVPRbQZswFZn31/z0Irz/rwMtC3dLNth0Mw6yS6GD6fUPWI
         NaQCQaD/LCWf1ie5EqPHk3Txr1SIxf9ap5me6Rc/S/BfzYr3uT0kDhh9IP3zsr9gF0Wg
         53vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792614027; x=1793218827;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1dsbTRUUZAIHuOkmNlkVS28FEDkccXE9KFaKF3Qdc8Q=;
        b=quuPV/adw9xIeAnG9RjSClHkIeiTWcSS3JcQVUP3onpYBNFChY9+rfLnEQcBMAHzXB
         0jgDrtkK+jY3SjA1ZOxdv6yMJIQfNHIovLqQl1H+UjzS3eltWzZiDnrF7RaXUs0l0TEv
         L0YzvP5Fhy7HNN6G0AMOXMjL7I7G7iDU5WTscVk7XDGFIMf92VocyebdHwGWnzZeJUTz
         53FkvBwqzPzGS93g5jbvmzKWtwjxmyJQeFp2HQpCOLUKTp5NXbOeae7KO95LvO8PWEiH
         DNzYeSND0FO3kKJdRjglNVVyLYdfYj7ONC7ZftKwMeBHfMmlkVagrSmD0EuFXrHPbFWY
         78ig==
X-Gm-Message-State: AFq9FYJhMZ+B5ZZ3mj66OkoDCxA9ANSUNd92b9ju9h7InbeWycZ+pjEz
	jmO0ZFWE7WHfjurY5lv/SMOfsmQ93iyOc4cW8bzXpuGRwTWLsnzqNVGpTS0an+Rd4nE=
X-Gm-Gg: AYBFou1uB9t7+aL1WApNEKIkmwbFY/A+tlCOnOQIaSlUSKhUU6+yObgntZ2VQixMlOQ
	MzVx006e3gf1cZqGFbpOjxw1nJoZmhlegmy30SV2PjwbhQIT9ab6UoWmzWDOBWsOa57nfVapQFn
	hV3fzq52c5eTtaVUwBgxS6bvkJXt5miIWq4plax6eImUmm3LM7JHSJyoD648YF02y4URaqvv/4L
	8jJ8pKtoxRjZbhWw8BPYiibEVokAjLElBnNCYLaQpoqTErT8zfjKnS5561qAMuGsGFBX0tjY/T0
	0EcS23/a9N7TipOfyC1HZmVY3gQt1hkc75b7eU9MnhlcYjH6XXgaGWNNgoyupu/2a9wxBmm8ATb
	C95YfvvKzPX6EUSYn8+DzUmXPTEY7Df5t53JykXVctkBTxqEARtL2s6WqpMCS056U2+6/lO1YBs
	ZvJMptpsO+ug9ks4ht30nsZ7LjoY+7Ai/CecI9zAJ+E4Wso12EN77l4V96wRF+G2nyU8blnSyyg
	KsGHf/mbUM8AsgaODYkWaW0H9oIFeEuSuVkCNDYiNB0GviRIOVEUYGPj7VU3Qh/iHuu5aCmCk7Q
	U9KxFdU0gW8UBOPm
X-Received: by 2002:a05:600c:34c4:b0:4a2:1a:a10a with SMTP id 5b1f17b1804b1-4a2001aa275mr57783885e9.29.1792614027070;
        Wed, 21 Oct 2026 13:20:27 -0700 (PDT)
Received: from debian-hp-1.fritz.box ([212.233.51.18])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203b66f6bsm21923215e9.15.2026.10.21.13.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 13:20:26 -0700 (PDT)
From: =?UTF-8?q?Rapha=C3=ABl=20M=C3=A9lotte?= <raphael.melotte@mind.be>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	=?UTF-8?q?Rapha=C3=ABl=20M=C3=A9lotte?= <raphael.melotte@mind.be>
Subject: [PATCH wireless] wifi: mac80211: get AP HT/VHT data for assoc request after mode is known
Date: Wed, 21 Oct 2026 22:20:20 +0200
Message-ID: <20261021202020.640739-1-raphael.melotte@mind.be>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When user space does the authentication, for example for FT with iwd,
there is no matching auth_data. Then in ieee80211_mgd_assoc(), conn.mode
is limited only by our own capabilities. The AP's capabilities are
applied later, by ieee80211_determine_chan_mode() in
ieee80211_prep_connection() or ieee80211_prep_channel().

ieee80211_mgd_get_ap_ht_vht_capa() runs before that. It fails the
association with -EINVAL if conn.mode is HT or VHT and the AP has no
HT operation element, or no VHT capability element on 5 GHz. Thus, an
association to a legacy AP, or to an HT-only AP on 5 GHz, fails. For
an FT roam the old AP has already been left, so the connection is lost.

To fix it, get the AP's HT operation and VHT capability data when the
association request is built, after conn.mode is set from the AP's
capabilities, and use zero values if the AP does not have the element.
Remove the early check and the copies in the association data, since
they are not needed anymore.

Note that as a side-effect, a 5 GHz AP that gives VHT operation
information only in its HE operation element, without a VHT capability
element, is now also accepted with in-kernel authentication.

Fixes: 7d8b02592d52 ("wifi: mac80211: obtain AP HT/VHT data for assoc request")
Signed-off-by: Raphaël Mélotte <raphael.melotte@mind.be>
---

Notes:
    The problem was noticed with iwd connected to an HT AP, while a legacy
    AP with WMM enabled was a roaming candidate in the same mobility
    domain. The FT roam to the legacy AP always failed in
    NL80211_CMD_ASSOCIATE with -EINVAL, after the FT authentication was
    successful. Then iwd must connect again from the start, which takes
    much longer than an FT roam.  With mlme debug, the kernel logs "no HT
    operation on BSS <bssid>".
    
    This seems to occurs only when there is no auth_data, that is, when
    user space does the authentication. With in-kernel authentication,
    conn.mode is already lower than HT for a legacy AP when the
    association starts.  wpa_supplicant uses in-kernel authentication for
    FT by default, so it should not have this problem. SAE or FILS with
    external authentication can possibly have the same problem, but I did
    not test this. I also did not test the VHT case (an HT-only AP on 5
    GHz) on real hardware.
    
    Another way to fix it would be in ieee80211_mgd_get_ap_ht_vht_capa()
    to lower conn.mode instead of returning -EINVAL. I did not use this
    approach, because then that function changes the mode, which its
    callers do not expect, and ieee80211_determine_chan_mode() sets the
    mode later anyway.
    
    Note that this changes at least one behavior: a (bogus) 5 GHz AP could
    theoretically give VHT operation information in its HE operation
    element without a VHT capability element. Then conn.mode can be VHT or
    higher after ieee80211_determine_chan_mode(). Before this patch, such
    an association failed also with in-kernel authentication.  Now it
    continues.
    
    Tests (mac80211_hwsim, iwd test-runner, qemu):
    - AP 1: 5 GHz, HT/VHT, FT-PSK, mobility domain aabb.
    - AP 2: 5 GHz, legacy (ieee80211n/ac/ax=0, wmm_enabled=1), FT-PSK,
      same mobility domain.
    - iwd connects to AP 1, then roams with FT to AP 2.
    
    Without this patch, the roam fails (netdev_cmd_ft_reassociate_cb() -22).
    With this patch, the roam is successful, and a normal connection to AP 2
    is also successful. I did the tests on v6.18.48 and on
    wireless/main (045958acaa75).
    
    Note that I used an LLM tool to help analyze the problem, re-write the
    patch and setup the test infra. I examined and tested the result.

 net/mac80211/ieee80211_i.h |   4 --
 net/mac80211/mlme.c        | 130 +++++++++++++------------------------
 2 files changed, 45 insertions(+), 89 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9374c2942489..4d1734c60e64 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -446,10 +446,6 @@ struct ieee80211_mgd_assoc_data {
 
 		u8 addr[ETH_ALEN] __aligned(2);
 
-		u8 ap_ht_param;
-
-		struct ieee80211_vht_cap ap_vht_cap;
-
 		size_t elems_len;
 		u8 *elems; /* pointing to inside ie[] below */
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3c31c16860ab..9b97ae3b353e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2148,6 +2148,43 @@ ieee80211_assoc_add_ml_elem(struct ieee80211_sub_if_data *sdata,
 			    const u16 *present_elems,
 			    struct ieee80211_mgd_assoc_data *assoc_data);
 
+/*
+ * Get the AP HT and VHT data that some of our association request elements
+ * use. Do this only after conn.mode is set from the AP capabilities. Before
+ * that, for example if user space did the authentication, conn.mode can show
+ * HT or VHT for an AP that does not have these elements. If the AP does not
+ * have the element, use zero values. This makes sure that we do not use
+ * capabilities that the AP did not show.
+ */
+static u8 ieee80211_get_ap_ht_param(struct cfg80211_bss *cbss)
+{
+	const struct element *elem;
+	u8 ap_ht_param = 0;
+
+	rcu_read_lock();
+	elem = ieee80211_bss_get_elem(cbss, WLAN_EID_HT_OPERATION);
+	if (elem && elem->datalen >= sizeof(struct ieee80211_ht_operation))
+		ap_ht_param =
+			((struct ieee80211_ht_operation *)elem->data)->ht_param;
+	rcu_read_unlock();
+
+	return ap_ht_param;
+}
+
+static void ieee80211_get_ap_vht_cap(struct cfg80211_bss *cbss,
+				     struct ieee80211_vht_cap *ap_vht_cap)
+{
+	const struct element *elem;
+
+	memset(ap_vht_cap, 0, sizeof(*ap_vht_cap));
+
+	rcu_read_lock();
+	elem = ieee80211_bss_get_elem(cbss, WLAN_EID_VHT_CAPABILITY);
+	if (elem && elem->datalen >= sizeof(struct ieee80211_vht_cap))
+		memcpy(ap_vht_cap, elem->data, sizeof(*ap_vht_cap));
+	rcu_read_unlock();
+}
+
 static size_t
 ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb, u16 *capab,
@@ -2262,7 +2299,7 @@ ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
 	if (sband->band != NL80211_BAND_6GHZ &&
 	    assoc_data->link[link_id].conn.mode >= IEEE80211_CONN_MODE_HT) {
 		ieee80211_add_ht_ie(sdata, skb,
-				    assoc_data->link[link_id].ap_ht_param,
+				    ieee80211_get_ap_ht_param(cbss),
 				    sband, chan, smps_mode,
 				    &assoc_data->link[link_id].conn);
 		ADD_PRESENT_ELEM(WLAN_EID_HT_CAPABILITY);
@@ -2276,10 +2313,13 @@ ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
 	if (sband->band != NL80211_BAND_6GHZ &&
 	    assoc_data->link[link_id].conn.mode >= IEEE80211_CONN_MODE_VHT &&
 	    sband->vht_cap.vht_supported) {
-		bool mu_mimo_owner =
-			ieee80211_add_vht_ie(sdata, skb, sband,
-					     &assoc_data->link[link_id].ap_vht_cap,
-					     &assoc_data->link[link_id].conn);
+		struct ieee80211_vht_cap ap_vht_cap;
+		bool mu_mimo_owner;
+
+		ieee80211_get_ap_vht_cap(cbss, &ap_vht_cap);
+		mu_mimo_owner = ieee80211_add_vht_ie(sdata, skb, sband,
+						     &ap_vht_cap,
+						     &assoc_data->link[link_id].conn);
 
 		if (link)
 			link->conf->mu_mimo_owner = mu_mimo_owner;
@@ -10224,67 +10264,6 @@ ieee80211_setup_assoc_link(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
-static int
-ieee80211_mgd_get_ap_ht_vht_capa(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_mgd_assoc_data *assoc_data,
-				 int link_id)
-{
-	struct cfg80211_bss *cbss = assoc_data->link[link_id].bss;
-	enum nl80211_band band = cbss->channel->band;
-	struct ieee80211_supported_band *sband;
-	const struct element *elem;
-	int err;
-
-	/* neither HT nor VHT elements used on 6 GHz */
-	if (band == NL80211_BAND_6GHZ)
-		return 0;
-
-	if (assoc_data->link[link_id].conn.mode < IEEE80211_CONN_MODE_HT)
-		return 0;
-
-	rcu_read_lock();
-	elem = ieee80211_bss_get_elem(cbss, WLAN_EID_HT_OPERATION);
-	if (!elem || elem->datalen < sizeof(struct ieee80211_ht_operation)) {
-		mlme_link_id_dbg(sdata, link_id, "no HT operation on BSS %pM\n",
-				 cbss->bssid);
-		err = -EINVAL;
-		goto out_rcu;
-	}
-	assoc_data->link[link_id].ap_ht_param =
-		((struct ieee80211_ht_operation *)(elem->data))->ht_param;
-	rcu_read_unlock();
-
-	if (assoc_data->link[link_id].conn.mode < IEEE80211_CONN_MODE_VHT)
-		return 0;
-
-	/* some drivers want to support VHT on 2.4 GHz even */
-	sband = sdata->local->hw.wiphy->bands[band];
-	if (!sband->vht_cap.vht_supported)
-		return 0;
-
-	rcu_read_lock();
-	elem = ieee80211_bss_get_elem(cbss, WLAN_EID_VHT_CAPABILITY);
-	/* but even then accept it not being present on the AP */
-	if (!elem && band == NL80211_BAND_2GHZ) {
-		err = 0;
-		goto out_rcu;
-	}
-	if (!elem || elem->datalen < sizeof(struct ieee80211_vht_cap)) {
-		mlme_link_id_dbg(sdata, link_id, "no VHT capa on BSS %pM\n",
-				 cbss->bssid);
-		err = -EINVAL;
-		goto out_rcu;
-	}
-	memcpy(&assoc_data->link[link_id].ap_vht_cap, elem->data,
-	       sizeof(struct ieee80211_vht_cap));
-	rcu_read_unlock();
-
-	return 0;
-out_rcu:
-	rcu_read_unlock();
-	return err;
-}
-
 static bool
 ieee80211_mgd_assoc_bss_has_mld_ext_capa_ops(struct cfg80211_assoc_request *req)
 {
@@ -10488,14 +10467,6 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 				req->links[i].error = err;
 				goto err_free;
 			}
-
-			err = ieee80211_mgd_get_ap_ht_vht_capa(sdata,
-							       assoc_data, i);
-			if (err) {
-				err = -EINVAL;
-				req->links[i].error = err;
-				goto err_free;
-			}
 		}
 
 		assoc_data->wmm = true;
@@ -10531,10 +10502,6 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 						       &assoc_data->link[0].conn);
 
 		uapsd_supported = bss->uapsd_supported;
-
-		err = ieee80211_mgd_get_ap_ht_vht_capa(sdata, assoc_data, 0);
-		if (err)
-			goto err_free;
 	}
 
 	assoc_data->spp_amsdu = req->flags & ASSOC_REQ_SPP_AMSDU;
@@ -11477,13 +11444,6 @@ int ieee80211_mgd_assoc_ml_reconf(struct ieee80211_sub_if_data *sdata,
 				err = -EINVAL;
 				goto err_free;
 			}
-
-			err = ieee80211_mgd_get_ap_ht_vht_capa(sdata, data,
-							       link_id);
-			if (err) {
-				err = -EINVAL;
-				goto err_free;
-			}
 		}
 
 		/* Require U-APSD support if we enabled it */

base-commit: 045958acaa75205b31578cb22c4345e28dd2e4bf
-- 
2.54.0

