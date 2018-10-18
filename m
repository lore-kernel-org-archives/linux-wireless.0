Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866A8C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 18:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DD1F204FD
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 18:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WkFsgM1s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DD1F204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbeJSCQg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 22:16:36 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41298 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728618AbeJSCQg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 22:16:36 -0400
Received: by mail-ed1-f67.google.com with SMTP id x31-v6so29112931edd.8
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 11:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A/KKEfRpKBVdzt6/ZEwYkUdKLNjVwawVsMGIlUz+JNA=;
        b=WkFsgM1sgGWP5YP7TdcwwevSBsHV1XUdfK8tEBKbWMTJM0GOQj1zHhVGtKrG1Euvl/
         OzBzTuq7oQ1kyrCs2atG18BfV4Odxy1od2UUIpn9D3m5IAcVYGkdZS0lb+0fINvcL7yp
         mCL8xucAnJqhFlNsRvoh7R7uuzMCCyll1PTPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A/KKEfRpKBVdzt6/ZEwYkUdKLNjVwawVsMGIlUz+JNA=;
        b=lWb+h9l4KZ0/jBvFfyTQvIMgVNIPwf/tXME0ecelYPQIUlApcDd4YNNn82pTEpuX47
         wdiZm9RG2zEqtoHwQ19YwITlaPfq4KvBUw3BwVY1/zNhuL/CZ3kStT3evXuI0q3IxNze
         4jU0MIqb5t8/hUILIwin7urk83q0wE+w/ZggvdWJATbFV57R+5e2raboTP4y6Oveh0O0
         dXgDwIqi+wtImur1WHXueAQtTqwNsJ2Y66bFi5Fh/h0XAbGcm8Bz1b/gc3ByAtnw7U5S
         WrjQof/DrCOUDzENnyM7qGa5z3n0eG4IvZohQBR+hb5b9l3MaPR78Sm90w3Iyta8oYT6
         emtg==
X-Gm-Message-State: ABuFfohK/m1iZjBPQTLe50sHViqlo9SDeJeEm0euJ2UbL+AgfSRqlyVI
        LVFrhGDkkL/2drlRun4Dp4Rr7N4aowk=
X-Google-Smtp-Source: ACcGV61GVQ3JmTRvNQNUsuGSTaCWZ0BQeFmw35RrVJhLB6U1WCQKF56BIzjrz2MocWUotvGTdm5DsQ==
X-Received: by 2002:aa7:d9cf:: with SMTP id v15-v6mr4001426eds.25.1539886465352;
        Thu, 18 Oct 2018 11:14:25 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id g13-v6sm7840810edv.48.2018.10.18.11.14.23
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 11:14:23 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id r1-v6so29142565edd.7
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 11:14:23 -0700 (PDT)
X-Received: by 2002:a17:906:1f87:: with SMTP id t7-v6mr29472685ejr.153.1539886463151;
 Thu, 18 Oct 2018 11:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <20181013005504.46399-1-briannorris@chromium.org>
 <20181013005504.46399-3-briannorris@chromium.org> <CAD=FV=VvaNTqEEC8XuOZ4ekNtPaj-KO3WdENQ6evweMjp8yoew@mail.gmail.com>
In-Reply-To: <CAD=FV=VvaNTqEEC8XuOZ4ekNtPaj-KO3WdENQ6evweMjp8yoew@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 18 Oct 2018 11:14:11 -0700
X-Gmail-Original-Message-ID: <CA+ASDXM0K3dVxg-Q5gJFOQkciLo424p2HtoYgu=AYYCRBfrnCQ@mail.gmail.com>
Message-ID: <CA+ASDXM0K3dVxg-Q5gJFOQkciLo424p2HtoYgu=AYYCRBfrnCQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath10k: snoc: relax voltage requirements
To:     Doug Anderson <dianders@chromium.org>
Cc:     Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, govinds@codeaurora.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        swboyd@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 18, 2018 at 10:56 AM Doug Anderson <dianders@chromium.org> wrote:
> On Fri, Oct 12, 2018 at 5:55 PM Brian Norris <briannorris@chromium.org> wrote:
> >
> > I rarely see drivers specify precise voltage requirements like this, but
> > if we really have to...let's at least give a little wiggle room. Board
> > designs (and accompanying device trees) may not provide exactly the
> > voltage listed here, and we shouldn't fail to probe just because of
> > this.
> >
> > Round these ranges down to the nearest volt, and provide a 0.05V margin.
> > The regulator should provide its own supported ranges, which will
> > helpfully intersect with these ranges.
> >
> > I would just as well remove these ranges entirely, but if I understand
> > correctly, there's some reason that QCOM SoC's like to set zero /
> > non-zero voltages.
>
> Yeah, I'll try to up-prioritize working on making that better
> (assuming others like my ideas in that area).

Ah, OK, so my understanding is correct? (I feel like I've bumped into
this multiple times, but it probably didn't stick because it makes so
little sense to me.)

> >  static struct ath10k_vreg_info vreg_cfg[] = {
> > -       {NULL, "vdd-0.8-cx-mx", 800000, 800000, 0, 0, false},
> > -       {NULL, "vdd-1.8-xo", 1800000, 1800000, 0, 0, false},
> > -       {NULL, "vdd-1.3-rfa", 1304000, 1304000, 0, 0, false},
> > -       {NULL, "vdd-3.3-ch0", 3312000, 3312000, 0, 0, false},
> > +       {NULL, "vdd-0.8-cx-mx", 800000, 850000, 0, 0, false},
> > +       {NULL, "vdd-1.8-xo", 1800000, 1850000, 0, 0, false},
> > +       {NULL, "vdd-1.3-rfa", 1300000, 1350000, 0, 0, false},
> > +       {NULL, "vdd-3.3-ch0", 3300000, 3350000, 0, 0, false},
>
> These look fine to me.  I find it really funny that this array has all
> those load values and they're all 0, but that's not new to your patch.

Indeed, funny. It's also funny to have that 'required' field, which is
all 'false' -- but that kinda goes to your binding review too: there's
an overabundant use of "optional", to avoid defining real requirements
on a per-IP basis.

Brian
