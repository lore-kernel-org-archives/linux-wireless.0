Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52755 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaBNOaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 09:30:18 -0500
Date: Fri, 14 Feb 2014 09:27:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [3.14 FIX][PATCH] bcma: gpio: register all 32 GPIOs
Message-ID: <20140214142726.GL22203@tuxdriver.com> (sfid-20140214_153023_426623_4B192DBE)
References: <1392311186-7805-1-git-send-email-zajec5@gmail.com>
 <52FD569F.1070408@hauke-m.de>
 <CACna6rzAC1Z91TGRffuTcqV-tLpGwE52hzAXOgMstn4mZnLTbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzAC1Z91TGRffuTcqV-tLpGwE52hzAXOgMstn4mZnLTbg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 14, 2014 at 01:01:00PM +0100, Rafał Miłecki wrote:
> 2014-02-14 0:34 GMT+01:00 Hauke Mehrtens <hauke@hauke-m.de>:
> > On 02/13/2014 06:06 PM, Rafał Miłecki wrote:
> >> Broadcom boards have 32 GPIOs (not 16) and these higher ones are
> >> actually used on some devices (for buttons, reset of WiFi devices).
> >>
> >> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> >> ---
> >> Similar patch may be needed for ssb, however I didn't meet any ssb SoC
> >> with GPIOs 16-31 connected to anything.
> >> This is so trivial I hope it can go as a fix for 3.14. It allows support
> >> for some devices that use these higher GPIOs.
> >> ---
> >>  drivers/bcma/driver_gpio.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> > Are you sure all the bcma SoC have 32 GPIO lines or is there no problem
> > when they do not? For at least some ssb based SoCs I know that they only
> > have 16 GPIO lines.
> 
> Damn, I'm afraid you may be right. I didn't think about that.
> 
> I was able to find references to GPIOs 16-31 on BCM5357 based boards only.

Sounds like I need to revert that patch.

Please never, _ever_, post a patch (no matter how trivial) for the
stable tree unless you are absolutely sure about it in the first place.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
