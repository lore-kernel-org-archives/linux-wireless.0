Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717075013CA
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 09:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860357; cv=none; b=qGgHFldvjHQVcc1QrFqdPa9ccW3O/wzfCBDxQ5bTma5oxLZ83I97U5PSBVSzdWkj+TudqPbCpFmrOWswla4eWlLikYEQOQaqGAbdpzc8AASNAWVqAOzZ3xT1P/synaoAg6hg26fAjpUdLX24NuG4RFk8OO4ByBwfT6Ss5j5Q/i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860357; c=relaxed/simple;
	bh=4Sbr75c0abt10xZybWlwcKOCX9shIU/NqqpX3auH90Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q0OJofM+5h8cHmAAVVhYWLht3as5O3eASfi2VsNuRO4DoHSj4j4iU/FRnJ2uDPEIrsVJf4N3/sWAVEqY/KwsR/InyykokUJWP2I+6fboyXnePxVkLs/rjrMLH9RZWwosJ5pxItUDSEgOY9zQA+qBTSY3vms2nTr9dmCa2BiouY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oPffJ0S5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oPffJ0S5"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d91ded8174so34102695ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 02:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788860355; x=1789465155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4UaQxBJSfqPaQYKAdjMuukZ2PpCv6cQKQMT0AYXy5/I=;
        b=oPffJ0S5R4JqpwhDzGxlk24N1dJNWu5XIO8MzvAuQt8pnqm1ri76IBqjmlkD7pm4ew
         +fz8Nbq56PpV+NDHHn/Jl3Ij1i2hy8k1YlygOZ5n7m3iBSn0pHRAfII1/wL8VLiQQAQ5
         vFyyGZQLXFtLn1cTMEWkYKg1OUVZJnhbyRBJs1WZ/QWmeu0PvzfhOD6jocp56RIaL8Mv
         MjGYVB1z3IhWngkQtOtwISroDILA5wBKWcMwiMpPozEg8l2TcNl0bg0hS+SGvN1y/uTE
         Sa6204ILohs+qaCgMol6j8DP4x/2o5S6EMivqh5CgzZwEVypJBUdBDNInCx1Z4x7ZeKH
         zylQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788860355; x=1789465155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4UaQxBJSfqPaQYKAdjMuukZ2PpCv6cQKQMT0AYXy5/I=;
        b=WjlywIbhTujfWYBY+OhowV9nV8l3/eNtPqMfci8NYBM2uNbP/MS4oOTdBEOdjtVQ3c
         7QV+VVdKD7sf1aRf44G2mLMJ/RxGpBaiZ2WkvenPSamvHZMPvkLvpIaf+qxHSDCskrgh
         /Qlkod0wvYx4dcxFqY998QiiG27fwzJaSShqUuxdHvH2CuwcIpKMb31EHlMBmefpC4YL
         7BfwlSCznv2zCMXwS9sWxxXXpEmI1gYac3LYUfK8qIPvjmKRL9/VgscaVJHm0OjCtQIq
         SpjlEv+MT66uzZR/zR6v3wEEbct9POqTXnB4GafYS0OitbJihuLXqBqOs5dr+6nY7mRp
         tUbQ==
X-Gm-Message-State: AFuF++lRZ9M0VAXjypC6wC4wv/B9KoFiROPtNqtIVJotZiOxKrFSKbA9
	GnyFJgXd5S7J7jAGhlGN0BzUhtoY+mkAPmaVY32+jmiClM3AL7IAlZkrfs+EIaDD6IE=
X-Gm-Gg: AYBFou11l/ADR7Q3WHlNPDRDWI6Zt1IoXAOClsWnapVjHZjDu2n/X5g0VljtAeByVqH
	HAvLXmFy1+Junj+mFtrwwmBJevA62JpYk0gVP0a+xdHdDvo2P9Iq0BhcpkDVFu2XC59TDF51vOs
	C3gapApmaNLxvJF4Cf2hl2DJQFtvUmiWxPfJxxJcGpluhnVomDj+smpZdUICXKt2juDbR4yURcB
	NCMeUhhF8NQOAK1b+HKpzIwD0YcsbeLP1kXtdK8cJ5V25y6nyN6izWm74CxZqTNVlF2XnAGBRl0
	m8cAuTnakVUyf1Mt8XfPntkEBilGlnThANud2djm1nCmioCdpGU9AD8hAyKVdTcmUuR842MktGG
	llg6nf4emY7Cj8qlkYYTuZIiwPRxGOP59lYcQTDhJiQtTKKLENHeD0idpagCrGn8wiykwKO0v5p
	CzqFIq26UGVIvnXPGCZLVVx2OQ9n5QRUEp73VCBxqAqGntS9zcIy1wsIIVFOoePXBO+yYM6bQm6
	i6ISs0xErB0hnaSOwmRZvcNSSj+TWIaeT2cW4GI7dFvvq8bBvgt2oJ0z5EriU+bqyIQ0mht7Yiq
	+g==
