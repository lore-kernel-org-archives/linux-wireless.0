Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE7DC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 561CA20833
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfDIIkI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:40:08 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45364 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfDIIkI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 04:40:08 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDmIY-0006mH-IM; Tue, 09 Apr 2019 10:40:06 +0200
Message-ID: <f6b699b051cd1625da57b224e7cd1a8ac6916e72.camel@sipsolutions.net>
Subject: Re: question: crda timeout in cfg80211
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Date:   Tue, 09 Apr 2019 10:40:05 +0200
In-Reply-To: <20190409083551.g27qvcxqhfm2x4uq@bars>
References: <20190326124209.j6tdk5cz47kc6mdj@bars>
         <07e019232f1720ce70d3353ce73cd32a23e5ed2f.camel@sipsolutions.net>
         <20190409083551.g27qvcxqhfm2x4uq@bars>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-09 at 08:35 +0000, Sergey Matyukevich wrote:

> Indeed, it is PI. I should have known. But instead I spent some time
> digging through 802.11 specs :)

Oops :)
 
> Well, as I mentioned in my question, regulatory update/reset operations
> shall be completed in ~pi seconds for _all_ the wireless cards in the
> system. In our case, regulatory reset operation may be fairly costly.
> As a result, we end up with recurring reset timeout, when more than one
> qtn card is installed in a single pcie host. One option for us is to
> optimize regulatory reset operations in firmware.
> 
> But what do you think about converting crda_timeout into a per-wiphy
> timeout in the case when all wiphy-s are being processed, e.g.
> in update_all_wiphy_regulatory.

Maybe we should parallelize it? But I don't know how easy that would be.

I'm a little worried just making it longer will cause users to really be
wondering what's going on?

johannes

