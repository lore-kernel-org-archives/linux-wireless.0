Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197207;
	b=gy7ZoB9lDEXiBmJc+i/3LM5IUyCcSO6gtD4W10bVH3B8mwbHTsoXuEsjFgOM2UzuO7S9
	 RsDWufCu7dtPhP2CY+vrQ8Bg5Bb3KX2MrFtoyb2imysqiRBbMiEjz7OZR/wJZQhAL/kzv
	 5XYXtQfbZ76X7vK+3kc5vVW6ldP0iPCUEWwlgbaX8iGUD829JJIsk8hiuSHnx4O82Zu48
	 qWsF7ZDAdZ89KhoXZ8jEPFZngjEQkklw6QC8COKrZNR+iJUDy+025eE9+tJTT+VAI21p9
	 2HLH2R5sIPj7RnoJ6Adk/sSder+n80bg5rgdQ7A9IsWEMKWndpJInvDZ/y6ZFpFCmgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197207;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w0FuKmqjAAxc2G36lErL/3fM5DHNQeeC+jY9FSXhzZU=;
	b=fyO8pDMYBQ4/m9vaS+YsqxQNMZZRYk8RE6m8VcW93hcN6E5R17Yju3LPYcQE48X7H56Y
	 B12h+AGCKWB+UVOELRunIhXD60yfosFtkIlzLit9gTCd1kuresZlJH2tCNoGSgRemJIwc
	 2HkMH30bZH9NqK5+RZw9SalShkuue+/dIVYH6kN2e6lqirJgAAqVkpdrQ2LZs7Tmc4JDl
	 tD/UvSl3CaTsOpRxsnTq5H3osP7i54OEUL8NkQbxSgYZvSsYvQ3kG0tqnNYwEap0jLWfm
	 itk/KJXuq9+MpYT2ps/O7DrOv38gPRw4dq+cPmL+TIkb/se+40Uarculb2HtqVw4vsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yCc+nva5;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729E4606A325
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 729E4606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yCc+nva5
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd3310348d2so978123a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197207; x=1793802007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w0FuKmqjAAxc2G36lErL/3fM5DHNQeeC+jY9FSXhzZU=;
        b=yCc+nva5YiTEVaq1YUYP+cS7RYAm+YZnTgtCkpztxgFAzXPaQCUPS11qNaxU1ZJdDx
         mZQ9zZfEXvr4Oj8rXA413TUukEUjPx8KNgURIik6NBj4r7lfhYwE7X2oKrBL1dFM6cYi
         coLoKkiB3zzWvTHYWNG/AGTvRcm9zq7iMwJtyU2kciUOIE1HYo9HpSbDQvf3bToytnkh
         70LX2PQNSUGFNyYI3283IjlFu4XyOyxCMNMQBhBesmzXgRL/FephHrFIH5eEYuX9D9BE
         8d1nvq+QDrSiJTr4PxFa/4HaC7CUTYIB24uNkh17lrDNwRpBnWeH89F2tXlSLgfUWzeZ
         EiXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197207; x=1793802007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w0FuKmqjAAxc2G36lErL/3fM5DHNQeeC+jY9FSXhzZU=;
        b=0eYb9gMQ6PsOshBkOMoPn1aUWRg4wy4PqREo/LAL9VWO06G8wXgE/wCUgGbaX7XEJr
         vyasjqKdz/A5kvqX6eMjq35Wl9Vy4P53xAWo7oHHDCgFvqHqWFShXDM5oXHyPHzLM4/L
         dqvdo88m4IWcJg5TnKP83dgzBzfi+J1OnOp6QtzYij+SA0mHM9hedP1bT49Ap9m+x6Qo
         LMu1T9Lz2XJmDMTvaBF6gXhufnq2xBMO154ndqVg0rTtSz4IeuGEYGuZxD33DPiHp93P
         HekrWg0yItyuonW8x7K3ITQ3tNcFlkx2WYTrgKn6OgH/5M7G8bLlis7FYnWPhJyNoXis
         LGEw==
X-Forwarded-Encrypted: i=1; AKwUvBzyIJg7q6N3fHet2enlBhyIWKSW7lKxno5i+SJXj9ZSsH0SHwJD+H+HZu9p5/i+TyLwVSZDZKllq/CETxTA8A==@vger.kernel.org
X-Gm-Message-State: AFq9FYLLY0z/iDhJGD1TCsm4EkFjTDE4DcVK2u+ei62j5Q2v9zfpiPWa
	UVUXStwJW1jIhRHhzE1+tejF7LMLC3yllnHtYcfVOXOZnFHPmjoKMf+8
X-Gm-Gg: AYBFou3u0g4NF8Y9vBqSZoTlCmJe3GYXO+LaXfJSjI6WXESCrjOLs2QmEnKWsCKXjwq
	hNWd81LKjyl0a96Jsq/MgSvOiOCD04VvIK+DzRR97dfVNh2Z39iWKX8QfTQr1+4oGVK4U+q8Vts
	28HSum4HZ7nPUUAc/ieSkiBySsIbmkIlS5Iwk4T3I1obsbbF9djWuWCCVPF1VvskQWcup9XfpSU
	0M3mWw6Zf3iDF7ILSY0Dy3RWRYcBDuLcpPlB+aSMbIHJm5+/qH1og4Bd3FgN58FTkXzcA7vulxx
	jjFNau+0vv+TGYXC9A/405fFby7kKyIFuGcR3zwOpS77Qa9B/ZjyJ4IayR2Oas+n1H9cWrefM9r
	9VteueExi5fAllfwVa1NR3VwQOURyVcKmSKKF1HVjkvyMV+dTzYXFIdtIs+8yNzBlETx5+ediZt
	vSzCln3CdbbPWwhb/vNC59/C9wsdyPdXkwYf34kiIU9bpxLsomfzprIpDxmrPN2R0WEo3n+IuvM
	X3WpJ5or44BVynrEwEPF0wTpiDj2TNHdEFlBEfWzNBFdHtWoD/B8u5W23bPgVeGko3sP7wECWqX
	DLDCET+fBJvZykUuhSiNotDHzlXbHFW4oiDYxOPDuTfx5Ey0NTg8qsIf2w3nLK/bsrsi
