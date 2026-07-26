Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554CC31D39A
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093976; cv=none; b=J7FV/iwJHj7SWd8mmETQ/+QhZC/WtBnpu2ZyRNQrr2Kx8tqJgdFgFp2VZbFWKuG1d59p/5Kvk9+8s91xKUyhOzXVt1gT/bveywPCk161ceovHyYcJF3wtIqRTbVKArJwts5wgn9q6jhiE8J7pbazgSHgVzZ+32vwD5ODfq7B6Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093976; c=relaxed/simple;
	bh=YN70RHjCwmQ83vx3SX+04RYNQVnGpUEZQcVazfzYY2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9I+mXEZsFQXF+8weV8P7i4lU3+aT2n7jdxlXWDGBnpvqnS7/MxKkOZvca0xcAbrCNkeeD1yGLGDLBdKl2dj4H/sq/MXmm4iaPdxBzdop4BDbG53SAPLV6fVIu9OikPVKD8HWPuYKP3xSaTvyzOxHECT8VHE90PNgbQWWozsHco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BwkGWwaH; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BwkGWwaH"
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-6689f36ae56so2635230d50.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093974; x=1785698774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9mAAQLzPAI07RqkNYsgKLJ0dCN5z/oc54+anUQNCXX8=;
        b=IEPw8uYtSTBsLMlFgFvJ9TwkkzOqlA2mREkO8j2M52CuHZL9nBw/PIIrpzTjFk2ZaB
         CymYCF4Yl4eroM18xsrY4X3hh00bgvrAyzVQiNRahWTodFIG3OjtD/iKvAQsRBujEg2n
         ByNDY6iQW5cbDm/f7e6LC5CrqBTbWPJmDJHZlYeILIHkYs4V2FkliAVSdbeYSWE1gXte
         H7GaNw/z0ta4o+Kl1mcR+IzWq75JCPmvuL3tkOAL5NGKbsVj6G7yGu/9NGoRYCShmut3
         JpIPm4tsACahyeKgHrD9A/bZpr3GYnGSNvX2mWoQC5nCF+DrYcr7x7e7+Mougs4nTxvP
         IrCA==
X-Gm-Message-State: AOJu0YxvC5sWMZSKx4Riainuj0DnP6NOKal7vpyNvMsfwUgX+qvwT+Kz
	i+ybcAYnUfZp/v4y3jYNArElqhlBuRPrrVoKBvC4x5cwKp+xfnXhbEeL+Iqf9ZdhgqQg4Wg0qt0
	TfickniQRShtVInJmZEkj/GBqUb17POvkQRrf7U/VnnalRNJchfWXo0LX1e4ZgZ15ZEJG28yBjk
	/mxfCxRDHq0qKpXSo2hRpTTmeO7EQM6AOHEP2rl9+2IomdakCBtoo3fAuaPAfc93Vskqru8GWob
	97PWxnrXx1HBJ/TMwOoiZqNNkA6
X-Gm-Gg: AR+sD13CUC+Q3aBbx+skV1wurmSzQtsdxJi+y3PSIL4EW6tuVy1lx3w9sbG3vAq7Pso
	/FX67cqke71hj/fBwLP5nipWxNIqID9Xo9gqIJoefATg+cZ+JNR8zQlNGny8uipy59n8/gXiLF8
	zuYLHXf+gXE9zqdJw2wgqcspjr/HHwo3aKmbgsV5/Z50ujfNIksziIG5PB3s+CD3cBSUjYP7LCI
	NCXlQLaLkwFcDqE/ruEMpmvv8VPve/sNVppEFt91hNx3uR/0+1YpWgCdcBAzrOANu+kXoOc+KVw
	g685QibPeDkYNh1dCNbFho1XOG6IRIQbhDEXD6ZlUPBH+PmdET22ls/CGo1+23Lce0sfE0sQFDX
	A9bKKSU4MEUIzZvV9czTCy5iA8NV9C0ycX8auAPbn8p2U4/a0bteDVB78wlqMSZqj3bAUCWtvBf
	jGj+d5jkEEoaMQyvV/XH+o2dvRgGZaysjiQDqd+j8=
X-Received: by 2002:a05:690e:134f:b0:668:14b:e5c6 with SMTP id 956f58d0204a3-668c7a483c7mr2057571d50.42.1785093973856;
        Sun, 26 Jul 2026 12:26:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-668c6d2fc9asm470636d50.7.2026.07.26.12.26.12
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:26:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cab041eced3so2810693a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093971; x=1785698771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9mAAQLzPAI07RqkNYsgKLJ0dCN5z/oc54+anUQNCXX8=;
        b=BwkGWwaHvC5vm19RuRnh1/rg5u15MR4wgnIAtpVk7jGffQvNf5a1xlAl9IbgsXDPKO
         EYzYVkhVPS0wDapajd6hih2MnZWaBUw+rE9l4sdLOiS9xHI/nhqivc+NNYBCVFMol/Yz
         KJ/grOwYyDZWSBCjFbaFyK6HDnC7zVHSc4lO8=
X-Received: by 2002:a05:6a20:d492:b0:3b4:b340:411d with SMTP id adf61e73a8af0-3c67dd8a3bcmr6307802637.24.1785093971742;
        Sun, 26 Jul 2026 12:26:11 -0700 (PDT)
X-Received: by 2002:a05:6a20:d492:b0:3b4:b340:411d with SMTP id adf61e73a8af0-3c67dd8a3bcmr6307788637.24.1785093971314;
        Sun, 26 Jul 2026 12:26:11 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc44cb92sm38355795eec.13.2026.07.26.12.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:26:09 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next 09/10] wifi: qtnfmac: use pre-assigned cookie for mgmt_tx
Date: Sun, 26 Jul 2026 21:25:40 +0200
Message-ID: <20260726192541.2816743-10-arend.vanspriel@broadcom.com>
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

Stop overwriting *cookie with a random value in qtnf_mgmt_tx(). The
internal firmware frame identifier (short_cookie) is unchanged.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 9e44c85d2051..284bc61c46d0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -454,8 +454,6 @@ qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	u16 flags = 0;
 	u16 freq;
 
-	*cookie = short_cookie;
-
 	if (params->offchan)
 		flags |= QLINK_FRAME_TX_FLAG_OFFCHAN;
 
-- 
2.54.0

