Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38A7472F68
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 19:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785266778; cv=none; b=VsJIAwBxC9bAdFpeakqKZupygVt6tQ9CZDdO/a2V0duwZIS1X/0a1bSWhMw8tHIY/zU+Lnz6yL3wPlh9bEJMBnk2kBbK0bErs4bXax1lIxP4Pnsvy1oJDLc8jVuFSSUuHjbzJRph86mrHiIz3ffOnOA+Ti54K9kx5hsQXnCXL68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785266778; c=relaxed/simple;
	bh=EcHGE4bv3/8f684uJyKg5YK5taQ5B8iQcN0YfquQ28c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hi78bAHd4/4tL8quFRMVW94JqZHNqXpIr8fopn97MddCuHvKxK4CQMjmAWu10X86ssRTUber8cGDXOWQwGrbpuEvnUPMZdjXWsdJGp8ufmzk2Ad0zbaV9xKIFWNyb8RE1OIq4WWZqK3OGLABL1peWEUK63NbmmbCT1/MnhtdAlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/OCuWfl; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/OCuWfl"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5bfaa014978so63645e0c.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 12:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785266775; x=1785871575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ePC1Y0ne7UyI/z8ccYsuTaBWGOHMZQF21As30zRm9nQ=;
        b=h/OCuWflAK4dOqPk2+VxB04I4c5BpKVOcK0dHpuwQFXJMhs6gEIre2d+GJX4bFyVBX
         S8ROP7GX3RXCVW3UPRhwyuCsZutFI/L/iuutI/pFKfOIdI9PdT6gwS+EyrEiO4eNpVEM
         2FnuENm3xYJZYV+8hRwyl9sraDzzRH24DyJNDCfJedg1LOG7D1XNKwuzyO1UhaqlPM1i
         ZUNZbEhBGqjFa5Hjbrby1qoKuhWmddvG/bq1BmMuV/b2pRfal1PudfVlXDgjUnJ/NNuI
         pi0416h9aoPZJB6PLrC20/LA+IWMyxK/z+HHfrX/YXFs80lepK2WthMAzNGyYNLgYZ62
         Ae7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785266775; x=1785871575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ePC1Y0ne7UyI/z8ccYsuTaBWGOHMZQF21As30zRm9nQ=;
        b=nLe94A/y9OAmXlse10UKfkrMk9dGGgO17Z0QHIYrpnctXDbW1xU5QrYcjhTRuHjB0w
         6GdWH6rCv3upePqhNKcxbgXYJAB10tlcjQ4XjeX5J+FN3clQ4Bt9qW3Nn759JV942a6o
         K36cc8V3RCgN23Rp9Dex3cMM+uDELVTB064b4W4dKzXxfjGo74VH6kVOshj4FMvJNBj3
         EftOFGO9Eo32D/gR8lMSWA3OeyNVzAc4BR+cHOa1WbEEvrndKhnHzzX36wpTgpPrBgg1
         cSBjZ1ZIsMZobweTRxz0sIUO/VJnzxezCxwIFC6Ma2fA/p8svO86vUISBQkwTskCFIX3
         Cuag==
X-Gm-Message-State: AOJu0Yy9dDhVIs3aaQdkOZNM1LfzK4/QuDnXpx9vmDk2503ZzO8lOeQM
	+qShRp6DzkZfC9AxW2Mqw44GrbkssdURJmnx9J7/BVHDTFTLCb4Wl5KzZfIIhLaa
X-Gm-Gg: AR+sD11IEVWUGG7lrT6p+PQKNzMaM3KTm3Y4O5GhZZYz556BN4zyWk4JHUN30qS8kt1
	M8e+u5Znkp8B37RBnTG3P4hrOXttdcA+VIMxD/CuHQPrIwRIlM5lWffgX6tGL/PVZZsccnHR0gR
	HtbigB3+CoDbytU2R+0kMe3qVBnIxS7L83CfMRqAGgNX91QzGZTic59nKuxV6FUEt46A9hsw+uQ
	mT/s579sDrujihR/hOhHF9VPt5MilLAySSWVOENEL44TwiVCJqJtUi4gFAuRkAZOgaeVq4AhDq9
	7QeJpNnTrV3pyP6qTjSj32RMNilq203pMQSi5gQorixAmb9KCNxn283FpCUpAcDfig3S9SqzRgy
	BAWgYhOA4aiXz9qr6epBq0/qXFFvvAVDlfH8MSc3pd7G2/idvQeFT/K4aGqlWpOYZtvBhb5mMJC
	y0Zy6PlxB9MwPZS4/S