X-Received: by 2002:a17:90b:5150:b0:3ac:a6a5:5757 with SMTP id 98e67ed59e1d1-3ae5c801c2emr953367a91.11.1793197206400;
        Wed, 28 Oct 2026 07:20:06 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9f286fsm3290141a91.15.2026.10.28.07.19.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:20:06 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Ville Nummela <ville.nummela@kempower.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Marek Vasut <marex@nabladev.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Stefan Hansson <newbyte@postmarketos.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
	Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/3] wifi: rsi: report background scan start failures
Date: Wed, 28 Oct 2026 22:19:26 +0800
Message-ID: <20261028141927.9306-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028141927.9306-1-enderaoelyther@gmail.com>
References: <20261028141927.9306-1-enderaoelyther@gmail.com>
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

rsi_mac80211_hw_scan_start() returns success when a background-scan
command cannot be prepared. The driver never marks the scan active in
that case, so neither cancellation nor the firmware-event path reports
completion and mac80211 keeps the request pending.

Build the probe request before queueing the start parameters, propagate
preparation errors, and clear the saved request before mac80211 frees it.
Successful scans keep the existing firmware command order.

LLM assistance was used to find the bug and review.

Fixes: 7fdcb8e12660 ("rsi: add support for hardware scan offload")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: W=1 module builds with MODPOST passed with CONFIG_RSI_COEX
enabled and disabled. Not reproduced; RS9113/RS9116 hardware was
unavailable.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 14 ++++++++------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 13 ++++++++-----
 drivers/net/wireless/rsi/rsi_mgmt.h         |  3 +--
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 27bfdb6affaf..a2e981e261d6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -237,6 +237,7 @@ static int rsi_mac80211_hw_scan_start(struct ieee80211_hw *hw,
 	struct cfg80211_scan_request *scan_req = &hw_req->req;
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	int ret;
 
 	rsi_dbg(INFO_ZONE, "***** Hardware scan start *****\n");
 	common->mac_ops_resumed = false;
@@ -260,15 +261,16 @@ static int rsi_mac80211_hw_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&common->mutex);
 	common->hwscan = scan_req;
-	if (!rsi_send_bgscan_params(common, RSI_START_BGSCAN)) {
-		if (!rsi_send_bgscan_probe_req(common, vif)) {
-			rsi_dbg(INFO_ZONE, "Background scan started...\n");
-			common->bgscan_en = true;
-		}
+	ret = rsi_start_bgscan(common, vif);
+	if (ret) {
+		common->hwscan = NULL;
+	} else {
+		rsi_dbg(INFO_ZONE, "Background scan started...\n");
+		common->bgscan_en = true;
 	}
 	mutex_unlock(&common->mutex);
 
-	return 0;
+	return ret;
 }
 
 static void rsi_mac80211_cancel_hw_scan(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 9ceb6cba3546..165423313c5f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1862,11 +1862,8 @@ int rsi_send_bgscan_params(struct rsi_common *common, int enable)
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
 
-/* This function sends the probe request to be used by firmware in
- * background scan
- */
-int rsi_send_bgscan_probe_req(struct rsi_common *common,
-			      struct ieee80211_vif *vif)
+/* Send the firmware commands that start a background scan. */
+int rsi_start_bgscan(struct rsi_common *common, struct ieee80211_vif *vif)
 {
 	struct cfg80211_scan_request *scan_req = common->hwscan;
 	struct rsi_bgscan_probe *bgscan;
@@ -1875,6 +1872,7 @@ int rsi_send_bgscan_probe_req(struct rsi_common *common,
 	u16 frame_len = sizeof(*bgscan);
 	size_t ssid_len = 0;
 	u8 *ssid = NULL;
+	int ret;
 
 	rsi_dbg(MGMT_TX_ZONE,
 		"%s: Sending bgscan probe req frame\n", __func__);
@@ -1928,6 +1926,11 @@ int rsi_send_bgscan_probe_req(struct rsi_common *common,
 	skb_put(skb, frame_len + probereq_skb->len);
 
 	dev_kfree_skb(probereq_skb);
+	ret = rsi_send_bgscan_params(common, RSI_START_BGSCAN);
+	if (ret) {
+		dev_kfree_skb(skb);
+		return ret;
+	}
 
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 236b21482f38..6a4907e6bca9 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -753,6 +753,5 @@ int rsi_send_ps_request(struct rsi_hw *adapter, bool enable,
 			struct ieee80211_vif *vif);
 void init_bgscan_params(struct rsi_common *common);
 int rsi_send_bgscan_params(struct rsi_common *common, int enable);
-int rsi_send_bgscan_probe_req(struct rsi_common *common,
-			      struct ieee80211_vif *vif);
+int rsi_start_bgscan(struct rsi_common *common, struct ieee80211_vif *vif);
 #endif
-- 
2.56.0

