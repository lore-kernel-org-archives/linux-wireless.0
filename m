Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508303DB336
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501332; cv=none; b=CU8cnLD7WUp3ILL9Aoj6KvPFthSsBtd8cjJNtN5KvZnytfOqCNsVZoA4qJ1ybw7lp+Rk7qwhM0O4MCXfW9ZrjMsahXWT7tCXAd6uQfYl5eAWXONnDILFT5ViGyM5LtOMh9h1CqpRbb89wVFOjlAebGjHMWzK2dY7ZwrQOiLM/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501332; c=relaxed/simple;
	bh=hlngVgbt/fHlmZwu9T2OL2Blvz2Y9ykDu2Gnv4uEwhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv6Ghal91Dk2EcahY3W1vG6nKmT3aXt7agAQLCrXEOyVj1lOtu1A9MvS0u6UFqsbGIxcKxb9A3JGB1rgl0tmwltss4oeyFuGhXBjwUzzd+O7eYXGFcVKuTpq0X8R/wuCAvU86QP3jut93mZYotwRM4+SkYR1ibqr1wMaS5Dn/NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cDDlsb5H; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cDDlsb5H"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2ccf2360620so7107425ad.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501331; x=1786106131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j1yh/gFRlu1QTfred31uo8L9p5p5dW7iY3cQ+OXl0a8=;
        b=prSQDdf+Eg/YBjcYElIXZMBkq1C34y3Fda6rh5fBEXsrIquBq9bpQ96CGVO7KXd1oC
         vSB9fPqpSrVu++DuJdiY5g+DNljuCBRAYbWyiXsIfHtByqt88vyafrCUlw/paqHRCxoZ
         7lP7b9HfrQC9/LAEyguFGY8+dUcXKgdhsJn1W3F+0XQzhR3hZuWHfBi4L5NsrrrO4mvf
         OwihIKRT5++HDBhvN8vsKoGX27RFR4lo7AEa58IdzF3KaEenyBWhO6CJufRVlBueZFP3
         yr7dttQF/43Vhifw4ZoduFoz1EdniH/uYvULXr/NRvT41nYEAVcQOtWfcGjXfwXrx1d+
         7fTA==
X-Gm-Message-State: AOJu0YxtbIzwAPt/vCE5BAqhUpo4hbz7tbiC4qCOmFsdHtwsCkvSvaPg
	BXsuJxJvWl64j8xEvBVnPk8p5OTrfpbDVMgn6M/pi9l8gZ1ghrWRz8iIE3wVCLXbMFdWZr2DpPN
	dogamttMUn4320B3apFC33UTbG+LWJebgZ9LwGg6a5Mj8IVzwodSphDHoKQplQsbwUoz/AOIBbt
	R9wyE9X2a6UcqC4m4n6SflTS2wg0vAdr1f2WdKOCYpgAlzBc5JBvtT4dyo0oPltqo3vn5r2/1ca
	CKaWumarFXBreSJkDBi4uKS+cid
X-Gm-Gg: AR+sD125vUSFvI6iYITmfDnCYAbaHE1PUkdIAT9p37kHuhWueWKjhzDCQQFUarGghcr
	6KEn6E2SojwjRo2xAbJSTkNF002qJ3MUoLP0KYIf5T3iW06rK8SvBzdz/KBT6rD8x2c53urjenc
	EDzGAYwNd2WKOCw68bwF9MVfpHyrYIc+cisEH3lQHR9Cz8KF4WJZLucwNSoA5GsbVTjBp+NRBY0
	lqoa0q3nPpZ8QeKTs28Ffco/2h9lafS6k4Dq4XtlLSkH4x/aAvTLX5dJnVvnYfXjqjVOtborc20
	QUE24U4h4Draq943se0foUVoKcCApsyDiJr5K+STXXZJni7xqL2CS+TuMb8NFLtBFQHpTyCOtbO
	2Ef8ysqJllwx7WJMhryVABWJnWUex++XXmUqtgBaQSCbkKYDu8IC8zoouqM3I6doQ/ra/m9q+jX
	LskUGPXBVfpeHqc6IvzsSQKRB4ov/BIfjN46HKNcc=
