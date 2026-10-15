Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CDF54146F
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792077794; cv=none; b=AQdDn8nnW1BlFLzWSrcWFaVfDbv6dnFlt2n9cZZ46nhnPFyibNFH+BWsag3/iRkIQjJwWM96CgAT06VMU/GXjNQgz8+cC/Y68AuwnXM1ySdP88r1tvoehkrvqEoqwAXOki1q3MBm+7zLLoHD5kqmclAEiYj3WYAMT0DY2WyNsDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792077794; c=relaxed/simple;
	bh=4dauBJvADEExgMQfHXq+IRvV55pQwyhrlwye1iITDI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gbkZa+yx35tL99Y1Taj+2kXxmyrJf3wVdQafH81TI3RcI5Dkw8JTD07CoR+QsJlQsnnSBYvDk84BKn5MUmkUQmJrVeD0nMy/iK1PYsaL2ZPXdDPqvNqiv8SvYuPRf1MP514Nt9tlJzUw9/87/mHm3Z/gmy7O3tCYNfN+QQ3pe0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P2kl8slx; arc=none smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2kl8slx"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-677dbe051d4so1789194d50.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 08:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792077786; x=1792682586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ffUdm1w2bLO+0OCh3PoxdUD/MaQBekn/KGeOVmB9bPs=;
        b=P2kl8slxMqYdvWUGAqupDV/AGCjUpYuzZKb1JeqdzsWkk4ePfKV5x9CUYQOyLSRd3A
         EfkFRtm8MAks+l4MpMYjENvTFXdRwnV5s/y+P4cRfsrYY+olT1Ra0idXwC75wKQNz9So
         FHnSS0um69oQPgm1VqSr5A5/Dgc9INpIHAQ4JWtP7Gi27Xl1MHFl9KZt2L1e+p4L0LK2
         uaeQi06xoO9ouyJUWqkCvrHsxGYSTNLGMXZg+EjvwRG2HPb4h+lq9GB8zFiNvGteduLi
         iMF/Z84dP6++DeVbDpC3fdk0Q+j6Ncqj9uaVZWL0mqBmKWk4lotx9wvb5l3b8k/0+tPW
         2XRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792077786; x=1792682586;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ffUdm1w2bLO+0OCh3PoxdUD/MaQBekn/KGeOVmB9bPs=;
        b=BZO9kMipXI+zl0FYY+sj/yv8JVFaCRLWU/1/Sh7vO93wYk9mQGoP0W+/s+ER16Cx9L
         xw9qm/PMzOecdwsKrpRbj2+KbGBZpnZIaz6Z7HBwMsFQh4KaQL0NwO5tMTpq5aHP1zc4
         ilkXMpmKsiQqEjbO/JGdd0lCMfQrnV6d99pfltiwU3lct1yTHxiZD/7hakLG3swbssDl
         bckQyNHMj2kQGJMbgH4RF9ARSdE/a33O4aTLgB7OCk62MSVDQVNhqstW21iYJXm9bG0W
         wLX7eBbpbHfr3YIKHqV0KrbTuEbW1rPDIaFNLhF+cyfOI7v20YECW5kc/SptDK3WPSbw
         D/Ng==
X-Gm-Message-State: AFq9FYLMTIm2eDOtcEyVRytCF616dktAqj8ir6KnqhsDrSu2B/vIEwAk
	px46hP7zZFXVF6kTbXMgQhzLpK7cqLQGm3BqAv4eqNvrVdAXAMrSy9A0
X-Gm-Gg: AYBFou2Y5k/PRiv2j+W8wUA4EzKHQaHdn7YoKZBBPaMIEwYkwD0NwSNHOHLlhita5wt
	Ea60N8/rxeUy/vSSrlKRi+LAx12CGmUc1LUCCmosZ+gFaK89wV+g9KkqM5ZLFNgG7o/Q2Pk3njC
	uTQc+pNXP4MEXCuijIGvFHBRg+eF9Vy2FFGLMq5O4S+7C7VnRQcDgMroOzcPobh2AUv5fnWCQMP
	4pHGYNliiQwi72BHaUU1zfFnnqots6HnO2DizHDk4I0ATqq6kq6h22rxeKJYMe+5uqX6fJyffiQ
	UI6Iu9aSRVx3kDdY/wYAsY8tOZOgtGAut/aDn/NjHwfwZWKnJgip3GfTwNQEN/vBm/yTHDJXd29
	vJaeZx73OQMQJ/QLRn8+sH8mJ4heo6EJoOPNXKPvDI0/2yihNFPTuGPwNH0s9MhJdP8ys09u9Ut
	yAxdhkWUQpXb8LZC9xOyWmMozrrfg9b7efoRCV7zF6JXHpxacxcy1u2kSO7ffagXYS0nBc8CCkh
	oNytkoWlj4FySkQoAcoXg6Rm2x6kFNuvSP1kclZEXiIMWTlJeNICxFW/TuroFVPcocrUOY=
X-Received: by 2002:a05:690c:c4e9:b0:8b0:9eb3:dbd1 with SMTP id 00721157ae682-8b09eb3dc7dmr36797807b3.37.1792077786332;
        Thu, 15 Oct 2026 08:23:06 -0700 (PDT)
Received: from tux ([2601:7c0:c37c:135::8803])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b07f2320a6sm67686617b3.35.2026.10.15.08.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:22:38 -0700 (PDT)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>
Subject: [PATCH] wifi: cfg80211: Fix error pointer dereference in nl80211_pre_doit()
Date: Thu, 15 Oct 2026 10:22:08 -0500
Message-ID: <20261015152208.351083-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nl80211_lock_and_recheck() can return an ERR_PTR on failure. If this
happens, 'wdev' holds an error pointer that bypasses the non-NULL
check at 'out' and gets passed into wdev_put(), resulting in a
dereference. Clear 'wdev' to NULL before jumping to 'out' to prevent
this.

Fixes: 8e3d9039d280 ("wifi: nl80211: avoid rtnl for commands that don't want it")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d790e204aee3..7a5f7000fbaa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20192,6 +20192,7 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 			wdev = nl80211_lock_and_recheck(rdev, netns, wdev_id);
 			if (IS_ERR(wdev)) {
 				err = PTR_ERR(wdev);
+				wdev = NULL;
 				goto out;
 			}
 		}
-- 
Thanks,
ET
https://github.com/sponsors/ethantidmore

