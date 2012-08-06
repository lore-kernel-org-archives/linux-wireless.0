Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59547 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab2HFSwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 14:52:38 -0400
Received: by obbuo13 with SMTP id uo13so6265647obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 11:52:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343924881-31418-2-git-send-email-hauke@hauke-m.de>
References: <1343924881-31418-1-git-send-email-hauke@hauke-m.de> <1343924881-31418-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Aug 2012 11:52:18 -0700
Message-ID: <CAB=NE6UTm9WyHZX-Ve5TZcKVfWf52caGhBWY_3q9RQuD8KcnZQ@mail.gmail.com> (sfid-20120806_205241_289705_75773812)
Subject: Re: [PATCH 2/2] compat: fix endless recursion in flush_scheduled_work
To: Hauke Mehrtens <hauke@hauke-m.de>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 2, 2012 at 9:28 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The hader file defines flush_scheduled_work(a)
> compat_flush_scheduled_work(a), which causes flush_scheduled_work() and
> compat_flush_scheduled_work() to be the same function.
>
> With this patch it calls the actual function in the kernel.
>
> This fixes problems when unloading mac80211 from compat-wireless.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  compat/compat-2.6.36.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
> index 8f25be0..05b41c2 100644
> --- a/compat/compat-2.6.36.c
> +++ b/compat/compat-2.6.36.c
> @@ -133,6 +133,7 @@ int compat_schedule_delayed_work_on(int cpu,
>  }
>  EXPORT_SYMBOL_GPL(compat_schedule_delayed_work_on);
>
> +#undef flush_scheduled_work(a)
>  void compat_flush_scheduled_work(void)

Hah! Nice. I'll add this and push... Zefir can you see if after
getting today's compat.git and then by reverting your patch
3da0495cf863288b on compat.git if the unloading issues still happens.
Likely this was the *real* cause, although it is odd to me you ended
up removing the flush_workqueue() and not the flush_scheduled_work().

  Luis
