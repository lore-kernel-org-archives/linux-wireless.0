Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:39800 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab3DPSk4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 14:40:56 -0400
Received: from mail-vc0-f176.google.com (mail-vc0-f176.google.com [209.85.220.176])
	by mail.nanl.de (Postfix) with ESMTPSA id 54A8F45EF5
	for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 18:40:53 +0000 (UTC)
Received: by mail-vc0-f176.google.com with SMTP id hf12so662323vcb.21
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 11:40:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130416133828.GA20024@redhat.com>
References: <20130416133828.GA20024@redhat.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Tue, 16 Apr 2013 20:40:30 +0200
Message-ID: <CAOiHx=nY148aJoVON6TK4eygbFn4Moh9JVGZGbNaQsRR=TSo9A@mail.gmail.com> (sfid-20130416_204100_539194_C41BB5DE)
Subject: Re: [PATCH 1/2] iwlwifi: fix freeing uninitialized pointer
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes.berg@intel.com>, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 April 2013 15:38, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> If on iwl_dump_nic_event_log() error occurs before that function
> initialize buf, we process uninitiated pointer in
> iwl_dbgfs_log_event_read() and can hit "BUG at mm/slub.c:3409"
>
> Resolves:
> https://bugzilla.redhat.com/show_bug.cgi?id=951241
>
> Reported-by: ian.odette@eprize.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> Patch is only compile tested, but I'm sure it fixes the problem.
>
>  drivers/net/wireless/iwlwifi/dvm/debugfs.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
> index 7b8178b..cb6dd58 100644
> --- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
> @@ -2237,15 +2237,15 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
>                                          size_t count, loff_t *ppos)
>  {
>         struct iwl_priv *priv = file->private_data;
> -       char *buf;
> -       int pos = 0;
> -       ssize_t ret = -ENOMEM;
> +       char *buf = NULL;
> +       ssize_t ret;
>
> -       ret = pos = iwl_dump_nic_event_log(priv, true, &buf, true);
> -       if (buf) {
> -               ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
> -               kfree(buf);
> -       }
> +       ret = iwl_dump_nic_event_log(priv, true, &buf, true);
> +       if (ret < 0)
> +               goto err;
> +       ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +err:

Not every error check needs a goto, you can avoid it by inverting the
condition: ;-)

	ret = iwl_dump_nic_event_log(priv, true, &buf, true);
	if (ret >= 0) /* or maybe even > 0, because AFAICT 0 => nothing to read */
		ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
	kfree(buf);


Jonas
