Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D3446AA9C
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 14:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546776; cv=none; b=SR4tsXY51NsS9iRr7HQvweaqGR5zsdTvk3yKN0mnr+DZAIZyz/QLyxSGAzEl6YMN7Uf4cexWphlMJY17LBLfYw+kYJ19RGT27f4f/TjU46pZkJaK5eI5QKkUUfe1GFx4R9nKF71o/+Wv0n28/LRP99raiAlRamRfJe+JxtYFdhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546776; c=relaxed/simple;
	bh=v8ilK+pEsYpngRvjfbRcBdLp0FzX9zgBZmRgQxySmZI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kuziDsqwpo3cVzsYLw6T4G2Ibr32ttdOSTQnb22p4m5rUeH29HMaAtgIv9ZvLupSJ8mNLpvvc2BY3E9O4OeGqalv6DJr/o010WhJ+e067WUOLyHntSb9quK4BsA6faN736BKsPNa1TDDn67iEj2k2VxSzooncBQEpgUM4hY8ybM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KfK3HGSv; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KfK3HGSv"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49954b88fffso11859795e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 07:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786546759; x=1787151559; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NhF+5+IkWvEfJOpZIxvPcr/6RRXPpqOnEBt9tf6dcVM=;
        b=KfK3HGSv8BJ67JuFtSJrLlK1bEqp+LCe8lNB09HonjCPGHAGGs9QjkrD5KWolqqEDl
         3OYfHZvbrs3/OoPFgQIssmrU7uR2kxrwL6AsrXvMr+aUCsNU4StF3TpgO1eDviVi4zrg
         Cs4ElFa6glp1SLeb0BzLIXgGp04Z80LohKgWGqYwy0uAZlRqLzuEH28+EjL+XejhR5IR
         RWGjkEgJzjlljE63CyJpk1rFYHnqcd3aIvE7J5eC8gJAzgieEKKYOslppljmnjLFHadQ
         WTqytaeI5DWbunaNpcACWO3XyNunsGWrcH0rLqZqatJz+6tKS6O6x89O28V2nyCxcJLN
         QlYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786546759; x=1787151559;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=NhF+5+IkWvEfJOpZIxvPcr/6RRXPpqOnEBt9tf6dcVM=;
        b=k6orFVBagKyEpYDMRzUIHToFdD6fePf5Q7kmCbTs/Bu9gfVp0AE4j0dOZ6NTjzLE5p
         BuC/GosUvEJpriRtdbQtZ/wqGFZxIhKnX9Tftb2NjqV3EXcynGHhoOJJEgbiH0FPhsY3
         hnzu9oVRg2/f0CIzyNNzDfg5aFugG9kdN6dY//B8SRjPdKTFTFuxHs0vxtPdSVgbazlM
         J0/fpZISLsUKIV+oFuhtHsdpNkMvXQUoY8dsQlgdi8R3+67ODkpkoF4OiBfM9CRf6tp4
         q2KaoWojn3f5ksrZpI9t9sNgbBQvd6ZexCzjxyas3TNoSm8ARQtmxRuX7iBU+bGI3TPj
         qqlA==
X-Gm-Message-State: AOJu0YxBsJOR5UfzDZ8xabBOxDpdU3Yw26qiGR3jjTDge4+P2kcIpIMB
	Oyhme05EY2fKhc2onotZg+oZcCTlWu4UTSw1IuxmqW02lCR9qr9ytXFduaDQ7Q==
X-Gm-Gg: AR+sD115fJWXEHM+Z3JWs2mFNnvNXK79qv/zLxDCNGDC1mpaYcwucm6jv+tDapK/U27
	Y+AG6TN6jAePUt5INyrbXaGt+0RCwwB6rVx+HxX7Q1FBiYf4N3f5pH+YyW7OPpqEKsIb7+1eeDj
	U2TSIICBEiS6P/NYl1WVUxa9aoySWyFql5FD4Fx4e245/sptIE10lYVxqoBEFLlpyaoRfNN+13i
	3NYLjYvgH1g9f4ibN8M4BXUGq6QutwgeFHUhflqAZXeBFe4G9h5ZXiilVhlQcM9TNgzoZ9ku06o
	bM5zZIOJ2kdjr6lSzHaOiH5RLqk+mdtwe/tjbw0ZuH2h2CRdKZg74qGsL48vf0VB4FKcTLvxzZO
	mFrWKJ/IJuULBc80njzrbI+qmgmX2ATAvuiUYvyvvCcbtt0ZCh7wsMm6VIe6jMfglCyekq/Brpg
	weUuaJCga+cYDpvbQJmxbJAMedtOFs0mRpt4qPQQsRtMf9ys0rt9FMo1ioVUwqLnmTRoWUCmlUg
	PgwiSAJWg==
