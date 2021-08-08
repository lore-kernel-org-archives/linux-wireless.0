Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C56EC4338F
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Aug 2021 10:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D69661004
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Aug 2021 10:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhHHKBC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 8 Aug 2021 06:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhHHKBC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Aug 2021 06:01:02 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FB1C061760
        for <linux-wireless@vger.kernel.org>; Sun,  8 Aug 2021 03:00:42 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id a19so19284798oiw.6
        for <linux-wireless@vger.kernel.org>; Sun, 08 Aug 2021 03:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6wyow44YPiiK5i4Vf6IipqAYBIDrKgSk5WD113gWcH4=;
        b=Uzp9tIAuHLV6mzU0CTvTg9j3iI/iiJWhG2zC8+JsL1pi+BwhY1YpkMyPwp5jEHD7nI
         cArsDUcTdRF1105RhsPKFKYwynjc5r8a7dV9f3bLyBQWWAbF8LxKQHBEXujFlB5uTFYQ
         TbJi7AVIeaej3BltYec+oI8OXSamF9ERc2/K/wugqwVyAQlTBnTFzsfoZ9tg93fwfF1S
         /TE8e8QtFxZP5APvUv75cqX+cQ3XD61P0TrcU5KhrRn31zc6ELP+IPs7rq6+0FtdDiJl
         dPC+gYD6DOs8k/AZO2ykKYa/3cwDbIqQiozrW8HYN0IsjDt1V5JkdjYfFMQUNbj2jUZX
         1jEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6wyow44YPiiK5i4Vf6IipqAYBIDrKgSk5WD113gWcH4=;
        b=q5+wSlUOaTaT8pgPBvDFctD0YDf0S4uQJj+4Yoqneet6nVaMbu8jwLqsaUAB9TEd+f
         Eu5VXjniBOf9iWfI9FJ+eL02HIzZxpOid3QTboG6b2ZrEL935sGFkgWDn8Imlqoi97XE
         0vD3IJKYh63XXK3aUgZEjedNvW5Oerj6f0u1QsqIXunX5w7LJ6+Mexwt72sBgPCjzGjA
         bsUinDxaTd9doq2X7StGxnAQrp/rqUdXqnFYsIPzaBzC5XCjr+iOpIDY4hRIZ3OCOTwY
         rFKrXvj/gB9hHtPbiW/Z2JwZUm72x18qjY1nZ01OUpzkLtGqJs7Hx5vPaB60SEvkNjn8
         f7Nw==
X-Gm-Message-State: AOAM532Gp7SA1rwAQ5GMoQaismgJBUqtOyPMZFWxQxWpSmm6M7DbX9Aw
        mp6TGySPq4c/p8K6b/HMCHdG+hH0w58/t7vUL7JTFpnya9c=
X-Google-Smtp-Source: ABdhPJzadqf4wN5tw4e0K/s28GCFnZ1j4bMAqpXth5lYuCpwKuMS0H+RJoUCZxHnRbm6zVXYcso85I06l8ffilUkavU=
X-Received: by 2002:a05:6808:3db:: with SMTP id o27mr3439737oie.114.1628416841815;
 Sun, 08 Aug 2021 03:00:41 -0700 (PDT)
MIME-Version: 1.0
From:   Sugandh Huthanahally Mohan <sugandhgowda@gmail.com>
Date:   Sun, 8 Aug 2021 12:00:31 +0200
Message-ID: <CAD_iCC9=wccbhrPCzAzMnRa3-a9g_BcjL6g=FAgs6aXEwGB5Aw@mail.gmail.com>
Subject: FTM support in ath drivers
To:     linux-wireless@vger.kernel.org, pradeepc@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello All and Pradeep,

We are required to evaluate the Fine Time Measurement protocol (FTM)
in ath drivers for a project. We want to make use of both components
of FTM i.e., Initiator and Responder.

Going by the ath10k drivers, we found implementations for FTM
Responder while we could not find implementations for FTM Initiator.
Could you please let us know if the FTM Initiator implementation was
done as part of ath10k drivers?
Also, is FTM supported in ath11k drivers?

Thanks and Regards,
Sugandh Huthanahally Mohan
