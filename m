Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA54C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCA9F2098A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:31:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCA9F2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbeJCRTY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:19:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52321 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbeJCRTX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:19:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id 189-v6so5201378wmw.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 03:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PaJRRPKuIMpfz/EAOVkBTAJwq73k38fiN8cMmggULfM=;
        b=XVhRee7HSjskIncA1ZOkARbfzph0bf/UXw/00otIK6N7ffA/Mz6j813cx6dOpPP6sf
         KjmvnUbKxGx/owg/k2lWGIE9JBQNnwx/++0ArtYtNpdzQJCi/6u/Jjb+PPiw5X+3e9Id
         hTRt9HZwE9oMTP7GFtoIF5sFbPBfx00dKvcaDVxEF0fZHwdxwNDIeLJrduGPloLEMZzk
         tTr1GaA7GMBGIVJRTvlC1oNSPB7TmTtxmodD4oGt/DDGqccX5EV+GrCVDJxxxg6KkUc/
         /KVomOPFihl7ItgER0d2FgQ7rG3yWIVtdvqiUZHIZTG4SxigM8u0GnPOkapLiiR4OWyB
         S0+w==
X-Gm-Message-State: ABuFfoiflC8cX488QZTFTPWK2+35mix0UV/UXA+lwvQhJmlvSIRNn49Q
        Dy4l2489bH6nnztq7YK6CloYZQaD/x8=
X-Google-Smtp-Source: ACcGV60MpX3nxYc/sPxsa4cxFtB6iqAjmkai11Saoro8p16a0qJluH/2mQPxkl1+1ADyt3RTDboAhg==
X-Received: by 2002:a1c:f516:: with SMTP id t22-v6mr977736wmh.103.1538562695413;
        Wed, 03 Oct 2018 03:31:35 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j66-v6sm1231159wrj.28.2018.10.03.03.31.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 03:31:34 -0700 (PDT)
Date:   Wed, 3 Oct 2018 12:31:32 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: fix frag length allocation for usb
Message-ID: <20181003103131.GD27279@localhost.localdomain>
References: <1538554631-5168-1-git-send-email-sgruszka@redhat.com>
 <20181003091206.GA27279@localhost.localdomain>
 <20181003101946.GC2229@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003101946.GC2229@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > 
> > Hi Stanislaw,
> > 
> > I agree that we should use len in page_frag_alloc() instead of q->buf_size, so
> > 
> > Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > 
> > but reviewing the code I guess the real issue is not q->buf_size (since it should
> > be bigger than MCU_RESP_URB_SIZE) but it is the sequence of calls in
> 
> I added printk and there are allocations where len is bigger then
> q->buf_size even with correct mt76u_alloc_queues, mt76u_mcu_init_rx
> sequence for mt76x0u:
> 
> [16426.606090] q->buf_size 2048 len 2048 nsgs 8sglen 1728
> [16426.606131] q->buf_size 2048 len 2048 nsgs 8sglen 1728
> [16426.606134] q->buf_size 2048 len 2048 nsgs 8sglen 1728
> <snip>
> [16426.606464] q->buf_size 2048 len 2048 nsgs 8sglen 1728
> [16426.607517] q->buf_size 2048 len 1024 nsgs 1sglen 1024
> [16426.939268] q->buf_size 2048 len 14584 nsgs 1sglen 14584
> [16426.984955] q->buf_size 2048 len 14584 nsgs 1sglen 14584
> 
> Not sure where it come from, but it's after MCU init (which is 1024
> third line from end).
> 
> > mt76x0u_register_device() since mt76u_alloc_queues need to be called before
> > mt76u_mcu_init_rx()
> 
> Ok, so this was already fixed in 
> 
> commit 481bb0432414f790066205fe77226b7d1877385d
> Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Date:   Wed Sep 26 13:07:39 2018 +0200
> 
>     mt76: usb: make rx page_frag_cache access atomic
> 
> but then the sequence was changed again in
> 
> commit faa605bdfaa1322ea8e85791abdb3382a8cb4e0c
> Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Date:   Fri Sep 28 13:39:00 2018 +0200
> 
>     mt76x0: usb: move initialization code in usb.c

That is an issue introduce in this commit, I am working on a fix.
Probably I got also the other reported issue. I will send a series to
test soon. Thanks.

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
>  
