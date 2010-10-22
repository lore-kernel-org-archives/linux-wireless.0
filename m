Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44882 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0JVFaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 01:30:18 -0400
Received: by eye27 with SMTP id 27so491849eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 22:30:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik83ddeZtR-joexNSq2P_QW+V+TBTUq0AHpxLoj@mail.gmail.com>
References: <AANLkTik83ddeZtR-joexNSq2P_QW+V+TBTUq0AHpxLoj@mail.gmail.com>
Date: Thu, 21 Oct 2010 22:30:16 -0700
Message-ID: <AANLkTi=da3fZE=1RepeGZTOAA1GiWE8j8rQxnNFUo4r1@mail.gmail.com>
Subject: Re: Compat wireless breaks on kernels prior to 2.6.34 with the RT
 PREEMPT patch
From: Blaise Gassend <blaise@willowgarage.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing #ifdef XXX with the following might work:
#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) ||
defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)

On Thu, Oct 21, 2010 at 8:13 PM, Blaise Gassend <blaise@willowgarage.com> wrote:
> Hi,
>
> Compat wireless seems to not work with the RT PREEMPT patch for
> kernels prior to 2.6.34 because struct device does not contain sem. I
> would love to submit a patch like the one below, but I do not know how
> to detect that the RT PREEMPT patch has been applied. Does anybody
> happen to know?
>
> Thanks,
> Blaise
>
> --- compat-wireless-2010-10-09/include/linux/compat-2.6.34.h
> 2010-10-21 19:26:34.172694358 -0700
> +++ compat-wireless-2010-10-09-original/include/linux/compat-2.6.34.h
>  2010-10-21 19:23:10.494696161 -0700
> @@ -139,32 +139,20 @@
>  #endif
>  /* source: include/linux/netdevice.h */
>
>  static inline void device_lock(struct device *dev)
>  {
> -#ifdef XXX
> -        mutex_lock(&dev->parent->mutex);
> -#else
>        down(&dev->sem);
> -#endif
>  }
>
>  static inline int device_trylock(struct device *dev)
>  {
> -#ifdef XXX
> -        return mutex_trylock(&dev->mutex);
> -#else
>        return down_trylock(&dev->sem);
> -#endif
>  }
>
>  static inline void device_unlock(struct device *dev)
>  {
> -#ifdef XXX
> -        mutex_unlock(&dev->mutex);
> -#else
>        up(&dev->sem);
> -#endif
>  }
>
>  #if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
>
