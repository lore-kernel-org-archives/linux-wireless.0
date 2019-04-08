Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34E4C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 20:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FFE02084F
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 20:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfDHUK6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 16:10:58 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34000 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfDHUK5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 16:10:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDabX-00074o-Rv; Mon, 08 Apr 2019 22:10:56 +0200
Message-ID: <ed6e95dad39ef0ac98c62e3acd3f78fd7b3a6d2b.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 08 Apr 2019 22:10:54 +0200
In-Reply-To: <14c9d8f7-7cf6-d7e1-a1c0-9f1a10920d4e@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-8-alexander@wetzel-home.de>
         <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
         <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
         <69e6577f90d99289acaa9853fe236e6f15f9e774.camel@sipsolutions.net>
         <14c9d8f7-7cf6-d7e1-a1c0-9f1a10920d4e@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-02-24 at 14:04 +0100, Alexander Wetzel wrote:

> Finding a really good sniffer able to also capture A-MPDU frames 
> including control frames would be awesome. 

I think the AC-9260 you have should be a decent sniffer. The (yet
unreleased) follow-up hardware is even better, but this one is fine.

Just remember to load with amsdu_size set to the appropriate (maximum)
A-MSDU size you want to capture.

> I probably should work on the new AP, but then I always wanted to test 
> coreboot and finding out my notebook is now supported is too alluring to 
> resist;-)

:-)

> > I think they all should just be made to work in native mode, the
> > firmware basically supports this as you found, there must be some small
> > bugs.
> 
> Agree. And with your statements that it already should work and the 
> option to get ucode updates I like our chances:-) With some luck it 
> could even work and I made some error the first time. I'll give that a 
> second look with what I have at hand soon. But after bombing you with 
> mails for what feels like most of the weekend I'll postpone that for now:-)

I was looking at the firmware now and ... well, I want to really test
this to understand what's going wrong, because it really *looks* like
even the recent ones should be supported natively, at least as far as
I've looked now.

> As mentioned above I'm currently aiming for two or three Intel AC-9260 
> cards for the next development round. It's seems to be the most modern 
> card and the price difference between the cards is irrelevant compared 
> to both efforts and costs to get the cards working in two or three 
> devices. If you thing another card would be better for development I'll 
> just use that one instead...

AC-9260 should be fine, as far as Intel is concerned. Also make for good
sniffers, in my experience, we use them all the time for that.

johannes

