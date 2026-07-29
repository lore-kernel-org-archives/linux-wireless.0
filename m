Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBFA379ED2
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346603; cv=none; b=LGijlAt3UHwMAeB55rCQ2e3ISUTZgjNK1TUk8++jfUFNXWg1c7JHvWElqtyF/bh7HfvraUSvP5Wb2kDcar8zE5rmOl66UIyba5p0EfPSnB/NesGnaiEcvX+c/UjUIIN/U7q1q6mc5wFFv95H+Ej0NTN8PY6QBhWD+ozlXd88Rkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346603; c=relaxed/simple;
	bh=IWqDuURRcNsyW45L8LWTkRCh6zzFVXVXKphIqjNwpAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jdf+LoTKHky3Losamy68suwF0klortn6yOIvgYLtG3Ef5dulWYvESsbk/tTPWqwIukHYNgP0aFbDrcBi5tFiUHntSjNGCwdX1DlOTSlYt8/CBrqAyuRuU8LqGksw0Sl2fwJI3zdzWcCr3xS9m8TNa7cfUYVFbKT5VEoyAQ1f/os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ufm/PEEH; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ufm/PEEH"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d032846c95so81985ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 10:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785346601; x=1785951401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r9lmLVYjr93Girs1odAHEeMDnIJQvCQg1I6d0OHkOeA=;
        b=Ufm/PEEHKjZv7FmLD6gPKLRdkXNa1rPH+nLUatyKque4lxIcwXH2PjRIr22DNxlNHi
         mL1Y/SDVn5Db2BhNp8wfoPZuL6yHnLX+fJmbMmDABTq/dRW3xD4gYfDAtnIy2nCir9U7
         dYGUSh4MtLTiggkRZZ5z2Q7B0MWWeB8pJIsM3VBD/16CMM1hb4F+anK7Fuo37uYC0dPU
         hTkllPLyZsj2sqn9ofJ6dlLhyD+IpUg406ftBZE5iHf1N+9a2agAs25x7HMidUg7ePT5
         4WUDsyJWJJVgKUKSTfNG18T1Xq9sOT8aWrHS3Vj9Xte/N/vNpCJJOr2egNjGDdgn1/0W
         MG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785346601; x=1785951401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r9lmLVYjr93Girs1odAHEeMDnIJQvCQg1I6d0OHkOeA=;
        b=crJYhwF8lY5ozDdW1+Cj5Ex0HngSSptx9XDAx6gCM9wiA7PW6deS+jruGqDLA6c529
         qvZR/BaEaVkeGK9n59kMkh/UXkcbtvm95lg/Aj7e6aM6CQ5HPSY9xYZl8U8Wkz/5iYNn
         9y3qo8EJZkEC/kXC9yXoH3DKt3ZnRra+D7OjiJLh1Bx6qUJuQPK+kY15J6tAJQaPoBrV
         hUx7n2zdI1hwFJyNbaOpOt5uaQ9WQ5qmvA40jblv5o60atinfewm8fOb5J3HXCqRLjtM
         BrlC5BaCavAEG50uzFnJfg8YqS/hlKMFVO0cByMarChuPzhZ1eo6Gd/lkXYZIg7jOxq8
         yzRQ==
X-Forwarded-Encrypted: i=1; AHgh+RrPihK/1FZLXGHfU66723a0r8WjuokrVJ8u6HDi/d7wt4gVrJPDlwLRQ+wN+DBXkfTUG+BQYzvHMhe+fwJ04g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwzAFcCKxlQ1/9gO0MVeVMI4VFj7pgAAshFCJypE5ke5DU5XCFz
	xKEM6z9GNnYe9cNGDEBtKV93SQCe4JZz74L2l5gGuZQF2otcusGiGXsj
X-Gm-Gg: AR+sD12dndYawsMQ12hffyetpbAoEFjR/8tpD9Si3c4DpdO9ZO3cQsC6RKYqy2bkdt3
	7IyIDpsvqnAT8BbNqzmlFn5DzN7XAcFtXGGgLY8JcAgA54zTfMo4OtydXatvoIMgkBBst9uWo0M
	VUx8cQWcmUW1+FtjZmTK1TAQ/gULHWei41qCYqwRD+zB3/4IaXFJdsxwx6+0fWShO2rytRMtxj7
	Fs6FjfKoTVt4orfPRUiWs32xbrQws/j8ODo5kIQv1yiDH6XrGFOu77ZmeX/cq6a0fxdyI85S05+
	/fLaWZuhkQXIC9GnJpbnEW6M7IHbrXWKasS4LJhAoK0oF2MC4kaWqF8meCCERl2LWKZXItplFgw
	YvmS6WWG4A6GwpcKSQIt2cFIFDhZ65dlonELDqlRr8h3KgrO9JwfO+txWsicakaIQgZnjXx0IcQ
	9VpOKesx+C+O/dDqEghfKF7A12DZL9679/d1OJEHIH9bfmKe5ykkaI6YUY5+aA5VW2e172SJJy/
	8fkwFOIKrl8dJe1YP5GjZ+0mIA/gYrhnZIPwA==
X-Received: by 2002:a17:902:f54f:b0:2ca:f40a:be76 with SMTP id d9443c01a7336-2d015d94cb0mr78650655ad.36.1785346601182;
        Wed, 29 Jul 2026 10:36:41 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([120.234.91.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bf39cdsm14806045ad.55.2026.07.29.10.36.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 10:36:40 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Rex Lu <rex.lu@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Chad Monroe <chad@monroe.io>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 0/2] wifi: mt76: unlink TWT flows when MCU ADD fails
Date: Thu, 30 Jul 2026 01:36:30 +0800
Message-ID: <20260729173632.14387-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7915 and mt7996 link a TWT flow into the device list before asking the
MCU to add the agreement. If that request fails, the accounting masks
remain clear but the embedded flow node stays linked.

A retry can corrupt the list by reinitializing the same linked node. If
the station is removed instead, the mask-gated teardown skips the flow,
leaving a dangling node for later scheduling and debugfs walks. The two
patches restore the list to its pre-request state on the MCU ADD failure
path, split per driver because their Fixes targets differ.

MCU DELETE failures are deliberately outside this series. Deciding
whether to drop host bookkeeping while firmware may retain an agreement
requires separate ownership and accounting treatment.

Zhao Li (2):
  wifi: mt76: mt7915: unlink TWT flow on MCU add failure
  wifi: mt76: mt7996: unlink TWT flow on MCU add failure

 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)


base-commit: 57aa1718d5953dd532137d43b696c68545c2e0b3
-- 
2.50.1 (Apple Git-155)
