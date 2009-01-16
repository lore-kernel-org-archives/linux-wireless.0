Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47250 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbZAPVPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 16:15:49 -0500
Date: Fri, 16 Jan 2009 16:13:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54usb: fix conflict with recent usb changes
Message-ID: <20090116211351.GA15245@tuxdriver.com> (sfid-20090116_221555_703857_F49EDC2B)
References: <200901162024.31636.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200901162024.31636.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 08:24:31PM +0100, Christian Lamparter wrote:
> A recent change in the usb core "USB: change interface to usb_lock_device_for_reset()" 
> conflicts with "p54usb: utilize usb_reset_device for 3887".
> 
> Sadly, we have to call usb_reset_device before we can upload the firmware on 3887.
> Unless someone figures out how to reliably stop the 3887 so the hardware is still usable
> next time we want to start it.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> John,
> 
> I guess this patch should be in the next wireless-2.6 pull.
> And it would be nice, if you can put "[PATCH] p54: fix p54_set_key's return code" in there too. 

The other patch seems fine, but this one doesn't apply to wireless-2.6
-- p54u_device_reset_3887 doesn't seem to exist there?

I'll apply this in wireless-testing and eventually to wireless-next-2.6,
unless you send me an alternative patch based on wireless-2.6?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
