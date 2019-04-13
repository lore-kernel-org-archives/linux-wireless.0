Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C90C10F14
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 07:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE8621721
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 07:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfDMHu1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 03:50:27 -0400
Received: from c.mail.sonic.net ([64.142.111.80]:38202 "EHLO c.mail.sonic.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfDMHu1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 03:50:27 -0400
Received: from [192.168.42.66] (173-228-4-66.dsl.dynamic.fusionbroadband.com [173.228.4.66])
        (authenticated bits=0)
        by c.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id x3D7o19W025651
        (version=TLSv1.2 cipher=DHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 13 Apr 2019 00:50:01 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: gsmtap design/extensions?
From:   Guy Harris <guy@alum.mit.edu>
In-Reply-To: <20190413071227.GC24451@nataraja>
Date:   Sat, 13 Apr 2019 00:49:59 -0700
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Vadim Yanitskiy <axilirator@gmail.com>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Transfer-Encoding: 8BIT
Message-Id: <7C48A51C-852F-480B-9F6D-C5BFEBB1A389@alum.mit.edu>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
 <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
 <20190410234555.GO25552@nataraja>
 <f0a64bb751b8c601f58130a7f3a3158d70f18f63.camel@sipsolutions.net>
 <20190413071227.GC24451@nataraja>
To:     Harald Welte <laforge@gnumonks.org>
X-Mailer: Apple Mail (2.3445.9.1)
X-Sonic-CAuth: UmFuZG9tSVY91n9/xOYFcUKpfH3vHl4elpm08mHpiblxgGsdVFToL6AR8ZXIZB6JddycEsDBjMHzzTreEkiudlJKLXGdap/z
X-Sonic-ID: C;hrL/vcBd6RGgr9/uKuSLEw== M;xMU6vsBd6RGgr9/uKuSLEw==
X-Sonic-Spam-Details: 0.0/5.0 by cerberusd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Apr 13, 2019, at 12:12 AM, Harald Welte <laforge@gnumonks.org> wrote:

> On Fri, Apr 12, 2019 at 07:15:56PM +0200, Johannes Berg wrote:
> 
>> Agree. Sorry about that. No disrespect was intended, but I'm still not
>> sure I understand the need for UDP encapsulation *as part of the
>> protocol*. I guess saying "GSMTAP can optionally be encapsulated in UDP
>> with the well-known port xyz" would be something else, and it'd make
>> more sense to me than saying it has to be.
> 
> Sure, like with most protocols you can wrap them in anything you want.
> 
> Let me put it like this:
> You don't have to run RTP inside UDP, you could equally put the RTP
> frames in to SCTP or DCTP.   It's just not what the original users of
> the protocol/spec had envisioned, but it can for sure be done, and has
> no side-effect other than not being interoperable with existing
> implementations.

Or you can just have LINKTYPE_RTP/DLT_RTP and supply them inside nothing.

However, unlike RTP, there is no reason *not* to do that for GSMTAP - it's not as if the IP or UDP headers in a packet from a host supplying GSMTAP-encapsulated packets provide any information necessary or even useful for dissecting the encapsulated packets.

Whether it's useful, or possible, to have any interfaces on a *host* with cellular modem connectivity supply the cellular-network traffic as packets with GSMTAP headers - which appears to be what Johannes is thinking of - is another matter (but even if the answer is no, there is, as per my other message, a use for a LINKTYPE_GSMTAP/DLT_GSMTAP header type).  That might not be possible, as cellular modems, as you note, tend to hide a lot of lower-layer details from the host.