X-Received: by 2002:a17:902:f602:b0:2c0:b6c7:227e with SMTP id d9443c01a7336-2d046d67890mr17364575ad.5.1785501330551;
        Fri, 31 Jul 2026 05:35:30 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2d04b140f1esm948195ad.46.2026.07.31.05.35.30
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:30 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f283baf1fso948113a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501328; x=1786106128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j1yh/gFRlu1QTfred31uo8L9p5p5dW7iY3cQ+OXl0a8=;
        b=cDDlsb5HriDEC+EMpX2aJiSsdz6vT8QAVzsjKhpvgargXxDgFuNawMHLUontLWI8sa
         le/V0ckzvO7/9vtnFTazKOP3WA9IRnmH4gJlUkfkgQ0W4q+6G1QJHSXVTcM1qVa0lxIz
         u93i4JyfEBC+fzAoUyze88vxpbT5oI+bhpLXo=
X-Received: by 2002:a17:90b:2d90:b0:383:f52b:d616 with SMTP id 98e67ed59e1d1-38fb116d6a6mr1802476a91.10.1785501328383;
        Fri, 31 Jul 2026 05:35:28 -0700 (PDT)
X-Received: by 2002:a17:90b:2d90:b0:383:f52b:d616 with SMTP id 98e67ed59e1d1-38fb116d6a6mr1802434a91.10.1785501327656;
        Fri, 31 Jul 2026 05:35:27 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:27 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 05/13] wifi: brcmfmac: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Fri, 31 Jul 2026 14:35:01 +0200
Message-ID: <20260731123509.1975281-6-arend.vanspriel@broadcom.com>
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

Stop generating cookies in brcmf_p2p_remain_on_channel() and
brcmf_cfg80211_mgmt_tx().

For remain_on_channel, remove the cookie increment from
brcmf_p2p_discover_listen() and store the pre-assigned cookie in
p2p->remain_on_channel_cookie. The expiry callback in
brcmf_p2p_notify_listen_complete() already reads from that field.

For mgmt_tx, remove the "*cookie = 0" assignments in
brcmf_cfg80211_mgmt_tx() and the cyw extension. The pre-assigned
cookie is then correctly passed to cfg80211_mgmt_tx_status() which
already uses *cookie.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 1 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c      | 6 ++----
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 6b2c34e3a796..03a7a4c18279 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5573,8 +5573,6 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	*cookie = 0;
-
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
 	if (!ieee80211_is_mgmt(mgmt->frame_control)) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 873754be5174..5c7a475cb5e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -123,7 +123,6 @@ int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (!ieee80211_is_auth(mgmt->frame_control))
 		return brcmf_cfg80211_mgmt_tx(wiphy, wdev, params, cookie);
 
-	*cookie = 0;
 	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
 
 	reinit_completion(&vif->mgmt_tx);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index c7d7b35ab125..3d7bf25f1985 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -979,10 +979,8 @@ brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p, u16 channel, u32 duration)
 	p2p->cfg->d11inf.encchspec(&ch);
 	err = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_LISTEN,
 					   ch.chspec, (u16)duration);
-	if (!err) {
+	if (!err)
 		set_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN, &p2p->status);
-		p2p->remain_on_channel_cookie++;
-	}
 exit:
 	return err;
 }
@@ -1020,7 +1018,7 @@ int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 		goto exit;
 
 	memcpy(&p2p->remain_on_channel, channel, sizeof(*channel));
-	*cookie = p2p->remain_on_channel_cookie;
+	p2p->remain_on_channel_cookie = *cookie;
 	cfg80211_ready_on_channel(wdev, *cookie, channel, duration, GFP_KERNEL);
 
 exit:
-- 
2.54.0

