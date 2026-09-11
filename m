Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507483EB0E8
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 07:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111473; cv=none; b=YzllsjQMBLtMEjg+k6SyD07qPCLPgyzuqRvC0k4B0LSHKPjQy+laDHcXj5j7JafTlLiTOiqhTqXGhxMfoVJtNqNhxfyKz2p276BeaRNdFbDXKCF9OeMHEonB9PQHvDAjjVVPA/2vWmZbJj09Gp6Es0wgHT7WwopH5+qX/+sKiZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111473; c=relaxed/simple;
	bh=aoSZMPbbv+KZgH3lgZ82ja2wMgFCS7081TvMaC64rL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbBEnGwlwjOtkTFitbGj//3166eoIGBmkH8pcFNX+ZohqVVg25pbMBzBdmwz8a79Kk8sXezSYHaQJA+cIr1QuECNL77g06dq3ewGwFVKLURPXXIWIWYQMVxC9X1OuVvlWpr9Hxe1XGjq4d+K74DC9KZGOHMMAjcXfJWXTf1TByg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SMo5TO8r; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMo5TO8r"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4d03f95dfso84583a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 00:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789111466; x=1789716266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MNkNpvPXXOsHCrRH3dp5EJvTni7q+cIYOriXNedPssg=;
        b=SMo5TO8r76xIC1WOfrUBiSrWZbwPiKvU0EF7T69o7DHf0Yvwyv+vz1fS/vgp2dNwHM
         pjvXcZlhzTviAJ4R3PSuprjhnuVPmtG9zL93uFrv2ortP3xNJeodgqkb7C+S7zMrGwS7
         cFWMGQB5yAnxcVN2oRjzY6VBdv00bwYpo+byyZFCsc8Ov9VOV5cwL72BN1781TL4h1Bl
         hoqZJtko5B4lXZLSudk7PBqBKOOUxa2A0sKJ422se0bJ9rA7RZPiT1XOFpoheWFeuCrQ
         whBHP8T0d7O14jiTM0Du++DoRPBmMeQlVgrrB6LilvTUKddgtnU450zMbaXWjy725kiS
         i4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789111466; x=1789716266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MNkNpvPXXOsHCrRH3dp5EJvTni7q+cIYOriXNedPssg=;
        b=sJA/B1KxM2LP7sTnwo8VSpZatgDjP6rI2bXlOYISZHn4StRfZ9Uny9F4/U+u6Esk2f
         nSck1c6fFxAC0jdfR4wrqa2JqOL8OJFObNdYlg9ozibRq1WBW7sUIawWlbj54O9UXqdg
         4E81z4W8uMDE1ODKOeYTOcmi9qzaTZmT3S+WLDiZ1rdxvwA9ZjZ+lHWjyrOy5OOxZ+72
         R9o0v/i1hGrsz/lHcpErhnkGSdtm7dKKPSdq4rbWJYdRkiWvvSlVZwb1/2UAEe/z5CTJ
         LdwTxyDyN1I/km8+sLPDwWuNSf//4GSUZHmLxV70PTsbvVrjRkyy9ZIiTkDndePm8wDM
         7rKg==
X-Gm-Message-State: AFuF++meCv2tK5zD5f91ntqmbbQrAGaVY2BOhS5YrhAoNC0RGO5/Y2nN
	1vfdOlsw+LePGvlB/NcTArxVcjhG+l1JS+Oppc8RaPiSSL8oiHsaDabVUWNshk9A
X-Gm-Gg: AYBFou2w2j9zXljhDDBS9mEtberx9CeciJBQCNS5yuF6FQKsi3B2PCQx7t2cEOo/RPT
	c8W+X+ZCOYMc5gY5dNeuMZRDnx0jWfxk7RzFq/74G9EhDpnpbuGbh5ItRS/2jM785C2yuw+I6qr
	LQSoOAXOQZER6QiSMM3gNdNB8HfEQ1MKxSXsnJ3q+3a33V4Xhek3uPxexuOPKyZmn/8Hijghbxw
	J9LnaWhKQgc1gyTj8WqVyOfVICbn4PrxRMS/ikTyHawlyS7XEfE4zX+UIBPQ3Fb+FBS+tv/XiGe
	gPGGYOvtUQj13J1b1ylfXygIcLqsZvrap02Cfvd8FYlDiPvclFOmMK2FsKiZ4MOP8frclgLmHHS
	RZUnhXvOzP7apH1VInFbcVwmU8PlaHvDfOu2XImdZgm+D7JGQC+fSkBb2vAQKnTJsI2KNZzKye/
	TRhXJpbuMcG8W8ZQWbZ0hJPo1MEFXYKCvqHWuns8/pTuT1GRCGph62MFUG82kkfmHyfK2YXHPRO
	EItTIUAacTBY4Cu1vZS9pcIfMdjnQJqZSB5YNkDor7hWzB1BCTO35IIkZZ+odCf8ykgvtCXZhzx
	+A==
