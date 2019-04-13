Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846FCC10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 06:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EC712084D
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 06:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfDMGuH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 02:50:07 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:46279 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfDMGuH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 02:50:07 -0400
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.84_2)
        (envelope-from <laforge@gnumonks.org>)
        id 1hFCUG-0005Gf-Jr; Sat, 13 Apr 2019 08:50:04 +0200
Received: from laforge by nataraja.lan with local (Exim 4.92)
        (envelope-from <laforge@gnumonks.org>)
        id 1hFCMK-0007xE-69; Sat, 13 Apr 2019 08:41:52 +0200
Date:   Sat, 13 Apr 2019 08:41:52 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Guy Harris <guy@alum.mit.edu>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Vadim Yanitskiy <axilirator@gmail.com>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: gsmtap design/extensions?
Message-ID: <20190413064152.GB24451@nataraja>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
 <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
 <20190410234555.GO25552@nataraja>
 <f0a64bb751b8c601f58130a7f3a3158d70f18f63.camel@sipsolutions.net>
 <196E881D-AB4A-4569-9C1F-5BCB41FE832F@alum.mit.edu>
 <1D6FE33B-DC15-47D8-A1AD-E95608300FDC@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1D6FE33B-DC15-47D8-A1AD-E95608300FDC@alum.mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dear Guy and others,

On Fri, Apr 12, 2019 at 03:47:26PM -0700, Guy Harris wrote:
> On Apr 12, 2019, at 12:54 PM, Guy Harris <guy@alum.mit.edu> wrote:
> 
> > I see nothing about a struct gsmtap_hdr:
> > 	http://osmocom.org/projects/baseband/wiki/GSMTAP
> > that...
> > 	2) would prevent it from being at the beginning of a LINKTYPE_GSMTAP/DLT_GSMTAP packet in a pcap or pcapng file.
> With a specification based on
> 	http://cgit.osmocom.org/libosmocore/plain/include/osmocom/core/gsmtap.h

I completely agree that there is no technical reason why one couldn't put GSMTAP
headers in current (v2) or future formats inside an ETHERTYPE / DLT and have
them natively appearing in a pcap file of the given DLT.  There would be no objections
from my side to do so.

One could then simply call the same dissector in wireshark from that DLT or from
the existing UDP port number based dispatch via the IANA-registered GSMTAP port
number.

However, among the existing users of GSMTAP in the last decade or so,
there would be no advantage, as the related sources of GSMTAP frames all
exist in userspace and are feeding data, particularly from potentially
multiple sources, which can very well run on different hosts.

But that of course doesn't prevent new users from using different
transport mechanisms of getting GSMTAP from e.g. the kernel into
userspace.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
