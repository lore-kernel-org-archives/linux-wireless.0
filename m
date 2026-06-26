Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76D03DB336
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 06:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782455608; cv=none; b=dD60UN44c9BpvoC7cMkvyf7jo5+1EN7h4rz3KpQE47zrspd/4hl/r7DYoejdIy31/iY0YS2Nj7L58qS57IrsU/ARtpUrT7V3EIo3kGM2A6JUu2RnMMN0evXcZldlud8hUEaKkrlFumsNAPqugy7Fe2U9FLBb+9L7OAMQaXGf0kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782455608; c=relaxed/simple;
	bh=j+GoVCuaLvqU4SwwdqaBic2hIr4Z2cYuhqEBA53VU80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jj/Pyg47PxnjBpxu1+znXRgIrkSmqMzkn/1/0OwzUhBLmDzhnOn7lx9EDcYl2GQDMdJFjJltAGHdjzHtWHbtnJuU3so6tMjpytzcnC08ImSwWZpu77VKkD1d9btAAO5J9/AFhq1+HHGqHKAFZyxjS7al8Z9c6eUgLim29aIKicQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=L0td6fwE; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="L0td6fwE"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-13986d61b4fso908135c88.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 23:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1782455606; x=1783060406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m3NewaIlQ3hKAP5pHFgT6EvIGsSEB7Kg1StwcRvY5eE=;
        b=L0td6fwEya4P8pl7kaesYVZyy9YNajHwVDElj6Xtotdu2PMaGS39gmFpD4y661uQN2
         CgkVYy3Bq3EUmylTIBX1dNvRZDrumEUrJI+Btn4xcH53XzXZWXiE/6mmB2qdV4R8sbBV
         35yCuLobBAPxjtYFcd3XZP/yD7fLHOeyFZyJBFtAB3eHF/fh6/A+zhWXdlyLowhUfd9C
         89K7l78g5dHVYJA6B0Rc1O0TaTwjj7S4oZXEDc93Y2gdfhK2fEdSnR3XWVSKSrY3QXLM
         H5zr7UTw0QpF4kGXUHumIW5WECVNLdHXP3eaCZU2zksP5E2hSi2jm3yIaTjC3eLn42RL
         Yt2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782455606; x=1783060406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m3NewaIlQ3hKAP5pHFgT6EvIGsSEB7Kg1StwcRvY5eE=;
        b=rEE5S3NH7SwIdelPuryOxWU9Cokms/O15OSHzaLgKQCkhv7nDJ7hgCn9Xf5RCsZOK7
         gjvGrX1itLZSGn5nFrUZSMXlshCLo2SKGmfCzegXEGFQyBrSp0MSM30J22eScpFT782L
         hQNJYc2vxW88wBTUdKJZGvZgQ8RtOjCm4Om93gL4pkbh3BzfTp0g9/m6r9dUew0dNfVW
         ChAjzIMXdLDsHyMpzH3x9z2HSr8hmqGy/ToD5jlKd7kMXuu9YBW3lVt1F4FhwAd0sgZH
         zmshhS+Cuhp+u12jiPJzVxr3IX2RGpj85BHzpOVDr7D+rFPXdPW3gBEMDCBjcGoPNq8M
         cjVg==
X-Forwarded-Encrypted: i=1; AFNElJ8ikWPuD1lur7klvw4BV0O0oB4aPOiVxm+2UzGu0qDFJHn+GdsM4k1bRW5amqEJ+eEJ039Nk+0x8OYqJov/MA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKfuyRU9qWqxagXst/zeLpqyyTiO+JQ0aFmkmYFwM8PAeaqaFq
	RhmeGTzHXh8uyJaDaQ/QZPy2SBx03JUlS3dtt3rtRnXFF69MzGc9YEo9S9dQXi4NJj4=
X-Gm-Gg: AfdE7cnqTC53dBJDM8Xma9uqoE6CjQjHKIeQGQJTDNT9mZW6uXorxXir1DY9NgsowmD
	BGfuY5r+f/Zj5j2zDYdN6KE0FkVTzK/Y+EZ+f32dhO53ln/JxcwRPtmP8jWmBo2hoZZKwOgR38A
	EorNGSKkO+Sz5KwBfe7cLz0lMl0ZSuV+q78rGU5bYNv28+IOF84jUtTm02N05LHPn2t12E9Any+
	ZHekoTVvl93j4a0YzNPrpCInOK+c1uOTr7zKzl6crWtLQ8lLLYKC1MD0Swb4Tl66Em/zuXxHtsd
	8tJB2NZh2w9GHfMqj7tdO+LQMS9Cduv4HyhspoqJaQ7/9d+C0/TNjog0UiX6ky3JCcfdg94smiI
	SVgJVu3DvqdEMs/TcFeZPqg47wHvqHGGoEQ84UjZqzkTVBsPkXcdfH7nRUSk3Zaloy/xUhfCIRu
	BvvF2rd9MQ1jpRELp95Bj25P0EzFNsstq54xpA94KI+vCyqB2uWjuDtxDUjkNGaT5vEbzC8UNJ2
	U8OgW27lPUI6aOLeH13APLgx4mjOzo=
