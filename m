Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbbIITwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 15:52:37 -0400
Date: Wed, 9 Sep 2015 11:17:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: remove kmalloc wrapper
Message-ID: <20150909181712.GA30637@kroah.com> (sfid-20150909_215247_206599_6879B70C)
References: <1441782493-11338-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441782493-11338-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 09, 2015 at 04:08:10PM +0900, Tony Cho wrote:
> From: Glen Lee <glen.lee@atmel.com>
> 
> Call kmalloc directly. No need to wrap kmalloc.
> Only one function, wilc_mq_send which use WILC_MALLOC, can be running in
> interrupt context or process context. In this case, We call in_interrupt to
> decide the flag, GFP_ATOMIC or GFP_KERNEL, for kmalloc properly. Additionally,
> there is one kmalloc which flag is always GFP_ATOMIC. This also changed
> together.
> Others are not holding a spin lock or in interrupt context. So use GFP_KERNEL
> flag for kmalloc.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c         | 110 +++++++++++-----------
>  drivers/staging/wilc1000/linux_wlan.c             |   2 +-
>  drivers/staging/wilc1000/wilc_msgqueue.c          |  10 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  38 ++++----
>  4 files changed, 83 insertions(+), 77 deletions(-)

This no longer applies to my staging-testing branch, can you rebase it
and resend it and the other patches in this series?

thanks,

greg k-h
