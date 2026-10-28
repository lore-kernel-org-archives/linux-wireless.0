Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793162495;
	b=r+tZC9tbnzZT1SE8gTLNr6SXhLQQtnGC9F2THDL6AbiSolPf5WZpR6qj9toQ4rVqyrwA
	 wZbQEYjSkJezRyBz49TsDeJMCjJjLn+fHtJKAPs0HV/UIHBLq/vlUn7OwbfACZ+V46/R7
	 JCWqt3M3zfCwxZIHBIHF+VhkCrMrOnWVcyjGsFbPNWt2+nktl0KmOot63yAKv1i9wMhEd
	 8VS4g4qdufevVxlFWqusMYyLfi94hiMl6a5JhVFKiuPLId7x0E9eogrIO4lOAKOfyH2Zl
	 bnc0qnGQ9F6YC+czKY80lLOyUD6V1tBc4caXnlmYYnVJjVsh5nDC+P7w/WACS+07/iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793162495;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2oz5sHulKG/cmbjPoxzVB6iSV/i/NLI+1E7kfTmkYng=;
	b=385yko9Uo+eUEfiSo8gWRaV62su7ifRipL2ebSsi8wGPC/0ya2jTbYUPLaAIUwEhyWFo
	 HBWoCK35/XnD6PQ10GOCoo1ZL/9q48lMiF+zyxA4t66jpwyZYkFqiBgP8dGQ3kvTZ6z6/
	 CdravLGosz82SFLgVtmGGVAssoLJcHh9t+T+iLNUCw4A8IV4wZ68HfZHrgtJa7aE4/Mu3
	 rb/CktD5mvuTA9CBkcRXavR+n8ZZ2vKjT/Rwciy73XYXmysZOnbnMSHQ6m9+8fltuTB6E
	 NTXwx5Csq5Jz85CwFMJovC5WmsQrNv4OTZEZzHoYIvSBcR0c7+ovQDMb/i/XVg0roEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=H+skV5Vx;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADB6606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 04:41:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1ADB6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=H+skV5Vx
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so405011a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 21:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793162494; x=1793767294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2oz5sHulKG/cmbjPoxzVB6iSV/i/NLI+1E7kfTmkYng=;
        b=H+skV5VxMTgy8wQZPdkYB5QkzsaCtsEZUDU84zYyCDoy7EptknMKQkbktHkKSDpOzq
         Gh/d0NOdW4cgHPZs0QQBoCpqi1mw5UnJKKiUXS260Y+USgcgE9xasaizcK6nvhjng8EA
         JzBT2Czi0WIHMzoR+ITx1xvkDy+HH/ovv9xIUHIVMTO1/pcqW6ZgSD9PG1tEfoC1+fgw
         +H8O0U/5MC6BYD/BOyktQbVGRL3ExOcI3AHapb0DLiqKT3Mg9pf2ONNVpMOh5Gcjgk+T
         m+W9Qy5r5jkGQ9wBxTYVif/a82TozZR/OQdYC5d5+uWRQ22NTIYOWcc2SF0SM3lC+3oi
         Qf5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793162494; x=1793767294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2oz5sHulKG/cmbjPoxzVB6iSV/i/NLI+1E7kfTmkYng=;
        b=w2I1n5+h4zKSl9rSPbwtbq8Nzklh8zqLyqgmjsXgecw+ZR8A7Esp2FH1G2OwbxbupE
         3wkp4Cn3LRY9ItD0kaO8OIJ036rL1HET1LxGFKMqQL4KuaF0nZp/oh+cEskOHcW+9k3z
         28XobmJfvEeQf/IUXBz83beL3MomJFaMRsJ45xb+K76QMi4vT59LvwcmELZ1ab99VqtV
         /zMMBIJVVse9MmDPD+OCtJfPBJBrgGRa6kua0zGaa9sobCjCPpokWD2umh5LT1k8o5pG
         oG8PLTzUxlsk4pm3Lzy1iRmBSp5YtPoa6tZkpY7jG+MRQITuywmbI1087eswUV5U5oVX
         2PXA==
X-Gm-Message-State: AFq9FYK/i+OeBu53tAwAzF5ilJAwuXsVB3oZz6jxo/Hb+KR0YdDKd34V
	KPEL3L4FlsdV2Z3UvWZaUG86eaxEVnQXS78LaOrmEgy3RSpoMLqPTjhXRma7+YhLDCie+RektN0
	UjVUp9RU=
