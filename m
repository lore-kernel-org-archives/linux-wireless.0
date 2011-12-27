Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:39828 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab1L0Uyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 15:54:44 -0500
Date: Tue, 27 Dec 2011 22:54:35 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: QoS frames in AP mode?
Message-ID: <20111227205435.GA31878@w1.fi> (sfid-20111227_215447_932947_7A4653C5)
References: <CAGXE3d9dCL+tnXg5ero51cxf3T9VPVgv8oKo51Vi_gWd8as9Xw@mail.gmail.com>
 <1323968408.31153.1.camel@jlt3.sipsolutions.net>
 <CAGXE3d8iseEhF2+w2riO=w_aMDdi8Uv4+w7URCM+PxYG19eYww@mail.gmail.com>
 <1324024068.3429.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1324024068.3429.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 16, 2011 at 09:27:48AM +0100, Johannes Berg wrote:
> On Fri, 2011-12-16 at 09:14 +0100, Helmut Schaa wrote:
> > On Thu, Dec 15, 2011 at 6:00 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > 
> > >>         /* skb->priority values from 256->263 are magic values to
> > >>          * directly indicate a specific 802.1d priority.  This is used
> > >>          * to allow 802.1d priority to be passed directly in from VLAN
> > >>          * tags, etc.
> > >>          */
> > >>         if (skb->priority >= 256 && skb->priority <= 263)
> > >>                 return skb->priority - 256;
> > 
> > Is this code still valid? I haven't found a reference in the 802.1q code :(
> 
> I always thought you'd use like iptables to set it to the right value,
> but I have no idea.

Yes, if my memory serves me right, this was indeed the original reason
for this code (from almost ten years ago... ;-). It was used in some
interesting combination of iptables and tc rules.

-- 
Jouni Malinen                                            PGP id EFC895FA
