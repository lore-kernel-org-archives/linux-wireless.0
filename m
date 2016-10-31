Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36360 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S948002AbcJaX5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 19:57:16 -0400
Received: by mail-pf0-f175.google.com with SMTP id 189so31071777pfz.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2016 16:57:16 -0700 (PDT)
Date: Mon, 31 Oct 2016 16:57:12 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>
Subject: Re: [PATCH 01/12] mwifiex: fix power save issue when suspend
Message-ID: <20161031235712.GA101079@google.com> (sfid-20161101_005720_477205_9E7CF9B5)
References: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Oct 31, 2016 at 04:02:09PM +0800, Xinming Hu wrote:
> From: Shengzhen Li <szli@marvell.com>
> 
> This patch fixes a corner case for "FROMLIST: mwifiex: fix corner case

Upstream patches don't normally get a 'FROMLIST' tag while you're
sending them to the mailing list :) That designation is used for Chrome
OS trees, so we know where to find the patch source. But the upstream
mailing list *is* the source.

> power save issue", main process will check the power save condition in
> PS_PRE_SLEEP status so the sleep handshake could continue.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> BUG=chrome-os-partner:58164
> TEST=stress Wifi w/ power_save enabled
> 
> Change-Id: I5a36d9eaeb7fe5faaccc533e0d1ba1f3253666dc

In the same vein: while I'm happy to have the BUG=, TEST=, and Gerrit
Change-ID for our Chrome OS tree, I don't think upstream reviewers
typically care about those. Please remove those from upstream
submissions like this.

(Same applies to the rest of this series. Also, consider running
scripts/checkpatch.pl. It will at least remind you about removing the
Gerrit Change-ID.)

> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 3 ++-
>  drivers/net/wireless/marvell/mwifiex/main.c   | 5 +++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> index 5347728..9075be5 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -1123,8 +1123,9 @@ mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
>  		mwifiex_dnld_sleep_confirm_cmd(adapter);
>  	else
>  		mwifiex_dbg(adapter, CMD,
> -			    "cmd: Delay Sleep Confirm (%s%s%s)\n",
> +			    "cmd: Delay Sleep Confirm (%s%s%s%s)\n",
>  			    (adapter->cmd_sent) ? "D" : "",
> +			    (adapter->data_sent) ? "T" : "",
>  			    (adapter->curr_cmd) ? "C" : "",
>  			    (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
>  }
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 2478ccd..f559ead 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -308,6 +308,11 @@ process_start:
>  			/* We have tried to wakeup the card already */
>  			if (adapter->pm_wakeup_fw_try)
>  				break;
> +			if (adapter->ps_state == PS_STATE_PRE_SLEEP) {
> +				if (!adapter->cmd_sent && !adapter->curr_cmd)

The entire 'if' condition is unnecessary. That's all checked already
within mwifiex_check_ps_cond().

Brian

> +					mwifiex_check_ps_cond(adapter);
> +			}
> +
>  			if (adapter->ps_state != PS_STATE_AWAKE)
>  				break;
>  			if (adapter->tx_lock_flag) {
> -- 
> 1.8.1.4
> 
