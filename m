Return-Path: <SRS0=nAss=VM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED4DC7618F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 17:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 238592081C
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 17:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fD8XCw8k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbfGORLt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Jul 2019 13:11:49 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42259 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730782AbfGORLs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jul 2019 13:11:48 -0400
Received: by mail-lj1-f195.google.com with SMTP id t28so17030143lje.9
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jul 2019 10:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uBujI1LKsX+AicedaFrnsmqG4PdfJMOQIXaxCHAk4rY=;
        b=fD8XCw8k14IG7/yHaD+7mShpN5sKbB7DZx3cF5z8gOZlO6SjOe+uT2FL9cQMzzMRLP
         EuvXLscSX10HBL36Eu3myWNqmswQPNMoWaQKyd+DDcssimLJ46siZRUSwZhNxnZ93/j3
         NWcMN6jC2tKHUi6NVcO4c2bxuH9Nb7Q895XbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uBujI1LKsX+AicedaFrnsmqG4PdfJMOQIXaxCHAk4rY=;
        b=WWZ9b6kc8WmGdgcsQHeRXHjziHCf+xm7gA2IcChBZvSTQkuphYgfbhW5qN76KWTRWl
         k4nCrkBoMPivb0sxeLZAEL+q0BQ+T+Y64MSYYMxP7dqHjBI9kTbBQYbX50RFwjLCX0LL
         9JwB4W/XTp35dwkYiV2sYMMJf/oNUY56DNvQMml2Yx4OP2ULQNB5S1PQ+iG2A3E8++SQ
         JKxKfyLemK1KB7Lg4D5cNza984W7kF5Tp9aU6lJ90UbJvvhz0HYd+HtsXUdQcZBNBE12
         ANdT/e3bQmDqtRgWfZ2ZXtkdxZwsGEd2ArugQAnE6ZniXtpxqTXHJu4bH523P25b52CH
         1tMw==
X-Gm-Message-State: APjAAAV/ydLl92Nnar2NJPTgzTOwOn1lUjozwtDgW3iBdZOVOQ8AGx3A
        oJj1Gies7wlps8rHnMNsRbOECOnrc0A=
X-Google-Smtp-Source: APXvYqygsdJpUK3gVVc9Msm7Q7bEAB5JZ5P2Pq4e7BDXwevxnWDOdZaM5WSIGL5wgI2oefCqayJQNw==
X-Received: by 2002:a2e:9cd1:: with SMTP id g17mr15076849ljj.234.1563210706651;
        Mon, 15 Jul 2019 10:11:46 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id h78sm3250921ljf.88.2019.07.15.10.11.45
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 10:11:45 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id v18so17030476ljh.6
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jul 2019 10:11:45 -0700 (PDT)
X-Received: by 2002:a2e:b0e6:: with SMTP id h6mr14180325ljl.18.1563210704749;
 Mon, 15 Jul 2019 10:11:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190713013215.215008-1-briannorris@chromium.org> <F7CD281DE3E379468C6D07993EA72F84D1867CEE@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1867CEE@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 15 Jul 2019 10:11:32 -0700
X-Gmail-Original-Message-ID: <CA+ASDXN6UPMR8bSyuzHxt-HDiFcV=dH3ikdyKKftn-dyFUJuaw@mail.gmail.com>
Message-ID: <CA+ASDXN6UPMR8bSyuzHxt-HDiFcV=dH3ikdyKKftn-dyFUJuaw@mail.gmail.com>
Subject: Re: [PATCH] rtw88: make functions static
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Jul 14, 2019 at 7:24 PM Tony Chuang <yhchuang@realtek.com> wrote:
> I am sorry I have to NACK it.
>
> Nothing wrong about this patch. Because in the last patch set I sent has
> 11 patches, but one of them is not applied by Kalle.
> And I am going to resend it, which will use rtw_get_tx_power_params
> in debug.c

I suppose that's fine with me. I've marked it as Rejected in Patchwork.

(Normally, I would say: it's your fault for leaving these things
unused. But it was in the middle of the series, where you were aiming
to start using it by the end.)

It would still be nice to see the promised v2:

https://patchwork.kernel.org/patch/10966403/

Regards,
Brian
