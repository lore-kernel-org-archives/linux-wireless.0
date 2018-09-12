Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:55264 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeILNyS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 09:54:18 -0400
Message-ID: <1536742236.3678.10.camel@sipsolutions.net> (sfid-20180912_105051_597347_3DCCB264)
Subject: Re: [RFC v2 2/2] netlink: add ethernet address policy types
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Michal Kubecek <mkubecek@suse.cz>
Date: Wed, 12 Sep 2018 10:50:36 +0200
In-Reply-To: <5B98D336.4090107@broadcom.com> (sfid-20180912_105004_080743_245162B9)
References: <20180912083610.20857-1-johannes@sipsolutions.net>
         <20180912083610.20857-2-johannes@sipsolutions.net>
         <5B98D336.4090107@broadcom.com> (sfid-20180912_105004_080743_245162B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-12 at 10:49 +0200, Arend van Spriel wrote:
> On 9/12/2018 10:36 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Commonly, ethernet addresses are just using a policy of
> > 	{ .len = ETH_ALEN }
> > which leaves userspace free to send more data than it should,
> > which may hide bugs.
> > 
> > Introduce NLA_ETH_ADDR which checks for exact size, and rejects
> > the attribute if the length isn't ETH_ALEN.
> > 
> > Also add NLA_ETH_ADDR_COMPAT which can be used in place of the
> > policy above, but will, in addition, warn on an address that's
> > too long.
> 
> Not sure if this is correctly described here. It seems longer addresses 
> are not rejected, but only result in a warning message. I guess the 
> problem is in the reference to the "policy above" ;-)

Yeah, good point. I meant ".len = ETH_ALEN" but should clarify that.

johannes
