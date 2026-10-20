Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792457444;
	b=NN31h5TLLSNMl8OS3uRbjsM1tuoUTkbdUo5glI5aFYcnuvXjlD5/cIzljv+jB5UKK/o3
	 uMuZfLEaKTnaV8g2n1+WldVHq4g1IL65z3UGLhNrmqJyqr7PgEPYbzEYnt98mPpMqotg6
	 6strnk/NjDAH6eqf2By1Js3yvyukXJCz483o1h3yjMc5VA5k3R6k/WUjyMD0zd/tZUP6C
	 OQe7oBpcOO/tIFOAeq0X77zVsIwiIwvVaQFpGF+rVw6o/u3Y1EQkKSxo5EDnRspufQ+uT
	 6Qt3vDkTWYMHHaOiJUMhOTK76Wq/+RwTt0HJQTK5DJR2DmJMVY0t/ozxSfJ+31LGL8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792457444;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XPe0JNEbr2LiKTaVjn34vcDqNA4MmDzPEYnEmiPiiyo=;
	b=VqiiRMhkEaUIoP23Po87loqxsoTBsQU9S/a6u7TrDpIyRQ1FGq5TsoMbsjag21jj9cEZ
	 +EeI3uhce7UsdvoeuI4xBArJuA2nyfXmDpW6utod12/82UV/ppAAuTwmoD0EMDU73/91E
	 ybi5sjGYlAo1RgqY4jxx3F3u6ZRFhBdGOKiLpuiFxCyrOhWZMQHwd36TOw80Qfvvhr9Pa
	 CivCSpvdkIFkscn5u6l6OoHnfnEtjxsm+XFEKUk7vulrIes0wctUd3kx2DwVtJ5F/hgXx
	 v3tVOXbcqcvrd1xwbIn6peq5p3siMY8u48inEtgRGl+MWHbss+lWWNYkPDK3+couOtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=h6UpW3Wz;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17069606A336
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:50:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17069606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=h6UpW3Wz
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ac7842c17dso1620404a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 17:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792457443; x=1793062243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPe0JNEbr2LiKTaVjn34vcDqNA4MmDzPEYnEmiPiiyo=;
        b=h6UpW3WznxnyArzXBPrbHGIVe1IhMpKDdTTi36iKnXZ3Eqy09f4SURmiAcGlqyhA6A
         CfeQfpi2AuU9ozSMUH82IsrOOXYrgOCjkbbiml3RoKhYaLkN/+SfJ4c2fJY+1SR4pTYw
         WUJzCc1V5FnKbdvJbU9yMcJCtxmLNw82nKPeQaLImlBr+Y+c7VInSrhCDYbKpMHWKIJj
         rZ1sZQdJQC/Nkn++kkNwvz1CsW2cKVAmhM4dv19B238AXy9tWNoGjVCETYl3vDg38C9/
         D8uQuDlnfw/+bIlA05XFQXJHt2Kc+6Y5lfBgzS5UeJkiOoOPY/+evXZD60uPqxWICleP
         rwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792457443; x=1793062243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XPe0JNEbr2LiKTaVjn34vcDqNA4MmDzPEYnEmiPiiyo=;
        b=aD86fSBGeFZALnpuGUIb56yWhqnlObMVvgubn/813rvga8uEQGOWfcU4rrAMehekTH
         XfpmD/pZpFkOjSUoS5/VYyYEmEe4Hpq26ojJAeJSYAlcYlJUZHMBjxw88PmdSqt4kHZ7
         mHC3xbJjpTFKPBxPErKIv57wdKg0STH7mHlPupjz7NYI9ZRz6rlyiDK4dfal0D04ZWhf
         j3Ly9MfnDv+OVnx0/TbAUbY++AIWD2NqtRSBeZdyog7sI1VoVRa30SCHsmszqYHcpY4z
         xs/ahSgZiuckPfMcIwNdcS9dWbXE0Ez9+qIRJC+c3O6Jx4Zenis8WiUpXSCCswSmXk+/
         72yw==
X-Forwarded-Encrypted: i=1; AKwUvBzRHEzskzx2azzBOFK9ae1dCeoXQ2B8tu7QlM/4oIuEX3Q84m7EbGiVZCrmCUHEMTQpRTbA0HzacCeh/aplMA==@vger.kernel.org
X-Gm-Message-State: AFq9FYItke/zeYrPtcOhabjHNl0yufbb4hoSl1ZyoIJCZ/xTArt5XuvI
	bh09a1VWkaf4VDItTgLALTc4vyQmNQjQDWjBuPDsLNx3ypvGRXL/vJqpstw9J+Iy3X0=
