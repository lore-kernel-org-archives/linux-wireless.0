Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA16D471266
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657526; cv=none; b=eQYkPPn0Gn37k8KEY0PGFEPluY/xZdWXeDG/t7HHC0aGoESb3LX1jtnacRKSyd8YDf8Kgd5BMZ47+IDwoMyW2FKLmNR2xbFOclHSh3Fc0ae0e0HVeW+TVOpQQbgw3USYmrcaNaUYpgNt3R6+948I9uSAJ7RGhVLqSCzsMXs5/8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657526; c=relaxed/simple;
	bh=CDa6T/n2NUwOYTPApJaM+nQTzvN39brHZzjYqCSnEIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cII+ASaCOWRd6OmqdBCHfkxawNRGkyQoW4pH+j8fRJ4FYBodWi+dZRtLPDd02KYQFVewjcmEU3dhJs9wYcsEexVWoW4xcFaHbvZmYcLaQ6fXplzEOvNDv0QZw1JYGE3bGbUk5Nh4KN4hDEewilZ58381cxrkpTSCdQrJoSAUxmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3BFb0Qa; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3BFb0Qa"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso6608552f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 11:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784657522; x=1785262322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=atzuAW8BUPg7t2P/PauMDGaY2DZmWpTjfQUjtUYsIO4=;
        b=Z3BFb0Qax+NipooLZVE3xknRqul1xsGFAlB5EQnbq5HG6LcoVI6xHXzb625kz2mQE6
         adoHuUkN75vsE05FqQwz1UGTuSzc4BjxbDhc+Y4DhPLzj6ml2LIbDWGmStJUiRnOmgsk
         lkBsO5CcFvnrn0sbOI/eeLq+DDJEWVc/FSB6VyLaldI0qo5FyzZ5k9WrAjSNDqURbhMl
         zpKvRzBKX0k8BzBqRXgqxjVPUhmAcENfguaTVrrK97l/x+Frf/FxbQD/vubszO4AjQ9Q
         RrtpbTBs/ZoE/n52IN6xSwRiBQlX1noBrJn1YJNrjVxdubzxf1RNelrFN9wbyrdi/sPK
         UHMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784657522; x=1785262322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=atzuAW8BUPg7t2P/PauMDGaY2DZmWpTjfQUjtUYsIO4=;
        b=ROtpfwE36lngmzHNp+gNcZqf0Vg165SrwcUb+codSNE7KV/tFRJmMPlPiCDQvvpMD2
         edBYMJjvuEpsQ8tZdFbDH8nsaFLcVJWlfucNZ7fwxI2R48ycrZqzNHfISaCS1u24+HG0
         TmBX2yy8J70cGwZwIvMLOiAn1m30cRxp91KOqRHAN9kkxWRrv+xDGH2IL93EGM1plZno
         up8Z4sP8gO7/57nw1XzcE470M+9k6NiIS4HB+blw+zVnBZT/bSnt3CpqnlFVMOicsRRM
         95+fhn42EC246Ysh9f4K1Bn8pj1RYjEG0fOQVqGlSY/enwTrmrkdDqa8S9eLV3U+M70I
         lByg==
X-Gm-Message-State: AOJu0Yz9lyFEBoI8qplFa/1QFujiZ0GPdH6XqsQRoJxwKJR43dqeYOBs
	exoMeOSubtRgVzzgCEJNESGvy5jBcK2tj8T5oVbtAVc4GMM2ofBwPVh/VPrx4iyBCew=
X-Gm-Gg: AR+sD10RrqeyKxcRCAKFr9mBaOAwcllPH/gnQ6dcyWhW/rQqiz42PjL2mYzuoSfXGH/
	E0AIuJr/iXDmTsmgZNCLG9LWcL4wuyfOU85LTLUYbj4wZ8BN8gUnfcPQ9jLVG/ujMs2tEBcenl9
	NI8gkjHWs1kX5L1kEJYWx98US7R2DsL4Tg2tSkJrz6NicFNLkCFdKkQSBvWEMTtgWOTBlV0pUum
	0WbxisBf5nID5tvtG+BXo3xWM1E8PWx48RvarpbnnBOLct1E65pV7+G/yJDugwJykA+/jBlClEZ
	k5ShuYcDPo+xPuq9h8fUq0rjbDRQ3K0JROmDSpaJZE5hLXgsfX/DPPpXeMCt+c4TMZmBVVkM8Jo
	y7bvJN2vnRPq47aeCJtD0X236Nf2DuSWNPWuPLaAozwFQanvctWXPAvNqhMW5vSdq4Kkop/KD5J
	2gQxuYx3RhyEWRiwjLMj/5Kt7fECz0qM1WVfCv
X-Received: by 2002:a5d:5e8d:0:b0:47d:fc33:e6bc with SMTP id ffacd0b85a97d-47f623310ffmr23845481f8f.47.1784657521636;
        Tue, 21 Jul 2026 11:12:01 -0700 (PDT)
Received: from localhost ([102.128.173.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f67466e09sm44781875f8f.21.2026.07.21.11.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 11:12:01 -0700 (PDT)
From: Louis Kotze <loukot@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loukot@gmail.com
Subject: [PATCH v2 0/2] wifi: cfg80211: say why the auth/assoc BSS lookup failed
Date: Tue, 21 Jul 2026 20:11:56 +0200
Message-ID: <20260721181158.3004022-1-loukot@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <2629d83dd460f3d9a60566f3fad975db13b045c3.camel@sipsolutions.net>
References: <2629d83dd460f3d9a60566f3fad975db13b045c3.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The BSS lookup for an authentication or association request can fail
because no scan entry exists, because the entry is expired, or because
the entry's use_for flags forbid the requested use. All three
currently produce the same generic (or no) diagnostic, which
wpa_supplicant relays verbatim as the only hint a user gets when e.g.
an MLO association degrades to fewer links.

Patch 1 makes __cfg80211_get_bss() record the reason via an optional
extack while it walks the BSS table, and wires the auth and assoc
paths up to it. Patch 2 adds a KUnit test for the reported reasons.

v2: per Johannes' feedback on v1, drop the separate failure-path
classification helper (which re-walked the table and could race
against it changing); the reason is now captured in
__cfg80211_get_bss() itself, during the same bss_lock walk that fails
the lookup, and the public cfg80211_get_bss() wrapper just passes
NULL. Since the reporting now lives in the lookup, the previously
silent authentication path gets the same messages for free, and a
KUnit test (new in v2) can cover all the reasons deterministically.

Demonstrated end-to-end in a mac80211_hwsim VM: with an unpatched
wpa_supplicant failing an MLD reassociation on a stale per-link BSS,
the supplicant log now shows
  nl80211: kernel reports: BSS not found in scan results
  nl80211: kernel reports error for link: 1
instead of the undiscriminating "Error fetching BSS for link".

Louis Kotze (2):
  wifi: cfg80211: say why the auth/assoc BSS lookup failed
  wifi: cfg80211: tests: check BSS lookup failure reasons

 include/net/cfg80211.h    |   7 ++-
 net/wireless/nl80211.c    |  28 +++++----
 net/wireless/scan.c       |  35 ++++++++---
 net/wireless/tests/scan.c | 122 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 170 insertions(+), 22 deletions(-)


base-commit: ac798f757d6475dc6fee2ec899980d6740714596
-- 
2.55.0

