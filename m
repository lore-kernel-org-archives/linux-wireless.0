Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8141C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 19:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 960CD20835
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 19:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AR3LlDMN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390277AbfBMTWO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 14:22:14 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41619 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731511AbfBMTWO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 14:22:14 -0500
Received: by mail-ed1-f67.google.com with SMTP id x7so2925341eds.8
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2019 11:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ssCdifowv/Nk6RzFh72YkBwhu6Woml4BTntZg65Iaeo=;
        b=AR3LlDMNfK52H6hE1BIg4IasxwOvk1EXZEVFok7LBt2QRAGYdfOchh1KgIyYzDh3O3
         JDK9LyvrHEvEW/Qk7WgouyTPKuHM6JCYKUh5uLo4Kc3arP8LbxLAL+0t4p9AEqQP9YEv
         aFO/eGx2ScElmkT4UFjAUT7Zad4XrVxl9tLgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ssCdifowv/Nk6RzFh72YkBwhu6Woml4BTntZg65Iaeo=;
        b=YS+KfHQBea55pZVc3fpQTfKY9uYiL7q1acT0rXbTLBfyl9qp/8T2PsLQQQUh69PkiJ
         4u5AdUGSeqBxbNOJPMxlfBHDn0isNnMuhEWnSrHichd85hrEe03qn/9yoszE7rXIvndJ
         hrHlYYOdHyCOLRh1QhY+OzqRmC5cm2cn1oOUqnWx9Fg76jlzPGrcQZMfp94En/OZzHqp
         VWdzzThdkyeLtPubwf+zgFryNsjECq34ZXJhP8ucHUWzbsilX+yx3ctsj1vES/xuGKvx
         o44y3Nns+7ywsWvF2+C2n+cf3aISy/Wi0GXk8XiWkRAdAu+7UvYSiC4mNbqm5CE5N2jT
         rrIg==
X-Gm-Message-State: AHQUAuZyBXLhw2YpVK5U1on9mxb+exTyt5wwiM2E5/uhqeQ3QZeQjSoR
        S2ZsH2PCbntHa5lytn6zeXpd4uHcgmI=
X-Google-Smtp-Source: AHgI3IYl0okXpfTN40Mvh6VNIqv9rynuGS/HBtStnj2dSLbqU7M94LW7rpKkKr7JHYOh1qPUqFLdVA==
X-Received: by 2002:a05:6402:1506:: with SMTP id f6mr1666536edw.288.1550085732290;
        Wed, 13 Feb 2019 11:22:12 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id v11sm29627edy.49.2019.02.13.11.22.10
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 11:22:11 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id x7so2925223eds.8
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2019 11:22:10 -0800 (PST)
X-Received: by 2002:a17:906:358e:: with SMTP id o14mr1522802ejb.212.1550085729796;
 Wed, 13 Feb 2019 11:22:09 -0800 (PST)
MIME-Version: 1.0
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com> <20190131223609.GA191502@google.com>
 <F7CD281DE3E379468C6D07993EA72F84D17A3A5E@RTITMBSVM04.realtek.com.tw> <F7CD281DE3E379468C6D07993EA72F84D17A5B7D@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17A5B7D@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 13 Feb 2019 11:21:58 -0800
X-Gmail-Original-Message-ID: <CA+ASDXN5WadHo5ZQ1cr_Xy50UQAVEdAo+w74wUUOvvpp_rnpJQ@mail.gmail.com>
Message-ID: <CA+ASDXN5WadHo5ZQ1cr_Xy50UQAVEdAo+w74wUUOvvpp_rnpJQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/13] rtw88: hci files
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 13, 2019 at 3:08 AM Tony Chuang <yhchuang@realtek.com> wrote:
> > On Behalf Of Tony Chuang
> > > From: Brian Norris [mailto:briannorris@chromium.org]
> > > Do you have some kind of memory mapping/ordering issue or something? I
> > > wouldn't think you should expect to just drop packets on the floor so
> > > often like this.
> > >
> >
> > Looks like the cause is that the DMA might not have done when the interrupt
> > arrived. Need to do more test to figure it out.
>
>
> I tested and checked again. I found that I didn't enable DMA sync for
> the TRX path. After some work it can be resolved if I turn DMA sync on.
> So I will include this in the PATCH v5.

Great! I'd also highly recommend dropping that loop. It just pretends
to do something that it doesn't really do. Leaving a single iteration
as a sort of debugging check is OK, if it's truly a bug any time we
fail it.

Regards,
Brian
