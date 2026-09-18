Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1B11C6FF5
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 09:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723030; cv=none; b=WKdghHqA3BDlwYhT8ghVjDpR4d312PhpkRwb7YM7uim4htkFgFhCi0EDKU2ucaKPt296YPfcn+ULl2yHUPLm+9NGET29GGoHWvNtda1L6LHfvb/B8I98Zj1gAqwlb6SBBLTtOfnDv6XM80SzFOjLe5Rn0Z8D4Zhu0veLu1pHXaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723030; c=relaxed/simple;
	bh=pYBZciPk8WPF2+VgIIBHdGh5z0HjmNj27L2kWCx/XM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V/rUJZGChGny+EeUlBMURcTBV6oevHE3XmJzxWq8Jj31xGSvtj22d9rpr2/GJ9UG1McZ/AlJriMo+Jitw4xETMAX8Bs5dVkoSAIdDlygsO52LftWdl+mqrDFCZx4uwb1K3E0udmb/mdNqk7bpwE0YpFDP8W+ve3Bx2fVlirxS9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=liPgTobh; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="liPgTobh"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-8623e5d435cso153120b3a.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 02:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789723029; x=1790327829; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vVshUip7ZfJ4LkvqTJFisv+xGWFj6v3ChS6YXNEH7eg=;
        b=liPgTobhGsevAAGXUb54vhb1ZU3hYNXN4WFXV2JnWBb755GekTkFE0g52L3GmMhqaE
         Min8AJEFQ8LZrGYr4CgVK3M0JLNnessOjAazoLaPVCJT21Wwjba/YT1klYOtvMiieoSz
         DDbMlA9vVHkR0kELl9RNqMu8dZGpul+nyP5VPvgBA+H+YGU4fvd6zcqe5tGTz4qsnNZd
         pMRth3NBR/2mOik+6lqj09g3nLHtTiqq4wJpiiExxIOSepxdwWNvvvAQJXMd+PqkmFgc
         oKSv0KP8hmJJckqOuFIF/G2PkzuB/1zU9eh+rG9/kvqUE+dvwULKGBDlndxaCwtd76KG
         acyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789723029; x=1790327829;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vVshUip7ZfJ4LkvqTJFisv+xGWFj6v3ChS6YXNEH7eg=;
        b=HN/h1CjiBDR12heX/rrYtXEe+bgiKL6q+qhh4caleBqtgBGBrabmDyAdmuq8u5Ziad
         J49PRS9qg1c1wLPEA6A+qgWkUJKyrUABcWB6crBGv32EPpl5fKbxFeZFiM/hIDxeJxeq
         +EOrIHsJI/f8+tBju4oxHAW0ufK9YXl+bwMJG5QL38JYYKi07YwaJe9M35OE4ZpUEIAy
         RNub2kbSLFBzxavYYlI+wYxEkxpx41/Edr8DS3oFbaY0/u67DGb6BUTXAMckBjtITbVt
         gCHKUeSvQ70fcYcBh7kzu/2ThexbpWwlQs3I4HXTnGozqqexLkEXouJ6FY/cPxYOPbAs
         OQOw==
X-Gm-Message-State: AFuF++n31rS225ZvOkM9I1rkgyZqmOKKy6VVcbEaPn/5rug8rwCy4uOO
	2lJh/y1e98w2d/o+j8leeLcjy2HLPXjnA8jb7wgnlwMkQUfJmlYsLBroYndlWSfK
X-Gm-Gg: AYBFou0NZlZ1QSmGnzc67eO/1obPIU7SQ6oTd22XYW6i2rXlqNcBB+Qy4/A31nylJQD
	UYTtLPuBhCQ/hG0Ab2Vo8eTmZdrHdxFldR/Mbl6uls5Q0pvZfrUXn8IRLG78c3bGNxgZlJUuSwX
	z4fJwWJLP5FYoDC2dw++MWDPKC1vJGMnwdqU5w55kSuhz3OIJCpuPWmOWmwdfDPpLORZpU0Ua/s
	Fd/Oc2de7xrcIm2j5qMt/vL/7ZRPqVp1vcDdWigDva4IWrTSAnu7Qv9CGh+72FcDsdern3cd5gA
	XDifa2gvDV8R57s/C4Boj02HeLgFsdDnh3V1i5fPazV3D4nvv8/C66/6l9Tu1UG1cecIA+xKz9H
	9Y1m9D29jyk21D1nZrmZLe9MZxTNdd1ezMr5akgXyME0/PaVqQH6mqMRCTOhFWfDBOax/XnAiRO
	s7RNc7uSW20KJIXfdnUnxiWFg+2ULcvoE0sm0r+HjMk8JjWSTqfk5N0JHQ86gUbHmVZ+8QqEI=
