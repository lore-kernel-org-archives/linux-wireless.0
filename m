Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9220D36F90C
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093973; cv=none; b=jNWY7lbd+KHbjWtLZDrdzNByGI4CBtfQB9igIDgNmN0s8DpDPmQY+6/96LO5eSEZdEvTn4tumJdbKXEdiBPGdLV+3lotxMNsmgr/DiMEm6giLLvXkU8Pk5s7HmTpDlc1p1rYHVve98lFkqDkPzDScJ8afYKx0aKjbU6jmgCbM0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093973; c=relaxed/simple;
	bh=wIz+3euQACHcMtzoe/1WVQoQpiunxZW+Fc/WKDXM5WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLMNXnn7RnQVaUxgXKJXmM2An3UKxR32pvi538OuBGHAAsHKRmRAoakts4iR49SeTPsvhJeHUrJx6xnS1LNBotz98V71VIqxD1AS7btIHu6OaQGyBp3hqqo2Y6GgUjyb9EpalD03iNjR1xZaKDLLwZ8trtTLebP8XTA8s+sikc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SwZGm+qY; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SwZGm+qY"
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-66843304cbaso2800103d50.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093971; x=1785698771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VwmBr3II+Nl4yIpxO7BvkJDCioVvnXcf67GLy4y8934=;
        b=tYg2H1kQ8SMOW/T5+c3qkyo/V2i5QoROhxwlc8btMl34JvG54O8tRDrDIeVxKoaLw/
         Xh3yj0PNXaLQB3RC7ApVZpYjuwvIYZQG2nS+jlW4Co5pn+oPoApIi0WIgFbKqsqt+6RB
         C3pG5dODq4wweLEir8v+/08hKkMnQNczAl85gXjdkwvS7rbtWabSJ9/jF3krEiFGa6fq
         tiqtfLIoOsjikjvvJKfo1gs6yq2JFYvUZsljqhvoQdhJu8eIV7hw/bjaQNiDxDlDfn1k
         FK0DH1B4rfwhdk3jiCEE97b4GBQkhW2mGLlMwozpou2VSI1KTDH0D76hg6v9006aXurN
         dNHA==
X-Gm-Message-State: AOJu0YwannpFW6lp8NExqLrQaZbsRsKB+ppt47wIpTmw4bOPvXnKsMef
	6XJMtD8WgN2JRwsxD5LQCx7iXEKE3GSsEOoLmVwDwhrajLKNIF10aLSYviIG8yPqmKSkwXYpBP6
	f9sPWQh3D4GXkXuIZtuL7+HyznY5vjB+rEX4VSnPRQrfZ6NTa4DVqprd7u2KvzwwuMOEaovdiGK
	Xoa84mypAyy1/b2D9dM7KYmdt5vE153jAjcsXSSFKeUYJgbaZVVVCcHeTLKXcL/ed8FnHZ/rI7P
	UBa5NAQquRiOtccGU7QlPvW9zBM
X-Gm-Gg: AR+sD12XhLdTl/tmw8GqsxlgwUzHm+0MrJ39n/jL6zvrjhvr3XqTsfns0arTRUaZV+/
	5KcdUpsOGHaBSjWZ+gdvdklM7IQS1fN5f/YFtiQcRUZstroUmFA/vwjTm2jc0NeknKm8avXm0RJ
	Mo4d3kWtv/Xk8VwpnuUAP/EHwKxwVxdPV7xAXswZ6WcS/RC6Y+enbuAc+c2UvGoSzz8e3FJQZZA
	yaJUm1mGpLRBz0Tmse16OyISzm1eU+hZ1aJ4MGohaFDH0zd1j6hs4Xp2KgAZ8liSAsn9WVj14IU
	vpFzvnwMHZNyxbukVnQeBGPPDknTWnU4rspTRtKs+31upnTbpKQ7ycOMEY0mM9agXCl0Ltecwza
	X+5cnQChDTnMjBTEG9guvg5BHhA6HN+77o/E0+YlPsVv4kzd/xENx6JoM4ddnZvcVaCRHL3xPBC
	57VHf7rfLocuSVw+J1yPkK9ecC1faQ3VPcKFARngM=
X-Received: by 2002:a05:690c:688b:b0:81e:67e2:f75c with SMTP id 00721157ae682-81f69d5577fmr16402667b3.32.1785093971403;
        Sun, 26 Jul 2026 12:26:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-81f65782d03sm2451537b3.1.2026.07.26.12.26.09
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:26:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb5ea36f969so2312001a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093968; x=1785698768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VwmBr3II+Nl4yIpxO7BvkJDCioVvnXcf67GLy4y8934=;
        b=SwZGm+qY1Ejhd3EDy/0zY7o+72Mp9dXj7jPDnVKNcGjwFN7Y3L4njg5oyaBX/wUDyZ
         4fjHqsYkgVt29n1W7iEc9DuarJVvjZmASM5EaYpYXkMuMxYY/DH5V35dru1ZlY4rYG9e
         fITtB7DUtO8Ubki+7v5QXbGh6TBR3uvV4IuKY=
X-Received: by 2002:a05:6a20:12d0:b0:3c3:7179:a640 with SMTP id adf61e73a8af0-3c67dae9754mr5310983637.3.1785093968557;
        Sun, 26 Jul 2026 12:26:08 -0700 (PDT)
X-Received: by 2002:a05:6a20:12d0:b0:3c3:7179:a640 with SMTP id adf61e73a8af0-3c67dae9754mr5310973637.3.1785093968087;
        Sun, 26 Jul 2026 12:26:08 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc44cb92sm38355795eec.13.2026.07.26.12.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:26:06 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next 08/10] wifi: nxpwifi: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Sun, 26 Jul 2026 21:25:39 +0200
Message-ID: <20260726192541.2816743-9-arend.vanspriel@broadcom.com>
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

Stop calling nxpwifi_roc_cookie() to generate cookies in
nxpwifi_cfg80211_remain_on_channel() and nxpwifi_cfg80211_mgmt_tx().
Use the pre-assigned cookie from cfg80211 instead.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 4f9e20f72811..198174ac754e 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -212,7 +212,6 @@ nxpwifi_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	tx_info->pkt_len = pkt_len;
 
 	nxpwifi_form_mgmt_frame(skb, buf, len);
-	*cookie = nxpwifi_roc_cookie(priv->adapter);
 
 	if (ieee80211_is_action(mgmt->frame_control))
 		skb = nxpwifi_clone_skb_for_tx_status(priv,
@@ -277,7 +276,6 @@ nxpwifi_cfg80211_remain_on_channel(struct wiphy *wiphy,
 					 duration);
 
 	if (!ret) {
-		*cookie = nxpwifi_roc_cookie(adapter);
 		priv->roc_cfg.cookie = *cookie;
 		priv->roc_cfg.chan = *chan;
 
-- 
2.54.0

