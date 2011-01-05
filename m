Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:46735 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab1AEBSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 20:18:45 -0500
Message-ID: <4D23C6C6.2010205@redfish-solutions.com>
Date: Tue, 04 Jan 2011 17:17:59 -0800
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH 2/3] compat: backport alloc_workqueue
References: <1293891815-22087-1-git-send-email-hauke@hauke-m.de> <1293891815-22087-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1293891815-22087-2-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just patched this against 2.6.27.49 and it builds.  I'll try to fire up an image later, though I'm using Ath9k cards...


On 1/1/11 6:23 AM, Hauke Mehrtens wrote:
> This is needed by rtlwifi.
>
> The function signature of __create_workqueue changed in kernel 2.6.28,
> so two different defines are needed.
>
> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> ---
>   include/linux/compat-2.6.28.h |    2 ++
>   include/linux/compat-2.6.36.h |    4 ++++
>   2 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
> index b9024d6..fdb8fb2 100644
> --- a/include/linux/compat-2.6.28.h
> +++ b/include/linux/compat-2.6.28.h
> @@ -236,6 +236,8 @@ extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
>
>   int pci_wake_from_d3(struct pci_dev *dev, bool enable);
>
> +#define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active)
> +
>   #endif /* (LINUX_VERSION_CODE<  KERNEL_VERSION(2,6,28)) */
>
>   #endif /* LINUX_26_28_COMPAT_H */
> diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
> index 1f2f507..74d2309 100644
> --- a/include/linux/compat-2.6.36.h
> +++ b/include/linux/compat-2.6.36.h
> @@ -97,6 +97,10 @@ struct pm_qos_request_list {
>   static inline __attribute__ ((format (printf, 1, 2)))
>   int no_printk(const char *s, ...) { return 0; }
>
> +#ifndef alloc_workqueue
> +#define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active, 0)
> +#endif
> +
>   #endif /* (LINUX_VERSION_CODE<  KERNEL_VERSION(2,6,36)) */
>
>   #endif /* LINUX_26_36_COMPAT_H */

