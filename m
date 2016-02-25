Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33980 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbcBYBOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 20:14:21 -0500
Received: by mail-ig0-f172.google.com with SMTP id g6so3779338igt.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 17:14:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456358932-23114-7-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com> <1456358932-23114-7-git-send-email-afenkart@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 25 Feb 2016 12:14:00 +1100
Message-ID: <CAGRGNgW7S8xru6KVBdQMLN3+=N-uzMf18rwfDWW6uNzCv7eaWg@mail.gmail.com> (sfid-20160225_021425_381473_6642CB43)
Subject: Re: [PATCH 6/7] mwifiex: factor out mwifiex_cancel_pending_scan_cmd
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
> releasing the scan_pending lock in mwifiex_check_next_scan_command
> is valid, since the lock is taken again, and all nodes removed
> from the scan_pending queue.
>
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c      | 43 ++++++++++------------
>  drivers/net/wireless/marvell/mwifiex/main.h        |  1 +
>  drivers/net/wireless/marvell/mwifiex/scan.c        | 23 +++---------
>  drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 13 +------
>  4 files changed, 27 insertions(+), 53 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index 6ddc98b..490d0d1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -1920,13 +1910,10 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
>                 }
>         } else if ((priv->scan_aborting && !priv->scan_request) ||
>                    priv->scan_block) {
> -               list_for_each_entry_safe(cmd_node, tmp_node,
> -                                        &adapter->scan_pending_q, list) {
> -                       list_del(&cmd_node->list);
> -                       mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
> -               }
>                 spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
>
> +               mwifiex_cancel_pending_scan_cmd(adapter);
> +

This is creating a "short" window where &adapter->scan_pending_q_lock
is unlocked here. Is that safe?

You might want to write mwifiex_cancel_pending_scan_cmd() as two
functions, one which takes the spinlock and calls the other and one
which does all the work so you can call the latter here without that
window where ..._q_lock is unlocked.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
