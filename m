Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8797044606A
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512964; cv=none; b=oorCXLwCIK5rhD8XNQpOuM6vgdVNyn3yXN2zM2sHnbbbnMFoREalPUce2bQfianSelCuxuf2x4Abacrp5TKWNVOMOKFXH9M0+S7A1b3PEwuGmZNHWwbZJ12BeoqpOG169L87fi7Rv8MZy+7feS4D26neIdlBFdwgzh60+J9nKz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512964; c=relaxed/simple;
	bh=dwU1WTkn+14qiJyoN/fcILNJIPDNMbgqt2pyeUSZuEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBswRKi3c/oz5C5rfJGr5LLE9ceYCq9lCEH8MJ7TRAxGgA9qDBWl+1wqu+cpAVWKU7hrTu8lYcTmHpFSJpl4xE3Dqnc7qpIQ6lBCC6zva+fBSWgawLMZwSQ91fvJBISATpzhIFPfQNqslMWgPvr/eXSnoZ/4BfSUAlUZ64SI5Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gcZUy4S+; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gcZUy4S+"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cc8311c6ddso813595ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512960; x=1786117760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ahxcHCC15uBTh1B3etEh/3ZgFZZQjRbxcgGWND2qogs=;
        b=gcZUy4S+URoqjiuXUZVq0nOkKlyDKecqVr0VS07iDwFMPNarXkX5+DPMsAkzHucYt5
         tQVQl6gLJPU8JMDeqQpBhBU4VrX3nj21NZvorgl+QvT85uM8ODyNnTLHx1MPZKOFoqPU
         sXIb9HLXE0z5zAQNk8VEW9M6W98vEM3Gm2wjFu997c/5z5bms4TPkqupzc3CQHoL+Zo0
         n3WAHb/9ypJ0q4vU5opHdWJVuJ6rfEsKA10hY+NEZZCqc+IkCvvfKOTOuB+IUyb4o//l
         Jwf5tRvQDPv+nWOoP/1HvamoHZpWWt0HjUMKlvk1nIILvC3vR2hGyHaw8zQpYfijdB5k
         pVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512960; x=1786117760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ahxcHCC15uBTh1B3etEh/3ZgFZZQjRbxcgGWND2qogs=;
        b=mUBr1ruKqObuXYAf4CpDjVN+OrJhjVD1LqwBx9UgFuVGM20QMmlBu4MGARNWVE5Now
         bHUO6t6I3/6X8VhkW2PzenbkZ8/LSJPHVT3mFM+ZMkqmkgrKCnt6QQQZaLd0LWNX3qZU
         Q0S/lD5iVNuFf760yA9QBkKpZbOtdKwb9hC0Z5tZ7LXm2pL9sVhHBahhGSnRK2RsLWXP
         /tnQ6SigP5SU/HFVqDFVuYWAz5EB9RFWO7T4SPMM5DhTKnqfxpu62efmlG+QMnUtvR0M
         FOm7ZTYfOnjrJdr+v/a0D1bdT7VxzSnOppZLsxy01Wksyu2n/e/D77NaAbp8+aTJLpR9
         lKaA==
X-Gm-Message-State: AOJu0YzDk2TtKCWvBWbyYqm65wqsOTlpsK8D5WoZV23WqCjIDWtCqs6L
	L8jJBwhhZsHBjf1tl3Ou1IK7d8O65oO65OZ8bYDB8myNINAgQGdED75W
X-Gm-Gg: AR+sD10GYgBIfbPKlhulTiHPmdYPpbDLwi48DHmpUjM7a6JQh3mhWYqw6d+Hc3/p+rR
	chdujyU5FmLfBgZoUrDl/Q9z6LCfxLA9oCNimvsxlX6vMLcc1ekRK7IuAq8anygCy0fRjKjws+2
	gV+lS4ANDUUbvrIGTAFdLzhatp1BfdySUmU2WcXo7qsXxOpdP2jBO5QrhwOKWQNF43aFCqZYSr9
	q6Js3yYxlrgaCc3yQAsd8nSw2PQe9NxWizKX3PFYYFo6RsWbK6FzNXwBSxqMXPBNd+VZC/uQb6n
	3lwUOHvzgKfzgJHJCxB3Iaxb3WWEWjIAAMKsNnyVd8TFXDfF/C5ZPjNrE5O7IE2LZN8AR/7NFto
	pXA97mjjz2MW+59NxMjw2ZjhghZufW+g0Lc1PujvQoHPXeCQSjtj0YXPJqRMQ3HpNetor60V7gS
	xpyFhKgGnRk28xKt7MDvK5xp52KV+2WQRUkkd1+2yxhLe+tw7LgCeN8MJolxD/NsP9+RyuTXW3Y
	Po=
