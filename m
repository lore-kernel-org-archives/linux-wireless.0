Received: from mail-oa1-f98.google.com (mail-oa1-f98.google.com [209.85.160.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC42130B517
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249969; cv=none; b=dkXGBvRD3ugFmOAgdEPfX3Xf/QQmCj9HP4dxS9g0opQ4/gM8ZbfANjSVIcpHqOMCDnR7ipHyI6UFtc+lOHEdBGyxZ+bZNyeANB23eJX0DYjsUR5cvx5OpMZG8FqMsqY9lYHbWBkIqFCiXXF2yeyi16y0hlAaBSmGk3G9QGIJwCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249969; c=relaxed/simple;
	bh=x5MXwj1d+VB1odu+qOXn2Ic0Y+N5eUhDb+btCILvx44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKY6PnD1tkbSJ8O+XAddaYc7Xf155YkQOPZbKok390hF4CxBJz3JSjrAwqV5+VWv1x5NnrQlRpyp+ApUSGOKwxGw9lTzxgXJNWpAqTWEwQMrVg5I0lPcmveDZGTJcr9CGQgsB79vErWPLPhjNw/laTwaljrbh+yFb7vKjgkcDsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=VFQdyxyd; arc=none smtp.client-ip=209.85.160.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VFQdyxyd"
Received: by mail-oa1-f98.google.com with SMTP id 586e51a60fabf-456395f4e7bso2442148fac.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249966; x=1785854766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4PlKcANzq+y1Rq4zco4LLPjQUEuNl07QXAtQYWq7XU=;
        b=g5CL9yN9D9scnnkScauIXmDaWt9zMkBh+ghA7T/WgAiOCNDLV2Hq5+El7E2cPpzYCJ
         0RWjSpuoNbEjACjaSAcEi5K7bn+HrDfBRAGC6Ln06d9MG/VFhJsA00Y/1EdccsxpfjXj
         Vi8OWANYTb7GBzgcAdQb3hWfQPQR1aMaaMhwihfMpK8TJ8nbe47DYQQkEnYnOq+IHu8H
         XcTBeRZVl3dGUdQdOTPXwvd0V6ErjYK3n3TIljksf4J0rsT1PkbzhEOTL9ovW14ugkVf
         Pftv1jQdT5kdrJw4UVaE804zTpnHrEHJptW/0CYS2H51oLEyGVvIKU6DXzLQUhtzZjhw
         Q4sw==
X-Gm-Message-State: AOJu0YzyGMDtJHhjN1lDJFwrvbD9lNXlqoKI9OC1wlsIbeMsy5jdtMVC
	WSu3jgpG6KkyCaE0fvnknPJepFSa9LeEjx1OGPpfNVWpp3eU2jIroTKCYf7LSoF464q6zkdhF5X
	g+UR81GmWLRoqYt/E7/3LxRMYmPkbDA7taKl8zHVyibSBAD/4L4zSbctldo8mIDDRCvmkhyjJms
	vB2Gw4f93aa4vphXvkiIV3yCxuASJGDzIDBVqYKotV5KyO2gP+fF0NicSzt96s5IHupC/cICMji
	lteUOFz2tnUrddlXw+M0d6djC3S
X-Gm-Gg: AR+sD12xSi9JiLwNKwLefRR02nG+/ssmQ7sTb6qFY7ZpR/HDfU63u9RFhhdfSCAyiBK
	OsMKp+PiBXGTxvN7H2G5cWW1UjR4ljLXfeI/H8qkXGralqut7Q7JWaLM1cjJi/muiId8WbOfnjF
	qQmMeh2OMLxf6TChdcoQlYDp/VHRTyQowPFx3WwAnMOEYAsfzTYFzgcXfW8TjwIM/co5KIILzkn
	+9n0h75ICxsPuTb+bi2VR4AJKsINlXjHAWEg3IT61XT96Y10kSnenp+LkNylkTOee0XZhS3qGiq
	Al8tFlIBSp4SO2DoPvV+VowtU42m8lGvDxqxY68g/KXxm9Y2l2bCW/NudEkBmC0vqPXorSLqUp8
	o8zRaFeYREhN1EvEwpynT2nAHcFRa73EDPNtpno2GCBPBy5cwsPnEeCLcQglOGFt3WYQ/HCscno
	ZzOFpXCyYmXvi0rYlo+xujq0a8QtqywazgC5EdTz8=
X-Received: by 2002:a05:6870:8a08:b0:448:8bdd:8358 with SMTP id 586e51a60fabf-4586c68ea49mr1546895fac.15.1785249966622;
        Tue, 28 Jul 2026 07:46:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-45886b5cf9csm3013fac.15.2026.07.28.07.46.05
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-930edb4362dso416926485a.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249964; x=1785854764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n4PlKcANzq+y1Rq4zco4LLPjQUEuNl07QXAtQYWq7XU=;
        b=VFQdyxyd9z0Fe+GCzxe+RpDYFlFjC4H9BkTZlACQ0PQ4pWI1nmMJWhIIY2PGtIoSmZ
         clSZu08Idv7Whgfq/6z8wBk6feJJIn8H79WNVRGx3ZidOinT0JhLI3vROlJTr73F+Nsc
         h3qXlRZLZAOvIdbln+4OonersDntLFdYp/PA8=
X-Received: by 2002:a05:620a:4587:b0:92e:63bf:9583 with SMTP id af79cd13be357-93302792557mr271034885a.63.1785249964524;
        Tue, 28 Jul 2026 07:46:04 -0700 (PDT)
X-Received: by 2002:a05:620a:4587:b0:92e:63bf:9583 with SMTP id af79cd13be357-93302792557mr271030085a.63.1785249963953;
        Tue, 28 Jul 2026 07:46:03 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:46:03 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 04/12] wifi: wil6210: use pre-assigned cookie for remain_on_channel, mgmt_tx and probe_peer
Date: Tue, 28 Jul 2026 16:45:41 +0200
Message-ID: <20260728144549.2207061-5-arend.vanspriel@broadcom.com>
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

