Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EA93218BA
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 10:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788602758; cv=none; b=MZB4E12hvlnDsxYWRgojDPkvIx9ie1dMfW5mLTfLbDgSaTkemWiSTsgD2a4TRYQR4bvBveUekfML+M4rNStGaJ1ge7MevaCngRzD16cXEmXrTED3HmgGIM0uP3sfHqlyHI6gzeBLnYwNO50DoxkUrATItpTNryr26ZvGjEGFmjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788602758; c=relaxed/simple;
	bh=cpP8ANudbdWPOFQJFqMv+O1f4auumUXQKGMA0l7fPo4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JJPOiyMKWq0Bd4y/nK9doiNwnXoBOk+//cSFvVUTJF2bTfNiVxOCbnmevGyB5RUCQ/TXnbKxEaNQbQH6Help0GvoGM/MMxfdcved/ynrIBKzKbcJKzEcyFwNoWqzYOWfjgUK2Jd3ED5SDkR/Nr5iV4uinqQ1Tr5ELc+0jVq+p80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RnX5gc2w; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RnX5gc2w"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-39c7ef2b1e2so16900851fa.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 03:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788602755; x=1789207555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KEmycsxdKEgtKycB7F+mNFHTBFbitCM1fHqOBorxUCg=;
        b=RnX5gc2wuiX2d/Z5Sr0FttOIP9ikHXL0wOBoIpa3JHvSHzL2K2Q3q57u5VoJCQSlB1
         YF6ntulkXgJbjYg0VYeTAaxSCag1JkSVNAgsiFW9d+Pch+uq+nbnnfuzQ2PoR4oSUDLv
         F5vp73UUl07Fm6Tkg953YrsUTXDHcNQwS5gxu2P09tEDDi4zZcIy4dBK70/YM0CQ6LFJ
         WkYZfcIBFrZdb3maqr8ta7pxCse7fwkoFui4rCXcnLhRhYR2YLNeCANvYTq8pWrM+b4/
         HISYHqDjfPdOVq98rBCN6utqyXqH/hAbvoR7AYxlZ3XQxMye9Penn4j8V9DbV3mWcIC5
         XilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788602755; x=1789207555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KEmycsxdKEgtKycB7F+mNFHTBFbitCM1fHqOBorxUCg=;
        b=r47Ug+wfMZoN6LtnrxQfO6RXqZvTJRLWJRzds/DN4Xsc+lG7ClgsN0UpvMQlVTcvph
         /hSGJZ3HTFP0OQ2KqPGhHr053MYV9NP1VCd2DlwgZB/vrIXwVzcfKzjLATbsidDpo3Pr
         8mE9+BGJueJUOJnYZreC41kU9f4rBMhiTRPJPhli2bRh8bJPwBr3EwkkySOegnphLvho
         nv6JjnfJklIXhJ2CcmjeF3fEynKv+Xgz6JJgIp65uYJeq25s8MqB6n7096LNVCnZV+GM
         QuUpAsGnUp9e0GH/oMF1H1HkRrI2e7tUW8WfDdfoAWii2RxFKFxMs00F50dusnl8+/8G
         kCQg==
X-Gm-Message-State: AFuF++nfWcl4QZAef1dHDmw9xGVS4YrY53sBHTv8ZhbWyOOchmlT5Ipq
	VJ9Q3dBYcBHQ4bQK9xLuRUWl7o5INHD3UJzlqCtO16rfWIqXHdgWwjZs
X-Gm-Gg: AYBFou2GAGr5VErNxCegVO51moQomfGrgytxZuZYZx6EUh3qXSV18A4oEygSDu2FBix
	dczbbYCG4Dtnq+hOnGSAfyUt1iKeG5HjPjsVf9l4UfrT+pWLT+sxExa9pm2yAsxjxSmJ4cnu1Rn
	WkamHae8AM1J/pK8//TSsEqFzkjByEIW6/g7wbI3DxtmidHdeTqbLwMXnJPjjLryw2PM9UwBkfU
	YDF1hsMWRWL33wYuuG5TnCOUju47VLC3fHcFaKSwYc1WMqDATlLGQjXDp1f504/8ly6Q6F9t/VS
	dyznE7drTolDWMDNPVuJ8ngk+he1L/O14Sss8pfTZj+3OHkgrfJOypNXRSbdz3QioLJ3azTubav
	bvewVzg+LJpmWOla+QvYbNYihNU7M1vmtLdFkqb9TM9W+pU22JZ0DAvBq324eFsJdNAwmZEbq0w
	xdGioM8dSu2l9zjIM/XwiAUuiUw4lNYRyY+VCIpwyKHuRlZnXHToMBe4gU1kBb+piBsizYM+UXX
	BEQQTsF9V5QiXz0XgQXuuzRgfNBnY8r/5ik6dMlE+xXhwNmngg2DKWU6pOSCQ==