X-Received: by 2002:a17:903:38c7:b0:2c9:8287:fd0d with SMTP id d9443c01a7336-2d052438c91mr6467215ad.3.1785512959580;
        Fri, 31 Jul 2026 08:49:19 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm11852510eec.19.2026.07.31.08.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:49:19 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v3 3/8] wifi: brcmfmac: core: populate radiotap header with RSSI
Date: Fri, 31 Jul 2026 15:48:35 +0000
Message-ID: <20260731154901.1822-4-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154901.1822-1-shivesh@example.com>
References: <20260731154901.1822-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

Populates the radiotap header with dbm_antsignal using the rssi
value extracted from the firmware's hardware RX header, fixing
missing signal data in monitor mode captures.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/core.c        | 44 ++++++++++++-------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ec170647800d..eefc437dd055 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -431,45 +431,55 @@ void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 	netif_rx(skb);
 }
 
+struct brcmf_radiotap_info {
+	struct ieee80211_radiotap_header hdr;
+	s8 dbm_antsignal;
+} __packed;
+
 void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR_FMT_RADIOTAP)) {
-		/* Do nothing */
+		/* Firmware already provided a full radiotap header; do nothing */
 	} else if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR_FMT_HW_RX_HDR)) {
 		struct wlc_d11rxhdr *wlc_rxhdr = (struct wlc_d11rxhdr *)skb->data;
-		struct ieee80211_radiotap_header *radiotap;
+		struct brcmf_radiotap_info *rtap;
 		unsigned int offset;
 		u16 RxStatus1;
+		s8 rssi;
 
 		RxStatus1 = le16_to_cpu(wlc_rxhdr->rxhdr.RxStatus1);
+		rssi = wlc_rxhdr->rssi;
 
 		offset = sizeof(struct wlc_d11rxhdr);
-		/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU
-		 * subframes
-		 */
+		/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU subframes */
 		if (RxStatus1 & RXS_PBPRES)
 			offset += 2;
 		offset += D11_PHY_HDR_LEN;
 
 		skb_pull(skb, offset);
 
-		/* TODO: use RX header to fill some radiotap data */
-		radiotap = skb_push(skb, sizeof(*radiotap));
-		memset(radiotap, 0, sizeof(*radiotap));
-		radiotap->it_len = cpu_to_le16(sizeof(*radiotap));
-
-		/* TODO: 4 bytes with receive status? */
-		skb->len -= 4;
+		/* Insert our radiotap header with RSSI data */
+		if (skb_cow_head(skb, sizeof(*rtap)))
+			goto drop;
+		rtap = skb_push(skb, sizeof(*rtap));
+		memset(rtap, 0, sizeof(*rtap));
+		rtap->hdr.it_len = cpu_to_le16(sizeof(*rtap));
+		rtap->hdr.it_present = cpu_to_le32(1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
+		rtap->dbm_antsignal = rssi;
+
+		/* Strip the 4-byte receive status / FCS tail */
+		skb_trim(skb, skb->len - 4);
 	} else {
 		struct ieee80211_radiotap_header *radiotap;
 
-		/* TODO: use RX status to fill some radiotap data */
+		if (skb_cow_head(skb, sizeof(*radiotap)))
+			goto drop;
 		radiotap = skb_push(skb, sizeof(*radiotap));
 		memset(radiotap, 0, sizeof(*radiotap));
 		radiotap->it_len = cpu_to_le16(sizeof(*radiotap));
 
-		/* TODO: 4 bytes with receive status? */
-		skb->len -= 4;
+		/* Strip the 4-byte receive status / FCS tail */
+		skb_trim(skb, skb->len - 4);
 	}
 
 	skb->dev = ifp->ndev;
@@ -478,6 +488,10 @@ void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 	skb->protocol = htons(ETH_P_802_2);
 
 	brcmf_netif_rx(ifp, skb);
+	return;
+
+drop:
+	brcmu_pkt_buf_free_skb(skb);
 }
 
 static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
-- 
2.53.0

