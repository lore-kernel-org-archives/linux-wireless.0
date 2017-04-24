Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35586 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165794AbdDXG4X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 02:56:23 -0400
Received: by mail-yw0-f193.google.com with SMTP id k11so5080947ywb.2
        for <linux-wireless@vger.kernel.org>; Sun, 23 Apr 2017 23:56:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170424053902.1644-1-dev@michaelmera.com>
References: <20170424053902.1644-1-dev@michaelmera.com>
From: Marcin Rokicki <marcin.rokicki@gmail.com>
Date: Mon, 24 Apr 2017 08:56:21 +0200
Message-ID: <CAN6Sofawy9BmFaVgNw=gt=9VwLqNFdCQ2fa3DApvJTVCJpjoqg@mail.gmail.com> (sfid-20170424_085626_513641_34C01819)
Subject: Re: [PATCH] ath10k: fix out of bounds access to local buffer
To: Michael Mera <dev@michaelmera.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Please send again to ath10k@lists.infradead.org with cc
linux-wireless@vger.kernel.org

Thanks.

2017-04-24 7:39 GMT+02:00 Michael Mera <dev@michaelmera.com>:
> During write to debugfs file simulate_fw_crash, fixed-size local buffer
> 'buf' is accessed and modified at index 'count-1', where 'count' is the
> size of the write (so potentially out of bounds).
> This patch fixes this problem.
>
> Signed-off-by: Michael Mera <dev@michaelmera.com>
> ---
>  drivers/net/wireless/ath/ath10k/debug.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index fb0ade3adb07..7f3c17e55693 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -628,17 +628,21 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
>                                               size_t count, loff_t *ppos)
>  {
>         struct ath10k *ar = file->private_data;
> -       char buf[32];
> +       char buf[32] = {0};
> +       ssize_t rc;
>         int ret;
>
> -       simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
> +       /* filter partial writes and invalid commands */
> +       if (*ppos != 0 || count >= sizeof(buf) || count == 0)
> +               return -EINVAL;
>
> -       /* make sure that buf is null terminated */
> -       buf[sizeof(buf) - 1] = 0;
> +       rc = simple_write_to_buffer(buf, sizeof(buf)-1, ppos, user_buf, count);
> +       if (rc < 0)
> +               return rc;
>
>         /* drop the possible '\n' from the end */
> -       if (buf[count - 1] == '\n')
> -               buf[count - 1] = 0;
> +       if (buf[*ppos - 1] == '\n')
> +               buf[*ppos - 1] = '\0';
>
>         mutex_lock(&ar->conf_mutex);
>
> --
> 2.9.3
>
