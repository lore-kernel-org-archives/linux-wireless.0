Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D3D3DDDD0
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 06:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782455621; cv=none; b=XFCWpFAkZEcrlnAAtdcP5bL9ZoVCfyczFZp5AsZhbis+VBpo8x5oiwO1L+l8fripYiJiuZVAc/7Xu/M8kalTNG6xkUWPdm+SD6qymQ5JWWf2weFQTnxTrwCUVsfdMFDBNgMm6RphN4iSIsWP/nwpo0aZhzB/yuqaeR3MDAwFtCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782455621; c=relaxed/simple;
	bh=3c4dZfH81P/O8rSIy/ifesCYtlRl1hB9+2QlOhMSoSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeQhr6Ox41LI2Q3T7bSKEiU99Ir9DC5n1ect0NG4ijkPehZm4/tJ8KD6LVP//zm606b1qvXKQBp8LYyKCbB9YzE5xWlH7nlsTdGgB5ARRREoJ2Di9kaWFrVwI1S5fa2vcsTpVzlwVQqnTnxiO5DqTd2jA/aJyJJM7jUJ4Ubtl+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=HKTsDoCk; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="HKTsDoCk"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-30bc871ecdfso848517eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 23:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1782455619; x=1783060419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8Mil24BTkKQ11Y7yk4p0FHOHJdUxkQjIzC/ehrGIXk=;
        b=HKTsDoCks2TkmU+J1uGUoVNJ5Jk2m6XIJJG5gE9xuXGL2Ks/n/ROHLdIgu/Nuoc9oX
         FKcj3UEZTHY0ajHn820vIjRwmyh8g5A00m3owAqRoEnqGZWF70LOudkDo/hvYLfRFtTN
         LRpecWIo5RxsWKj+7OvHsBMgDvBl5KpS1Owp6zILD5iuA+bhm6JqST+mTbIT0Cm9wJud
         Ez3WEdYy2q7MPD+Qq1nZV0H15j7YwoE1U89zLvXjBjZ4/vxz2nN7j38ZNCdd8eCPzJ3y
         c+X4XYNTXw16DKeUNfYwIet51U6qPUgTpqoCM9nE/fZzyjHn5zEaP8jSJXYo+XALHO+L
         hyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782455619; x=1783060419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r8Mil24BTkKQ11Y7yk4p0FHOHJdUxkQjIzC/ehrGIXk=;
        b=ia+ffJgtd4htzLT4QkWSGJ1rOBlYQUKWk9GrWpT956EB9cIgfDsJkQOaehhSDonpfw
         CJmVH7ZjxPQumwj8LioI+UWpo/y8mgWab2HOBr4SPa7WaN7HGcwNIZA8pDWzX3NKKuw2
         QoAuuhtljHygTaZ0VkwXIp4uUQx/yrU8Xveb+LkyW3u1OkibnKOoexhWIdHDgENuqsLL
         0vHjsM5O8u9DOTVz81u70gPqcnuqY8JBTcplhymMUh7OJ32kbp2Wj1icHsKLnNCbOpoV
         c1P2vmzN8WGgfci329bOaHykijvvNKKbHPYt/HpMa99lxIbYsZK0C8IRT7OGcNLNcXpM
         E2Rg==
X-Forwarded-Encrypted: i=1; AHgh+Rpwokcyo/10jzDY4t0hb6pNq9kQC5IhXl4uS/B42ljwxCoqNx4FLls2s7fTx0kRKC1h0jcg3GvtQKRG8t9aAw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxP2ZlupjMLbV4wN1em8997pKp3qutTZtplFT1S5chUDjgNv+Ca
	VaF6rJb+SS2IhpKtzjDFONz8nRR23ZxQfHPZ8Y292/XcQpTklJK18Jd9t6a03tDqDvc=
