Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793844592;
	b=yrki/eNCl8Olob5ReRbtmmN2vX+Rm9c+aLvlgyfBClurTiOmkmBeO10mnaqRpuJ0umgX
	 ZKdo3RZuxX3hrgtIQYk+2cyVOy/t9Co4rxx85qLoKYmZodpTvcwra2bnYdTI6+gYrO569
	 y/5J/uefnyv4mN5VybzaJiiOSlLFjod7REns6wYCkfQVyyLAA90NahkLTENU1Yk4K07hT
	 7t2hqqENdiCgy9iMTnrHK/jlBi7RGXk7aTFZM3vLhUtSDxij/FDdPAhfeiRebzA+zhVAs
	 CB+S8jnS5AUtARLA4D+9tnYJI8SjbH6UGb/PTgA/hoLRsUlB9hGsc5yrK1VPbWDSSKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793844592;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QM0rqoR6TQ58XbCJMdcNU5VHlh8KBEoq/5kBhNjxofc=;
	b=uEXwlCBPWBzTYFSDX8au3sWcZZySx4CdvrVCc4RC7vNtntps8DzxkmKpXjZYkPWTcUGb
	 QZtDnfLVrS9pBDiBZc/H5n4Kq6aY7MPiGtXwf0uolj6gDtfIvc8C/IIzkj+PHwQlz+w+T
	 v3fRKHZSXygpCi+UaHElm4EpCTyykcF6GeT3g6kgPMBsdcbbLP6fOgJ8jP0Ny5R4ty1Fi
	 GpuGaEGZB4Nid3NPb9WMTsjAgtpJfUI1nTkFa5dHG1dSUpaz1hA/PGHztIIyDXP2OSVtp
	 k1qIc2FlSm8bIDAsvSbPuHrV6gHguNdbLN189PSJ6HVGI4DvZGULMQMl3u3V6hmU9vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DxuLsby3;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5BC606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 02:09:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F5BC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DxuLsby3
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1b244fb7fffso1901658c88.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 18:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793844591; x=1794449391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QM0rqoR6TQ58XbCJMdcNU5VHlh8KBEoq/5kBhNjxofc=;
        b=DxuLsby3907SeCgJyDfsbvUyOXMUgxEgCBV5FRQ8BUgxz6S22WV45NryMtWseE/dpU
         sTO0+loltyFMAq8K2ZyHk9DEdMBv6TCwD/CCXK674v2QpujnLk6vXzbAtNNW7XhwBAKz
         s4HSRHr31VchGGM4KxHKI0Mz6J6gQW97JlhNvnDWUCAgUzsG9pr90/JBbtpzpA0heeZr
         h18ErhlRxD3KFO+actCD56g7O5HLVMfjVqy6JRI/pkDkl8FtfSi9m57r46R0J7fkVXHX
         ztCZ8v+Vp7Er978v+jlamn2fn9oczoenJcTndwNQg5TMjKZ8ul87Q6s2DW8vvmoshtZo
         hS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793844591; x=1794449391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QM0rqoR6TQ58XbCJMdcNU5VHlh8KBEoq/5kBhNjxofc=;
        b=pN1OzoULELuXV/O/X472dh+yRr09H/Kr39kedFTLjZQkWnW8RG4Vqc7mnfrYufUucW
         0y15CmNwmVnRbe9dRiSpWj7obwK+zVfwz56j3Fi1qs7szI8mwCFyEQksuV7gmtSw9+ga
         4QAgPAdqq84d8iOdH3IZHWuD/Kj6ppQHhnna1cRvRgoNmRnEeUHT8NkeRUz1v+YGx0VU
         KAG6Zd3z7ADKwcxNfXoK8QvaGI5FH/qTzacg81X+dAko6TL+9AjozuSA09B0CwS1w6FG
         ggRIc4LQhqV0MY0Y2IvUkQL0teIcmEIDsCVSYkusOyv2AHWcA1HLhIL9/h75mgZ4Umjq
         xHKw==
X-Forwarded-Encrypted: i=1; AKwUvBw4ow0KCHCUGe+5kXqJJjf642JvuKaRnDZbpPZ3qLEK7UI746Zr7XQJNzT5+k24feKmSJKM8kvs3yDYjlKdLA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9ooy5/wKQKau0XeUCXlV/RZ8JlyOfeL8I/468ApCMfSN3Z5oPD
	SnN2cvFx/qNEnrEXeDcZabxa/ljUBQF0BFIevbCv6COSqZ/ry5Xah+XT
X-Gm-Gg: AYBFou1KAwod/nmzfbSIgz60ryA0FpGQR4QDs5GzX25r52PRqMh2l5s9wC6Y9X6Hmz8
	x7WJ2hoeWQph8lGFO4Sy03xdsJ9dwCfDVHuii+YVTY5QCSokJ2amVU7Cleti8Kv4I7UUQaPQdDS
	2q2zg45pnhQ9FT40M4x/6xNq/3xJb49umtwwM0wY60ILJjb0Woex9a8X86/PkB/vfJV0eOdj0qt
	Zq7wYDnjKFArqiEEKgozF2dktiTorheiS1OrEjKcdjoR9zDSpl91sXUmLqrfllf7JMboonQ4yGO
	5pCc0/2TwP/dAwp9XJ0tvfzdY3ehzFIhz1x8H47nJBN37bKdHW3ZjleQXelQxQnKPCa7JYuND84
	NUm0E+z8Z9IViWWWSptM3H6H8vBOwQOxLRX7ggiCn0b2kLUCOH0IeMxK3zAouioPO2HVHt2nbAi
	kkwRikcZbYRPlqzlyddYSnVS5uJ65K+64YYvOFt/cwY3aEqdJj5pLBkSpVpEB+8X1sT17Hxp4tL
	hMJTfqkG7m9dnT8ObGCZ1n5uLyvp9M1L5IhOD/hVQSF4rcgeJ3dtUXIpGqSiCymxv6cYFR97hDJ
	qdy8+UAc8Nw1/wTLr8NKx7vtQRXH7B+YmVh/pwcSFQCIbg==
X-Received: by 2002:a05:7300:c387:b0:36d:c2a:7964 with SMTP id 5a478bee46e88-36d0c2a7ae7mr4540508eec.21.1793844591036;
        Wed, 04 Nov 2026 18:09:51 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36d34d5960esm10630389eec.5.2026.11.04.18.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 18:09:50 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Avraham Stern <avraham.stern@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: Re: [PATCH v3 0/2] wifi: iwlwifi: Fix GP2 to nanoseconds overflow on 32-bit
Date: Thu,  5 Nov 2026 10:09:45 +0800
Message-ID: <20261105020945.2683535-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012050516.3803074-1-zhanxusheng@xiaomi.com>
References: <20261012050516.3803074-1-zhanxusheng@xiaomi.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Miri,

Gentle ping on this series. Both patches still apply to v7.4-rc1, and
the six multiplications are unchanged there.

One correction to 2/2: the mld/rx.c site came in later than the
sub-driver itself, so 2/2 should also carry

Fixes: f1699ad5857d ("wifi: iwlwifi: mld: add debugfs for using ptp clock time for monitor interface")

I can send a v4 with that if you prefer.

Thanks,
Zhan Xusheng
