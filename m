Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A910EC10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 07:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F7AA21721
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 07:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfDMHhG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 03:37:06 -0400
Received: from d.mail.sonic.net ([64.142.111.50]:53558 "EHLO d.mail.sonic.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbfDMHhG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 03:37:06 -0400
Received: from [192.168.42.66] (173-228-4-66.dsl.dynamic.fusionbroadband.com [173.228.4.66])
        (authenticated bits=0)
        by d.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id x3D7afoF008432
        (version=TLSv1.2 cipher=DHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 13 Apr 2019 00:36:41 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: gsmtap design/extensions?
From:   Guy Harris <guy@alum.mit.edu>
In-Reply-To: <20190413064152.GB24451@nataraja>
Date:   Sat, 13 Apr 2019 00:36:39 -0700
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Vadim Yanitskiy <axilirator@gmail.com>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Transfer-Encoding: 8BIT
Message-Id: <B99492E6-9EA9-4A4E-8585-8EA84D8E7267@alum.mit.edu>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
 <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
 <20190410234555.GO25552@nataraja>
 <f0a64bb751b8c601f58130a7f3a3158d70f18f63.camel@sipsolutions.net>
 <196E881D-AB4A-4569-9C1F-5BCB41FE832F@alum.mit.edu>
 <1D6FE33B-DC15-47D8-A1AD-E95608300FDC@alum.mit.edu>
 <20190413064152.GB24451@nataraja>
To:     Harald Welte <laforge@gnumonks.org>
X-Mailer: Apple Mail (2.3445.9.1)
X-Sonic-CAuth: UmFuZG9tSVaXMpC7V7wa9TrYKvyEAVhUJjZdzVy+qrDoQlb0TeehkRswjLM8P7fTAygnJ5+dmvgMzUnQgpDpT24EUR3JNI4H
X-Sonic-ID: C;pA0a4b5d6RGGZqVsT+DgAQ== M;HHJq4b5d6RGGZqVsT+DgAQ==
X-Sonic-Spam-Details: 0.0/5.0 by cerberusd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Apr 12, 2019, at 11:41 PM, Harald Welte <laforge@gnumonks.org> wrote:

> But that of course doesn't prevent new users from using different
> transport mechanisms of getting GSMTAP from e.g. the kernel into
> userspace.

Nor does it prevent libpcap (once I generalize the remote-capture mechanism) from supporting gsmtap://{host}[:port] (port optional) URLs that cause it to set up a UDP ({PF_INET or PF_INET6}, SOCK_DGRAM, IPPROTO_UDP) socket on which to receive UDP packets from the specified host (at the specified port or, if no port is specified, the default GSMTAP socket) and supplying packets that begin with a GSMTAP header, with a new linktype of LINKTYPE_GSMTAP/DLT_GSMTAP.