X-Gm-Gg: AYBFou2lwGxHeR8E6JLTaj842+hwyizkx4zbV3GC9hnZ4X1QiMkNO9tIypAznwovyTs
	vj6ovVQeka0epA76A76fcfczI6lXWQBtkPZ+rEEobp7UQhZuBsjATRcwlnvoX/QttihJsdEXsiv
	uouAVPZoIsOkt0VXx+lVXVBu/XQBL463Lmo5+lnfHyCdxvHgURh/I/ZTA5L7lOR5QlPp0wXgFvb
	SsI/WlLCBUEwRYjErfTORA45A2B3SeuCjjHt7M+3NiN23ch91+Kiw3FW04pnTEtBJkPZtazIxXI
	jkq8Q9ioMY0tf/S2/epz6Ou1bLDzAJg0oD8ETuAYdfzIOqViqFbfw9T6x38un5oP9csAQz2gr9k
	fQ1ydE/g+XoT9k5rjVk9g76BaT1aDf6Dm9B7M9ZDS821pA4Dg7WpKqs0shYhaWPnIKtiV5PEc5W
	7MQAkkn5G7Zl1pE+TdTtt58wqvq5TQFg94AclNmXtKUUOiSdfrxAWH4Rmwpn2E1kn+hLTmwfvh/
	v3WGQ==
X-Received: by 2002:a17:90b:3b91:b0:3ac:bfa7:b079 with SMTP id 98e67ed59e1d1-3acee97ab0amr8126582a91.7.1792457443246;
        Mon, 19 Oct 2026 17:50:43 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3b16c2asm8520499a91.2.2026.10.19.17.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 17:50:42 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 3/3] wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response
Date: Tue, 20 Oct 2026 09:50:27 +0900
Message-ID: <20261020005027.1105121-4-yhlee@isslab.korea.ac.kr>
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

nxpwifi_ret_11ax_cfg() walks the TLVs the firmware returns and copies an
HE capability into fixed-size buffers without bounding any length. A
response shorter than the fixed part wraps the u16 walk length, and
header->len is used as a memcpy length without being checked against the
destination.

Reject a response too short for the fixed part, reject a TLV longer than
the bytes left, and reject an HE capability that does not fit its
destination. Select the destination buffer first, by band, then validate
and copy that one.

The lengths come from device firmware, so this is not a demonstrated
out-of-bounds write. The driver has not appeared in a released kernel,
so there is no stable tag.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 49 +++++++++++++++++--------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index 16bda167fa66b..be38a034be325 100644
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
 
@@ -212,34 +212,53 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 		return 0;
 
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
 		if (tlv_type == TLV_TYPE_EXTENSION_ID && tlv_len >= 1) {
 			ext_id = *((u8 *)header + sizeof(*header));
 			if (ext_id == WLAN_EID_EXT_HE_CAPABILITY) {
+				u8 *user_cap, *user_cap_len;
+				size_t user_cap_size;
+
+				if (he_cfg->band_config & BIT(1)) {
+					user_cap = priv->user_he_cap;
+					user_cap_len = &priv->user_he_cap_len;
+					user_cap_size =
+						sizeof(priv->user_he_cap);
+				} else {
+					user_cap = priv->user_2g_he_cap;
+					user_cap_len =
+						&priv->user_2g_he_cap_len;
+					user_cap_size =
+						sizeof(priv->user_2g_he_cap);
+				}
+
+				if (tlv_len > sizeof(*he_cap) -
+				    offsetof(struct nxpwifi_11ax_he_cap_cfg,
+					     ext_id) ||
+				    sizeof(*header) + tlv_len > user_cap_size)
+					return -EINVAL;
+
 				he_cap->id = tlv_type;
 				he_cap->len = tlv_len;
 				memcpy((u8 *)&he_cap->ext_id,
 				       (u8 *)header + sizeof(*header),
 				       tlv_len);
-				if (he_cfg->band_config & BIT(1)) {
-					memcpy(priv->user_he_cap,
-					       (u8 *)header,
-					       sizeof(*header) + tlv_len);
-					priv->user_he_cap_len =
-						sizeof(*header) + tlv_len;
-				} else {
-					memcpy(priv->user_2g_he_cap,
-					       (u8 *)header,
-					       sizeof(*header) + tlv_len);
-					priv->user_2g_he_cap_len =
-						sizeof(*header) + tlv_len;
-				}
+				memcpy(user_cap, (u8 *)header,
+				       sizeof(*header) + tlv_len);
+				*user_cap_len = sizeof(*header) + tlv_len;
 			}
 		}
 
-- 
2.43.0

