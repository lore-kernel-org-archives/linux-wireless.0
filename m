Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1A7C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 21:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B617E2070B
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 21:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfBVVGe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 16:06:34 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53338 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfBVVGe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 16:06:34 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gxI1g-0006Ys-GG; Fri, 22 Feb 2019 22:06:32 +0100
Message-ID: <69e6577f90d99289acaa9853fe236e6f15f9e774.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Feb 2019 22:06:31 +0100
In-Reply-To: <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-8-alexander@wetzel-home.de>
         <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
         <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-02-22 at 21:50 +0100, Alexander Wetzel wrote:

> > No, but if you have a good test case we can check out what the firmware
> > bug is and fix it. Perhaps not for all, but for the future at least.
> > Maybe we can still figure out where it was introduced and thus see where
> > it's good to use native mode.
> 
> I'll verify if can reproduce the scrambled packets and will provide a 
> capture if so. Assuming that confirms the initial finding I'll be able 
> to reproduce that at will within minutes with access to a test system 
> having a mvm card. (I have some plans which will improve access, but 
> looks like that will take some time and efforts.)
> 
> For now I handle that as low prio till we have generic Extended Key ID 
> support merged

Agree

>  and I've had some time to improve my test setup and 
> hopefully have better access to a mvm card for testing.

If all that's lacking is a few NICs then I'm sure we/I can help out with
that :)

> > > I also have tested patch for iwldvm using the Compat mode and I think
> > > mvm cards will also work with that.
> > 
> > No they don't, no firmware is available for that.
> 
> So far I only looked at the dvm part of iwlwifi with only minutes spend 
> on mvm to port the NATIVE solution from dvm.

:)

> Are you saying that mvm cards can't seamless switch a RX/TX key to TX 
> only one? mvm seems to support SW crypto as needed and switching RX/TX 
> to TX keys is the only other requirement for COMPAT mode.

No, sorry. I misread your statement. I thought you were saying "mvm
cards will also work with iwldvm" rather than "mvm cards will also work
with compat mode" :-)

I think they all should just be made to work in native mode, the
firmware basically supports this as you found, there must be some small
bugs.

johannes

