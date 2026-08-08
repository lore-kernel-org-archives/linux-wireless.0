Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12D234DCD2
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 17:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786209797; cv=none; b=C5xf7qy8EKOoc9JPzWgdGriTzRh5A/i+oVRnRaOSjftr6+vBYluBErk2GeWSyjbZGpaH8NlIG7RpB54zbP3yc0kTHZISC9g1iMejNhcxPCa1V7KX5hu+9/6qMD/TTIcjfNIN1OjITJxEiP+hmI7xdyawcVZ+f29qjtvVWg6H608=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786209797; c=relaxed/simple;
	bh=eb1PgPIaDeoCUvho6YCq/RkkxJuxQ6mp5K9gaHhmaqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHD14UFaE1HFY6kRgU0CYKDcv/Qo6tXJpR0oSHNhG0cV2SOzP4dxUS+hvYv4puMehnz2Nf1pW4xIKoMNMZqZl6uVYurmNTSQXB3SYAb4Smt8tH5+X2X64/V8ZlI3Srg7glvStXUqZ1XKbB+pn8kuQerBsH59jUtpMB0E+FuxYgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kwx0OfPp; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kwx0OfPp"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6685483aad2so823059d50.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 10:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786209795; x=1786814595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NGm5OdYw6hzWSbSy6f6o1TTEnHk5WqT8iRYKZzG9jW4=;
        b=kwx0OfPp03pxqB4A/iua7/tUyEfP/Va5RgCoEomUpqHqG/oQ69Bd6CUz9afoX8yNnu
         gxfAc8saakDLcrxPsNSDpLmqjLFKTuPi9yQtinGDYcskAD9VOgFtglA0NcAnke9uknZx
         BvSgWXi9okE24wpZXu1aV1m3LT+1dcA0L+PjmDWsICh6NkYADoCtoYtUiXm30TD1ltyG
         W3APAr11GcifWf17eB+PWO3+SW4RSBZQqH0XglIR+yxCt5hHAVEzpkLJF4jQ7U5oH9Uq
         8eHmQ+mtXjhTts9BB+BNw1QbKqFSTe9hbfyjcUfziob9SAmkArhImbiCLk6K0tlmooz3
         TzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786209795; x=1786814595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NGm5OdYw6hzWSbSy6f6o1TTEnHk5WqT8iRYKZzG9jW4=;
        b=sT4ndo6c/z4yz4l6h/Buo1ZAC8Mz/EpslEsLQUjusT+jkoVJJQ4pUpGnmNKER9MZPA
         /m/Ele88SdxSnXWSr8/W2pK9wClFcT6vIvrNa3jMrAc07dHAMHg/gDd5Ix9o9aYWEE7G
         WoZggSFLb/shXVaBxdwvTNvnst8H+LyOrVpuhA1rQ1bermjDqdVmFez0Nd/+1eANCizK
         LP170rqH3WL9l/xegBYcTI/ytGCfR8qE7Jz1vWGHReYaP3cte8V4/5IblK50u9N+xOzB
         +8kPIcNrJOqdY0X5PDh+fMzr9GvW1SItG0DKuTEigdKvyp9ZoJuWjHBwsnZMxhG9ig/I
         6iBA==
X-Forwarded-Encrypted: i=1; AHgh+RqIeQYwypnUC8O1DVDTMpmE52CImEkHjjTRqGzxPqPEuWwmmhAs35BPUk4pmBtaaDvZvIUXtZNsoxIEDWpPJg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlJCzz7H22eGKp7HWhwt16PcY0g+qavNllhOGY+iQVZherS89n
	WGFEPhlYYKLBOmmWS3ZRVaiEv7Isv1UMpt6ok54K9JIsWslMt310Ryqt
X-Gm-Gg: AR+sD11Q1wMk56QboviJ8DYLWIBqA4LMgh1X/aD0DOm4bXhYyznv6sX7A6P1m3pFTlT
	ai2SGQF356/lMCOE04+hWcL4TwhvK65o/tzBL1v0k3oSDRnPsJmRAxIfcldltDG/7GZ0dmDxjFU
	lzDkoH5mskk7PFsiEMV6s9lKKfOUbC0n5kzSNYajBgDvKhSCiUbt1G606MqSg634V1cWOT7XHwy
	GO+u04tn0U4p1lDCPTn2f386mic/IR7MEq2+QCQjV0AiwKu8rG3kqcSq2e6UEJo0a36V/UVR4Zk
	XKpOxPtA5T3+yHzsrOx8GgbyoaGDukUWp4upx3tmBzL073L84pzIMDnkYQ/KLAs9GYTIkuT1I0L
	byrZRLmQOa1dJXHKvgTKXxG/wDfWQ00l+ilmkyyj2kbsiYUABrG5taer9wmanRTsLinUNI+8Hsr
	ksJJdn0qS2Fvj+kfVcV0W4/VfE4TsCvw6Pd9k5cuDn+P77aQ==
