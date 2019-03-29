Return-Path: <SRS0=IiY2=SA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E87C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 10:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC66206B8
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 10:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfC2KfS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Mar 2019 06:35:18 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53102 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfC2KfS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Mar 2019 06:35:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h9oqy-00049g-6A; Fri, 29 Mar 2019 11:35:16 +0100
Message-ID: <f2fa741f5f818650b071eca23be16fb2bdb3c759.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow scans on radar channels, unless there
 is CAC or CSA
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        mathias.kretschmer@fit.fraunhofer.de
Date:   Fri, 29 Mar 2019 11:35:14 +0100
In-Reply-To: <2969898.mUHQksrBSp@prime>
References: <20180918141633.10282-1-sw@simonwunderlich.de>
         <1537435276.3874.14.camel@sipsolutions.net> <2969898.mUHQksrBSp@prime>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-09-20 at 12:27 +0200, Simon Wunderlich wrote:
> On Thursday, September 20, 2018 11:21:16 AM CEST Johannes Berg wrote:
> > On Tue, 2018-09-18 at 16:16 +0200, Simon Wunderlich wrote:
> > > Operating on a DFS channel doesn't mean we can't leave it for a short
> > > time - actually, some features like off-channel CAC work by leaving the
> > > operation channel to check other channels for availability (although
> > > off-channel CAC isn't implemented in mac80211). In our case, we want to
> > > use mesh while doing background surveys on other channels from time to
> > > time.
> > 
> > Actually ... as far as I can tell it *does* mean that, at least
> > currently for FCC.
> 
> 
> Mhm. I remember you said that before. But I can't find references for it. I 
> checked the FCC 15.407 document [1] but couldn't find anything in favor or 
> against that. Same for the measurement procedures [2]. I also couldn't find 
> off-channel CAC in FCC, which I used for my argument in ETSI:
> 
> In ETSI 301 893 [3] they talk about non-continuous checks for off-channel CAC 
> (in 4.2.6.2.3, second paragraph) and continuous period for CAC (4.2.6.2.2.2, 
> first paragraph). Continuity is not mentioned for in-service monitoring 
> (4.2.6.2.4), but off-channel CAC could only work when continuity is not 
> required.
> 
> I'd appreciate if you (or someone else) can point me to where it's stated that 
> we can't leave the channel for the a short time. I'm assuming that we are back 
> fast enough to ensure the required detection probability.

I still don't have a document, but we spoke about it at the wireless
workshop and Jouni agrees that this is an absolute no-go for FCC, while
allowed for ETSI.

I guess you can make it depend on the radar domain information.

johannes

