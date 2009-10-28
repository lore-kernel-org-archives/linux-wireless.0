Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbZJ1Psn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 11:48:43 -0400
Subject: Re: iwlist wlan0 scan disrupts communications
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Charles Gordon <digigordo@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1256743398.4237.114.camel@johannes.local>
References: <86201b3f0910271340t51aa6c0bgff43e6e7211a0dee@mail.gmail.com>
	 <1256676190.4237.27.camel@johannes.local>
	 <86201b3f0910280747q557a6153oec929e8235459c8f@mail.gmail.com>
	 <1256741651.4237.112.camel@johannes.local>
	 <86201b3f0910280802r279bf0d8q3424245ddfb1f8a8@mail.gmail.com>
	 <1256743398.4237.114.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 28 Oct 2009 08:48:40 -0700
Message-Id: <1256744920.3850.28.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-10-28 at 16:23 +0100, Johannes Berg wrote:
> On Wed, 2009-10-28 at 11:02 -0400, Charles Gordon wrote:
> 
> > I think that when the scan completes, mac80211 should either notify
> > wpa_supplicant that it should reassociate, or maybe send a null-data
> > frame to the AP which might cause it to send another
> > deauthentication/dissassociation frame (if we lost the connect).
> 
> it does send nullfunc frames, you're probably running into an old bug
> that caused those to not be sent.

Correct, 2.6.28 did *not* have the nullfunc TX fix, so if the scan lasts
more than a few seconds, and the AP has traffic for the STA the TX will
time out, and the AP may drop the STA during the scan.  2.6.29 was the
first kernel that had the nullfunc TX fix.

But the supplicant should still reconnect...

Dan


