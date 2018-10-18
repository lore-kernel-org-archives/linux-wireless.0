Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C239BECDE43
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E4FE21530
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:54:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E4FE21530
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbeJRRyo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 13:54:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37354 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbeJRRyo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 13:54:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id q1-v6so27689wrs.4
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 02:54:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JqtyxathQK4U/JUSCuGiOF2DZZNhOhiObX2OLHxNWTY=;
        b=ke0vMEXNKrvqnn/ANKBI9sWHG4gt1+e40UEQ8iWEDmium3ONk0eFnyYaYL46uPREOy
         HomIwFqDJPc1/J8p7GM2PMtnefa5mdJyAekcpDqSzzCTx2Rcy0OVFvAqMlI/HbncQnMY
         9WlLd7x9YlK3sqdp1kUXYo0x4wg379IGHNDNjmxsFF+RkiKIrAjhOy1+uAUjO4ywI63z
         BM2bIlkJCtQYQkUrfZJGk6Y3ZBS5mrapUrbtz9+gw5D3+ebNlsoy1wO3GM30fGErSAio
         BucJCqDnHgnael4xf0cmuWa6yx+4Hh7M4b8Pl1N+tMVKpzIEDb94b3accSH0ELdMt9K0
         AkCA==
X-Gm-Message-State: ABuFfojJRYtFf8VTGC8ClzdVJrSpDKzNlDFmWY9GQusCScZwbmr6bsCv
        nZxE9xdqoV2cs8doyxuTjK+rBQ==
X-Google-Smtp-Source: ACcGV61z/skNhLFR8s7YGCDFD3HNziwUM9IesmHosNn6F10KSpBLYMjBPBFEpDfXYZwjXez9sAK1JA==
X-Received: by 2002:a05:6000:1284:: with SMTP id f4mr7071764wrx.140.1539856469431;
        Thu, 18 Oct 2018 02:54:29 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id f7-v6sm17294828wrr.68.2018.10.18.02.54.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 02:54:29 -0700 (PDT)
Date:   Thu, 18 Oct 2018 11:54:26 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: antenna select corrections
Message-ID: <20181018095426.GE4938@localhost.localdomain>
References: <1539850059-11886-1-git-send-email-sgruszka@redhat.com>
 <20181018091335.GB4938@localhost.localdomain>
 <20181018092146.GC2190@redhat.com>
 <20181018092819.GC4938@localhost.localdomain>
 <20181018094055.GA6294@redhat.com>
 <20181018095333.GA6495@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018095333.GA6495@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Thu, Oct 18, 2018 at 11:40:56AM +0200, Stanislaw Gruszka wrote:
> > On GPL realeased driver for MT7610U ( mt7610u_wifi_sta_v3002_dpo_2013091 )
> > it's like this:
> > 
> >         CoexCfg3 &= ~(BIT5 | BIT4 | BIT3 | BIT2 | BIT1);
> 
> <snip>
> > Does your SDK do something diffrent ?
> Ok I can see:
> 
> 	CoexCfg3 &= ~(BIT5 | BIT4 | BIT3 | BIT2);
> 
> in
> https://github.com/i80s/mtk-sources 
> which is newer version of the driver, so preasumely BIT1
> should not be cleared. Will fix that in the patch.

ack

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
