Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F77FC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 12:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 485A121738
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 12:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfDWMbj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 08:31:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60922 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfDWMbj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 08:31:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hIuaH-0007eV-8P; Tue, 23 Apr 2019 14:31:37 +0200
Message-ID: <19f9db0cb17f886b712f47a461b876946cd4f417.camel@sipsolutions.net>
Subject: Re: question: crda timeout in cfg80211
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Luis Chamberlain <mcgrof@do-not-panic.com>
Date:   Tue, 23 Apr 2019 14:31:36 +0200
In-Reply-To: <20190411124030.3epjsukmgwfncz6d@bars>
References: <20190326124209.j6tdk5cz47kc6mdj@bars>
         <07e019232f1720ce70d3353ce73cd32a23e5ed2f.camel@sipsolutions.net>
         <20190409083551.g27qvcxqhfm2x4uq@bars>
         <f6b699b051cd1625da57b224e7cd1a8ac6916e72.camel@sipsolutions.net>
         <20190411124030.3epjsukmgwfncz6d@bars>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sergey,

On Thu, 2019-04-11 at 12:40 +0000, Sergey Matyukevich wrote:
> Calling regulatory notifiers in parallel sounds like a good idea.
> But I haven't yet looked into the details as well. Before fixing
> the timeout issue, I was trying to figure out why that regulatory
> reset was needed at all.

:-)

> Here is a simple usecase: Linux distro sets regulatory region to US,
> STA is connected to AP. Any STA disconnect (including an attempt to
> reconnect to another AP) leads to regulatory reset cycle: US -> 00 -> US.
> This reset cycle is not supposed to be done for the wireless cards that
> specify REGULATORY_COUNTRY_IE_IGNORE flag. However regulatory reset will
> be applied anyway if at least one card in the system does not specify
> that flag.
> 
> Hence two questions:
> Do we really need this kind of reset when we remain
> in the same regulatory domain ? 

Probably doesn't make sense. If I were to guess I'd say that was a
simplification, since in many cases we'd actually be doing something
like (intersected) -> 00 -> US?

Actually, in your example, we're probably doing "US->00" and "00->US"
separately since we don't really know that we're going to connect again
to a similar AP, right?

Adding Luis, just in case he remembers anything about this ...

> Does it make sense to track when restore_regulatory_settings performs
> reset, and to skip reset for the cards that specify
> REGULATORY_COUNTRY_IE_IGNORE ?

I guess that'd make some sense anyway?

I do think ultimately we need some kind of reset every once a while when
we're disconnected, otherwise we'll just carry around intersections and
other baggage forever.

johannes

