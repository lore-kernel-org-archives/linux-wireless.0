Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbbJYI0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 04:26:17 -0400
Date: Sat, 24 Oct 2015 18:21:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, johnny.kim@atmel.com,
	rachel.kim@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: wilc1000: return -ENOMEM when kmalloc failed
Message-ID: <20151025012143.GA7624@kroah.com> (sfid-20151025_092709_024917_E5760E3D)
References: <1445468856-18931-1-git-send-email-luisbg@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445468856-18931-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 22, 2015 at 12:07:36AM +0100, Luis de Bethencourt wrote:
> The driver is using -1 instead of the -ENOMEM defined macro to specify that
> a buffer allocation failed.
> 
> Fixes smatch warning and similars:
> drivers/staging/wilc1000/host_interface.c:1782 Handle_Key() warn:
> returning -1 instead of -ENOMEM is sloppy
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Doesn't apply against my tree anymore, can you refresh this against the
staging-testing branch of staging.git and resend?

thanks,

greg k-h
