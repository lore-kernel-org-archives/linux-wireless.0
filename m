Received: from mail-qv1-f97.google.com (mail-qv1-f97.google.com [209.85.219.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862DF2777FC
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501336; cv=none; b=nu1lpdQgm5ugRmFSIm7oQAFDiO0nUtZYNvC2V2VpyWEksm3SQC+88DPSFrTnmL8LSe5TLLFlUT2Pmif2xqkhZsp92Iuj8mB7n2/x5XIf3CY+I7A90oin/HVz7HQ302AFDRg9KouGW+jgjOv4+CKeS7p2HNxO0cYPJMUsK52yV1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501336; c=relaxed/simple;
	bh=1LOZSaWG2uzh/DCffSMH3rPaWMoMWYdMtKwtKAk9vLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GG8a4Nk75RnuHqtADxnST+3rXfO0BWg5rJaCEABLzGsX2SRFK2bGhiIIHdf4qaJ8+NUO3eZV17qaHxKfEhhPj388ZV8wpPu7nCeDz8QyJT+G3n+KTTDUGKscmwlwZ8vo+LfNnqzg8XbpcQ8gO2PU6B2nXa0VSdRZkvC4JaRys1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JwXUfGdj; arc=none smtp.client-ip=209.85.219.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JwXUfGdj"
Received: by mail-qv1-f97.google.com with SMTP id 6a1803df08f44-9061a795d76so8241496d6.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501334; x=1786106134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vw8UsAkLTYYubS2GArrnvTGyTO7xTPOjCEXxf9oqMpo=;
        b=oWDw9cB3X9fRC8gUjqPcSo3ikLDHWguHFfnfvsFZNRTf6B5Sml9JEqoyB/CRZfd4qP
         GUfadmFftYqKaW94tUFLZNwIChw+w1mnFtREdxZem17Xo4cGI5Uro7r6e/W2rDa1kVtx
         5g4u2QJrscisHGuGrlkgD/7k71iCDKg7XbuqwgjwFDyy5bzhQ3SLAucMAWWHJkcon8VA
         18sxh8bgVceUS/cisNXR6wky+t+JIpZmfDcCwKo2fBr11tgKkp87ABLhFd3f2kHhMnpo
         MMbOPrB553IWpGzllqBLV8XXZ+kY+lC8tqYKl4zr7d56eQmADADB42SFrfz3HK+Yon8b
         w5nQ==
X-Gm-Message-State: AOJu0YwmKhjMUbcmEvLVgNTgCU5fLX5TL9cyC6oP/6dabEL6PXPLTbLx
	S+N5bxlZM0JefPXszmOIBSWbJk1cCmcQzfUEpYNrou+ueUYzji7XP0qtVbbjLI6qbCF/sylsmOX
	Qz3hJfMplXfnyKum09yEd/EVl3RR8pOyn0V2s0ssyocaU5RC3i5rFkZeZEShNAGFCtWXix3OW5P
	vRqyp8sbE/OF3OXF0QF7aAjQYdtxaLEo6mZnL1Cb7gI9bKpHfwf+DLBzNlgDnMZQLSRC9db8y3b
	P1/vS9w0eGOPmRaFcJVUKestlkW
X-Gm-Gg: AR+sD13yyZQR0Q7a5orKe7p4z/s3bS/61MhBkTWZIWuqqFwn5hTv7tkcDerlGXW7tIH
	Qv4OrT+gAFp+UF0pcepaAVBw3JGTUiG6y9vB7Dx/fdtvgoc1eHeBK9R+CT0kAnbqMrJN84UwU+q
	qc6mCz0hQchtfE5S2owYxImFPsOMkTSFNVhfL4gZAa3agUWy5wzeCuuS0GzxSejWoCKjSX5r4av
	ML6M6RyU2xs9SF5cfRHfpecl9roB6RR9H3Ivp5lzuyHGR2RR9PISrMpJJaCsul2JKPxzNjuEceQ
	7cC/u8ntYnqy0E1JK7X3MEvVIfi/cw1YY0KVfPFvkjNYS/Doj6WvjkBZxhWjhNDwcmzxTR4ps8B
	poNL0MqKrsmjd0eylqgdbvTaCoDHDqt04xjbYiyuameI1SoJGG8d+sS7dDg1FA3yzU81VG2/bTj
	6wk/ddUV8ryNlAKi72hgdWOJ9zYndQAk0+vooqWiA=
X-Received: by 2002:ac8:7f4e:0:b0:51c:2685:2964 with SMTP id d75a77b69052e-52b4b0fc53amr25244831cf.43.1785501334459;
        Fri, 31 Jul 2026 05:35:34 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-52b4e7eae62sm561011cf.3.2026.07.31.05.35.33
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:34 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso923503a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501333; x=1786106133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vw8UsAkLTYYubS2GArrnvTGyTO7xTPOjCEXxf9oqMpo=;
        b=JwXUfGdjZnPry/bEDmvQ77aNGNE6HIymbB1M6eBpmAeAZ96L4TLQ+JNdBw8VUMIppm
         4UlE5AeNJnvVs9IqxmGHQ23/Dht0E4o9don6r1RNBkekQ8bSs2mDSQiSF0LlQlmNbh7k
         nilhMVqIRg+f0w9h6KToG7wa+ZFfc1Mvf21So=
X-Received: by 2002:a05:6a21:6b0f:b0:3c3:8b83:f19f with SMTP id adf61e73a8af0-3c91b3a9af8mr1840297637.60.1785501332786;
        Fri, 31 Jul 2026 05:35:32 -0700 (PDT)
X-Received: by 2002:a05:6a21:6b0f:b0:3c3:8b83:f19f with SMTP id adf61e73a8af0-3c91b3a9af8mr1840273637.60.1785501332337;
        Fri, 31 Jul 2026 05:35:32 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:31 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 07/13] wifi: wilc1000: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Fri, 31 Jul 2026 14:35:03 +0200
Message-ID: <20260731123509.1975281-8-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Stop generating cookies by incrementing inc_roc_cookie in
remain_on_channel() and via get_random_u32() in mgmt_tx(). Use the
pre-assigned cookie from cfg80211 instead. Remove the now-unused id
local variable from remain_on_channel().

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 6654fce4ded8..7c19ad34fda5 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1106,18 +1106,13 @@ static int remain_on_channel(struct wiphy *wiphy,
 	int ret = 0;
 	struct wilc_vif *vif = netdev_priv(wdev->netdev);
 	struct wilc_priv *priv = &vif->priv;
-	u64 id;
 
 	if (wdev->iftype == NL80211_IFTYPE_AP) {
 		netdev_dbg(vif->ndev, "Required while in AP mode\n");
 		return ret;
 	}
 
-	id = ++priv->inc_roc_cookie;
-	if (id == 0)
-		id = ++priv->inc_roc_cookie;
-
-	ret = wilc_remain_on_channel(vif, id, chan->hw_value,
+	ret = wilc_remain_on_channel(vif, *cookie, chan->hw_value,
 				     wilc_wfi_remain_on_channel_expired);
 	if (ret)
 		return ret;
@@ -1125,8 +1120,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 	vif->wilc->op_ch = chan->hw_value;
 
 	priv->remain_on_ch_params.listen_ch = chan;
-	priv->remain_on_ch_params.listen_cookie = id;
-	*cookie = id;
+	priv->remain_on_ch_params.listen_cookie = *cookie;
 	priv->p2p_listen_state = true;
 	priv->remain_on_ch_params.listen_duration = duration;
 
@@ -1170,7 +1164,6 @@ static int mgmt_tx(struct wiphy *wiphy,
 	const u8 *vendor_ie;
 	int ret = 0;
 
-	*cookie = get_random_u32();
 	priv->tx_cookie = *cookie;
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
-- 
2.54.0

