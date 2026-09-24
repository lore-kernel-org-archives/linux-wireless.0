Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C570377AAD
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 12:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790253056; cv=none; b=n4hdZRc9HYUA1KsAFXHt83f1bkhwhqB0TSXzqXN0vwHkCCLZEHrnJHltq/bUfm75QtFzEMDo4zyf+i20xNFZ/wME3YxEPlUlzTjp42BfeLczl965xGKMqB85rIKYaQ5yMCURwFIHS8XZ3LbpWWmho/0gWDBeFzBl8uXCABOCs6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790253056; c=relaxed/simple;
	bh=omk9GI045/Wzc6JEiHTL3O2HU5TJfulTTCxUFqD7tN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6BY7rWzmRQ7knt9rV0Y+W48pUaacStSQFQ+FsqwLaZ6clyXIwaVRh+HRNIwal03lj9eC8qR4sgjOCCSxFVTo2ucTpqeCNK44hYwA5MdJIAtpWas17G5lJSFXSgRU2DYvKX+BI6y/27sSAf11mOhfxaRNc/WCB2e83IkT1lv4JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IkNJdfGM; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IkNJdfGM"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e4b11so12244555e9.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 05:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790253052; x=1790857852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IeZGVwvFZh+DRIKqU9fspJebPiKjj3eoo80WtQQLI48=;
        b=IkNJdfGMtF1KdIA0c/UZ1zk5m/AYh6gTTl9E8NS6892RjGyjWHwadJRndSZsG8hjUB
         8PTqS1EnoutCOkrobRey36lGNGqMrzKmmoyBBvaefPTceT5NxpN2PldvCjHTjUfTsnUR
         5Pr8NKsJLObIfW1mDKPD0Mwf+Irgip+b0Nq9LwNAAEfgzQS2CCdt5I4IB+W5dntnYGSr
         1J3M82Z+qfxX6+PKclXv2xMlVKUDCTEIHovfZlIzLAR2b5OAlMcM5f9Gi+iHLS/rnBIR
         DRSwwAZihgUVVEqfy52FYGGioTmuEEbjh2U9mRLVjMu+Gu/zWuD7r3aI0NuSiF4esBwt
         Pzxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790253052; x=1790857852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IeZGVwvFZh+DRIKqU9fspJebPiKjj3eoo80WtQQLI48=;
        b=ac1RX1bktITk96jgblhW6YlpWJ67GaVepCnGUSdkvMEaFQZSBSih7wJCxhwmpedbXM
         lLYy+My84WkrVf3OgIot5dIUSmQrItGPyJW8lbC1Elto7NnGK2ifNK5iyAvfpFPbzSm2
         NynWHUs2oW+alN7MLppZ6GCYaeCcvZRyolRnSCJTY7qZvJXwdIQN+uOZ/Tf+TorDf1bj
         6qBTVo20lLZadtu8GCS5kuKTLV3ms+fKiM6OAP9pvjAEt+RgwHgJ/bFbUhVDKbvydVqE
         gAFLquPZ5sWMYtzbxUvzKZJoy2TWZWO9KrVPSCBQ1vz92qJm6fm7w95ewxBTPTzeVxv/
         MqbQ==
X-Forwarded-Encrypted: i=1; AKwUvBzJ91y2vBH+P6/ctfLzYfR1oEOBxYK3WrVobCnr2IYIzc3drGl/BNBVFjlTRd4T6F1TyTE6ivP1KNZRUMBR4w==@vger.kernel.org
X-Gm-Message-State: AFuF++nkUmZXrC9MpqSZ+iq/5VzVXYbe9I7KAVWF5t3FqZF00SVNZkLk
	KxRSCFfOLkqSe5ZWMWxAHjsD3faZyGGm2uhdkO9y3CWG2taREhpnpKTT
