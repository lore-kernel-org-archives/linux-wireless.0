Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BE1ECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 22:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A90FD20854
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 22:10:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="G6s8lsHa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A90FD20854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbeJYGkZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 02:40:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42036 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbeJYGkY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 02:40:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id f26-v6so3110889pfn.9
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 15:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+baQiYxjI40nxslAaaoB5lHy2HpqgfpBFUHPlxw7kMI=;
        b=G6s8lsHaLteOxOniK/qym6IXkFaFZATr0LK7EYFe9WJDBWhBEY6V7OmlUTkw5DJLpB
         qdee/bM4I2oWXWsTu12uNeoieSxCKRLdvVLgell8xDzd4Ssf/G/kSgieN4Tkypg+jYS+
         7Ajw80fhcVoN69dLeOvt967EekvjFoTF/yBc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+baQiYxjI40nxslAaaoB5lHy2HpqgfpBFUHPlxw7kMI=;
        b=lHEvzPviFtlARteTkkoTa/kK2oZKsMD1/iVMVKyUfolSHYjRUgY3JSsKITKL3wK2JW
         Dou5DCTJBP7BbTYBzz28Tffr7rjnYDBlkyDML8YHmVf1HQeTCvUs/l3Uj8yVLLfWQyV1
         XjXpg7Uh7hVvJkkBrD/7RE8REzspAJW/qK2Y9M9oIjutNtZHfcirS31DvLQVwZdCveFA
         XB0Pnm+a8iFWhFyWnUi89dq1rQouthUdDBUmcPDRYhrs9AipaW6EpbpuZW0h12DSKoh0
         FXDu1rvVimvioPVjuQ/YpkCu/WGiGHzg+f9uqF94LeOb9Ac/S5UsMFc6hfcskpeRQi9y
         +DZg==
X-Gm-Message-State: AGRZ1gIgX6FTDRK3ZdHhZu+Tq7P7nI79oCtYU9zXBSVy6iUA/DTwF2hj
        tuCVlePtktuUfyGXhLLG5o5A1Q==
X-Google-Smtp-Source: AJdET5dcKfN6k+vuQ/Je/Ckt7UPlbGKlpJdQdJU5BsZhJgCR9BvYnKtvX5c7P2k2PJaDMz2tgSONmw==
X-Received: by 2002:a63:2356:: with SMTP id u22-v6mr4128873pgm.122.1540419033329;
        Wed, 24 Oct 2018 15:10:33 -0700 (PDT)
Received: from rodete-desktop-imager.corp.google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id m18-v6sm7534709pfk.149.2018.10.24.15.10.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Oct 2018 15:10:31 -0700 (PDT)
Date:   Wed, 24 Oct 2018 15:10:29 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ath10k: snoc: fix unabalanced regulator error
 handling
Message-ID: <20181024221028.GA44244@rodete-desktop-imager.corp.google.com>
References: <20181013005504.46399-1-briannorris@chromium.org>
 <20181013005504.46399-2-briannorris@chromium.org>
 <CAD=FV=U0uK25mL9_d1nVB7uBV+vR9YTqGm1iTQgzdNuZO5O5_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=U0uK25mL9_d1nVB7uBV+vR9YTqGm1iTQgzdNuZO5O5_A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Thu, Oct 18, 2018 at 10:54:39AM -0700, Doug Anderson wrote:
> On Fri, Oct 12, 2018 at 5:55 PM Brian Norris <briannorris@chromium.org> wrote:
> > +       if (vreg_info->settle_delay)
> > +               udelay(vreg_info->settle_delay);
> 
> Not new to your patch, but this seems like a duplication of what the
> regulator framework is doing for you.  There are plenty of regulator
> properties describing lots of different types delays and that would be
> the place to put it.  Doing so makes it automatically easy for boards
> to specify a different delay if they have different ramp
> characteristics (like someone put a bigger capacitor on the line or
> somesuch).
> 
> At the moment it would be easy for someone to submit a patch to kill
> the settle delay in this driver this since the entire vreg_cfg table
> has 0 for the settle delay.

Thanks! I'll probably take a stab at killing the excessive
specifications in these tables, in a later patch. Would be nice to get
the bugfixes landed first though.

> > +static int __ath10k_snoc_vreg_off(struct ath10k *ar,
> > +                                 struct ath10k_vreg_info *vreg_info)
> > +{
> > +       int ret;
> > +
> > +       ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc regulator %s being disabled\n",
> > +                  vreg_info->name);
> > +
> > +       ret = regulator_disable(vreg_info->reg);
> > +       if (ret)
> > +               ath10k_err(ar, "failed to disable regulator %s\n",
> > +                          vreg_info->name);
> > +
> > +       ret = regulator_set_load(vreg_info->reg, 0);
> > +       if (ret < 0)
> > +               ath10k_err(ar, "failed to set load %s\n", vreg_info->name);
> > +
> > +       ret = regulator_set_voltage(vreg_info->reg, 0, vreg_info->max_v);
> > +       if (ret)
> > +               ath10k_err(ar, "failed to set voltage %s\n", vreg_info->name);
> 
> Not new to your patch, but ick, forcing someone to manually set the
> load / voltage of a regulator that they've turned off is silly.  It's
> only list to try to send a patch to remedy this situation.  Let me try

I'm guessing you meant:

s/only/on my/

> to put that higher on my plate.
> 
> 
> ...just like with the clock patch I suspect that some of this is
> duplicating the "regulator_bulk" APIs.  ...though I guess maybe we
> can't use those too easily until we can avoid setting voltage and
> current so much...  In any case, your patch overall looks good and an
> improvement.

I'll admit I've never used the bulk APIs. But I might give them a try as
a follow-up cleanup. (As before: would be nice to have the simpler
bugfix first.)

> Reviewed-by: Douglas Anderson <dianders@chromium.org>

Thanks,
Brian
