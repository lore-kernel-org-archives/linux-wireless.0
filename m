Return-Path: <SRS0=vmj3=DT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58579C433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Oct 2020 08:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 034CC206F4
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Oct 2020 08:11:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHWHJ46+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgJLILo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Oct 2020 04:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbgJLILn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Oct 2020 04:11:43 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFEEC0613CE
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2020 01:11:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n9so13516491pgf.9
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2020 01:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gxBKupSKNm0WjlJ2r8d/Ivcf+9kpHIZLqPGV+tgABeU=;
        b=JHWHJ46+pWa8ObtUAgF3ZY/AjkOhmC3tIpMWj6YrnR46qklQeWoVStiOgY8LIbgeJl
         /T1d47QcTgvNKEmdBlLlcktvsQAWP/zKgdhpgg2yO2MZw3b8uP0eXjX01AW29ZCv2F1Y
         roFGujonkXexEAuxJPq5jgHI5vv7oy8cYY66B+TzIbgiE0nQWJVNRSOR9MLdjF9MS8tU
         PMulu8vJNHVCuyUCVcPf7ixB7I9gxvIvcfdprvdWSMtl61NyEnjlrxNoMBa2xWab9/22
         ed9Le+5jKYS7eYaoVPN73ZfA/KE+Z8V73SijJSAw/3eai/Ac3w+w+jx9GsdG4Go8ttzM
         asoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gxBKupSKNm0WjlJ2r8d/Ivcf+9kpHIZLqPGV+tgABeU=;
        b=gx78WG2oYBaTDEfaadeT52owQM+BVRDje7cSOBmVkszVtcJUOuZNyqh5uAh+2QGemB
         5lfYOokzMXZluxuBg10rr2MYBf/5BQkRBo4OZMkOARVmpfsWckB1GgfwfXbEU6sr15L2
         1tnietDKCCsJlwooWGZuCig4DPPZUc1DYV2r2aWRsnIjFnJ5xH1FIQqCGu0lD+521G04
         j5YnHI6ywKOY9W4OeD0aCdDwBUPwIFaupWJSHeI35lW1raboNmPszcGAwY0miqWUVAYQ
         5pMjBDJOTTLNn5p0o73uhlDhwqspL7wPH3a34T/2im9SoypdqJT6hcjDb2UtO/i+rWcK
         fZ2A==
X-Gm-Message-State: AOAM532ad6XPOKL+jNzSX6h1oAuV0cEyEe1vruAYzFO/mwjDZysI6K7y
        z5D2a9erYtSQ2XUnHHf9Zg==
X-Google-Smtp-Source: ABdhPJzWBVFP4Y0hcGyyvVC+mB7vkUBtrFv+k1Kv50GuNX3wqX39ABMNswhqh4e5nIodB3VaNLYmJQ==
X-Received: by 2002:a63:5653:: with SMTP id g19mr12382750pgm.151.1602490303186;
        Mon, 12 Oct 2020 01:11:43 -0700 (PDT)
Received: from localhost.localdomain (60-251-199-163.HINET-IP.hinet.net. [60.251.199.163])
        by smtp.gmail.com with ESMTPSA id 92sm10966806pjv.32.2020.10.12.01.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 01:11:42 -0700 (PDT)
From:   tony0620emma@gmail.com
To:     tony0620emma@gmail.com, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, tehuang@realtek.com,
        pkshih@realtek.com
Subject: [PATCH] MAINTAINERS: update Yan-Hsuan's email address
Date:   Mon, 12 Oct 2020 16:11:40 +0800
Message-Id: <20201012081140.18085-1-tony0620emma@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <tony0620emma@gmail.com>

Switch my email to gmail.com address.

Signed-off-by: Yan-Hsuan Chuang <tony0620emma@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c99577961cc4..f437c4923b12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14701,7 +14701,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.g
 F:	drivers/net/wireless/realtek/rtlwifi/
 
 REALTEK WIRELESS DRIVER (rtw88)
-M:	Yan-Hsuan Chuang <yhchuang@realtek.com>
+M:	Yan-Hsuan Chuang <tony0620emma@gmail.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/realtek/rtw88/
-- 
2.17.1

