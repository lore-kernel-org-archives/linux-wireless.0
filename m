Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197133;
	b=m8KLzvujJkRV0LYpyNZDqFvoDVQ8MFPhLGTQbFftB5fEddtfrpmNR2S7GRixuugkF/Tp
	 8fSWF2p81vNoGLEZz9OL1YlRTwHwJj7wwIo0dkXu3BgF4SWB2gZRT1GxublYPWk+dgwwk
	 euaiEgr5cBXPz3TuGiLjNlai/U1VFrm0P/bDie05hxmGb8s8WBYXnD7d05hvxYAVsdoZe
	 tDJZEjuVh3eiDZE/+A3Fde3sOqjP2IWQv4CYXWXtf41TRc4/O70ZjBUgpCLX2WsvRow9i
	 FwvNnFk47N2mBrjPCb6hWIIyUghxEqxZo41BjNt3HnCIMbeDyswcDHFevwp7QXvwk7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197133;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nFEfZnQ59TpCZnJvhgBJzEp+yfYh6wGlCUPMkB3MYBc=;
	b=SfTdrOKhIPe4BW4v5f2INLNN7g6JC55zLxXvJQ2UqwaMKgDA5Xsi3USgI1A6+yriEjqA
	 ONCqGLhUgjsw7vFVCwFxOj0TplVD5zf7Qp2osSjkBkMJpJGl99KuuDKd3kxe09C8poT5s
	 KNfycDKJwyYxMG+f925sXU/tedLBXX6kDtxdQH3C7qVefe0yE5rTdSOYYKRiL2P3XQvfe
	 2qK510nylrMzNBRBFVOq+pmBG//7NqtzJGsXvIA0ENkTy49dkX2xXHzW/6EYGg534D0AD
	 0A85iBc8WyOPJKVw8BU/9n0NrEf1yVYVtnEnWcVcjT8UNsfwKobTrn59+FbRk1j7WFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RjLQz0ze;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C49D606A330
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C49D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RjLQz0ze
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso453998a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197132; x=1793801932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nFEfZnQ59TpCZnJvhgBJzEp+yfYh6wGlCUPMkB3MYBc=;
        b=RjLQz0zek60zgNWMOUzt+E2a1xXdBEOiVCxWA/FFoRh3FoUS4+hOiT2HP3gcy8Kvux
         PrLGVghaH9/X5IesZxXXelQwMBw23TpKdfAm5H5CNTED6rtMXS+MDaFBoWDcEriTyU3X
         421a2sdHC6BR37TyAyTU1M26ctJlzFHYvxKFbVxnoaER08bJLunZh9kh3b/UY+IjdsFU
         DmrPpA2BejTH1SQtFJYaUTx43Wre9yYyVqDjcLyp3PH58lMGu1ve46GKjhzXVXJg9pGj
         PuhME+NL8nnXJW/SI/NbjncgvmKw4C3+eKf9NogEbuvwpeYA430D9zLKqfjca6lcV5AW
         mAkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197132; x=1793801932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nFEfZnQ59TpCZnJvhgBJzEp+yfYh6wGlCUPMkB3MYBc=;
        b=0rABEVtkOmDqBP2kbfE8Tk8Jo6L+eoTkv0fh/L+obt8TWelfKHCXbq+7HIUGaBvuDi
         udFDojtNg7zXsY/nCjI8CEFijk79EVImd59cUGsbk6sAX3GAX41pIYos8lqhoajvj31Z
         Fx5hCfvaq/8OYKItoiD8GTv6BQdjpEfQgUUGXUeQgbVZ085+/JXnKb9cFUQjhdaPPRm2
         fbWFCheN7No4ZehOiVbLxYfqHP0w5WB47xkmfvCAZS30NYMKzeCcu2If/5pp2gZYZOzr
         FXYth5tJShc1+8nPHxkfNt8fir0UYrDigvC2g1JuzipTzXm+3z1ZNaoeTPN58nAS4tZn
         Oo4Q==
X-Forwarded-Encrypted: i=1; AKwUvByv26NnE10gWOXRMs/xlLfGFTQzibpTKFn8zWi6gLiCu4iVD13WezY+JV+0YkKo2d8Sj//VRNJyckJjePzDZQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLui3NdsyJ6T4lmsmR4Np7O2L4di6wq1WOBTQ8X9E7zN1eCGMV2
	+nwUhSfOnJc7UT07vLNg3kXPshtHOdDduxFrg191TTapWidQiUBKfF9E
