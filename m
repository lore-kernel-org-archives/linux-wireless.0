Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:42989 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZI2DdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 23:33:08 -0400
Received: by ewy7 with SMTP id 7so5041197ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 20:33:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090929025509.GB6529@mosca>
References: <3ace41890909281935k284402f3q90b54ae20a636eeb@mail.gmail.com>
	 <20090929025509.GB6529@mosca>
Date: Tue, 29 Sep 2009 04:33:09 +0100
Message-ID: <3ace41890909282033h7b3825a6n22265f3c6f0a5b72@mail.gmail.com>
Subject: Re: compat-wireless master-2009-09-28 breakage and suggested fixes
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 3:55 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Sep 28, 2009 at 07:35:22PM -0700, Hin-Tak Leung wrote:
>> commit d0cf9c0dadcdc89a755bcb301cfc9c796eb28ccf
>> Author: Stephen Hemminger <shemminger@vyatta.com>
>> Date:   Mon Aug 31 19:50:57 2009 +0000
>>
>>     wireless: convert drivers to netdev_tx_t
>>
>> and the 2nd change due to this:
>>
>> commit 384912ed194e43c03ad1cdaa09b0b1e488c34d46
>> Author: Marcel Holtmann <marcel@holtmann.org>
>> Date:   Mon Aug 31 21:08:19 2009 +0000
>>
>>     net: Add DEVTYPE support for Ethernet based devices
>>
>> Both of these changes are traced back to changes in
>> <linux/netdevice.h> , which compat-wireless does not ship. What's your
>> policy on these kind of changes to compat-wireless?
>> (the 2nd SET_NETDEV_DEVTYPE change probably can be spanned by an
>> ifndef SET_NETDEV_DEVTYPE, and roll into
>> "compat/patches/01-netdev.patch"? Should the first kind of change also
>> go into compat/patches/01-netdev.patch?)
>
> I don't see this yet on wireless-testing but it is on 2.6.32.
> I backported this as follows. I'll push this out shortly.
>
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Subject: [PATCH] Fix compilation against for 2.6.32 changes
>
> 2.6.32 added SET_NETDEV_DEVTYPE() and netdev_tx

Argh, I see what you are getting at: codes that emulates "API changes
between 2.6.(x-1) and 2.6.(x)" go into file
compat/compat-2.6.(x).{h,c} .
The 'compatibility code for new kernel' wording wasn't too obvious :-).

>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked.

> ---
>  compat/compat-2.6.32.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/compat/compat-2.6.32.h b/compat/compat-2.6.32.h
> index f7081f2..418b521 100644
> --- a/compat/compat-2.6.32.h
> +++ b/compat/compat-2.6.32.h
> @@ -31,6 +31,18 @@
>
>  #define dev_change_net_namespace(a, b, c) (-EOPNOTSUPP)
>
> +#define SET_NETDEV_DEVTYPE(netdev, type)
> +
> +#ifdef __KERNEL__
> +/* Driver transmit return codes */
> +enum netdev_tx {
> +       BACKPORT_NETDEV_TX_OK = NETDEV_TX_OK,       /* driver took care of packet */
> +       BACKPORT_NETDEV_TX_BUSY = NETDEV_TX_BUSY,         /* driver tx path was busy*/
> +       BACKPORT_NETDEV_TX_LOCKED = NETDEV_TX_LOCKED,  /* driver tx lock was already taken */
> +};
> +typedef enum netdev_tx netdev_tx_t;
> +#endif /* __KERNEL__ */
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
>
>  #endif /* LINUX_26_32_COMPAT_H */
> --
> 1.6.3.3
>
>
