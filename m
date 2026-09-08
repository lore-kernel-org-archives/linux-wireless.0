Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E2A355F49
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 03:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838893; cv=none; b=G6nV3nkKpPL6Ox7U+7LRuQdvRHPYypYfMkpL59mTRJc7e+s8ppdinakm2f4OY4qA3E//QqN+WRlynjMSn+i2l1CeCEx7RGa79/k06U3W17CdQj4EGD10g4Kj9aeEUjZSUvK/MBB5C6VJ/Li5z+bLGBfXez5t0LK6gLCT8N3CUbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838893; c=relaxed/simple;
	bh=RVYRuLJLoWEYUIPzk5QlE8xyUNB5ZMc142ZXcNtg7dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbFuxDN1OrUhsL/N9vTdPcXPTiovX2t7GzS/Y+Tb1058Zou7H+eWu0xcm00J9HN4cVERRFvhnj6wjHGTJfzbjAzL1WALgPTQmyLg2xJ1px7VJjlI1TaHt6EaStDmxm9xS7hi9RYnUxhDHUZiSNB5U3ETNxB5sjoSC2LMoW/XWto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CwmKmpZp; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CwmKmpZp"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d6ff2f2c4eso4110605ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788838883; x=1789443683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RVYRuLJLoWEYUIPzk5QlE8xyUNB5ZMc142ZXcNtg7dw=;
        b=CwmKmpZpidPWgTNUtHz9iVDSvoogM3OZQrY86EgrqKkljwNsoio7DFJ5BbPllzYr90
         QvY4Nf+OqiS28JJn9auBFqFpp5TZWxkghBBrd5bgu4/WTTLWNJ2ua/OMMGnVB6b87fhr
         hx7ky/Aw2Y7GpqJAz3yySKwE7odAnnm6BOWDe2gNL4G1k+9mwfZSLd5ZbUEjXiwuW4rq
         fCGpkvPTD6tW7Gy3NvcUklW86CGQlA6drmpSTURUHbKN5sIxTKS+8f3yCBHJY95cn3mc
         y8RuDC+Xpi184wU5YC0qs0ykYSr5a1KNR3pSOwCP6ilrOGR2Nxn7v7N5sz1yZf32fZ+c
         WoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788838883; x=1789443683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RVYRuLJLoWEYUIPzk5QlE8xyUNB5ZMc142ZXcNtg7dw=;
        b=UGauDjigt0UhWuws2C44DYf+EtKSUtq6H7/asrVckfIEubpA1YcqryRn3hfob71qED
         hO/Nbltq3hpl3/Jtf3ElkBQEa9Ude2O20u5AQ35f1T3DCEuFYWmfdsTAWxzeoJz1/cZK
         D8W7e2TWWCo156+u/4GHdRxQF0ysvTHuK5iM+vi9xHI8DJ1tLSCr8sdVXMH9Wv6jq5IJ
         7Wzdl32CmO4LYd1zR92HHFibO200JP+bVFAg2E7iXiooJmgxp0Rb1RUiyLckSRGG0BBX
         jW//Zrb/RAsZx4Z+Pew8siL99gmC7EaKctrOj8MDwXxdgQ2s53F4NSgtsbMC3kTrjYEp
         vVEA==
X-Forwarded-Encrypted: i=1; AKwUvBwMq01QTjqiYs+hOQhIPfDT+JkoZQiw06cFXve+SIjEtSx+d3E1q0hcQLAXTXgPJvlITDHvBF7WXvHl3sSNmg==@vger.kernel.org
X-Gm-Message-State: AFuF++lImSR23fzTPQ7chx3Twu+RooG/E12JCWbOmp8hNyhyl3RwlvSW
	JmRJxhiBO9OH9oQ5BWjY88ssyvk5qQl2YRfJ6L9VjgCDWx/6N1apJFtG
X-Gm-Gg: AYBFou2b2Z3mnUxpJ4CypB5u1bNQNEECNJxG7ri26rZLST16Pfsn+m4Fscc07LzzkyT
	NzXxhzCxbwinVyrwjcx2s7W6VXnznjeJ50mdVUbB1RVr/wKKzAx7ixj/YSpnlaXS7zJqkbrSGK8
	jhMKrjZQUmiIYnNTQvoV70pEKjd5k3+ZnEYRo87ds+FW1tHkGmOXdr1eSMsHbDahmgCSfux6x3/
	xFiPEsiqaAlhB6wWccaLeaz33g5n+4D+kpnmftRElKSOqG03/8phW7KmnSMK7dHUwxxo+lgOf5p
	G5iv9VryYgQGtozsrUFAn4oe1Er1p3yALyXbYwZa+/jPOUPiCrncAEtCGVU3SDPdUf1T3xMVc91
	87OFBGQbFr3SvLwNXqtBkGRKmgtngTkHvRFke6B2sY89CIEU/2jSxbFwWgGn3k/xTJu08JAmOrh
	LgLM/m+2+J/75q3qJ/1hhyzeiEsp9za8p9cVicNyk2v1A8nk6rFcFYl+ZO7qByOnOGMwn5oL91x
	l8AzBUpkJnYd8rYkCmmz3BS15M4BKizI+M6WkxC
X-Received: by 2002:a17:90b:2801:b0:38f:aa76:88b with SMTP id 98e67ed59e1d1-39b3d7d056fmr17645951a91.4.1788838883266;
        Mon, 07 Sep 2026 20:41:23 -0700 (PDT)
Received: from cachyos-aura ([45.112.148.105])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3369856a9f7sm13696442eec.5.2026.09.07.20.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 20:41:22 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless v2 1/3] wifi: iwlwifi: pcie: don't infer CSME presence from a failed read
Date: Tue,  8 Sep 2026 09:11:16 +0530
Message-ID: <20260908034116.416258-1-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <60a8acf1adc0d2acc5c558c4cc791d01421f6b92.camel@sipsolutions.net>
References: <20260831130332.323549-1-navonjohnlukose@gmail.com> <20260831130332.323549-2-navonjohnlukose@gmail.com> <20260901154828.GA1879052@bhelgaas> <20260901161736.GA1883420@bhelgaas> <1a2c11d47b27dfd8a246300ac158d25cef5abf35.camel@sipsolutions.net> <20260906230022.148733-1-navonjohnlukose@gmail.com> <60a8acf1adc0d2acc5c558c4cc791d01421f6b92.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fair enough, and sorry. I should have said this up front.

English is not my first language, and I used an LLM to look up commit
hashes and to rewrite parts of these mails. I see how that looks on a
list, and that you want to disengage here.

The work is mine. I hit the D3cold failure on my own machine, did the ACPI
and Ghidra digging to find why the reset never gets armed, wrote the
patches and tested them here. I assume I should have written the mails in
my own words here, sorry if I violated any policies.

If any of the technical points in that reply were actually wrong, I would
still like to know, since I would rather fix the patches than defend them.
But I understand if you would rather leave it.

Sorry for wasting your time.

Navon
