Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792457441;
	b=zWq6tWADLUb1qC0jgk9XTrfdN3bf7OgPQnMhrGmgtInwxdroK++n4dRz+YBFVe883kC3
	 SkUVFMFKI7+WzQ/584kpUtvIdvz231431AWrQRe4FFT3lI81ekVgQm65JelFdrnsmv++w
	 X2kRjKBmi84PBnQ4uMIcfsEDocRzR/kqjQRym4Loz3NQnYB7D/TR0qysWhlx0nZPra09E
	 tLm0+c2N3DmaFUSejzeXb33Cnkej/X33URv0VLRRRoafKCCv2l0H4GMp3TDyUPoN1T9XH
	 8iFCCd4eiD6IM3iaPhm5PEedxNgJ6niTi9B3mvxmyydjXQAy7ARmB2XiSWKkmuyQ61w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792457441;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9blM1tq4Eg4vAP7xUabO/Mdku4yW+ki7sKxUpiTn5z0=;
	b=KerIAlKnBP2F51P2bsVs9282bgfPyl53bFpV7EBNbu7s6dk7Xyl4gKB7sBm0c9RBCbbi
	 IDe8NEKIDoRNf0HfWeY1osifNP0k3TyvxzlvU5c9KtsMxCT3d2WcmBQyzIXg0oOlGWmV0
	 BC9NSeXZUL2agL+RPX5HoASjuSMtZH5fLAK8x04W2i1XB7ZnffGYzjpf6IMqyL18TyI8i
	 bWWmzM3VXaE/6bE+3xmM92ekbyBt01KZfSSYdY4RQ0UT48WcrJ9/eFz47LkLd6eFfDnIT
	 T58mZR+6W9ZJMnlkv0+Xs71zBqHyielNQs7b03cxFD84QpjgbU8O5G7REYN8Kg/p+Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=f5sDjb29;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9D2606A324
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:50:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A9D2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=f5sDjb29
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cd632f7a4a1so985904a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 17:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792457440; x=1793062240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9blM1tq4Eg4vAP7xUabO/Mdku4yW+ki7sKxUpiTn5z0=;
        b=f5sDjb293/4UYDZBvfTGwqeMx47Oi9qg8gQKXZUEww/TzlTv5Btk5pmsOpbtNX/st/
         Chz0HPTFq5B/BCFBmmUkOlw1VJkKmQxfLwXJpOaezmHSWeOzy5g7G5a2hraasbQmBamj
         QOnI4Hwb7m/LmD5N5da9J/27aLE3ebkJFHBnY3ocZeVVKK+ZZn4EszTNU0FVSaW5rRtG
         Iaj8GUrtEIBB3Z3OjCFnBpIfBXqsZcr49kC/SJrsMNdDrrJOc49UISGUE83Fl2Anzzbx
         zcqVgHbP1MGNtqunQQIR160KjilYdeam+UUjnhDwWw6WQaeq4NQfFYoTfrPQM8kRlbtj
         ywXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792457440; x=1793062240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9blM1tq4Eg4vAP7xUabO/Mdku4yW+ki7sKxUpiTn5z0=;
        b=DmbWf8jg65Px6VbE2u/lnPACXY2rH5zc3yPDjkYzbxmLW+bS26AY9IywgkFFWoALps
         PsADJG9MLw2kElIBh4g1ikZuHuPgJ8KOQib+z98yo2GihH5Bsm6dkuNlR7nWgllhFlJ7
         zto596RG/y6/T3ON0jlul7YNGjR14HBr9DQMI7j2292lHNJdkK1G5iFnjK/kTdto/aFD
         Yt6Ci85SzVJ+f53XNa4ObnqGTuoUfjFeXHVleIpnrMfL3go2N3bQdBlh7X9hLjEIDvS+
         fz+Qpy2PM7Wli71jCBCVd/83/K75MOwlKmWB4pBg/RSWYksuQcuBXIh7Zr/klrW/7gii
         GVsw==
