Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:54219 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882AbZHDRJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 13:09:53 -0400
Received: by ewy10 with SMTP id 10so497523ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 10:09:53 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: cancel all work on disconnect
Date: Tue, 4 Aug 2009 19:09:50 +0200
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <20090802183002.16766.4142.stgit@ct.roinet.com> <20090802183015.16766.56837.stgit@ct.roinet.com>
In-Reply-To: <20090802183015.16766.56837.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908041909.50599.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 02 August 2009, Pavel Roskin wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Thanks,

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 658a63b..b4c696d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -893,6 +893,12 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  	rt2x00lib_disable_radio(rt2x00dev);
>  
>  	/*
> +	 * Stop all work.
> +	 */
> +	cancel_work_sync(&rt2x00dev->filter_work);
> +	cancel_work_sync(&rt2x00dev->intf_work);
> +
> +	/*
>  	 * Uninitialize device.
>  	 */
>  	rt2x00lib_uninitialize(rt2x00dev);
> 
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
> 


