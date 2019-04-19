Return-Path: <SRS0=g+pd=SV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D410C282E0
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 21:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D808D2171F
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 21:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WhY6Pa8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfDSVB1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Apr 2019 17:01:27 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45940 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfDSVB0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Apr 2019 17:01:26 -0400
Received: by mail-lj1-f194.google.com with SMTP id y6so5536408ljd.12
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2019 14:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aff91PpYlqDIAvuCCF/vRKFun+5OfLrLU4Sj9Dku07s=;
        b=WhY6Pa8eogNHdM5esPZlyg6UqYtAq7DZxQ2tMSbXOq4cCRiGKdGAuxWhm391rzAspQ
         C9l5PFhyoe5jeuqB4KNtUvGv4+f1DfLMS11EwW/6upZ7/FSkJZTkr7h4unmctQDvHUxI
         XTDOoSgXzxGxZflu2KzhUgLa6VwzD5/Pr3d04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aff91PpYlqDIAvuCCF/vRKFun+5OfLrLU4Sj9Dku07s=;
        b=Dn6aAzLIPKcMx40jQayWiL6ggpxPLs5bCOMmMq628bydSlUofdX7f3NBsEF0wqSNIr
         jdQRKLnfb74TAkCvVHDrJhjHY2F7xp4H3vHCgBs/2UXOrgc4XR3RyGBBpQMrHIx+PuBI
         fv1AbaDU8a7RzRlcM7UhTcBZFEdc/iORsLEpFFGP0cF3PaLSb+OP2A6ht5zwh32Cyy7K
         iQZBjadC0ZF2Upy03pbOCdWE9rpd9oQi5V0Q/u9FjLxulw7S5xWezmXQW18rZIxs3yrR
         Ozf3FwmUMlUYjrZCp6/kwsxP51MCKYgpAl7EwXy3q+tCcGCc/sVgMWTNO2kPN3fHAIvr
         cbTA==
X-Gm-Message-State: APjAAAUSQHo8REe4tzE30d9AGiMPbLKpOzYslN3PyhZ47GAIZJkpeSQy
        zQ9p2jj7OFtKwgSzJ1VPxAEh9KGTOgA=
X-Google-Smtp-Source: APXvYqyfsuDFFTEvnjU72vK6UrhqoNAU2HTGwT0uwIQZawB1730jd7GVn81TR7AnDYqaRlxTr5hbAQ==
X-Received: by 2002:a2e:8719:: with SMTP id m25mr3464053lji.50.1555707684469;
        Fri, 19 Apr 2019 14:01:24 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id t206sm1372141lff.21.2019.04.19.14.01.22
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Apr 2019 14:01:23 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id q66so5566096ljq.7
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2019 14:01:22 -0700 (PDT)
X-Received: by 2002:a2e:3506:: with SMTP id z6mr3325847ljz.72.1555707682372;
 Fri, 19 Apr 2019 14:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
 <20190325143611.sjwwjqtrftxntwyk@penguin> <20190326075414.GA8598@redhat.com>
 <CA+ASDXNcCNcBmiHi468p1foWgSOXy9Mt8o+CD17Bd4PqhUXFoA@mail.gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17CB940@RTITMBSVM04.realtek.com.tw>
 <20190327102623.GA20943@redhat.com> <F7CD281DE3E379468C6D07993EA72F84D17D50A4@RTITMBSVM04.realtek.com.tw>
 <87zhp0g2a5.fsf@codeaurora.org> <F7CD281DE3E379468C6D07993EA72F84D17D6AD6@RTITMBSVM04.realtek.com.tw>
 <87ftqf2za7.fsf@kamboji.qca.qualcomm.com> <F7CD281DE3E379468C6D07993EA72F84D17DE448@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17DE448@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 19 Apr 2019 14:01:10 -0700
X-Gmail-Original-Message-ID: <CA+ASDXM7pT9h1sAdhbA8Np+dOKKpq2MLh=0w11MOE3cwqea6ag@mail.gmail.com>
Message-ID: <CA+ASDXM7pT9h1sAdhbA8Np+dOKKpq2MLh=0w11MOE3cwqea6ag@mail.gmail.com>
Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Apr 19, 2019 at 1:23 AM Tony Chuang <yhchuang@realtek.com> wrote:
> > -----Original Message-----
> > From: Kalle Valo [mailto:kvalo@codeaurora.org]
> > Please submit a new version with the new license. But don't any other
> > changes than change the license and possibly remove the default line in
> > Kconfig.
> >
>
> Hi Kalle,
>
> I have sent PATCH v9 with license change and remove default y.
> But for somehow reason the patches did not reach linux-wireless.
> So I can not see them appear on the patchwork.
> I do not know if there is anything wrong, should I resend?
>
> I am sure I've CCed linux-wireless, just checked by Ping-Ke.

Checking with people who were CC'd is not a good choice -- that
circumvents the mailing list.

I didn't see it on Patchwork at first either, but now it's mostly there:

https://patchwork.kernel.org/cover/10909117/

Also on the kernel.org archive:

https://lkml.kernel.org/linux-wireless/1555653004-1795-1-git-send-email-yhchuang@realtek.com/

Maybe it was just delayed. Patch 14 is also still missing though.

Brian
