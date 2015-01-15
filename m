Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53908 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbAOMen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 07:34:43 -0500
MIME-Version: 1.0
In-Reply-To: <20150115114340.GC17976@mwanda>
References: <20150115114340.GC17976@mwanda>
Date: Thu, 15 Jan 2015 14:34:42 +0200
Message-ID: <CAB3XZEdbiOqO-th_1kY8j_95dJKvVKuFAe3XZPj_iJDE8KrPog@mail.gmail.com> (sfid-20150115_133447_651679_E6B253C3)
Subject: Re: [patch] wlcore: unlock on error in wl1271_op_suspend()
From: Eliad Peller <eliad@wizery.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, Ram Amrani <ramrani@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>,
	David Spinadel <david.spinadel@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 15, 2015 at 1:43 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We recently introduced a new error path which needs an unlock.
>
> Fixes: 6d5a748d4836 ('wlcore: add ability to reduce FW interrupts during suspend')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker fix.  It's possible that wl1271_ps_elp_wakeup() unlocks
> on error but I didn't see it, and that would be an ugly API.
>
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index e90fb78..02f0e86 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -1785,8 +1785,10 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
>         mutex_lock(&wl->mutex);
>
>         ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       if (ret < 0) {
> +               mutex_unlock(&wl->mutex);
>                 return ret;
> +       }
>
The patch is correct, thanks.
If you'll take a look at other functions in the file, you'll usually
see "goto out_unlock" (or something similar) in this case.

Eliad.
