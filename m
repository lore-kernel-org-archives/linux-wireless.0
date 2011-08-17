Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:49160 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1HQWmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 18:42:12 -0400
Received: by iye16 with SMTP id 16so2726654iye.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 15:42:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE6600131E1C339@dnce02.ent.ti.com>
References: <AC090B9732AB2B4DB7FF476E907FE6600131E1C339@dnce02.ent.ti.com>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Wed, 17 Aug 2011 19:41:52 -0300
Message-ID: <CAEsZsEjRwJs-YTfWgunzPmh56t4KaQ2sPG_n0W5KitfWL-AcKQ@mail.gmail.com> (sfid-20110818_004217_828962_F8DB6419)
Subject: Re: [PATCH 1/4] NFC: Add NFC dev_up and dev_down control operations
To: "Elias, Ilan" <ilane@ti.com>
Cc: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Tue, Aug 16, 2011 at 2:35 PM, Elias, Ilan <ilane@ti.com> wrote:
> +/**
> + * nfc_dev_down - turn off the NFC device
> + *
> + * @dev: The nfc device to be turned off
> + */
> +int nfc_dev_down(struct nfc_dev *dev)
> +{
> +       int rc = 0;
> +
> +       nfc_dbg("dev_name=%s", dev_name(&dev->dev));
> +
> +       device_lock(&dev->dev);
> +
> +       if (!device_is_registered(&dev->dev)) {
> +               rc = -ENODEV;
> +               goto error;
> +       }
> +
> +       if (!dev->dev_up) {
> +               rc = -EINVAL;
> +               goto error;
> +       }

I think -EALREADY would fit better.

> +
> +       if (dev->ops->dev_down)
> +               dev->ops->dev_down(dev);
> +
> +       dev->dev_up = false;

What happens if the driver is polling for targets or even with a
remote target activated? The nfc_dev structure has some control to
track the driver state (e.g. dev->polling) that must have their values
updated. Otherwise, the next start_poll() call would fail with EBUSY.

> +static int nfc_genl_dev_up(struct sk_buff *skb, struct genl_info *info)
> +{
> +       struct nfc_dev *dev;
> +       int rc;
> +       u32 idx;
> +
> +       nfc_dbg("entry");
> +
> +       if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
> +               return -EINVAL;
> +
> +       idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
> +
> +       dev = nfc_get_device(idx);
> +       if (!dev)
> +               return -ENODEV;
> +
> +       mutex_lock(&dev->genl_data.genl_data_mutex);
> +
> +       rc = nfc_dev_up(dev);
> +
> +       mutex_unlock(&dev->genl_data.genl_data_mutex);

This mutex is used to protect the variable dev->genl_data.poll_req_pid
in cases when the netlink socket is closed in parallel with start_poll
or stop_poll calls. As you are not accessing poll_req_pid, you don't
need to care about this mutex.

> +static int nfc_genl_dev_down(struct sk_buff *skb, struct genl_info *info)
> +{
> +       struct nfc_dev *dev;
> +       int rc;
> +       u32 idx;
> +
> +       nfc_dbg("entry");
> +
> +       if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
> +               return -EINVAL;
> +
> +       idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
> +
> +       dev = nfc_get_device(idx);
> +       if (!dev)
> +               return -ENODEV;
> +
> +       mutex_lock(&dev->genl_data.genl_data_mutex);
> +
> +       rc = nfc_dev_down(dev);
> +
> +       mutex_unlock(&dev->genl_data.genl_data_mutex);

The same as above.



Regards,
Aloisio
