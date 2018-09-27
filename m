Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB25CC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99E772147D
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99E772147D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbeI0VeA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:34:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51550 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbeI0VeA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:34:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id y25-v6so6296680wmi.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 08:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BvpgcXj62QE16Jq+gFz2h/Rygnlms2aXsmrTxceyPIM=;
        b=NvhZ/3+xQXeQTytcx+sxjlFaz3oSZy2wYpL5HNxmXHHwleHFxfKCfv+SmGGquekGwe
         3MREWQqcjYwiUPX4zG5HAX+1HomzwCxnhK2LQJFqWBL1F9pgLdVwupdKDPMBcw5O6p2c
         LGfLc9jCieGN17nbwM4pqRI8Jk7vqFthbMYJoiZXJWgX9RIweMBLI2cm4Cm7gnyF4ztW
         7rcNPfH4Kr7oWJgu5EbdrOfyau/t43p5cX4YNw9cmy2yT5nb+SDa01qujwmohEG+039M
         GuTQrK3LAUyn0muq6HN/SD9udMB/eFtferOsg5P4YIm1fD0Vu16+h+uiIGv2Fke8SzaI
         rBdg==
X-Gm-Message-State: ABuFfoiulc7GgKM0ytp2dp46bHEmoJ80ozkREi/EV1Xx8qVRvq8RZAtM
        BJYbsialwKRKTHARu+93MWGt2g==
X-Google-Smtp-Source: ACcGV61EFmOct+2J1toZh6LeaDgjWTufKqInWsiapUncHCAzKsXoBYNyFCYqe8nflJwjWffmgeMISA==
X-Received: by 2002:a1c:1748:: with SMTP id 69-v6mr8381534wmx.75.1538061315625;
        Thu, 27 Sep 2018 08:15:15 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id i7-v6sm2357192wrb.30.2018.09.27.08.15.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 08:15:15 -0700 (PDT)
Date:   Thu, 27 Sep 2018 17:15:13 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/26] mt76: move mt76x2_wait_for_bbp in mt76x02-lib
 module
Message-ID: <20180927151513.GE24450@localhost.localdomain>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <abcc5b975da9d834067c45420397db4e3ff11e3b.1538036134.git.lorenzo.bianconi@redhat.com>
 <20180927101001.GB19941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927101001.GB19941@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sep 27, Stanislaw Gruszka wrote:
> On Thu, Sep 27, 2018 at 11:01:37AM +0200, Lorenzo Bianconi wrote:
> > Move mt76x2_wait_for_bbp utility routine in mt76x02_util.h
> > in order to be resued by mt76x0 driver
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> > +static inline bool mt76x02_wait_for_bbp(struct mt76_dev *dev)
> > +{
> > +	return __mt76_poll_msec(dev, MT_MAC_STATUS,
> > +				MT_MAC_STATUS_TX | MT_MAC_STATUS_RX,
> > +				0, 100);
> > +}
> 
> I think this should be renamed to 
> 
> mt76x02_wait_for_txrx_busy()
> 
> or similar name, to avoid confusion and should be also used
> in mt76x0 to replace:
> 
>         if (!mt76_poll_msec(dev, MT_MAC_STATUS,
>                             MT_MAC_STATUS_TX | MT_MAC_STATUS_RX, 0, 1000))

ok, will do in v2

Regards,
Lorenzo


> 
> 
> Regards
> Stanislaw
> 
