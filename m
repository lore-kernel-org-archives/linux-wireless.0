Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A6745FFD0
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427480; cv=none; b=GQq7GQvTDXZ9F7rvcLWtpuDerYbMFHFd5oh3TdfoUrl0MiKtwY9VWk0e4Yh5QAwZ0/ICWxqqYqUcGe99G0Tb6vm6kQefSJqQwUpaD1c2eo9uYt5I8igJAI5u8a8MtIJ/QlacyFNNKhfKrgN/RYwOGwh1KW4N555x7STEtcr5FmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427480; c=relaxed/simple;
	bh=83sqCGdGcSCvVa+9JspIJKCFU9FvCzQFy5Q7L48LIJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBEhD57PHP6XrJt+6iRI7JtckqICbItiPaXJ1949NnYf7NmC2S5Dlx+qY3VkwcuE4Occ/qMkW9fF96OsT0vCHGTPrES84AqRSMRILMrK83xZlXvmo750pDDgzYOsIJV8CbtgnlT0QniVxync8ah8c9jSbpyUbLsBhikPtXkQmZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nm7z0Bwa; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nm7z0Bwa"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-849f2f32facso4946b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785427478; x=1786032278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3jIAI+a5zpsh6wBE3laZ7ci5SL/RFgEEpXPR8uss6Ao=;
        b=Nm7z0Bwagth6q7UjFiJYqXPIRLNO/lZ9txh8UYjs/3SMCUF3DHCjNb3vBXR6zXCRKS
         9W8xZVZY59ib8TyyzI6uS+UfNq5pBTGOdard/JuHYgO+hHywTRWyvC9/dnS0CQXGJ9aE
         M4GWcg3jWBDiY13OMjRqMhkVCEi2fMlmLCS2lohXb8LI/sXvQRVDMjj3Dee1BynZ4vFJ
         GP186fcDdp4nCZN0vs1ufatfPboW+ESd806YJCSozUWdGhdKUY1F28TtwQJS41lBX8gG
         cI/SkIi+LRkp3fvuyzUxsnveUwAGEzQLySLp2fOHLcH66bGKbQBORtKCHjHiPeJP5dRw
         LGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427478; x=1786032278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3jIAI+a5zpsh6wBE3laZ7ci5SL/RFgEEpXPR8uss6Ao=;
        b=PmosTOrZfQGNZp0sin3hIhP8qzuK1VtDJ4P1kHYkoa80o/Aa2FPM00GOTjUgltBpu1
         7ZFImoXqU85lks/EiufbxRICf84qxPaSKgU4XnGN1T1ka8uuMw0HMlC5p0GBAIGx7CoW
         LQH9VceFJC7H1ck8H8bk+D2wc4IfChtq4DxeuavmGDdw0z+b4HyBdvjlWQE/JSMdh+EU
         s0OYCHnt0suoyvBg3cmZrdBa9ZSoeK7VeGL/F2gG7C79P+IqHKrsKLe7frCWBS7TDkCv
         g3343QaNGRAL2m520unNNjvzziSvJh2gGeADf8N5Ht67tvtryv1BCmpt1Wdes1Sr2W5r
         HWBw==
X-Gm-Message-State: AOJu0YzP76THLLP9Cj1Cu8VBVrGOVYt5eQvYi4t3O8oVtK/aqGPBu4r2
	BuRCwohOhx4/3Rm10EPAF41xir+ydeG4DUk1gEXy/bFFqeCEc6mQFIUW
X-Gm-Gg: AR+sD13oCI236LDP66e6hafTdaH1j41Mb4iJ5/xXvoz4SQOemtdA2ynwKCH5x7qnOj5
	locYs7xM/TAMg5ce9c9Du+MVtIsRELuFoBiDxSUHhfBhFvokKhCdLQRnqfSsUefgs6SXLXmNknu
	OMOdLku2y4OMXBIZyaA+qzvRMOt/uw7IyhPnppAN9FpDXs2BJsGoakEE405+w7Iyn6QYe/kRfPB
	gQcdF13OtlOqUWKn8Ja7zQtZor1zJH0dBkBwIpuDbjkOK1+9NORBnezF3RRaEXaDbRwX9wy+FQP
	9dvn+ikoWR0qnstV/3la3jivWloPEMheSAhXX98HAYLpF+fYT7nNHKUgpC6FGte3tgR6ZNvEuo3
	u3L31YBkLzMRxntLbB9Ej6pNbLOIxqX3i1sW8lONORChpeilke55FZx6NKsIq914dvYksf3r/4H
	glpyk1kPlD7+taBgly1OCv00KmnNAprjpMZ16GuQbDoKhsVbAzzhpnqMVc+MmHWTajWtcwnHV0H
	KsHEINj6xNZWg==
X-Received: by 2002:a17:90b:1c89:b0:36d:b30b:14ed with SMTP id 98e67ed59e1d1-38fa80944a8mr870183a91.2.1785427477707;
        Thu, 30 Jul 2026 09:04:37 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm35012783c88.5.2026.07.30.09.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:04:37 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <shivesh@example.com>
Subject: [PATCH 3/8] wifi: brcmfmac: core: populate radiotap header with RSSI
Date: Thu, 30 Jul 2026 16:03:51 +0000
Message-ID: <20260730160425.11933-3-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730160425.11933-1-shivesh@example.com>
References: <20260730160425.11933-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Populates the radiotap header with dbm_antsignal using the rssi
value extracted from the firmware's hardware RX header, fixing
missing signal data in monitor mode captures.

Signed-off-by: Shivesh <shivesh@example.com>
---
 .../broadcom/brcm80211/brcmfmac/core.c        | 34 +++++++++++--------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ec170647800d..673f0000389c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -431,45 +431,51 @@ void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
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
+		/* Insert our radiotap header with RSSI data */
+		rtap = skb_push(skb, sizeof(*rtap));
+		memset(rtap, 0, sizeof(*rtap));
+		rtap->hdr.it_len = cpu_to_le16(sizeof(*rtap));
+		rtap->hdr.it_present = cpu_to_le32(1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
+		rtap->dbm_antsignal = rssi;
 
-		/* TODO: 4 bytes with receive status? */
-		skb->len -= 4;
+		/* Strip the 4-byte receive status / FCS tail */
+		skb_trim(skb, skb->len - 4);
 	} else {
 		struct ieee80211_radiotap_header *radiotap;
 
-		/* TODO: use RX status to fill some radiotap data */
 		radiotap = skb_push(skb, sizeof(*radiotap));
 		memset(radiotap, 0, sizeof(*radiotap));
 		radiotap->it_len = cpu_to_le16(sizeof(*radiotap));
 
-		/* TODO: 4 bytes with receive status? */
-		skb->len -= 4;
+		/* Strip the 4-byte receive status / FCS tail */
+		skb_trim(skb, skb->len - 4);
 	}
 
 	skb->dev = ifp->ndev;
-- 
2.53.0