X-Received: by 2002:a05:6122:1815:b0:5c1:706d:aec3 with SMTP id 71dfb90a1353d-5c33fa9be2cmr1713248e0c.11.1785266774672;
        Tue, 28 Jul 2026 12:26:14 -0700 (PDT)
Received: from fedora.fibertel.com.ar ([200.55.79.212])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c34eefcfaesm373461e0c.2.2026.07.28.12.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 12:26:14 -0700 (PDT)
Sender: TheySaidThisWouldntFit <mariano.ignacio.baragiola@gmail.com>
From: Mariano Baragiola <mbaragiola@linux.com>
To: Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Mariano Baragiola <mbaragiola@linux.com>
Subject: [PATCH] wifi: wilc1000: validate monitor transmit frame headers
Date: Tue, 28 Jul 2026 16:26:10 -0300
Message-ID: <20260728192610.2236361-1-mbaragiola@linux.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wilc_wfi_mon_xmit() reads the radiotap length before ensuring that the
fixed header is present. After stripping that header, it reads the frame
type and all three 802.11 addresses without checking how much frame data
remains.

A truncated monitor injection can therefore cause out-of-bounds reads.
Validate the radiotap header first, use the common 802.11 helper to check
the variable header length, and require a complete three-address header
before using the addresses. This covers QoS and four-address data headers
while rejecting short control headers that this path cannot classify.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Mariano Baragiola <mbaragiola@linux.com>
---
 drivers/net/wireless/microchip/wilc1000/mon.c | 30 +++++++++++++++----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/mon.c b/drivers/net/wireless/microchip/wilc1000/mon.c
index b5cf6fa7a851..9b8c083b403d 100644
--- a/drivers/net/wireless/microchip/wilc1000/mon.c
+++ b/drivers/net/wireless/microchip/wilc1000/mon.c
@@ -142,6 +142,9 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
+	struct ieee80211_radiotap_header_fixed *rtap_hdr;
+	struct ieee80211_hdr_3addr *hdr;
+	unsigned int hdr_len;
 	u32 rtap_len, ret = 0;
 	struct wilc_wfi_mon_priv  *mon_priv;
 	struct sk_buff *skb2;
@@ -153,13 +156,26 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	if (!mon_priv)
 		return -EFAULT;
 
+	if (skb->len < sizeof(*rtap_hdr))
+		goto drop;
+
+	rtap_hdr = (void *)skb->data;
+	if (rtap_hdr->it_version)
+		goto drop;
+
 	rtap_len = ieee80211_get_radiotap_len(skb->data);
-	if (skb->len < rtap_len)
-		return -1;
+	if (rtap_len < sizeof(*rtap_hdr) || skb->len < rtap_len)
+		goto drop;
 
 	skb_pull(skb, rtap_len);
+	hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	if (hdr_len < sizeof(*hdr))
+		goto drop;
 
-	if (skb->data[0] == 0xc0 && is_broadcast_ether_addr(&skb->data[4])) {
+	hdr = (void *)skb->data;
+
+	if (ieee80211_is_deauth(hdr->frame_control) &&
+	    is_broadcast_ether_addr(hdr->addr1)) {
 		skb2 = dev_alloc_skb(skb->len + sizeof(*cb_hdr));
 		if (!skb2)
 			return -ENOMEM;
@@ -191,8 +207,8 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	}
 	skb->dev = mon_priv->real_ndev;
 
-	ether_addr_copy(srcadd, &skb->data[10]);
-	ether_addr_copy(bssid, &skb->data[16]);
+	ether_addr_copy(srcadd, hdr->addr2);
+	ether_addr_copy(bssid, hdr->addr3);
 	/*
 	 * Identify if data or mgmt packet, if source address and bssid
 	 * fields are equal send it to mgmt frames handler
@@ -207,6 +223,10 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	}
 
 	return ret;
+
+drop:
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
 }
 
 static const struct net_device_ops wilc_wfi_netdev_ops = {
-- 
2.55.0

