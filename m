Received: from mail-yw1-f228.google.com (mail-yw1-f228.google.com [209.85.128.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC55416D1A
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501338; cv=none; b=PaGfJdGEmS7eIIdZTIhClQoZyvr3VrqFQM3Xc2G1J4HVPMwk2R25WrMGhvWX5CGqIa+l/1Yxffsn+zmgA+2rJSkJxEh4JwMSMB6mhH6vL5PNrc6BFrAP/1Yoq92Rmhm/KupSX4pZLRDrsLR+skCtEadn4nimudQQKbjJzbynqig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501338; c=relaxed/simple;
	bh=wIz+3euQACHcMtzoe/1WVQoQpiunxZW+Fc/WKDXM5WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXWZOQgueUeLs3zAO0Hv9n68KadsQQ1Wegv/JdUn6z5+un01mqEM4vCHhIWyfWGYPpWjig6VvSyUaPAwrngsgwmOf57JUiKyxZf3kT7R9zPfLuQsLc+QlFh496EBxG23ngU0j/xLQwTEFUoNrpubca+CoasywUqRyfH4kwDxRBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=av+iM92X; arc=none smtp.client-ip=209.85.128.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="av+iM92X"
Received: by mail-yw1-f228.google.com with SMTP id 00721157ae682-81ed2a06b9eso8807647b3.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501336; x=1786106136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VwmBr3II+Nl4yIpxO7BvkJDCioVvnXcf67GLy4y8934=;
        b=qGUqJw+WxgqF2cArsL/Wr2BUP3bPXzAJC3mPixy0ikHEZ5E9ERM3g6KE44VWeKNCMq
         lxzlicT+H0HC3aoCpf5VFRR+MgyqFDBo9xi1BQLSfchCPXfiiYVF9N1FfYEGDJKDfn8W
         /5kPX9ujhh0yzeglXzCqkvOqjuCv5KFRJ6rJNAYNBK4w1QYuvFyC0xPvAemXi/0ifrTO
         TVYprnjs/L3pv+qIrCBs8yzse5awEHUtPmmypgW8M0ai7PwazILPhI7SoDKRLmuqVxpA
         KsQSTHVxr4yPyOupIU0X6+bMc+Ko7AI92H1wETtdNI8nM8Kv4iGHbYwktHELs7DtmF9U
         g0pQ==
X-Gm-Message-State: AOJu0YxgHdUFOglqsYYTEcpDFd3ibcGJqWe8taftghKAzTm62D4CXSPy
	P37/+U5G779Td4335PN3t0MANUAn82+EXGgAb/YdlG7gMAFVmAW3wc0YKAKwuTbGnLZVAuJR05b
	fi8sdN8pkima70FClOiMhViKY+CvNSLSV4+XaMiocp/qOcMJbOHi4TH3EyRJY/iIHHjIC9WbiuB
	itKnf9HoH/uLTlUiL/XUFM6wS71Kf7xGB5r8l+LPtK5aG0Dv8It6J/c25JbYEpfEfWy9FBRdv8t
	YbHyc8e/KdiOnxZh/8GOmWpp04+
X-Gm-Gg: AR+sD13GHBhYXGkFt5k3/voVOSfTxsUaU7hGXwta3Q0qeroAJbvT1Lon5MgoYtT+Ia3
	ekOn5s8iD+PPlyCQiEJycfra6YCjWbkQ4+cw6dDiHWCxFWsUKJjqpyLkFVpct/0gEDIkfG1XgP0
	Xfz+chzF6H3IT47T14rbDV50hI48L0dJh3g0E4jwrZdy3Pn05YreDiEYWDOZj0aXjQn14upmwze
	CPf+hNo22eL/FFjLti/wYpoqZH/vNnE1Dy7CP2DdXuFkm6E9U5DHPUSX7yXDDed0E5H1w4Xqx7G
	k1wVMwF0a/NwPJbgbW/cql32i70mDrtlZJgJRTgWWzYKJ4NK9wzi0GaL4ciXf1DClzr5rl/iHaF
	Oqlyoy+JKgIK2Kst6VqYqRiCp4Bdn6aLNmBVlnbl5xWPRUDWjbIykqQZAeHhtD4ecfwbbMDccgt
	+3BUViVA03ruTYAhcOWHU9YIaaJdhYfuIO2VuSwvI=
X-Received: by 2002:a05:690c:278a:b0:80d:ab06:cb64 with SMTP id 00721157ae682-81fcba55e12mr17123017b3.8.1785501335997;
        Fri, 31 Jul 2026 05:35:35 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-81fcd0ae036sm564427b3.17.2026.07.31.05.35.35
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:35 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so1231301a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501335; x=1786106135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VwmBr3II+Nl4yIpxO7BvkJDCioVvnXcf67GLy4y8934=;
        b=av+iM92XzSqCruBbsT0wEnxPPyM3xSlYBpXMHAho1Ts54UCmQaT8s6gqYJtmhsBs5R
         hpCGHF7kNEobtVBSolzcp7IWBPjVutrFQ8yxSKzoDetNnmXfmZftujrMJjR5L3ftEPSC
         LY+d55P3neW1FnGpFKsSmItlJJ0lFcmNGNgvc=
X-Received: by 2002:a05:6a21:398b:b0:3c4:147e:98f1 with SMTP id adf61e73a8af0-3c91b1b787amr1737812637.31.1785501334822;
        Fri, 31 Jul 2026 05:35:34 -0700 (PDT)
X-Received: by 2002:a05:6a21:398b:b0:3c4:147e:98f1 with SMTP id adf61e73a8af0-3c91b1b787amr1737788637.31.1785501334371;
        Fri, 31 Jul 2026 05:35:34 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:33 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 08/13] wifi: nxpwifi: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Fri, 31 Jul 2026 14:35:04 +0200
Message-ID: <20260731123509.1975281-9-arend.vanspriel@broadcom.com>
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

Stop calling nxpwifi_roc_cookie() to generate cookies in
nxpwifi_cfg80211_remain_on_channel() and nxpwifi_cfg80211_mgmt_tx().
Use the pre-assigned cookie from cfg80211 instead.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 4f9e20f72811..198174ac754e 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -212,7 +212,6 @@ nxpwifi_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	tx_info->pkt_len = pkt_len;
 
 	nxpwifi_form_mgmt_frame(skb, buf, len);
-	*cookie = nxpwifi_roc_cookie(priv->adapter);
 
 	if (ieee80211_is_action(mgmt->frame_control))
 		skb = nxpwifi_clone_skb_for_tx_status(priv,
@@ -277,7 +276,6 @@ nxpwifi_cfg80211_remain_on_channel(struct wiphy *wiphy,
 					 duration);
 
 	if (!ret) {
-		*cookie = nxpwifi_roc_cookie(adapter);
 		priv->roc_cfg.cookie = *cookie;
 		priv->roc_cfg.chan = *chan;
 
-- 
2.54.0