X-Gm-Gg: AYBFou3NXMAs+PIRK7iEG1EGUiNWaqEJQPgxQvyaywY4RwcKiV9LapDbv0wuY7R6zjs
	81rlMW+O4umEH1wM1Jy2TBv0HxqW907fsYExIF+znmqj6AvZQdBrYwo1fjflzM1wrdk//8YurCB
	dUNXUid8hdcwT8hhVddJNGb9Ej7QsWaNFHGa9vBSE2CrDH50RILowz8aIyYXzAzj/Ia8+dCh1ZM
	N+QL1xuO+TLbFf6IUKpFa1Y2QNKliGP2CY+B8VE72P+KRG74X5uNfxd5fQeCRVJW6vEcrf5uug6
	ZU78K0IxEbyD9hu8pqXk0LWJE+NN6BHMvXo6JqqRlj2hxhnAS1h+XEUoZ9HtdPa8aiSbn+d0kLz
	HYjYGAG5Kppew7O5Ena8+as/1hSWpqF4F0f9VrG5A/RPktmKQxb8s+MEYryvP6OqjERb4zL5m9v
	Id2D6t5P3sVccPP4QUMzZrmXZQCwjpq9hv7bbeHG08z9iBuZuTTfw1VBr7JHWxCZigsOEdTzLX2
	8FyOA1mJPlp9xr3E4vEnjT0EvZLRIdL72e/g/lEarj0GV/BwMK7sgXRAOsuRT7vOozl4thrKb8H
	hEeQ7Nz3PMcnx7kUSkflcMiAjHazRh07MwM1VHbhYPE6i9IeIIt8K1u3G/Y53jX0qoX6
X-Received: by 2002:a17:90b:2fcd:b0:39d:efa9:cd1a with SMTP id 98e67ed59e1d1-3ae57e07d0cmr1867914a91.4.1793197132116;
        Wed, 28 Oct 2026 07:18:52 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a0482e9sm3437223a91.0.2026.10.28.07.18.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:18:51 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Linmao Li <lilinmao@kylinos.cn>,
	Kees Cook <kees+treewide@kernel.org>,
	Rosen Penev <rosenp@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/4] wifi: nxpwifi: stop AP TX after preparing channel switch
Date: Wed, 28 Oct 2026 22:18:17 +0800
Message-ID: <20261028141819.7556-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028141819.7556-1-enderaoelyther@gmail.com>
References: <20261028141819.7556-1-enderaoelyther@gmail.com>
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

A channel-switch request can leave AP traffic stopped if installing the
CSA management IEs fails or the driver's work wrapper refuses the request.
The driver disables carrier and the TX queues before programming the IEs,
and the wrapper silently drops work during removal, command timeout or
suspend.

Prepare the CSA IEs before stopping traffic. Queue the switch directly
with wiphy_delayed_work_queue(), since the driver's wrapper can silently
discard it after the IEs are installed and traffic is stopped. The wiphy
mutex serializes the callback and worker with AP-stop cancellation.

LLM assistance was used to find the bug and review.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. Not
reproduced; IW61x hardware was unavailable.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 384ba69dd058..0f7720df0304 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -3115,12 +3115,6 @@ nxpwifi_cfg80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				       &priv->dfs_chandef))
 		return -EINVAL;
 
-	if (params->block_tx) {
-		netif_carrier_off(priv->netdev);
-		nxpwifi_stop_net_dev_queue(priv->netdev, priv->adapter);
-		priv->uap_stop_tx = true;
-	}
-
 	ret = nxpwifi_del_mgmt_ies(priv);
 	if (ret)
 		nxpwifi_dbg(priv->adapter, ERROR,
@@ -3137,11 +3131,16 @@ nxpwifi_cfg80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(&priv->ap_update_info.beacon, &params->beacon_after,
 	       sizeof(priv->ap_update_info.beacon));
 
+	if (params->block_tx) {
+		netif_carrier_off(priv->netdev);
+		nxpwifi_stop_net_dev_queue(priv->netdev, priv->adapter);
+		priv->uap_stop_tx = true;
+	}
+
 	chsw_msec = max(params->count * priv->bss_cfg.beacon_period, 100);
 
-	nxpwifi_queue_delayed_wiphy_work(priv->adapter,
-					 &priv->dfs_chan_sw_work,
-					 msecs_to_jiffies(chsw_msec));
+	wiphy_delayed_work_queue(wiphy, &priv->dfs_chan_sw_work,
+				 msecs_to_jiffies(chsw_msec));
 
 done:
 	return ret;
-- 
2.56.0

