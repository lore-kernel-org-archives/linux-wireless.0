Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E993C342B
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 05:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895635; cv=none; b=soEPripSaDAgU96NqhZcM5FPNXz+lHyzd8TPKkmcYPYtWGaM1zPO55q18UeKCn6Gl56sa7sLcQSGfBjUlfkSL3ynVJ3t7i90NuMxzyP6bPDBAE1DDbmDIzO1X20DLfwrVLtrFPrs/KEDDOV9EkGy4Dy5wiFgjir2IZvuDo6tOUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895635; c=relaxed/simple;
	bh=dBbjlkA2tsBHvTcCMvacmI4N9SCJyqRzT+DHpOXjsMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EV9T5Q38z5V4RT/azG2hJ0+kCmXV9N/w8QqkjzzAAkA+VAeOpjNePs/sZLG7fNwvgW0+94WI0Ke8EIUtyrUQsXICM9ayCa45ZlttyuTWHKsCAgCdlGfU0lHpj3TUEvDrO+vkfxXO+eADrr8ffQMsaUVCETm5eY4cShsNyadRoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XjWTOHUw; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XjWTOHUw"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b4a95ab94fso1859668e87.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 22:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787895631; x=1788500431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oNQ5o0lvWu2bpZfsZoLZ2i4xs2m18GDSA2KNq9uyagw=;
        b=XjWTOHUwFviNpgOB0vhQDseacVjeO8zgnU1Oo3EmvuR8v104iNEcpvFPwH25sXYcF5
         OUeHM//1tiEgopQMA2kUOVKD7hYSsrbbLz4ReCyfGLdJR1KIfZVtpneHHIUY9dHNKuTz
         J/URtQ/U6rdOYfTYojD6EQ2wvdOlzPdwyvCPWkc4/cBpk0z8IMuBXNjiEhFuPJ7LczMK
         iFie5xWBJv0siO9UcO7cpIZwgSY87GGqU7tdlqkSdDZ7W5t3XHdAMh1X4ZYGyblClLd7
         xMhhTE9JoRB9eEP9MTVxBY/pO9wYCIprQro7jK3qoc439Mc8X5s1n6YsrIQJ8BoyYurj
         uSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895631; x=1788500431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oNQ5o0lvWu2bpZfsZoLZ2i4xs2m18GDSA2KNq9uyagw=;
        b=gzWuscoAyWsyqXkgMsevjgnLXq6iZ1DTabfrxj7hROfTGXi7yntV+LAdiAnqgpNDrZ
         m0NtBd4lcUx5iDQrnDUggq5Z52KudD5+DnKNraBO/a4P4010d4+OWKQ8OrV20jpDBzyf
         sWT8Fm6dZn3mcdQ2YQGM3MqnMWUxk3XVMxzIZZw9qcQe61Siex83WusdTlmtDN1mnKxz
         pBGVvhgvJmV3YZhZopBsBUcZR9GqRWND63LdM+rbPsVCb4ZeXionR2vaej/vEMXvM9RL
         CSI7xQa6UKJzlLrQ4ohuOwfCQ/JljnqsbYdKTM/SHVhhibni2IFn5DOGt0TnHOuVqyYg
         Hbww==
X-Gm-Message-State: AFuF++npKV6TeCi/Bu1bP5KYDuQbHYYYHlX4tcpxKrT8QIxiiiHmq4ek
	owj2DkwtDaMp2jtDw/mBTRjh3HcXdcJYiufTww+jzujLndPt5oPTIccZ
X-Gm-Gg: AR+sD13o4NoamjyR547dkR7t76rL+nzjaveZ5mOeDDSmk8zWOURniaovUxgx4QoGCBQ
	RAyEmuDYyusruIsbrBWqVlfdiA3Lgc80OX/AeOytYE5g9yTuLc/TVg8UDRE0YznjRB9IXi2Vgws
	7BWjBYZX6m3hHV/6o2AL1dgAopV31ZkQyrdXs7j7PPWCgh4sVXZ+4hp6qDKjqoApPSew4Uty0Ta
	tIUY0MjVjVdq0OFO4E4NBifx68FZpuLmB+eL/0X7vOc4qKHWaeAUC7sN9mWp3qFSE/yc1mEf3W2
	Djfnjdomd4iG8Ijp7b/b3gWHgEF7vXqMEdkP2dlGWo++5ivN3uqgV0C4a1QPpHIx4m7SaSQfCvT
	qLFG7ukOKMeCYsgh/8q4sY8LfAW0w2C2ewS0CrUCm02S3neTVYEy4GwpwYplIVHJsAMg+R1ECVL
	inkrwsywtGLpfE0tf4yTncYsTUaUs0lJX3GLSkxPkawnHEY5aXIy3NT4DpxhKdsmAeZtd4NpP2/
	u2Dpmpp7tLEz7i76zPjj9HT+IKGj3nMp6xJ+zawNBV+OJVrTHWeG/m1ksOJQBuPvM1y854=
X-Received: by 2002:a05:6512:31d0:b0:5b4:ab3a:8305 with SMTP id 2adb3069b0e04-5b5e63db7d3mr849136e87.11.1787895630494;
        Thu, 27 Aug 2026 22:40:30 -0700 (PDT)
Received: from archlinux ([94.180.48.0])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b5e8a1a8edsm166172e87.79.2026.08.27.22.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 22:40:30 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v7 0/3] wifi: rtw88: rtw8822c: refactor DAC IQ calibration to s32
Date: Fri, 28 Aug 2026 12:40:20 +0700
Message-ID: <cover.1787895379.git.ulijg308@gmail.com>
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

 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 160 ++++++------------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |   3 +
 2 files changed, 54 insertions(+), 109 deletions(-)

-- 
2.55.0

