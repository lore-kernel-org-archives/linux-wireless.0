Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5999C2C2360
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792119786; cv=none; b=NcHHU+6cKKtxoEZORgJ+bSnomKL7kOsZ02EevPWmRXecbrtDss+jgAEVZh+sBrgw0iAHpZ4peoGfF2QJCZTIEUp1oQl600xfwGQWgLr4xp3sJ87PmLaYaB8zTtqepMRCyH4GHBJQPPQFt5Net5ipb1jdW38Q6fRba+1vIpmkrr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792119786; c=relaxed/simple;
	bh=kQ2dKaQoE8x00XszrgduAM5ljTPA4kY00EPvVgvfkZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoRggX9yJaFIYrPqoCYQ/bgVDMxgK2fQkOrerYQTvLxIgCqLnqdCIMxvA9JXXojKRaBZtDJQbpEFD/JqefB9lyXXuEC44A1QGum1daVhHoWi1PfHbTCGoFNiviQilx0LM7BnlYafge6vohG357+OoKeu5hBLakyQlHUt7ZDjZlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=ULhmUn6z; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="ULhmUn6z"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-89f81643121so143241b3a.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792119785; x=1792724585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b4v+dWiCRAdthtI0M2qpP1oy65No/E58vyRYWnt7MYQ=;
        b=ULhmUn6zAT+nk4K8eSJdLR6nUmG7K5noPKFEAFjn2JKwKesDPmILe1aDLOxFS1twQ6
         NuUY4xARvrl9ps6oKyiAnXEJZJIjyRXL6MfE1uNevfqc45HpeiKRFsHPCXE2SdIPuBHI
         GBkOGZxnVz6qN8QwOg3l/tGVwDHAVrvo6uz7VzAVNvdzrpbsktdzTeD52Sg+rkSRHPK2
         u6A3ph8FckrNnudjz/L0X0jkDj4EmO1A8pOj3vSHL5Mk7Y+r4ipRotVj2u1+L+lOmJ2v
         jsOLqelwnECC9cKik72MR0DRbb5LCIGJ4PRNPC76tChaQvWfowYN+XtTRowtXVsQvh2I
         6Gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792119785; x=1792724585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b4v+dWiCRAdthtI0M2qpP1oy65No/E58vyRYWnt7MYQ=;
        b=A/NN3s23qlyjmLtDV5ymqgehQ0o0VAI5W7oc9dmpjyULzLM2psnGL3rKFaMsa9jtj4
         spK5WWsNO8xZrqbz/DPRQIlbuRULAkhWt4/uUzetRf2Wfatb7VIInEUsgCndfMELgGHS
         FKCKNJKMD+VROVWYqMiI5raOu40xPMoXl98Ea6BCmAuPVFElGJVskidj/oMGbhUuN74y
         XwlCuEf7Vkfb8+majvP3d7MAbIXiNjHIvsYGATpT0T+EiWYpjABN0HUcVWCivoUM9Kd/
         JGroI0oFPb9yXkncb5N78MLuXZfdUgpR4tbSf+sVNrhyrqNpaT60ZYFpYEuuXH6kKEOg
         WTRw==
X-Gm-Message-State: AFq9FYJGWsccv1b9yWGLKk0Ef95CYJg9FEHt6HGKjdANplsqWApsRdr4
	RRDvxgp9xudEjKP43D93lsVDng5NWMqNXhGyPukCV/L4hswYMPDTxi+KpXYjBVfEOejiuCIz3ec
	KvHEy
X-Gm-Gg: AYBFou2dIiXeh48/k02wyR8uhvX6Fuk2+jq5NwY21KoCoutE1al3nEInTjizLoUjspC
	U63MGmRGLAtMhukhSoAGiBvYNNMY4XR4EVlELNhF+DJzEJEfADl6AH4NrC1ADqdYCHM9evoJQty
	/9VPsNdg9tClkQMKC9cMdK8PvqqpurUoJc/pKZ7I95HdMjIS9+rNSLjkRqOd/ngtfVgmeKsz8YC
	k+xmglzZ2uP6w0RwLX2HmRoOGd9w5KL0TnE/eVgArmVv+hLBbcE76pawj/pGsdzbCJzWlWGRroM
	uIbOmXrT1cUIfMlz5LapKTDX9MI1nbYPHygNnOn1uUwtmuBRtfqemSVrCYuvUwjkzUsd8azLy+T
	+DxiMnSPUHBzuApZMUcbUVHEZcDy2tZotlaTbo/kIAOX/OsSeom7deyB0CPaJCwTv8/1U275H1V
	OMPMOfec3GZl1qjrA1QjREaryADu1WaP24/N19fV/6IkjWxu0pWL+uCPPTwVtdRGh2NekSCvNx+
	xFpKg==
