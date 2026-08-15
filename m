Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F2E1BC08F
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 05:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786772804; cv=none; b=oUQ0YgZAOzsgoFeuJsRT21tK4enL3mIVzCJ3RnfxQ0IawuZ0mH41yOzHmuGMURUSi3HQvBIKJImC30x7q8TLx6c3n59S4+RcAry86Oe9ngHyDcuwsUQJMX0cHYqo/SgLy9p3GryQc5pek0N8xQZlzGaW2ZcYFT0Wiw9GQ7+6/jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786772804; c=relaxed/simple;
	bh=UZydWhieuZfX6HJyIP5HEC62kZX3uQrbt57ATZdDl6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FYvV2FA4N9pMmnrIV0pvWshzdCQ2bPAZXRj1FzQE7m0tpkfzH/OdmzgQoGWDZhNS6WvwQejJOO7+2ZA3zG2Qee4VDvXFC7PlOJLOKHDHPmGnoYRFiqS3PtSl+EPC/1LoDJW2Q/VRoMPmueZZRNGi5Ki+GL0W1aPM01PNxG+n1AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VzQbh+7p; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VzQbh+7p"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aeb2bc82ccso1994332e87.2
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 22:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786772801; x=1787377601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vaUjVYA4Mz8er7Ul0quD61wBLUzHk1GEuAFgBoYaZD8=;
        b=VzQbh+7pogN1OyGVTTsdvIS4yH2F+tGpuH9udfJVpNHKU5G5Eh8h34SrfqO42oLZP7
         hw95VsrAC/dvGKKxJHYt1aXkPJ58LZ/IPh1VniKc/qruJQf3XPJRh+xezWUC3E1H/0cr
         1378H8uwpABsBciMtDbiFnB5N1w9oi05kt2O0QtfBhfLm0PMSXoZknhn28dtatKHFhHp
         6lvw3d7qHBBxGn4Y1wFOFw97a00svFF5//XzvoG9I7SRbuvumQMurb1nUAHbogvY1PnY
         Cs/y5uBp+O5i3ioztA43ACHIyTEcOWlySMOnviw/24EtV3kaoVBWTdbY6yg+LobZFbtB
         Exxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786772801; x=1787377601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vaUjVYA4Mz8er7Ul0quD61wBLUzHk1GEuAFgBoYaZD8=;
        b=AbXCaasOxvfDwa57Je+mV594/e9xCBwntcF+jZr4iwvtV5jhhmtZjpzlOk7s+VA9Um
         N2pMncM47v8JIVlvMqAUIAcuaSETTlp/SFPVJICkGBluU6rb2xlt7TkuMbbT6VIb1Wik
         prTEIKTVjPMfshAoXT8NYKk6aDEm6QCRris+fXUbN0IhsRzE8MPxNhRMSz+4BGvWFZ7K
         ZhkAUQstHsPkISFK4B+i89KVt268qV2uj+C8J+h8XNbQVyMIecUYVlvHM+xYw3unip1g
         C5f3+NLnEC708ui5ch2ril2i2zhvYlFwwbPJVWDOJmZ7jeim7o8elsw1SMKiwgIL/ysr
         qnjg==
X-Gm-Message-State: AOJu0YxF0FfiniA6cg79We50w7M8OI1i4Yfxxd688pjqrNTIbqrDjlUV
	qYY12ykvuw+aUaKPf+Y/lhT2HnPK07dhM5w97gyqdNJMR1eba8N19pGU
X-Gm-Gg: AR+sD10o6VguleeBcayv4Z5q+eF3iNdl3Fo2ROcKlQfi3eYG1FV5DluF7tyAmbJ+Sx6
	f8PVEG++gO270a3ek1sv/+M+AYz3pzaSqIE8SbZRm9i7Yll5mDjHBmzqEPMdxjt/5gmuhweS13J
	rw+4ojAT8B6FHb/pbEjiQDeIragf5Ib/D/2P0hvMIurxrsUrYbSnYxx6fddWoUClp6xpmpP7dIl
	wXkB4x6kCDKds8WmbcJ40bixFP3E0w6g/J1E5SuRD6SnIPLMOwn+zLRRKdxG/gkWe/jyy0kezG4
	8IjXBUfg/pO16l7b0C1URVa5qvB4R09NXKPKgO0WwvD7AVOkFr+KYGuDaDpwtO3M4+usxAqgMjS
	8UNf7FnQxsjhCr+IbdCTSwoxiZnhCWErmEUZY+lTBXmVkB00Lw5a69u36rF0XD69k5+PVbXissi
	3a6D0MIqO/chJjWDdDDqxK5XqK9uF8vo5671Hm/1pYFoUxFh7XS3L8uc/cnOs3m/wMCK1m2Db6s
	Sso0xMa3N8s2W4rlZAN1klJPrB06ZNimp8Xi+rQfA9HgbmHerSNEPfBzV7K4Q==
X-Received: by 2002:a05:6512:a82:b0:5b0:12e1:486c with SMTP id 2adb3069b0e04-5b4591206a1mr1629233e87.24.1786772800985;
        Fri, 14 Aug 2026 22:46:40 -0700 (PDT)
Received: from archlinux ([94.180.44.22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bed96esm967527e87.40.2026.08.14.22.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:46:38 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v5 0/3] wifi: rtw88: rtw8822c: refactor DAC IQ calibration to s32
Date: Sat, 15 Aug 2026 12:46:31 +0700
Message-ID: <cover.1786771562.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20260815054631.NPhw16LlL1yAeaNNGaod2XiwUAn4idCLGnvPAe4Ib_s@z>

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
  fi: rtw88: rtw8822c: Convert DAC IQ calibration path to signed math
  wifi: rtw88: rtw8822c: Replace custom DAC IQ sorting with kernel sort

 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 151 +++++-------------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |   3 +
 2 files changed, 47 insertions(+), 107 deletions(-)

-- 
2.55.0

