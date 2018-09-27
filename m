Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3438CC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6BCF21571
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:14:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6BCF21571
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbeI0VdE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:33:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42191 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbeI0VdE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:33:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id b11-v6so3024482wru.9
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 08:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5sRup4QXrP17u8syaOjdpArqolnuN3qakdP2zSRvkZE=;
        b=LrxvV6emraud8yLgXdcr1P2aZW0tey2SoXkV1bB309x3AkHnIjSAsXtFsdVXrjCdAx
         +6mw2+ky11WehEGZfup7OyiAc+NCbGydy6wGF8iJt24rZVuU6jSkiRkGog16DhjpiHPk
         +8rLUlglc+BeTK0/wdJp/Wda/h2eaWDNs/mZ3BcHPIZFm0YlLnY+HX49PhbGjsb06Rhy
         /iWjN+iMgeHWTlM2MCK75anCEEul2IVP2yCeSSoQmxRiCMQpt0pWEjY37otZzQJLKBJk
         GQjC4715FRrBduDdxk4Z1hRVSjoIW0CVw/RbY5QNuZ2AzKObp1fQ8qU2WkJVPHZWZpnP
         6l4Q==
X-Gm-Message-State: ABuFfog73ShvAt3S1AQ9YEwFxNM/RtvdSu04e5FmJ8NcP62Z+z6tV2Ut
        SiE8eW1hXp91RM0Iy3J1teIx4A==
X-Google-Smtp-Source: ACcGV639lbEt1PhKVgoDkYh/HjKsu8T/kR00uDUV9Z9YTYV3oXOBdMShUCYJpnfZ353tmjK6rcfp8A==
X-Received: by 2002:adf:91a4:: with SMTP id 33-v6mr9040230wri.37.1538061259854;
        Thu, 27 Sep 2018 08:14:19 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id l8-v6sm2558937wrs.63.2018.09.27.08.14.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 08:14:19 -0700 (PDT)
Date:   Thu, 27 Sep 2018 17:14:17 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/26] mt76: move mt76x02_beacon_offset in mt76x02_core.c
Message-ID: <20180927151416.GD24450@localhost.localdomain>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <a3e3e4065e8dc6455ad6653c10b31b0a6fe3b7ef.1538036134.git.lorenzo.bianconi@redhat.com>
 <20180927100629.GA19941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927100629.GA19941@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Thu, Sep 27, 2018 at 11:01:35AM +0200, Lorenzo Bianconi wrote:
> > Move mt76x02_beacon_offset utility routine in mt76x02-lib module
> > since it is shared between mt76x0 and mt76x2 driver and remove
> > duplicated code. Moreover move beacon_offset data structure in
> > mt76x02-lib module since it is shared between mt76x0 and mt76x2
> > drivers
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> <snip>
> 
> > +const u16 mt76x02_beacon_offsets[16] = {
> > +	/* 1024 byte per beacon */
> > +	0xc000,
> > +	0xc400,
> > +	0xc800,
> > +	0xcc00,
> > +	0xd000,
> > +	0xd400,
> > +	0xd800,
> > +	0xdc00,
> > +	/* BSS idx 8-15 not used for beacons */
> > +	0xc000,
> > +	0xc000,
> > +	0xc000,
> > +	0xc000,
> > +	0xc000,
> > +	0xc000,
> > +	0xc000,
> > +	0xc000,
> > +};
> > +EXPORT_SYMBOL_GPL(mt76x02_beacon_offsets);
> I don't think this should be added to mt76x02_core.c with interrupt stuff.
> Interrupts are mmio specific, and beaconing are generic for both buses.
> Seems mt76x02_util is better place for beaconing.

ack

> 
> Also maybe to avoid confusion mt76x02_core.c should be named
> mt76x02_mmio.c and contain only code for PCIe i.e. mt76x0e, mt76x2e.

ack, will do in v2

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
