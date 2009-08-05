Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:48368 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZHESzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 14:55:05 -0400
Received: by ey-out-2122.google.com with SMTP id 9so215539eyd.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 11:55:04 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [rt2x00-users] [PATCH] rt2x00: fix memory corruption in rf cache, add a sanity check
Date: Wed, 5 Aug 2009 20:55:02 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
References: <1249422496.3489.2.camel@mj>
In-Reply-To: <1249422496.3489.2.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908052055.02412.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Change rt2x00_rf_read() and rt2x00_rf_write() to subtract 1 from the rf
> register number.  This is needed because the rf registers are enumerated
> starting with one.  The size of the rf register cache is just enough to
> hold all registers, so writing to the highest register was corrupting
> memory.  Add a check to make sure that the rf register number is valid.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Good catch. Thanks!

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> That's the issue reported by Michael Buesch:
> http://marc.info/?l=linux-wireless&m=124886312314098&w=2
> 
> With this patch and the patch to stop works on unload, rt73usb seems
> rock solid now. 
>
>  drivers/net/wireless/rt2x00/rt2x00.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index cbec91e..ee9afab 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -836,13 +836,15 @@ struct rt2x00_dev {
>  static inline void rt2x00_rf_read(struct rt2x00_dev *rt2x00dev,
>  				  const unsigned int word, u32 *data)
>  {
> -	*data = rt2x00dev->rf[word];
> +	BUG_ON(word < 1 || word > rt2x00dev->ops->rf_size / sizeof(u32));
> +	*data = rt2x00dev->rf[word - 1];
>  }
>  
>  static inline void rt2x00_rf_write(struct rt2x00_dev *rt2x00dev,
>  				   const unsigned int word, u32 data)
>  {
> -	rt2x00dev->rf[word] = data;
> +	BUG_ON(word < 1 || word > rt2x00dev->ops->rf_size / sizeof(u32));
> +	rt2x00dev->rf[word - 1] = data;
>  }
>  
>  /*
> 
> 
> 


