Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784D041B8CA
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501330; cv=none; b=SGQ5zJQCi5fjP3y9FcTcvFr/XmyUEaHzR2jwknrDje6NPd6Ya94vXPsVchX+p7EhQzYnpa6d6GTkVOZhllUbtuGIFAOoOq5xeKxOSv5fiukeMuKmLs4wVwE+4fvL24d9aBdtpFNQLlp7+NFJQe2O45dBhW7S13R2MZnEsEqVhDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501330; c=relaxed/simple;
	bh=x5MXwj1d+VB1odu+qOXn2Ic0Y+N5eUhDb+btCILvx44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxHhvQ9udnKsmxFd61AfdUxGbIk7zRU9b6550yWh4Ix2jmt1Mtzk+qg3w5/u4ZVR7visEpDGXmpDNOZEFOVs94qA10cog6fhBolknYDu9CGEAD0FkqyUUbbuseRB3WOCN9ow1g/utrvmOUzJmyDVlilRCgbYGSa/8b7mPy1G5yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=QS5HTYe+; arc=none smtp.client-ip=209.85.221.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QS5HTYe+"
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-5bfc5b77c02so785650e0c.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501327; x=1786106127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4PlKcANzq+y1Rq4zco4LLPjQUEuNl07QXAtQYWq7XU=;
        b=PhOMEaEUzkimQSyDxPL4wC7fCmjKRofxj2H/D8GV2R/Svj7YPD9P59uJACoZ8DK2g1
         kEVfAFPRLwwcoIKbIPD+x1lAx2rl6+mVd0V465yaMymI3ugWEDiSZdASZfND9nzTMEkC
         LfEBf8EAiuppyNdVkWXElOoubEg8FEPUMPC8eKMRo+peNSk6REc+6deq3ARSxGG+ZoGO
         WWGHyzKdcH/kWBIH4wEvCITSBOmYWD4VFNZGm3QLS5K0C4W4Gx5MYO2Fuv15y5I9jGVw
         hN+Sr0sgq6RC4DeZf9ojI7boS+DmnBtgNwYDLZL+Jolvv1/JUid7YQKrSx4ILiJ6+FqI
         UfuQ==
X-Gm-Message-State: AOJu0YzPAGZ2orNJN6c/XVbMzO06wAwQRhSatnOuUhGttBjOpdx1Y/fU
	tRnZ5tLGDiCwcz3OvIOddDUZa2DU29noIllCXmzTFizQW7Op5inFC1XhBq9sQFIAql6focG2+Mc
	fEOb+e0/w9gklt0ExO8UvBDjOHt8CSbXAJ3pMBZVLbbfAGNG3QHi48JLWk/DV+IfYygFgeRH8f/
	kP7OUvKiUsZ8IIZs9Kv9uUv7gkfWchywNzWxtaNwMAocDOywFukenqN2Tsm1XRo2ncF1UVrXaV/
	AOp3zANhKiNzIczVBL5tL7QKWA7
X-Gm-Gg: AR+sD13Wd9wMrDlRZvxROQE8PhHFcEa9guV9UpeAR33ogZjbmX4nZat7IB4JRFpIqj8
	RlxzCrYl9WagnP2ccJl5LM0SIbcF+uBMCrMlnh9wxnjEI9Cic1G5Aulj7WhI5kmhC1itWa0Me6R
	+e+7qyQVGGLyWXdb7khJIfMYISIK2EYW5Nd3knOi84ktRGkvPL/8hrObYBrs8QzdIvgbwCFee60
	E8JzZLvXxaMS/+Xp2IFmsXwtvusEqOadbirQMSFY8fejYEmzCly6rjSSAZNOLJpEAddP73t1Uan
	1fH5vYMlbMEIbAgwd1jZn4DyGiLn2dh0pd8mU6AtFgZiXhVbRu8OIjCGF/X3iXkoMOhRhGKGAnK
	Df/d+g1Rh8C8SZaI/+k2ngLrimYmuO+bwmsPNaxDEzZLYgYxOTc/VyrIR2cHW8EvFN9hN9Yr+ZV
	TKRSNunMybX/f2KsV9eDM2nYwRWYY0isqYfyJWWio=