X-Received: by 2002:a05:6a00:94d3:b0:869:86ae:e94f with SMTP id d2e1a72fcca58-874d259e98emr2452661b3a.4.1789723028839;
        Fri, 18 Sep 2026 02:17:08 -0700 (PDT)
Received: from localhost.localdomain ([2406:6d00:a27c:4200::7be])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-875dd3e70ccsm514511b3a.37.2026.09.18.02.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:17:08 -0700 (PDT)
From: Gilly1970 <gilroyscott1970@gmail.com>
X-Google-Original-From: Gilly1970 <gilroyscott@hotmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-kernel@vger.kernel.org,
	Chris Scott <gilroyscott1970@gmail.com>
Subject: [PATCH] wifi: mt76: mt7996: refresh the tx BA session timer on NPU devices
Date: Fri, 18 Sep 2026 19:16:59 +1000
Message-ID: <20260918091659.1176350-1-gilroyscott@hotmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Scott <gilroyscott1970@gmail.com>

mt7996_mac_add_txs_skb() refreshes mac80211's tx BlockAck session timer
only when a WED device is active. Airoha boards offload through the NPU
instead, so on those the condition is never true and nothing keeps the
timer alive.

NPU-forwarded frames do not traverse mac80211, and the only other places
that stamp tid_tx->last_tx are in the software tx path. When the peer
negotiates a non-zero BlockAck timeout in the ADDBA response (Intel
stations commonly do, most others answer 0) mac80211 arms
tid_tx->session_timer, which then expires in the middle of an offloaded
transfer and tears the session down with a DELBA.

The session does not come back on its own either: mt7996 restarts one
from mt7996_tx_check_aggr(), reached via mt7996_txwi_free(), and
offloaded frames carry no driver token so they never get there.
mac80211's ieee80211_aggr_check() fallback needs
RATE_CTRL_CAPA_AMPDU_TRIGGER, which mt7996 does not set. The reported
symptom is a file transfer to an Intel client dropping from line rate to
a few MB/s and staying there, with a single ping from the router - one
frame on the software path - restoring it instantly.

Extend the check with mt76_npu_device_active(). TXS reports do arrive
for NPU-forwarded frames, measured at roughly 24 per second on a busy
radio, which is far more than a seconds-scale session timer needs.

A second user who independently saw the same collapse, held off only by
a once-a-second ping from the AP, ran a patched image for 100 hours
(~175 TB of offloaded iperf3 traffic, ~4 Gbit/s) without it recurring.

Link: https://forum.openwrt.org/t/quantum-fiber-w1700k-support/222776/3900
Link: https://forum.openwrt.org/t/quantum-fiber-w1700k-support/222776/3901
Link: https://forum.openwrt.org/t/gemtek-w1700k-community-builds/249319/458
Fixes: 377aa17d2aed ("wifi: mt76: mt7996: Add NPU offload support to MT7996 driver")
Signed-off-by: Chris Scott <gilroyscott1970@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index dc1a3e9..e50db1f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1540,7 +1540,8 @@ mt7996_mac_add_txs_skb(struct mt7996_dev *dev, struct mt76_wcid *wcid,
 		}
 	}
 
-	if (mtk_wed_device_active(&dev->mt76.mmio.wed) && wcid->sta) {
+	if ((mtk_wed_device_active(&dev->mt76.mmio.wed) ||
+	     mt76_npu_device_active(&dev->mt76)) && wcid->sta) {
 		struct ieee80211_sta *sta;
 		u8 tid;
 
-- 
2.43.0

