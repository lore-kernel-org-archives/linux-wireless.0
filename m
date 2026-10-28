Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197145;
	b=kYxI60HAKwOAci4BTgIIOBOyY4Z+gqVoffmUfPZISFoXQs2oBwsvl+xG5Cdjpa2QbaMV
	 eNh7FaKKp8b5n38SmHVAk+f+khtAhzd8pRaWOL08tUHB/iE4GjlG3cIks0UB+eeqYqaTG
	 gj84zwuVQXWcduupQgtzKQFmkUFhlw1VUTz/zKfLUTt/Yuvgi5mT8j9q4ZBCxBVXBtAnF
	 8i19WyxMN2mEmF+XzSS+UIisE8sMyEAT5k7alM/d+aXWuSrkYieCF0SAWXnFisMCS1fUC
	 C2uSDfr7WVyekDeUKEdob7356wVeQ6oPsBI8iITrAyMMaPT5Dk5LxJJSqxvA0XjC/BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197145;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JBg8MLPlrE0fjPrOyLI8JRzxatJ5zVcZoGDssyVp73c=;
	b=aPMBeW5p9lC2z804nCfueJ0BRSFc5BuRGNC6uukcbvuPCTGYg5CnSa/qV6dz8X99/4FS
	 uIrdWPTJozsVf0PuSVyIrpVm1BrTeFB5xWzfzB3aXSA6Yif2I9kt2xvapQkx9Oy4udIcL
	 NN/JtzDv7xwMUY/7t8RKESdllc2z4pxA6lotPoWt3XSGjX7ns3MEXJaLTVAXsuDUvgLbU
	 2G+PaW0ejy3EM9sEEZjnOg1bg9N3wqWRlFfLGtt/isHp+8EQkVINcQcOnugdU1dfKqZIK
	 w/G0QhACpeZZZfA5JCmTymLIUHFdFvwd0EBiKzQcR798/SD6bWkN441oGxET8BDhTWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nVvzS0cC;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAEE60A2620
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:19:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDAEE60A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nVvzS0cC
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so639119a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197144; x=1793801944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JBg8MLPlrE0fjPrOyLI8JRzxatJ5zVcZoGDssyVp73c=;
        b=nVvzS0cCAcsPi1aoEMGZ6fwt7Q1PvWG0cUwqP9ijYueVsaXUPH+RLO7Db3Qw7Paw3H
         LgzMPIOgHpmTpJ/UlWh4O9S5pgNDWOKWXvY1OLQEitXmAT53YR2xirH3EV3OTeMuYz8+
         AlE+eLRej3ixe/qmP1ooD5IrzTnll1fKVxklyAsqaY33eQYDwMygEKb33J79v2ydYkAH
         cCvFSQt32Hh20D86ytYH24x/XcllCFd9YQEQhqUhehnnHjUG/NJFV/9ufSFTtnpWgi6c
         HFZ3ElkDrfo2G9o53XQjrwZJtZ8MamNCO7OQMT9IaunybfF8PtF5B7wkiu00eguMeONP
         V9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197144; x=1793801944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JBg8MLPlrE0fjPrOyLI8JRzxatJ5zVcZoGDssyVp73c=;
        b=biBMQo2j6iUI6Ju6NMlvqmbebGxl19rb+lnNI7FK6fm4ANaR1jb/zoAsZ9U0lwI9Jh
         2DjhIV/5PaeONB7ZOIeaWzUBHHY3s7pVKCQHfXvCveONgQp+53rWez9sba+gte2WoXeP
         BB+0OACpgHEkFYqGqmbq/2fr30T2eCFyki2FnKbP/rfyLVbuwgyt7obaETAmWqi7kb8a
         hef1qi06acEHUlFOp33SGPBdkDkhPRIzyiVBg4/aTIbl+fzVeWW0EhnuWmHhssJ1R7/s
         P97jBcZQ4k5xGrd6wIKlFDEYSitF8/5JapWhXcAH0cLhui6UPSs5VL/AeRd194xPnuCT
         cSzw==
X-Forwarded-Encrypted: i=1; AKwUvBzQHJCBB/vX3XoxUjqmVuG1C5j0lSxLnj7A7dDmTEwk6a7Y9/ze7F/T6IGJbA2O5qJAZoz2o0Ar6JnlzJibrw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLIKMdpnjDnoIJN7DzhU+lb68P0zJr75qB3E/ZdaIeNTfHXUwiz
	Re4t4Vy+aHpL//cfcheY6+VDo49ervOVs06cdy/2HVkpvSI++M/F6+VY
