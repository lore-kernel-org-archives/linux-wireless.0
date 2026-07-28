Received: from mail-qt1-f227.google.com (mail-qt1-f227.google.com [209.85.160.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46148449B22
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249976; cv=none; b=KmpM3NoSchSIQMazoYUuaasK2j9eB5w7vAfml2Abfxhd1/Atsjs0K+Dii+u9+zVMi9eI3xeFyDsSQ/pQQZJLpQv/UblhengGxhwPNqFTvI8eeKvGS/kSdnLWIRL9hrn09b6QvHqI1AsEdUtG6anBEAsdtNT1vNxlRh5P5yePyI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249976; c=relaxed/simple;
	bh=wIz+3euQACHcMtzoe/1WVQoQpiunxZW+Fc/WKDXM5WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJnig134NGyrV6KID/of64d8+QCs0cisWaUCNuokHgQn1Vn4Dupe5P/Q198xgAO+GmQFAY3qn41BmB6VXNUld66V05rz3DTKRib7clN2CssbCFWbTNO9k1Xj/WGXXQ6cvIkg817f1/1eWQTNfINw+/IQLEt2haLNGBzswiCbMVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Jr13gp7O; arc=none smtp.client-ip=209.85.160.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Jr13gp7O"
Received: by mail-qt1-f227.google.com with SMTP id d75a77b69052e-51c01089e8aso26138901cf.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249974; x=1785854774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VwmBr3II+Nl4yIpxO7BvkJDCioVvnXcf67GLy4y8934=;
        b=VhMBA/L2vb6yP3qKjGTQNyCGdv6EOyyRHTJX//rcdAITIm84O9Ny6FiMyH7Fz8+M+C
         cpDbRLt8oxF/tXSEw5MnMB0rw7NrEyqj8MEvdIfhXgWYysLNeZtEICIYdpDSlbERpL6s
         PJrQ6Juk38cVWx+lv2Lo5Ve0dkqVvPOBFYenHSsTIIPHis/hM5Z+fudaiSK1pY6LePVf
         wJA7Z+B2F9Uebio23zMIETBqQGeTre+LxFk5m8y/CrC+09RhN2b2HKtSHORavq4OFQgH
         pDgBAB395h19gfbUkYkduvaiubuWk5oba6gNd4eTUSf1GUhu8XWfrmdZaUxh1nfXStp7
         X8Vg==
X-Gm-Message-State: AOJu0YzaJYyJ5TMvhh79ZkJlO0/xr6496Y6CliGJXe9Gi2oGzpGv1wA/
	zRPK7nYRBsRoLjTQtXvAn9HChJuN8Dig9rnnWdnnXrJOhxxKYrqbk4FLahKxCthIKE/A0f6dS0K
	uwFpuyNdcb4msRCBS9+AYc520nfWq9UpQPuBrKYAjVj83VEUFX9z5C7lSIP7baDzp7/b2oL2uTG
	6oek4vRpxh3OktbXeqYDiPkJaBoh2q2qovPgysjQIZJWQHIMb5f/BGuTPflCVjlAvvfW0cI1Z9z
	ztMUYwwELTdkmlNqNqBOrnRoeWT
X-Gm-Gg: AR+sD10Gxvev03d8U2e4xXQwFZCjTMUegHkLlV1B9yI82dxDpoCLFepvrI6/+ujCt+V
	WDL53ceqx3LMFy+J28aCfJU5RetPl2oPWigUIJiUFTFI5utu7QDTasGtS2LL++72P9aD5SYy+/2
	myJoGDHQFRoL+atB3aIyT1sJiTx7wD5ipBls7aXjWpNLKbjW4zfgfWG3pNHXsv8l6NDvL9v7+tE
	zMpTohV7bUCiATczDP5a91pTB7UgESdpGzSGYM6uZ0yUO6vl9X6vKwfPzb7KRVuMXcjr/gVRTQq
	A9jicWMoWIbembtaIZnc/6uXBUPLmgTPhXr4s2OS23+JzbAJ++QrVFB9SfdwoksejHr6Z2ttduD
	UExGVFvxpiEWcIwvxk9AaDcl4ptl6t12qxcbJYvIWrAEM6qltUPLxaEjqtgMifoozhLGd5IQHQb
	U9V3ROebIx5qbyMuj7zXly+ndDed0cdBYhsu+FB78=
X-Received: by 2002:a05:622a:305:b0:51c:1daf:196f with SMTP id d75a77b69052e-529d7217c24mr24610941cf.58.1785249973883;
        Tue, 28 Jul 2026 07:46:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-529a27c625bsm2300021cf.6.2026.07.28.07.46.13
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92ec91dc265so360580585a.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249973; x=1785854773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VwmBr3II+Nl4yIpxO7BvkJDCioVvnXcf67GLy4y8934=;
        b=Jr13gp7O/iT9f0ekjpoq+3yPYMyAhu1oJbI+v4WYaGJsYkLn/lausdvBaL+3fzbWtP
         jrM2Lq178dTfDJ+5+qDtiie2EYtMoz9sdKPWA4Fk40JTCuGMcem6MzD+2OJJL2UmSZl0
         mvxN0zLJvIdDLLZ+KAlZxIjSEeLInnGquRd/M=
X-Received: by 2002:a05:620a:4622:b0:932:dd83:c54 with SMTP id af79cd13be357-933026926bemr254650885a.42.1785249973086;
        Tue, 28 Jul 2026 07:46:13 -0700 (PDT)
X-Received: by 2002:a05:620a:4622:b0:932:dd83:c54 with SMTP id af79cd13be357-933026926bemr254644485a.42.1785249972438;
        Tue, 28 Jul 2026 07:46:12 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:46:11 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 08/12] wifi: nxpwifi: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Tue, 28 Jul 2026 16:45:45 +0200
Message-ID: <20260728144549.2207061-9-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
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

