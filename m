Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD055C677FC
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 19:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DCEE2075C
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 19:23:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DCEE2075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbeJLCva (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:51:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37762 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbeJLCva (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 22:51:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAgXm-0001p2-2P; Thu, 11 Oct 2018 21:22:46 +0200
Message-ID: <1539285754.4027.6.camel@sipsolutions.net>
Subject: Re: Question on FIELD_PREP() for static array
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Garry <john.garry@huawei.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        jakub.kicinski@netronome.com, yamada.masahiro@socionext.com,
        Arnd Bergmann <arnd@arndb.de>, viro@zeniv.linux.org.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name
Date:   Thu, 11 Oct 2018 21:22:34 +0200
In-Reply-To: <1539285190.4027.5.camel@sipsolutions.net>
References: <c8594a75-964b-01b0-382e-88bcb5b462f2@huawei.com>
         <40fd3d963820bf96547fa9b5e8c171c6a339674e.camel@perches.com>
         <1539195207.3687.178.camel@sipsolutions.net>
         <830ff9fb-07b1-86b6-4f57-af549a37a8c0@huawei.com>
         <1539271422.3687.217.camel@sipsolutions.net>
         <ef2d37ab-bef4-fd3f-a6f7-e68e60695e9b@huawei.com>
         <ec680438-babe-4ee7-988b-c2466a11e789@huawei.com>
         <1539285190.4027.5.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-10-11 at 21:13 +0200, Johannes Berg wrote:
> 
> However, I have another trick:
> 
> #define __NLA_ENSURE(condition) (0 * sizeof(struct { unsigned int x:1 - 2*!(condition);}))
> 
> or, in this context,
> 
> #define BUILD_BUG_ON_RET_ZERO(cond) (0 * sizeof(struct { unsigned int x:1 - 2*!(condition);}))

Oops, I forgot to insert the second !, it must be

#define BUILD_BUG_ON_RET_ZERO(cond) (0 * sizeof(struct { unsigned int x:1 - 2*!!(condition);}))

johannes
