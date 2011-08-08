Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1HHP61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 11:58:27 -0400
Subject: Re: [RFC] mac80211: fix resuming when device is gone
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110808141900.GA25857@redhat.com>
References: <20110808141900.GA25857@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:58:26 +0200
Message-ID: <1312819106.4372.37.camel@jlt3.sipsolutions.net> (sfid-20110808_175830_275504_AE86417D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 16:19 +0200, Stanislaw Gruszka wrote:
> Is possible that usb hardware can be unplugged during or before resume.
> If so do not call ieee80211_reconfig(), which among other things arm
> sta_cleanup timer. Timer callback then operate on freed memory.

> I have this warning with possible fallow up crash without physically
> unplugging device, but usb core rebind rt73usb with message:
> 
> "rt73usb 1-2:1.0: no reset_resume for driver rt73usb?"
> 
> What probably also need to be fixed in rt2x00. But I think fix in
> mac80211 is needed for possibility of physical remove. Not sure if this
> is best possible fix, through. Maybe just preventing arming sta_cleanup
> would be better, other things in ieee80211_reconfig() seems to work.

But ... if sta_cleanup timer operates on freed memory, why doesn't
"local->registered"?

johannes

