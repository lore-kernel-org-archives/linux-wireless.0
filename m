Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6EF12C534
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768965; cv=none; b=sSnLECD8VLRuGVihrYqiaHA0OxLhdK9D8Bxyqv2yBmW2q8Hf51dpg9vh/0u3f3dyjQ/U4ksADMSyl95keJ0WsH4euY4m7gOfZpI3cQODymrJio2+ojgUqd/n9hmZB1Z9eV/ml5s29Ng1g7hsGoWBlIk8Q8uBLOAG0foW04Vorpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768965; c=relaxed/simple;
	bh=yNbi8MQpsTQ3PMK8Nhe/XHDQlPfbrrLl1OGxvluchAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TQqdWqvYZT8Pm7zBMg6YDw5oFTZpXu92hT1WbKXFIeZRdv4C6j0UE+DeX3M8/xCewN5dy6hb/W+ZPeafNodZnCLpRZeReOZLji8fSozrBy1x2IYuIDQX2QU4Zv/n25O6y+c30o4MQaP3e+d5RmLCm3SouQoY5sCGB78bIBLhpbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c7sTaBX4; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7sTaBX4"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2caced6038eso723635ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 18:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784768963; x=1785373763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DUKN5sPrRvuKbWGXM5C8TwKRW+R8k9MDgafaHsafP5M=;
        b=c7sTaBX4d+OTgGuaDsYP6zNrsmDB9IVPw81KnNd+iP0HAFvBN/KRmCeCN4A7ZPuYJT
         rsKN59UjYcu8F6+18CMIDvzZrlmyMX3CysPdOTWygAG1arkuH2985Z/6b1UqxGq1dTed
         mtPSjJyeSVKlEVlyvC60gwv5yx7gBdRFbXxStkYvWACj6qL89UQVoTpcl2ARRq3vscfZ
         kZBZz882NyQbcnkomv3RE663EPWx0It3MMUInouoz9GDxay/kWwd9cFnHIczmUMNd9Lb
         yKFI4BIkJt5jVY0w4EA8VqxUw4eTAf83U3hGfj5Sb7RurO88HL3sgPe3BjhOkAufDDwj
         jVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784768963; x=1785373763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DUKN5sPrRvuKbWGXM5C8TwKRW+R8k9MDgafaHsafP5M=;
        b=l2Eyqe8/00mltPSeaK7K895yM1bmUxymstqhS/raE2BIaeYTQnxXNqbvp1CBJL9Blb
         UFOtwkeIO33OjmIyOAR4eaaqrAcHdHQjnGkY/zBy9qKNIjBo5AOLFpfvGrv0lu9ompJg
         Boi7SPmJiowkbq47ll9b9WzW0eJR5EoBjCHpohbbd/DPD2h5hPj8W7CINutacmKvbI82
         tNv/DwRu/oSl11FHXbgeAHLR+D22iPi9jX6c/tBP6Hz9f4tKvnoSKz7ZZKxZIBXBXi+h
         b63r8B2fXYGihNQqsnXHYW+8fz1QdMu87FdS3FQ7oM6JFP3lvNXKpAHErKVktQ7Lj61S
         350g==
X-Gm-Message-State: AOJu0YwfOb5RC15q+Px0wGvFBpz/tEm6lOaiZnzSfNQGcXUI5Kq7zdh/
	Z+nRB4hPKbiczH7WmQfzjx6zRK7Xay3IR+FTZPy/6ySQrpsMYhPtsrUQ
X-Gm-Gg: AR+sD123jQPwoYDrNrMlI54VNVb5hE97K55e2S2oHJdvv9IhciBiZ8ogq2yTzsKUFFC
	yYm1cJYrH8ICXPcRCI/aErTZD+q6e3eborWfiFK3LgANlPZSIqCa9lWDGhUGxvfnv5TaFrIBR4j
	jnOLU+HPgR6h/8Cg5m/QcllFwuecpXI4utwVZYDsHYxo3VD8Jeni1ttHSbI6/+zQnmM3BQh78LZ
	PlvM57xDr7sMaXit2Uv7RCVf9vYh3XysLXo3PX1abUupzUjeRM+S+rbfvzkYhHXzu7q/zEa7vqC
	FSr9WZ0OGLUvbqWEOCDKhj5zl6yxrxwOrORXf5vWT7OVpX72tEndc9lNcPqjcqFP3YzuEINRTLj
	DvY/skPiIrwnq64RNEtFTSWca5lW9xm5HbQtoj4q+kjmGxSn/XU+H5TsqkubgE1/N3pXxzU7Ran
	qxyfNwNsKWIGmRqq/8jhXuMdnw13EkIInbMMNBM4XBm77FBGbaX2Q=
