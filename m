Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E18C4361B
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Dec 2020 14:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC8AC22D50
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Dec 2020 14:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgLTOTK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 20 Dec 2020 09:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgLTOTJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 Dec 2020 09:19:09 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752D3C0613CF
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2020 06:18:14 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id d17so9894122ejy.9
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2020 06:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AlxDHsRJSlJHFCuxX1ZUwHupb0Ta7pUpeS/i8eu6MA4=;
        b=k+u+lwauWj7VaDmDsIvV7syQEqPB1Zxjph+KQM65NJ0lmbuI8V3od2NeTcxcaCPHdB
         PRUs8wZOBmJC9HJl/0Pz7SSWW301xq7NAxbt4/aDNPPv0hBGIqZsqlskkBG0A3zi20ja
         iIJcoR/fQDoczmsViMMNIjrTmPdN7427iOFa3Zt2DL/vLiUQSkdS6RV8eUmmlYfkRVxl
         I4cu716S5iCgRM/zDvevd2AXVEqHFwd3rGlRq8b6JAcN8VdEGlXH8/tcjXoZUHAWGkSD
         Jh0vANQ/rldgvOTMaMx3ee0lI84hZzNNi2rSAcSzloMc5k+1ylVAUjAkkb/GywvmSOpt
         wsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AlxDHsRJSlJHFCuxX1ZUwHupb0Ta7pUpeS/i8eu6MA4=;
        b=PZUscIiYLnFBosZWHjrtrUeZ8g+FcGcHprB9u18gX8PxWUrydbAr5Z2dll13sVSUS1
         apyXcFmVYiHEXTfWHbnuxX7R8UxajaEhGT9HIfxS92SrFrN4Qh4RNhjai7XtDmDWzUWm
         FSEi/rTHCP35CWV6AIMiMieS1yJSH9qyU5jrscc1eHorH+UVmhaB/Lqs9d1NYRy5tCN0
         EDMmGMvrLcjNlItJg6pVQOWmJbbzOz9aNR3hyJGPAvRoMoy6UJ8ZEoeipAymxdacZPjC
         MoiywcDE2qr08DCWAL8M1ZVMmagbhkFc/RXsB+ZacvsiSLBEBjudoGn2VQQ6O1/rbz5K
         rnVw==
X-Gm-Message-State: AOAM53057i8JGyQZpgtyqAIFl7SVPu5uBtfeKhwk6ejvRUyVVEM1tkvk
        Hh/+C3zlhWjwCdads7UGi9A=
X-Google-Smtp-Source: ABdhPJxY43dSL4S+k0X/9OxrnoE6tBo2rLfvDlllDYB03t0bRJdeYWQmmWx2VeIZMEhoxguZOalOpw==
X-Received: by 2002:a17:906:f0c9:: with SMTP id dk9mr11900363ejb.51.1608473892464;
        Sun, 20 Dec 2020 06:18:12 -0800 (PST)
Received: from [127.0.1.1] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id d8sm24209687edm.75.2020.12.20.06.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 06:18:11 -0800 (PST)
From:   Arend van Spriel <aspriel@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <aspriel@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] MAINTAINERS: switch to different email address
Date:   Sun, 20 Dec 2020 15:18:07 +0100
Message-Id: <20201220141807.17278-1-aspriel@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Switching to private mail account as work email is polluted with a legal
disclaimer. Just making it extra clear by changing the email address in
the MAINTAINERS file as well.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Arend van Spriel <aspriel@gmail.com>
---
Hi Kalle,

Not sure if both s-o-b lines are really necessary, but better be safe
then sorry.

Regards,
Arend
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5c1a6ba5ef26..85a7c3a2ed63 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3545,7 +3545,7 @@ S:	Supported
 F:	drivers/net/ethernet/broadcom/bnxt/
 
 BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
-M:	Arend van Spriel <arend.vanspriel@broadcom.com>
+M:	Arend van Spriel <aspriel@gmail.com>
 M:	Franky Lin <franky.lin@broadcom.com>
 M:	Hante Meuleman <hante.meuleman@broadcom.com>
 M:	Chi-hsien Lin <chi-hsien.lin@infineon.com>
-- 
2.17.1

