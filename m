Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF63C433EF
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Apr 2022 07:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiDMHIW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Apr 2022 03:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiDMHIO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Apr 2022 03:08:14 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84D62ED4A
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2022 00:05:52 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b15so1214106pfm.5
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2022 00:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wA/XhN+liF7FNQdYD63xlSjmBiv/wnn45LKu56yG8aw=;
        b=AreLMy3LsZ/2P+aighUoU5gjlgpeBV8R7aO4E6ZmNrH9sPFlHDYfXCQ9dsaQSKUUDZ
         jV695MA6AjTW9RaVAKwYYDjPOSnx5VhKZBhY+t+VOpMmHsvuvmUO3uevsu7U4SoQZX/Q
         hKY670Ht3+qDXUL6ihxfD4vmxjl3ro3ScX1SDiJ3bn9yNvTvyI5Jk5d9mYgm8hoPX7qr
         1+qPrlrepeFD1qFKz+Inw4HQwj7zVmeaIa1RIZvKj+dElNrFnhxT76DSr9HnuNU6qNNj
         CDAr/V+AXPW6hm65wKobzJCFQHpgmZ/HCfP68ZL1bibg1imj6sYE0SrrHqGdYcyfLpKZ
         /IFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wA/XhN+liF7FNQdYD63xlSjmBiv/wnn45LKu56yG8aw=;
        b=2ixaLKUyv2iWQv5ceSZuo+qkgn5nkYyWu+qV451zwicXNPahSGBWjHQUUV3TH3RhG9
         zwh/IfJFrXE6/sbQTrqsYXMDifJljK7VdgXaxAPaNuKp6V5KXyDA9xKvH0NA6ZbAOLzZ
         md8kZ+uYex+RD98OUjHbuBRUpppGbU558PIUbw2B4BdOh647GHSva4Gu5G7b0FzqBzHf
         FFOEkECGzwnBSNzaCMoH7GlLwLU7tjqf2DwmHr80ln9mepmVuobuzMaPvcx/ElYKH/aO
         hdhd8zBmwksQaFGzJGY5TCOSc8FCtVo887vC7z1sY4+tLcxwXw5DEct6Sr71LF5LJ4bw
         JcYA==
X-Gm-Message-State: AOAM532wPtxHGNWnleX+QALP7tr233ACqUgGb9dEo6UbLDQ3/DTk4McD
        M01xZHVuoc759d8x/VYPAc1i
X-Google-Smtp-Source: ABdhPJzozXDajJ1TNHGEamoE5ZZSxjlxIF5/046swX9Uyn7xnV9vkvwlcsjXH3KBZ12ieR4vKeneWw==
X-Received: by 2002:a05:6a00:10cc:b0:505:ada6:e03e with SMTP id d12-20020a056a0010cc00b00505ada6e03emr17405824pfu.45.1649833552212;
        Wed, 13 Apr 2022 00:05:52 -0700 (PDT)
Received: from thinkpad ([117.207.28.99])
        by smtp.gmail.com with ESMTPSA id t15-20020a63b70f000000b00381510608e9sm5035307pgf.14.2022.04.13.00.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 00:05:51 -0700 (PDT)
Date:   Wed, 13 Apr 2022 12:35:42 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Prasad Malisetty <quic_pmaliset@quicinc.com>,
        agross@kernel.org, bjorn.andersson@linaro.org,
        lorenzo.pieralisi@arm.com, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rajatja@google.com, refactormyself@gmail.com,
        quic_vbadigan@quicinc.com, quic_ramkri@quicinc.com,
        swboyd@chromium.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v4] PCI: qcom: Add system PM support
Message-ID: <20220413070542.GB2015@thinkpad>
References: <1646679306-4768-1-git-send-email-quic_pmaliset@quicinc.com>
 <20220412060144.GA41348@thinkpad>
 <87k0buoa9j.fsf@kernel.org>
 <20220413054904.GA2015@thinkpad>
 <CAA8EJprcQtVFvjL_WsMoDxvPSAqaRMS90ZuTsD_cDuujtr83Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA8EJprcQtVFvjL_WsMoDxvPSAqaRMS90ZuTsD_cDuujtr83Xw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 13, 2022 at 09:36:30AM +0300, Dmitry Baryshkov wrote:
> On Wed, 13 Apr 2022 at 08:49, Manivannan Sadhasivam
> <manivannan.sadhasivam@linaro.org> wrote:
> >
> > On Tue, Apr 12, 2022 at 01:40:08PM +0300, Kalle Valo wrote:
> > > + ath11k
> > >
> > > Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
> > >
> > > > +Kalle, linux-wireless
> > > >
> > > > On Tue, Mar 08, 2022 at 12:25:06AM +0530, Prasad Malisetty wrote:
> > > >> Add suspend_noirq and resume_noirq callbacks to handle
> > > >> system suspend and resume in dwc PCIe controller driver.
> > > >>
> > > >> When system suspends, send PME turnoff message to enter
> > > >> link into L2 state. Along with powerdown the PHY, disable
> > > >> pipe clock, switch gcc_pcie_1_pipe_clk_src to XO if mux is
> > > >> supported and disable the pcie clocks, regulators.
> > > >>
> > > >
> > > > Kalle, is this behaviour appropriate for WLAN devices as well? The devices
> > > > will be put into poweroff state (assuming no Vaux provided in D3cold) during
> > > > system suspend.
> > >
> > > ath11k leaves the firmware running during suspend. I don't fully
> > > understand what the patch is doing, but if it cuts the power from the
> > > WLAN chip during suspend that will break ath11k.
> > >
> >
> > Thanks Kalle for the confirmation. Yes the device will be put into D3cold state
> > and that will most likely equal to poweroff state.
> 
> Just to remind that ath11k on Qualcomm boards has a separate power
> supply, not directly tied to the PCIe power supply.
> 

It may change in the future or on a different OEM setup. Irrespective of that,
this patch sends the PME_Turn_Off event to the ep devices. The devices in turn
will shutdown the internal resources for poweroff/refclk removal. Therefore the
device state shall be lost.

Thanks,
Mani

> > Prasad, you should try to just turn off the host resources like clocks and
> > regulators (not refclk) and let the device be in the default state
> > (D3hot/L{0/1}?) during suspend.
> 
> 
> -- 
> With best wishes
> Dmitry
