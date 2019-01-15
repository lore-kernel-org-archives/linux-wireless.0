Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A172FC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A1DA20656
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfAON3L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:29:11 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56806 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbfAON3L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 08:29:11 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gjOmD-0007ph-Tr; Tue, 15 Jan 2019 14:29:10 +0100
Message-ID: <d9181baa0f9d6f33a3323f6663eefb97141c9ebc.camel@sipsolutions.net>
Subject: Re: wireless-regdb for automotive
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marcin Sielski <marcin.sielski@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 15 Jan 2019 14:29:08 +0100
In-Reply-To: <CANWiEci5fFFr0n4Eu7N=ox7djf9KSXnma77+N=vRNc1=U997FQ@mail.gmail.com> (sfid-20181217_191421_830793_5C380D7B)
References: <CANWiEciGLPxDc5JT0+gVrzEyEC6GOcUJUf8XR4PrYHj4TysHpA@mail.gmail.com>
         <112ca7a8933b6113edf29e874d95207a22ccb790.camel@sipsolutions.net>
         <CANWiEci5fFFr0n4Eu7N=ox7djf9KSXnma77+N=vRNc1=U997FQ@mail.gmail.com>
         (sfid-20181217_191421_830793_5C380D7B)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-12-17 at 19:14 +0100, Marcin Sielski wrote:
> Hi,
> 
> > > Do you possibly have ideas how to adjust wireless-regdb package
> > > to support also automotive use cases as described in:
> > > https://www.efis.dk/documents/44659
> > 
> > You might want to explain what changes this requires ...
> 
> Let's take 5150 - 5250 MHz as an example. It is ok to use it in in the
> Cars if EIRP is limited to 25mW,
> These regulations applies to EU countries as well as all the countries
> which recognize EU rules.
> Currently the only solution is to update db.txt to reflect these
> regulations by OEM/Tier 1. There is no
> generic solution that would cover various applications (e.g. in
> automotive) where Linux kernel is used.

Yes, ok, hmm. No good ideas here.

But DE for example specifies

        (5150 - 5250 @ 80), (100 mW), NO-OUTDOOR, AUTO-BW

now?

Perhaps it might make sense to have the db.txt processed by the (C)
preprocessor, and add something like

#ifdef COMPILE_FOR_CAR
...
#else
...
#endif

and then you can build your own binary for the in-car environment, yet
share the sources with the community?

johannes

