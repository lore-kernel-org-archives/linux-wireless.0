Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E8936D9F9
	for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2026 04:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777525087; cv=none; b=XLQrOJqiMQAvW8vBtYzOvfZB11IoKjj80Ze22UNSYC4ZG5xdnd/yi63yfROPUuRTAuM8nsLpu5M9V3n7uiZ6ge7NXbI4GOOA+4w5oUHZZw+kAlNyFGhJx7YTETaiyq4PBSdhNBsD6xj7QMLQd84lF2VZR77GpThgsIW38E3qaeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777525087; c=relaxed/simple;
	bh=sZ5db9OMzu/ERL36zpv765dLG+X6FCJubt1KSBYE+BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdLT2bYgLPygxa7xpdpGbU+O4HD3sa1NNNxClWwIlJiXr511+IfCHnGMrN92f+goI0pas12S1Hrszwvg0FAl7yaUVMS7ysUFEWzM/CeU6OuX2r9gXBOaCjWj/UVMEOAqOvCcoaVbiu3n33mr6p3hiMrDNW1L6cYo+Q1klUy+IrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=OJSHrVIC; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="OJSHrVIC"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82f33d28c1dso300717b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 21:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1777525086; x=1778129886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=St8ASszBJPPTeFlVArhOrj/dEVW+6LWXmvw38LqMsEA=;
        b=OJSHrVICaaujpd4m3aXuUeddsMLBwVtwG+ZktfMdX5pTs4eSR0Akrv0t89he+VQ3JU
         Wa2ltLSjQE+QbTG6v1g7gjF4SpWbh3DOeGw3J2zcOyhAjgGoSgRToEcgZOfR7a5VqvKm
         E05tE0csXnJ331W0Vf2VLSHdKjYLw5VVn9byNvXQaFPyTjvvrov9RWyw96A81hBs8gu3
         F3iFrDboS+fL6Cqh/OinuT9QzXMRLf6zMHPD0J+fppR/FisgkMBNKnatBbyor+JnR02l
         RLpI1WvDjwz5I8X3sBQ0lPd2nvNCVqrSIkd5+mLtqdm2alfl7/6yUsHoHGcCdrK1QHV0
         g9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777525086; x=1778129886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=St8ASszBJPPTeFlVArhOrj/dEVW+6LWXmvw38LqMsEA=;
        b=seZLXgSmfW16Ji0EdpuBNRZS88W4zBKCDZ5+vk3Zsnaym3MSCKn4emx99k4suR+E3f
         SF/mBG8Or45f2YZuydMYds2AGahT6pi0QckKDJbxTL6j/QQN6UuD9+YnbGrGZsblHYO+
         rxVFYSVQ6dwkq+v+zfYWnMmxEM+1EeBktkCNIy6aMmLg5Hs9hqLm6eoUSKqK7r8PqkKU
         57NI4m+52bLna4HkeY0IQ/cYz7ogIh7JExnFuOLnx6DK6ARvmGv6bnMjAAGlhqZarfIY
         ACln9P87TYeXU2VuTrczT0J/rtRHewrXCWk8F31caAnx+vq1PHTaCh3fN0oIuSdjHV6c
         MhMQ==
X-Forwarded-Encrypted: i=1; AFNElJ9VcM4DsI22YJy0T+gZENkZdTb9WV0gBOkmxFU0PUWp+cdp8uu5JmC2By8cMkCICsgs9iULlRTT6zJRn7prXA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKTspbFJYPcv5ytefo4uQL8nLHdxdyLRvmbWBQ8Jma6No8h8w+
	dtqXRlI4vKfQD/M6QwewuyNdsvv13hfrE41RLpE/i64hWImB1GtPxHSH6NYAaNAD9rA=
X-Gm-Gg: AeBDieu5BQo/L5erF4rMbGjQYNXyrA/cxAHOyvQXex3PId6RpirEWjH82CIUXtzhpEP
	y5s+dpOMsV4JSrC83mCDD2rH4M4pKvm/BrSJXCqEIjOTWYdqHSn03Vdx1l1hcM1ss+mPNvO03RM
	fs7lPw+l4iOb0Qy2prKsbSP5KTzuRYhcLek8z1lGmYt7CRw9S0/yWKXADqA/Iw6fjHJZpLZF/uB
	QbGzGATHHl8TRd/J9p16S4DP2mYH5JWymB951bGfSnLtu/7mRcHeJ+Quecd9nvVYwT1fNAXq4qM
	MwofF0KTawkjukuDWHM7QZqogQWksZV+0ugu4t/q8qYenUphPw06lPstfXSpVzt8bFyn0DnCU4m
	jLs4+TDQjGR9nHO8WPGPPyzzp87SOOVynFVz5EUdKrQjMmpCXOmxKcYD+5/AiQ7mofo/Y1oYAiP
	LCOERm8dPPz7TzmMDcQ4/87gR0BBPL8blAaP12+UeKcMb+WMJxXG0EGQKC1QaXUYnz5tRux9g+4
	0VHnuEuGmA1oiTAq+l6jA5Ds8fTv2HwRYqYtkv0Yg==
X-Received: by 2002:a05:6a00:2d85:b0:82f:3828:a019 with SMTP id d2e1a72fcca58-834fdd6a1efmr1625723b3a.46.1777525086006;
        Wed, 29 Apr 2026 21:58:06 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed80df96sm3595073b3a.54.2026.04.29.21.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 21:58:05 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>
Cc: ayman.grais@morsemicro.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2 17/31] wifi: mm81x: add ps.h
Date: Thu, 30 Apr 2026 14:55:43 +1000
Message-ID: <20260430045615.334669-18-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260430045615.334669-1-lachlan.hodges@morsemicro.com>
References: <20260430045615.334669-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(Patches split per file for review, will be a single commit alongside
SDIO ids once review is complete. See cover letter for more
information)

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/ps.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/ps.h

diff --git a/drivers/net/wireless/morsemicro/mm81x/ps.h b/drivers/net/wireless/morsemicro/mm81x/ps.h
new file mode 100644
index 000000000000..0b59bb4145ab
--- /dev/null
+++ b/drivers/net/wireless/morsemicro/mm81x/ps.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2017-2026 Morse Micro
+ */
+
+#ifndef _MM81X_PS_H_
+#define _MM81X_PS_H_
+
+#include "core.h"
+
+/* This should be nominally <= the dynamic ps timeout */
+#define NETWORK_BUS_TIMEOUT_MS (90)
+
+/* The default period of time to wait to re-evaluate powersave */
+#define DEFAULT_BUS_TIMEOUT_MS (50)
+
+void mm81x_ps_disable(struct mm81x *mors);
+void mm81x_ps_enable(struct mm81x *mors);
+int mm81x_ps_init(struct mm81x *mors);
+void mm81x_ps_finish(struct mm81x *mors);
+
+#endif /* !_MM81X_PS_H_ */
-- 
2.43.0

