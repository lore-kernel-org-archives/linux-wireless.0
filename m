Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A01CC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29F54216FA
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:19:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29F54216FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbeI1Nl5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:41:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37932 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbeI1Nl5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:41:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5n3m-00085P-57; Fri, 28 Sep 2018 09:19:34 +0200
Message-ID: <1538119161.14416.57.camel@sipsolutions.net>
Subject: Re: How many null-data probes on connection loss?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Fri, 28 Sep 2018 09:19:21 +0200
In-Reply-To: <a409f0b7-5a91-1add-484d-588a554f0cd4@candelatech.com>
References: <9a1447d9-9a61-dc2d-0101-33c6bdeb946f@candelatech.com>
         <1537951137.28767.5.camel@sipsolutions.net>
         <fc564b2e-b6f2-75db-a2d9-99ea55a63c4a@candelatech.com>
         <1537986415.28767.17.camel@sipsolutions.net>
         <7ed031b0-19d9-46db-33d9-082999e5ed22@candelatech.com>
         <1537987703.28767.22.camel@sipsolutions.net>
         <e3c18a8d-9a58-54c5-9aaa-b778299f527b@candelatech.com>
         <1538032363.14416.2.camel@sipsolutions.net>
         <a409f0b7-5a91-1add-484d-588a554f0cd4@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-09-27 at 08:32 -0700, Ben Greear wrote:

> > It seems though that if there's some noise or so on the channel you
> > wouldn't be transmitting, so what kind of "network glitches" might
> > affect this? AP going away unexpectedly for some time?
> 
> I am thinking that if the 'timeout' is 500ms, and the number of probes is 2
> (the default values), then it should probe at 0ms, and at 250ms, and then finally
> fail at 500ms if nothing was received.  In otherwords, X probes, x/timeout apart.

That seems reasonable I guess. Although I'm not sure - perhaps once we
know it failed we *do* want to try a bit quicker again? Otherwise we
have a totally dead period there in the meantime, no?

johannes