X-Received: by 2002:a05:651c:a206:20b0:3a3:74b7:fc0f with SMTP id 38308e7fff4ca-3a374b827ffmr7443231fa.27.1788602754702;
        Sat, 05 Sep 2026 03:05:54 -0700 (PDT)
Received: from archlinux ([94.180.80.42])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a3705868a0sm13107741fa.19.2026.09.05.03.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 03:05:54 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v8 0/3] wifi: rtw88: rtw8822c: refactor DAC IQ calibration to s32
Date: Sat,  5 Sep 2026 17:05:45 +0700
Message-ID: <cover.1788601784.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series refactors the Digital-to-Analog Converter (DAC) IQ
calibration routines in the rtw8822c driver, eliminating legacy
unsigned workarounds in favor of native signed math.

The original code heavily relies on unsigned 32-bit math mapped over
a 10-bit circular hardware register scale centered around 0x200. This
introduces complex nested boundary checks, custom bubble sort rules,
and custom min/max tracking helpers.

By migrating the temporary stack arrays and signatures to signed s32
and utilizing the kernel's FIELD_GET_SIGNED() API, the coordination
system is linearized. This allows the removal of internal custom
helpers, collapses unsigned wrap-around logic into standard linear
operations, and enables the drop-in integration of the kernel's
native heapsort library.

The series is broken down as follows:
Patch 1: Introduces GENMASK constants for register fields and replaces
         manual bit shifts with standard FIELD_GET() macros.
Patch 2: Converts stack buffers and function signatures to signed s32,
         switches sampling to FIELD_GET_SIGNED(), and straightens out
         the validation windows and hardware offset mapping.
Patch 3: Replaces custom bubble sort logic and unused helpers with a direct
         call to the kernel's native sort() library using a safe,
         overflow-proof relational comparator.

AI Disclosure:
An AI assistant was used for source code analysis and conceptual
consultation regarding the signed math transformation. All code
modifications, final implementations, and refactoring steps were
written, reviewed, and verified manually by the author.

Testing:
- Note: The author does not possess the actual rtw8822c hardware. Actual
  throughput and runtime performance verification is left to the vendor
  or community testers.
- Every patch in the series was verified with scripts/checkpatch.pl
  and yielded 0 errors and 0 warnings.
- Each patch was sequentially built (bisected and compiled) to ensure
  there are no compiler warnings, pointer type mismatches, or broken
  builds at any intermediate step.
---
Changes in v8:
  - Patches 1/3 and 3/3: Collected Acked-by from Ping-Ke Shih.
  - Patch 2/3: Fixed comment block style (made the first line empty).
  
Changes in v7:
 - Fixed variables declaration order in rtw8822c_dac_iq_offset() to comply
   with the "no declarations in the middle" kernel style rule (moved 'avg'
   and 'i' to the top of the function).
 - Fixed a typo in patch 2 commit message: changed FIELD_GET() to
   FIELD_GET_SIGNED() to match the actual code implementation.
 - Simplified the signed average hardware mapping in rtw8822c_dac_iq_offset()
   by replacing the complex ternary operator arithmetic with a clean, standard 
   bitwise AND mask via GENMASK(9, 0) and added an explanatory comment block.

Changes in v6:
 - Noted lack of physical hardware for throughput testing in the cover letter.
 - Fixed a typo in the subject prefix of patch 2 ("fi:" -> "wifi:").
 - Optimized the min/max search loop in rtw8822c_dac_cal_iq_search() by
   starting from index 1 since index 0 is used for initialization.
 - Reverted an accidental change that broke the compilation.

Changes in v5:
 - Fixed a typo in the subject prefix of patch 2 ("fi:" -> "wifi:").
 
Changes in v4:
 - Flattened the series from 4 to 3 patches to avoid intermediate broken
   states where sign-extended variables interacted with unsigned check
   logic, ensuring 100% clean bisectability.
 - Leveraged FIELD_GET_SIGNED() for modern, native handling of 10-bit
   signed hardware entries as suggested during review.
 - Shifted definition of register field masks from the .c file into the
   shared rtw8822c.h header file according to subsystem design patterns.
 - Stripped out custom rtw8822c_dac_iq_sort() wrapper, invoking the
   kernel sort() library directly inside the main calibration search loop.

Changes in v3:
 - Corrected the subject prefix target tree from wireless-next to rtw-next 
   as requested by the maintainer.
   
Changes in v2:
 - Fixed missing target tree name in the subject prefix (switched to wireless-next).

Arsenii Pashchenko (3):
  wifi: rtw88: rtw8822c: Use bitfield macros for DAC IQ sampling
  wifi: rtw88: rtw8822c: Convert DAC IQ calibration path to signed math
  wifi: rtw88: rtw8822c: Replace custom DAC IQ sorting with kernel sort

 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 161 ++++++------------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |   3 +
 2 files changed, 55 insertions(+), 109 deletions(-)

-- 
2.55.0

