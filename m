Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A11E5C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 23:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 759F22082A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 23:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfDJXqI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 19:46:08 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:55965 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfDJXqI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 19:46:08 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Apr 2019 19:46:07 EDT
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.84_2)
        (envelope-from <laforge@gnumonks.org>)
        id 1hEMus-0000xr-Rz; Thu, 11 Apr 2019 01:46:06 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.92)
        (envelope-from <laforge@gnumonks.org>)
        id 1hEMuh-0001Qh-Ht; Thu, 11 Apr 2019 01:45:55 +0200
Date:   Thu, 11 Apr 2019 01:45:55 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Vadim Yanitskiy <axilirator@gmail.com>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: gsmtap design/extensions?
Message-ID: <20190410234555.GO25552@nataraja>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
 <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
 <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes,

On Wed, Apr 10, 2019 at 09:23:13AM +0200, Johannes Berg wrote:
> > but unfortunately, nobody has invested time into this (yet?).
> 
> 2012! 

Well, Osmocom is a very small community, with probably somewhere less than
25 active developers over the last few years (less than 15 full-time),
with an *incredibly* large scope:  Implement virtually any protocol
layer of any protocol stack on any of the 3GPP interfaces and all their
related network elements for 2G/3G as well as even other technologies
like TETRA, GMR-1, ...

And all that in a field of technology that has less free software than
the Operating Systems world had in the mid-1990ies.  It really feels a
bit like the Linux community 20 years ago.

So resources are always *extremely* tight, and given those limited
resources, I'm actually very happy with the results by now, having
automatied CI, build verifications, unit tests, functional test suites,
end-to-end testing, and all the code we implemented on git.osmocom.org :)

While current GSMTAPv2 is ugly, it works rather solid for all known
existing use cases, so there was no urgency to introduce a new version
of it.

> Not sure I get this, but I also don't really care all that much. 

Well, with all respect, GSMTAP was created for a variety of use cases,
see my other lengthy mail.  It's fine if you don't care, but unless you
could explain your use cases with a few paragraphs, neither you nor us
are able to determine if there is common functionality and if it makes
sense to use GSMTAP or not :)

So far I have not seen any explanation about what kind of data you want
to encapsulate at all.

> just a pretty strange design if the kernel were to output this, I'm not
> even sure how I'd do that properly. I don't want to be generating UDP
> packets there...

There are well-established APIs for having sockets in the kernel and for
generating + receiving UDP packets from it.  NFS has been doing this for
decades, as do various kernel-side tunneling helpers including the GTP
kernel module.

I'm not saying it's the right approach for your problem, I'm just saying
kernel-side code can for sure use UDP sockets.

> Perhaps we can define something (GSMTAPv3) to not really care how it's
> encapsulated, and for 'native' packet captures like what I want on Linux
> when integrated with the driver, actually use an ARPHDR_GSMTAP, and
> encapsulate in UDP when you create it in an application and want to send
> it elsewhere, rather than just writing it to a pcap file?

Sure, that works.  But the real question is, to me:  Are there common
GSMTAP payload types that both the existing GSMTAP users carry, as well
as what you would want to carry?  If yes, then it makes sense to think
about a common encapsulation like GSMTAP.  If the payload types differ,
then it seems rather like there are two distinct use cases that
wouldn't benefit from standardizing on one format.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
