Return-Path: <SRS0=Sl5Z=XU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00F3C4320D
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 01:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95E3B214DA
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 01:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XDiO+gjy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfIYBJ0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Sep 2019 21:09:26 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34243 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729301AbfIYBJ0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Sep 2019 21:09:26 -0400
Received: by mail-io1-f65.google.com with SMTP id q1so9297898ion.1;
        Tue, 24 Sep 2019 18:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0qoaoTDAjRV29/UL580IFfKdGNsaStRuKRBigYtB0Zw=;
        b=XDiO+gjyS7ZVsjg7msFnLhyFFBifyXv3e7YuA3S6LsPIm+8Wm37b9Gx8ir5s2nvTEE
         4CLtRlQ18hwpJ7WQbnedU4td+QeEpmuPlGo8iPpA8JFC/e9cfHiPSDj8bkE0mym+xH5s
         4o3Zt70Jlode9tlxU5oXVwPBof8gM/I+vLHCDo84ahQPitOYoSQrd2i6rcTJDXVK7Atz
         ORAsK7Ib2JFx+DjrQEqPv3cwxUx0x6lskcMNMi1HJUGE2PzXATJtJZdp5TMa6nUtYYe4
         q3j/BwK/beAJiJOxYZXAHCLoiU9l+AkSlOUa1jCfzF8vlUjqGcyLYutabpPk4BxCj/cj
         ZehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0qoaoTDAjRV29/UL580IFfKdGNsaStRuKRBigYtB0Zw=;
        b=RluUCqx/kzvc27gPOsFc1F+gqSdxOJF8jM3NiLs1i9oAgu31KEVHI+IoDnOGM8KUTN
         rppCFGmEyr/ZmXvwvmU4k22yfCf0CQeCnyZgBRdUYUUfcQ6TzH2RTdtrtd2shW/EJ98p
         vMiRoGW0xDlTA5X+ZM/603f6hzcdo8xP7wMiorfG8ovN0f5e4DxMoa730R3CifrTp4K7
         ZgqQHK4dygKiLaU5GxbHVXC1B26wEtDZR8es+1IgVx76Eo41cpQGte0tJSxnqoJHbLbs
         TMfv0rgyo19HiVL4DNL4qMdqa+Wn5gJJPHNLRpLzISnz/lqPT0r6mxjg/bVkkfWJdEIV
         gayQ==
X-Gm-Message-State: APjAAAVmfxGJu8JH2iLE/aD+9IgqjZPez8OKwu48c7TaLcR03ucEXbJr
        7MP3njJoh8j0hnhTEXHmluA=
X-Google-Smtp-Source: APXvYqyJQw60nnXBo8IOkvNVJN5i5TE00dngvI5i7TZeFj+UTu8cmYUDSUY34+1t7gWd3XgLI+tSow==
X-Received: by 2002:a6b:f319:: with SMTP id m25mr6676370ioh.33.1569373764944;
        Tue, 24 Sep 2019 18:09:24 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id l13sm23532ilq.56.2019.09.24.18.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 18:09:24 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: prevent memory leak
Date:   Tue, 24 Sep 2019 20:09:07 -0500
Message-Id: <20190925010912.27513-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In alloc_sgtable if alloc_page fails, along with releasing previously
allocated pages, the allocated table should be released too.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 5c8602de9168..87421807e040 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -646,6 +646,7 @@ static struct scatterlist *alloc_sgtable(int size)
 				if (new_page)
 					__free_page(new_page);
 			}
+			kfree(table);
 			return NULL;
 		}
 		alloc_size = min_t(int, size, PAGE_SIZE);
-- 
2.17.1

