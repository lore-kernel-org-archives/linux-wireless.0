Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44996 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736Ab3DQHK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 03:10:56 -0400
Received: by mail-wi0-f176.google.com with SMTP id hm14so3369951wib.15
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 00:10:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130417062350.GC1597@redhat.com>
References: <20130416133828.GA20024@redhat.com> <20130416134053.GB20024@redhat.com>
 <20130417062350.GC1597@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 17 Apr 2013 17:10:35 +1000
Message-ID: <CAGRGNgXuqkUmcOTfEKqrDDUxu8741QE-dWrb-tdvV9d28X+GzQ@mail.gmail.com> (sfid-20130417_091100_300450_555FC8AB)
Subject: Re: [PATCH 3/2] iwlwifi: remove unneeded goto from iwl_dbgfs_log_event_read
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jonas Gorski <jogo@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, Apr 17, 2013 at 4:23 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Make code simpler a bit.
>
> Reported-by: Jonas Gorski <jogo@openwrt.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/dvm/debugfs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
> index 17f04de..d532948 100644
> --- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
> @@ -2241,10 +2241,8 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
>         ssize_t ret;
>
>         ret = iwl_dump_nic_event_log(priv, true, &buf);
> -       if (ret < 0)
> -               goto err;
> -       ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> -err:
> +       if (ret > 0)
> +               ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);

That's not the same, what happens if ret == 0?

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