X-Received: by 2002:a05:7022:504:b0:139:dab5:e2bb with SMTP id a92af1059eb24-139dba4ac87mr5451427c88.15.1782455605958;
        Thu, 25 Jun 2026 23:33:25 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d91006bcsm15463687c88.13.2026.06.25.23.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 23:33:25 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>
Cc: ayman.grais@morsemicro.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v3 29/33] wifi: mm81x: add yaps.h
Date: Fri, 26 Jun 2026 16:29:25 +1000
Message-ID: <20260626063014.1275235-30-lachlan.hodges@morsemicro.com>
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
 drivers/net/wireless/morsemicro/mm81x/yaps.h | 77 ++++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/yaps.h

diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps.h b/drivers/net/wireless/morsemicro/mm81x/yaps.h
new file mode 100644
index 000000000000..2b2bb5f6e399
--- /dev/null
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2017-2026 Morse Micro
+ */
+
+#ifndef _MM81X_YAPS_H_
+#define _MM81X_YAPS_H_
+
+#include <linux/skbuff.h>
+#include <linux/workqueue.h>
+#include "skbq.h"
+
+#define YAPS_TX_SKBQ_MAX 4
+
+struct mm81x_hif_ops;
+extern const struct mm81x_hif_ops mm81x_yaps_ops;
+
+enum mm81x_yaps_to_chip_q {
+	MM81X_YAPS_TX_Q = 0,
+	MM81X_YAPS_CMD_Q,
+	MM81X_YAPS_BEACON_Q,
+	MM81X_YAPS_MGMT_Q,
+	/* Keep this last */
+	MM81X_YAPS_NUM_TC_Q
+};
+
+struct mm81x_yaps_pkt {
+	struct sk_buff *skb;
+	enum mm81x_yaps_to_chip_q tc_queue;
+};
+
+struct mm81x_yaps {
+	struct mm81x *mors;
+	struct mm81x_yaps_hw_aux_data *aux_data;
+	const struct mm81x_yaps_ops *ops;
+	u8 flags;
+	struct {
+		struct mm81x_yaps_pkt *to_chip_pkts;
+		struct mm81x_yaps_pkt *from_chip_pkts;
+	} hw;
+
+	/* Chip interface is stopping, new work should not be enqueued. */
+	bool finish;
+
+	struct mm81x_skbq data_tx_qs[YAPS_TX_SKBQ_MAX];
+	struct mm81x_skbq beacon_q;
+	struct mm81x_skbq mgmt_q;
+	struct mm81x_skbq data_rx_q;
+	struct mm81x_skbq cmd_q;
+	struct mm81x_skbq cmd_resp_q;
+
+	struct {
+		struct timer_list timer;
+		unsigned long retry_expiry;
+		bool is_full;
+	} chip_queue_full;
+};
+
+struct mm81x_yaps_ops {
+	int (*write_pkts)(struct mm81x_yaps *yaps, struct mm81x_yaps_pkt *pkts,
+			  int num_pkts, int *num_pkts_sent);
+	int (*read_pkts)(struct mm81x_yaps *yaps, struct mm81x_yaps_pkt *pkts,
+			 int num_pkts_max, int *num_pkts_received);
+	int (*update_status)(struct mm81x_yaps *yaps);
+};
+
+int mm81x_yaps_init(struct mm81x *mors);
+void mm81x_yaps_show(struct mm81x_yaps *yaps, struct seq_file *file);
+void mm81x_yaps_finish(struct mm81x *mors);
+void mm81x_yaps_flush_tx_data(struct mm81x *mors);
+void mm81x_yaps_flush_cmds(struct mm81x *mors);
+void mm81x_yaps_work(struct work_struct *work);
+void mm81x_yaps_stale_tx_work(struct work_struct *work);
+int mm81x_yaps_get_tx_status_pending_count(struct mm81x *mors);
+int mm81x_yaps_get_tx_buffered_count(struct mm81x *mors);
+
+#endif /* !_MM81X_YAPS_H_ */
-- 
2.43.0

