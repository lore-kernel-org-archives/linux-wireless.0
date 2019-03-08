Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B96FC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 18:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D31AB20857
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 18:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Wk/DNF1z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfCHSoK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 13:44:10 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37522 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfCHSoJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 13:44:09 -0500
Received: by mail-lf1-f66.google.com with SMTP id u2so8015363lfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2019 10:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ni4GW8IVtQr7JfF2dHFK5sl79sLbNta6t5jcmw6I1E=;
        b=Wk/DNF1zEJAfeFrzbb/ZRXROG5FpJEAFj5h+nvUkq3+Sccs6MbVbFro7iT9UlQ51/Z
         tBEY08h0Q34uJWQwRUSOKK76qjhksfYuOv0eeOPuw9vC9N6IvCE+uc0Re4HmFOuOirt1
         52zk1ffJ3PSCSwwWth6Y2mLLmqmnvl54ZRxCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ni4GW8IVtQr7JfF2dHFK5sl79sLbNta6t5jcmw6I1E=;
        b=QmceOqUkzqlVEEdGxXUOSVhkdbAJqb1iJDdWKBLVQ2sSlaqHztX3w002EGBTb4TP4r
         RUyEucp1jmMifxpiDSymCeywNrQ8CWvLvFeNag9tw6X+17c0MngLcUSuvk0qzuh845x+
         65FwGPL2D1/c01pcu80otj7rrYCHPbMmSWaXQpLRRvrcGOKXojEMg6+ZmoGXRobDIwc6
         BYZBHI3ouBp4Z+Pr0+aEdy8PU4LPMaz5yLpMaxNPFq2cihVb06Lkku5/ErMqy2DhBDp0
         pZWbo2Q/rx3rHwuYwHJCaLaw7Y6OVwtxBsQOm7oRSPQUnqnPy+ckhvPccXgvAuZz9HFG
         Psaw==
X-Gm-Message-State: APjAAAWWsVBdJl+LmkueVVpSPTn28FK4UJkUqc3ZXWPNTJkW3NuJuoXk
        Tp0rWHXts9gCX6KavDaoF/y0AkNP52o=
X-Google-Smtp-Source: APXvYqyp4vEXl0KdwR7pKCjdFapmgWeTw2doDsc0LG7FHedNQSSg9z6pBj96seKv3GUnrXV2do0hzQ==
X-Received: by 2002:ac2:53ab:: with SMTP id j11mr10851195lfh.49.1552070646521;
        Fri, 08 Mar 2019 10:44:06 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id 5sm1695451lje.18.2019.03.08.10.44.05
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 10:44:05 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id g12so14946115lfb.13
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2019 10:44:05 -0800 (PST)
X-Received: by 2002:ac2:51db:: with SMTP id u27mr10665957lfm.36.1552070645270;
 Fri, 08 Mar 2019 10:44:05 -0800 (PST)
MIME-Version: 1.0
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AE4FD@RTITMBSVM04.realtek.com.tw> <87a7i58xag.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a7i58xag.fsf@kamboji.qca.qualcomm.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 8 Mar 2019 10:43:53 -0800
X-Gmail-Original-Message-ID: <CA+ASDXOt3XvHnpkugiX4wRN7MdEh2EJaywABnpzTSr4O6p1xsw@mail.gmail.com>
Message-ID: <CA+ASDXOt3XvHnpkugiX4wRN7MdEh2EJaywABnpzTSr4O6p1xsw@mail.gmail.com>
Subject: Re: [PATCH v2 00/24] rtw88: major fixes for 8822c to have stable functionalities
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 8, 2019 at 2:40 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> Once everyone are happy about the driver, at least it needs a review
> from Johannes and me but reviews from others is more than welcome. I
> also saw that Brian gave good comments but not sure if he thinks the
> driver is ready for upstream?

I still have it on my plate to take another look-and-test at this, but
I don't think that should stop you or Johannes from looking. At some
point, if there aren't major structural or conceptual issues, it makes
sense to merge and iterate.

I'll try to get to it within the next week if not sooner.

Regards,
Brian