X-Gm-Gg: AYBFou1g7lcyXfS7Iu/Dgq3Smuuc+uWWJN7dUyFn+NQR+KEMKTRMwk/pJKOZwuLR2ga
	UHrBRt3oJBodTxe6T6B9Bvfj/GJdi+Z7Y8k/Q2DbLxp9yrCLmkyMFHKUlag7MNIUKbJZsW3PJ8u
	Ie5VWF3EXa2DUnm9DEgecuwdgIWX6Yvza+It/paUn0NTsns9OH4p48MVRaUnzz1Oed10yGB6RUI
	ikEYWuhe2j78J/juL7Bd5/D5fL141wNz0WltJ3qHtRlwiTgoxaFvHJ4AXL+Yf8xpBW5nWC06kx9
	SCFnf5XZgsTeMvbEw97G8ATcaOAlDM42k/MxKDf3f2n504yk2brOzNSd8Pgtx4Grb3fWwhWkYbf
	IRnhMDjxWw2m9ZWBQu8wondxvcK0JzVcv8soTkjmc32/RlUqijhsxEstUmoWJNvWkQTKBIzuWpH
	WN3tBt+gwSmJEcpMZ2vzpdsuijP66UWMk0UNDP97b94DEFIP1taQEyU2cyUYixSoQBg0+ZtTRLz
	fq4yP+0DGoaaC4LXQFNMM9nQ8fgW0Y2RnTqr7yMWWdQcHFO5SnfNb/gwYERlvDzFHEKYN79WOc=
X-Received: by 2002:a05:600c:138c:b0:49d:174e:2a1e with SMTP id 5b1f17b1804b1-49fe66e6538mr38211495e9.19.1790253051185;
        Thu, 24 Sep 2026 05:30:51 -0700 (PDT)
Received: from pws-dionisio-3680.powersoft.it (78-209-174-168.subs.proxad.net. [78.209.174.168])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5bae43dsm64010115e9.5.2026.09.24.05.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 05:30:50 -0700 (PDT)
From: Michele Dionisio <michele.dionisio@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Michele Dionisio <michele.dionisio@gmail.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH wireless 1/1] wifi: brcmfmac: fix P2P device removal race in brcmf_detach()
Date: Thu, 24 Sep 2026 14:30:27 +0200
Message-ID: <20260924123027.4122909-2-michele.dionisio@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924123027.4122909-1-michele.dionisio@gmail.com>
References: <20260924123027.4122909-1-michele.dionisio@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the driver is removed while the user space process that created
the P2P device (e.g. wpa_supplicant) is still exiting, the P2P device
interface is removed twice and the kernel crashes.

The two paths are:

 - wpa_supplicant, on exit, sends NL80211_CMD_DEL_INTERFACE for the P2P
   device. nl80211_del_interface() holds RTNL and the wiphy mutex and
   calls brcmf_p2p_del_vif(), which disables discovery and waits up to
   1.5 s for BRCMF_E_IF_DEL. Then it calls brcmf_remove_interface(),
   which unregisters the wdev and frees the vif and the ifp.

 - brcmf_detach() sets the bus down, so BRCMF_E_IF_DEL never arrives,
   and calls brcmf_remove_interface(ifp, false) for the same ifp.
   brcmf_p2p_ifp_removed() reads ifp->vif and then blocks on
   rtnl_lock(). When brcmf_p2p_del_vif() releases RTNL, it calls
   cfg80211_unregister_wdev() on the wdev that was already unregistered
   and freed.