X-Received: by 2002:a05:600c:4e08:b0:499:4892:d022 with SMTP id 5b1f17b1804b1-4997c0d09c0mr81316375e9.8.1786546758852;
        Wed, 12 Aug 2026 07:59:18 -0700 (PDT)
Received: from [127.0.1.1] (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997aaa4a8csm82675685e9.3.2026.08.12.07.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:59:17 -0700 (PDT)
From: Nicolas Escande <nico.escande@gmail.com>
Date: Wed, 12 Aug 2026 16:58:05 +0200
Subject: [PATCH ath-current v3] wifi: ath11k: reset ar->num_stations on
 hardware start
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-num-station-v3-1-871d20e043f6@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WOTQ7CIBSEr2JYSwO8hlJX3sN0gfS1YCwYoI2m6
 d3tz8KVy8nMfDMzSRgdJnI5zSTi5JILfhVwPhFjte+RunbVRDAhmeKC+nGgKeu85mgLUCoA4KK
 uydp4Rezce6fdiM6WmjFG9Jk0h5nG+wNN3nhbvIthoNlG1L+JStRMsRpEAaUUTErKqXcmFJiM9
 i1e+0G7Z2HCsBGsSznEz/5+EvvsQQHGSwZMFhyg4uo/pFmW5QsvHOBQBQEAAA==
X-Change-ID: 20260812-num-station-d33483331299
To: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2

When (multiple) hw restart occurs, we end up in a situation where we
cannot accept new stations / mesh peers. This seems to be the
'num_stations' in 'struct ath11k' that did not get reset properly in
this case. In ath11k_mac_op_start(), it was indeed the only accounting var
that did not get reset so let's clear it too.

This avoids problems like those:

	[1248828.088023] WARNING: CPU: 0 PID: 12281 at net/mac80211/util.c:1682 ieee80211_reconfig_stations+0x98/0xc0
	[1248828.088115] Call trace:
	[1248828.088116]  ieee80211_reconfig_stations+0x98/0xc0 (P)
	[1248828.088119]  ieee80211_reconfig+0x774/0x1438
	[1248828.088123]  ieee80211_restart_work+0x10c/0x178
	[1248828.088127]  process_one_work+0x178/0x3c0
	[1248828.088130]  worker_thread+0x280/0x440
	[1248828.088133]  kthread+0xe0/0xf8
	[1248828.088137]  ret_from_fork+0x10/0x20
	[1248828.088141] ---[ end trace 0000000000000000 ]---
	[1248836.686604] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
	[1248836.686609] ath11k_pci 0000:04:00.0: Failed to add station: xx:xx:xx:xx:xx:xx for VDEV: 1

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
---
Changes in v3:
- Fixed message typos
- Trimmed stacktrace
- Added hardware revision to Tested-on
- Link to v2: https://patch.msgid.link/20260730140306.133718-1-nico.escande@gmail.com

Changes in v2
- rebased on ath/master
- no code change
- Link to v1: https://patch.msgid.link/20260729080932.3462066-1-nico.escande@gmail.com
---
 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2d55cdc4d165..0baa46df1fb9 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6699,6 +6699,7 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 	ar->num_started_vdevs = 0;
 	ar->num_created_vdevs = 0;
 	ar->num_peers = 0;
+	ar->num_stations = 0;
 	ar->allocated_vdev_map = 0;
 
 	/* Configure monitor status ring with default rx_filter to get rx status

---
base-commit: e07447e654476262558bee570f4cf456e2b32565
change-id: 20260812-num-station-d33483331299

Best regards,
--  
Nicolas Escande <nico.escande@gmail.com>

