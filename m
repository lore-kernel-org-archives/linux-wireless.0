Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A771A23A4
	for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2026 00:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783731263; cv=none; b=m5IUT+sSkcl0LmR6SCO4Qyt+urp7mp08qcHx4YS3oPo5CeCnZDfoBivyFA9BAkHomEhd1uThy/fy2dl5yEoPz8LrxMpLSUw+yPErUYClwT9ebaiRyogyag1E3qhjnXNCanFDe4zcm6LWsv+VPxcFfek72vvJthaY6W5VeJCciCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783731263; c=relaxed/simple;
	bh=7O7Ys5pGj78/u8nrdu2ukPAzmeAitV2Xu6aD4Py/vEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U9IolpaQ9rC88igiTyrfX6kGis05IlgDFokhImCFFUW/RRTCE6AqE8OyS1ZZ9KO+znNScvZVMzsOYy3ZHBsZA2jRaQzbdZKKAB1zWxF3bgyTB7mBNjZB6JJ73vNqS+QlhgRgmvXehn3P74vINQ5bh724L9Wgv4ltZe3IUtViQ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--yuyanghuang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YSZWKIaS; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--yuyanghuang.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YSZWKIaS"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2cd01a14e81so19555955ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2026 17:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783731261; x=1784336061; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=52oFjEQxVKmNTciLxs+PW1u2TYE3Y4rq4FXh2hf1zy0=;
        b=YSZWKIaStbK0dVGXjq6NZpCqgKor8rVCqqINvRiGB3m9ecR99Ynf6bdSGUjuKlGDme
         Vzq15TRX8z66OAcfz/8EIqGmYUPs+t2rFBRM0cMo+/aBD97KKNKRgx+5Yj3/ZcNqnJGs
         XMstGzC3rj2ioVetk2ESjVVJmQMJvYPMpTef3JMPOXDQXSn1Hj25uf7Zy30bLtYlf6n2
         Pqsan7QFjY5ckPaWUDDK54d9bvO2abivs7Ai4nxI48TWaoi1Bq6aEIuzJosSitHd+aL+
         eTUnzhuTRJUqSnlwJYjHaOwl0gi83U7L55guR1jO0lh7XiRt8bGvnIM7YyP09p+CYZS6
         S62w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783731261; x=1784336061;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=52oFjEQxVKmNTciLxs+PW1u2TYE3Y4rq4FXh2hf1zy0=;
        b=ZLI+sO7otqybOcjS3Ib0UL9an8oNR89zaJAc1fYbJFWJH09SpzGCFLJlYR7Pp8XTvH
         nT+DAJF5DeAJdAxetxtwXBYKEJKVwO4kk9mKxJ3u7lnmm11jvOxYDjKQ+SA7/I55yGBF
         qtaWml9cJUH+grmT4Wf2G30bqUzfJ7GyfdLHRP1IsK2XcwzfiKk69emgZYyHQBHUSNPp
         pdeGFBLUVfCNqbAsEd2DFDs/aX1EYMyk9OoO5OZ9hNEi+Lxy8RZCLCt2nITJPDXRplcY
         Yagyliy+n0Nx3tWnc7unkVpMcL4W4VQVbErf1ZiDH3VZqkQdEn0oe3Say0H7fSlzaCb7
         8CDg==
X-Forwarded-Encrypted: i=1; AHgh+RrQpXn8v/EePPBSw5k4vn142U5Fhfa9JuKu3wcFbdwDSZBg9xZeCRayIMNM60eD6Oyb2OrFfvOgKsv8NsD1jg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxrHcUoCKg69j8mLyVQsEoETPkTSz/zKa5LlkwOhXjoMk7dCtD
	z4yBJb4qpcJnIDXsUABEqvwX91xr6sjlROR3MDBMSMTj9j5VPfDi9BjxeHV5tAjSsrN2NLxuTUg
	S1nAJrxvGGlED6EUHFWHMGHMsrA==
X-Received: from plss9.prod.google.com ([2002:a17:902:c649:b0:2cc:f9a3:ad11])
 (user=yuyanghuang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:db03:b0:2c7:ebfb:618f with SMTP id d9443c01a7336-2ce9eabf95bmr14620515ad.14.1783731260961;
 Fri, 10 Jul 2026 17:54:20 -0700 (PDT)
Date: Sat, 11 Jul 2026 09:54:03 +0900
In-Reply-To: <20260711005405.2861680-1-yuyanghuang@google.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260711005405.2861680-1-yuyanghuang@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260711005405.2861680-3-yuyanghuang@google.com>
Subject: [PATCH net-next v2 2/3] wifi: mac80211: use ifa_dev from event argument
From: Yuyang Huang <yuyanghuang@google.com>
To: Yuyang Huang <yuyanghuang@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	David Ahern <dsahern@kernel.org>, Elad Nachman <enachman@marvell.com>, 
	Eric Dumazet <edumazet@google.com>, Ido Schimmel <idosch@nvidia.com>, 
	Jakub Kicinski <kuba@kernel.org>, Johannes Berg <johannes@sipsolutions.net>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"

During address teardown, the netdevice's ip_ptr might be cleared before
the inetaddr notifier is called. In this case, __in_dev_get_rtnl()
returns NULL, causing the notifier to abort early and fail to update
the ARP filter.

Fix this by using the in_device pointer from the event argument
(ifa->ifa_dev) which is guaranteed to be valid.

Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Yuyang Huang <yuyanghuang@google.com>
---
 net/mac80211/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 90d295cc364f..0e7a60dd1d8d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -588,9 +588,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return NOTIFY_DONE;
 
-	idev = __in_dev_get_rtnl(sdata->dev);
-	if (!idev)
-		return NOTIFY_DONE;
+	idev = ifa->ifa_dev;
 
 	ifmgd = &sdata->u.mgd;
 
-- 
2.55.0.795.g602f6c329a-goog