X-Received: by 2002:a17:903:2306:b0:2c9:994c:9a5 with SMTP id d9443c01a7336-2cfa9588d7emr6808925ad.30.1784768963146;
        Wed, 22 Jul 2026 18:09:23 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350554sm22562085ad.66.2026.07.22.18.09.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Jul 2026 18:09:22 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhao Li <enderaoelyther@gmail.com>
Subject: [PATCH] wifi: cfg80211: publish PMSR request before starting the driver
Date: Thu, 23 Jul 2026 09:09:16 +0800
Message-ID: <20260723010916.76433-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nl80211_pmsr_start() assigns the request cookie, calls the driver's
->start_pmsr() callback, and only then adds the request to
wdev->pmsr_list, without holding pmsr_lock for the addition.

mac80211_hwsim saves the request in its start callback and returns. Since
nl80211 uses parallel_ops, an immediate REPORT_PMSR can then run before
nl80211_pmsr_start() reaches its post-start list_add_tail(). hwsim also
dispatches reports from its virtio receive workqueue. Completion removes
the request from wdev->pmsr_list under pmsr_lock and frees it.

Thus completion can precede publication, race the unlocked list mutation,
or free the request before nl80211_pmsr_start() reads req->cookie for the
netlink reply.

Add the request to wdev->pmsr_list under pmsr_lock before calling the
driver, and use a cookie value saved before the call so the request is not
dereferenced after a successful start. On an error return the driver has
not retained or completed the request, so remove it from the list under the
lock and free it.

This ordering also permits a successful driver callback to complete the
request synchronously. Document the resulting start_pmsr lifetime contract.

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 include/net/cfg80211.h |  6 +++++-
 include/net/mac80211.h |  6 +++++-
 net/wireless/pmsr.c    | 21 +++++++++++++++++----
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f5abf1db7558..a8ba484ecad6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5202,7 +5202,11 @@ struct mgmt_frame_regs {
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
- * @start_pmsr: start peer measurement (e.g. FTM)
+ * @start_pmsr: start peer measurement (e.g. FTM). The callback may
+ *	complete the request before returning success. After completing it,
+ *	the driver must not access the request. If the callback returns an
+ *	error, the driver must not retain the request or later report results
+ *	or completion for it.
  * @abort_pmsr: abort peer measurement
  *
  * @update_owe_info: Provide updated OWE info to driver. Driver implementing SME
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4f95da023746..64600e7bd251 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4661,7 +4661,11 @@ struct ieee80211_prep_tx_info {
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
  *
- * @start_pmsr: start peer measurement (e.g. FTM) (this call can sleep)
+ * @start_pmsr: start peer measurement (e.g. FTM) (this call can sleep).
+ *	The callback may complete the request before returning success.
+ *	After completing it, the driver must not access the request. If the
+ *	callback returns an error, the driver must not retain the request or
+ *	later report results or completion for it.
  * @abort_pmsr: abort peer measurement (this call can sleep)
  * @set_tid_config: Apply TID specific configurations. This callback may sleep.
  * @reset_tid_config: Reset TID specific configuration for the peer.
diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index d1e2fae5bc0e..3484956ebb50 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -420,6 +420,7 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
 	const struct cfg80211_pmsr_capabilities *capa;
 	struct cfg80211_pmsr_request *req;
 	struct nlattr *peers, *peer;
+	u64 cookie;
 
 	capa = rdev->wiphy.pmsr_capa;
 
@@ -521,14 +522,26 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
 	}
 	req->cookie = cfg80211_assign_cookie(rdev);
 	req->nl_portid = info->snd_portid;
+	cookie = req->cookie;
+
+	/*
+	 * Publish before the driver can complete the request. Completion may free
+	 * it before rdev_start_pmsr() returns, so use the cookie snapshot below.
+	 */
+	spin_lock_bh(&wdev->pmsr_lock);
+	list_add_tail(&req->list, &wdev->pmsr_list);
+	spin_unlock_bh(&wdev->pmsr_lock);
 
 	err = rdev_start_pmsr(rdev, wdev, req);
-	if (err)
+	if (err) {
+		/* An error return leaves the request owned by this path. */
+		spin_lock_bh(&wdev->pmsr_lock);
+		list_del(&req->list);
+		spin_unlock_bh(&wdev->pmsr_lock);
 		goto out_err;
+	}
 
-	list_add_tail(&req->list, &wdev->pmsr_list);
-
-	nl_set_extack_cookie_u64(info->extack, req->cookie);
+	nl_set_extack_cookie_u64(info->extack, cookie);
 	return 0;
 out_err:
 	kfree(req);
-- 
2.50.1 (Apple Git-155)
