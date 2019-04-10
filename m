Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9FAC10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 07:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906F4217D6
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 07:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbfDJHX0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 03:23:26 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40398 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfDJHX0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 03:23:26 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hE7Zj-0006AG-2f; Wed, 10 Apr 2019 09:23:15 +0200
Message-ID: <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
Subject: Re: gsmtap design/extensions?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Vadim Yanitskiy <axilirator@gmail.com>
Cc:     Harald Welte <laforge@gnumonks.org>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Wed, 10 Apr 2019 09:23:13 +0200
In-Reply-To: <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com> (sfid-20190410_083605_324978_F3549EC8)
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
         <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
         (sfid-20190410_083605_324978_F3549EC8)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-10 at 13:35 +0700, Vadim Yanitskiy wrote:
> Hello Johannes,
> 
> FYI, there already was a discussion about GSMTAPv3:
> 
> https://www.youtube.com/watch?v=vum9jzavZi0&list=PL07C78AF831FFE8F9&index=10
> 
> but unfortunately, nobody has invested time into this (yet?).

2012! But, umm, I don't really have time for a whole video right now -
anyone have the slides? :-)

But yeah, the first slides look sensible :-)

> > 1) Why the design with encapsulating it in UDP?
> 
> This gives us a possibility to "demux" multiple GSMTAP streams on the
> receiving side, e.g. if you are running multiple processes.

Not sure I get this, but I also don't really care all that much. It's
just a pretty strange design if the kernel were to output this, I'm not
even sure how I'd do that properly. I don't want to be generating UDP
packets there...

Perhaps we can define something (GSMTAPv3) to not really care how it's
encapsulated, and for 'native' packet captures like what I want on Linux
when integrated with the driver, actually use an ARPHDR_GSMTAP, and
encapsulate in UDP when you create it in an application and want to send
it elsewhere, rather than just writing it to a pcap file?

johannes

