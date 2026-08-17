Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E298034D3B9
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 20:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786997825; cv=none; b=eVmXD6Y9JMVRB2EJhFasqHY/UppUWkYsutnHJZRRBDCDyqIpQ7XlHdzKvxk8Cbnljy/iP1Z9iRfMTnR9pH4XYwiP2vG9LOEnbSfmcerlaCxiGku3NI6ya9pz6J9jXTRkPYsU2iHFRquSLJG/y2iK0WUvLVRjXTZjACcpaGj1nEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786997825; c=relaxed/simple;
	bh=EjzIcz1zGypMzu78Nhg1bwmrFTPlTUKvakOpJEEFMYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqM5N6Ow0Gfgv6p2wsOsc0GKCWzyeQFV4NnfBIR726FsJJIOIdMZOixfS1plSH5v8Lpf8GdW1SwuVV/GO9aKNfnPePPbOJyUSF1CKGKzjv0OvYzH9RYROmX6RA20WBrs0BEjvQdXY6Z8/eRB4NgM7zW8VHJX+F6Tah+lynym84o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ng4r7qdw; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ng4r7qdw"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39dbe684115so2403921fa.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 13:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786997822; x=1787602622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EjzIcz1zGypMzu78Nhg1bwmrFTPlTUKvakOpJEEFMYE=;
        b=ng4r7qdw8mohVJZ1syGgw/gZFuk3YYFkeG+uRBS3UNEq5QzUE/G+8Ilddxw7OOFlpq
         r0uIaD67ZWGEcGQxX/xtj8bPMeEq4RPBqclCr9UqriFRR8r3U/BmiI+xDloS/vIB78yL
         GIQtVVkMQDeeMn8g139gZVk3mrs8e0irRFogGZ6PI527Db1yYoaWGa9hAEIuob7QDz6l
         TYwT8Yjlzcth8BtihhMJVJY9y5Fuq02+KOzqRaCBtd8XfvI1hBd4emaATM2fmLrx6KdJ
         7gorbrS8Vo4XFO24pCgPoXUlh6a/MvrAH97DbH3Nt8QdBda5Ys0/wtGQ3ORWjH+XPAQT
         XKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786997822; x=1787602622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EjzIcz1zGypMzu78Nhg1bwmrFTPlTUKvakOpJEEFMYE=;
        b=PcL3xXafwMb0kVYeCxcdxH2fGtk1ksMzBW/wQuGv7DUl6/g1iiWBbvw80KifsUnIW+
         LXJPg7aYdD7psylVsMICezno/HVXO0KBzmHODRE1TFo8zluL1xu3tMthDctviivEwTj0
         uRkKEdN3Qv+qPKlwh1SwT/wGtw/djxJvw6NVZWlmhp0wbJbI2oRx4T9nMIdqHNYPyQdm
         ze64x1P+qMB3+36qQrIJYE1/Hep1FQXriygpigIFi+XrgKIYRAqgyuA6YyG4gx+DNV1m
         T4GvD9V1USqNm2Wn0rVocxnntwBM9cLeQ000i/dfS0NMKxBqnPF7dgKIKSALW1v7SzJB
         sXjw==
X-Forwarded-Encrypted: i=1; AHgh+RrKfmFLVN1cU0Xetd2+BHVYduUWG6wAirlCPUJ6Yb/Yh5bP6iNXY6XFMKpVgmRQJAkwUJX+rPBE9PVOa3XZOg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2u9dRemxGt2+DEd38/4JF688NR7pGo3E8vdMP4btIrlwAnTEz
	xoEVvpT0gcRGYBrSwIFv47siX/tK/dQaC8Hi/UR7tCAP4CsuVIPEgvYr
X-Gm-Gg: AR+sD114xF9cZXBucRcw22USB8l3nJ5ifbYZ4t/0s3zVqqYaRLsgo1xShXaZ1tbiViX
	IkBC8Ef3PdAwQbVUj0Gf7XLD1aIAJGR3/d1AmzdDI4YHzHcl/cURZHGGTc8e6Gr/pSCKaujmeOW
	k7zmWD0omcdcpHXORnZrM4aEVz1sX+ktFp8go5D2gzvvWo5D7TzhoUP/TfcQgPxIFPQpuoz/rZh
	oGFBuA/a8QdhTz9k1DjnQWNkyf+qm6/m7drxg44GELTmbngrpr680EB4rYVsbznwrkV2q6VzQQ+
	ZRlkMCUiXbGgHSDQpibM8uP1vRsMTTDxUeEWn1keiOShcLJo8NDAThJMwXdSUxbNqsIBCMd/CK1
	JW9Qzxp8/GEwRuttcbRLtuBI7/FUoH5j5JJTqTDQLmIvdhFcDGVdmgHUWsD61jfzHaQDaaceNBi
	cJHD4o+5qT/StYCTzg0k7Rxu3gloy8xU/I392YGLiuR5uJJJZtQwS0tFZewUbxSgY8ASMOYNxCN
	/dJcPTwFMPnbN0313MIUPaf9Fwmtq20LKOY0EQZjI/+nExngxDGNmWgyLIt
X-Received: by 2002:a05:651c:50f:b0:39b:439b:6246 with SMTP id 38308e7fff4ca-3a17686d024mr2948121fa.3.1786997821732;
        Mon, 17 Aug 2026 13:17:01 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a16b0de90fsm7142071fa.11.2026.08.17.13.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 13:17:00 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: Re: [PATCH] wifi: mt76: mt7921: skip unknown CLC firmware records
Date: Tue, 18 Aug 2026 01:16:56 +0500
Message-ID: <20260817201656.1773758-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816174841.1918-1-acharyalaxman8848@gmail.com>
References: <20260816174841.1918-1-acharyalaxman8848@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the quick turnaround.

Tested on an MT7922 (mt7921e) with linux-firmware 20260810 - the image
whose CLC region carries the idx 3 records - on a lockdep and UBSAN
build of mainline at fd923b32d761, with 9417c5818a01 applied underneath.

The device probes normally: the RAM firmware is loaded once rather than
ten times, wlp11s0 appears, association with a 6 GHz AP works (channel
37, 6135 MHz, 160 MHz), and switching between a 5 GHz and a 6 GHz BSS
and back is clean. No "hardware init failed", no "Invalid CLC record",
and no UBSAN report - so the bounds checks are still doing their job on
the very firmware that used to trip them.

Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

One nit, take it or leave it: both length failures print the same
"Invalid CLC record", so the log does not distinguish a table that ends
mid-header from a record whose length is out of range. Two distinct
strings would make a future report easier to read.
