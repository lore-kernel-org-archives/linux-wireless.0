Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A9BC282DA
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 22:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7DC0218A3
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 22:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfDLWrz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 18:47:55 -0400
Received: from d.mail.sonic.net ([64.142.111.50]:56126 "EHLO d.mail.sonic.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbfDLWry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 18:47:54 -0400
Received: from [192.168.42.66] (173-228-4-66.dsl.dynamic.fusionbroadband.com [173.228.4.66])
        (authenticated bits=0)
        by d.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id x3CMlRoU016038
        (version=TLSv1.2 cipher=DHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 12 Apr 2019 15:47:28 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: gsmtap design/extensions?
From:   Guy Harris <guy@alum.mit.edu>
In-Reply-To: <196E881D-AB4A-4569-9C1F-5BCB41FE832F@alum.mit.edu>
Date:   Fri, 12 Apr 2019 15:47:26 -0700
Cc:     Harald Welte <laforge@gnumonks.org>,
        Vadim Yanitskiy <axilirator@gmail.com>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Transfer-Encoding: 8BIT
Message-Id: <1D6FE33B-DC15-47D8-A1AD-E95608300FDC@alum.mit.edu>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
 <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
 <20190410234555.GO25552@nataraja>
 <f0a64bb751b8c601f58130a7f3a3158d70f18f63.camel@sipsolutions.net>
 <196E881D-AB4A-4569-9C1F-5BCB41FE832F@alum.mit.edu>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3445.9.1)
X-Sonic-CAuth: UmFuZG9tSVYuvx4wRlhqOAwziRJKy/pPaTcADNtxSvHS62wnlMEKMcIq0VUolDJzTcNUrQLygw5kmnmHB61LEGdrr62f+N1s
X-Sonic-ID: C;9jNs8nRd6RGRE6VsT+DgAQ== M;lL7A8nRd6RGRE6VsT+DgAQ==
X-Sonic-Spam-Details: 0.0/5.0 by cerberusd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Apr 12, 2019, at 12:54 PM, Guy Harris <guy@alum.mit.edu> wrote:

> I see nothing about a struct gsmtap_hdr:
> 
> 	http://osmocom.org/projects/baseband/wiki/GSMTAP
> 
> that...
> 
> 	2) would prevent it from being at the beginning of a LINKTYPE_GSMTAP/DLT_GSMTAP packet in a pcap or pcapng file.

With a specification based on

	http://cgit.osmocom.org/libosmocore/plain/include/osmocom/core/gsmtap.h
