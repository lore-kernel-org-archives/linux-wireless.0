Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F3EC10F11
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2725C20874
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfDOJ2j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:28:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:35244 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfDOJ2j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 05:28:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hFxui-0003eB-5k; Mon, 15 Apr 2019 11:28:32 +0200
Message-ID: <446da2afcad3c7bb539027147030649ad08f3f33.camel@sipsolutions.net>
Subject: Re: gsmtap design/extensions?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Guy Harris <guy@alum.mit.edu>
Cc:     Harald Welte <laforge@gnumonks.org>, openbsc@lists.osmocom.org,
        radiotap@netbsd.org, linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Aleksander Morgado <aleksander@aleksander.es>
Date:   Mon, 15 Apr 2019 11:28:30 +0200
In-Reply-To: <1089142F-2966-4C41-921B-465FBA721E79@alum.mit.edu>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
         <20190410233213.GN25552@nataraja>
         <1462659018bc40830efbe2348791b8df45b54cff.camel@sipsolutions.net>
         <1089142F-2966-4C41-921B-465FBA721E79@alum.mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-12 at 12:48 -0700, Guy Harris wrote:

> I.e., there's a split there between "capture" and "getting the packets
> from a capture delivered to you over an IP network".

Right. That's what I was trying to get at, you said it much more
succinctly.

> Depending on how your system is set up:
> 
> 	$ ls -l /dev/bpf*
> 	crw-rw----  1 root  access_bpf   23,   0 Apr 10 22:57 /dev/bpf0
> 	crw-rw----  1 root  access_bpf   23,   1 Apr 10 22:56 /dev/bpf1
> 
> 		...
> 
> and it could just be rw-rw-rw-.  Perhaps other systems make it harder
> to grant capture privileges.

Yeah, generally it's not that *hard*. It still seems *wrong*, and e.g.
it would also mean if you do need to do it remotely you'd have to filter
out your own remote control (ssh) traffic lest you cause traffic
amplification, etc.

johannes

