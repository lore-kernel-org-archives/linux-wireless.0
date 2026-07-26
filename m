Received: from mail-qt1-f227.google.com (mail-qt1-f227.google.com [209.85.160.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5288B374E7A
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093970; cv=none; b=HgZPH5mRfyUQt8ZM1u8SYQ/WP0VT2JXxH5ydnH0jGDbEY+nzKQfqoPdo7U78DFSlGpBcubnap0ShFBeQeOlNPfQjvXfxYGEE/URmdKJ7eXHo0mYg11VkZCQDzYkRxRRlcg7a6F+ImNWoZX3YwnmQ6iQ1hwQ1Y2gJfdnTIVspFTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093970; c=relaxed/simple;
	bh=1LOZSaWG2uzh/DCffSMH3rPaWMoMWYdMtKwtKAk9vLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkPLMCYi5guHWeQUwz6RkxkOqqUzB1JuLH67heu0oiJU4uq/0Nz620nR2mCQikmr2JfodaOUuIf4oz58zCIwwKrUtXxeJshLhKR9osC1gb7OjyuYc/WRtP3W80tU1FRQOjnO0AbRPDGNQhJbeeLwz7e5h+62sbPJCyq630tzT0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KLDuGO/m; arc=none smtp.client-ip=209.85.160.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KLDuGO/m"
Received: by mail-qt1-f227.google.com with SMTP id d75a77b69052e-51c1372f84dso15045411cf.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093968; x=1785698768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vw8UsAkLTYYubS2GArrnvTGyTO7xTPOjCEXxf9oqMpo=;
        b=WZ9EaSc2gEM+cVh9agJAULP47zzTrWKb2jUlmijZI9LUkwSV12QPogIwdvRMtPBa7Y
         ZQ/KewosbEyS3tBCLP45+grDiHZV/X4j+jzs2RVy3259gkD94SvOTUn89ng9veNffrv7
         9t3rJ76nQZj+sEFdiF/I3oG0iguF8JRsivH6QkDgVusJOVtpHXXSFqX6fz8DEnCnkBhs
         GtTXQLOuPE0Z0Mz5f45j3hOr7mSKQs8cOxvtqWt0fdoaJY+9E1OFfFetpTzqvoRQ4wiO
         dDOIHftSPk1KGfiIlgXGAzg3ZjL7AOfVNfxugFh3Ukzx1iKTWoajQgvwkynxEEsZP6E5
         xZUw==
X-Gm-Message-State: AOJu0YyjjKkrjhns/zWAI6ua9YpEfd3+0kjHEwHCLgeHdah1XkXdnCmp
	9z2XLawNumJr7b6E3WeJKJy0JlU+G+QQ8Sw4ddl9YuufgOKouH3Yv4odPLHA0WKv1CXDvnQ0+PX
	12pdLb+RxDGKudfvhqwYLv6UX+59FAeh/EgbC6pJOr1NRGVX6b/ivABgpzX/9ZXZIVSju9zbp6J
	bniZcV/08OXjdIQiOqL3oN5pLQkrC70unvGu/CYlD1FyzXW24jWCSOYZLZ2BHqF3hv+gqExx0n+
	DzSQ0EGlUUwu07JMtfa0RLPvUAk
X-Gm-Gg: AR+sD11O85sUkKE8KMBXcTmBPyRSYQrrrh44u9z+4Twl2p7j9kVEamxl1E385ubdcyL
	x4ztvyU4wG/DA67/0vatRwgKKJdlgzGySlxXiSOXYPD0c4/pUOcqUK75WMkxkbxBtKJ3lPgdVpm
	W93Gm2lVVwJJUT2Q57XzyMr2J+Vp4rgtJ44sd+HjJ//i74ijwMKCjngB/Ys92WQLqOvxcVEvtEx
	/tp3Mp3GT/jnEkzMJK+t5ERsTCTljAtmxCyCUAi7blAnuQJq6o853qYFD/QfRtk2bN0uw1jDjAq
	jb8UYLgvfImF+UROtd/5SpolNF9HYDrY0KCcK/pGYOSlpN5b+9T3S5XtVvn4TE9mxnKpTYdLxJG
	Wke5uvr5JcZaQC6VoKZrXuW8LHLB0uknjnPqXczG/wqSEHbPLRTmCOAjs208eKAe0T+Kd3VGdBD
	o3NO0jInnF8Aj0g6RWcN3r0ZL7wL8/tTu/6OC+kDk=
X-Received: by 2002:ac8:7fca:0:b0:528:3ae6:14d7 with SMTP id d75a77b69052e-529a86999camr59828591cf.59.1785093968185;
        Sun, 26 Jul 2026 12:26:08 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-907e86f0fa2sm3401706d6.21.2026.07.26.12.26.06
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:26:08 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3811ae55313so147940a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093965; x=1785698765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vw8UsAkLTYYubS2GArrnvTGyTO7xTPOjCEXxf9oqMpo=;
        b=KLDuGO/me+oo4Vn2uLXTfDOVpi9BvwHSfUZuT7rIJqoETdnDq0iBS70ZrtdItuZnCR
         8bOeTIgP/dOBXYXveCXVcZkQfoXvF8HLCPNoNVHnytIOqWv3ucwa/Ny7C2ICHAKCbKLr
         XDxJY+gZUlxFuxQoxVgOGp4e2v+Tm6oD8OgFs=
X-Received: by 2002:a17:90b:3845:b0:38e:5ac1:9517 with SMTP id 98e67ed59e1d1-38f293cd3edmr5666633a91.3.1785093965190;
        Sun, 26 Jul 2026 12:26:05 -0700 (PDT)
X-Received: by 2002:a17:90b:3845:b0:38e:5ac1:9517 with SMTP id 98e67ed59e1d1-38f293cd3edmr5666613a91.3.1785093964714;
        Sun, 26 Jul 2026 12:26:04 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc44cb92sm38355795eec.13.2026.07.26.12.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:26:04 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next 07/10] wifi: wilc1000: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Sun, 26 Jul 2026 21:25:38 +0200
Message-ID: <20260726192541.2816743-8-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
References: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
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

