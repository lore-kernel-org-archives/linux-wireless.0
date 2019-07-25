Return-Path: <SRS0=wvrd=VW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A77C76191
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Jul 2019 17:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3176A22BEF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Jul 2019 17:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uqJZ9lPi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403866AbfGYRsB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Jul 2019 13:48:01 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40606 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403862AbfGYRsA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jul 2019 13:48:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so23409420pgj.7
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jul 2019 10:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=uPyttyuukrOTyss4ATYWgEvUft5R0VGROoogq8e3TtU=;
        b=uqJZ9lPiDh6lDJrwTHr7pHrkZYYsxkLlZrhZHZlGYYNuBIeM69qOefpd858bUSgUTS
         EZvvkiGFLtRo1xyovAUomFKaMXUM5X1Z6D6CQWYvEFFpVjdBPLK28jbBMgXG357oVrIL
         lh6nYvSs9bi8UlYPOURqLRRSXQ9+GcbAtIJmki61DrhoWtOttOkUPRC2DNGPSF+l/kw3
         vrYwxuOfRBxagbSyfDxzK8L5uMp/CBMxgwJxP06wil9LJH1ay0wbZP5PlYs/BpL3fsBW
         BLO32TDOn6+aFMRLSjoqOD66ponaqQ91dLs0hQ7ORps2bW4PInGOREH4t7IpVOC292NS
         41mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uPyttyuukrOTyss4ATYWgEvUft5R0VGROoogq8e3TtU=;
        b=jOz1bw8u/Nu+M7J2XUMv5AdYSGw0X47K8SqUIdzMJ3viMMI474Li2SWhbz1zM1XJ9A
         r/TN96knDELtAiXFT6aGV0oWxM2PaH3ByE3cat1VcspQJ3AXPeKwKnwjgoOd5hbqEfrc
         waHyOMWof9Y/G07/UMPbYp+ph9mS0+Re3PuEHvHnJpjhx8ysmHcPCnjWaV3EXM1gmm6Q
         ZX4WqUjNTLzFsEP5/6eWDxzAcU+AUyPGF9XwTQYv1EsjSll5mW0YJGiXSr2bXL+Q62UD
         Otsfs4dXdcIBwJuvCMnpZBV6I872hvvEfIm+zG2n3nUTUFH0vxJLqMWrS8lVTtdgty7c
         S3yg==
X-Gm-Message-State: APjAAAUWNeeQchjv5XS7YHrLlRJl2PPHEDpOmAezLXBjGuo4eL0C7gLV
        A0tYe9+MTOyRD+NisABEi+L1vA==
X-Google-Smtp-Source: APXvYqxWJJdh2WpxR05u7uTV6jiYAW/aFCKSvCbDb97bOitI1MMffmACT2/OqB9WOLNoqFmGmLAUkw==
X-Received: by 2002:a17:90a:ca0f:: with SMTP id x15mr48139512pjt.82.1564076879249;
        Thu, 25 Jul 2019 10:47:59 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id r2sm68103389pfl.67.2019.07.25.10.47.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 10:47:58 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/3] ath10k: Clean up regulator and clock handling
Date:   Thu, 25 Jul 2019 10:47:52 -0700
Message-Id: <20190725174755.23432-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The first patch in this series removes the regulator_set_voltage() of a fixed
voltate, as fixed regulator constraints should be specified on a board level
and on certain boards - such as the Lenovo Yoga C630 - the voltage specified
for the 3.3V regulator is outside the given range.

The following two patches cleans up regulator and clock usage by using the bulk
API provided by the two frameworks.

Bjorn Andersson (3):
  ath10k: snoc: skip regulator operations
  ath10k: Use standard regulator bulk API in snoc
  ath10k: Use standard bulk clock API in snoc

 drivers/net/wireless/ath/ath10k/snoc.c | 324 ++++---------------------
 drivers/net/wireless/ath/ath10k/snoc.h |  26 +-
 2 files changed, 48 insertions(+), 302 deletions(-)

-- 
2.18.0

