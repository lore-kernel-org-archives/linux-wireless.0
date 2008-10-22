Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:56109 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYJVRHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 13:07:10 -0400
Received: by ey-out-2122.google.com with SMTP id 6so1014938eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 10:07:08 -0700 (PDT)
To: Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH] Fix debugfs_create_*'s error checking method for wireless/rt2x00/
Date: Wed, 22 Oct 2008 19:07:04 +0200
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
References: <48FEED4D.3000208@cn.fujitsu.com>
In-Reply-To: <48FEED4D.3000208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="gb2312"
Message-Id: <200810221907.04946.IvDoorn@gmail.com> (sfid-20081022_190716_743060_171523E7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 October 2008, Zhaolei wrote:
> Hi,
> 
> debugfs_create_*() returns NULL if an error occurs, returns -ENODEV
> when debugfs is not enabled in the kernel.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Looks good. Thanks.
John, could you pull this into wireless-testing? Thanks!

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00debug.c |   21 ++++++++++++---------
>  1 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
> index 5cf4c85..b380cd3 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00debug.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
> @@ -587,29 +587,29 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
>  	intf->driver_folder =
>  	    debugfs_create_dir(intf->rt2x00dev->ops->name,
>  			       rt2x00dev->hw->wiphy->debugfsdir);
> -	if (IS_ERR(intf->driver_folder))
> +	if (IS_ERR(intf->driver_folder) || !intf->driver_folder)
>  		goto exit;
>  
>  	intf->driver_entry =
>  	    rt2x00debug_create_file_driver("driver", intf, &intf->driver_blob);
> -	if (IS_ERR(intf->driver_entry))
> +	if (IS_ERR(intf->driver_entry) || !intf->driver_entry)
>  		goto exit;
>  
>  	intf->chipset_entry =
>  	    rt2x00debug_create_file_chipset("chipset",
>  					    intf, &intf->chipset_blob);
> -	if (IS_ERR(intf->chipset_entry))
> +	if (IS_ERR(intf->chipset_entry) || !intf->chipset_entry)
>  		goto exit;
>  
>  	intf->dev_flags = debugfs_create_file("dev_flags", S_IRUSR,
>  					      intf->driver_folder, intf,
>  					      &rt2x00debug_fop_dev_flags);
> -	if (IS_ERR(intf->dev_flags))
> +	if (IS_ERR(intf->dev_flags) || !intf->dev_flags)
>  		goto exit;
>  
>  	intf->register_folder =
>  	    debugfs_create_dir("register", intf->driver_folder);
> -	if (IS_ERR(intf->register_folder))
> +	if (IS_ERR(intf->register_folder) || !intf->register_folder)
>  		goto exit;
>  
>  #define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)	\
> @@ -619,7 +619,8 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
>  			       S_IRUSR | S_IWUSR,		\
>  			       (__intf)->register_folder,	\
>  			       &(__intf)->offset_##__name);	\
> -	if (IS_ERR((__intf)->__name##_off_entry))		\
> +	if (IS_ERR((__intf)->__name##_off_entry)		\
> +			|| !(__intf)->__name##_off_entry)	\
>  		goto exit;					\
>  								\
>  	(__intf)->__name##_val_entry =				\
> @@ -627,7 +628,8 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
>  				S_IRUSR | S_IWUSR,		\
>  				(__intf)->register_folder,	\
>  				(__intf), &rt2x00debug_fop_##__name);\
> -	if (IS_ERR((__intf)->__name##_val_entry))		\
> +	if (IS_ERR((__intf)->__name##_val_entry)		\
> +			|| !(__intf)->__name##_val_entry)	\
>  		goto exit;					\
>  })
>  
> @@ -640,13 +642,14 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
>  
>  	intf->queue_folder =
>  	    debugfs_create_dir("queue", intf->driver_folder);
> -	if (IS_ERR(intf->queue_folder))
> +	if (IS_ERR(intf->queue_folder) || !intf->queue_folder)
>  		goto exit;
>  
>  	intf->queue_frame_dump_entry =
>  	    debugfs_create_file("dump", S_IRUSR, intf->queue_folder,
>  				intf, &rt2x00debug_fop_queue_dump);
> -	if (IS_ERR(intf->queue_frame_dump_entry))
> +	if (IS_ERR(intf->queue_frame_dump_entry)
> +		|| !intf->queue_frame_dump_entry)
>  		goto exit;
>  
>  	skb_queue_head_init(&intf->frame_dump_skbqueue);
> -- 1.5.5.3 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


