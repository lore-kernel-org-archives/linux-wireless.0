Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64146 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3HVPJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 11:09:52 -0400
Received: by mail-ob0-f169.google.com with SMTP id wc20so3912711obb.28
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2013 08:09:51 -0700 (PDT)
Date: Thu, 22 Aug 2013 10:09:50 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: ignore obviously bogus ECSAs in probe response
 frames
Message-ID: <20130822150950.GD24445@thinkpad-t410> (sfid-20130822_170955_581484_C5E13799)
References: <1377179613-26591-1-git-send-email-seth.forshee@canonical.com>
 <1377180063.14110.23.camel@jlt4.sipsolutions.net>
 <20130822141011.GA24445@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130822141011.GA24445@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 22, 2013 at 09:10:11AM -0500, Seth Forshee wrote:
> On Thu, Aug 22, 2013 at 04:01:03PM +0200, Johannes Berg wrote:
> > On Thu, 2013-08-22 at 08:53 -0500, Seth Forshee wrote:
> > > The Netgear WNDAP360 sends invalid ECSA IEs in probe response
> > > frames
> > 
> > I think we shouldn't be checking probe response frames at all. That
> > seems like a mistake. Can you try this?
> 
> I had considered this, but the spec says that it's at least valid for
> the AP to be sending ECSAs in probe responses. IEEE 802.11-2012 section
> 10.3.3.2:
> 
>   ...an AP shall inform associated STAs that the AP is moving to a new
>   channel and/or operating class and maintain the association by
>   advertising the switch using Extended Channel Switch Announcement
>   elements in any transmitted Beacon frames, Probe Response frames, and
>   Extended Channel Switch Announcement frames until the intended channel
>   switch time.
> 
> Perhaps we can still ignore them though? I suppose we'd expect to
> receive some other frame with the ECSA before it actually happens.

Anyway, your fix also eliminates the disconnects, so whichever solution
you think best is fine. There is a build failure though.

+       ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
+                                        elems, true);

Needs to be &elems here.

Thanks,
Seth
