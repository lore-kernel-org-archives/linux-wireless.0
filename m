Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173009pub.verizon.net ([206.46.173.9]:27985 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2HLRUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 13:20:03 -0400
Message-id: <5027D79E.9050607@verizon.net> (sfid-20120812_192009_539490_FFA9A7C3)
Date: Sun, 12 Aug 2012 12:19:42 -0400
From: "C. McPherson" <ccmcphe@verizon.net>
MIME-version: 1.0
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: mcgrof@kernel.org, lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] compat: fix system crash on 2.6.35 when flushing work
References: <1342168714-3361-1-git-send-email-zefir.kurtisi@neratec.com>
In-reply-to: <1342168714-3361-1-git-send-email-zefir.kurtisi@neratec.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir:
Thanks a lot for this reference. All my systems are running Ubuntu 
10.04/10.10. I was updating our compat-wireless with the stable 
compat-wireless 3.5
and came across this crash in our testing lab. I added your patch and 
the stable compat-wireless 3.5 is now working with our Ubuntu.

-Tex


On 07/13/2012 04:38 AM, Zefir Kurtisi wrote:
> Ubuntu 10.10 stock kernel (2.6.35-22-generic) crashes in
> compat_flush_scheduled_work(), that is called e.g. when
> mac80211 module is unloaded.
>
> The problem was introduced with 80bf8a83
> compat: backport system work queues system_wq and system_long_wq
>
> The crash happens in compat_flush_scheduled_work() where both
> flush_workqueue() and flush_scheduled_work() are called successively.
> Removing one of them resolves the issue.
>
> All compat-wireless tarballs after 2012-03-18 are affected.
>
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> ---
>   compat/compat-2.6.36.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
> index 9190ecd..8f25be0 100644
> --- a/compat/compat-2.6.36.c
> +++ b/compat/compat-2.6.36.c
> @@ -140,7 +140,6 @@ void compat_flush_scheduled_work(void)
>   	 * go with the old kernel's one first for now (keventd_wq) and
>   	 * if think its reasonable later we can flip this around.
>   	 */
> -	flush_workqueue(system_wq);
>   	flush_scheduled_work();
>   }
>   EXPORT_SYMBOL_GPL(compat_flush_scheduled_work);