X-Received: by 2002:a17:90b:35d2:b0:396:41d1:cbc7 with SMTP id 98e67ed59e1d1-39d9bc0dca0mr4927613a91.3.1789111466067;
        Fri, 11 Sep 2026 00:24:26 -0700 (PDT)
Received: from codespaces-1adab9.ktkhmpmw22vebpok31ngjx2qsb.ix.internal.cloudapp.net ([23.97.62.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39da1ad5d79sm1984815a91.12.2026.09.11.00.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 00:24:25 -0700 (PDT)
From: Rivaldi Hormat <rivaldihormat@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org,
	ath10k@lists.infradead.org,
	Rivaldi Hormat <rivaldihormat@gmail.com>
Subject: [PATCH 2/2] wifi: ath10k: Add missing validation in ath10k_htt_rx_proc_rx_frag_ind_hl
Date: Fri, 11 Sep 2026 07:23:17 +0000
Message-ID: <20260911072318.5232-2-rivaldihormat@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260911072318.5232-1-rivaldihormat@gmail.com>
References: <20260911072318.5232-1-rivaldihormat@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath10k_htt_rx_proc_rx_frag_ind_hl() doesn't handle undersized packets.
This can lead to an integer underflow and an out-of-bounds read.

Fix this by adding the missing validation.

Signed-off-by: Rivaldi Hormat <rivaldihormat@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 30 ++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ab2d373b4..4fabb9264 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2775,6 +2775,13 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
 	struct htt_resp *resp;
 	size_t tot_hdr_len;
 
+
+	/* FIX: Validate skb length before skb_pull */
+	if (skb->len < HTT_RX_FRAG_IND_INFO0_HEADER_LEN) {
+		ath10k_warn(ar, "Invalid skb len %d for RX_FRAG_IND\n", skb->len);
+		return false;
+	}
+
 	resp = (struct htt_resp *)(skb->data + HTT_RX_FRAG_IND_INFO0_HEADER_LEN);
 	skb_pull(skb, HTT_RX_FRAG_IND_INFO0_HEADER_LEN);
 	skb_trim(skb, skb->len - FCS_LEN);
@@ -2792,6 +2799,13 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
 	num_mpdu_ranges = MS(__le32_to_cpu(rx_hl->hdr.info1),
 			     HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES);
 
+	/* FIX: Validate num_mpdu_ranges */
+	if (num_mpdu_ranges > 1) {
+		ath10k_warn(ar, "Invalid num_mpdu_ranges %d\n", num_mpdu_ranges);
+		goto err;
+	}
+
+
 	tot_hdr_len = sizeof(struct htt_resp_hdr) +
 		      sizeof(rx_hl->hdr) +
 		      sizeof(rx_hl->ppdu) +
@@ -2799,10 +2813,26 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
 		      sizeof(rx_hl->fw_desc) +
 		      sizeof(struct htt_rx_indication_mpdu_range) * num_mpdu_ranges;
 
+	/* FIX: Validate tot_hdr_len against skb length */
+	if (tot_hdr_len > skb->len) {
+		ath10k_warn(ar, "Invalid tot_hdr_len %zu > skb->len %u\n",
+			    tot_hdr_len, skb->len);
+		goto err;
+	}
+
+
 	tid =  MS(rx_hl->hdr.info0, HTT_RX_INDICATION_INFO0_EXT_TID);
 	rx_desc = (struct htt_hl_rx_desc *)(skb->data + tot_hdr_len);
 	rx_desc_info = __le32_to_cpu(rx_desc->info);
 
+
+	/* FIX: Validate fw_desc.len against remaining skb length */
+	if (rx_hl->fw_desc.len > skb->len - tot_hdr_len) {
+		ath10k_warn(ar, "Invalid fw_desc.len %u > remaining skb len\n",
+			    rx_hl->fw_desc.len);
+		goto err;
+	}
+
 	hdr = (struct ieee80211_hdr *)((u8 *)rx_desc + rx_hl->fw_desc.len);
 
 	if (is_multicast_ether_addr(hdr->addr1)) {
-- 
2.53.0

