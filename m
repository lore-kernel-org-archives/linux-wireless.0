Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9887053CA9D
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792077518; cv=none; b=aMAkth3nliOn6/eSCTeILKl8dFxWFTHfKMjif95K6G6hgff2bLvYd7dzkzhbWcQpbYMid/X33+z5gCCETwRYWwp51/bI/ItJBSX4q7Sfe1z4nPF04aFsjOrWUSdBlQOYaJjQ9la3Nf9LEZIRzcSsHOvPp7Y6F1fx2kD3jFpXCo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792077518; c=relaxed/simple;
	bh=++Q8Z0PhbUqNHVck4+ce6iBGWIyeo/ytKAm2vgGm5Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OV6+1hEHuZFzLlLI4/Kz9WMZU8Tcq7aXQ5hJOLbrVLtl9c3hzIsWXdDYjiehv3eV8yZ2mmlZZyhIj/ABpWEUVtGaExr3CfY6870pVPCV+kVbQN24R9uLPH/eP1TT6IotO5m/52PJKghANCKpsjuQejgu7qB8f0uj5UENQfADqvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ln7aDGWI; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ln7aDGWI"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8ac4806e210so39243037b3.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 08:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792077512; x=1792682312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=657leYWjF62i3dCYkjoGlICrtXlQe1Ifza02V7u9nf4=;
        b=Ln7aDGWIb5toLh2Caalr47AHVFoYeIwJPW9d5+Oat2c5+wX8+batc8moxIAdGylbbw
         Pso0QApZQrDmBDoLBpNi1a1V3QI5Z7ejAEk8Xp+gJOf9LPyNA4BBJrJih8kSia/Xph7s
         vEKLHrI5ff6dvVbdjPovCRpAfr9SaxSpH7fLO1DMddV1pcoxXO4EdVhvdMOpqgyvk2Qq
         4Pu2BqDTMfXA0LA14xCF8r7xLgWv3fVJp6RXOoEfd0c+8Ty6x3hSZ41GBLA8roiks6kM
         1IDIhZBLbG4RYuOewq0GO5aNIAAXAq8YdQRvSRHGdkdO4FV4TiBBLYVc6ESzWSxB23vf
         ZD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792077512; x=1792682312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=657leYWjF62i3dCYkjoGlICrtXlQe1Ifza02V7u9nf4=;
        b=fOUtzeJTZCiXsc5NC+A2eFRROBL4VViMhsBLbO6yBEFQgP7QtnQ6k7sE79f5kSHRbe
         hgMamp1gxPjwxue2i0ZKE7rG2VGcaPr93xOACd2A7MPXJJVpPM7AxvmP1qQ0jeuSL7h0
         TrRRoe8ZfJ+tTwV+JhCB5YRxT3Uhm2tmHF9BVFoNztu68E6f+ENjhv5zydmSJzgcxorh
         NhvIEgcnckw1JsmwRQDP0IUYPshnzzVSlTWYFHLqxBfFq6j/WwFYPtthE6QGIrsQF+Va
         jmrJmWtH0jNGGRpGVlKYlNm8i0m+RM7OIYeXNQ4G+stoMNEeEyZ18PnlYgvQkn+vXGgY
         KalQ==
X-Gm-Message-State: AFq9FYINB9QvX/v9BqyWfWjQ5kbAUCAJ6V38oA8MnpId5qI0fIsLZ9E1
	D0oChZMwBfomqVJJU+yifu1JNZcoE1/txM05sfzFzE3NJaugGw5JrCrtCFAwNg==
X-Gm-Gg: AYBFou1iHVAxoeMWpLn1kSW4xywnAgJvGb03IpD8QBtiDvZitzBiCjxtasBrTakVA/L
	CJX7EpyrHotZo9trYUbs2Wu+BnCeokc+OrVVZdNqjjT27xC9wRDdRJMpmHX5yDNy56hhGjiQqiY
	N3t7A1VmqIwB2LeGHjJUlksL1u+VjpKwMaG7DRYd8s386r3LuA91CXNx37WIjwKv7aq+txRoTdO
	W7BNJpYWsSk6p1cioCWuYK7IKvDA6dBwO0hNClo8vAz74JqHmB552dmhvCCv7RJF9WQNNB1j4ng
	UzY7s1wltUn098vYVKOjPrQ09Israk4VFHQQqE2xIH/KC6A/ZkQa9FnwBpBA/DQC6W4cYN54OvB
	KNkEXISsuXfaxrVjaBEVcVcTsSwGNyCz4a/bxmgLnvRCGG2g4BRly5OolvWaJB5CjRL6tzQNsVA
	ArKsl9YK+PBMryRD1ad4sw134snDsM0SJ+bGxLYRYqs2gp/zMmkr6gaViWTtxpOYp0zPU2A9fuf
	Axrh3D//zUkCoDPFauzbxh54BZslCJL/GkybxxdSgYarbcVUtCEZzfA1dDFV+aSlxDgusw=
X-Received: by 2002:a05:690c:4003:b0:8af:1f4a:21ae with SMTP id 00721157ae682-8b07ee1dd1emr53956717b3.65.1792077512318;
        Thu, 15 Oct 2026 08:18:32 -0700 (PDT)
Received: from tux ([2601:7c0:c37c:135::8803])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b0c1d50766sm23093017b3.49.2026.10.15.08.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:18:31 -0700 (PDT)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>
Subject: [PATCH] wifi: cfg80211: Fix error pointer dereference in nl80211_dump_station()
Date: Thu, 15 Oct 2026 10:18:01 -0500
Message-ID: <20261015151801.348976-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__nl80211_lock_held_wdev() can return an ERR_PTR on failure. If this
happens, 'wdev' holds an error pointer that bypasses the non-NULL
check at 'out_err' and gets passed into wdev_put(), resulting in a
dereference. Clear 'wdev' to NULL before jumping to 'out_err' to
prevent this.

Fixes: 599b8a3c549b ("wifi: cfg80211: support unlocked station get/dump")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d790e204aee3..739283404531 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9031,6 +9031,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 								wdev);
 				if (IS_ERR(wdev)) {
 					err = PTR_ERR(wdev);
+					wdev = NULL;
 					goto out_err;
 				}
 
-- 
Thanks,
ET
https://github.com/sponsors/ethantidmore