X-Received: by 2002:a05:6a21:3511:b0:3dd:85a9:55ab with SMTP id adf61e73a8af0-3e16be2877amr18484077637.36.1792119783810;
        Thu, 15 Oct 2026 20:03:03 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f56c8c490sm422493b3a.10.2026.10.15.20.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:03:03 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 2/2] wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response
Date: Fri, 16 Oct 2026 12:02:50 +0900
Message-ID: <20261016030251.690780-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016030251.690780-1-yhlee@isslab.korea.ac.kr>
References: <20261016030251.690780-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_ret_11ax_cfg() walks the TLVs the firmware returns for
HOST_CMD_11AX_CFG and copies one of them into two fixed-size
destinations. Nothing bounds any of the three lengths involved.

The walk length comes straight out of the response:

	left_len = le16_to_cpu(resp->size) - sizeof(*he_cfg) - S_DS_GEN;

left_len is a u16 and the two sizes add up to 11, so a response claiming
fewer than 11 bytes makes the subtraction wrap instead of ending the
walk, and the loop condition is only "left_len > sizeof(*header)".

Inside the loop, header->len is used as a memcpy length twice without
being compared to what is left or to what the destinations hold:

	memcpy((u8 *)&he_cap->ext_id,
	       (u8 *)header + sizeof(*header) + 1,
	       tlv_len);
	memcpy(priv->user_he_cap, (u8 *)header, sizeof(*header) + tlv_len);

The first destination runs from ext_id to the end of struct
nxpwifi_11ax_he_cap_cfg, which is 50 bytes; the second is
priv->user_he_cap[HE_CAP_MAX_SIZE], which is 54. header->len is 16 bits.
nxpwifi_set_11ax_status() declares the struct nxpwifi_11ax_he_cfg this
writes into on the stack and issues the command synchronously, so the
frame is still live when the response is parsed.

Do what the driver already does elsewhere. nxpwifi_ret_get_hw_spec()
checks that the response is longer than its fixed part before
subtracting, and nxpwifi_update_vs_ie() rejects a token longer than the
bytes remaining. Add the matching three checks here: refuse a response
that cannot hold the fixed part, refuse a TLV that claims more than the
remaining length, and refuse an HE-capability TLV that does not fit
either destination. A TLV whose length is within those bounds is copied
exactly as before, including one that fills both destinations completely.

This is not a claim of a reachable out-of-bounds write. The lengths come
from the device firmware, and whether it can emit these values is not
something the tree answers. The arithmetic reaches past both
destinations, the idiom is already in the driver, and the checks are
cheap.

The driver has not appeared in a released kernel, so there is nothing to
backport to and no stable tag.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index 1665bd514596e..ddbfe0939edc4 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -204,7 +204,7 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 {
 	struct host_cmd_11ax_cfg *he_cfg = &resp->params.ax_cfg;
 	struct nxpwifi_ie_types_header *header;
-	u16 left_len, tlv_type, tlv_len;
+	u16 resp_size, left_len, tlv_type, tlv_len;
 	struct nxpwifi_11ax_he_cap_cfg *he_cap;
 	u8 ext_id;
 
@@ -212,16 +212,32 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 		return -EINVAL;
 
 	he_cap = &ax_cfg->he_cap_cfg;
-	left_len = le16_to_cpu(resp->size) - sizeof(*he_cfg) - S_DS_GEN;
+	resp_size = le16_to_cpu(resp->size);
+	if (resp_size < S_DS_GEN + sizeof(*he_cfg))
+		return -EINVAL;
+
+	left_len = resp_size - S_DS_GEN - sizeof(*he_cfg);
 	header = (struct nxpwifi_ie_types_header *)he_cfg->tlv;
 
 	while (left_len > sizeof(*header)) {
 		tlv_type = le16_to_cpu(header->type);
 		tlv_len = le16_to_cpu(header->len);
 
+		if (sizeof(*header) + tlv_len > left_len)
+			return -EINVAL;
+
 		if (tlv_type == TLV_TYPE_EXTENSION_ID) {
 			ext_id = *((u8 *)header + sizeof(*header) + 1);
 			if (ext_id == WLAN_EID_EXT_HE_CAPABILITY) {
+				if (tlv_len > sizeof(*he_cap) -
+				    offsetof(struct nxpwifi_11ax_he_cap_cfg,
+					     ext_id) ||
+				    sizeof(*header) + tlv_len >
+				    sizeof(priv->user_he_cap) ||
+				    sizeof(*header) + tlv_len >
+				    sizeof(priv->user_2g_he_cap))
+					return -EINVAL;
+
 				he_cap->id = tlv_type;
 				he_cap->len = tlv_len;
 				memcpy((u8 *)&he_cap->ext_id,
-- 
2.43.0

