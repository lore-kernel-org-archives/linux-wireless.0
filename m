Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:53607 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYLHOUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 09:20:22 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/6 v2.2] mac80211: add sta_notify_ps callback
Date: Mon, 8 Dec 2008 15:20:20 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
References: <200811292232.56550.chunkeey@web.de> <200812021655.53141.chunkeey@web.de> <1228731369.22164.70.camel@johannes.berg>
In-Reply-To: <1228731369.22164.70.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812081520.20666.chunkeey@web.de> (sfid-20081208_152026_301457_5424EF47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 December 2008 11:16:09 Johannes Berg wrote:
> On Tue, 2008-12-02 at 16:55 +0100, Christian Lamparter wrote:
> 
> > Do you think "This callback is optional. Only use it, if your hardware/
> > firmware really implements a station filter table" is enough (and correct spelled btw?)
> > Or do you volunteer for adding one or two DOC entries about APs, BC & MC Buffering,
> > TIM and station filters mechanism, caveats, and available callbacks or solutions?
> 
> Incidentally, I was entirely wrong about the sta_notify callback being
> allowed to sleep, it's not, it's under a spinlock, and, more
> importantly, RCU read lock for station removal (and this cannot be
> changed). Must have been wishful thinking...
> 
So?
can I move the notification enums STA_NOTIFY_SLEEP/STA_NOTIFY_AWAKE
to the sta_notify callback again, or is this wishful thinking as well?
After all, sta_notify wasn't intended to be used to tell the driver about
power state transitions but it does fit the bill...


Regards,
	Chr


