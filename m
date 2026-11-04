Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828573;
	b=oqxuqrDV8+VTn4WUgtJjWJM9H3Wf1pr7rjXNIlbe/jnA9bJDif5DGSrZZItInqOVMTuZ
	 8cOt7LKSwXgCtJyYqhlQNGvMql8yVgR6/m0jKsvZEiMh6VbCtoKTNuL8Oty2wz4txUsbF
	 92GOfgwecqEI2gH1C+Pj0l3+8hVNogda9iWrrLgONTL2zbGJQ4ovi85NHgRxBVj+UGKkX
	 4jx7fmeFVdueSocsDvmkmHax4Fp6Znlk3llhdf3VQOsxoyTX6FSw/7GWZ6EwhK3J1BeRZ
	 Iaa73yEaeCaDIg8kljg/SfwbIuvsFX/qBsO8cwCpx3RYwRHtOw343oh8hv7/PFahn9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828573;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Content-Language:To:Cc:From:Subject:
	 Content-Type:Content-Transfer-Encoding;
	bh=HPzHB/dtrJsMY9VojaEjPnmFQ6c2G5pM0qhP1qv18Xo=;
	b=rISpJsmr8zwikpc92jYtjSBm29VNSd27zF/UyTfIxxYtd+4tDvCaQPASZYOESoVhhr+U
	 TOqgXUwrIDbeuI9lE7mvGAPwDJ31uci6pFLCalDkVyzm8Y+dxuHkQXSLeJXfhy0ZvDNL/
	 xEx0S0Ib2RI+cBX187hTEOndFmcp+SVGCVuFxP3WHaAFVlhpxxXlQSYIhpxse/FWKGYTS
	 l8oblIrmbvKAJZoPd4x9gGbNjQN0So0Dc6ChP5AqQsG+UcrOwvEqPplrIwjMxyEHmgzRD
	 wIC19Go/l/zUii2M+8d8Ten67MfksEQFYiBdbfl0TR2Gr+JBp53QLUujRs30E21lyEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RJBi1jx7;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BF9606A331
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 21:42:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76BF9606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RJBi1jx7
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so432655e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 13:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793828572; x=1794433372; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HPzHB/dtrJsMY9VojaEjPnmFQ6c2G5pM0qhP1qv18Xo=;
        b=RJBi1jx7/wrC66yF2tBxbba97Q36jRjEygz9/V4qM0PFuzbcQvwMvTk8xpAx6oKGq+
         qnqTQTxAbPV+3ICHG2jQOeeYkzAeQRWyHeQ+u27ldzV+iimbjVofrWCluhlzHuhndl8d
         a5nHB4wIz8Sotd5VDbudQBxp9wlaBcXAyjCm+nGiW3BbAmcLus1vtOcrY7RE2g/7FDJi
         c8KRGWyTI+J8xAC7ua5QPAHoLfBeyuDx+QkfdXDnff8ZTiKch15+GIXKzdU6nkxyOjTl
         Ww1bP63P7zyKaqPr5cJszrWNoetWBu4S3hoxYwCkgMBGXOObx0MDHFwsXrIh1s2gpCPv
         Ilcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793828572; x=1794433372;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HPzHB/dtrJsMY9VojaEjPnmFQ6c2G5pM0qhP1qv18Xo=;
        b=F+eu4OzjBOnTLRGCk5/gNF8kOVL1Cm7vM2xspeS5E0YsdyiQoiYrgDyPj3l729wpPb
         flyiZzIIIsSnMZcd0LuwYeRFEirhVs1TAUrONZdAQ3Al6wPWzaMbGWq1pWcGEtbm2w25
         m9GdoH7tdGS1RlSkmE5VRbMGtA4tdU74ABY/zwJkAbLC9lVIMs72Gk4fFCxdfb3p/XQg
         sL+x8aTNjVSlvb6FD5V8PnemumgX9Iz/5Yk90/LOZhdyrIIh40Y07DS3w17AzJzX7MA1
         bGUsH4CWxgb3LYqzu6FOhoIPq2b5IQKUQL9An8Ep5Kz2f4r/DW1GsPax8RgRgMO9NUbd
         PEYA==
X-Gm-Message-State: APuU4Z/Lnc6lTY4f5XJqMMdNdTXlc2pw+IVM6MvKo8Zedty1ih4Kp9Qt
	rUyIP7GTyTTBYR+BRhj2CefA4+iq8B6BgRAq2NDbLXM8esUIpaHWyePku4iil7zi
X-Gm-Gg: AYBFou0YAB/XvCiURuuhNTtksbPWSO1PFqwhzTmXBO+5r1KgnqL52QeOce4Z1/9UzPO
	QAwCKmRSBejxKLwz9F66KXF35367SSxgr7WmIJ05ksTAjJphSVNgqIAeeKxCrQ70DqBkjx7tSVG
	tB8SidkEgoOuPvEt7mmrbHoOAgct8vtUB9ZulWOj7w+Oy9RmCtSmfeguUEq4lIuiCrejPeucs18
	4Xh/g2gZAwh4yE9WSYlvIHP8PdTHmD6yL1swtU4dPrM9qMkvofnKnX9AEEYh2W6h9HvKCdODtbq
	93b7Xdxrd5AbONz05sHFwnzgMx33RaTYSu3UyYc6Z0mNU0P92bfUdE/WQltvfZFkTq1AyrATo+d
	gszgwlhjmF3r4lGMOZOR7fES2CW1FVKVEjrtTkBgPDBTIZ2jmT1ruyPZp1I8AIcul44PyYepAqs
	Azuj68tO1ijKsi+qYiJVoaP1D1AMnhSBCU40zJQDGYS7/PBJoHa4BgNuquwhGJbW/YwuhLEwy5H
	EDGPv8KIY4+5BjMl2b1jYgsq96z2TYH47QSWE3UFoInSFpAyj8BJnjrNrQoPakOCLC5pkxNIiyN
	fdmpHzd6TyOwqnVLnJnlRGZftSJuyVhqm18=
