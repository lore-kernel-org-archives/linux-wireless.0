Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4D4C433E9
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Jan 2021 11:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13B80233F7
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Jan 2021 11:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAMLsi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Jan 2021 06:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbhAMLsi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jan 2021 06:48:38 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0C9C061575;
        Wed, 13 Jan 2021 03:47:57 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id z1so1891926ybr.4;
        Wed, 13 Jan 2021 03:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OgFoj8A8iH+xHmxdpvqXBMUS1oxib043+v3N6AYNDEs=;
        b=JcPYAhk3ZGBKAFXDOwpNt/X9DrNPFhd1bGuLFR5lSfXhDI9Vq+jBid/7wbZBvuWMAy
         AEhQQTNel27g9y6pS9AyOnT0Xe+8eMmA+p+2nqz+gSEMMW1YNAVF5QcNNEdC2KEs17x7
         djzgx0RsEsGcxDzX/KksJmBwsvGckLqhs7OmHWWMo9b3nHEDZ5+mXybruvwISJ2yBjho
         2Jv8u+k36j5M7Iqd7dyF3oYCAtNE/51rDBsmbW0RgzArXXxLn0ECv5olEFWIHTmiw9rC
         GBUWA+rhmPT5yFLOEyJ+XmJcWpIy/Yq2H09Bin58xuBWLcCkNgK1TlN4ZX4ifP4g1i00
         TWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OgFoj8A8iH+xHmxdpvqXBMUS1oxib043+v3N6AYNDEs=;
        b=cKQkms2oJMZnpXUkylrfRObjU3oQyI5rnOPxkp6qNcsXTqA1+zgT1eJgtiZca83Kw0
         dITJ9hBljmIJVi9Pjh4/p4U3Tlh8GM3AgbUme1ciN5gMhvou5kjrYVXpxWXn3VIqKo+1
         B60+mAX2V3E+Vvo03Rw4WbJGA6J60eWuGgaZMRaEN1SKEvDG1jGW0EKy9DtjaJwDgzym
         HtxrIJxz9EaHFqCqW1J79fMxG1sAgltIr71Ihz+/yEJNcbRhIcvgzbE20kEqlOcF0Ski
         GhOJFyKLpUZsawi177DyF5W3703XDKWrsrROScu79tauVS67AocJK0/lyNAWuYby/7D+
         t2eg==
X-Gm-Message-State: AOAM530tL9TeGvGfT3GaDwy94f/IMJZtqWnU/JJwp+Mrh9xMmcLmhGB1
        7FBx0yq5+uo2itFQTHMsKapu5h0+cA5cXe1GSzc=
X-Google-Smtp-Source: ABdhPJyXLchdXSWvR3e0BYha1dSL/cMPRj2jOrT8OesBcOuuXG8yixGN2aAbOwrRIqRGOguo0l07uU86WPFPAKfrbf0=
X-Received: by 2002:a25:538a:: with SMTP id h132mr2528613ybb.247.1610538477096;
 Wed, 13 Jan 2021 03:47:57 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Wed, 13 Jan 2021 19:47:31 +0800
Message-ID: <CAD-N9QUvu8D0qbdy6HqKfVF2Lu2Z+e7Huf_vpHumE=dhqfUGgw@mail.gmail.com>
Subject: KASAN: use-after-free Read in ath9k_hif_usb_rx_cb (2) should share
 the same root cause with "KASAN: slab-out-of-bounds Read in
 ath9k_hif_usb_rx_cb (2)"
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dear kernel developers,

I found that KASAN: use-after-free Read in ath9k_hif_usb_rx_cb (2) and
"KASAN: slab-out-of-bounds Read in ath9k_hif_usb_rx_cb (2)" should
share the same root cause.

The reasons for my above statement,  1) the stack trace is the same;
2) we observed two crash behaviors appear alternatively when you run
one PoC in its building environment multiple times. 3) their PoCs have
a really high similarity

If you can have any issues with this statement or our information is
useful for you, please let us know. Thanks very much.

--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
