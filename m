Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34257 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934283Ab3CHP3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 10:29:20 -0500
Received: by mail-oa0-f51.google.com with SMTP id h2so2076969oag.38
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 07:29:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361544646-9059-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1361544646-9059-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Fri, 8 Mar 2013 20:59:20 +0530
Message-ID: <CAD2nsn2sQhF2B-gAWpVoG7U4ijyS3TO=buhe0yiJk12T3g-kMA@mail.gmail.com> (sfid-20130308_162926_992175_56D69BB9)
Subject: Re: [PATCH v2 5/5] ath6kl: Fix a debugfs crash for USB devices
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Ryan Hsu <ryanhsu@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 22, 2013 at 8:20 PM, Mohammed Shafi Shajakhan
<mohammed@qca.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> Credit distribution stats is currently implemented
> only for SDIO. This fixes a crash in debugfs for
> USB interface.
>
> BUG: unable to handle kernel NULL pointer dereference at   (null)
> IP: [<f91c2048>] read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
> *pde = b62bd067
> Oops: 0000 [#1] SMP
>
> EIP: 0060:[<f91c2048>] EFLAGS: 00210246 CPU: 0
> EIP is at read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
> EAX: 00000000 EBX: e6f7a9c0 ECX: e7b148b8 EDX: 00000000
> ESI: 000000c8 EDI: e7b14000 EBP: e6e09f64 ESP: e6e09f30
> DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process cat (pid: 4058, ti=e6e08000 task=e50cf230 task.ti=e6e08000)
> Stack:
> 00008000 00000000 e6e09f64 c1132d3c 00004e71 e50cf230 00008000 089e4000
> e7b148b8 00000000 e6f7a9c0 00008000 089e4000 e6e09f8c c11331fc e6e09f98
> 00000001 e6e09f7c f91c2010 e6e09fac e6f7a9c0 089e4877 089e4000 e6e09fac
>
>         Call Trace:
>         [<c1132d3c>] ? rw_verify_area+0x6c/0x120
>         [<c11331fc>] vfs_read+0x8c/0x160
>         [<f91c2010>] ? read_file_war_stats+0x130/0x130 [ath6kl_core]
>         [<c113330d>] sys_read+0x3d/0x70
>         [<c15755b4>] syscall_call+0x7/0xb
>         [<c1570000>] ? fill_powernow_table_pstate+0x127/0x127
>
> Cc: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/debug.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> index 15cfe30..c557367 100644
> --- a/drivers/net/wireless/ath/ath6kl/debug.c
> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> @@ -1752,8 +1752,10 @@ int ath6kl_debug_init_fs(struct ath6kl *ar)
>         debugfs_create_file("tgt_stats", S_IRUSR, ar->debugfs_phy, ar,
>                             &fops_tgt_stats);
>
> -       debugfs_create_file("credit_dist_stats", S_IRUSR, ar->debugfs_phy, ar,
> -                           &fops_credit_dist_stats);
> +       if (ar->hif_type != ATH6KL_HIF_TYPE_SDIO)

made a mistake,
should be > +       if (ar->hif_type == ATH6KL_HIF_TYPE_SDIO)
will send another patch
> +               debugfs_create_file("credit_dist_stats", S_IRUSR,
> +                                   ar->debugfs_phy, ar,
> +                                   &fops_credit_dist_stats);
>
>         debugfs_create_file("endpoint_stats", S_IRUSR | S_IWUSR,
>                             ar->debugfs_phy, ar, &fops_endpoint_stats);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
