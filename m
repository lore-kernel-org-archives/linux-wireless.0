Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56493 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbcFULNF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 07:13:05 -0400
Message-ID: <1466501787.3170.12.camel@sipsolutions.net> (sfid-20160621_131347_804958_FB9011D1)
Subject: Re: NL80211_ATTR_PAD question
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 21 Jun 2016 11:36:27 +0200
In-Reply-To: <575F089C.3020201@broadcom.com> (sfid-20160613_212518_019571_6F7C96F1)
References: <575B1964.2030806@candelatech.com>
 <1465592932.2308.6.camel@sipsolutions.net> <575F089C.3020201@broadcom.com>
	 (sfid-20160613_212518_019571_6F7C96F1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-06-13 at 21:25 +0200, Arend van Spriel wrote:
> 
> On 10-06-16 23:08, Johannes Berg wrote:
> > On Fri, 2016-06-10 at 12:47 -0700, Ben Greear wrote:
> > > I see this was added sometime recently:  NL80211_ATTR_PAD
> > > 
> > > If another enum member is added, should it replace the PAD enum?
> > 
> > No.
> > 
> > > At the least, I think we need some comments about how this is to
> > > be
> > > dealt with.
> > > 
> > 
> > You simply ignore it :)
> 
> So do you know why the caller of nla_put_u64_64bit() would need to
> specify the padattr. I mean, why is this not an generic attribute
> that
> netlink deals with internally. It has probably been discussed on the
> netdev list but I could not find the right thread.
> 

Netlink attribute numbers are always specific to the (generic) netlink
family used. There was a discussion about using the attribute number 0
since that's reserved, but unfortunately it's only reserved in *most*
families, some actually use it (despite that being broken with libnl.)

johannes
