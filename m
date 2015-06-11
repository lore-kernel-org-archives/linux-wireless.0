Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbbFKOqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 10:46:12 -0400
Date: Thu, 11 Jun 2015 07:46:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Rachel.kim@atmel.com, dean.lee@atmel.com, tony.cho@atmel.com,
	chris.park@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: modify data type
Message-ID: <20150611144611.GA3546@kroah.com> (sfid-20150611_164617_790929_65644812)
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
 <1433923607-20927-2-git-send-email-johnny.kim@atmel.com>
 <20150611004059.GA30902@kroah.com>
 <55791DB3.7080205@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55791DB3.7080205@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2015 at 02:33:39PM +0900, Johnny Kim wrote:
> 
> On 2015년 06월 11일 09:40, Greg KH wrote:
> >On Wed, Jun 10, 2015 at 05:06:44PM +0900, Johnny Kim wrote:
> >>-static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
> >>+static int wilc_wlan_cfg_commit(int type, size_t drvHandler)
> >Shouldn't this just be a void *?  And if so, why not the real function
> >pointer instead?
> >
> >Also, lots of these seem to be just pointers, please use a pointer
> >instead of hiding it in a size_t as that's the most portable, and
> >correct, way to do it.  No need to hide any function pointers here, this
> >isn't Windows :)
> >
> >thanks,
> >
> >greg k-h
> 
> To replace the integer to the pointer as your counsel, I need a lot of
> discussion internally.

Why "internally"?  Why not here in the development community?

> But I will fix the type and the related things like your thinking.

thank you.

> I know there is the build warning for 64-bit machine and this driver stays
> in BROKEN status on linux-next.
> I want to know if the reason is 64bit build warning.

Probably, fix them up and then we can see about getting that broken
status removed.

thanks,

greg k-h
