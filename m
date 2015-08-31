Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50033 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbbHaITo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 04:19:44 -0400
Message-ID: <1441009177.13980.6.camel@sipsolutions.net> (sfid-20150831_101955_429001_FE6435FC)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Date: Mon, 31 Aug 2015 10:19:37 +0200
In-Reply-To: <wrfjegik8vqy.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <55E289A3.6030001@lwfinger.net> <wrfjegik8vqy.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-08-30 at 14:41 -0400, Jes Sorensen wrote:
> 
> > > +> > > 	> > > urb = usb_alloc_urb(0, GFP_KERNEL);
> > 
> > The above statement generated a "scheduling while atomic" splat. The
> > gfp_t argument needs to be GFP_KERNEL.
> 
> You are seeing scheduling while atomic in the TX path? That just seems
> wrong to me - Johannes is the mac80211 TX path not meant to allow
> sleeping?

The TX path is one of the few things where you can't sleep - that's
needed for performance reasons since the network stack doesn't allow
sleeping in the TX path.

> I have never seen this on x86 and I have been running the driver for a
> long time. It is puzzling this causes a problem on PowerPC. It there
> something special in the config for it? I am inclined to say there is
> something wrong with the PPC32 setup rather than with my usage of
> GFP_KERNEL in the TX path.

No, using GFP_KERNEL is wrong here. You're perhaps not enabling enough
options for it to come to a warning on x86.

> johannes
