Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999E2C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73EE4218AD
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfBKRWs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:22:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfBKRWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 12:22:48 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C77B480F83;
        Mon, 11 Feb 2019 17:22:47 +0000 (UTC)
Received: from localhost (ovpn-204-174.brq.redhat.com [10.40.204.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFB065C21D;
        Mon, 11 Feb 2019 17:22:42 +0000 (UTC)
Date:   Mon, 11 Feb 2019 18:22:41 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190211172240.GD6292@redhat.com>
References: <165515185.283024.1549744145982@email.ionos.de>
 <20190210094123.GB2913@redhat.com>
 <CAJ0CqmXp2a-zwPMyMFu+UCqTHP7qNRiJFopDSdZWdms7dVef4Q@mail.gmail.com>
 <20190211074455.GA6292@redhat.com>
 <20190211100405.GD3467@localhost.localdomain>
 <f7c29b08-c7d5-4d10-4be1-958ee79678f1@i2se.com>
 <20190211110635.GD2293@localhost.localdomain>
 <8a996497-ed69-4087-2c37-7f73633cbb4e@i2se.com>
 <20190211151055.GC8128@localhost.localdomain>
 <500c0d4a-611a-1b00-5ea4-7368e5e9f1e9@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500c0d4a-611a-1b00-5ea4-7368e5e9f1e9@i2se.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 11 Feb 2019 17:22:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 11, 2019 at 04:27:40PM +0100, Stefan Wahren wrote:
> >> All my results refers to the mainline kernel we all should talk about. I
> >> started a gist which try to describe the mainline variant:
> >> https://gist.github.com/lategoodbye/c7317a42bf7f9c07f5a91baed8c68f75
> > So to summarize:
> > - Raspberry Pi Foundation kernel works just with RFC series
> > - mainline kernel works out of the box
> >
> > is my understanding correct? 
> 
> not really.
> 
> Compiling the mainline kernel with arm/multi_v7_defconfig it works.
> Using the same kernel but with arm64/defconfig doesn't work. But i don't
> think this is a 32/64 bit issue. The arm64 defconfig is much more
> complex (e.g. enables more IOMMU stuff).

One possible thing that could be broken with IOMMU is allocating
big buffers via page_fraq_alloc(). Theoretically that should work,
but who knows. You can check my patch posted recently, it make
the driver stop doing big allocations via page_frag_alloc():

https://lore.kernel.org/linux-wireless/1549872974-7268-1-git-send-email-sgruszka@redhat.com/

Stanislaw
