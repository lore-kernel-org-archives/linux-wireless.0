Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3F7451995
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 09:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774835; cv=none; b=DVMpiNcOpZdiYHiOPh9y0JSUWYgTgZDDgthqTjTEVelSqUHMc8YCsBRVWMQ0lr6KPb6iJVy3k+tAuOU6WT7gZsP/3WzDnzzML4gXUbgZwWVgScoPiTKYyx6sarNJ1WPMuAyrjLhemkDEhWzXoHhSm950aKh3WNKz8V5voj5dUAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774835; c=relaxed/simple;
	bh=tY5NnhQZpDSdyWxYoipDRZaMQLSvDSC3Hb6EbUbFWm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZpZm/e6WzwJRr/jsoFvofG6nAHpVwZ60LvL6L0ypTACDYkl6+sr8vClBUGTRY6NFvS+07/csMUXzB9/EybX0As/yPYs1Sou3UueCR2wQ8CU7ZhgBs86YVu1c41dO27QeLToqGbGRo4j377Onk1ObBlMy9zl6AzFdokfibS7FJ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fpZakA6t; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpZakA6t"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9e7391839cso3503468a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 02:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788774833; x=1789379633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pPL4aNtiXw+QNEKnkbqTe9V+ETGQlK0apxkr/mZWEXk=;
        b=fpZakA6tcgYr12SoAsuZ5uc8558bWilSjaGa5FMJd/vfGB74NlctEdOI0oFqpk6ijK
         GuyiPwCmAUpR+loLNT8eqmzuKNxK45MLGHA43I1msjfts9ihKiu3H5XSvMpXQ3QQp0Gr
         +Gf0gdM5MshOPRPkkaknxcastbkxGaS+6e+RavwBTaI2+DtTHzGVreBQhbnQqSKGgQDB
         fGcmDNDWsBwRp7s2RI/L9xirN9lmbDxsdl90I5nRO0m+RG27QWChyf2mQyXFszICmkHe
         mPnUJ2cwj7KVaAW/L+EW+1OhRlgkXHSVm/JosEx+iPioTDTN6JmSVbznow5LxrC5NIPL
         vgYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774833; x=1789379633;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pPL4aNtiXw+QNEKnkbqTe9V+ETGQlK0apxkr/mZWEXk=;
        b=Dr94hVdtZhmwU+o4RQzTE9FA4qS2/2swXlyFOUJLfvjo2fSSWT9rR0qOT6/IbR/Mfd
         0TyZw87aio7FIEfydI5ItRZB7mdcaEwBK2YF8qQ6YzNs70jvBD0b6x5dwu71vTHVaZAw
         gTXu5EKUUJLcV8lQqdlE3ADz26D1ZRfqlTfR+BZt0ETs+qihQKHZw/Y3Zrpv6xuccj0e
         2JzO+mHi65bIjzhaZVNqrtdP964JRVEuY3Su+EP/EmrVozdJmY1vZR6t/xr3abL4k8TF
         NUHOqbtr/JsmwlSAregMzU/HwZ6budpo8JnTrhdjF8KKIMLhrudC4o9Alen2YM+9oWvO
         enOw==
X-Gm-Message-State: AFuF++mR9JJvWL5k432kcjfxSiALjdtVxUI/uYXbv4aHBRBkwOMyDUNz
	H6Y2kzpatlFrvystGIDoDnY94xJs6bTXm9EV03iwRv3HhiCKnG5mmMMO
X-Gm-Gg: AYBFou0Cn3023oj6Ud+E75sDeDfoKb36ubXOFfVBa9xWq+LUErLSyKYy1/2OgpKpYnR
	PySNpb0oprZNAPJESWB2YAjV2rpWRjP2TqZ0tBeuixrMzFzBYQpWfhBAcp3nJvpPE3aibLgpsLI
	MYPNiADSUkNpinKrClPj0C2zK8md2uo72hAaNzZ3qWuKYLZWuEiYxVMh4Ptk2eW3l6vsOoS0bIm
	vxn22vdRghnpM0nMvXtP8gcp1vWC1VHxrwmpEqXL1GJ/JBHx9Z5cl0Z9LLVL+Gfdpsbg4ydWRyg
	6IxPBzwew0wuHHhHuq5p01sDiECLdNcMsFe/CHta2Mx3c+GZNtOr/A461LYPrZu6D41CM9NZAOd
	2aIFS8G6wwokO1d25ecVOqskFnDQWQAzGYB2Hi5PUyMny1uRoV3MeRViuYhHSNVhkBKaJTtT2lX
	nqtTkkMyaASHm4CdQtrLq7JDnMTzQ2TAktloI6Y1aR2Qcdc3IDpXZGtY+070fdxMHoCGp5xdRzj
	+fachKVcwcvfA==
X-Received: by 2002:a05:6a20:cfa8:b0:3d0:7a2e:f827 with SMTP id adf61e73a8af0-3da3a0aaa67mr32108608637.16.1788774832692;
        Mon, 07 Sep 2026 02:53:52 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm30377066eec.21.2026.09.07.02.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:53:52 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2 0/4] wifi: fix typos in comments
Date: Mon,  7 Sep 2026 15:23:44 +0530
Message-ID: <20260907095348.26094-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Comment typos under wireless, split per component.  Found with scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Comments only, no code
changes.

v1 went out with a bare [PATCH] and a "net:" subject prefix.  As
maintainer-netdev.rst asks, v2 designates the patches to a tree, and
each subject now names the component it touches instead of "net:".  The
series is rebased onto that tree; the diff is unchanged.

v1: https://lore.kernel.org/all/20260907061417.33729-1-hemanth.selam@gmail.com/


Hemanth Selam (4):
  wifi: nl80211: vendor-cmd: intel: fix typo "firwmare" in comment
  uapi: wireless: fix typos in comments
  wifi: mac80211: fix typo "capabilties" in comment
  wifi: mac80211: fix repeated word 'used' in comment

 include/net/mac80211.h                 | 2 +-
 include/uapi/linux/nl80211-vnd-intel.h | 2 +-
 include/uapi/linux/wireless.h          | 6 +++---
 net/mac80211/cfg.c                     | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

