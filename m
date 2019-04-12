Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C434C282CE
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 17:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 567972077C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 17:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbfDLRQG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 13:16:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53152 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfDLRQG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 13:16:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hEzmQ-0004Ez-Cb; Fri, 12 Apr 2019 19:15:58 +0200
Message-ID: <f0a64bb751b8c601f58130a7f3a3158d70f18f63.camel@sipsolutions.net>
Subject: Re: gsmtap design/extensions?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Harald Welte <laforge@gnumonks.org>
Cc:     Vadim Yanitskiy <axilirator@gmail.com>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Fri, 12 Apr 2019 19:15:56 +0200
In-Reply-To: <20190410234555.GO25552@nataraja>
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
         <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
         <46474c61d7748042cc0a1f23773186786020638e.camel@sipsolutions.net>
         <20190410234555.GO25552@nataraja>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-04-11 at 01:45 +0200, Harald Welte wrote:
> Hi Johannes,
> 
> On Wed, Apr 10, 2019 at 09:23:13AM +0200, Johannes Berg wrote:
> > > but unfortunately, nobody has invested time into this (yet?).
> > 
> > 2012! 
> 
> Well, Osmocom is a very small community, with probably somewhere less than
> 25 active developers over the last few years (less than 15 full-time),
> with an *incredibly* large scope:  Implement virtually any protocol
> layer of any protocol stack on any of the 3GPP interfaces and all their
> related network elements for 2G/3G as well as even other technologies
> like TETRA, GMR-1, ...
> 
> And all that in a field of technology that has less free software than
> the Operating Systems world had in the mid-1990ies.  It really feels a
> bit like the Linux community 20 years ago.
> 
> So resources are always *extremely* tight, and given those limited
> resources, I'm actually very happy with the results by now, having
> automatied CI, build verifications, unit tests, functional test suites,
> end-to-end testing, and all the code we implemented on git.osmocom.org :)

:-)
Sure, I get it. Just a bit surprised I guess.

> While current GSMTAPv2 is ugly, it works rather solid for all known
> existing use cases, so there was no urgency to introduce a new version
> of it.

OK.

> > Not sure I get this, but I also don't really care all that much. 
> 
> Well, with all respect, GSMTAP was created for a variety of use cases,
> see my other lengthy mail.  It's fine if you don't care, but unless you
> could explain your use cases with a few paragraphs, neither you nor us
> are able to determine if there is common functionality and if it makes
> sense to use GSMTAP or not :)

Agree. Sorry about that. No disrespect was intended, but I'm still not
sure I understand the need for UDP encapsulation *as part of the
protocol*. I guess saying "GSMTAP can optionally be encapsulated in UDP
with the well-known port xyz" would be something else, and it'd make
more sense to me than saying it has to be.

> So far I have not seen any explanation about what kind of data you want
> to encapsulate at all.

Right, see my other mail(s) from today as well. Basically the IP frame
that we're actually sending, and then attaching to that the "session" or
"mux id" that it's being sent on. Sorry, I probably also don't know the
right term - those show up in the drivers now.

> > just a pretty strange design if the kernel were to output this, I'm not
> > even sure how I'd do that properly. I don't want to be generating UDP
> > packets there...
> 
> There are well-established APIs for having sockets in the kernel and for
> generating + receiving UDP packets from it.  NFS has been doing this for
> decades, as do various kernel-side tunneling helpers including the GTP
> kernel module.
> 
> I'm not saying it's the right approach for your problem, I'm just saying
> kernel-side code can for sure use UDP sockets.

Of course it *can*. But I don't think it makes *sense*. The key feature
here isn't communicating with somebody else (unlike NFS, GTP, GENEVE and
whatever other protocol they have). In fact, you shouldn't really care
about the communication part per se at all, I'd think.

> Sure, that works.  But the real question is, to me:  Are there common
> GSMTAP payload types that both the existing GSMTAP users carry, as well
> as what you would want to carry?  If yes, then it makes sense to think
> about a common encapsulation like GSMTAP.  If the payload types differ,
> then it seems rather like there are two distinct use cases that
> wouldn't benefit from standardizing on one format.

Agree, and I don't really know.

Maybe I should start differently. Do you have an example GSMTAP capture
file that I could look at in wireshark? Yes, I see you've pointed out
how I can get all the software running, but if you have a file already
that's almost certainly faster :-)

And then the question I'd want answer is this: If there's an IP frame
that I send to the modem from the application using a regular UDP or TCP
socket, what would the corresponding GSMTAP capture look like? Surely it
includes the IP frame in some way?!

If the answer to that question is yes, then I think there is some
overlap, because you can always imagine the modem receiving an IP frame
and telling you more about how it was encapsulated over the air, no?
Mind, most if not all modems probably don't actually do that today, but
I wonder how much of that is because of lack of infrastructure to do it,
vs. it just not being necessary - since I've been told that the modems
do in fact often output tracing that contains information about this.
Just not directly combined with the IP frame.

johannes

