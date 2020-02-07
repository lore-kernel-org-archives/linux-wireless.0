Return-Path: <SRS0=CI53=33=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBDAC2BA83
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 19:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 116C821775
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 19:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Li9E7GmS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgBGTlH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Feb 2020 14:41:07 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:38647 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgBGTlH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Feb 2020 14:41:07 -0500
Received: by mail-ua1-f66.google.com with SMTP id c7so279288uaf.5
        for <linux-wireless@vger.kernel.org>; Fri, 07 Feb 2020 11:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lHWgWJsBTDLmFelPvNCWY3Lq4TWNtA3yeQGevFzYeko=;
        b=Li9E7GmSCMT++ufkP9A1VOhbm/LC/Toya9EUUDgxF+Kkodah6A9Y+vRasVnhak9W/N
         UW8lj2cw0mknBtl9D97VTZ+x6lsoYH3BV1ib++8/BJftBXFKRKNiC8C8PsXCWBxoDYeD
         I0gg+iG3ju7cpQBkyI3wsDkFHP/30ByfL3sIjc4o+WG5a+F0GFVWLHp4Zgx7Wg9hnj3Q
         sYpQXV2qpvKn70u3qXcZ81aLVyjJaxUxQq1HgWrUoFKONDb4U0swTlJ10S1ECrmw/FMD
         AqsWUgBk6PNyjnGpE2dbTZfDSSIfJ6bojPw0Q0SnSBxyIuGAk+L6aIaZIwtI6e8DRf8W
         O5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lHWgWJsBTDLmFelPvNCWY3Lq4TWNtA3yeQGevFzYeko=;
        b=IYgT9+dUUm1tRxdpjSPSmdZgy9NXAyc4aK/btKmMxIZ5KyPo90frJNCj7u5KqWHQ6r
         wa6QEf6fnKyIzzh/vqBwavfJSVWdTXUoxE23S4AwwCt4rAiQWVm8iqs0cipNj2s9+Gbu
         P3kTnE8eFQ3dhrGbslt8ngCRsBayQ5kNPxktP1W6VY9OUbmldx8yNQpl55gYzl9bzJZJ
         wxKNWocdbk5eglImemUNIL+nu3Xcr1IuJpLN5biSchv67pa4KxAApzuNHZqi67YFui2C
         GFqQJ/QBi8xsVX5LLl6jxoCjyaVjmPXVln+1WS5lI9fEPodLaUxiZnCI4fGbBX8k5aCI
         4GpA==
X-Gm-Message-State: APjAAAX+Yj2uhn0i82XPullarjup/7Ixikh+xu29maHIE3zucFrDamh0
        sU62zvW3Ejowk8fDJaH6PkI0Z6um6eNJu6uSHCA=
X-Google-Smtp-Source: APXvYqy48iFpLXrhtF9c0E0LL5pMZ6CxswFitquISMIsUzXcWitdmUdu+sk5jNH0/6csdGh1FPvc/2oUHR96igNHIB8=
X-Received: by 2002:ab0:7653:: with SMTP id s19mr222454uaq.94.1581104465940;
 Fri, 07 Feb 2020 11:41:05 -0800 (PST)
MIME-Version: 1.0
References: <20200204120614.28861-1-yhchuang@realtek.com> <CAB4CAwdFez_WbRQb2jZQtqspSkO5ujL31ZLt4XshNcWiSqHByA@mail.gmail.com>
In-Reply-To: <CAB4CAwdFez_WbRQb2jZQtqspSkO5ujL31ZLt4XshNcWiSqHByA@mail.gmail.com>
From:   Justin Capella <justincapella@gmail.com>
Date:   Fri, 7 Feb 2020 11:40:55 -0800
Message-ID: <CAMrEMU_KJbwAK-onH0sRUgUPxDuZtD5bPJN6XmF=a9NqpfeJ+g@mail.gmail.com>
Subject: Re: [PATCH] rtw88: disable TX-AMSDU on 2.4G band
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Instead of permanently disabling could a module parameter or other
configurable be used? I appreciate the performance enhancements but
don't like the idea of disabling functionality
