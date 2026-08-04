Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22C03F5BD7
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 06:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785823953; cv=none; b=fX/185gRo5sJ0qUoGi85exIHWAbacIkSaSNzaOZYMqraQawgbNWHXcAGDW9oiqV7Lly/8BXPGViiLIpuwxstpoXtCDR3HteFPcK8qE9B4EGb97eGE1TX/7UMCznOjaIT9iTGYZDVCtFmyFAtGOAshu251sMk7C/HnEiR3sEb0HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785823953; c=relaxed/simple;
	bh=K5Ph9XcyqOYkIasx02lR7AFxCwUH0dmM/cCvoQIHRKk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dq7TsBJtAZK0/Kaysx8ZT+Xt4dKD1HexsnG5L58gbJ6pf4fB0CheNz4IxSQUGicbrYGIYlTZKsyyJrIGsU+AXCrJnUBA3gLaYsQ3WsARoShOJB59gs8eXuMTVd/0ux+vdxy/chYM/cvOrIZZm4kgHRT2M2GKHM2Ad2h8wZoYz48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gT4p7sUZ; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gT4p7sUZ"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-49612ef3209so436624b6e.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 23:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785823950; x=1786428750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lLnrl7cvfXhXnP0TWy+i62c7ISWemwc6cOZstir8oEI=;
        b=gT4p7sUZvuSsh9OotrRHNVX2EjaglX+SdQVFp0IVMq6A0q4T0j0ZrMrHSYg425g4MG
         Z2qAERqDZMbFvk4TFCCuIC4Tk8x13jp8iZPAbsQPy0tvdhtszjgWHBS8hz6Od3e56V4R
         wB17X5EpOPF4pcl10QmBK3VVUgfWZS6M4YJe+k5gRSUHUA4gxUVj9xB5XvAi8Os1n002
         ClfygzJmaG5heyKftdIqQWqWSfaoPprNx8+fHLLgPZ7Z3SqrSOqLpa6poZhLs5pkXDP3
         ULPUHfXJfck02dQ9UfeJUtPmk+A0NO80uFc50ywPevTrODBwGvtapeWeRKBHfk0IsDjv
         6kxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785823950; x=1786428750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lLnrl7cvfXhXnP0TWy+i62c7ISWemwc6cOZstir8oEI=;
        b=KDbPZl2g9TH/5kRTNJ0DWU+vDLkp0M5ZrmP+taC3ejJ5Q8Ag91+GvV6l2kolKi+CBB
         2DTqhLsOHQ3imqL3gdY56B2TkIinZYyLUkCbnDXSCsriqgG63ehGi6MznNC57Kh01Hmj
         a5pwo55U9RKSB1xXnGVgOlqNuO1Ha12GAZaLEtfIMAwt8fyKGky4V+020YiXSUR2OPeE
         zLRUyoIuyy9ra9wGMVuGUvQO6TUd359glnBlu2kYNfgFbquuct7FoxRQE8Z9Mr7B3PZz
         WONtbAXyHV0hVqde22VuVFTDCiflVkKt9qI42K7SrtymB+SllBj0onarxeGgrh++LjCO
         ApcA==
X-Gm-Message-State: AOJu0Yzm1rnfx2nUr2se42ELcKR2jc+ildTWPkyntqI5GobzaD/bpHox
	tKlzNcaneW2FTZdgpFcluwjeogUfRjgFhk7dvNOU6USQmqCn1lFgcQ5m
X-Gm-Gg: AR+sD11zIZPcoxQWfCX7/m/elw6p9nb9M2ZHOMlTZseKQwloJ9x/+KQPmbH0eAh/bPD
	luA42Q9wyZlC1NpXDuEHCokiMuVb6vRDRHcS2ELDWXrzzMK16eWWs6YkOSqe+8Qd43xykvYhGPv
	HYLEY32VHPIf9/igIdGB+lDkx1601p8DnW/zYJnxk3wL/w8KP7UTCzI1BvGUb9MPfvW/xBeCGjY
	fr1gK6NtsDum3U8n40il3dUdsmeSppWLAtl9jMOL7PLWae8Jkl4d+/uaNSTgF7KqivrEnUgvjOA
	iH6Vkgddy0j7aDa9B3gmONkTfJ+3b3DmSTCo7frVvEZaNReXtAdT3uOM15hbddPQT0LzZrBnfdt
	cRV6qVt0ZaOeGrfH/sTW7E8LR4XKuGZNcvzPE309jc8AR1kxxfF3kJa3TT9LGrJhS5ZoDWnskbk
	WRoe/KRlzwt8OzuwczQsCa0OqzFraUicmq7/fvsQ9YLWOViNtEw6A27JvWttmGel+gG15EjOzVq
	ZZuSmoaB9/Cczn3FBHXk0vbg4CT7ftVOOheOgq++vEeYVzYyDuJoKHy59OO/RI=
X-Received: by 2002:a05:6808:1387:b0:495:ac16:7afa with SMTP id 5614622812f47-4af5e3740eamr13419377b6e.4.1785823949634;
        Mon, 03 Aug 2026 23:12:29 -0700 (PDT)
Received: from antares ([149.88.25.215])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4af58d11372sm7918032b6e.7.2026.08.03.23.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 23:12:27 -0700 (PDT)
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v4] wifi: brcmfmac: cyw: pass PMKID to firmware if present
Date: Tue,  4 Aug 2026 01:08:59 -0500
Message-ID: <20260804060859.412348-1-bogdan.nicolae@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zero out auth_status on initialization. Otherwise, garbage will
leak from the stack to the firmware (when ssid is less than 32 bytes
and/or when params->pmkid is set). Then, pass the params->pmkid to the
firmware (without it, the firmware caches a garbage PMKID on successful
authentication and denies a subsequent association request that includes
the PMKID).

Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")
Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
v4: Fixed indentation
v3: Added Fixes, Cc: stable, and Acked-by tags
v2: Split into a separate patch

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 873754be5..2c59b5e57 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -200,7 +200,7 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct brcmf_if *ifp;
 	struct brcmf_pub *drvr;
-	struct brcmf_auth_req_status_le auth_status;
+	struct brcmf_auth_req_status_le auth_status = {};
 	int ret = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -208,6 +208,8 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 	ifp = netdev_priv(dev);
 	drvr = ifp->drvr;
 	if (params->status == WLAN_STATUS_SUCCESS) {
+		if (params->pmkid)
+			memcpy(auth_status.pmkid, params->pmkid, WLAN_PMKID_LEN);
 		auth_status.flags = cpu_to_le16(BRCMF_EXTAUTH_SUCCESS);
 	} else {
 		bphy_err(drvr, "External authentication failed: status=%d\n",
-- 
2.55.0
