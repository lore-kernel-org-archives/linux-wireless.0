Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACFB3ACA7A
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791389846; cv=none; b=MPHLGR2mV6IqB1JTK7zPnGzcOdmfqOrzoqzNA1l39QEBB+g9DnPIuUgaKqv5jDkd8W+w0M4dn0vi6cNhwVEEeMn8BroaL6DhqLSfyZVWuW6kgY4DeNYcwKJU5egcXMjUBk9nrYnLuM8EXsJqGWW6GEXtm4CVpisI7z1RE67stqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791389846; c=relaxed/simple;
	bh=xClNSbQk28O4IEWLfHQwoE/rQvvZVXRjJvoSD6+zhd4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FNXtd56o8Nx/ZnU3uMeaw7KQAM5epUqTnZUGJbmsNC9g9jGv1qOk9WtUN97jmvbIIzY5gd5PxW9lO+4mHXJG2lLM5Y+diQzqXqhw51y0+HKAgTaRF0We/Dk2jdRqMDPZPgD7mPFGF0gGApHwmhE9tBMdh3XmtgiJ9s6xt3vBweQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ENhyUama; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ENhyUama"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so13471915e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 09:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791389843; x=1791994643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=96ubfTEIebV0IP8hANMUHHzo8Lc8lFj1Gn1AjeLyV8U=;
        b=ENhyUamadzdJZ/jySvAFRuspLl+X9aARs8SEzWB70yIm32UCt9FqnltO0gDPJeFz5q
         9d2QVXdDO7wqsnmxPNc/UzZzecYhSKwMpbiEXOSjmNV8i+WPLmNh9vQbXMx72QAM+ySd
         ypAmLM7sf4I+SWdQ/aOeMB8yW9AAVueSUPJjkWSVzOpEXED0tChJ5+ZORY9m8y0Ycq/F
         YyP2YeRp9ujhfNYi3EhX0LNybQikICG5KOO6w3VFp1OCS1IUXUV43UtPAhuJY0Y5TJ7w
         MeXeoYpXiRwOQXSiVQj2BxLYdj4tcqzs++vDXFbXZnqApIX3p+pncew6CXxeAsTMxo80
         4hdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791389843; x=1791994643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=96ubfTEIebV0IP8hANMUHHzo8Lc8lFj1Gn1AjeLyV8U=;
        b=M64GUOjjK6kV28akuj7NZryj12uSGkN06rWuuJtF8+h4IV9Obas7iqlDJesNPN5vun
         b/+nS2V1Rt9d4WnQoiEvooRV5mgQo6TaQHIc2iByfwKcpntiMLwLjwYrwmsW30aWIY15
         cXgJZwz4WhoEpcYd3TfBsd23kAT8Xdxv5K1kRGCoC1PtBBh8v2ZP2lb5QvsqB4yMCZfq
         34vVmXNMuMvdWitxISLnaWvmmxG52QM/XgoFA9cqI4UHUIfECwjsOhjjmXK5XSFJQ+vp
         1/cLMchYpe74zih4jpMNv+xqx1Nj/PXwBOPpK+xHD8Y99mXGQZFeUkXXtlGxWQsmzfCy
         DEAg==
X-Forwarded-Encrypted: i=1; AKwUvBwypeQc05b4AMLZClK3R4AF6+wmzMa7RgociBRakNXyJCV6kvx/mz9t9rUe37ejuFc+wc9jTbSvM5X0uOEemg==@vger.kernel.org
X-Gm-Message-State: AFuF++mpIy8XiQSNjYYk+uTFhncZIdfCynwBbxinCa1B0T+K2hxP2nhB
	W2OvH/X9LlnKiZv7goDEzOpH23xfCtPKE9ShEApwxrfMzbAbGnNU+ik=
X-Gm-Gg: AYBFou1WSDEua5cdsfW3DerzRC1c1NsQsQeY09G5KadhI/SGHChdXkip+KjjJ+O4IhD
	z/G4FFE9kWAaekCDTzDaf1yeDKdTP88Vo5eYWr3sNp067RlX1LojSawJWd22/hbv42Lk1w9IJUb
	iUjWdZ/fjMtTIUgmOZ6m8kTvnZdblheAkUDBkvEam6zuymkcVDnTsAovN55ykJvoVdzitHJz6Pj
	FXvkllG4Z7JsSDcl4WhH8Z52nT5hiyUuqFggKNIzy7+I2sS26bN/hQQW25roRSL+XPUBECSbUfM
	ji5yf5QNuh1QfGMfXcaIJZA7maXzOeONX6mv/hAcDhzO2fNsuTLUBKEtV60k5TBqO593KNr0j8u
	YQQqu2+W30XvSjJPRr1TihejsO0vxXBlu0zYCCkMfLcjUZjsKR20dSxGp8iz5Bvl3gPLLGRZnfR
	oHgOIhspDckvsYV81mz6hdUS2o6kACjW4VH5IH+Hc=
X-Received: by 2002:a05:600c:3f12:b0:4a1:698d:3042 with SMTP id 5b1f17b1804b1-4a1803113d3mr44267585e9.6.1791389843053;
        Wed, 07 Oct 2026 09:17:23 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843aac98sm2685295e9.9.2026.10.07.09.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 09:17:22 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@kernel.org>,
	Po-Hao Huang <phhuang@realtek.com>,
	Chin-Yen Lee <timlee@realtek.com>,
	linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless v2 0/2] wifi: rtw89: fix IE length passed to cfg80211_find_ie()
Date: Wed,  7 Oct 2026 16:17:19 +0000
Message-ID: <20261007161721.261452-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

Two callers of cfg80211_find_ie() in rtw89 pass skb->len as the IE
data length, but since ies points past the management frame header
and fixed fields, the correct length is skb->len minus the header
offset. This causes cfg80211_find_ie() to potentially read past the
IE data boundary.

Changes since v1:
  - Straightened the cfg80211_find_ie() call in wow.c to a single line
  - Removed unnecessary blank line in wow.c
  Both per Ping-Ke Shih review feedback.

Tristan Madani (2):
  wifi: rtw89: fix IE length passed to cfg80211_find_ie() in 6 GHz probe
  wifi: rtw89: fix IE length passed to cfg80211_find_ie() in WoW AKM

 drivers/net/wireless/realtek/rtw89/core.c | 6 +++++-
 drivers/net/wireless/realtek/rtw89/wow.c  | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--
2.47.3
