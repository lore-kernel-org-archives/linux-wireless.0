Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3D44921B4
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 12:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784051; cv=none; b=tpTPUrEOXKzQOrT2UY6IQSRduNwWfIKscWk4o0vubimhspaVG06K9LWltCQt4PJASQe0M39q21+QGO6Q1i7+QhM63v6GcwTAC+0tlg4mr5H0pR+RdusJPCAW7oMcYlJWbVKsgFRjbXpuNO2MXaHGDdRlWW9UcdAFLvF1u6xA2m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784051; c=relaxed/simple;
	bh=4Gcl7z+Hf+H9rZ9m8KC8HDccTTcqnZoMSADIZwo0b8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n55ZVMab59fzidPy/t3Zmn8wNkatDdabs0f8IJ1/HYqQFagGYb7a2CNYDz8nr4lNnYPd52x4vflqcCITzzUNbuPcQ7bdVXTcQYRrsUuflbk8iR9OnKpCNa7mVg4BqtwYJg91wzg8kv0djpuRHWVcozs0RI67hyVU+wqZkqsszxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=e07Hdf5I; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="e07Hdf5I"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-381b831d535so5700952a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 05:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788784049; x=1789388849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ueZ0LICg8LRJYUq5KckgSFGdPG4THDlsGje4YHQAzIA=;
        b=e07Hdf5IxRbn5E9umcSq3534tpxtfgEC+/8mvJvaNvVeymh+E3b+3OR5mEOsoTesJm
         RadqRsb758cOMKCOBTIPPXBtY/IFUv/M0dkIfrNAbPHRyfgOVvuyQQgAX2a6Y3riIvV3
         4IzQCHT2WqQ2fgd4KcXo5Hh8D4ITdH+ZnKGQbr870mbE0pkt85QFPmSm6pwuYqeFNTis
         5Q8vqBgFkVHvTG0lRnVGEvFfywYS9IbOfvtItK/d4bHFu+1L/5C5icFqBjoC4U62uCHW
         cT1qKSsZgsr8i9KJyF7PMiLTPOoeGBL6TnX6kq3Vb5B3QUMlP/qPFfszqnBWPHBZ2Mom
         4GzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788784049; x=1789388849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ueZ0LICg8LRJYUq5KckgSFGdPG4THDlsGje4YHQAzIA=;
        b=c9re7jnfjPfM9xHJ4BDCQlVLN31dK+wmuk3Xw5IWAV2lS5NW+CeopGJTe6xtVDyzWI
         9rgIVNw0YeEo+oylJCqDFN2wHFKNc5VO+Slr3vXbaA9IFzKtmZll3wOZ1E1qLR6bYc67
         XUCd5BRD3Q5XVjoCJ9J4NSMGdlIEjMnU33Ozohf/1+oucqZJ/EIyrx3OTIzLIXnPM8Rd
         WlOmV20Nux23FKhaXbeajb0P87VD+dgNKa1vtbplOnM1q1Tkj8HThpKBTZ/3nmLKA5qO
         HTUAl90IEUOjNQDVI4gXv6xhUvZ+pfb/0XtWgT9qU0SzySeFGj/7OzIPqIHS56rLF63r
         1BrQ==
X-Gm-Message-State: AFuF++kL08h+Jye0OC/cfTmzdD7SKM4+qYgHjNlKMBqS+/p1uBUZDgzx
	S3m1mF4FuVvmD/8x6Bv2ajSsy4qaOL1IuZanPJouIVZyhqSQmGpAs+Xs9JKS7oFjZKjxztCjbmC
	rRXge4z24MzQ=
X-Gm-Gg: AYBFou3baMHPy4GbE2qK5F55bS+Bwq4lyXiInbkmHvtIZE/E4L2nlDgdP0UeQPWnFAz
	B4e5bWOqIAGBnLkkwyhp0FaqwwYcV/O8uMOnitIZ4tBvJMhcPU+8zOnv+Gxb09ckUU8QDZLkMAj
	A7X3w/KUN5hLGrRRLl3egOgLMyF0iOWpTavPPVhtnn5ZChQ1nD6BU7fq15OfjPDOWj8SvICKJfq
	0lKovubPQb9slkkISFUX2NCPhwwncR+iDu+v8cpB/XyKnGPBVshrWoBbEJ8e7OVzofC+iA8TCGa
	LEkE+5VvZjagA3Z7F3a812KXJ7giJeqgR83xgstnmM2OQqDhTCVUxWMF7wpvo02Ccb1sOBae7Ib
	FUL5242xTevPfMlDivkGOwEKYD8/uyYIj69kgbiJqvcX20u+K2YKwHVw0pbwByNN0P6DFlV714n
	5EOvnpAjrvHJTbHmXgkW04McJC3wchsPaz60NHz6pXfPQnmurT075LhAFzaOSoosviAcgC
X-Received: by 2002:a17:90b:3803:b0:395:7fff:a08f with SMTP id 98e67ed59e1d1-39b25eef036mr31953272a91.0.1788784049397;
        Mon, 07 Sep 2026 05:27:29 -0700 (PDT)
Received: from Roxy.sysu.edu.cn ([2602:feda:30:ae86:295:dff:fe84:68f4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432435648esm32122104c88.5.2026.09.07.05.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 05:27:28 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	gregory.greenman@intel.com,
	miriam.rachel.korenblit@intel.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 1/1] wifi: mac80211: reset default-key debugfs after netdev recreate
Date: Mon,  7 Sep 2026 20:27:13 +0800
Message-ID: <989e39c2b3e696abc61bb2c7608786538817f60e.1788783312.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788783312.git.zhilinz@nebusec.ai>
References: <cover.1788783312.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_debugfs_key_update_default() stores dentry pointers for the
default unicast and multicast key symlinks. Recreating the netdev
debugfs tree removes that parent directory and clears the parent and
stations pointers, but not those child dentries.

A later default-key update then passes the freed dentries to
debugfs_remove().

Clear the stale pointers when the netdev debugfs tree is removed, and
recreate the default-key symlinks after the directory is rebuilt.

Fixes: c942398f95ef ("wifi: mac80211: handle debugfs when switching to/from MLO")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/mac80211/debugfs_netdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index f3c6a41e49119..a00b0776fdb1d 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -20,6 +20,7 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 #include "debugfs.h"
+#include "debugfs_key.h"
 #include "debugfs_netdev.h"
 #include "driver-ops.h"
 
@@ -1020,6 +1021,8 @@ void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 	debugfs_remove_recursive(sdata->vif.debugfs_dir);
 	sdata->vif.debugfs_dir = NULL;
 	sdata->debugfs.subdir_stations = NULL;
+	sdata->debugfs.default_unicast_key = NULL;
+	sdata->debugfs.default_multicast_key = NULL;
 }
 
 void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata)
@@ -1032,6 +1035,7 @@ void ieee80211_debugfs_recreate_netdev(struct ieee80211_sub_if_data *sdata,
 {
 	ieee80211_debugfs_remove_netdev(sdata);
 	ieee80211_debugfs_add_netdev(sdata, mld_vif);
+	ieee80211_debugfs_key_update_default(sdata);
 
 	if (sdata->flags & IEEE80211_SDATA_IN_DRIVER) {
 		drv_vif_add_debugfs(sdata->local, sdata);
-- 
2.43.0

