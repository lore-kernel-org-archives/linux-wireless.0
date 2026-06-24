Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBBF2F8BC0
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782312338; cv=none; b=bJj9+6KPgK8B1eSz2KHsbhtupW3w0ac+fKuy/aRFkBxhCZVQxHqLll5usz+Nrdhkq8B3DTW0gGCcBTq/77OZDJFQVUyWk1GPuMy/z2vu4+ZkfI6cdDhdLFICOnhJIm9RMgoeiAAwhHUdS4WKSIUoJYqtwMgOafPbStHVKmZiM54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782312338; c=relaxed/simple;
	bh=QAi51ZVTcnfA3MPJodoPROj3G1yOTG7EKILfYu4W6o8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XZF29y0DRqKVoB0LS3DUODG5e0z9gMjOHOSzc/9WXAEIVfIKSfIx1Iie1VDtXzNqjHkTZ1f6aDS1AVtkm/V38w3N+U5odLili9MQJM7LaBR8kfm2uMGOFb0TAT/HpDJjgl1vetd5WRkrbyqKTHOL0Bq0nJoyrFZqLFWQATeFUT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UtSJifzO; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UtSJifzO"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-30bc806fcf8so1310983eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 07:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782312335; x=1782917135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BCqeUIYXnFvsifsboKxFvJZWYto9gkhRGJWwSC7wviY=;
        b=UtSJifzOFgxkNbAJoOTfnS8upu10StadZDYc/z7JLGs04/wlRqwh1GyeuCgGX61N+F
         72F7Zk0VzqJjPClef5SoaqqnmQkvDKVgOC3hvVLgXsMl9EPFXeWo1w6x+7ejxufSw7v+
         xbgkRUKmEbD/kDVq72CWsaFvuoI618CPIiWdmbS6qBpLpP6W3gCtRPUKhYTdYaQ7Y6Jh
         5PTNeNfdNAMfY38Hau2rL/t5mysFcket2JLUn7p9k8d8dHTxZhJ49WjYlBoKqmgb1oSb
         N0KGUuQbPZ41ymYMvyhUsf+A3ULDZ+4xEjViJKPa1uThT2/yI5owpfGmmtYpYnuYLI5F
         u7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782312335; x=1782917135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCqeUIYXnFvsifsboKxFvJZWYto9gkhRGJWwSC7wviY=;
        b=dnz1i7FoChf9IAOGcaxC/PmT/jotwl/0RrnWfOvVCGBAXiNNW0lksPDeU0PgFCTZ9L
         3ximgtRfhTye2q5FhDxk4XVkCylFUJdhEfGIWP63EXQlVcsSHB6VXjC1tVyE4EqRUTqk
         t9mDyIS/7srK/4VigMOci1Iyd91NYZXZkM7R68qLieP/CmEFerCAaRenUabinyOlIQUj
         rnZXi0r6IY4YQQxtFO0lnvutCZNgakLxS3tttdbRj5nPsG4Wja41nWfsxQ6GJhkn+Chf
         bIJwXNcNNF6fRkHGluGghzFTuNLU0X9hToEMQdY15PT+4rqcCp+HXDEgeDopVb9IietS
         MmPw==
X-Forwarded-Encrypted: i=1; AHgh+RqsN1A6/rTcTHl6E1zra22IVYU/l8Yo+arspzT6rluggZzq3WcLMfKjfnydIpHHIh/M4sXrpg6lyrwSqM9TSg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDF3GA/D0OtoYvLgqqutM692htb/FgGWiLxJX3DhJyeY5fi0vd
	3lDl3hrxPNSxYmcJ0Vw9jtdEaSbDhLIFoWFmK8AYq2QmsIzhhXfZM51N
X-Gm-Gg: AfdE7cnOVcXnhdfvDppnRVgktJxif0H965l2+TX7s9hMBZMc0YP2bF0BAG7domRlpbJ
	IUsxyCuLp2i9cGXtuA3tH8As4G8r/xZ7beaZZmc8DhQ4MU1rWfKAn8o1mpZ0MXyAnwadyrXZvdq
	1zWo2GfvM5Lmui6sSegpbiVi6QsQYY1/JgFEVybQ+Tqj4NR6W7gqxsG6yCsZB4QLYSxp3v4BLm8
	AOc2cVP/FAMc7I17ewpXw1z3sf9kx53vchvcha1lCi7vYRhccfJYtsAgRXibSFiwu9uwepFuqQO
	qCMVKvxXmPDEQgcrbOx2MXhmdchiF/A56eKF41SPYNP0Oepk/DSsYc76wrW/MIiZpvf4NUSg3aX
	uSlk48DTjB50d4dug0q3ykTj4ZBhSrMFT/I9v4pA++pHu/gPZI22fF2nisv2/3Z74p/LR1Vm5wF
	6bqyCu+zOI/cKxdV/P5VlssR/Xeq5RpSu/VGKC
X-Received: by 2002:a05:7300:6da5:b0:30c:1707:e4b0 with SMTP id 5a478bee46e88-30c58ca3ec1mr6240781eec.25.1782312334862;
        Wed, 24 Jun 2026 07:45:34 -0700 (PDT)
Received: from yyh-VMware-Virtual-Platform.lan ([45.32.131.238])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c1ba5c25csm24899292eec.8.2026.06.24.07.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:45:34 -0700 (PDT)
From: Yanghan Ye <yyh94306@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>
Cc: linux-mediatek@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Yanghan Ye <yyh94306@gmail.com>
Subject: [PATCH v1 0/2] wifi: mt76: mt7996: fix runtime txpower limits
Date: Wed, 24 Jun 2026 22:45:14 +0800
Message-ID: <20260624144516.1841063-1-yyh94306@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refresh the mt7996 firmware power limit table when mac80211 reports
txpower changes, and enable the firmware TXPOWER SKU/backoff controls
needed for uploaded tables to take effect.

Tested on an XR1710G/MT7996 device with 6 GHz AP mode. The reported
txpower follows `iw dev ... set txpower fixed 1000/2000`, and measured
signal level changes accordingly.

Yanghan Ye (2):
  wifi: mt76: mt7996: refresh power limits on txpower changes
  wifi: mt76: mt7996: enable firmware txpower limit controls

 eeprom.c        |   9 ++
 mt7996/init.c   |  16 ++-
 mt7996/main.c   |  72 +++++++++-
 mt7996/mcu.c    | 365 +++++++++++++++++++++++++++++++++++++++++++++---
 mt7996/mcu.h    |  25 ++++
 mt7996/mt7996.h |   6 +
 6 files changed, 471 insertions(+), 22 deletions(-)


base-commit: 2dd6e4c8892f59b7943ee163afd6ced881bfb31b
-- 
2.43.0
