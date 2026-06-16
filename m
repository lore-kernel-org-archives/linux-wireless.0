Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89A388860
	for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2026 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781619399; cv=none; b=B3SZDSgbWr6I+Ji1XK7pr//e5guLWU4ezWAogp0AsG0vu+Rnd4bhlz8qSmWa+4xOb6D3tuWsWO15op1o8WvJOubpR/bJRISIq0AHMA5s3YjhaI4hnLivK/hrGzcTKdG91HRfWImFGjU8c3cczVKBn7D1J0aDR6i7vNTJ7BsJ69w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781619399; c=relaxed/simple;
	bh=L2DG+L5Kpgnnah4oYouE9C15yNIM80TbNg8vzs+o4oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKHeE7XrnI0hDWcjLFlCxluCVLP43DGF6DIzYnQve5HxlgN1n+bfEIvva6LnlmQS+f56GXHG8/cLQENTbppplFdsOsXl6HZmPTn/98lu37Ktjue5c7n0CnN8q0XyzgA7PgK3pG4kEkHZDtPMZAD3X6Ofl5/6b1PZiRmPJF+DkCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fASRkxPl; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fASRkxPl"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bdb3fd39045so670332766b.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2026 07:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781619396; x=1782224196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhHCJY7V6uO77H2mkenjYXx4UrXf6lFT0U3uVHQgInI=;
        b=fASRkxPlzgBFl8X1mO3UA/qwnlZpzpQW52wRAUxnQ8u2T4mk+pbGM9KnH0AdFneya1
         WeREOK4ugysUBUnJqW6KCLo9fJcm/1Ltr+pUDYxfR5BoUI7ksS9vadmJfP6+OXNvrEI3
         Ok+853m3jYWUmVihbcJz1xjx8qOa0BO7/PogowR/WgBPlIwOkYyV5quffNa/i9PFHB5B
         igpC95j2M47KYpN/Uvah2bSSLG7mSefn73UUzFr9MNx1rKTlmrArXHENzAYvcapIhcmZ
         tFuaVntKEstktVhXI0eGMvH6dy34kRbihDnAnFbnIVdCM7VVn6Uiae9di9OAawdRrvAu
         YHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781619396; x=1782224196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QhHCJY7V6uO77H2mkenjYXx4UrXf6lFT0U3uVHQgInI=;
        b=jfEt1RtRhVn7LwDCln1XYfbdbbjjvUsihg9kaNe6UUmRjC2r5z2DrCO+IDQ2UOzGSs
         s1VUa76wQ9REHo8MCF3VDn0GmhQUuan4qNqyXAlUibIf0sqyZiapteORdt0bSZcPODYk
         B5foyf2+fb5LtauUoJdiQXUqgJEC5lHkxIUg15W4pmUwK30aXHF3+rLOhltroN/HFqUq
         zeH1cHCZVP2+JZmyCFPh9aaag3jorM7PMwc4uoWyr3I2aiBmoSjc9mN7u6ST6NyaM5Vd
         GEgFas4D6iFAu9Ib6UUeoX9uAWLp0iUQmGFPZHfTu/IPTtAIBfv7pplkb26A8Gsy+YLG
         n6Zg==
X-Gm-Message-State: AOJu0YyKRM5C1lJPkhYKMm9+6GL7xAYc9Ut0msyJFQee4fHy5Y9yHL4F
	Q/QBDVngw9labMVYUQWosHj//6la/Q4o/lu7DmdhAGlW2I8+ctUyFl0m
X-Gm-Gg: Acq92OFI/ngUkJ/MLdJPHSQS527H7DaKlwYhj6gnZ+mOX2OiX7+up7F/qykHmIDYiOn
	gDEEL+K81onuRprom0kvoW/JCxJLHCdeJQ9actMhZXRdxDbncFDyBY3GUsU3eNtXJdV05srok8t
	cyZGcdcpcIoCG9NibeQj36uKalDtgPf32z0+w0KSQuhUS9nFC5YqsnXZ/p5T0Fv7hOJHp9mAr+J
	zNnUOr9PvDsLMSYdalns0VzJqsrTkclSi1QfrR6SoxbjcyF1RXX2JMvN10tRS6RDzLlFRtNr8Qw
	6iFSPOw5U6MYkzgjUBWlkAK0BFyejT0I7+b9/i0ADjj2rsRwUXANbP/8tjIN03ePdnemdpZkgUD
	Y+lexJAIsp/ANzLZAQEXWUdVBzdm4xTYcqHRu8sFaFoSEK5HNI0uHFP5Vjtk+Ulzsgo+VDalL/p
	A+kGcTPxhwBZziHkQVqwJ2TAHqnDaE/CIdiA==
X-Received: by 2002:a17:907:3f87:b0:bee:ac9b:9abc with SMTP id a640c23a62f3a-c043cdd5664mr216934566b.22.1781619393777;
        Tue, 16 Jun 2026 07:16:33 -0700 (PDT)
Received: from localhost ([80.208.66.169])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb9113dc3sm662911066b.62.2026.06.16.07.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 07:16:33 -0700 (PDT)
From: William Hansen-Baird <william.hansen.baird@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	William Hansen-Baird <william.hansen.baird@gmail.com>
Subject: [PATCH rtw-next v2 0/3] wifi: rtlwifi: fix ASPM AER flooding on RTL8723BE devices
Date: Tue, 16 Jun 2026 16:16:17 +0200
Message-ID: <20260616141620.91081-1-william.hansen.baird@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260614135508.70307-1-william.hansen.baird@gmail.com>
References: <20260614135508.70307-1-william.hansen.baird@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes AER error message flooding and system slowdown caused by
RTL8723BE with subsystem ID 17aa:b736. The flood is found to be caused
by ASPM, and disabling it stops the AER spam.

This flood of AER error messages for the RTL8723BE is not unique to
subsystem ID 17aa:b736. 
Commit 77a6407c6ab2 ("wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723")
targets the same issue for subsystem ID 11ad:1723.
The fix applied in that commit, however, does not correctly
disable ASPM. It merely disables driver control of ASPM.

Patch 1 fixes the previous commit such that it properly disables ASPM for
subsystem ID 11ad:1723.

Patch 2 converts the if-statement check of subsystem IDs to a
rtl_aspm_quirks pci_device_id table matched with pci_match_id() 
such that future devices can easily be added if they have the same error.

Patch 3 adds the RTL8723BE with subsystem ID 17aa:b736 to the 
rtl_aspm_quirks table to disable ASPM for it. Testing on a 
Razer Blade 14 2017 showed this stops the AER error message flood and 
wifi works as it should.

---
v2:
- Implement __rtl_pci_disable_aspm() in patch 1 which disables ASPM 
  without checking ppsc->support_aspm. 
  This is called both by rtl_pci_disable_aspm(), guarded by the original
  check of ppsc->support_aspm, and the new quirk code.
- Rename rtl8723be_aspm_quirks to rtl_aspm_quirks and fill out system 
  vendor and device ID alongside subsystem vendor and device ID in the
  rtl_aspm_quirks table such that we can use pci_match_id() alone
  without the RTL8723BE check.

William Hansen-Baird (3):
  wifi: rtlwifi: fix disabling of ASPM for RTL8723BE with AER flooding
  wifi: rtlwifi: convert pci if-statement to ID table
  wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 17aa:b736

 drivers/net/wireless/realtek/rtlwifi/pci.c | 40 +++++++++++++++-------
 1 file changed, 27 insertions(+), 13 deletions(-)

-- 
2.54.0

