Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D6B377EA2
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093964; cv=none; b=KLeVsTm8OQ9cS6n9RuWycNQBOtt6Ho47TeVRkp5sB82gusmAuvJEsMUygV7UTtiVgSvQxdVv8MuHQtflKtK4ZXwJHw9wE9TXbrW1brWCBaYd+BvehhmeNFitvN8mulITQpt1tmuwUVmNJfY3iInd+R6zpVci7OJS576vTfSoKqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093964; c=relaxed/simple;
	bh=jMgvxiK9lmLnOAee+XZtVagqR2BdhpjxqxhBR68zT+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2+x18j+XUeTn3ViUtcTqZCQVOnXMAxekfwpE37lhmCzYaLC/crfHlhNQADEhHAD11LmTV47lYY+B3cIQCK9NtrLpihye+UiDYSc33eJEo9fGlHIzFDjJZ8KyVxffip973tnlin0Ae/QcJFQ2oH4ncta2VZsO6W7txA2/6LJc1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FjlDlFLk; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FjlDlFLk"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2ceaf8a1265so24424545ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093963; x=1785698763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ar0WQnIHDpGHXJ9rIXyWU0tvEfBnqrXceAiqGiwHa6c=;
        b=gXESmxv3U+zqETWcJLbq4ljOv2W+DDlLUugpHjTkwRVd4VgILWFgi0EE1cgLpuLIGm
         z86omVwFqagWQUWhFGddjCA82zejOLeUGkWNYP878S3LV7z91CnzFTJwZwu9+UYobQhl
         GoB9C6SwEd4yT0mkGnBV2w2yS314Gz13jN/O8iL086JvpmVYGGM2BvvGXymV8CRdLoVr
         dwa1Rna/bGs23PyzbXgmY6tSpx03M9L6DmOGlvl2eq4fvazxRp+ud+FICiniYNoS8QEb
         8ha686KH+UuNW/lry/OLl+riQ5/KWg7QnU/ZA0LhBlucHkX41yZU2mmHRnUveGaQcTR8
         MqAQ==
X-Gm-Message-State: AOJu0YyqQearVH6KVKjk1fDtCpdP8FSKULH7hEAF/CLhQWxC/eN0ECM8
	hnUYCf0/uEq1efTIgIZ4tmGbLTdMHRTkYKM8T85HkJiiv60zbz0XyayCDq2TBtg0zMpHtDppHUv
	hIecD8G+W9yVyI2NW2B3XOPuXoFiW3M3CpypXKz0EN97dPOt4oV6Po4VZnSWUDypZNTSRMScoQs
	rjqKMMzR+EsAu3D7FEQ+AvNokvuN1+dYvOiLjlY6kesQztV42rU97B0rH04bQ+MMFihYPDJTtfw
	oW2yTO8F7FllSEd2R8+purxfM39
X-Gm-Gg: AR+sD12LPWQLOrcllNCEJwbEUGMirxH9yC0jp7TOnJrSuaDKqo6pig2DXkikkCEo/Sw
	3PXLIz3YuA4LUUciOjKD74Lxn/YrYaUt53Vy9sD+dgNhwGgaWurdpQCAVWuI5GU4mUGeVlxGgl3
	BCl5BPWywk/UYNXbCooLS92H3Ula9OYaIgLFhePvK8u1bYXqDO2o4Db4d64/9lncSKerzdib55o
	BDu+jKJhsKTSmEBILuc1x3u3w4nMa1ou242HmURAd5SG7jm/x/GbKxS8eNZkJX/we9L29MNkyhp
	cat2SPpONHEBEfbdrOx3ZMLNxkVpaABSGGvo/ytI95t/P77YArWrlAS7vxAVV3QwTWSX912ShQh
	N596U42gxSXZFiRQlksJE+Ob/i2d6g1l7PqF74hO5teAU4Nxtsqz4y/dXbIjDx5mH6U/MX+kthi
	jWd/EUB70kVf8WNIZSGT65SHv2wRyzIjygVMm33ww=
X-Received: by 2002:a17:902:d550:b0:2cf:b68a:2050 with SMTP id d9443c01a7336-2cfde79049dmr54055025ad.15.1785093962799;
        Sun, 26 Jul 2026 12:26:02 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cfde5b356bsm4938425ad.12.2026.07.26.12.26.02
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:26:02 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ce7fabf76so3036022a91.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093961; x=1785698761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ar0WQnIHDpGHXJ9rIXyWU0tvEfBnqrXceAiqGiwHa6c=;
        b=FjlDlFLkv/peDiFIFTY3y6xZB8dX5S3fq1N1noQZuGGSDFkMLkORXDwqf+XrbVa6oE
         18lcJpBbwwdkkzAgVmWXbM2FxnM66M3tu69JT75hAmwfDoCGKxpAWWR535oKYI+w/M8G
         Ss8G4qwR1CmnoqEcL8M85A4tYjpuYeDVUkkyo=
X-Received: by 2002:a17:90b:380a:b0:38e:6aa7:68ad with SMTP id 98e67ed59e1d1-38f293cd2f1mr5774176a91.5.1785093960894;
        Sun, 26 Jul 2026 12:26:00 -0700 (PDT)
X-Received: by 2002:a17:90b:380a:b0:38e:6aa7:68ad with SMTP id 98e67ed59e1d1-38f293cd2f1mr5774166a91.5.1785093960440;
        Sun, 26 Jul 2026 12:26:00 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc44cb92sm38355795eec.13.2026.07.26.12.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:25:59 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next 05/10] wifi: brcmfmac: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Sun, 26 Jul 2026 21:25:36 +0200
Message-ID: <20260726192541.2816743-6-arend.vanspriel@broadcom.com>
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
index 20f7fccd6121..7e0368f6860e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5573,8 +5573,6 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	*cookie = 0;
-
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
 	if (!ieee80211_is_mgmt(mgmt->frame_control)) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index ce09d44fa73c..f0f3a45d7cde 100644
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

