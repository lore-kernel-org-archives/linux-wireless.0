Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7B5C5ACCC
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 23:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A93822148C
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 23:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="M9ASXLrB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A93822148C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbeJQHkJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 03:40:09 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38895 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbeJQHkJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 03:40:09 -0400
Received: by mail-ed1-f68.google.com with SMTP id c1-v6so23099635ede.5
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 16:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L20oBb+GTRAlxBhsQCOZ0ZfwFt4RyVEHkcClT6KSZms=;
        b=M9ASXLrBzHy7kk8zctLq/RrDOtSXJOqEO8iq10RNv40A2XdBfvigk4Jfs/rq4Fjz7d
         7H5apakEwTHlvamo5V9UFlHkWUBQ/IoFgw7FZ7K76gccqehHuUrVVWRC8RkbGNY0atYY
         O1+xmayMMJnb9OB92NFwke6uwaF57tqECbbsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L20oBb+GTRAlxBhsQCOZ0ZfwFt4RyVEHkcClT6KSZms=;
        b=LrBMi7FOGbb+dSAAnhMBVDtELm/vcVtSyozAhLaMcTluBuD4uLP7pjg+jAq7aFWrrD
         QLCNvhTHPpvC14RWBHVztPFsq0dqstLmzz0WH9MY8txbh2flHvcC328Fm64gAPkdTeKM
         ReE2RmwITjFxpSdtuqiGiXdqbBMLt6XaiIzxcT2sgPR+bOlcdrylLuj+QHiz4twQO5kn
         zmRZiBUI0X4UX9IdrtZ9zXslwC+Aklr7Gidldjk+YxugOhZVNoG5NRruM5EIz+Zjjpmh
         NfHM9HskrBhCYLz7wq6O1VGuK5hD/6AMkcTc+mpfmiGx7U5Q0zf1MysvXPDXbU8Zxjiz
         w7Ng==
X-Gm-Message-State: ABuFfojTtgD0iLlffjVtrkQO+q80r7Z/BOsl0xQJT7NhAH9MS4Ej+6Yl
        EzCA78K+RedbeHXUnXudzi23PNX7BL8=
X-Google-Smtp-Source: ACcGV62iH72dEKMVUnLNgY6CE9NopA7/w0gLwiqKy9hnbWGU1MqNNIJA5QnMiYg7J3fO0jN7SCOEzg==
X-Received: by 2002:a50:91ad:: with SMTP id g42-v6mr33106094eda.43.1539733639158;
        Tue, 16 Oct 2018 16:47:19 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id x15-v6sm7004396edm.26.2018.10.16.16.47.17
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 16:47:18 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id r1-v6so23098360edd.7
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 16:47:17 -0700 (PDT)
X-Received: by 2002:a17:906:1f87:: with SMTP id t7-v6mr25479858ejr.153.1539733637583;
 Tue, 16 Oct 2018 16:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20181013005504.46399-1-briannorris@chromium.org> <CAD=FV=UmvnsueUbDTa-vSp5Ay+8Zo0YORW8T7u1AwreUbZA4+Q@mail.gmail.com>
In-Reply-To: <CAD=FV=UmvnsueUbDTa-vSp5Ay+8Zo0YORW8T7u1AwreUbZA4+Q@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 16 Oct 2018 16:47:05 -0700
X-Gmail-Original-Message-ID: <CA+ASDXO6PMudAkt0BTXRh8GjmheYvge+smYdr-n=pdBP5swJrA@mail.gmail.com>
Message-ID: <CA+ASDXO6PMudAkt0BTXRh8GjmheYvge+smYdr-n=pdBP5swJrA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ath10k: snoc: remove 'wcn3990' from generic resource handling
To:     Doug Anderson <dianders@chromium.org>
Cc:     Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, govinds@codeaurora.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 16, 2018 at 4:43 PM Doug Anderson <dianders@chromium.org> wrote:
> On Fri, Oct 12, 2018 at 5:55 PM Brian Norris <briannorris@chromium.org> wrote:
> >
> > ath10k_wcn3990_clk_info and ath10k_wcn3990_vreg_info are not
> > WCN3990-specific structures. They hold generic data. So don't name them
> > with wcn3990 specifics.
> >

> > -static struct ath10k_wcn3990_vreg_info vreg_cfg[] = {
> > +static struct ath10k_vreg_info vreg_cfg[] = {
>
> Ironically, you could sorta make the argument that this should be:
>
> static struct ath10k_vreg_info wcn3990_vreg_cfg

Hehe, good point.

> AKA the "wcn3990" shouldn't be in the name of the structure (since all
> snoc devices can have the concept of an array of regulators) but
> wcn3990 could be in the name of the variable since it's possible that
> different snoc devices could have different arrays.  However I'm OK w/
> waiting to do that part until we actually see a different snoc device
> with a different array.

But I think that is a pretty reasonable conclusion.

There's still some other strange stuff in this driver too, like the
fact that this is NOT a const array -- we assign things dynamically to
the regulator fields within the array -- that we would probably want
to fix if this is really supposed to be a generic multi-IP driver.

> Reviewed-by: Douglas Anderson <dianders@chromium.org>

Thanks,
Brian
