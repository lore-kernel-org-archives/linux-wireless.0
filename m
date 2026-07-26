Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595B1375F96
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093962; cv=none; b=Su0owFdjKm5Er1K1eW1HK3B2vVgrjiRBr/b/M/ZgvADOO9Z4ld3/aA1MoR+Tui7VYcXc+C68MOCarm/UAHKheQd75vvcT+ab92fb1p9+2x7vvhZMNiDLDj/jp0BW2jAdNEAIh0jNO+6hQSq6XCRgLQc+h2UxuxCzWAJ3HwB9hMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093962; c=relaxed/simple;
	bh=x5MXwj1d+VB1odu+qOXn2Ic0Y+N5eUhDb+btCILvx44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0cMiTVl5dmaw/U79o4MArGLBRcgoZ1U1X3KvkcPy6weKWaVhFk5RQmyTicgd9AKEHqhthIKvbCTKml11h1b6EyH+7qjwbuPlPP0SpyomusejpV/1dGKx7TFGux/22lf7k508xG5uGkEy9YOFkPl0EOPvnAtPwi7maxNBuiupqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=TpDZLwxe; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TpDZLwxe"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2ceab75934dso25299665ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093961; x=1785698761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4PlKcANzq+y1Rq4zco4LLPjQUEuNl07QXAtQYWq7XU=;
        b=reepQ+BN6FshMVkdhZ9f3tGqQXyhqUOrqFjQjq7SlNyw6oZiPL7S3fRDzJFrFc6Vbw
         ZqOUze8NLHAh35DgXV8w2wsgLLpXq/Bd8TpeqZVQVowbkW5grh64QIdp8zPaCYOBbXey
         u+W8R0ULJMP7Uhy3G3ii2XjtzMk116Rebm2R16J3Ank/rP3tv+i7JvfamU2cVZReSAOI
         7ndSjgVJihh1C+MWnwgPVpVs17febvg6Mrqzb1+NLm5LG2OyNSGjNWVAkj169jsQlc6b
         8qca30vXfB1G33KLeTK0dk7fQdWKdigdHdzfikxi4FC7AqWDpFTcquXagJr0NkSyF/Br
         HLmA==
X-Gm-Message-State: AOJu0YxeqSvdNqP/78f6EsVgU6ToDs8FnEtFjRCroVMqqxe51lkeIZyI
	VSQdgWxJ+ZiVqnqmQvx+U3EwHDU9HnAyNU68lqtjR480ECneTjMPtqEmcoa9Dl/SnX6e6yQwx1o
	Mol0FOFDemR8NY11iUTEbsqZ+dZi1Qf9ILLDdb0/pH/MNh3shOmv5UXR3UKl468UZKn4A5GpfJ5
	HBy5tUStCA51GTaUqA1McMSvrJz52Aqc6cOW415jtznUHbYAg6hxyC/YtmxokpZVTFaoJajH619
	Hq4dqH1zl4M9yLZ3fqsONUI6aKb
X-Gm-Gg: AR+sD11osIwdb5mh2n4D1hmt8sruNuUclelDglFVFzO/o9voAADCZ+ryZ23fSoCeU1g
	vW2EM5i2XMOEQNzdYCsA5wbzMthzrFQtXfULYwI19hIkd1xtvD8BMX5EK/I8UjlbTX07fRJFMjt
	qm/vp2GCZn7aCmL4gRyRv55v54gt/Gz+OMOZPO3B8MYzn1OkfYP/VXIn2OtovCYDadi7GJs42tB
	0vKx82DJ23aR4cRmNuq/yl8bI8bqfBeqJQv/DxWF0zV1dROr3zr2BwP6gmyt2YdEXJmR8zfuBzK
	TmZLEUq/gD4FDXxE/84F+zB3SlsXk+qYJDm1qQLBmoKPNQjMYViW4YYG7PGVx62Ob1/0sHFEslC
	PjWWK/BTlgLCcvIXtEM1eKKGPl4z4g0d4pGNSse7QdqCPA/7dn1OpkifqO0Ql35lCk+PfEzvEDA
	JUis6X9jcYai6bokKlx/Wktrr5fMpouvwI4KFV+Ag=
X-Received: by 2002:a17:903:2c06:b0:2ce:bb47:6f3c with SMTP id d9443c01a7336-2cfde88657emr59750375ad.34.1785093960656;
        Sun, 26 Jul 2026 12:26:00 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cfde7c2a89sm5517615ad.52.2026.07.26.12.26.00
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:26:00 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cacd6d37edso30745665ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093958; x=1785698758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n4PlKcANzq+y1Rq4zco4LLPjQUEuNl07QXAtQYWq7XU=;
        b=TpDZLwxekJJdxV68G7CGMLIYdqN/tFfhV0/NV13amWQMUzYiFy4Ef3i1WYdT4oksHo
         Hdz3V8aaIdluB5n/ppv9umTZJ9faF8cnTNVf3xtZeNShAx2SUW4/Cu6jRriRbRGmMckL
         5eqovxvswXDyW+++YNs2lFccHb0WYEdz2LtVw=
X-Received: by 2002:a05:6a21:6196:b0:3c3:bbe6:95b1 with SMTP id adf61e73a8af0-3c67dd8a07amr6021249637.24.1785093958743;
        Sun, 26 Jul 2026 12:25:58 -0700 (PDT)
X-Received: by 2002:a05:6a21:6196:b0:3c3:bbe6:95b1 with SMTP id adf61e73a8af0-3c67dd8a07amr6021228637.24.1785093958263;
        Sun, 26 Jul 2026 12:25:58 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc44cb92sm38355795eec.13.2026.07.26.12.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:25:57 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next 04/10] wifi: wil6210: use pre-assigned cookie for remain_on_channel, mgmt_tx and probe_peer
Date: Sun, 26 Jul 2026 21:25:35 +0200
Message-ID: <20260726192541.2816743-5-arend.vanspriel@broadcom.com>
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