X-Received: by 2002:a05:6102:1499:b0:6c5:d55d:c093 with SMTP id ada2fe7eead31-758faeda28fmr1039977137.8.1785501327293;
        Fri, 31 Jul 2026 05:35:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-759c9b50f79sm79168137.25.2026.07.31.05.35.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cccfa32670so10606265ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501326; x=1786106126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n4PlKcANzq+y1Rq4zco4LLPjQUEuNl07QXAtQYWq7XU=;
        b=QS5HTYe+6IRFUXEx0PvXrYDipxUihuT4AKO7n2cDZ+cRK40yWGfxfvkRsO0h+znb6K
         dVb/TNilrCtspHpGzU4gf/m+ugtujlhiKakRH0+Kd/64E50cCA92wwE6GYxAK06vZ5be
         ZgiMTRkUDxPV5waR6qscAogCo+4NITV5Puo2M=
X-Received: by 2002:a05:6a21:d84:b0:3a3:a9c4:3d60 with SMTP id adf61e73a8af0-3c91b1156f0mr1868236637.27.1785501326093;
        Fri, 31 Jul 2026 05:35:26 -0700 (PDT)
X-Received: by 2002:a05:6a21:d84:b0:3a3:a9c4:3d60 with SMTP id adf61e73a8af0-3c91b1156f0mr1868211637.27.1785501325637;
        Fri, 31 Jul 2026 05:35:25 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:25 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 04/13] wifi: wil6210: use pre-assigned cookie for remain_on_channel, mgmt_tx and probe_peer
Date: Fri, 31 Jul 2026 14:35:00 +0200
Message-ID: <20260731123509.1975281-5-arend.vanspriel@broadcom.com>
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

Stop overwriting the pre-assigned cookie in wil_p2p_listen(),
wil_cfg80211_mgmt_tx(), and wil_cfg80211_probe_peer().

For remain_on_channel, store the pre-assigned cookie in p2p->cookie
instead of incrementing it. All cancel and expiry callbacks already
read from p2p->cookie so they pick up the correct value.

For mgmt_tx, remove the defensive "cookie ? *cookie : 0" guard;
cfg80211 guarantees a non-NULL cookie pointer.

For probe_peer, store the pre-assigned cookie in req->cookie instead
of the CID value. The CID is still available via req->cid for STA
lookup in wil_probe_client_handle().

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 6 ++----
 drivers/net/wireless/ath/wil6210/p2p.c      | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 5f2bd9a31faf..6ebd340c8ef7 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1488,8 +1488,7 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	 */
 	tx_status = (rc == 0);
 	rc = (rc == -EAGAIN) ? 0 : rc;
-	cfg80211_mgmt_tx_status(wdev, cookie ? *cookie : 0, buf, len,
-				tx_status, GFP_KERNEL);
+	cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, tx_status, GFP_KERNEL);
 
 	return rc;
 }
@@ -2399,13 +2398,12 @@ static int wil_cfg80211_probe_peer(struct wiphy *wiphy,
 		return -ENOMEM;
 
 	req->cid = cid;
-	req->cookie = cid;
+	req->cookie = *cookie;
 
 	mutex_lock(&vif->probe_client_mutex);
 	list_add_tail(&req->list, &vif->probe_client_pending);
 	mutex_unlock(&vif->probe_client_mutex);
 
-	*cookie = req->cookie;
 	queue_work(wil->wq_service, &vif->probe_client_worker);
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
index f20caf1a3905..6d2cadca259f 100644
--- a/drivers/net/wireless/ath/wil6210/p2p.c
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -144,7 +144,7 @@ int wil_p2p_listen(struct wil6210_priv *wil, struct wireless_dev *wdev,
 	}
 
 	memcpy(&p2p->listen_chan, chan, sizeof(*chan));
-	*cookie = ++p2p->cookie;
+	p2p->cookie = *cookie;
 	p2p->listen_duration = duration;
 
 	mutex_lock(&wil->vif_mutex);
-- 
2.54.0

