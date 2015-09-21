Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbbIUGIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 02:08:01 -0400
Date: Sun, 20 Sep 2015 23:07:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: Chaehyun Lim <chaehyun.lim@gmail.com>, rachel.kim@atmel.com,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 08/18] staging: wilc1000: remove declaration of
 WILC_WFI_frame_register
Message-ID: <20150921060758.GA24173@kroah.com> (sfid-20150921_080805_663167_B035CF5D)
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
 <1442731885-4344-8-git-send-email-chaehyun.lim@gmail.com>
 <20150921020143.GC22262@kroah.com>
 <55FF9B94.9020300@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55FF9B94.9020300@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 21, 2015 at 02:54:28PM +0900, Tony Cho wrote:
> 
> 
> On 2015년 09월 21일 11:01, Greg KH wrote:
> >On Sun, Sep 20, 2015 at 03:51:15PM +0900, Chaehyun Lim wrote:
> >>This patch removes function declaration of WILC_WFI_frame_register in
> >>linux_wlan.c file, then adds it in wilc_wfi_cfgoperations.h file.
> >>
> >>The compilation warning occurs because it is assigned to incorrect
> >>pointer type of second parameter of WILC_WFI_frame_register.
> >>It is assigned with struct wireless_dev pointer type.
> >How was this code ever even working properly if the wrong pointer was
> >being passed into it?
> >
> >Tony, what is going on here, is this code just never called?  If so, can
> >we just delete the whole function?
> >
> >thanks,
> >
> >greg k-h
> 
> This file with linux_wlan.c file is being fully changed, but at this time, the second parameter which passed as
> net_device pointer instead of wireless_dev incorrectly is never being used inside the WILC_WFI_frame_register().
> That's why no problem is found yet.

Then we should just delte the parameter entirely, no need to pass
something into a function that is never used.

Please, someone do that instead.

thanks,

greg k-h
