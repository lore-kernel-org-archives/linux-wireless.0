Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38804 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaJBMhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 08:37:14 -0400
Received: by mail-wg0-f47.google.com with SMTP id x13so2999596wgg.6
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2014 05:37:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412251934-7011-2-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412251934-7011-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1412251934-7011-2-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 2 Oct 2014 14:37:13 +0200
Message-ID: <CA+BoTQ=QEnDhW_Kb-dCO--67LAFNL37g4JSDuET84FFPLHpz8w@mail.gmail.com> (sfid-20141002_143720_688783_AA4B7862)
Subject: Re: [PATCH 1/4] ath10k: Add support to configure pktlog filter
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 October 2014 14:12, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> Add support to configure packet log filters (tx, rx, rate control)
> via debugfs. To disable htt pktlog events set the filters to 0.
[...]
> +static ssize_t ath10k_write_pktlog_filter(struct file *file,
> +                                         const char __user *ubuf,
> +                                         size_t count, loff_t *ppos)
> +{
> +       struct ath10k *ar = file->private_data;
> +       u32 filter;
> +       int ret;
> +
> +       if (kstrtouint_from_user(ubuf, count, 0, &filter))
> +               return -EINVAL;
> +
> +       mutex_lock(&ar->conf_mutex);
> +       if (filter && (filter != ar->debug.pktlog_filter))
> +               ret = ath10k_wmi_pdev_pktlog_enable(ar, filter);
> +       else
> +               ret = ath10k_wmi_pdev_pktlog_disable(ar);

You're not checking if ar->state is ON.

Even if I assume the above doesn't crash the driver/system this has
strange semantics. On one hand the driver has to be after drv_start
(e.g. at least one interface must be up) before it's possible to set
it but on the other hand pktlog_filter is retained across
drv_stop/start. I'd expect it to be possible to set the pktlog_filter
regardless of driver state but maybe that's just me.


Michał
