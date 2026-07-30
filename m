Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEF735B636
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428509; cv=none; b=XiExD7nFpiTc3uC1qhplOy4dtsuBkmoemoh/roiFO3N3Rb+x9q6QRCdK/tDKKXl1ArF/ZwSRiR3YlxSBkO9VHtKCwBJgoil6GnW68gqaHuLKdUU+uKLYrZQNOhLnvKMhONJPpvQ3zeUvEhbyevjYWuObPX6TMCd0Rlwb4drENk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428509; c=relaxed/simple;
	bh=11o2VHRYKUzasN6xbkTuOKJzZziHdzT348VOo3qx4cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El2IZVJtxf7IimgirzfGHcS0MYrAiebloEwmy/y2gV6qo1Q13xglYVAEo7tOFVt8MHmOyKJKR7BAHPZtcWBRILYtY89Mk5igLHwhaXEWQ2wIoRy9rrtUEV4/FwfZeBmJ/5+lD+k2nR2U3Krd5a3W+9AEy0N2NdGe3okiUMTcuJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4uZt7JL; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4uZt7JL"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84e4efb18c9so9158b3a.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785428508; x=1786033308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Julx1UQMQbFkIhi89Hhi0qC7Ef3z2ArBe2a/Ccavl0=;
        b=W4uZt7JLmdm7jj+EAJZkA1XwZlP7OgMz8bi+89VsDQgEvb5lzrahTPDo1cikP/XD1N
         tFxc4kHqCvXo/9rVCWOlHFEt+KMKFolA7xFKCpgRRT9FG+AJpjmILck/Jd7bln3KmO8F
         sBQum3Acjz9/oNZppGK+vH1RnvyFPIVQrS8d4S/k3vPthQqO2N3OH6d5+oH/Cq3uU4KN
         swhL+zk5IctNEbx+gG2baKUlPyfYQHqCq/rghFWMm6fYZppXcVtJxzSgJsCswTyXZ0AW
         RRSOgufiii9iCN40goP2WkOVviOUVm+2cQa5xu/wlKipp99CWkzikpQY4iWrXI1nl8E7
         loNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428508; x=1786033308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Julx1UQMQbFkIhi89Hhi0qC7Ef3z2ArBe2a/Ccavl0=;
        b=idv6dNLqS/Ow94MXuBu5ykOBRpgRVcxUVqVJl3aqXeVHYiSIvuyBba8wY+v43gpm1q
         BXMtGxGCe1k304GFBqRJ6A1UHzfITWT84i/emTMSWNTY7mcImXqh/O3KlPA7fIKMP87F
         kZXtCp/wR/2+0Y/3wJa6sCXMS6luIu/kEnURcKcgQ67zCGZ4JV1e/VPmZtD/U4LSm+ti
         Rkl6CsWzB6P9hnTmUn31FRHbC3MoVWXfpSTrFVvJMKzBopvtoOQuz5AQ3dXq5gf3z0jd
         qsp63GXp0kznhOnUTAZKHYV1XCnOqRLcSKmANUrRJuvOaXS0llduZ8DGem2Ss7ufZS2D
         A5HA==
X-Gm-Message-State: AOJu0YwFgxZ33VXUK2BlKPbNr86LIMHmuEnOIsdS/KVRuJx4S3fsk4p9
	zEVz3QXWAOzEwwfOAkx35DvTmmouLSdA/A1OqBXrErJdxW6f70HYQBU3BOK4tdW4/Wc=
X-Gm-Gg: AR+sD11MgIvsZbLOmFoWhS8eCoVW4Fs3vnHv0Bublj+BX77B7WioR9wS1ycj2mPYRzS
	MS/ArRj9/+IXkT+QJ/tSOPeH81JMWlvkU+qRcinjVswIBgn0bmlszbmaynOnNhdBFKgo7e80qI8
	X3j7oJF4Hg6pLTzjDJrqfABwzTe+nOG2bJSpDRtawiBgXkMkuqWMdsmE28snwbPHo15WwXwHRFK
	7TW9MJ+OqgHfLcKjlAjdarB/eiv2Xyscg1n2bPjgQOl4JDI6m7Qbt+xMH63WCjCAqhmsg8Otq+m
	xnbdlqb2GfjocWIZRAt6cWQgPnk8bF5AMZk5fchqPz+JVN8iuqSmPqDh3Eg/nPpq7bCNP53AcAR
	KHpdlFrzzRvlCJl+2Cx7JdeoWC8GZOiutlLIUf/NVJu1g4CiBtgqz6tmhEvFhwSdx9tywydylib
	Dq2JDO5p0Ve2Ml4oBvHUezbbwAR983Xx1ABeC143T2EWvf2a2IC/j10UzZBWMX1U8WgR47K4Cct
	3g=
X-Received: by 2002:a17:90b:5866:b0:38e:c140:2a0b with SMTP id 98e67ed59e1d1-38fa80cad74mr798248a91.3.1785428507955;
        Thu, 30 Jul 2026 09:21:47 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7275973dsm19964269c88.15.2026.07.30.09.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:21:47 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v2 3/8] wifi: brcmfmac: core: populate radiotap header with RSSI
Date: Thu, 30 Jul 2026 16:21:06 +0000
Message-ID: <20260730162135.12278-3-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730162135.12278-1-shivesh@example.com>
References: <20260730162135.12278-1-shivesh@example.com>
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

