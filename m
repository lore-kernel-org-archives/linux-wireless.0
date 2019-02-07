Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F231C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 21:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 663D82175B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 21:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfBGV4M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 16:56:12 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:59806 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfBGV4L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 16:56:11 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1grreS-0006P7-Ug; Thu, 07 Feb 2019 22:56:09 +0100
Message-ID: <99d5f95e0085ff738e4877f9e2aa7960d3972565.camel@sipsolutions.net>
Subject: Re: [PATCH v2] rhashtable: make walk safe from softirq context
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, Thomas Graf <tgraf@suug.ch>
Date:   Thu, 07 Feb 2019 22:56:06 +0100
In-Reply-To: <20190207214834.awrpkxunnvfdorbe@gondor.apana.org.au>
References: <20190206090721.8001-1-johannes@sipsolutions.net>
         <20190207134006.gmuooqmyc5womcaf@gondor.apana.org.au>
         <fee1bdca8bb21a472a75c1a43fa61aad7fe4bff5.camel@sipsolutions.net>
         <20190207214834.awrpkxunnvfdorbe@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-02-08 at 05:48 +0800, Herbert Xu wrote:
> On Thu, Feb 07, 2019 at 02:50:54PM +0100, Johannes Berg wrote:
> > 
> > > This interface wasn't designed for use in softirq contexts.
> > 
> > Well, it clearly was used there. You even gave it a gfp_t argument in
> > rhashtable_walk_init(), so you can't really claim it wasn't designed for
> > this. I see now that it's ignored, but still?
> 
> I see.  This was added behind my back so I wasn't aware of it.

It's not used and actually I was wrong anyway: this would have also
allowed doing the walk while holding a spinlock or with softirqs
disabled, rather than from IRQ/softirq context.

In any case, it's clearly working to iterate from this context, and
doing a spinlock_bh vs. a spinlock in the rhashtable code isn't really
that big a deal? Not sure I really understand your objection.

johannes

