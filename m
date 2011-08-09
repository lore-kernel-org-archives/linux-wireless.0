Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1HIJXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:23:09 -0400
Date: Tue, 9 Aug 2011 11:23:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: fix resuming when device is gone
Message-ID: <20110809092314.GA2152@redhat.com> (sfid-20110809_112313_854110_DF90251D)
References: <20110808141900.GA25857@redhat.com>
 <1312819106.4372.37.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1312819106.4372.37.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 08, 2011 at 05:58:26PM +0200, Johannes Berg wrote:
> On Mon, 2011-08-08 at 16:19 +0200, Stanislaw Gruszka wrote:
> > Is possible that usb hardware can be unplugged during or before resume.
> > If so do not call ieee80211_reconfig(), which among other things arm
> > sta_cleanup timer. Timer callback then operate on freed memory.
> 
> > I have this warning with possible fallow up crash without physically
> > unplugging device, but usb core rebind rt73usb with message:
> > 
> > "rt73usb 1-2:1.0: no reset_resume for driver rt73usb?"
> > 
> > What probably also need to be fixed in rt2x00. But I think fix in
> > mac80211 is needed for possibility of physical remove. Not sure if this
> > is best possible fix, through. Maybe just preventing arming sta_cleanup
> > would be better, other things in ieee80211_reconfig() seems to work.
> 
> But ... if sta_cleanup timer operates on freed memory, why doesn't
> "local->registered"?

I think I was unclear. The sta_cleanup timer callback, namely
sta_info_cleanup(), can operate on freed memory. On
ieee80211_unregister_hw() -> sta_info_stop() we delete this timer, but
rdev/wiphy/local/hw structure is not freed. It's keep by reference
counter. Then if ieee80211_reconfig() is called, we schedule
sta_cleanup timer. After that, when sysfs drop reference counter we
free rdev. Then sta_info_cleanup() crash kernel.

Stanislaw
