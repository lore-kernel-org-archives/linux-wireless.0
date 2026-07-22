Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED6133EAF9
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 07:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704060; cv=none; b=VBQxIshvA7pCizaADJqDtU/jgG6KbWIo5Vhl3P7tHnkTC7d84kPb/rjhxByeiZwLXUY0DiqIIZV/a59ueFrVp9R01NCrJpKg6V0eBP0ljt6QygYxENsIe/lKUvW2rPnN5cesBOYm9OIL/1ZpmcDim9pH30QQ+nRmyuC0AUp/mbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704060; c=relaxed/simple;
	bh=bodMFi7taOfL3wl99o5rWGxnp/aWxE/BQmjmBdSLFd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u87X3ClRKASmbeuLcjdDaKhpLaisjejZK3VuFPLGFp9gg0TDAUk9pkZ4NWCcz4rdbKbSyoELXsCWcubNYYnwHxSJsuCuaiDAMpPHuxJRw4NVB7lKwcH+c62GwgDu0k3bQ4d6qEJwwuqVhPjVMSyP9vTMWqtOh2r5rvDThOBmrX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IwVnzC/s; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IwVnzC/s"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so19181085e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 00:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784704058; x=1785308858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A0tVSkx36GeNpI9z5aZsGTmDHitm0/Nzvhk8+wS4DA8=;
        b=IwVnzC/svibWAJkTm2ybKD+0cxIn6wFG3ooerFSDe0PIBJEN5FgXgAg9fCM2tiiGZP
         bEjnwPl9mf/bkLa8FmtN0iKluxXrPca8yeO3y7xK0a70/ZdJdhA0/Aydmgt31UrlkaA2
         VU8vvXdDdjhNEJlUqR0GOftkd+krsEzs7sdgnmtGGkb4AmrVNhNKRjNL/YXH6VAhK/4y
         uCH4BTxp++13kUbLQsXWJF5Do+TEbIz1+7Db5fNocmPUIIaZjyzYOxvwpNo0l1NGBlpn
         fdvKogzI17znGd6dCkFtb83Bq+R9/DB3VAS7hMk/flri+iKZ4JLTyvk/Yd+WEcaS5qmB
         zrrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784704058; x=1785308858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A0tVSkx36GeNpI9z5aZsGTmDHitm0/Nzvhk8+wS4DA8=;
        b=WMWseRTRjP3lQaPdCkvEf5rWqkiiy4AnQL9ar3+VkkCd9AUU/QsLHatv1BJUsOYb93
         eXe2QkxwVwttSA5PbKKokR/fQO57DzGdGgAyfpmWWBp7rdvtXeq0/017js04ImEHlUYn
         7Y0BUJnfs/kyq+XS5esYip2c4Hhx9VPHep+CcmpneHe7uumCFdkwG7pst0ubN8T4qkSt
         Cwr65cIIGnzaZJgT2csda8SYP16tbGC1wsoUEqF+j16/fHKNXpCI1MGq31SpZRce8+NR
         VOXakA7Zyvv3RHi0RiK4ww41zJNNSt0+DBHfykOU3B/bcmU4hpYoAhWKrpd4dbalyfTI
         D2Hw==
X-Gm-Message-State: AOJu0Yxk4SsyJx3VtUGheGGP7ctuSkd5LYjEuE56e/r61Y+e6wdMo+69
	V7I7WkAIK54IEWm742fkyRRYTxhq5ujWQ0R0amFzPmNhVq0NHw6G+5EwOr4o7LkWJI0=
X-Gm-Gg: AR+sD13U1Z/9LrCPjWXnUOEG73FB7BBahsw2u33PBV3/tiJ6BipVQlCcHUXNAxD5oQ1
	rAr6mA7FybCI5D/MPhnKc2ubUm8ebWjznp8xeXFpLGSgdvzaPjSYMOy/MmRaEnNEbmGMi10pABq
	3aFQlL5uK5SlIHJYxIrK1StWzYCu6XqyPA4v5sLpSbpl8CcIKzF6TzElT2BKAnFRiNRGWJbkwcx
	vCU+gO/p6/wy1v6iBYmHK7gHuHYtL3UMNkd//V39PmGBDgAMDA7WgMuPRXIODLQaUlMDCeJ0nGc
	XHaEh/S82b8fiTFFdO/D+67qakCcdAZcjCK87j/v42Sr5zxaFCsAp1dhzhycJRs2Q1Cs44ivtq1
	c32wmpqzgMZ0TLy6uMyyG5DzghNl26xZRqXcKn0uB9jxEJ6CRRUx9TawUuSAkFsMXJknufZr+nl
	iw75i72OjbkZDmblxHUTup4d9itg==
X-Received: by 2002:a05:600c:b8d:b0:493:a613:56b2 with SMTP id 5b1f17b1804b1-4954a3d0d5fmr255278905e9.8.1784704057580;
        Wed, 22 Jul 2026 00:07:37 -0700 (PDT)
Received: from localhost ([102.128.173.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956b72fac1sm28231115e9.1.2026.07.22.00.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 00:07:37 -0700 (PDT)
From: Louis Kotze <loukot@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loukot@gmail.com
Subject: [PATCH v3 0/2] wifi: cfg80211: say why the auth/assoc BSS lookup failed
Date: Wed, 22 Jul 2026 09:07:32 +0200
Message-ID: <20260722070734.3612581-1-loukot@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <bbb15b0ae332d7344f5b69da5e993acc6813aca7.camel@sipsolutions.net>
References: <bbb15b0ae332d7344f5b69da5e993acc6813aca7.camel@sipsolutions.net>
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

Still demonstrated end-to-end in a mac80211_hwsim VM: an unpatched
wpa_supplicant failing an MLD reassociation on a stale per-link BSS
now logs "nl80211: kernel reports: BSS not found in scan results"
plus the failing link, instead of the generic message.

v3: address Johannes' review of v2: use GENL_SET_ERR_MSG for the
-EINVAL messages in nl80211_assoc_bss(); comment why the bare
NL_SET_BAD_ATTR is enough there (the lookup already set the specific
message); comment that the identity checks in the walk must precede
the expired/unusable classification; report a combined message when
matching entries were rejected for different reasons instead of
preferring one of them; drop the "scan again" instruction so the
messages are purely descriptive; keep the original argument wrapping
at the nl80211_associate() call site so only the new argument shows
in the diff.

v2: per Johannes' feedback on v1, capture the reason inside
__cfg80211_get_bss() during the single bss_lock walk instead of a
separate re-walk helper; cover the previously silent authentication
path; add the KUnit test.

Louis Kotze (2):
  wifi: cfg80211: say why the auth/assoc BSS lookup failed
  wifi: cfg80211: tests: check BSS lookup failure reasons

 include/net/cfg80211.h    |   7 ++-
 net/wireless/nl80211.c    |  27 +++++----
 net/wireless/scan.c       |  44 +++++++++++---
 net/wireless/tests/scan.c | 121 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 178 insertions(+), 21 deletions(-)


base-commit: 69bd85e933c617a84fa54fcc80e628e98afdc45d
-- 
2.55.0