X-Gm-Gg: AYBFou0FOWjZvAv5B+QQSq+KuO7JOLOManMFklbDy0LoRHNUVX/t58gooJdR/Fa0xW+
	HYfqicWEgYIO7c3Axnxd3uMuBhpAOKiK3YFuh44cs2/Gn5jQ2uVHddwVVi5tNo/8AXfmSvpprFt
	KyM6ZDSQzesn4WU+GA5CYW7A2nxgFxF1H3QoERT0RLYHkviASnze/ON/wqTEkFkHSnUARDQtC9L
	C2ldsDx9tL6LrM7l8/d9Oi7HxjqPEWRDkw6YkqIXFJdOn9kB/G0Dq6gQFrKqDvbjUyczzHwxLeE
	w6Fciyj1ZOpVXXJBDD2VqhpeVSLb4RWsWVfWCkEykyyIzsgL3CJ9f5Ghi3+7PGcx7oi30jFA5UX
	tYzJTRVybkXuEHMypw1AjQqBMp0XTykJ4jJePlgJzlt/x+Iz/0AjE7UXXSANFeQc48hbJg/6CA4
	x5SS3/NFUnWuVTbuhmjlwZrIZ3gxGu1KaDXV+2foxPpnIhbhApiQtx9SwxPY47ZuYA8pQ0CCh2s
	CFH9Ednr9jX8Xa3STMvaS/p5QVqMxcIsFtY1olLtjhot63modZ6VFfmPRSjMkoe9pjkUFyTExLZ
	B6/L1TRsOTSjmbXrCl6QT5n2QewQJ5X22u5E24rPioV18ZNDFOrryt78iBXRtN+WGb49gBi5HQP
	GH+NDGC2xc8mVnppomyu0lt5UYn1qLe8Jew==
X-Received: by 2002:a05:6a21:3cc2:b0:3de:b120:bb88 with SMTP id adf61e73a8af0-3e902079ed5mr1002996637.2.1793162494287;
        Tue, 27 Oct 2026 21:41:34 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a6cfc5ccsm630826b3a.40.2026.10.27.21.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 21:41:33 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next 1/2] wifi: mac80211: include freq offset when comparing frequencies
Date: Wed, 28 Oct 2026 15:41:17 +1100
Message-ID: <20261028044118.1422069-2-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028044118.1422069-1-lachlan.hodges@morsemicro.com>
References: <20261028044118.1422069-1-lachlan.hodges@morsemicro.com>
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

The freq offset is not taken into account when comparing the rx status
freq vs the control channel. Use the existing helpers to make sure we
account for the freq offset.

Fixes: 6d531b9af16e ("wifi: mac80211: rework RX packet handling")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 net/mac80211/rx.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ecee9348c70d..8843405c9a0d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -909,7 +909,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 
 		chandef = &sdata->vif.bss_conf.chanreq.oper;
 		if (chandef->chan &&
-		    chandef->chan->center_freq != status->freq)
+		    ieee80211_channel_to_khz(chandef->chan) !=
+		    ieee80211_rx_status_to_khz(status))
 			continue;
 
 		if (ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR) &&
@@ -5333,11 +5334,12 @@ static void __ieee80211_rx_handle_8023(struct ieee80211_hw *hw,
 	dev_kfree_skb(skb);
 }
 
-static bool ieee80211_rx_valid_freq(int freq, struct ieee80211_link_data *link)
+static bool ieee80211_rx_valid_freq(struct ieee80211_rx_status *status,
+				    struct ieee80211_link_data *link)
 {
 	struct ieee80211_chanctx_conf *conf;
 
-	if (!freq || link->sdata->vif.type == NL80211_IFTYPE_NAN ||
+	if (!status->freq || link->sdata->vif.type == NL80211_IFTYPE_NAN ||
 	    link->sdata->vif.type == NL80211_IFTYPE_NAN_DATA)
 		return true;
 
@@ -5345,7 +5347,8 @@ static bool ieee80211_rx_valid_freq(int freq, struct ieee80211_link_data *link)
 	if (!conf || !conf->def.chan)
 		return false;
 
-	return freq == conf->def.chan->center_freq;
+	return ieee80211_rx_status_to_khz(status) ==
+	       ieee80211_channel_to_khz(conf->def.chan);
 }
 
 /*
@@ -5445,7 +5448,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 				continue;
 
 			link = &sta->sdata->deflink;
-			if (!ieee80211_rx_valid_freq(status->freq, link))
+			if (!ieee80211_rx_valid_freq(status, link))
 				continue;
 
 			if (rx_data_pending) {
@@ -5469,7 +5472,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			sdata =	sta->sdata;
 			link = rcu_dereference(sdata->link[link_sta->link_id]);
 
-			if (!ieee80211_rx_valid_freq(status->freq, link))
+			if (!ieee80211_rx_valid_freq(status, link))
 				continue;
 
 			if (rx_data_pending) {
@@ -5539,7 +5542,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		 * RX using the station.
 		 */
 		if (link_sta && link &&
-		    ieee80211_rx_valid_freq(status->freq, link)) {
+		    ieee80211_rx_valid_freq(status, link)) {
 			if (rx_data_pending) {
 				ieee80211_prepare_and_rx_handle(&rx, skb, false);
 				rx_data_pending = false;
-- 
2.43.0