X-Gm-Gg: AfdE7cm0kZgG46fHiOkRMnX155yrItNxfOvzZUoxggDfQ/VpN8dia21HZ0p5kcZS9YI
	P9ry8Kdsv62H8IUDnbQS5JI6r9J65TDVu+hW9DIXb5ttqYIQd093hqr9DDiZE1M1XhB0hJYvkhD
	2+NeP1w5yL8PKLxgtgCCJuUq4VtMqBS5AltM3WbxvHPjaqIwvN/r0V1cyFOQax0C9ISNkVm97mb
	V+eoOXuD12inv/9G8txA975iulmYWWJRG3KZVxaQKtN8+Oy4Wzcxndl3GEW91/+nl4q6g94sUG8
	ypSqOA8DEEUPQHKXfEPe6Oms/73Kc0W3QSQzq6B7ulUb0wZv5gboLrn7s72IKdSGg089X+eeLHo
	IoY7jglcS/sy+p6N8WhD/Fx+dPXXGiXy39fBHP5Bd4Nhvp0nMwG20fGebMMs/0EbkIlE0LZ42XL
	i/IuKdzaGKZ18fmT3bP+unEnNsf2yDpammUb2lX0SsswdH4RkTxidOZl5vrPlyFEZvr19YwaCAD
	pjOU7GHwNTczNg3hlov
X-Received: by 2002:a05:7300:f602:b0:304:d75b:f5df with SMTP id 5a478bee46e88-30c84eb7db9mr4596303eec.19.1782455618958;
        Thu, 25 Jun 2026 23:33:38 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d91006bcsm15463687c88.13.2026.06.25.23.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 23:33:38 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>
Cc: ayman.grais@morsemicro.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v3 31/33] wifi: mm81x: add yaps_hw.h
Date: Fri, 26 Jun 2026 16:29:27 +1000
Message-ID: <20260626063014.1275235-32-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260626063014.1275235-1-lachlan.hodges@morsemicro.com>
References: <20260626063014.1275235-1-lachlan.hodges@morsemicro.com>
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
 .../net/wireless/morsemicro/mm81x/yaps_hw.h   | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/yaps_hw.h

diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.h b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.h
new file mode 100644
index 000000000000..89e15375aabc
--- /dev/null
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2017-2026 Morse Micro
+ */
+
+#ifndef _MM81X_YAPS_HW_H_
+#define _MM81X_YAPS_HW_H_
+
+#include <linux/types.h>
+#include <linux/crc7.h>
+
+#define MM81X_INT_YAPS_FC_PKT_WAITING_IRQN 0
+#define MM81X_INT_YAPS_FC_PACKET_FREED_UP_IRQN 1
+
+struct mm81x_yaps_hw_table {
+	/* NOTE: We need these padding bytes for yaps to work */
+	u8 padding[4];
+	__le32 ysl_addr;
+	__le32 yds_addr;
+	__le32 status_regs_addr;
+
+	/* Alloc pool sizes */
+	__le16 tc_tx_pool_size;
+	__le16 fc_rx_pool_size;
+	u8 tc_cmd_pool_size;
+	u8 tc_beacon_pool_size;
+	u8 tc_mgmt_pool_size;
+	u8 fc_resp_pool_size;
+	u8 fc_tx_sts_pool_size;
+	u8 fc_aux_pool_size;
+
+	/* To chip/from chip queue sizes */
+	u8 tc_tx_q_size;
+	u8 tc_cmd_q_size;
+	u8 tc_beacon_q_size;
+	u8 tc_mgmt_q_size;
+	u8 fc_q_size;
+	u8 fc_done_q_size;
+
+	__le16 yaps_reserved_page_size;
+	__le16 reserved_unused;
+} __packed;
+
+struct mm81x;
+
+void mm81x_yaps_hw_enable_irqs(struct mm81x *mors, bool enable);
+int mm81x_yaps_hw_init(struct mm81x *mors);
+void mm81x_yaps_hw_finish(struct mm81x *mors);
+void mm81x_yaps_hw_read_table(struct mm81x *mors,
+			      struct mm81x_yaps_hw_table *tbl_ptr);
+
+#endif /* !_MM81X_YAPS_HW_H_ */
-- 
2.43.0

