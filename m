Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58373 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab0JXTTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Oct 2010 15:19:52 -0400
Received: by eye27 with SMTP id 27so3498057eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Oct 2010 12:19:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287857641-7882-1-git-send-email-hauke@hauke-m.de>
References: <1287857641-7882-1-git-send-email-hauke@hauke-m.de>
Date: Sun, 24 Oct 2010 12:19:51 -0700
Message-ID: <AANLkTimv9dohuKynRW3GaMUDAOtMKhf0xwr76+wc2vCW@mail.gmail.com>
Subject: Re: [PATCH 1/3] compat: fix device_lock functions on non rt kernel
From: Blaise Gassend <blaise@willowgarage.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I agree that CONFIG_NONE should have been CONFIG_PREEMPT_NONE. On the
other hand, I disagree that CONFIG_PREEMPT_NONE and
CONFIG_PREEMPT_VOLUNTARY should be removed. They might not be in the
latest RT patch, but they are in older patches (2.6.29 in particular).
 Leaving them in will not hinder kernels that no longer have
CONFIG_PREEMPT_NONE and CONFIG_PREEMPT_VOLUNTARY. Removing them will
cause the build to fail for some configurations of 2.6.29-rt, and
probably others.

On Sat, Oct 23, 2010 at 11:13 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> CONFIG_NONE and CONFIG_PREEMPT_VOLUNTARY are not added by the last RT
> patch. I have not found any references to CONFIG_NONE, probably
> CONFIG_PREEMPT_NONE was meant, but that is also wrong like
> CONFIG_PREEMPT_VOLUNTARY. These two options are also in the normal kernel
> config system without the rt patch.
>
> This patch only checks for KConfig options added by the rt patch, but a
> rt-patch user could also select PREEMPT_NONE or PREEMPT_VOLUNTARY, and
> compat-wireless will not build. I do not think this will hapen often, so leave
> it like this.
>
> This patch fixes build with all non rt-kernels.
>
> CC: Blaise Gassend <blaise@willowgarage.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/compat-2.6.34.h |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
> index 1cfd6e5..f710d08 100644
> --- a/include/linux/compat-2.6.34.h
> +++ b/include/linux/compat-2.6.34.h
> @@ -142,8 +142,7 @@ do {                                                                \
>
>  static inline void device_lock(struct device *dev)
>  {
> -#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
> -    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
> +#if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
>         mutex_lock(&dev->parent->mutex);
>  #else
>        down(&dev->sem);
> @@ -152,8 +151,7 @@ static inline void device_lock(struct device *dev)
>
>  static inline int device_trylock(struct device *dev)
>  {
> -#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
> -    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
> +#if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
>        return mutex_trylock(&dev->mutex);
>  #else
>        return down_trylock(&dev->sem);
> @@ -162,8 +160,7 @@ static inline int device_trylock(struct device *dev)
>
>  static inline void device_unlock(struct device *dev)
>  {
> -#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
> -    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
> +#if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
>         mutex_unlock(&dev->mutex);
>  #else
>        up(&dev->sem);
> --
> 1.7.0.4
>
>
