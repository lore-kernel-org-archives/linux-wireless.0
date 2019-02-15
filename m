Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBF9C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 12:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB3F32192D
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 12:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436957AbfBOMWE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 07:22:04 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:39664 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731176AbfBOMWC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 07:22:02 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gucVA-0006xE-Og; Fri, 15 Feb 2019 13:21:56 +0100
Message-ID: <52bdb66f7e9e26ce9225ae11e37e22766d73694d.camel@sipsolutions.net>
Subject: Re: [v3 PATCH 0/4] mac80211: Fix incorrect usage of rhashtable walk
 API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, Julia Lawall <julia.lawall@lip6.fr>
Date:   Fri, 15 Feb 2019 13:21:55 +0100
In-Reply-To: <20190214140236.omt74prxhkfaasue@gondor.apana.org.au>
References: <20190213050551.x3jffq3ipghw6g2m@gondor.apana.org.au>
         <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
         <20190214140236.omt74prxhkfaasue@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> The first two patches in this series are bug fixes and should be
> backported to stable.
> 
> They fixes a number of issues with the use of the rhashtable API
> in mac80211.  First of all it converts the use of rashtable walks over
> to a simple linked list.  This is because an rhashtable walk is
> inherently unstable and not meant for uses that require stability,
> e.g., when you're trying to lookup an object to delete.

Thanks a lot, Herbert.

Applied those now, I'll send a pull request to Dave with them. Once that
trickles back into net-next I'll apply the third patch (it doesn't apply
without the others), and then Dave you can take the rhashtable one.

Let me know if you'd prefer I take the rhashtable one through my tree,
which really would be only so you don't have to track the dependency.

NB: it'd be easier in patchwork if you tagged all the patches with v3 in
their own PATCH tag, or put the "v3" tag into the actual subject (not
the "[PATCH 0/4]" tag because evidently patchwork drops the tags and
doesn't track them for the *series* just each *patch* ... so with what
you did nothing is visible in patchwork, even just appending "(v3)" to
the subject of the cover letter would've fixed that...

johannes

