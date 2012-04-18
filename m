Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33093 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2DRW74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 18:59:56 -0400
Received: by wejx9 with SMTP id x9so5040089wej.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 15:59:55 -0700 (PDT)
Message-ID: <4F8F476B.3040800@gmail.com> (sfid-20120419_010000_146627_230C450A)
Date: Thu, 19 Apr 2012 00:59:55 +0200
From: Mircea Gherzan <mgherzan@gmail.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wl12xx: fix DMA-API-related warnings
References: <20120416104858.GA24159@elgon.mountain>
In-Reply-To: <20120416104858.GA24159@elgon.mountain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luciano,

Am 16.04.2012 12:48, schrieb Dan Carpenter:
> Hello Mircea Gherzan,
> 
> The patch 690142e98826: "wl12xx: fix DMA-API-related warnings" from
> Mar 17, 2012, leads to the following Smatch warning:
> drivers/net/wireless/ti/wlcore/cmd.c:126 wl1271_cmd_wait_for_event_or_timeout()
> 	 error: no modifiers for allocation.

How would you prefer my fix for this issue: as a new version of the
original patch or as a separate new patch?

Thanks,
Mircea

>  static void wl1271_boot_fw_version(struct wl1271 *wl)
>  {
> -       struct wl1271_static_data static_data;
> +       struct wl1271_static_data *static_data;
>  
> -       wl1271_read(wl, wl->cmd_box_addr, &static_data, sizeof(static_data),
> +       static_data = kmalloc(sizeof(*static_data), GFP_DMA);
>                                                     ^^^^^^^
> You can't use GFP_DMA by itself like that, it needs to ORed with
> GFP_KERNEL or GFP_ATOMIC or something like that:
> 
> 	static_data = kmalloc(sizeof(*static_data), GFP_KERNEL | GFP_DMA);
> 
> +       if (!static_data) {
> +               __WARN();
> +               return;
> 
> There are a couple other places in this patch which do the same thing.
> Could you fix it, please?
> 
> regards,
> dan carpenter
> 


-- 
Mircea
