Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbbG3Bkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 21:40:42 -0400
Date: Wed, 29 Jul 2015 18:40:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "tony.cho" <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 21/21] staging: wilc1000: update TODO list of WILC1000
Message-ID: <20150730014041.GA3626@kroah.com> (sfid-20150730_034045_120897_EA808D52)
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
 <1438073261-28315-22-git-send-email-tony.cho@atmel.com>
 <20150729210123.GA25941@kroah.com>
 <55B97E17.5050007@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55B97E17.5050007@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2015 at 10:29:59AM +0900, tony.cho wrote:
> 
> On 2015년 07월 30일 06:01, Greg KH wrote:
> >On Tue, Jul 28, 2015 at 05:47:40PM +0900, Tony Cho wrote:
> >>The TODO list is updated for the WILC1000 kernel driver. The TODO list
> >>contains many items listed in time sequence.
> >I don't understand what you mean by "in time sequence"
> 
> Sorry for unclear sentence. This means I will work them step by step
> in chronological order.

That isn't necessary, lots of people might want to work on these, there
shouldn't be any specific order in which they, or you, do them.

> >>Signed-off-by: Tony Cho <tony.cho@atmel.com>
> >>Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> >>---
> >>  drivers/staging/wilc1000/TODO | 13 +++++++------
> >>  1 file changed, 7 insertions(+), 6 deletions(-)
> >>
> >>diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
> >>index 95199d8..6b745cd 100644
> >>--- a/drivers/staging/wilc1000/TODO
> >>+++ b/drivers/staging/wilc1000/TODO
> >>@@ -1,14 +1,15 @@
> >>  TODO:
> >>-- remove the defined feature as kernel versions
> >>-- remove OS wrapper functions
> >>-- remove custom debug and tracing functions
> >>+- remove most of warnings reported by checkpatch.pl
> >"most"?  Why not all?
> 
> I will end up to remove all of warnings (I must make it) but I need to do them step by step. Most warnings are
> from both camelcase and line over 80 characters. They will be removed after most warnings are removed to avoid
> confusing new driver coming soon. Again, I will remove all of warnings.

That's fine, just don't change this TODO item.

> >>  - rework comments and function headers(also coding style)
> >>  - replace all semaphores with mutexes or completions
> >>-- make spi and sdio components coexist in one build
> >Why remove this item?  It's not done and needs to be done.
> 
> The first two lines are still in my TODO list. Do you mean coexistence of spi and sdio? If yes, I will recheck
> the driver to find out good solution as you recommend.
> 
> >>+- remove compile warnings related to 64 bit machine
> >That's a given, I'm not enabling the build of the driver until that
> >happens. Please work on that next, coding style fixes can happen after
> >that.  As of right now, this driver is marked BROKEN.
> >
> >thanks,
> >
> >greg k-h
> 
> As you mentioned, I believe it's very important to break down BROKEN status. I will soon send the 64 bit patches
> to remove compile warnings while fixing coding styles at the same time. As you know, there are the structural issues
> to resolve them in the driver, for example, redundant casting which causes build warnings and the codes are not
> readable. However, I will cut down all of them.

Try doing the 64bit changes first, then worry about the coding style
issues after that is working properly.  If the driver stays BROKEN for
another release, I'm going to have to remove it from the tree :(

thanks,

greg k-h
