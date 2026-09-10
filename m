Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9B438DC79
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027739; cv=none; b=Exgo0ZgUqQp7Wh/FsQjU23gmhhdsxJSLpNJBjiRxvCEAMgbT8VwjOPtOW5SUQBX4mCm4GHDvaHP5s3lst1IHIBcYDJIGchMWhqW14AXIORX+S8NuSSa2pLvMzOCtRt9bZUHnOdomNxOwVbR21rJ9b0SPrUwiyoAP4DlvhiMP3aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027739; c=relaxed/simple;
	bh=vdIaTE9XpwnCRqTXSrb7A32urL0OgQ1CIfPqyCIB1w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQ6o0/LTsek+rvoJnfnaceBdXKhzC5wEd+isGFJ5sgQ7x8iTiHeQWhjS715fdlixS+tERo4RHUrvjbPd22ekMgVx+IFkIPK0kEsuMR0ys2juCKZ41H0bKBIcTUkmtWTF6Z+1uwrs1VqA7rH9BZCZsdiK6fT1X3EJYQ3ELzt9G54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WJaT/nzV; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJaT/nzV"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc1a4c62804so4901415a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 01:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789027737; x=1789632537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mMJLA/efZolJ/s2ULV6M9FfSxybkuBS9TaHpKmSFOSM=;
        b=WJaT/nzVFNAvteJi1yj9I79mhFIN5vhvhliTkPedX5QtWsh/pRixkmgwq1p3RAH9Zi
         hs4HaYytT3/tc6sJbNdmq0pRSLfCjQj3gqSS0B2YyZ8/xwy5FDBR+9Vf7onx3dy+ZzYM
         mkos1LQg3FgrbVuwVBTX/221bH4vXd7nDSE27/RMaR23d/mxuXSTrY641n4QB70hwRHl
         lz41OKN4+mYG1eaGUJKjxXrTGedr7G7Eten6JMukwGot0BE2GhYa4A8hnKrdxecrRaqY
         PAGqiPir10lvAZybubBwVrPB3W/zjStFLaGRuGtgTfvPKmIPY/W3iERtvfX4ZW3EqVmV
         IWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027737; x=1789632537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mMJLA/efZolJ/s2ULV6M9FfSxybkuBS9TaHpKmSFOSM=;
        b=Htl3MP2gNqzCDSArnnuo21XqyzpVhOgh7nPnMBATTL2CnWE5/ZB6nBr3O00ZxT847Z
         T+BrmAT1NGjPd3+Ep86azHQixbryeU0ZVnxuuZAIPnNogpRxmdPegeiRtD7LoeaBUTD8
         krV+ZzddKf1sOVfy4t4imPBgPvnsRU6bRYa0YLJyLFZsiAkriGLXyY5srB+WdT2yG2pH
         aVDxUtbntZxPk9ArXe//Ql/Kk/fBFVVqj7oxSeZ65FsxEADdbppNCm6zfjue5DkHNNDv
         hEoVtNk7Zi3DkVmBkUHmEieaS/enGkCxcgUXD0lvuJuMTBRKQUSljgD9FEfdNLuGCQAm
         +VLA==
X-Gm-Message-State: AFuF++mq+sSWeBmH0N1xOvnpr7b2LtQNLQUiOq+QMhFW+/YnWpZ6fFyF
	ZahzN+FygOA37vGV4+45dweFqLLg9QlszvJLAPMZo/rBHxACKCx7DzNa22QfcVvvlLY=
X-Gm-Gg: AYBFou2I04/adG40jmtt3aochqyK9iXs0VhzmOdArpHdj6XpYll0V5QQHuJ1SCMbUWR
	t2ILs8VeZNuHgNd4ixIhwZ4nPixkPtoYsowCcZ0s7Tr5rmPU8k+CDkYK9vOtsXlZy+z9XeYJGfw
	7ir/VCJ8GE4NRb5rsqsIi+UpcmUfx5JPMMjTcr2dQ08tPi8tm6VP9lmQk3W3KkFBsfszB2txQsJ
	YPkBcTkwV7LsxkXuWNRSeqQ3QFmvFzcy/fiGy/xER0u374SJU2teXSNSWGx1VE5Zy8f84c8QJGw
	Mg1Rgy4C1QN/AfQG9+AABadJA06gVgO5f4+HEL3ewNBt4nCdgqMS5NNpsJ4VbstJrJDjF+z7RP7
	RpTZonZ4q0WZgLMPrnpwErlV3T1qysoagK/J/gJ+3U2FhlAtFIFw8+EMnrbsLS08zsqMAUyEQa6
	cTJJpkto9/vTdDN8L3TXH+JsA8BaupYVhJrBqv8sGDaWZPeElp2UNkoWJyKdAFFLiVcl+8sELbW
	Z4HVPLs50dJXI8THUIwv2WXNs7rtgW6hsW/bEDph9ApxmVOso8TWs1TQLfZ8db95EpDxm/Yf2DE
	DQ==
X-Received: by 2002:a17:90b:3c48:b0:398:e436:384 with SMTP id 98e67ed59e1d1-39b260d335dmr61169626a91.1.1789027737071;
        Thu, 10 Sep 2026 01:08:57 -0700 (PDT)
Received: from codespaces-1adab9.ktkhmpmw22vebpok31ngjx2qsb.ix.internal.cloudapp.net ([23.97.62.116])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d77486a1esm4607521a91.12.2026.09.10.01.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:08:56 -0700 (PDT)
From: Rivaldi Hormat <rivaldihormat@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org,
	ath10k@lists.infradead.org,
	Rivaldi Hormat <rivaldihormat@gmail.com>
Subject: [PATCH 2/2] wifi: ath10k: Add missing validation in ath10k_htt_rx_proc_rx_frag_ind_hl
Date: Thu, 10 Sep 2026 08:06:59 +0000
Message-ID: <20260910080659.20831-2-rivaldihormat@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910080659.20831-1-rivaldihormat@gmail.com>
References: <20260910080659.20831-1-rivaldihormat@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ath10k_htt_rx_proc_rx_frag_ind_hl function processes fragment
indications sent by the WiFi firmware. It performs pointer arithmetic
without validating the skb length:

1. skb_pull(skb, HTT_RX_FRAG_IND_INFO0_HEADER_LEN) without checking
   that skb->len >= HTT_RX_FRAG_IND_INFO0_HEADER_LEN.

2. hdr = (struct ieee80211_hdr *)((u8 *)rx_desc + rx_hl->fw_desc.len)
   without checking that fw_desc.len does not exceed the remaining
   skb length.

If the firmware sends a malformed fragment indication with a small
payload, this can lead to an integer underflow in skb->len and an
out-of-bounds read in hdr->addr1.

Fix this by adding the missing validation:
- Validate skb->len before skb_pull.
- Validate num_mpdu_ranges to be <= 1.
- Validate tot_hdr_len against skb->len.
- Validate fw_desc.len against remaining skb length.

This prevents out-of-bounds read if the firmware sends malformed data.

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

