Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020A937D100
	for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2026 04:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777525149; cv=none; b=K4BYXmp6gXaezcE/YhR06B3Gc2a20DjmEazOE87LrGYrxSPbYXQ6JyGU0tRMx+baWqpf2A2yTF4O238xBjZXLxsLdG91XDxi+LAwnKdNoHUKwWGNpgGZa7rmbF05d2/GA+fU13pFJtXgI/m+YlXRK5nTgks5/1bCKI+rzGXbqaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777525149; c=relaxed/simple;
	bh=3c4dZfH81P/O8rSIy/ifesCYtlRl1hB9+2QlOhMSoSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlnSHkDIgTe6ilJLhxHPjFYWPGDVwkRCrQR0/SbRtoqp7U13Ed7+xzl+hXK5JL2UajC3yOqu5iGog+RmImIlaLkCffEwZ+4nKoCdY2DSWRkbKnd/8b+7Jlzq0EynvJJD7IJnZc73yvRf/Uhktw21ObV36VzJfuAFJyXX8fQRrvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=FY7S+Mx5; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="FY7S+Mx5"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82fbf5d4dc2so393514b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 21:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1777525147; x=1778129947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8Mil24BTkKQ11Y7yk4p0FHOHJdUxkQjIzC/ehrGIXk=;
        b=FY7S+Mx5IoDEC/Zq2GULk042xebF+LVdGxsE1BNpOHqWwSW/HNjKLtFVk0H02OZhRp
         8QC4M7O5N2+zygkaDUz1acpYWhBCF8NJL1FaYvO3xv4DEWl1s7raXd2RtAXeO5p9jere
         cULRmXqvNnXnerzutVV2STaUUvUw24qrYd0qQ4qlkItfL8YGomqkU/8cLJbC4H3xC5dv
         lZ2kQ2vE3U/1WE5LtqvV2p+ak1e8TaVSvQgHgadhyO8r5XKB7QQD9hmWunvCVJwbCB3W
         vh9mXv45Lyjh5cfsIQF3NtWLUa9NRH0zu+96dWHE8nSHWt7AzC04e9JI/Jr497RgjVH8
         mMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777525147; x=1778129947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r8Mil24BTkKQ11Y7yk4p0FHOHJdUxkQjIzC/ehrGIXk=;
        b=YjG9C4GEgNhBD8wsJUaT2P8gG6sGhqODfvbNIvhqgdibZVOmY+gLNebbKrz1CdTqAW
         /pASl+TLiyPwLvAD80BgZ8FT/P2DFtI4PPxM8Gpin4Xo0hgai6c5qtUv0cZURPrfMds+
         KcvbkRYwbGm8cjvcOD/VaPWTwektMsN6IA6GIi2Td+fr6XTwvueoOpbz5BTbe7tmZPfU
         Rukamp6SnMpB8aOgb46VH4s8ZhYd/tmHwbBK4JJDbtRteY4OgJLkGdPMZG7sr8x0/DgU
         JyIwwvDFDqTX3t56YHZAJ8qM08ApZ8MqGJC2CL4J7uj0bvks2/d8W/zpkRBGO69wQHal
         rd4A==
X-Forwarded-Encrypted: i=1; AFNElJ/nHLZLRcbN6Us7QPatDpn4oRxMjRMb+ep/c/JJOzNmWsSMRKrdTkjxXwf67lwC77R2n5PAcELHvoKOXWGIXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyT6IqIQBhsR2Alo53TWxpZ8o7EnaA3/+7Sa6AEr/6ZZQPSm7JC
	SEX/KzD2TFvBW1tPRWlnFqnsceoQX6X/Cr2A5SMdPO4xjZWkMpk/VJ5lTupltl0NzEQ=
X-Gm-Gg: AeBDietgN6Ynpl9a6FQ7Ksb4gRMPDBPfT0OCxDxg6ip/9gi0S0rJ5QRbi/I6bWyzh/5
	IUuOW6o3vXj6r2qlUZKSbxcJHLjB4i5dV27kqJYUiz60urmWSQVs6xGvNQ9DesQEALwhf+ZS4bv
	5W2y5QIBSgL6n9p3jPkFMD8dLMMINIwFqV2CHiHNSD3pWA4BgtJhQarUaGZezN87nvJdh8UBDgW
	zdcqEtzEZtyvIIRMwg4YH61aVn+3ZDbdz0mcsTtDL8Psyd8EnQ88fpKu65B/Ocu/n+E15PsDkAw
	+IN5pBQ6RBWhCDL6/ZGk7Zvbj9WlnKkNJJg9E3F5gZlgZW4O7yF31ekT9+0s2Yc/KfVAgs13cq+
	pAWxqwtGVTHBiPggOoDzlnGz3+wXys2ouVJf6wuQN+uNCs834OnKeY+dgHYv96dwZ+jP+MJYmrE
	dFKX8R2CTu+wRwAl6GvbgLyjVP6kfSIBhBZzoRpNwAr3mTa2JMwznFswd9VfounSj/p31jc5OgN
	tmzw3VNckq9GeafSocBX4SBTUsPxcj64GpKJGMa4GfbHE4TL8UC
X-Received: by 2002:a05:6a00:23d6:b0:81f:3fa0:8c38 with SMTP id d2e1a72fcca58-834fdb68013mr1626774b3a.20.1777525147283;
        Wed, 29 Apr 2026 21:59:07 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed80df96sm3595073b3a.54.2026.04.29.21.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 21:59:06 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>
Cc: ayman.grais@morsemicro.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2 29/31] wifi: mm81x: add yaps_hw.h
Date: Thu, 30 Apr 2026 14:55:55 +1000
Message-ID: <20260430045615.334669-30-lachlan.hodges@morsemicro.com>
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

