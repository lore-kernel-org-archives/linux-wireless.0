Return-Path: <SRS0=Fczi=EE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3605C55179
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Oct 2020 17:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 462C420720
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Oct 2020 17:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D/YOni6i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgJ2RmW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgJ2RmS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Oct 2020 13:42:18 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4C0C0613D2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2020 10:42:18 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id z2so3855690ilh.11
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2020 10:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DaqhxLdFqboQ1Cvq3lJOUqwLA0L7wq5AZx17hyccx7U=;
        b=D/YOni6i+SOEMGJhjccQ/tYv07ugHo/a288VcVxABe8ketBPMA05wQhyAn5UWmowlv
         Ov8ngzvYLscM/Gac7YNEoxEdcWFSaTG2cWYY8i+cL5kpNPQxkPu/Mod3gxODzvSSYwxo
         6HGPMjmCAWzcEXWorpmyZobi4TjER07DsVQKrkfgw47xeHXWvW0+yhZv5sbHs4MB11Uk
         XAuskQ108MQ3Dpu347lez0725gVlnOfOxIJ1xYDKWxot9cpB0Lfy2FEoW//ijvQ4OMma
         s1qtEQiTExJ3nPXtS5Lk7cpl9Wx/EDisNN5kIGe8oSHdYrmKEmYDC9vEF3V2lREWs4LR
         Wyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DaqhxLdFqboQ1Cvq3lJOUqwLA0L7wq5AZx17hyccx7U=;
        b=UGGXM2NWyD5lErjG4rtgADDcFIPd+OY2n6/XqeDOvP4DAXgBrr+Whhjo8MMp8jWGm3
         Mcz40ZZB/kackQWYekIXiCGcombIYLCZx4gyz2+dZ30Ij5S9RH1mnv0RU64muQuGCe4y
         u5Bmn+lQvjAtcFMmJXKp4cGwDMPrjVdhkMMPkJ8WeW8DzA/lVfjmthOhrgI/c+v4NZ70
         Hh6eB9RVCvPa2QhsHucuTMQiC2Likzo61IYfQLdu+9KThwtOWTfKU/6mv2GBxhcwELTT
         0Lr48gE93JryPUOi5hxxhhM6b5dw/CzVuBbbPxpYPj8Da0i97sACfkbDsCxJ088hTyQ3
         IJGA==
X-Gm-Message-State: AOAM5308Rr5CjkRvVdAjK4+cGhs829BHs6vcEhl1WIyxdsFdSf1piHW2
        smTQoEV3J/Tf9spiHDeKd+NA89k3hs6l2b0Sc4YGbA==
X-Google-Smtp-Source: ABdhPJzV8j5Is77RPsNbsO/SbOMiMpJ4g8o+vmeiTZ44JdeOMlJA25/Y+9rG9ZqYZEWfWdb/E9UcW9ZUDoOVTZWmhTk=
X-Received: by 2002:a92:dc52:: with SMTP id x18mr4303964ilq.134.1603993337307;
 Thu, 29 Oct 2020 10:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201028182018.1780842-1-aleksandrnogikh@gmail.com>
 <20201028182018.1780842-4-aleksandrnogikh@gmail.com> <5d1e166e32cd8263787764b7c7fe64b24cacb2a6.camel@sipsolutions.net>
In-Reply-To: <5d1e166e32cd8263787764b7c7fe64b24cacb2a6.camel@sipsolutions.net>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Thu, 29 Oct 2020 20:42:06 +0300
Message-ID: <CANp29Y6hyz7xQi=7OG3CBAS0vMQ98S1=H4ZQK9socNUeY_XiKA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mac80211: add KCOV remote annotations to incoming
 frame processing
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 28, 2020 at 10:25 PM Johannes Berg
<johannes@sipsolutions.net> wrote:
[...]
> Wouldn't it make more sense to push that a layer down
> into ieee80211_rx_napi(), or actually now perhaps even
> better ieee80211_rx_list(), so we get it even if the driver called that
> API in the first place?
>
> You might only care about hwsim at this point, but perhaps hwsim would
> get optimised ..

Yes, ieee80211_rx_list() seems to be a reasonable place to move these
annotations to. Thanks for the suggestion.

I've incorporated this change into v5:
https://lkml.kernel.org/r/20201029173620.2121359-1-aleksandrnogikh@gmail.com
