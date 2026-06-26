Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815733D9020
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 06:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782455547; cv=none; b=dqBI1URrtKvCupAtOu45giqMEeTm1FwRPjjxS8Vno33K4YfnbK/8CuArsIbQHwETha6gsTTyRkGgRsfEclYV2vpm5HwYJUoNc0yE5lEKTyUKF/XaUukxxhSfoI6655ThTlGju7TnkRvhOnN503d75b6GaDykVxmdIPqpDsMR/XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782455547; c=relaxed/simple;
	bh=sZ5db9OMzu/ERL36zpv765dLG+X6FCJubt1KSBYE+BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfSJD6/o8ceQsA0fO27Nt0qgQNN2nJlJ/Bjmrb7Y4HEgC03LwbsVmRbqC4SoQCZcM+zL0cesQURhbLiDbPfuqGtzEMvzSrruTOKXKWo/n2sH0OBSsqyJYWg3sFKN8cetfA+Wg2/jUX8ZpL+Tlk6FAg+KmBEXfdqCaEtdkEPooM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=l2FHX4eW; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="l2FHX4eW"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1397e093f90so2154573c88.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 23:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1782455546; x=1783060346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=St8ASszBJPPTeFlVArhOrj/dEVW+6LWXmvw38LqMsEA=;
        b=l2FHX4eW56sYyBFiRI1kFNq2tEs0a0flRR46wRI22XVGOlS+WegcPMvnZi0ZQ1kCTV
         FJMReJHP3QF9jNPJaaXkQYruqPnelih7CBLIHwCOzNhLbwl3qm0t6HlWvVw3SjVCtUAN
         ZEBD+STqxe/DhbBH+ZwPs6zBrnG7P5IlPcXK7NythoG8SSigilbFO81UiwdIalG/GpDy
         PTB1DeoeKr7vI3bfdnDHxd57nz21nxRJnlgt4X2p1taW7HK9obsvk8d/EVxw89nIdWkU
         asxCGOatn17u+F2/BDDlgJfuPhBSwyLdQy3GMkKiHDZNFG8Bn42yAYeavdYpI6neCooY
         nRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782455546; x=1783060346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=St8ASszBJPPTeFlVArhOrj/dEVW+6LWXmvw38LqMsEA=;
        b=MIu0QOm4FpS/A9sHnEXnQ3FXMC9sd+GFt3tyhaVG67C56XfJopUmDHSry6czFXjgZb
         va3Dw5ZYMnKoFHNQQlMUDFqft+Yt7qK2D1d7DPC3Gix7GkKCjGDRqQjxaaboBAbKyRx3
         /8MqVLEv9ryHbTxWGkhimQBCISecHVZ77vKlFfdJln1F96QICEDxS3aCs3tmHFQ8NhL7
         UtMDqrEXX5xDhovPovNqvTEXTfSbSZrTHmK7Fbx0iFFd6knbadbTCh4Nodw+zdEjSc9o
         yZRqiuzC4nBCYJn4Cy0MrKKM/w54XuwFYWzvkKL6oRT3gxkZPzfqAoAiT4WGLn9NDk+n
         /BTg==
X-Forwarded-Encrypted: i=1; AFNElJ/OmixYP7q2JlZvee+3TsQTnrQ+yp2FX1phE6QyWKfmpuCpexgGUhLdRkFhxbIHxNNwJXh0qmR/94cxQxjL2w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw443vrQvxhnVkTrFW7TpiOr4gp5gnvWPNbIpBqJ3orRlKI2qhv
	leFq4+6KOysvEJhQcwDFgn3qo7xNZlmre4plCSwcLnxEFtePSwE3vmMu91yk98bwZ0s=
X-Gm-Gg: AfdE7clPf4zdp4LgbgESfGln6hac0Ys6Sb2IT7kSGg4k0tZMXbvitSxJ5pQY8uzKceh
	DVMt6lshAK3fmAHeRxiv/zSK41SsyfCfUVjDER6ZSI5UrjX61Qg/wNzsjUUP1OfkA9XturwXXM7
	aPQbARM14pok7B7XV3ABMtRT1HfWfxCTonCG3s6/o1aU1KGbPQ+0HaWKB2aNw6NilyBntBVcHxD
	GvJZbGgjojeJ0JlxIAUWGdEV6jHK80znNCgG4QvVliOPsxE6p2Sfk18GwWOu30K9mDbmxVh4oeT
	fRgFHh3BE0aiRmFSV4e6iUTSrnhpNuNFC+rmIyZRLu/igcMfUfW45wXAJjtcQg/mMBFVUJX8gu3
	kmcTdj1/r8f1cN6/Au7t9+hY7qj3LagfznW9LTqqKrWnTsxoM8ZzJ7QC2b1vzwlB8IJpNfeUh/g
	4ts85XYHRtw4af++Sot/PUmdd7/XUTEeXMh5JE3cOcjxbh5xKXtN679bY6JdzOb9CjYP63AcOJB
	Ymc/PUorilT6nib0oo5
X-Received: by 2002:a05:7022:6981:b0:137:699d:7b95 with SMTP id a92af1059eb24-139dbab18bemr4734168c88.19.1782455545669;
        Thu, 25 Jun 2026 23:32:25 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d91006bcsm15463687c88.13.2026.06.25.23.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 23:32:25 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>
Cc: ayman.grais@morsemicro.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v3 19/33] wifi: mm81x: add ps.h
Date: Fri, 26 Jun 2026 16:29:15 +1000
Message-ID: <20260626063014.1275235-20-lachlan.hodges@morsemicro.com>
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

