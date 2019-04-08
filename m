Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2216C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 19:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DEB420863
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 19:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbfDHTGU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 15:06:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60920 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfDHTGU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 15:06:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDZb0-0005kI-Gl; Mon, 08 Apr 2019 21:06:18 +0200
Message-ID: <07e019232f1720ce70d3353ce73cd32a23e5ed2f.camel@sipsolutions.net>
Subject: Re: question: crda timeout in cfg80211
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Date:   Mon, 08 Apr 2019 21:06:16 +0200
In-Reply-To: <20190326124209.j6tdk5cz47kc6mdj@bars> (sfid-20190326_134333_009337_40AB75D9)
References: <20190326124209.j6tdk5cz47kc6mdj@bars>
         (sfid-20190326_134333_009337_40AB75D9)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-03-26 at 12:42 +0000, Sergey Matyukevich wrote:
> Hi all,
> 
> Linux cfg80211 regulatory subsystem uses CRDA timeout to ensure completion
> of regulatory updates, performed by user-space software. See call_crda
> functon in net/wireless/reg.c:
> 
> static int call_crda(const char *alpha2)
> {
> 	...
> 
> 	queue_delayed_work(system_power_efficient_wq,
> 			&crda_timeout, msecs_to_jiffies(3142));
> 	return 0;
> }
> 
> So regulatory update/reset operations shall be completed in 3142 msec.
> And that includes processing of regulatory notifiers for all the
> wireless cards in the system.
> 
> It is not quite clear where this specific timeout value came from.
> Original commit (a90c7a313a1c5b) doesn't go into details about it.
> 
> Any ideas where it could come from ?

No particular reason. It's just ~pi seconds, and IIRC Luis thought that
was funny :-)

Are you seeing any issues with that?

johannes

