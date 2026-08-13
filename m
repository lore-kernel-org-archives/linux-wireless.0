Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E97411F9E
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 05:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600082; cv=none; b=OV4s9ce3xKirkvIAoRLgCOTgsFfSc0jiaU3B8GScSKq5f7UbqJYmoYe2KGnqN3fIc/pIZhf/TyyYGV+Z7IV1U2lA9mDaD1ADFMTN/Ik09Lmk6z40qQOafNfYwuF07aIbHvMf7swFX3kAPOSF7/S4lDrGtFg1tbeb5BV8NGiZE/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600082; c=relaxed/simple;
	bh=xAEbD1qhX+UvLXGCrYAzN4WGxa/j+VC7rd9ZlcKDthY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IDoq/ADuQhMRfPrBFfLSiHlOw+kxZtb1eAMu9XliwMgS/SmBqvMgjB86eKrfR08gvcF8nV5+s5SrIV8tBR1b2ABTntIo7cVDrGxYsIwW2PbnwuoT4GwjIvn8tbL/FgB2GLY09YAJMYolzF7ueSd/NqWJzUgmyuKXzF3iF3bl/Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/YfBTXN; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/YfBTXN"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b0148201fbso1372049e87.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 22:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786600077; x=1787204877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=954OfKO082wPfZzLkeOGkJjs4WOkgCE1FxraJdt3gDU=;
        b=j/YfBTXN/6GcHUkv+gofsiYgpQKFLk5p1U1sGNmjg58f9TFPOktZWrBBAha1giUSxx
         n6GdGdLMs8C5C8JF+CZKfgBZ5qwMlGg/3dmbj5fYs2McdlmEKHRw4qQSSWLvpSJegqkN
         DtzR4vxQmmdXII4PC8ZVEsSidozGtrTdD2WhBdj4R4qroljs7r9h7zWXLMCmxO6xmg5P
         S6RCS7MV+c4MXPwSStCJpXr932VgQIIgaLQbQ+4Nic2eoXS+m6vIw5AlMfikQLr9aDTy
         GElHwqew56N1/5ULgtIuYEEUcf57ibpPjflu0bNDHVnS2FR5yWvVLB2E5U2jEV+tftUB
         4nkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786600077; x=1787204877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=954OfKO082wPfZzLkeOGkJjs4WOkgCE1FxraJdt3gDU=;
        b=Ne6l+VmFNvI4xin7+k7K3ZfYfxBOYZyiyuSvogVWma7EzXBp9/KDJJsTaWvjJvCmns
         7BimSzmcJV/5L7/5KtKw2Pl175F9zHIT/RFyCqLt7CAKIFZZ93wHj+Kf5ccbaGXJ3PGZ
         5u/XZQ3e5MzxnseEIx7EQA6LNS3M8tWlmUmsxb7augq8/9GCcDbCFT/7aXpCcEtNxhUL
         nbqZws/yDbYB7kO/J+pHuuvvD2hN4bH10th8vviqzZDUGwnhDvzjxAVqEyXZPaOkRF7l
         n1EY/tgdaozlK70cFSbXgNVuE5FH1dA1mUQAonNsnaVsC7bmPa1hYxOC+1n3dicDtEq0
         Lz7g==
X-Gm-Message-State: AOJu0YzhT2RAILxoKn9zo1QMaImgRzbVoaA1QFKUm5dtuzr9YbKrtUb7
	yuw99+rersdsjBzsuls7sNeMg+eNRi4Wl+18fHdZL6LkmgAoyRx8TiyC9jnFsrQu
X-Gm-Gg: AR+sD13Yd77t3mrJGNYQBviRjJwa/RQMgbTTbjnvS17VIQPn5rxlb+lU7JvmTPomS38
	+SMVdKWml6yLlu4SNgf3AxDhE0s/0NL9NsQvIJbrOUJOkueIRbka0bBqt0QbcdgUzL15yYG4232
	+JMB6s9qVexIVV5mDUs6q9S7f1YDn3I/7t1/mYixAPB4YHXMnUne9FnZ7IKRiFdFVtnuRCk/fTY
	sVnm73dSgU5XSwYXkPgWIWLeZp0Mec9eJ5UuEZCW6fIhzjmg87c7HlXrO3HxJGTxsAufGH1QDe1
	+TpaJ+vsYERTkG/ARGXk8pjOfBnpXFoVaK+w6XrJRwL8eOWreWt7wYcFCCVZl1oMUbGEZ9/TYwK
	wWZ/x8LjBK5YdNTK0NxtAa6nU0ca/ebLyM+KriKQC3SZ3uegckB6tQZ/738j1/o+RBKDj2mlSKs
	tMvLYgFXP4+jUccKY8bOClu9EapuUdA7pTZlpq51fr2t1HYwFVaNPIJ1CK0AYAsPvr6hrS2lsRY
	feDu3CD8rYkztGpq4bsX1CyHjmj6iEGlHLuDJd2DV97I1MCGmVZ6vYMmcrRZw==
X-Received: by 2002:ac2:4469:0:b0:5b2:dba5:806f with SMTP id 2adb3069b0e04-5b453f6fe2amr279135e87.31.1786600077252;
        Wed, 12 Aug 2026 22:47:57 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b4539e9673sm252483e87.23.2026.08.12.22.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 22:47:56 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH wireless-next v2 0/4] wifi: rtw88: rtw8822c: refactor DAC IQ calibration to s32
Date: Thu, 13 Aug 2026 12:47:28 +0700
Message-ID: <cover.1786599645.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series refactors the Digital-to-Analog Converter (DAC) IQ 
calibration routines in the rtw8822c driver. 

The original code heavily relies on unsigned 32-bit math mapped over
a 10-bit circular hardware register scale centered around 0x200. This 
introduces complex nested boundary checks, custom bubble sort rules,
and custom min/max tracking helpers.

By migrating the temporary stack arrays and signatures to signed s32
and utilizing the kernel's sign_extend32() API, the coordination system 
is linearized. This allows the removal of internal custom helpers and 
collapses unsigned wrap-around logic into standard linear operations.

The series is broken down as follows:
Patch 1: Prepares signatures and stack buffers, converting types to s32.
Patch 2: Introduces sign_extend32() and simplifies the validation window.
Patch 3: Replaces custom bubble sort with the kernel's native sort().
Patch 4: Eliminates minmax_cmp, streamlining search and offset loops.

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
Changes in v2:
 - Fixed missing target tree name in the subject prefix (switched to wireless-next).

Arsenii Pashchenko (4):
  wifi: rtw88: rtw8822c: convert DAC IQ buffers and signatures to s32
  wifi: rtw88: rtw8822c: use sign_extend32 for DAC IQ validation
  wifi: rtw88: rtw8822c: switch to the kernel's sort() library
  wifi: rtw88: rtw8822c: simplify amplitude search and offset via s32

 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 146 ++++++------------
 1 file changed, 43 insertions(+), 103 deletions(-)

-- 
2.55.0

