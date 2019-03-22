Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAFDC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFC08218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lZsjegfr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfCVOgm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:36:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36763 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbfCVOg0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:36:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id y13so2640868wrd.3
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 07:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=brfv5UT05UhmleJgTjxmxXWvloFZXn+Xt2HH6mAqytk=;
        b=lZsjegfr+92RA7KFcs02UK3/Cl8CYKjdFMbo7854mtnq5TquJ3jO3DOVrAdCMohjDH
         WoLfBcNRrKkeas6nsVOhUM4d9qU5sVuj46q8jqLgZfEgETxg3J/j4s26Vv0L9kW+cZu2
         tkt32kKT3o/PN3oCEk/kfp3zTqwGU8uOxoABo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=brfv5UT05UhmleJgTjxmxXWvloFZXn+Xt2HH6mAqytk=;
        b=Itj0Z82wqTzqHy64sYhdr0nQbdCciWlBKxCz1zLR14R05Pm9y4CMZnjfSiRyNEAV2p
         T6V+v1Bb8NN8JSzSqEESHB9aYpk4sCpyyDtNhcCpsKVQgKUxCJ6VevLzpRzvxUOvWqgc
         f2K61ljHBV76BXR9+AJl2n2HBC0/hAb70aRwZlL03WomYoe/Bf8aMpwRU0H27m8xpVs3
         kVJAO2EKsLznZ/c7Gxru8YADWWjgP6OZhVDMUkSFDakxVVZPPGk9wjQuXE8AwYkMbG8K
         KycATjS9w0MSoH5WaerEYug1JPATgznjIMbH4OT5uZ7W4rc1u8/+MsqpCSMpOAzYoNJs
         5EUQ==
X-Gm-Message-State: APjAAAUg1iyBR6FlUkOqsbQhL7tVhUWOS1rxZ51yx/7KjXMw2hGjGBvj
        QFG+EoL+kI8rO/2WzsENHPYmFT7lw7GONg==
X-Google-Smtp-Source: APXvYqwIPveR8RcisvYEcveHZsebnJmIwe9EEVAKN9TPK/DjGjf8pwN0IbftgI76vEg9RgtkuyPLew==
X-Received: by 2002:adf:ea81:: with SMTP id s1mr6514610wrm.277.1553265384429;
        Fri, 22 Mar 2019 07:36:24 -0700 (PDT)
Received: from penguin ([195.39.71.253])
        by smtp.gmail.com with ESMTPSA id h10sm8272231wrs.27.2019.03.22.07.36.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 07:36:23 -0700 (PDT)
Date:   Fri, 22 Mar 2019 14:36:21 +0000
From:   Brian Norris <briannorris@chromium.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Grant Grundler <grundler@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 03/13] rtw88: hci files
Message-ID: <20190322143621.2rtyzysglv4fqocf@penguin>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com>
 <20190131223609.GA191502@google.com>
 <CANEJEGt4xJ5pTXgqazTVV2MNZy9+SWa6uE+wbE_94aT+FvL-+A@mail.gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AA49B@RTITMBSVM04.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17AA49B@RTITMBSVM04.realtek.com.tw>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

[Following up a little late on this one]

Hi Grant and Tony,

On Wed, Feb 20, 2019 at 11:19:10AM +0000, Tony Chuang wrote:
> > -----Original Message-----
> > From: Grant Grundler [mailto:grundler@chromium.org]

> > This is another bug in the code actually: the code accessing tx
> > descriptor rings should be declared volatile since they are updated by
> > the device which is not visible to the compiler.  Compiler won't
> > optimize (or reorder) volatile code (by "volatile code" I mean code
> > that is accessing data marked "volatile").

If I'm understanding the code correctly, the TX ISR assumes that
everything between the last entry we processed (ring->r.rp) and a
certain point (cur_rp) is complete. The former index was saved during
the previous interrupt and the latter is determined via a register read.
So assuming properly synchronized interrupts (such as with PCIe MSI) and
no device-/firmware-related ordering bugs, then I think we're OK -- the
only "volatile" piece is the register read, which already embeds
volatile in the IO accessors.

> This is fixed in PATCH v5. We reset and use rx tag to sync dma.
> So the polling can be removed and the bus timeout has not happened again.

Yes, I tested the later versions of this series, and I didn't see this
problem so far. I'll follow up there with my Review/Test information
eventually.

Thanks,
Brian
