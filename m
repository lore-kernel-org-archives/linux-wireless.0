Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 249AEC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 14:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0B912075B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 14:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbfBLOZe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 09:25:34 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40774 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfBLOZe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 09:25:34 -0500
Received: by mail-wr1-f66.google.com with SMTP id q1so2883267wrp.7
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 06:25:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tp0DI8XVphPWUNaklWbhjStUNlhqo0SoQf57qrQCSlU=;
        b=D/mZf0/tYpAiJE4LGLVwkgXFDLUiuPuYtCfDSKJSTRwd0jqc0DUi/mkvijYBT0OdSj
         TAk1N/aPcQ83xPH4seGuplZDhktoHcIix9Hu/SXbngQhhdzehI3XAGxGbQvKltC212c3
         23lao/9rYrTmb0C3h4VCj7pz2/csbRBg8RkVZTl0NfTVkRh8YG8dWOeaSaeOr8O1YI6Z
         jirQF1c38xr/ZSQ23KB+EWb3ZArN6USeMSugtzx1km76oFnFrrdndolUWBnjpiuz4LWZ
         ZtpT7ATHHPrwSTHtQ++qDGN6s8GkiqRY5SXr2TrM/Kf7DPgJXn9lTnVqg0+vQRoG51tp
         Oajg==
X-Gm-Message-State: AHQUAuZ4xGrUrDOV88jRspz8m++d7HW7/q1R38or5Qu10sW46wK8OO46
        bD9zAl23kmYq9LUaoKy+4boJa9gpcVc=
X-Google-Smtp-Source: AHgI3IaXOs7H2W6fbPC1GWZE+Qt45xlv2srNPRKa4kM/U/GgoJSk7U9bpdzQ4JwOzA+DeSoNvNqcpw==
X-Received: by 2002:a5d:4a89:: with SMTP id o9mr2999638wrq.323.1549981532869;
        Tue, 12 Feb 2019 06:25:32 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c1sm16851566wrf.20.2019.02.12.06.25.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Feb 2019 06:25:32 -0800 (PST)
Date:   Tue, 12 Feb 2019 15:25:30 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo@kernel.org
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190212142528.GB24197@localhost.localdomain>
References: <cover.1549977282.git.lorenzo@kernel.org>
 <20190212134550.GA12256@redhat.com>
 <20190212135100.GA15292@redhat.com>
 <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
 <20190212141725.GD12906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212141725.GD12906@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Tue, Feb 12, 2019 at 03:09:53PM +0100, Lorenzo Bianconi wrote:
> > >
> > > (repost with corrected Lorenzo email)
> > >
> > > On Tue, Feb 12, 2019 at 02:45:50PM +0100, Stanislaw Gruszka wrote:
> > > > On Tue, Feb 12, 2019 at 02:24:47PM +0100, LorenzoBianconilorenzo@kernel.org wrote:
> > > > > From: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > >
> > > > > Use linear fragment and not a single usb scatter-gather buffer in mt76u
> > > > > {tx,rx} datapath if the usb controller has sg data length constraints.
> > > > > Moreover add disable_usb_sg module parameter in order to explicitly
> > > > > disable scatter-gather. SG I/O is not supported by all host drivers and
> > > > > some users have reported sg issues on AMD IOMMU.
> > > >
> > > > Again. This is not right approach. SG issues should be fixed
> > > > not workarounded.
> > 
> > Hi Stanislaw,
> > 
> > here we do not use SG, so num_sg is 0 and we use transfer_buffer. I do
> > not see how I am working around the issue.
> 
> By avoiding SG buffer allocation and configuration which most likely
> need to be fixed.

In my series I:
1- set num_sg to 0
2- use transfer_buffer

please correct me if I am wrong but in your solution you did the same since AFAIK
PageHighMem is always 0 so you end up setting num_sg to 0 and using
transfer_buffer as well. Is my understanding correct?

> 
> > Moreover with this approach we avoid some unnecessary operation in the hotpath
> 
> What unnecessary operation ?

the ones in mt76u_fill_bulk_urb()

Regards,
Lorenzo

> 
> Stanislaw
