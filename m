Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EE23B47F5
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791389847; cv=none; b=OVD9IcHKAqBhfhpGChyuyiwECLukvxZfYJugVYRcWhhkHQmaV/Sh9Gx5kRaVWXu9V7MHCsw2+wEls+/38lbgkzoBUH3ojGztBqK6QyTmjTYfPGolC934T2Mc099CoR01rDJye43Jy9ldPf7Ry/x/BdJ0jDaDoAxG8JrSLBETZE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791389847; c=relaxed/simple;
	bh=WHKroD7dUGdwvfgsrlVmP73MnJQsIo9u1DqdalxEU/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+X6mSzRGNlsac4wYG+8ooQoOLPMxJjjbPiaN1UefC2H3k7t6DBYb85jJ/sF8KfCGJRWv2EMHIz6+szBDguEmJ4PYEA9y1USTn2mFafd6CFUUCAh8GKDhtDF7X1n6OUXXj5vIhiSKrQduGpbMbv30VBLC+tIdXKsSfQg5n3Ek10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UOeftahg; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOeftahg"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a180fbeef5so8672835e9.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 09:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791389844; x=1791994644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=umgdDYKjH1ujmMwYt0DrEX+xooXwWq3eYjix5EPxwqM=;
        b=UOeftahgln2bI2Fjw0DeofSYI4y+8iNEmy63JIVKEF6nENoH++bxEdZw6i0+vay9Wf
         BFUHG8by3Ym3y/49pc5rARouEG1n85zeqxNOY2MERnV3P7w8SJSOcbg+S9yYs2WDGg3L
         4HTrFGj8y4e0Py3S7fdBOnaQIT5bF2BIsSqamIMQwPU0sSJ5ZBI8M5cXYDs9iD9Wx4Fh
         Y7lNKbj0j2LlgrC7QtdCpnyiUjg5C+ySj9w2VqTMTaOoCZUr8q/otC2Fw2DMA02tnhmy
         n8AeFjv0EtYK9PrW9JZUPpGlpHmgzaNnRI3BZ+/CNGeZ3+eJo/SgxThdrq5TSfvEz1y0
         cTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791389844; x=1791994644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=umgdDYKjH1ujmMwYt0DrEX+xooXwWq3eYjix5EPxwqM=;
        b=i4TEjn48M6NaBi2aYMGthaqx6G0S03X9MuENhX0S4gWRPWSQrxpMSu8HTqUvYPlaG+
         2qc5xCPd3I08sZD6O3CxFGJifHof8OzQckLlpP62t+ze4VTuCrChZKLjoY16rgEIlCqZ
         Mwxw0P2H6NbLKjyyGHgZuK9TSPLJgIkrBRAN/etBzMoi0qVoYV2gIQH02BB0nnqClXsl
         E01uL05Ex9zhFQhTlTCShwtJDdbfiN1GxdhrUx+JMminddrD2wWokftBmkymbRcYecRF
         tkRGnnYfGMvUnsl2ZVTiDLNNi0MGZE/fCAd7HPCZOOE0OAzdtflh3qO17HDCXFHdMT0d
         QE1A==
X-Forwarded-Encrypted: i=1; AKwUvBwkxXgjMnx9xMDg1vFo+ajhiyEtINkm9BbfIfMbtTodEtDTOOc6As7SHR8wM0MM8IUeYgsFx/R3NWHTSfrg1w==@vger.kernel.org
X-Gm-Message-State: AFuF++lbjtaSNqzRYz7/mn+a13ICQZDMv6jqS7RsgOFbE54766s0XFwq
	y/dHVBI2S56t0Hb48SDWEHxjr2QtlmEyl+S95+HdSZok7cHboI07wEg=
X-Gm-Gg: AYBFou1VSEQOYpsNhgz9VjBPXcd/z8bC1mPxNz8jeJoRkXKHHyTLCFl/N0Zea0djn4t
	5W1ZxHj8oKHc/EjLgP7gkKbZCy3HFGoybIFOEQQUMZs0jGib26fLopjoiO1WG7yUbjXLVP6kUe0
	dZD12RyEdBWiJU81X6YEh2pVvXYGVBhLr6xIPPRzgUoILx9ET+xi7WP+3/arcbpRyMVr18DbfTd
	dRKeCdNRvi/JIV3ZQaLGZlEcKgWtNm1BW+sbVmBp/Uc75ylLhmWoiUmAFPWtK2fi5VdOaWZkxfr
	+3oCycb+Lcd+adBaA9oVeHMGD0hdfLCxSfz2dyGUFDYbmvL+D/3bYm+85B8whZB3BWEX/SspAxM
	vZGBwEr+QQow0o8xZqvqKxPPyrimpCl7XBEN2p8wLltazL+dW0nsetAQ4BEBItj/2XoeGPeaH0q
	XSmKdMk2PskQeh5eKS5PnELYvoowm4AiF8Me8vyFz5
X-Received: by 2002:a05:600c:154a:b0:49c:cee0:e7c1 with SMTP id 5b1f17b1804b1-4a18043b5fcmr44495025e9.16.1791389843979;
        Wed, 07 Oct 2026 09:17:23 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843aac98sm2685295e9.9.2026.10.07.09.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 09:17:23 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@kernel.org>,
	Po-Hao Huang <phhuang@realtek.com>,
	Chin-Yen Lee <timlee@realtek.com>,
	linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless v2 1/2] wifi: rtw89: fix IE length passed to cfg80211_find_ie() in 6 GHz probe
Date: Wed,  7 Oct 2026 16:17:20 +0000
Message-ID: <20261007161721.261452-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007161721.261452-1-tristmd@gmail.com>
References: <20261007161721.261452-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

rtw89_core_cancel_6ghz_probe_tx() computes a pointer to the IE area
from a beacon/probe response frame:

    ies = mgmt->u.beacon.variable;

but then passes skb->len as the IE data length to cfg80211_find_ie().
Since skb->len covers the entire frame including the 36-byte management
header and fixed fields, cfg80211_find_ie() may read up to 36 bytes
past the end of the actual IE data.

Fix by computing the correct IE data length as skb->len minus the
header offset, and validating the minimum frame length before parsing.

Fixes: c6aa9a9c4725 ("wifi: rtw89: add RNR support for 6 GHz scan")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 397ebbfcac09a..6e000cdbb0219 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2571,6 +2571,7 @@ static void rtw89_core_cancel_6ghz_probe_tx(struct rtw89_dev *rtwdev,
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 	struct list_head *pkt_list = rtwdev->scan_info.pkt_list;
 	struct rtw89_pktofld_info *info;
+	size_t hdr_len = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	const u8 *ies = mgmt->u.beacon.variable, *ssid_ie;
 	bool queue_work = false;
 
@@ -2582,7 +2583,10 @@ static void rtw89_core_cancel_6ghz_probe_tx(struct rtw89_dev *rtwdev,
 		return;
 	}
 
-	ssid_ie = cfg80211_find_ie(WLAN_EID_SSID, ies, skb->len);
+	if (skb->len < hdr_len)
+		return;
+
+	ssid_ie = cfg80211_find_ie(WLAN_EID_SSID, ies, skb->len - hdr_len);
 
 	list_for_each_entry(info, &pkt_list[NL80211_BAND_6GHZ], list) {
 		if (ether_addr_equal(info->bssid, mgmt->bssid)) {
-- 
2.47.3

