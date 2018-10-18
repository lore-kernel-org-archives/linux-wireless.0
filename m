Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31ECC5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B52C4208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:13:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B52C4208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbeJRQNq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 12:13:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55819 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeJRQNq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 12:13:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id 206-v6so4461307wmb.5
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 01:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=atFdJSpcA6lxDJTG2VvZFL8obMCuuVvSX9Z15TMPeu8=;
        b=Iw6r+jcFonnoF2NCwysAPfnz2FRiKM8NwYFHUQ9VuYkUdy4bcYlKo5d6WfyTs5MKP4
         kg9kf/GFtzuvje0QdG/nADx8QgNseENJcAn8unz8Voscb7IOy11Y4S0+4BPwVbp/dccv
         PQ0VDTE1N/GM2CtMkPecOhmFrmpVgFD65k4iAd5SGTuQuZLMP9+slFS2P2zdcAnEpRlW
         mMeO3YtA2UVSw3K70kwdm3076F2KzhVUlDlCMm39uguBXDY/0s9+/uAheG71KXkFCKMD
         6jyjY6VnLRcB23QCdL1eEdixWEYqdn87W0RqqI3YPa5zXcEFteGPqwlqdFxrsyDBKpLy
         s/vA==
X-Gm-Message-State: ABuFfojtt3SbyoC7cqBIdA6GqZIusAItjJJJ6i24Z+dajOscWOEh5CAi
        SKZ6uSONKdG27LrNO5QGhMWlFDwC3pE=
X-Google-Smtp-Source: ACcGV61+iXAyZO6Z9MHYMAuXaeZ9HcTvq071XLBLq/RWZOpbs7Ow3bw8Y7bUwin/uQPE2XtU+qtdzw==
X-Received: by 2002:a1c:9816:: with SMTP id a22-v6mr6206409wme.13.1539850434595;
        Thu, 18 Oct 2018 01:13:54 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id l4-v6sm20986287wrb.92.2018.10.18.01.13.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 01:13:54 -0700 (PDT)
Date:   Thu, 18 Oct 2018 10:13:51 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: fix static tracepoints
Message-ID: <20181018081350.GA4938@localhost.localdomain>
References: <cover.1539815635.git.lorenzo.bianconi@redhat.com>
 <d9c86c268b987115f4ce08a8594e9e4da6c5f9fb.1539815635.git.lorenzo.bianconi@redhat.com>
 <20181018064521.GA2199@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018064521.GA2199@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Oct 18, Stanislaw Gruszka wrote:
> On Thu, Oct 18, 2018 at 12:35:32AM +0200, Lorenzo Bianconi wrote:
> > Add submit_urb and rx_urb static tracepoints in mt76-usb module.
> > Move trace_mac_txstat_fetch in mt76x02_mac_load_tx_status routine
> > in order to be available to usb drivers. Moreover remove
> > no longer used mt76x0/trace.{c,h}
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> > @@ -54,7 +53,7 @@ mt76x0_rf_csr_wr(struct mt76x02_dev *dev, u32 offset, u8 value)
> >  		FIELD_PREP(MT_RF_CSR_CFG_REG_ID, reg) |
> >  		MT_RF_CSR_CFG_WR |
> >  		MT_RF_CSR_CFG_KICK);
> > -	trace_mt76x0_rf_write(&dev->mt76, bank, offset, value);
> 
> I think tracing RF registers writes/read can still be useful.

Hi Stanislaw,

I removed tracing for RF registers since these operations are already tracked in
mt76_wr/mt76_rr so I thought they were redundant. Do you think deducing rf
read/write operations from mt76_{rr,wr} tracing is too convoluted? If so I
can reintroduce them in v2.

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
