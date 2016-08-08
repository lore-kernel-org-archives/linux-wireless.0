Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58911 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbcHHGpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2016 02:45:32 -0400
Message-ID: <1470638725.2597.15.camel@sipsolutions.net> (sfid-20160808_084537_436408_206E13CD)
Subject: Re: wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: rasun Maiti <prasunmaiti87@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>
Date: Mon, 08 Aug 2016 08:45:25 +0200
In-Reply-To: <1470588577.4325.4.camel@decadent.org.uk> (sfid-20160807_184952_437873_8E01E9DD)
References: <1470588577.4325.4.camel@decadent.org.uk>
	 (sfid-20160807_184952_437873_8E01E9DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-08-07 at 17:49 +0100, Ben Hutchings wrote:
> I'm looking at commit 3d5fdff46c4b as part of the stable process.
> 
> The path it touches is only used for drivers that don't describe
> their private wext handlers, right?  So how can we know that the
> private ioctl is using the iw_point structure and not one of the
> other types in union iwreq_data?  Doesn't this result in a regression
> when another type is being used?
> 

Crap, that's good point. I'll revert the patch.

Fortunately this code path is never actually used. The only "mainline"
driver that appears to use it is staging/wilc1000.

I wonder if we should just remove it entirely. Yes, it'd break that
staging driver to some extent, but it's clearly an unsafe code path.

Prasun, did you need this for the mwifiex wext ioctl support that was
shot down anyway?

johannes
