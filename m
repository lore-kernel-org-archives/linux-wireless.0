Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439C23DAAD9
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 20:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838158; cv=none; b=KhOKhebFXwWbZ814s7nymMwU+kcMi0RY5wUiYy4p8ScIChWPpjNkKEKsL21cQqGE1W7xNcxj47gZT5U1qpRD36FHvVALUEi/t9yTxo/5unjcvvozxp56pgEIAusTboMsUDpImj8zRZawZP7CDEphcnZRJ4o4nrE66AuuM6kHUxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838158; c=relaxed/simple;
	bh=KWcKP2geASN3jo8/dE06oUF8rjQfnBcpV2Gx2J0AGTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDDsvT5jiDRPiRcVcJdBWwAVtSsN8g8U4pIJgGWbOVM+GClRqHjanr3wqMdku2go5XTm8KTRN1f8d/mI89UY7jyZJQpEJMK+RAe2sfdkmixmK/4btRdsiSY6P3FgSZ7yx00jpBk2nXk9kIkueg2q5o2/V+yrf1ru6ueJnyDgIjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ks9YL6b2; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ks9YL6b2"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c981c2c37cbso892856a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 13:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784838153; x=1785442953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1uRexGHLvlqsOKL6vO2NQvFV//36xeGbmQtRnRdGXPo=;
        b=ks9YL6b2wcV1Z/EO0atHpiS9aGR2S+qXRKLk2aMi5D2CBigRX4GBNyU81EFroI3jlA
         oU2Xdrr2Iopizqg30NeKoGCMklLp8nSKrjrt++D9FHw3pPHfN9jh/JE2nsH0geAJhkQc
         icd9vAWOBEuTu+AIBrurXJnUD+ExCRXx6YkNFz7vOzVofevRh/nvw3ZUTzQBQYC0Gsz3
         Ib1xSgaRK8lRdrH/jFt9r59wIwbr8fC0TQLEqM4/36qQmZO8Bo4Dsgx3lNhD6KuTQINT
         vIR6gEjM4RyW9F8H4HiY5gbMBEN3/WQwbQ5Lj3+j2Ws+T8j9IrRIiqPG+8gGpirxWFhy
         nDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838153; x=1785442953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1uRexGHLvlqsOKL6vO2NQvFV//36xeGbmQtRnRdGXPo=;
        b=BCz9hLqhS96GnPduIwia0RVUiJY/9a9aYszV1jtRddsSWKFKaQrifAxPLaiiZODxm4
         hFHZGsCNIJFlKNSqZuAJWMQRlw1Ek73uLCI0nCAU5pIAqkSQApeYLy/2HcEweSH5ExN8
         7vETZaLRRmrYUBFHgnrdOdXGgjGpufnxvSKGi5S20jYp9Y2FrZuFFVXuXVML9qsQ8dMI
         f0ImQxPZMcAGk51gXQBcqFZc74EhKciYR5QetiAyjr0uIaSEtaLO3+9T2xDysVun/nOu
         Gadvja2yOnbH280Zd23rLuViRZwC3YuXn/AH0b3RpL2p/PmUr9DLUFZ6ku6Y4AhvleSm
         OkOA==
X-Gm-Message-State: AOJu0YyE4vRIeD9aTl7RUlE1tHVeJEeLpeN7Gfjmn+7CHdNUphMxENCw
	FIrZtBxQkRQQFDhwX5sui5uPZjrgaCzn/epNHAtyCy8RfdyDHYT/dp/Vy/PUHZQWyZDbng==
X-Gm-Gg: AR+sD12oNIBBEQCV5nHKba3KiC/YPHAVdPaiBqImNA6cyrS5jldlTV1FXF2+zXniBxJ
	x85JI+82GLdNP5kHn+EVCvCsCK8iT/2YqIHXfrmkSjkQNl75UVw6P88AHIcO+vbSXx4sAeqX7Is
	w/RktEwneIrVJxtFab1Olu2F8EfA7m3j2lNaxbtx9CigSXuEGIUNZrmtzj0cnpADzmhh/Ttq2hf
	tWYwaJJ8j7wb+49mgfM+mXWkbp8j0aYsitsxbwuZK/8zkjg95RH9ObD3Tja5nXLaqOb38NW+wTp
	BqKLWNUfr4HbGxxiin85OQU1C162GPbFEC3FIiz8pDCWzFIr/XI6kpijYiPfEN0YJwji/twlp5o
	c6gEsSPdcjMtuc0+FlBXl1IJEOr24v4GAFFIDYPSqZQVNRXlsL7eyf/V4eH+KmT6je3nq7AjSLb
	wHI0eyPJ+1OpJ8pwC1J1BknCOBzAVLPWrG4AjPr/oo
X-Received: by 2002:a05:6a20:9c8c:b0:3bf:6c08:4ebb with SMTP id adf61e73a8af0-3c44b18ac6cmr5289759637.48.1784838153196;
        Thu, 23 Jul 2026 13:22:33 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([58.250.106.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f0ebfcesm3364119a12.11.2026.07.23.13.22.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jul 2026 13:22:32 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org,
	Zhao Li <enderaoelyther@gmail.com>
Subject: [PATCH v2] wifi: cfg80211: publish PMSR request before starting the driver
Date: Fri, 24 Jul 2026 04:22:23 +0800
Message-ID: <20260723202223.99661-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260723010916.76433-1-enderaoelyther@gmail.com>
References: <20260723010916.76433-1-enderaoelyther@gmail.com>
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

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Link: https://lore.kernel.org/all/20260723010916.76433-1-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v2:
- Drop callback documentation that implied synchronous completion was
  supported.
- Reword the local comment as defensive handling for races or broken
  drivers that complete the request before ->start_pmsr() returns.
---
 net/wireless/pmsr.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index d1e2fae5bc0e..97449bcb9a22 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -420,6 +420,7 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
 	const struct cfg80211_pmsr_capabilities *capa;
 	struct cfg80211_pmsr_request *req;
 	struct nlattr *peers, *peer;
+	u64 cookie;
 
 	capa = rdev->wiphy.pmsr_capa;
 
@@ -521,14 +522,27 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
 	}
 	req->cookie = cfg80211_assign_cookie(rdev);
 	req->nl_portid = info->snd_portid;
+	cookie = req->cookie;
+
+	/*
+	 * Add to the list before the driver call; under races or broken
+	 * drivers, completion may free the request before rdev_start_pmsr()
+	 * returns. Use the saved cookie below.
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