X-Gm-Gg: AYBFou2JBvPbryWpTeEkSc+yVOW+a0vukk6NFkxQfcC5uqhJP3NEzUNFy21nkOPANst
	TNR1yAsQMF8bmAyo4PuJNWtcb7HvtgQJczbORVmCAjDUTOMnZf3lriwv3S2fbXkLfK8bScXpDwh
	iXfCfYvvtIS98xwSICHDSyZ3ySom1SM3QEowml4/2TK0n2f+smGzQliNW1GEAUhyT5KI0b8c52o
	XpcxkZQx2p7CrK4NlfvKiM/9qLTfII5rQd5Z29ctV1iuA/fPoH/VR8JvKZW7uYYOQZHS47GCCth
	QR5yA1+blQiACcG2SVc0JAOVZwf6Qhzwzboaq/cGsSgWhEb3UZPryTunQ2FH8yoQEY+zgklxeZV
	LjhB11TMDXFru2J8HoqW+fPAyMEMG5Vf1TiSqUx2VYd+fcX2UmQcKtIhLy0swJDV0k8hu4YZrCN
	JFjvA5x66gsAUDfx0VcuOxYUVGwTE6c+dIMOtidTNkolwAtUdhaWMMmNTwMiVt5UHGjsU4twJh/
	sQby6Jzj7APOVZt03IueeqqeBE2l/HsEsARIlvfFUui+QuTFygPbWgc5jZKWe38H6jjSUMV3m/M
	rKJi0wMYvY+yojmCnwRUrZzLiRmB7bR2nrbBxaB/zO9Ui5T5SA/i6NDfZXCVdOWi6BBR
X-Received: by 2002:a17:90b:5628:b0:3ad:6781:da66 with SMTP id 98e67ed59e1d1-3ae5816f4e2mr1764279a91.23.1793197143876;
        Wed, 28 Oct 2026 07:19:03 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a0482e9sm3437223a91.0.2026.10.28.07.18.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:19:03 -0700 (PDT)
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
	stable+noautosel@kernel.org
Subject: [PATCH 4/4] wifi: nxpwifi: stop AP when delayed channel switch fails
Date: Wed, 28 Oct 2026 22:18:19 +0800
Message-ID: <20261028141819.7556-5-enderaoelyther@gmail.com>
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

A delayed AP channel switch can fail while stopping the BSS, programming
the new beacon, or restarting the AP. The worker returns without notifying
cfg80211, and traffic can remain enabled over a stopped BSS when the
request did not set block_tx.

An earlier stop failure can also clear the driver's AP configuration while
cfg80211 still considers the AP running. A following channel switch then
reaches the worker without a beacon period and is discarded.

Disable carrier and the TX queues, retain the channel-switch state, and
request interface shutdown on all four failures. Keeping the state until
the stop path cancels it prevents another switch from starting while
shutdown is pending.

LLM assistance was used to find the bug and review.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: <stable+noautosel@kernel.org> # depends on the beacon ownership backport
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. Not
reproduced; IW61x hardware was unavailable.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.
All four patches apply without changes to v7.3.
Stable pickup is disabled because this patch depends on that backport.
Persistent firmware-command failure recovery was not exercised. The patch
disables TX and requests interface shutdown; it does not prove that cfg80211
and firmware state converge if stop_ap() also fails.

 drivers/net/wireless/nxp/nxpwifi/11h.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11h.c b/drivers/net/wireless/nxp/nxpwifi/11h.c
index a6c87dfad9ee..1341c9015ea4 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11h.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11h.c
@@ -300,22 +300,22 @@ void nxpwifi_dfs_chan_sw_work(struct wiphy *wiphy, struct wiphy_work *work)
 	bss_cfg = &priv->bss_cfg;
 	if (!bss_cfg->beacon_period) {
 		nxpwifi_dbg(adapter, ERROR,
-			    "channel switch: AP already stopped\n");
-		goto out;
+			    "channel switch: AP configuration is missing\n");
+		goto stop_iface;
 	}
 
 	if (nxpwifi_send_cmd(priv, HOST_CMD_UAP_BSS_STOP,
 			     HOST_ACT_GEN_SET, 0, NULL, true)) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "channel switch: Failed to stop the BSS\n");
-		goto out;
+		goto stop_iface;
 	}
 
 	if (nxpwifi_cfg80211_change_beacon(adapter->wiphy, priv->netdev,
 					   priv->ap_update_info)) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "channel switch: Failed to set beacon\n");
-		goto out;
+		goto stop_iface;
 	}
 
 	nxpwifi_uap_set_channel(priv, bss_cfg, priv->dfs_chandef);
@@ -323,7 +323,7 @@ void nxpwifi_dfs_chan_sw_work(struct wiphy *wiphy, struct wiphy_work *work)
 	if (nxpwifi_config_start_uap(priv, bss_cfg)) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "Failed to start AP after channel switch\n");
-		goto out;
+		goto stop_iface;
 	}
 
 	nxpwifi_dbg(adapter, MSG,
@@ -337,7 +337,13 @@ void nxpwifi_dfs_chan_sw_work(struct wiphy *wiphy, struct wiphy_work *work)
 		priv->uap_stop_tx = false;
 	}
 
-out:
 	kfree(priv->ap_update_info);
 	priv->ap_update_info = NULL;
+	return;
+
+stop_iface:
+	netif_carrier_off(priv->netdev);
+	nxpwifi_stop_net_dev_queue(priv->netdev, adapter);
+	priv->uap_stop_tx = true;
+	cfg80211_stop_iface(wiphy, &priv->wdev, GFP_KERNEL);
 }
-- 
2.56.0

