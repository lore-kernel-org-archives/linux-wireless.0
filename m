Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbbFKOr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 10:47:58 -0400
Date: Thu, 11 Jun 2015 07:47:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Dean.lee" <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: modify odd print message
Message-ID: <20150611144758.GA3671@kroah.com> (sfid-20150611_164802_194789_4AE6D53A)
References: <1433994264-26509-1-git-send-email-dean.lee@atmel.com>
 <20150611035037.GA22550@kroah.com>
 <5579140C.9070905@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5579140C.9070905@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2015 at 01:52:28PM +0900, Dean.lee wrote:
> 
> 
> On 2015년 06월 11일 12:50, Greg KH wrote:
> >On Thu, Jun 11, 2015 at 12:44:24PM +0900, Dean Lee wrote:
> >>This driver has odd message in print string.
> >>So this patch removes the data type.
> >>
> >>Signed-off-by: Dean Lee <dean.lee@atmel.com>
> >>---
> >>  drivers/staging/wilc1000/host_interface.c | 3 +--
> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >>diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> >>index 1ecb373..9e055c4 100644
> >>--- a/drivers/staging/wilc1000/host_interface.c
> >>+++ b/drivers/staging/wilc1000/host_interface.c
> >>@@ -703,7 +703,7 @@ static WILC_Sint32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperat
> >>  	strWID.s32ValueSize = sizeof(WILC_Uint32);
> >>  	/*Sending Cfg*/
> >>-	PRINT_INFO(HOSTINF_DBG, "(size_t)pstrWFIDrv= %p \n", pstrWFIDrv);
> >>+	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p \n", pstrWFIDrv);
> >Why are you printing a kernel pointer to userspace always?  That's not a
> >good idea, why not just delete this line, how useful is it?
> >
> >thanks,
> >
> >greg k-h
> we need this line for deep level debugging.
> sometime we need check and compare pointer value.

Really, even at this stage of development for the code?

> but we have plan for rework print message.
> delete unused & not required print message.

Good, all of them need to be reworked.

thanks,

greg k-h
