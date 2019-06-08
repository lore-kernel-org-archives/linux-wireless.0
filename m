Return-Path: <SRS0=2AcT=UH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5F6C468C2
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Jun 2019 04:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1DA22146E
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Jun 2019 04:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfFHEWH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Jun 2019 00:22:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:51244 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfFHEWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Jun 2019 00:22:06 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x584LPir014050;
        Fri, 7 Jun 2019 23:21:26 -0500
Message-ID: <7697a9d10777b28ae79fdffdde6d0985555f6310.camel@kernel.crashing.org>
Subject: Re: [BISECTED REGRESSION] b43legacy broken on G4 PowerBook
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Christoph Hellwig <hch@lst.de>,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 08 Jun 2019 14:21:23 +1000
In-Reply-To: <73da300c-871c-77ac-8a3a-deac226743ef@lwfinger.net>
References: <20190605225059.GA9953@darkstar.musicnaut.iki.fi>
         <73da300c-871c-77ac-8a3a-deac226743ef@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> Please try the attached patch. I'm not really pleased with it and I will 
> continue to determine why the fallback to a 30-bit mask fails, but at least this 
> one works for me.

Your patch only makes sense if the device is indeed capable of
addressing 31-bits.

So either the driver is buggy and asks for a too small mask in which
case your patch is ok, or it's not and you're just going to cause all
sort of interesting random problems including possible memory
corruption.

Cheers,
Ben.