The second list_del_rcu() of wdev->list faults on LIST_POISON2:

  brcmfmac: brcmf_p2p_del_vif delete P2P vif
  brcmfmac: brcmf_p2p_deinit_discovery enter
  brcmfmac: brcmf_p2p_del_vif P2P: GO_NEG_PHASE status cleared
  brcmfmac: brcmf_detach Enter
  brcmfmac: brcmf_bus_change_state 1 -> 0
  brcmfmac: brcmf_remove_interface Enter, bsscfgidx=1, ifidx=0
  brcmfmac: brcmf_del_if Enter, bsscfgidx=1, ifidx=0
  brcmfmac: brcmf_p2p_ifp_removed P2P: device interface removed
  [1.5 s later, brcmf_p2p_del_vif() timed out]
  brcmfmac: brcmf_remove_interface Enter, bsscfgidx=1, ifidx=0
  brcmfmac: brcmf_del_if Enter, bsscfgidx=1, ifidx=0
  brcmfmac: brcmf_p2p_ifp_removed P2P: device interface removed
  Unable to handle kernel paging request at virtual address dead000000000122
  Internal error: Oops: 96000044 [#1] PREEMPT_RT SMP
  pc : _cfg80211_unregister_wdev+0x6c/0x264 [cfg80211]
  Call trace:
   _cfg80211_unregister_wdev+0x6c/0x264 [cfg80211]
   cfg80211_unregister_wdev+0x10/0x1c [cfg80211]
   brcmf_p2p_ifp_removed+0x84/0xb0 [brcmfmac]
   brcmf_remove_interface+0x1f4/0x254 [brcmfmac]
   brcmf_detach+0x88/0x180 [brcmfmac]
   brcmf_sdio_remove+0x90/0x7b0 [brcmfmac]
   brcmf_sdiod_remove+0x20/0xa0 [brcmfmac]
   brcmf_ops_sdio_remove+0xbc/0x12c [brcmfmac]
   sdio_bus_remove+0x38/0x144
   device_release_driver_internal+0x1e8/0x2c0
   device_release_driver+0x14/0x20
   brcmf_sdio_bus_remove+0x2c/0x40 [brcmfmac]
   brcmf_fwvid_unregister_vendor+0xd8/0x170 [brcmfmac]
   __exit_compat+0x18/0x418 [brcmfmac_cyw]
   __arm64_sys_delete_module+0x1ac/0x244

The log was taken with debug=0x406 on an i.MX 8M Plus board with a
CYW55513 (Sona IF513) on SDIO. The driver is the Ezurio backport of
brcmfmac from v6.18.22 on a 5.4-rt kernel. The code involved is the same
in mainline.

To reproduce:

  1. Start wpa_supplicant on wlan0 and let it associate. It creates the
     P2P device (iw dev shows "type P2P-device").
  2. Stop wpa_supplicant and remove the driver without waiting for
     wpa_supplicant to exit:

       kill $(pidof wpa_supplicant)
       rmmod brcmfmac_cyw brcmfmac

The crash is reproducible on that board.

For the interface without a netdev (the P2P device), take RTNL and the
wiphy mutex in brcmf_detach() before reading iflist, and remove it with
locked=true. If brcmf_p2p_del_vif() runs first, brcmf_detach() finds the
slot empty. If brcmf_detach() runs first, nl80211 does not find the wdev
any more. The interfaces with a netdev are removed as before, because
brcmf_del_if() takes RTNL on its own for the primary interface.

Fixes: 9831bcb987df ("brcmfmac: Deleting of p2p device is leaking memory.")
Cc: stable@vger.kernel.org
Assisted-by: claude-opus-5-5
Signed-off-by: Michele Dionisio <michele.dionisio@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/core.c        | 27 +++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index d2ae679856067..92ec269f43b23 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1489,8 +1489,31 @@ void brcmf_detach(struct device *dev)
 	brcmf_bus_change_state(bus_if, BRCMF_BUS_DOWN);
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS - 1; i > -1; i--) {
-		if (drvr->iflist[i])
-			brcmf_remove_interface(drvr->iflist[i], false);
+		struct brcmf_if *ifp = drvr->iflist[i];
+
+		if (!ifp)
+			continue;
+
+		if (ifp->ndev) {
+			brcmf_remove_interface(ifp, false);
+			continue;
+		}
+
+		/* The P2P device interface has no netdev. Its removal can
+		 * race with NL80211_CMD_DEL_INTERFACE issued by a user space
+		 * process that is exiting (e.g. wpa_supplicant), which ends
+		 * in brcmf_p2p_del_vif() under RTNL and the wiphy mutex. If
+		 * both paths remove the interface, the wdev is unregistered
+		 * twice and the vif is used after being freed. Take the same
+		 * locks and re-read iflist, so only one path removes it.
+		 */
+		rtnl_lock();
+		wiphy_lock(drvr->wiphy);
+		ifp = drvr->iflist[i];
+		if (ifp)
+			brcmf_remove_interface(ifp, true);
+		wiphy_unlock(drvr->wiphy);
+		rtnl_unlock();
 	}
 	brcmf_bus_stop(drvr->bus_if);
 
-- 
2.53.0

