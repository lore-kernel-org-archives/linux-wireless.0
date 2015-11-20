Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34094 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688AbbKTKho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 05:37:44 -0500
MIME-Version: 1.0
In-Reply-To: <1447413499-25747-1-git-send-email-saurabh.truth@gmail.com>
References: <1447413499-25747-1-git-send-email-saurabh.truth@gmail.com>
Date: Fri, 20 Nov 2015 16:07:43 +0530
Message-ID: <CAA8avJ9m4t3DPFeSr4QetD+TtyfxBCMcRk4Pmf=WwNG+QRVj5g@mail.gmail.com> (sfid-20151120_113845_427537_549C99A6)
Subject: Re: [PATCH] NFC: added the sysfs entry for nfcsim workqueue delay
From: Saurabh Sengar <saurabh.truth@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have also tested this module its successfully creating the tx_delay
entry in nfc

root@saurabh:/home/saurabh# ls /sys/class/nfc/nfc0/tx_delay
/sys/class/nfc/nfc0/tx_delay

its default value is set to 5
root@saurabh:/home/saurabh# cat /sys/class/nfc/nfc0/tx_delay
5

its changing the value correctly
root@saurabh:/home/saurabh# echo 15 > /sys/class/nfc/nfc0/tx_delay
root@saurabh:/home/saurabh# cat /sys/class/nfc/nfc0/tx_delay
15

and on removing the module its cleaning up without any oops

Tested-by: Saurabh Sengar <saurabh.truth@gmail.com>

On 13 November 2015 at 16:48, Saurabh Sengar <saurabh.truth@gmail.com> wrote:
> added the sysfs entry for nfcsim workqueue delay, as tx_delay
>
> Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>
> ---
> implementing the TODO task
>
>  drivers/nfc/nfcsim.c | 38 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
> index 26ac9e5..e77be35 100644
> --- a/drivers/nfc/nfcsim.c
> +++ b/drivers/nfc/nfcsim.c
> @@ -32,6 +32,8 @@
>  #define NFCSIM_POLL_TARGET     2
>  #define NFCSIM_POLL_DUAL       (NFCSIM_POLL_INITIATOR | NFCSIM_POLL_TARGET)
>
> +#define TX_DEFAULT_DELAY       5
> +
>  struct nfcsim {
>         struct nfc_dev *nfc_dev;
>
> @@ -62,12 +64,41 @@ static struct nfcsim *dev1;
>
>  static struct workqueue_struct *wq;
>
> +
> +static int tx_delay = TX_DEFAULT_DELAY;
> +
> +static ssize_t show_tx_delay(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       char *buf)
> +{
> +       int n;
> +
> +       n = scnprintf(buf, PAGE_SIZE, "%d\n", tx_delay);
> +       return n;
> +}
> +
> +static ssize_t store_tx_delay(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       const char *buf, size_t count)
> +{
> +       if (kstrtouint(buf, 0, &tx_delay) < 0)
> +               return -EINVAL;
> +
> +       if (tx_delay < 0)
> +               return -EINVAL;
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(tx_delay, 0644, show_tx_delay, store_tx_delay);
> +
>  static void nfcsim_cleanup_dev(struct nfcsim *dev, u8 shutdown)
>  {
>         DEV_DBG(dev, "shutdown=%d\n", shutdown);
>
>         mutex_lock(&dev->lock);
>
> +       device_remove_file(&dev->nfc_dev->dev, &dev_attr_tx_delay);
>         dev->polling_mode = NFCSIM_POLL_NONE;
>         dev->shutting_down = shutdown;
>         dev->cb = NULL;
> @@ -320,10 +351,8 @@ static int nfcsim_tx(struct nfc_dev *nfc_dev, struct nfc_target *target,
>          * If packet transmission occurs immediately between them, we have a
>          * non-stop flow of several tens of thousands SYMM packets per second
>          * and a burning cpu.
> -        *
> -        * TODO: Add support for a sysfs entry to control this delay.
>          */
> -       queue_delayed_work(wq, &peer->recv_work, msecs_to_jiffies(5));
> +       queue_delayed_work(wq, &peer->recv_work, msecs_to_jiffies(tx_delay));
>
>         mutex_unlock(&peer->lock);
>
> @@ -461,6 +490,9 @@ static struct nfcsim *nfcsim_init_dev(void)
>         if (rc)
>                 goto free_nfc_dev;
>
> +       rc = device_create_file(&dev->nfc_dev->dev, &dev_attr_tx_delay);
> +       if (rc)
> +               pr_err("error creating sysfs entry\n");
>         return dev;
>
>  free_nfc_dev:
> --
> 1.9.1
