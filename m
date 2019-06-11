Return-Path: <SRS0=ropy=UK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7B6C31E44
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Jun 2019 22:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2259421721
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Jun 2019 22:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407277AbfFKWqw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Jun 2019 18:46:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:34169 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404582AbfFKWqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jun 2019 18:46:52 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x5BMkUqQ021305;
        Tue, 11 Jun 2019 17:46:31 -0500
Message-ID: <0b257651bb7ac4a6f0a8dce5470120b7701720b9.camel@kernel.crashing.org>
Subject: Re: [BISECTED REGRESSION] b43legacy broken on G4 PowerBook
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Christoph Hellwig <hch@lst.de>
Cc:     Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        linuxppc-dev@lists.ozlabs.org
Date:   Wed, 12 Jun 2019 08:46:30 +1000
In-Reply-To: <5aaa600b-5b59-1f68-454f-20403c318f1a@lwfinger.net>
References: <20190605225059.GA9953@darkstar.musicnaut.iki.fi>
         <73da300c-871c-77ac-8a3a-deac226743ef@lwfinger.net>
         <20190607172902.GA8183@lst.de>
         <30000803-3772-3edf-f4a9-55122d504f3f@lwfinger.net>
         <20190610081825.GA16534@lst.de>
         <153c13f5-a829-1eab-a3c5-fecfb84127ff@lwfinger.net>
         <20190611060521.GA19512@lst.de>
         <5aaa600b-5b59-1f68-454f-20403c318f1a@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-06-11 at 17:20 -0500, Larry Finger wrote:
> b43-pci-bridge 0001:11:00.0: dma_direct_supported: failed (mask =
> 0x3fffffff, 
> min_mask = 0x5ffff000/0x5ffff000, dma bits = 0x1f

Ugh ? A mask with holes in it ? That's very wrong... That min_mask is
bogus.

Ben.


