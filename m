Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69070C282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 424B5222C1
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403950AbfBMOzU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:55:20 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:45390 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732533AbfBMOzU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 09:55:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gtvwQ-0001z3-C1; Wed, 13 Feb 2019 15:55:14 +0100
Message-ID: <634cde01c2ab0cf00f7c82791dd93fec07aef976.camel@sipsolutions.net>
Subject: Re: [v2 PATCH 0/4] mac80211: Fix incorrect usage of rhashtable walk
 API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch
Date:   Wed, 13 Feb 2019 15:55:12 +0100
In-Reply-To: <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
References: <20190213050551.x3jffq3ipghw6g2m@gondor.apana.org.au>
         <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-02-13 at 22:38 +0800, Herbert Xu wrote:
> Hi:
> 
> The first two patches in this series are bug fixes and should be
> backported to stable.
> 
> They fixes a number of issues with the use of the rhashtable API
> in mac80211.  First of all it converts the use of rashtable walks over
> to a simple linked list.  This is because an rhashtable walk is
> inherently unstable and not meant for uses that require stability,
> e.g., when you're trying to lookup an object to delete.
> 
> It also fixes a potential memory leak when the rhashtable insertion
> fails (which can occur due to OOM).

Thanks a lot Herbert! That looks simpler than I thought it would be.

johannes

