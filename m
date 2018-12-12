Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E667EC04EB8
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 09:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A93BB20849
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 09:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="QmGZll6c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A93BB20849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbeLLJTz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 04:19:55 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34416 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbeLLJTz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 04:19:55 -0500
Received: by mail-lf1-f66.google.com with SMTP id p6so12985617lfc.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 01:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HaKdn7hOA8cpqASV6dk6p0jU97H1+EcOjvTQOh2ZQlw=;
        b=QmGZll6cZcPZxXfXfOaQmC0OJG6LUBp07bZ/9REL/GOeO9JZbuuTIV64ERX9bsY464
         4jBC3aJogrwulVsiEkiyOruGXkvVg5n7QgQMQ+pQfDOyYYjuznOnGSR4JwlyGalm5PwD
         ZvnZeGPVcoLKWRLFNuCdjzjw6LMAWYKFHnl/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HaKdn7hOA8cpqASV6dk6p0jU97H1+EcOjvTQOh2ZQlw=;
        b=dXhhqn5b3FAThJXsrtlPG2u6VBp5ogL8lQpbswSc8M3Ie5/DOTn/8YZyvfqduS16LQ
         0XGWObAs8iWG252wcUbJLTIf0yf9g2pxS+zNNyu/x5hXW7FJFGFmT68kr8WzO/A5c/lw
         uK6f5fIyDmAGmrBv4pE87vEvjWICjxW0QpWl7sDzMJXFEKyeyL6tAKXCxX6Hfmtb57lQ
         NqC7KY6VVBG0K4381gEiO8pCk10n9/cxlbiJvTwnUDJGPvRmv5+RIw+OCXjkeRAueszI
         LFaSIfgcnRpfEs1Glv6fPlKE64F3Ens7uuogp4eQFTuvjInBjN9EFdBOrvQ20rJiU4EN
         kfJg==
X-Gm-Message-State: AA+aEWa2mjb/iJjQWt8dRQG/WVavIIomrIvfPti56X8w2hrh7IxYv3Fq
        sO65my7usGxqafgOBCnCkyylpQ==
X-Google-Smtp-Source: AFSGD/U8SwDyTGMStPBGfnkMzmJeaop0TJmlmYVRguj6J9v1tstHkz3WucRrf6lUiw5R3KO56kw/BA==
X-Received: by 2002:a19:4ace:: with SMTP id x197mr10716507lfa.39.1544606393105;
        Wed, 12 Dec 2018 01:19:53 -0800 (PST)
Received: from genomnajs.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id k14sm3064845lfc.70.2018.12.12.01.19.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Dec 2018 01:19:52 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] net: rfkill: Remove unused include
Date:   Wed, 12 Dec 2018 10:19:50 +0100
Message-Id: <20181212091950.8782-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The legacy <linux/gpio.h> header is no longer in use by the
rfkill driver, so drop this include.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 net/rfkill/rfkill-gpio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 0f8465852254..41a5cd4b5c0e 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -16,7 +16,6 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 
-#include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-- 
2.19.2

