Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:58800 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761807AbZAPWGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 17:06:06 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] p54usb: fix conflict with recent usb changes
Date: Fri, 16 Jan 2009 23:06:01 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200901162024.31636.chunkeey@web.de> <20090116211351.GA15245@tuxdriver.com>
In-Reply-To: <20090116211351.GA15245@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901162306.02046.chunkeey@web.de> (sfid-20090116_230611_599824_AEA76526)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 January 2009 22:13:52 John W. Linville wrote:
> On Fri, Jan 16, 2009 at 08:24:31PM +0100, Christian Lamparter wrote:
> > A recent change in the usb core "USB: change interface to usb_lock_device_for_reset()" 
> > conflicts with "p54usb: utilize usb_reset_device for 3887".
> > 
> > Sadly, we have to call usb_reset_device before we can upload the firmware on 3887.
> > Unless someone figures out how to reliably stop the 3887 so the hardware is still usable
> > next time we want to start it.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > ---
> > John,
> > 
> > I guess this patch should be in the next wireless-2.6 pull.
> > And it would be nice, if you can put "[PATCH] p54: fix p54_set_key's return code" in there too. 
> 
> The other patch seems fine, but this one doesn't apply to wireless-2.6
> -- p54u_device_reset_3887 doesn't seem to exist there?
> 
> I'll apply this in wireless-testing and eventually to wireless-next-2.6,
> unless you send me an alternative patch based on wireless-2.6?
Ahh, wait... I guess, I know what's wrong here.

This patch "p54usb: fix conflict with recent usb changes" depends on
"[PATCH 1/3] p54usb: utilize usb_reset_device for 3887", which was posted on 26. Dec 2008 together with:
"[PATCH 2/3] p54: prevent upload of wrong firmwares" (unimportant here) and 
"[PATCH 3/3] p54: fix WARN_ON at line 2247 of net/mac80211/rx.c" (now: commit 124b68e755c2ef9342d5d477142c499fd7901360 in linus' tree)

And this is were everything went wrong... Because of "p54: fix WARN_ON at line 2247 ..." merge, 
I thought you pushed the whole series upstream and not just the last patch ;-).

Sorry!

Regards,
	Chr
