Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6428634402B
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 03:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791428994; cv=none; b=izJx5cQB/YtZsmHfbB3BHn/haRwEBoNXVeWPVTfxhVpkIb8TR9ZWgAOan65Nw/gvp2m3DYjOavVIO5oSVfDKYUGZPkycGyaFu/wIg8EuUK5Rqmv+RNRhPvPZXl80sD6cX7mMnKEMsEq/Hjf7mGw5W4cMfpBhBecduIYWY7Wuh44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791428994; c=relaxed/simple;
	bh=/G2Rcq0fuM7/EDRa5GatpM5baAHwfyTxhgej7WbhclI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sUzGTRY+cmydka3WUzoueK5phGszmETzORnDKepgqfphGJ54SVb1axGKzXZ+m8b/HQKLYJfjWLMjIqpTuR9iI+n1mCRqZEghEdMbQivYfNXEVrRFB/nZrJoFHGRYcQ3XhFfMZ50x8rZVO1LLK68rq3yoL2a/OBUy2uJAgl/5SdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=qBtzd3uk; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="qBtzd3uk"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3a80d1c98f5so2793166a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 20:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791428988; x=1792033788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EAGvBqaiF7dab9RZtibwZwvnkGxCaX+otX4h5L2NXSw=;
        b=qBtzd3uku3BX+60J0Gx6nFMf9WmZy2WQres7TE/pwTppUBncdo1oT8FvpqixHrMbzE
         NfVrC+Q5LKb9tl0rc2kINAC1RBROD7Rju2OPTNvkjgXMuTsVku5oYSL74EzmyPLSC59f
         oq8q6ENw5fYRri6KPy59vUOCq6SBSFzJ/eFW6LwF7qZxXVfLzS7dZrUcF0m9KpE0+kko
         Bhft8Zm6cTL2l45FD2RmZh4qIXbmYh30LQvoWYIb8ATRdvMWa/L/2CXDoL2JZP0SX26v
         jhGh+FSV3ZyDq8n4WG1B9XO6HUlYzpYblXcVeWxrBC1aD6Ymj+zRxOIRA+9pbIxheFzn
         cJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791428988; x=1792033788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EAGvBqaiF7dab9RZtibwZwvnkGxCaX+otX4h5L2NXSw=;
        b=lw1ZUmXOBix54/ogfgUh1KVqvxwmar0NjTslvPPDrEpZMfBzx82X3O8Y+lbXMIX/Dy
         8wEdw6NR+2+yJJJDwO9IIRBuRGLfWU8TQc9mPqxcDm1v1nF4Zncuoi9moM+U9EOyGTN9
         7AOQhLWofyCFnbhGB1ZNsVgnZJFF8DFURdyuUigRKVCXL9trlgbZFoRAha0b495FAue6
         ZVL1wom7ST85EmrzgULFWLuKpaEzNUSbMOuja/VUVTgX9Kw/QSbWwBp2bUzf2vnQ1xWQ
         /OIlZCtCnP6svQas9dunc2UfbO+y/LeMEDpOp4rZmDfqYwED4ll1LTX30MEU2ufR3IsO
         EWEg==
X-Gm-Message-State: AFq9FYJ9kehwl3fFpcIS85If7fS03/NYSKh6cnPHandy09D57jgyh0pg
	m2ZCjLb60n+oMrH0eM53KbzSnH580sM3S/iGLslQTG8B6bj7+e2Zo166PwnIfK0CBgM=
X-Gm-Gg: AYBFou3LOiAEKBejlJ5OQ5TZmXO0VAvwfNQu0Dzg/7XQ9DzGoCBPHChYWcHbFdwIs1U
	qQICis/FRlwkvZT+32Q1YUWl2bM+5EypIpz6eNlAeSXDht2ui1EkO69L54FRofYIAtb86c+fAKa
	dLMX0GRB7uGLAGTzfkt0H7v5nfvW/xCOv5cUZQvBXo8s62iigdohb5MvKR0mttejqYTixax967G
	OSO4gBOKMndDKQ27PuT1U4QGaFPYzcQ6U4eZeDfjGp4USD80bMqg9l5BJdhoeMwIq2fjQ0KjEVY
	vCfu/B4GVW0q1BzkhDJGW/qOYzHX1LyfNEpvy9ACZ791zYLODgxkPPrsoYmTqv4P7EnzG2VF3zN
	yD+udhZj916vPg1a6gjb8jyqfqtyRTNXHijnxtcOJZ8qh1VNbXKJtJOlU0wu641jKMfhbE5uBih
	3CEXRdlP84dDa5bF03DctNVLK09di4WRsA16HYwS5FN7De2qam8ds5CJ5bE53xnJpZI+wtGEmK+
	Cy+H6Q3nn2zxihbQs2Kg1VRBOAuEWiso4fQcF+/BVit9gmcZBshKn+oH5XkihsQHws+UWk3WhMl
	jZc=
X-Received: by 2002:a17:90b:2e4f:b0:3a8:599b:23cc with SMTP id 98e67ed59e1d1-3a8a1968d0cmr3680373a91.15.1791428988444;
        Wed, 07 Oct 2026 20:09:48 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3aa0cbc6e23sm2149514a91.14.2026.10.07.20.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 20:09:48 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next 0/2] wifi: minor S1G tim/beacon parsing fixes
Date: Thu,  8 Oct 2026 14:09:37 +1100
Message-ID: <20261008030939.474493-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

minor TIM/beacon parsing fixes for S1G.

lachlan

*** BLURB HERE ***

Lachlan Hodges (2):
  wifi: mac80211: handle shorter S1G TIM when parsing elements
  wifi: mac80211: set conn mode prior to parsing elements in beacon

 net/mac80211/parse.c |  7 +++++--
 net/mac80211/scan.c  | 18 +++++++++++++-----
 2 files changed, 18 insertions(+), 7 deletions(-)

-- 
2.43.0

