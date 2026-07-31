Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2C8446821
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514023; cv=none; b=RO16qQRaAFcZo1kXwfDq1ewOqJQRYFXxVeNs6WA9veHE7T4+8/rwBHJ2o4smV6g+kkFKUHh+9UzmBcTr8X1LhpJJ7H/r1KpMUy8c1AqYXOy7stvleLSdZHRUAlunKhunBR4//G6Hbg1nOCFKs635E4z88XTawISzhrlaxAR4P5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514023; c=relaxed/simple;
	bh=Jty8yO41/NAzwBTRC93gt7XYppm8tipeHN673R2Ik08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4/q+585hWm8eygjhMdjnu+GCPO54wKC0+Mytn0Qj85f0eRo98RdxmLvRY/Sw53q2/9+h+L/lumCql7NbK1tt4CX8VRZXIu8WVcn1SPXeOfDqRm7Rbg+7lIxu7jYI+DUrbX0T9guKybyEEW2YhO4qVS/qtAldtSSf9r0AMyONCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cyhYsIhM; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cyhYsIhM"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-ca132e9c54aso94059a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785514021; x=1786118821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XauinKQI6tu5wjHWqSFKKt7ebLbypRasR58eoZCbIfk=;
        b=cyhYsIhMz535yydF38+h0IbaWx+KZkCeutI27LzpL1EIMe275B6KbPUC9Vuj+5Zt07
         3iLIGK0jLHjuBlcn/PVPP0Nh2K2iMBLiX/RIcVC52iPiUZrqXpJbzqyGo1imYTt1B094
         Ymk2OfYiAqT5q+oaSEDX/fa3CIWI+5n/ZVsZGKtMlxHrFosJZa9+iR18UWoBbZuQJqnQ
         YNARRcm4KBaSX+8Zw5x2J9mllKm1bVN1Ae002YSsNvUMhJW1epv2bE9VYnU07utbQifs
         yW7DDLZUUwbvYa4c6JLRsmZoCMeGy/SLM/B+XxCEk2CJgXddY4UHf6ImwBCmmE9h/+EA
         aGng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514021; x=1786118821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XauinKQI6tu5wjHWqSFKKt7ebLbypRasR58eoZCbIfk=;
        b=kRoXNGjdMmukeA+EAQAP4lzaLe+JTEm3CYDhNPJAmLHQCrPDz0XIlBV/YbcAlmCNfc
         8aB2N96LeMECJGFGYRYKwbhc1bq/pyE3mk3/SFzKuZEVIHt3fyGx3qLXQvyPN4/IXDJd
         GDjhTpWDtimm5FFnDqBsks11IUCRG3cEsR6NspcNSbaxaOC/HAhc3rliYZp6Ef6MVo/E
         /axM8hbeNCbA4XXajXo0IZgUdxfL+t8fGodaX7ueujiNuyIEF49uxPLSICK3nzwRJy7u
         3c6QSJ/eTQV+cNEWZydMkaQ9rVXhuuILXJPqJ14B/zIkHB9JyLGQG7LWmZkewRncrlr0
         7kMg==
X-Gm-Message-State: AOJu0YxCST0mMKGrcTNie9j8VYrC/EmHy83Njbr4KeWfpcTdprT8smtz
	lMRkQu3f5sL5dta+wNkdpBO5xHhjmjgcree8YVKyTcymtrjGKYDBQo9w
X-Gm-Gg: AR+sD13j1RCjq729VPXINnybePH3xatSovB02FLman+NpYgwz7snGVy8OIUkO+ousYd
	M2FsroRZzQ4ANRh+KCyH2X3Cl/EaHqsUEtlUwcVcNmImXGDXYDJEAJ41dxsCHYIOT6kO1PjAHPL
	W8z7oEszUC8B/omaYZGtkQOYD11qPgV/FCnLbA/q+lbVhYrbOUQJaoTtoQAQXJZA5VgfyB1YSzf
	lV0iQwR+SxvJ9lvO624Bc7Tv07cp9bbxkukuy+4r4zXLp3uVyzhPyT9CoWLw4oxPw708Bf8wsQ8
	4LAP+CxdUIt0Pp/GSRM7ntgnMErmuP+0/spNmmAuO9KbukFB+vnqu7R9701cTSDSXpUzIZBuw+q
	7ZPeIEiPytkhuOYMj594fMrKvqcXdMQfsqiOpGwUF8A/TfigOKYqHpPtl3FaKyNOYRsZhZopLsL
	su+buoyVy7RlNwZby4bQAtetVpaYhrUB6AYVS8kcN7V2Re2WncoQ0n9icVydwhA1u3iBSu7zoWC
	fZC3SsR
X-Received: by 2002:a17:902:f607:b0:2ca:de3:15eb with SMTP id d9443c01a7336-2d05209f863mr7797915ad.0.1785514021222;
        Fri, 31 Jul 2026 09:07:01 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c93dsm7881425eec.8.2026.07.31.09.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:07:00 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v4 3/8] wifi: brcmfmac: core: fix missing headroom check and populate radiotap RSSI
Date: Fri, 31 Jul 2026 16:06:20 +0000
Message-ID: <20260731160646.3812-4-chanelshivesh@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731160646.3812-1-chanelshivesh@gmail.com>
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two problems exist in brcmf_netif_mon_rx():

1. skb_push() is called without first verifying that the skb has
   sufficient headroom. If the skb arrives with zero headroom the
   kernel will panic. Use skb_cow_head() before each skb_push() and
   free the skb on allocation failure.

2. When the firmware provides a hardware RX header
   (BRCMF_FEAT_MONITOR_FMT_HW_RX_HDR), the driver strips it and
   inserts a blank ieee80211_radiotap_header with no signal data.
   Monitor-mode packet captures therefore show no signal strength,
   making tools like Wireshark and iw unable to report RSSI.

Define struct brcmf_radiotap_info that embeds the standard radiotap
header followed by a dbm_antsignal field. Extract the rssi value from
wlc_d11rxhdr and populate it_present with
IEEE80211_RADIOTAP_DBM_ANTSIGNAL so userspace tools can read signal
strength from monitor-mode frames.

Also replace the open-coded "skb->len -= 4" with skb_trim(), which
is the correct API for shortening a linear skb.

Fixes: e665988be29c ("brcmfmac: support monitor frames with the hardware/ucode header")
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