X-Received: by 2002:a05:600d:82e2:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4b55d7d7a2amr11134305e9.10.1793828571681;
        Wed, 04 Nov 2026 13:42:51 -0800 (PST)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b4104d600fsm79563535e9.0.2026.11.04.13.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 13:42:49 -0800 (PST)
Message-ID: <428324ed-59e2-4c7b-ac97-e3e431a17788@gmail.com>
Date: Wed, 4 Nov 2026 23:42:47 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: rtw89: Did a8188bb7644f change the behaviour for MLO?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

a8188bb7644f ("wifi: mac80211: change public RX API to use link stations")
does this:

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 397ebbfcac09af..454d876aeb8861 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3073,10 +3073,8 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 	struct rtw89_vif *rtwvif = vif_to_rtwvif(vif);
 	struct rtw89_rx_desc_info *desc_info = iter_data->desc_info;
 	struct sk_buff *skb = iter_data->skb;
-	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct rtw89_rx_phy_ppdu *phy_ppdu = iter_data->phy_ppdu;
-	bool is_mld = ieee80211_vif_is_mld(vif);
 	struct ieee80211_bss_conf *bss_conf;
 	struct rtw89_vif_link *rtwvif_link;
 	const u8 *bssid = iter_data->bssid;
@@ -3110,11 +3108,6 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 	if (!ether_addr_equal(target_bssid, bssid))
 		goto out;
 
-	if (is_mld) {
-		rx_status->link_valid = true;
-		rx_status->link_id = rtwvif_link->link_id;
-	}
-
 	bb = rtw89_get_bb_ctx(rtwdev, rtwvif_link->phy_idx);
 	pkt_stat = &bb->cur_pkt_stat;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7bb4618065b672..cba7cdf61ce8a5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5389,14 +5389,18 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw);
  * mixed for a single hardware. Must not run concurrently with
  * ieee80211_tx_status_skb() or ieee80211_tx_status_ni().
  *
+ * For data frames, when hardware has done address translation, a link station
+ * has to be provided and the frequency information may be skipped.
+ *
  * This function must be called with BHs disabled and RCU read lock
  *
  * @hw: the hardware this frame came in on
- * @sta: the station the frame was received from, or %NULL
+ * @link_sta: the link station the data frame was received from, or %NULL
  * @skb: the buffer to receive, owned by mac80211 after this call
  * @list: the destination list
  */
-void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+void ieee80211_rx_list(struct ieee80211_hw *hw,
+		       struct ieee80211_link_sta *link_sta,
 		       struct sk_buff *skb, struct list_head *list);
 
 /**
@@ -5414,14 +5418,18 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
  * mixed for a single hardware. Must not run concurrently with
  * ieee80211_tx_status_skb() or ieee80211_tx_status_ni().
  *
+ * For data frames, when hardware has done address translation, a link station
+ * has to be provided and the frequency information may be skipped.
+ *
  * This function must be called with BHs disabled.
  *
  * @hw: the hardware this frame came in on
- * @sta: the station the frame was received from, or %NULL
+ * @link_sta: the link station the data frame was received from, or %NULL
  * @skb: the buffer to receive, owned by mac80211 after this call
  * @napi: the NAPI context
  */
-void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+void ieee80211_rx_napi(struct ieee80211_hw *hw,
+		       struct ieee80211_link_sta *link_sta,
 		       struct sk_buff *skb, struct napi_struct *napi);
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 31dc6f83781b1d..0ddd0b8ea12a05 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5556,7 +5556,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
  * This is the receive path handler. It is called by a low level driver when an
  * 802.11 MPDU is received from the hardware.
  */
-void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
+void ieee80211_rx_list(struct ieee80211_hw *hw,
+		       struct ieee80211_link_sta *link_pubsta,
 		       struct sk_buff *skb, struct list_head *list)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -5564,6 +5565,7 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_sta *pubsta;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -5694,8 +5696,15 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 		}
 	}
 
-	if (WARN_ON_ONCE(status->link_id >= IEEE80211_LINK_UNSPECIFIED))
-		goto drop;
+	/* FIXME: Emulate the old driver behaviour for now */
+	if (link_pubsta) {
+		status->link_valid = 1;
+		status->link_id = link_pubsta->link_id;
+		pubsta = link_pubsta->sta;
+	} else {
+		status->link_valid = 0;
+		pubsta = NULL;
+	}
 
 	status->rx_flags = 0;
 
@@ -5727,7 +5736,8 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 }
 EXPORT_SYMBOL(ieee80211_rx_list);
 
-void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
+void ieee80211_rx_napi(struct ieee80211_hw *hw,
+		       struct ieee80211_link_sta *link_pubsta,
 		       struct sk_buff *skb, struct napi_struct *napi)
 {
 	struct sk_buff *tmp;
@@ -5740,7 +5750,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	 * receive processing
 	 */
 	rcu_read_lock();
-	ieee80211_rx_list(hw, pubsta, skb, &list);
+	ieee80211_rx_list(hw, link_pubsta, skb, &list);
 	rcu_read_unlock();
 
 	if (!napi) {

rtw89_core_rx_to_mac80211() calls ieee80211_rx_napi() with link_sta = NULL,
so it's not getting the emulated old behaviour in ieee80211_rx_list().

Is this something that needs fixing?
