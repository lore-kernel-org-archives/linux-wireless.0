Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24BE3438A7
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786772132; cv=none; b=Ms0xtkj4izQXz5JD/ZYPJuCPYFlfT8+kLgmjGal7ooqSMAUvPZbAXO0DNupw8RqtxDydnd9JM/k7cqWQ+2LPhEjg799DC2pkwNC/hfm+jbivEaxXKY11uMYjQqRQxvpBR5u7/xi9NwxaPVMQ25pYoJwgX1sDGA8JxkU4DKuoegY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786772132; c=relaxed/simple;
	bh=HPjvee4tWjdNfjrS8b48i0A+diT0QeGe2s0ssvlK6O4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kDoBRo+7xm4zpScpHdZePVEvJQl+aqJ6cqM+atzQJ3OdJilA5yI2BuQJqDiTCPIM5Wb5UmMYESgXcEh/gmxIKq9t01T+cQZhtBlfVX29JY0GSHNUv9NRD7XrPfZ/QJyv0iJIDS/SM8lO53x236z6ae4pUHjsCgAHGniWlPjMmxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V3xMcaD9; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V3xMcaD9"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b0148201fbso1528627e87.3
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 22:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786772125; x=1787376925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lOfR4Pe/uKrMH/SqExULCOZ9If7xjyi11dlJoIyDO1k=;
        b=V3xMcaD9t7fwrCarhB8H2KGtUFy1m57hftzKNRHua3cF7JLTbCGJJRM8fEvlqQXT1m
         ObOoZ8E+GTWmf1XAb5ze3wMkoUhsqyfn3qwgf6cmvUY3sWonzJaOnXiphOU1O+zTq/MD
         9L52NyqDaLSiKri2Jos8ic8wQ0xOJ2M47NQgv9L2Q50FlhGBk+8vldYOgSY2A3a7sAvK
         6uCha8FBQifKeyQcVs+qL/s1KG//mlEjdUf8zT/wcW09oKq9b6tx4KrqMStQTNOBrEKC
         dUsY5WyzUND0hgxrBm0S4OLDwmxmR+T1dCOeKwfGtaEsQY9+/zlA/+ffMOoAdpy35imw
         Kj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786772125; x=1787376925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lOfR4Pe/uKrMH/SqExULCOZ9If7xjyi11dlJoIyDO1k=;
        b=Cu+m5PoLlHc619OkTPRM4efwkNItxsps+50FMTnmId2U3YvDRUbW24txkHtKWyu9Zu
         KCOCqKFXR57nRUC8la/7d5LqBGCEPccs4ZJWw3JntmoDd3veYoncynBg0rMqJelmIREh
         CbKRDbOJIWDDQGneYNMLk4nIqxpNgJw98xxCEKA0IZxxH9UQ83uLLfhtZ8akRRttkj/L
         6H/Zl+BstLUjtC0VjDLzLkJ/fC+SqMz0I4ru3vjZzVN54J8miJMuVowZ3tyikAtrYUJx
         bKdqeO+v/A17kO5QA594PDqH0iextek1qlM1RLeXxkO7+1xK2H7GULeLO8vZPmCrZTDT
         4oZg==
X-Gm-Message-State: AOJu0YyxP65yvk9dLb2404ldItwfdTRBMrVaKzOAM4Aq9BEegdjnkqyz
	warfsxoxDYUTHrD7Mm3JMvEXe46/FPDaHJFsdMGX3ZZ28LjWrXT1FavbPlK53Qmd
X-Gm-Gg: AR+sD10fQHOaLHZoe8wsDwvQkbE0RME9bl4DQlJDj1huIkzaC9wUXGGDLXv2qumKwFH
	FvTb3zsTJl+mz8Bfd7rnYZBgqo8tyhSHG+E452bJgqZFRZhpHLAa5dttFw3N+TcV+vxwEfIfMV0
	1Ct/kKtz9W2zIrVnfnD5Fn+tLlwKVuOgT0CJ4x1ZhGkOpZ02ql45zy4BrRbTmsGu3oObhwSWH3z
	vjnedp/PlTN7CqNrh1s1bwvuZLEMz8oKSa7mMst5bttuabSUBJZVxuUQDmNocykrEUjcMtus8Lw
	Vo8anedoG0+mwRto7Cf/S73e3hWqXm51L6/ZjAHtcdyOduqyFITHSytzzUc6nwdujT/aAg+d6c3
	UD4uJ3dLhI8rfEr8rwDRbsAI7v5RHzPwL0ChYw7axm4T2/qFg1AJF4jB/ulKlX+gF5QTBCkbMZy
	eCttKPYiT882N1FOdvj9eg6WTsOeFzbJHG04TevjLU/Or/EXCCH/Fo8orZ50lGwFHnKP/Sq+tcW
	+L/YIYJ0qza87PJofndFFUFmA7/Vev+EcYSIDddZLO6cv1LLvAqzR7bKABuwQ==
X-Received: by 2002:a05:6512:1294:b0:5ae:b259:75a1 with SMTP id 2adb3069b0e04-5b4591173a3mr1629900e87.12.1786772124530;
        Fri, 14 Aug 2026 22:35:24 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458c0a033sm932577e87.67.2026.08.14.22.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:35:24 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v4 0/3] wifi: rtw88: rtw8822c: refactor DAC IQ calibration to s32
Date: Sat, 15 Aug 2026 12:35:16 +0700
Message-ID: <cover.1786771562.git.ulijg308@gmail.com>
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
- Every patch in the series was verified with scripts/checkpatch.pl
  and yielded 0 errors and 0 warnings.
- Each patch was sequentially built (bisected and compiled) to ensure
  there are no compiler warnings, pointer type mismatches, or broken
  builds at any intermediate step.
---
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
  fi: rtw88: rtw8822c: Convert DAC IQ calibration path to signed math
  wifi: rtw88: rtw8822c: Replace custom DAC IQ sorting with kernel sort

 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 151 +++++-------------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |   3 +
 2 files changed, 47 insertions(+), 107 deletions(-)

-- 
2.55.0

