Return-Path: <SRS0=yvfE=2B=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32375C00454
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Dec 2019 14:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088EA222C4
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Dec 2019 14:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTFNRC0S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfLKOjf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 11 Dec 2019 09:39:35 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39575 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730139AbfLKOjf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Dec 2019 09:39:35 -0500
Received: by mail-pj1-f67.google.com with SMTP id v93so9017878pjb.6;
        Wed, 11 Dec 2019 06:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XbYbcASd2+KhdijffyhFolrYSToXlnSKrqANevTKCr0=;
        b=cTFNRC0SDsTy6TOB5GAhoEjp+6Nx4jpqI/v0BumN/4YTcJP+nvYX069JP+MbzEagHr
         H0ef6hXStk3Qg5lCvjuLedPwtDGDXfRoB85H+g1U06dX5OfXuUM2jxLvl6Cjs9tJ1WL+
         S0yPKhGp9Gb3thch8kkmllLkaCqodmqe2Sx4pEr+RL5dqATYLc3rAUoO5MLajiv7DCO3
         JNeUQRpuduNY8cUkoj6eofMk5/c454aa+Ha1eoWmL458SQ2qJ+ii3tkN3pBKHkkAAY6b
         u0wOCJNda/YXvxTj1qSg10BkhZrqKRHmv4Z2Tw0e/Zvq2XZkBq2HeYHcgVAzWVb+uVUw
         R2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XbYbcASd2+KhdijffyhFolrYSToXlnSKrqANevTKCr0=;
        b=F2gS3f3Q8nwmFgGR5vallu8cUdUccFy6xiFautOvd0/45t60Ziy9nKbJNR78DM1IBt
         XkXq2BaLGYm+E/9jbbDERIg2vhWSdVrE+QMpODlZIU8Vl9rLVv1jhEVavyXjdddA1h1w
         srcqaiVaXp3TpoVGqzRvFdZ5eVC6s2z4l3jmWVCQ7IrWEcRUK5ZDENn39rQRq4e8IzE9
         2sRUCl2zMboOy68L3obFchQnebk/RSOLKYsx5TgGjv7J291VvZ3ABpJzRdO+dTy7bKSb
         EftGA0N83HKK8ar9qiv6k9xrpqI4nYgh5oCP9BqDnXZNYTD5C86iDgHhnaq+dh9Bud4Y
         QhoQ==
X-Gm-Message-State: APjAAAXWgom63XuX0etys8LKG5SfbNptbCYH0JeQnKVY9U1dfQvHIICW
        l2GEdKWBS7g9AT4vHE1f5/o=
X-Google-Smtp-Source: APXvYqw0ZMYCDczwvXAKv4QaKyfYTxS7oOjP0rRHfMNhKXXkmJLTUVSslEFXuouLo4HrbdvcoGIzRQ==
X-Received: by 2002:a17:90a:970b:: with SMTP id x11mr3797597pjo.35.1576075174618;
        Wed, 11 Dec 2019 06:39:34 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:368e:e048:68f1:84e7])
        by smtp.gmail.com with ESMTPSA id q11sm3444239pff.111.2019.12.11.06.39.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 11 Dec 2019 06:39:33 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-nvme@lists.infradead.org, linux-hwmon@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sujith Thomas <sujith.thomas@intel.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH v3 08/12] thermal: remove kelvin to/from Celsius conversion helpers from <linux/thermal.h>
Date:   Wed, 11 Dec 2019 23:38:15 +0900
Message-Id: <1576075099-3441-9-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576075099-3441-1-git-send-email-akinobu.mita@gmail.com>
References: <1576075099-3441-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This removes the kelvin to/from Celsius conversion helper macros in
<linux/thermal.h> which were switched to the inline helper functions
in <linux/units.h>.

Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* No changes from v2

 include/linux/thermal.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index d9111ae..126913c6 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -32,17 +32,6 @@
 /* use value, which < 0K, to indicate an invalid/uninitialized temperature */
 #define THERMAL_TEMP_INVALID	-274000
 
-/* Unit conversion macros */
-#define DECI_KELVIN_TO_CELSIUS(t)	({			\
-	long _t = (t);						\
-	((_t-2732 >= 0) ? (_t-2732+5)/10 : (_t-2732-5)/10);	\
-})
-#define CELSIUS_TO_DECI_KELVIN(t)	((t)*10+2732)
-#define DECI_KELVIN_TO_MILLICELSIUS_WITH_OFFSET(t, off) (((t) - (off)) * 100)
-#define DECI_KELVIN_TO_MILLICELSIUS(t) DECI_KELVIN_TO_MILLICELSIUS_WITH_OFFSET(t, 2732)
-#define MILLICELSIUS_TO_DECI_KELVIN_WITH_OFFSET(t, off) (((t) / 100) + (off))
-#define MILLICELSIUS_TO_DECI_KELVIN(t) MILLICELSIUS_TO_DECI_KELVIN_WITH_OFFSET(t, 2732)
-
 /* Default Thermal Governor */
 #if defined(CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE)
 #define DEFAULT_THERMAL_GOVERNOR       "step_wise"
-- 
2.7.4