X-Received: by 2002:a05:690e:248c:b0:667:bd83:909c with SMTP id 956f58d0204a3-66ad7206010mr4246452d50.35.1786209794919;
        Sat, 08 Aug 2026 10:23:14 -0700 (PDT)
Received: from hp ([71.12.42.234])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66acad06ad5sm3367129d50.5.2026.08.08.10.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 10:23:14 -0700 (PDT)
From: Tim Michals <tcmichals@gmail.com>
To: yanli.yang@bedmex.com
Cc: zhirun.liu@aicsemi.com,
	dijia.xu@aicsemi.com,
	chunqiu.liu@aicsemi.com,
	johannes@sipsolutions.net,
	kvalo@kernel.org,
	linux-wireless@vger.kernel.org,
	Tim Michals <tcmichals@gmail.com>
Subject: [PATCH RFC v2 2/2] wifi: aic: update cfg80211 API compatibility for modern kernels
Date: Sat,  8 Aug 2026 12:23:05 -0500
Message-ID: <20260808172305.138690-2-tcmichals@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260808172305.138690-1-tcmichals@gmail.com>
References: <20260808172305.138690-1-tcmichals@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes modern kernel API compilation differences in `aic8800_fdrv`:

1. `netif_rx_ni` was removed in Linux 5.18+. Provide compatibility macro
   in `rwnx_compat.h` mapping to `netif_rx`.
2. `cfg80211_probe_status` parameter count was updated in Linux 6.0+.
   Wrap `cfg80211_probe_status` invocation with `LINUX_VERSION_CODE >= KERNEL_VERSION(6, 0, 0)`.
3. `remain_on_channel` callback signature in `struct cfg80211_ops` dropped
   `rx_addr` in Linux 6.5+. Wrap signature definition for Linux 6.5+.

Signed-off-by: Tim Michals <tcmichals@gmail.com>
Tested-by: Tim Michals <tcmichals@gmail.com>
---
 drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h |  5 +++++
 drivers/net/wireless/aic/aic8800_fdrv/rwnx_main.c   | 20 ++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h
index b2c3d4e..f5e6d7c 100644
--- a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h
@@ -21,6 +21,11 @@
 #ifndef _RWNX_COMPAT_H_
 #define _RWNX_COMPAT_H_

+#include <linux/version.h>

+#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 18, 0)
+#ifndef netif_rx_ni
+#define netif_rx_ni netif_rx
+#endif
+#endif

 /* CFG80211 */

diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_main.c b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_main.c
index c3d4e5f..a6b7c8d 100644
--- a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_main.c
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_main.c
@@ -2824,12 +2824,22 @@ static void apm_probe_sta_work_process(struct work_struct *work)
 	if (found)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 0, 0)
+		cfg80211_probe_status(rwnx_vif->ndev, mac,
+				      (u64)rwnx_vif->sta_probe.probe_id,
+				      true, 0, false, GFP_ATOMIC);
+	else
+		cfg80211_probe_status(rwnx_vif->ndev, mac,
+				      (u64)rwnx_vif->sta_probe.probe_id,
+				      false, 0, false, GFP_ATOMIC);
+#else
 		cfg80211_probe_status(rwnx_vif->ndev, mac,
 				      (u64)rwnx_vif->sta_probe.probe_id, -1,
 				      true, 0, false, GFP_ATOMIC);
 	else
 		cfg80211_probe_status(rwnx_vif->ndev, mac,
 				      (u64)rwnx_vif->sta_probe.probe_id, -1,
 				      false, 0, false, GFP_ATOMIC);
+#endif
 	rwnx_vif->sta_probe.probe_id++;
 }

@@ -3463,6 +3473,16 @@ static int rwnx_cfg80211_remain_on_channel_(struct wiphy *wiphy,
 	return error;
 }

+#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 5, 0)
+static int rwnx_cfg80211_remain_on_channel(struct wiphy *wiphy,
+					   struct wireless_dev *wdev,
+					   struct ieee80211_channel *chan,
+					   unsigned int duration, u64 *cookie)
+{
+	return rwnx_cfg80211_remain_on_channel_(wiphy, wdev, chan,
+						duration, cookie, false);
+}
+#else
 static int rwnx_cfg80211_remain_on_channel(struct wiphy *wiphy,
 					   struct wireless_dev *wdev,
 					   struct ieee80211_channel *chan,
-- 
2.43.0
