Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37847 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbcBYBPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 20:15:23 -0500
Received: by mail-ig0-f173.google.com with SMTP id z8so3542777ige.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 17:15:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456358932-23114-8-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com> <1456358932-23114-8-git-send-email-afenkart@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 25 Feb 2016 12:15:02 +1100
Message-ID: <CAGRGNgXcpo+g_WFeJpk-e4ig+6DQm9Mf4ma5WqVaA3bajyugGg@mail.gmail.com> (sfid-20160225_021525_672597_95E5FD3A)
Subject: Re: [PATCH 7/7] mwifiex: make mwifiex_insert_cmd_to_free_q local static
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

On Thu, Feb 25, 2016 at 11:08 AM, Andreas Fenkart <afenkart@gmail.com> wrote:
> after factoring out mwifiex_cancel_pending_scan_cmd
> the function is noc called outside of cmdevt file
>
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 6 +++++-
>  drivers/net/wireless/marvell/mwifiex/main.h   | 2 --
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> index 61426b3..4b0f44d 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -26,6 +26,10 @@
>  #include "11n.h"
>  #include "11ac.h"
>
> +static void
> +mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
> +                            struct cmd_ctrl_node *cmd_node);
> +

Why not just move the function definition above where it's needed?

>  /*
>   * This function initializes a command node.
>   *
> @@ -619,7 +623,7 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
>   * The function also calls the completion callback if required, before
>   * cleaning the command node and re-inserting it into the free queue.
>   */
> -void
> +static void
>  mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
>                              struct cmd_ctrl_node *cmd_node)
>  {
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index f71f894..840e5d4 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -1045,8 +1045,6 @@ void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
>  void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
>  void mwifiex_cancel_pending_scan_cmd(struct mwifiex_adapter *adapter);
>
> -void mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
> -                                 struct cmd_ctrl_node *cmd_node);
>  void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
>                               struct cmd_ctrl_node *cmd_node);
>
> --
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
