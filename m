Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651951;
	b=Vp2TfnRefLr8UpSBT82c4o2sqruQvxr+YwFxHnsGHSuELqVSeXh2+QHApejFYKsNP1Pi
	 smlwVEE37i+WfG57hCHSp+Qnj2LoTT7mh4y+0aIIU1as6cXXTWtoAigFIa/KiEFxjnRaZ
	 CeOsHjN1Pap8IIumlyT0g2eIG7e/M48/fjMLxHRlNXF5bDU/aTOOdnd4O6Sr9XgLuSZWV
	 UjxtXDJNBFVbA76QRllWN+5+jIpAhgW2TVnG6ZX/8TRK9mI916D2BncyNZNE7zlZMsoS7
	 7pLwIlMXjrSex6XdSx5sbC71nlgNblG1jibngLz8IyuU2LGOKMe74wfIFKctKWtpeZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651951;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7AjMDsEJuV9WhfKAuTOTNA7suHpt6+xXadogN7XqyGA=;
	b=GCJSYpCIhb6Fn5VpNdYdCVmlpy+JcjU5lveJNQ5u4qtKY6YW1s7pHGzH+KayWlsOZFp4
	 xj4BXbD/2A4z4Ipa9oVh2TmGWKLQQ3i5RAuXDhUuGhU6j7/L617kbZqfg5Y5pZfORagKG
	 W1tDs8wTtM7NtKiUMdPCkBpgEaDUA1UT0lndfEBm8JURsvelc9n0CcjWA4pLQJ0BOs8FW
	 Txj6Xbx5ZNICoWiNMlwtJfeLrh24ufbCFwNghqEi9qgj4NOzT8dKppYTZF7+Srq9PVhmr
	 PIPLYAmARo2Yiw0lg7eOn8MJ5Vkn2OH2N3sMxXWr/DbNOb9TSp47fiMR5rL2F96Q+Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=HlWsQ7GC;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46DF606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=HlWsQ7GC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7AjMDsEJuV9WhfKAuTOTNA7suHpt6+xXadogN7XqyGA=;
	t=1793651950; x=1794861550; b=HlWsQ7GCG7vu0z+A1GNjWY7DgJZ3idcJrte2HH+E4OALWjt
	aYLRyH+n5YRHwRx/JktAOcpGpaHHjVOc9ZrFS/djQzf5+mmyRS1RWawJCB97TRr4n+UXCqgsu7jil
	QTj3p38M40peTHx8kZdbEZ0Xt7kcD9NUi0DslICJSSvWhhSfJX6ZKqVZSrhSKbO8pc50KGmt+xB9f
	QDfYa7w7ynIbNxkF2rTglMKphbXa8FfAkmL86WxsrupZaWTK+Pzy0GxusAxpMwd5FFaLOZCdHJgAy
	Rfb8ozogVBlRsvPyYeiRa6jihFVgvVkb0e68in56nDlm40++y8rHvmLPSpoknPMA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyo7-00000001vzr-3eaG;
	Mon, 02 Nov 2026 21:39:08 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 30/30] wifi: mac80211: keep fast-xmit for sleeping STAs
Date: Mon,  2 Nov 2026 21:23:20 +0100
Message-ID: <20261102203831.1058362-62-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
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

Fast-xmit is disabled while a station is sleeping
since we need to handle the header etc., but now
with all the previous work, this isn't needed any
more.

Remove the associated code, which now also enables
sending an A-MSDU as a poll response.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       |  2 --
 net/mac80211/sta_info.c |  4 ----
 net/mac80211/status.c   |  1 -
 net/mac80211/tx.c       | 14 ++------------
 4 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5f31326a84b1..7f8bbcfc2c9f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1682,8 +1682,6 @@ static void sta_ps_start(struct sta_info *sta)
 	ps_dbg(sdata, "STA %pM aid %d enters power save mode\n",
 	       sta->sta.addr, sta->sta.aid);
 
-	ieee80211_clear_fast_xmit(sta);
-
 	for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
 		struct ieee80211_txq *txq = sta->sta.txq[tid];
 		struct txq_info *txqi;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8e044ff5f716..7a6d428b6a22 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1936,8 +1936,6 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	ps_dbg(sdata,
 	       "STA %pM aid %d sending %d management frames since STA woke up\n",
 	       sta->sta.addr, sta->sta.aid, buffered);
-
-	ieee80211_check_fast_xmit(sta);
 }
 
 static void ieee80211_send_null_response(struct sta_info *sta, int tid,
@@ -2429,7 +2427,6 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 
 	if (block) {
 		set_sta_flag(sta, WLAN_STA_PS_DRIVER);
-		ieee80211_clear_fast_xmit(sta);
 		return;
 	}
 
@@ -2447,7 +2444,6 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 		ieee80211_queue_work(hw, &sta->drv_deliver_wk);
 	} else {
 		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
-		ieee80211_check_fast_xmit(sta);
 	}
 }
 EXPORT_SYMBOL(ieee80211_sta_block_awake);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9b8e0b7e173b..94e224038974 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -118,7 +118,6 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	 * when it wakes up for the next time.
 	 */
 	set_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT);
-	ieee80211_clear_fast_xmit(sta);
 
 	/*
 	 * This code races in the following way:
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8f528ab7ebf3..820cfe53b29e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1331,10 +1331,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 
 	if (!tx->sta)
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
-	else if (test_and_clear_sta_flag(tx->sta, WLAN_STA_CLEAR_PS_FILT)) {
+	else if (test_and_clear_sta_flag(tx->sta, WLAN_STA_CLEAR_PS_FILT))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
-		ieee80211_check_fast_xmit(tx->sta);
-	}
 
 	info->flags |= IEEE80211_TX_CTL_FIRST_FRAGMENT;
 
@@ -3318,12 +3316,6 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED) || !sta->uploaded)
 		goto out;
 
-	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
-	    test_sta_flag(sta, WLAN_STA_PS_DELIVER) ||
-	    test_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT))
-		goto out;
-
 	if (sdata->noack_map)
 		goto out;
 
@@ -4403,10 +4395,8 @@ static struct sk_buff *__ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		 * is first since it's very unlikely.
 		 */
 		if (unlikely(test_sta_flag(tx.sta, WLAN_STA_CLEAR_PS_FILT)) &&
-		    test_and_clear_sta_flag(tx.sta, WLAN_STA_CLEAR_PS_FILT)) {
+		    test_and_clear_sta_flag(tx.sta, WLAN_STA_CLEAR_PS_FILT))
 			info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
-			ieee80211_check_fast_xmit(tx.sta);
-		}
 	}
 
 	/*
-- 
2.56.0

