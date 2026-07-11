Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7AD19067C
	for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2026 00:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783731258; cv=none; b=dQoZfO31xR58ZFP+5BeRxs4VxlCSIo+ac4I2kfMOttTzPYVu0HPlD/cqqTNfeZ+ZYtECGH1ssmxWe/pObWMFNveVErg2OT70XDTX90oYp05ixAUlm6BJ5cW2awJVVQBOnwu2YyA7ViKlh4U7iGNihTB3+YnD9ys0RaCGW3OaoZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783731258; c=relaxed/simple;
	bh=VUZMyy4yqPr33oPrmPpLcdtWGay1olntrZbuKoAmfH4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oQrvjr1qsX0tp9ncg0WwUf7IfdtJrO0MT+Y//wSt1Fnz0sPTZJH7TmbVCVrJeqSvC0BE7cv8UhgnDS3oani8V4vauadwNcgqaek1jK2hU+MGsj7KB1AqNsIys5ysa4yACiQ0/G325TISyCkQFcdFsEoII1vA7MRw8wmJFUAThkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--yuyanghuang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LK2IgSTx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--yuyanghuang.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LK2IgSTx"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ca3b314193so28288365ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2026 17:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783731256; x=1784336056; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m5cBCU9B06eC8xl8Z+jo/WJy1xgvxmqcjs5XDBzzPoE=;
        b=LK2IgSTxQDkoqyGcYqKBJiYJM+jsQSA4Q7g7Wo+9VnvjiAY9ZbJ0yTtxzrObaJV+KS
         JaE8LD3+pQxJvolJWBRhsffOk57MvTdudJIcMEXOMVEPF4T1deMRdN7V+wUctkfxcgDC
         O7wyUzthe01RoE2lzb4w8bwEWw3tuGyz+u+paHLrLsR4g1V3F4rQT3xBQL0lHwVJJqOS
         iPlY3gKRzXBti0KBuLmfM8h/LORl8+PMRYMmkCM2pJvF8nuuR2ltAwuhmovP3KuGKfeb
         JD3xE7doXr5+p0aBcof6asoC+Ur9Nyil3OZ195hx0a6x72A9zFOS/i+7bv2hg6DjdyJZ
         qoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783731256; x=1784336056;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m5cBCU9B06eC8xl8Z+jo/WJy1xgvxmqcjs5XDBzzPoE=;
        b=JQMsiHdKyoAR6IZ5iX+7SRJav+teYf8RJn6DsoSgSZCoBJtP63Dt5p5uD3bGXWyGZi
         P0uLJFF30PZrDwyLWKt/dhy/0SYemMOb8bXwGp9pPd42jX7ZSRDqQTT5MughFrrG5onA
         GSnB7En8mOGMXkWVw7xS1ruEwSpbd1kA4uDbtL9x4e86jMHkHSR9a7ClM//diKbl2wuX
         IGrh4H14HBqeXH/cWbBGAGfpnFmtuBizYVO5gq7sPElitXKt3N0w1lAa6RTwRcGXqgWS
         rzwvjNDyygq/EmxFx5AhVcfl6lTd8U7YqVPo/tSZ/hwvEZoOLVkgV6CyrVDuB8NK2QZW
         gQwQ==
X-Forwarded-Encrypted: i=1; AHgh+RqqxbJ5ZTKEPGPYuafJB1O3MfBNV5S6rQrH+euNL1HjhgAGzdnLvc9lRNLai5i8WvG+Xo/uvbQecsA+CeM1Ew==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHU3NwRjAP5LfmM0D2l9eqAL9jb0S0BPxWQmvZB9zITXdoX8YP
	SQNVuI9ck851uwa5yS3j+ZFh7U8n1IwLwdSaJABiHYKf8Sv79mi119zAzxXZYRgsNPXdZIaoCvg
	ZcWiPx4ns32AnPRDxOeXNYn7eIg==
X-Received: from pjjy22.prod.google.com ([2002:a17:90a:6c96:b0:387:9b6c:b940])
 (user=yuyanghuang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4ed0:b0:381:bc4c:da56 with SMTP id 98e67ed59e1d1-38dc75f4d00mr1113639a91.19.1783731256346;
 Fri, 10 Jul 2026 17:54:16 -0700 (PDT)
Date: Sat, 11 Jul 2026 09:54:02 +0900
In-Reply-To: <20260711005405.2861680-1-yuyanghuang@google.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260711005405.2861680-1-yuyanghuang@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260711005405.2861680-2-yuyanghuang@google.com>
Subject: [PATCH net-next v2 1/3] net: prestera: ignore duplicate RIF
 destruction events
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

During address teardown, the inetaddr notifier may be called multiple
times for the same interface. Ignore NETDEV_DOWN events if the RIF has
already been destroyed, rather than returning -EEXIST, which aborts the
notifier chain.

Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Yuyang Huang <yuyanghuang@google.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index b036b173a308..0c4f462baa6e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -1302,10 +1302,8 @@ static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 		dev_hold(port_dev);
 		break;
 	case NETDEV_DOWN:
-		if (!re) {
-			NL_SET_ERR_MSG_MOD(extack, "Can't find RIF");
-			return -EEXIST;
-		}
+		if (!re)
+			return 0;
 		prestera_rif_entry_destroy(port->sw, re);
 		dev_put(port_dev);
 		break;
-- 
2.55.0.795.g602f6c329a-goog

