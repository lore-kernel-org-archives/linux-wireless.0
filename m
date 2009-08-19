Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60032 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZHSOpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 10:45:12 -0400
Date: Wed, 19 Aug 2009 10:41:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT] p54: implement rfkill
Message-ID: <20090819144145.GA5905@tuxdriver.com>
References: <200907192354.15349.chunkeey@web.de> <20090807153602.GG7545@tuxdriver.com> <4A7C58CC.2040708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4A7C58CC.2040708@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 07, 2009 at 11:39:40AM -0500, Larry Finger wrote:
> John W. Linville wrote:
> > On Sun, Jul 19, 2009 at 11:54:15PM +0200, Christian Lamparter wrote:
> >> This patch gets rid of the deprecated radio_enabled
> >>
> >> fwio.c: In function ‘p54_setup_mac’:
> >> fwio.c:323: warning: ‘radio_enabled’ is deprecated (declared at include/net/mac80211.h:607)
> > 
> > Anyone had a chance to test this?  And report the results to Christian?
> 
> Sorry - I missed this one.
> 
> I just tested it. With the patch, the warning is removed. As far as
> system operation, the following is observed:
> 
> 1. If b43 is loaded when using p54usb, then the hardware switch will
> kill operation. This behavior is the same with or without this patch.
> 
> 2. If b43 is unloaded, then p54usb no longer follows the hardware
> switch, but operation can be killed with the rfkill user-space
> utility. Again, this behavior does not depend on the patch.
> 
> Based on the code changes in the patch, it looks as if the radio is
> turned off when the device is blocked, but I have no way to test that.
> 
> Christian - please add a
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net> to the patch and
> submit. This change should be in 2.6.32.
> 
> Larry

Original patch lacks a Signed-off-by...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
