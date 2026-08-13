Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6572341BA7A
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 06:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786603972; cv=none; b=XfKMTPfnK10twNWL+VI8NpZUykmzYCL3QrkbjF7QsHke9lifPp4/B9waTimzDKTwpvo7PVUb/4QzvwzylCbJnCRQe/amLuK9SHZ0xE51SOKucMQHwPuB6SNkzwEUSul+bRaNuCxXLc7OAr8NlxFIc4ziZTA0O2zhNPb2/SrpLs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786603972; c=relaxed/simple;
	bh=Sk99J0H/Z9nrU3stku+BhkRc1rZCLnM0D8arqBxdvM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fIJLiNQ+YyhYQFO7b0UyRJZGD6am0HLNp7wdE/CbYkzf3cHW4t2hucWLevXSJe7OWVD7I1iJWrGn4G2NM5WRIsVFr9MA0s/3xB25C93HHJzNZBwIkiwQY7fErRLsi1nizuIcAV/YmbdX3igDWf3nH7LxD7NYkLxHXYt3tDcqe2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E0pZG601; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E0pZG601"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b2a4359d16so380390e87.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 23:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786603968; x=1787208768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w5MJXBWLUZITB4uTg9L/4D9nTZBNcUiWYYsAhymg8X8=;
        b=E0pZG601oSSliLe0CElLEND+lC5+puUIFIwTn0hpwyKwsHVWRUYWw2zcjRv9JQNosH
         n//bJRy65ClTMP1QztoR9TJpwd8gaDjs6J7WL98G1TAVvzeHDWxjH8GChn+9LLuIKpII
         YgKW4IEend8lGYqQOdxdKMfsPZ3vffDsoS/J54MaKjZmK6JN8yknvQpKnTnG1f0g0tfY
         ZSv+iIgUL0OZbeRgL5NHHi4tC+CuMEbYQXQ2iSqL5nwO7iDzyViN/fX7tHyG8LbtJrfO
         SyuuXg4rnZMLEYHV8nYa/ZWv3qQdYos7F04P1oPt7IgmioD3WCleWPYukkTsRcc3LBBM
         vx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786603968; x=1787208768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w5MJXBWLUZITB4uTg9L/4D9nTZBNcUiWYYsAhymg8X8=;
        b=TZj23NVMUHlHkgmxLJK3WnXgjD45e4AVj8y8MldTAX+bVIrIECECNKY94X5+Cjbxqc
         7LHLP/T2Or2ZnMBwMWGFMSf4FA+AT0BDkyFvEpsZKSVo7GIl3TQI/0NeC19SlCunOyZ6
         DE2XN5m3UPngzvGOZaulY9HcRc1rsJyH+vwgxGHymkydRx0R9Jj48yKAX8X1Vxo9Otuc
         89rosAZ+E5a21n/jmZirrS5hE+W7aUJPlMVO/AqXzMiXJD2N/WqfHHIid3gOzC5Nx8Qp
         Y3vbgrxpCleaq9rdWO03midH+tW9K+L8/oGONxnIT8MMTE1y9jTgHmd8QbI7ht97iTma
         lkZA==
X-Gm-Message-State: AOJu0Yztjgqxqk0sHoZ+H8spgUjfx0+yL7E4fyhSdznozk9jLa25j1A7
	uunvzW5ryYLOg5bXQlNy501dT7md923WMJosna3c//xzhavMi06RboVX
X-Gm-Gg: AR+sD11XyUKnDjLxXFGghIaFP2NPUt/LIowcYUZr6TrxRIMndazFk1XBVBbESjcPGUR
	lk5z6/xCjcmsr666GTYaAA9cO+6bKIOXHQkM9nuLDvWWSErDO6s5Q7/d7oNSuCuyfNrxI6M8q0S
	laMnSUGrg8e8c3uw1cnASt3s5GRZiXNMmGbU1jVh8mYI8a6FOLzvsNStrdtwBp+G3jOuWlMH+hc
	kj3fYNoDCnAXFw9tTeHlpHsGG2yoJnd7p8/0Lf2JOdVXoszWMkvEe9CeAyWdN6JGMJRsfBNxAjk
	oz0rW1GA71ct2lGDDYVUr+EK7JgoD8eCmdpMJxPXpNZ4pmG8cdoS1+a5xUdeXgnIdilKeuVd3Sz
	gXXiTLEqjqVX3he6F3qc6UuMm/kAQeoEdzCahsK1EoWIWw+9JICxyNJgqwshxvzqm/al7riiZNV
	xsYJXe2A/FXZE3fH1TzWcQE0FlgMFLPpYA88MP1VKKoR8aX3OlL/4anRcaw768mGTJub8iY5isw
	7uPmFLTp5YqLA439sb1roJK1cWNkfWyOjdg5FnwZsJNi0xNpVcPrnToTLyw9g==
X-Received: by 2002:a05:6512:1096:b0:5b0:22a6:6b13 with SMTP id 2adb3069b0e04-5b453cfb311mr484198e87.0.1786603968024;
        Wed, 12 Aug 2026 23:52:48 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b453a54adasm270076e87.38.2026.08.12.23.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:52:47 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH rtw-next v3 0/4] wifi: rtw88: rtw8822c: refactor DAC IQ calibration to s32
Date: Thu, 13 Aug 2026 13:52:31 +0700
Message-ID: <cover.1786603749.git.ulijg308@gmail.com>
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
Changes in v3:
 - Corrected the subject prefix target tree from wireless-next to rtw-next 
   as requested by the maintainer.
   
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

