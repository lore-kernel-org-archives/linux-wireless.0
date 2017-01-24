Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48000 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750889AbdAXI5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 03:57:36 -0500
Message-ID: <1485248251.7244.3.camel@sipsolutions.net> (sfid-20170124_095739_620257_8E57AAC4)
Subject: Re: [PATCH] nl80211: fix validation of scheduled scan info for
 wowlan netdetect
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 24 Jan 2017 09:57:31 +0100
In-Reply-To: <bde55d09-6f3e-1f90-4aef-0e1169c11cf6@broadcom.com> (sfid-20170119_140531_409855_6CA9D983)
References: <1484820088-24448-1-git-send-email-arend.vanspriel@broadcom.com>
         <1484827206.2774.12.camel@coelho.fi>
         <bde55d09-6f3e-1f90-4aef-0e1169c11cf6@broadcom.com>
         (sfid-20170119_140531_409855_6CA9D983)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-19 at 14:08 +0100, Arend Van Spriel wrote:
> 
> On 19-1-2017 13:00, Luca Coelho wrote:
> > On Thu, 2017-01-19 at 10:01 +0000, Arend van Spriel wrote:
> > > For wowlan netdetect a separate limit is defined for the number
> > > of
> > > matchsets. Currently, this limit is ignored and the regular limit
> > > for scheduled scan matchsets, ie. struct wiphy::max_match_sets,
> > > is
> > > used for the net-detect case as well.
> > > 
> > > Cc: Luciano Coelho <luciano.coelho@intel.com>
> > > Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > > ---
> > 
> > What?! You don't have the same number of matchsets for both? :P
> 
> Actually I have, but your comment mentioned they do not have to be
> the
> same. brcmfmac actually did not set max_nd_match_sets so I was
> surprised
> it worked. That said this patch will result in regression in brcmfmac
> :-p Not sure about other drivers supporting net-detect.

So do you want to submit a patch to brcmfmac first, and then I'll apply
this later? I can apply it and break it, but now that we already know
...?

johannes