X-Forwarded-Encrypted: i=1; AKwUvBy9GfZYZkx3eLU5vgeto9pbTI3xZOdAGcttfCz4gLZJnEa+wjQ5eZPzslV4+oTSuZ/1qsUKro8hsxKkavelnA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIF+PQKSJsZ/JVjFrW6trlcAMkyZFs8uSRZOBsGEKsWoGJkos7K
	X4Q8YklXD/238DDojKNf+c3V+G7KY3RQWTC6oUey61m88Ab/cWqf41uwvTZkWQpr+NI=
X-Gm-Gg: AYBFou11WK7e9/a16pWKHXkl8nW/5TZuG9zsewMUxA+DpcWt8VFYWxuIxWx/yhROVxc
	7Y3tU/5esX4zcs/85FoWcamPjI76uOYZGS/yXBw/W7Qp3u7rQ5DAvxGnn38Q6oZ3+oocuR2wTFC
	CffPrP6/q23NqkbuFSkxk29WGqZ76n5AW48xbnqO6RsRVuhQfYWFjPX/wZSjPxS0oo7O207sIIl
	xLWx5RDLBgoyj0c4uLcX46quFh6DTEZ43ENwo1bcoTe7pT395uMg6Xj9I5FhpJnQLkrMehCnjDo
	DOEHrtuaJmdPmktzyQjRQcL9WUZotiMY4z5PP/GMBxZxcuzRShTOBshRbWTDRfURTFVM/ZKsb+B
	bnrYXuSb0yzBqAXlsLGJjuxjZo2zdPH+F7gNrPI20OH8TcF/1eujbUOm1VX1Zr0x4RQyhEngxB9
	khZFOO3+p/jfbye/8PQu+rb30WPNDxlcOT3wAjC8RJUD38jZmt8vF2WylXEL6FXaGhB52upTl3w
	t4iwg==
X-Received: by 2002:a17:90b:4c0d:b0:3aa:f4af:1e16 with SMTP id 98e67ed59e1d1-3acee293046mr8361923a91.7.1792457440525;
        Mon, 19 Oct 2026 17:50:40 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3b16c2asm8520499a91.2.2026.10.19.17.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 17:50:40 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 2/3] wifi: nxpwifi: read the 11AX_CFG extension ID at the right offset
Date: Tue, 20 Oct 2026 09:50:26 +0900
Message-ID: <20261020005027.1105121-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261020005027.1105121-1-yhlee@isslab.korea.ac.kr>
References: <20261020005027.1105121-1-yhlee@isslab.korea.ac.kr>
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

The send side writes the extension ID as the first payload byte of the
TLV in nxpwifi_cmd_11ax_cfg(), but nxpwifi_ret_11ax_cfg() reads it one
byte later and copies the HE capability from the same wrong offset. The
capability test runs on the wrong byte and the copy reads one byte past
the declared payload.

Read the extension ID and copy the capability from the first payload
byte. A zero-length extension TLV has no payload to read an extension ID
out of, so skip it.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index 7e9127ae2f421..16bda167fa66b 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -219,13 +219,13 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 		tlv_type = le16_to_cpu(header->type);
 		tlv_len = le16_to_cpu(header->len);
 
-		if (tlv_type == TLV_TYPE_EXTENSION_ID) {
-			ext_id = *((u8 *)header + sizeof(*header) + 1);
+		if (tlv_type == TLV_TYPE_EXTENSION_ID && tlv_len >= 1) {
+			ext_id = *((u8 *)header + sizeof(*header));
 			if (ext_id == WLAN_EID_EXT_HE_CAPABILITY) {
 				he_cap->id = tlv_type;
 				he_cap->len = tlv_len;
 				memcpy((u8 *)&he_cap->ext_id,
-				       (u8 *)header + sizeof(*header) + 1,
+				       (u8 *)header + sizeof(*header),
 				       tlv_len);
 				if (he_cfg->band_config & BIT(1)) {
 					memcpy(priv->user_he_cap,
-- 
2.43.0

