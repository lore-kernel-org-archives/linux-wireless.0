Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC578C282CE
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 19:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3322171F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 19:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfDLTzN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 15:55:13 -0400
Received: from d.mail.sonic.net ([64.142.111.50]:34650 "EHLO d.mail.sonic.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbfDLTzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 15:55:13 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Apr 2019 15:55:12 EDT
Received: from [192.168.42.66] (173-228-4-66.dsl.dynamic.fusionbroadband.com [173.228.4.66])
        (authenticated bits=0)
        by d.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id x3CJsmVk005098
        (version=TLSv1.2 cipher=DHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 12 Apr 2019 12:54:49 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: gsmtap design/extensions?
From:   Guy Harris <guy@alum.mit.edu>
In-Reply-To: <f0a64bb751b8c601f58130a7f3a3158d70f18f63.camel@sipsolutions.net>
Date:   Fri, 12 Apr 2019 12:54:47 -0700
Cc:     Harald Welte <laforge@gnumonks.org>,
        Vadim Yanitskiy <axilirator@gmail.com>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Transfer-Encoding: 8BIT
Message-Id: <196E881D-AB4A-4569-9C1F-5BCB41FE832F@alum.mit.edu>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
 <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
 <20190410234555.GO25552@nataraja>
 <f0a64bb751b8c601f58130a7f3a3158d70f18f63.camel@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3445.9.1)
X-Sonic-CAuth: UmFuZG9tSVZIk+6mzPSzrSYg1tOHQVDsHvOCymPrNzmhiKmuMkG+fcs/kqZq3xvOVhzSjYe9KnuRMCFFmOiLA96NdmilNF0j
X-Sonic-ID: C;oMDf01xd6RGFXKVsT+DgAQ== M;SGE81Fxd6RGFXKVsT+DgAQ==
X-Sonic-Spam-Details: 0.0/5.0 by cerberusd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Apr 12, 2019, at 10:15 AM, Johannes Berg <johannes@sipsolutions.net> wrote:

> Agree. Sorry about that. No disrespect was intended, but I'm still not
> sure I understand the need for UDP encapsulation *as part of the
> protocol*. I guess saying "GSMTAP can optionally be encapsulated in UDP
> with the well-known port xyz" would be something else, and it'd make
> more sense to me than saying it has to be.

I see nothing about a struct gsmtap_hdr:

	http://osmocom.org/projects/baseband/wiki/GSMTAP

that

	1) requires that it plus the payload be encapsulated in a UDP datagram

or

	2) would prevent it from being at the beginning of a LINKTYPE_GSMTAP/DLT_GSMTAP packet in a pcap or pcapng file.