X-Received: by 2002:a17:903:4b04:b0:2d3:160b:c01f with SMTP id d9443c01a7336-2db124b1ae2mr384628815ad.6.1788860355450;
        Tue, 08 Sep 2026 02:39:15 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (114-25-99-144.dynamic-ip.hinet.net. [114.25.99.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d9f9sm54848085ad.32.2026.09.08.02.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 02:39:14 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	linux-mmc@vger.kernel.org,
	Ulf Hansson <ulfh@kernel.org>,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH wireless-next 4/4] wifi: nxpwifi: Limit channel width based on firmware capability
Date: Tue,  8 Sep 2026 17:37:58 +0800
Message-Id: <20260908093758.596444-5-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908093758.596444-1-chunfan.chen@gmail.com>
References: <20260908093758.596444-1-chunfan.chen@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Chen <jeff.chen_1@nxp.com>

nxpwifi_cmd_append_11n_tlv() derived the channel width solely from
the AP's advertised operating bandwidth and could request 40/80 MHz
operation even when the firmware did not support it.

On 20 MHz-only devices such as IW610, this may cause the firmware to
be configured with an unsupported channel width.

Check firmware bandwidth capabilities before selecting the channel
width:
- Allow 80 MHz only when ISSUPP_NO_80MHZ() is false.
- Allow 40 MHz only when ISSUPP_40MHZ_ENABLED() is true.
- Otherwise fall back to 20 MHz operation.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/11n.c | 4 +++-
 drivers/net/wireless/nxp/nxpwifi/fw.h  | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11n.c b/drivers/net/wireless/nxp/nxpwifi/11n.c
index c2a54d781b42..a83e29ecc466 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11n.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11n.c
@@ -349,6 +349,7 @@ nxpwifi_cmd_append_11n_tlv(struct nxpwifi_private *priv,
 			nxpwifi_band_to_radio_type((u8)bss_desc->bss_band);
 
 		if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
+		    !ISSUPP_NO_80MHZ(priv->adapter->fw_cap_ext) &&
 		    bss_desc->bcn_vht_oper &&
 		    bss_desc->bcn_vht_oper->chan_width ==
 		    IEEE80211_VHT_CHANWIDTH_80MHZ) {
@@ -359,7 +360,8 @@ nxpwifi_cmd_append_11n_tlv(struct nxpwifi_private *priv,
 				((CHAN_BW_80MHZ <<
 				  BAND_CFG_CHAN_WIDTH_SHIFT_BIT) &
 				 BAND_CFG_CHAN_WIDTH_MASK);
-		} else if (sband->ht_cap.cap &
+		} else if (ISSUPP_40MHZ_ENABLED(priv->adapter->fw_cap_ext) &&
+			   sband->ht_cap.cap &
 			   IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
 			   bss_desc->bcn_ht_oper->ht_param &
 			   IEEE80211_HT_PARAM_CHAN_WIDTH_ANY) {
diff --git a/drivers/net/wireless/nxp/nxpwifi/fw.h b/drivers/net/wireless/nxp/nxpwifi/fw.h
index 188110b020cf..124728a72442 100644
--- a/drivers/net/wireless/nxp/nxpwifi/fw.h
+++ b/drivers/net/wireless/nxp/nxpwifi/fw.h
@@ -334,6 +334,8 @@ enum NXPWIFI_802_11_PRIVACY_FILTER {
 #define DFS_CHAN_MOVE_TIME      10000
 
 #define ISSUPP_11AXENABLED(fw_cap_ext) ((fw_cap_ext) & BIT(7))
+#define ISSUPP_NO_80MHZ(fw_cap_ext)      ((fw_cap_ext) & BIT(8))
+#define ISSUPP_40MHZ_ENABLED(fw_cap_ext) ((fw_cap_ext) & BIT(15))
 
 #define HOST_CMD_GET_HW_SPEC                       0x0003
 #define HOST_CMD_802_11_SCAN                       0x0006
-- 
2.34.1

