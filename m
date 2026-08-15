Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB342D594F
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 09:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786786773; cv=none; b=Mna/yesTlH2ojp67j/rEjOMBB0D5COoppdszK8BYR5aK1qTKGeRJKr8Z32S+tJZIO97wJUiwIbvRj9Jh1au3K4dcYN2fz4e7cnD24q4m4n+D7HDIBLh3usmwJLu8jjP6E8XNI64ARp6tI8/sl3zE8zLujR+M2GRSa5XLanJNgNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786786773; c=relaxed/simple;
	bh=CI0QIMmHQhXYmipUnZ4obBPXirDkukhV2/mM2zGuyOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eV8uaKdzUG6fd6BlfrJSpX8b7Gel0DeliKEWGewH8In5F4ETfQLlU9tBzPktARvrNZH3Hfw6qdvEHTLw1R2wC6ffBC8F6YRiusu8HTHZNTHeciqpGv7eplMZq1+mPNecvDt6iJNN7YOHWonKMZtEQg0HQ4ytEUn7XARtGjPw4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QpA0c7vE; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QpA0c7vE"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b021916bd3so2362707e87.3
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 02:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786786770; x=1787391570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wu3vmS60bFGjaB0EqV/uEdj+HM7TnRWaMX7yzwT7SDM=;
        b=QpA0c7vEMbxSAbFkXNQQqFRlBOxvnQvPvmYKYJhch+XkXXfhl7TzuZBfGv87KN7ouq
         JIb6KpRU7Iq/pjT2VrTttMq5wUo4IoqtwIgzA2ZbbHXRPiYZno8WGTo/l6t7qdXdEnI8
         pRnz4ahAFGRXFNH7XYvLFOn1Iyk07m+lguWo02cSpt8mp49YIR44Dis0ebKw08ccZseF
         QtuDY6uFdZ3DQorr8mKw9B1PVIGp2IuJVYXrRmYqiUl81byGr6XFj+oGOV/CdY75A83/
         rkraOM8BafCANzVbEJTvwWY37ltDdHJghqQBbZI4hZS0GNOqaYmAqwZ0Zrqftp6gUQtj
         mQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786786770; x=1787391570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wu3vmS60bFGjaB0EqV/uEdj+HM7TnRWaMX7yzwT7SDM=;
        b=EFjaueoUc3XCcc95SNrUxOtgcuk3lc6572FUEfrPk9kUzL0JDWUhbJTXQLWt9vJq0C
         w1fD7lLPuHFhS93TiBRuDeT49ZUfOJJIHcfKZQSfdLDtKvgeVquhLPU6QEXHnr1C8nFd
         2EzTXNV0ulEssRAJIYbZg/JhfPDivIaHw7qL0nst3uZagSi2/D1Locq6juV3vPNeYbYA
         kBWHPheJta/PPvPt33yes4jZ/d34Fu7sHMU545uT6Lh4xWSoKgtX5y5BRe9dNl0oAYyw
         WtIUn6M3VoLX4ZqyIXXg1y+rPPR4rSduoyrv5NmJlSSBCy7gvdPMwGyhmNBpApa558kN
         jK6A==
X-Gm-Message-State: AOJu0YwvIo3J27KD4/JwaUQqvCOU6GbTt3be/TVZJyPcH9Xrz2bLohme
	bJorSM/BNzoP1gh0xXG8guAGRiiNAFhf6VCnMQm2uDIhnItnrRxj8ybX
X-Gm-Gg: AR+sD11xgSQN8XEBA+D5Xqf5ZvUOFaKoNS80Rp1/Ha+9CtQAr6eKHIwSfXfz/4jqI7e
	ha1xAIbOZ6tedXD8hZwK8OQWO3z8CPi3eEwDmUxdtbGIjuv7hYM7DC6siqKWxxE8d9XutT2L/Lk
	hGOSGJNUOztGOKtuLO3Hfr0WKd9Nu5audjRA//RDNr91FoNlvYHhHteEV5nCMkztil2IDKkBYVz
	uQs/Y7t2O110c8amaiqjsbfcdcOnQ6E217Bu+KyPcChauO5bOPYEAYp/EtglQfu5v438yh8gr/q
	hoH2H77twoDEF9myYBl+aYGHiORVyw5AcE5TloFw9d3py6jJbU5RpsFND69P4WvuUx4bIXOHTdt
	HJVbb+g4B1bYMkpj4XmVrbyFoeGQBXkQrwSLMbpElttGhm7yf8fxEB9PH/acDY+f3t+tpM5zzYo
	EjJwhcPHBAszo/lA20r1boY0NAVU/uOe3gHiLHQ51gwM509B2Hmi64GwO9pyRw7EggyVxuHZAxq
	QOXqhF5XgPj1i26ayqhMDGx46N8C5Brl26FJd2HdFt3cFdeSogCMbEdt77Jp34ziWDIGEQK
X-Received: by 2002:a05:6512:8344:b0:5b0:1b78:495d with SMTP id 2adb3069b0e04-5b459118b21mr1156022e87.24.1786786769962;
        Sat, 15 Aug 2026 02:39:29 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bedf9fsm1040316e87.46.2026.08.15.02.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 02:39:29 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v6 0/3] wifi: rtw88: rtw8822c: refactor DAC IQ calibration to s32
Date: Sat, 15 Aug 2026 16:39:21 +0700
Message-ID: <cover.1786784750.git.ulijg308@gmail.com>
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

 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 155 ++++++------------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |   3 +
 2 files changed, 49 insertions(+), 109 deletions(-)

-- 
2.55.0

