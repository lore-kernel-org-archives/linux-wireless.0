Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45082C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F08A20827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F08A20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbeKIXkD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:40:03 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51229 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbeKIXkD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 18:40:03 -0500
Received: by mail-wm1-f66.google.com with SMTP id w7-v6so2118681wmc.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 05:59:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3hpCGnr7FRaskR9JHF56rn3UrorBIK3Xa/tJ5VWr13o=;
        b=NyN4OGd3I1EM8Ig4dwvaOv9RIgtrlY3BZ0diKswSB/fLQ8tXPwDjwiM5XMDlJ1jfaC
         2Jwrz1FFTurf7TWYnz+qGH3ZG6WgKNfxVkut+WzEJyCfeIUTlmyzWZ/BXsiLmS5jLGAh
         b2XRAFJtP4H2l57Crb1LFSUyCrhLC3lrroOwbLjRCoLabViBhPeJgX8DtjhK7TCOeWrR
         7RDHlNN0pVNdYOhUkiF17mJjm926i1uDFaTWBZ72CmL6Wo+HGt6PvlTRQdRC5cm/wObF
         8AtqapXqa1GOhnDdRtFlH7BipVADa5w150qGDAGkuI4psiG0PDhOl0GDjUyow9xRny/y
         PT8Q==
X-Gm-Message-State: AGRZ1gK6LqrevpltVN3SjCu7B4Vw9mtT2motfc+ojUYf/4Fz4z/WFDJM
        CsnEe9efmuuB4AQhCICY5iruPqpCVLo=
X-Google-Smtp-Source: AJdET5ekITZyRjyiwCxoj57zdZYb3+jSsaNifpShwCbvk/nVHIWzI3bJxnVERqMz6HrpRSYEsSccNQ==
X-Received: by 2002:a1c:a757:: with SMTP id q84-v6mr4914980wme.61.1541771957655;
        Fri, 09 Nov 2018 05:59:17 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id g16-v6sm8135507wrr.38.2018.11.09.05.59.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 05:59:17 -0800 (PST)
Date:   Fri, 9 Nov 2018 14:59:13 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] mt76x02: minor beaconing init changes
Message-ID: <20181109135912.GD9453@localhost.localdomain>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-5-git-send-email-sgruszka@redhat.com>
 <20181109113331.GG4174@localhost.localdomain>
 <20181109131608.GB8054@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109131608.GB8054@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Fri, Nov 09, 2018 at 12:33:32PM +0100, Lorenzo Bianconi wrote:
> > > Disable BEACON timer during init and remove interrupt registers
> > > initalization form generic conde since they are PCIe specific.
> > > 
> > 
> > Since the timer is actually disabled (MT_INT_TIMER_EN set to 0) and
> > we just set the timer timeout here, does it worth to copy/paste
> > the same code?
> 
> As I pointed somwhere else I have some random, not easy to reproduce
> performance drops on MT7610U sta mode, starting when AP mode support
> was added. I'm can not be sure if this is by this setting this
> timer, but I would rather accept slight code duplication, than 
> do something that (even with very low probability) can cause
> troubles and for sure is not necessary.

I am fine with this patch but I do not see how original code can cause issues since
MT_INT_TIMER_EN is already set it to 0 (comment mt76_wr(dev, MT_INT_TIMER_EN, 0) out
in the original code)

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
