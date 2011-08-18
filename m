Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39407 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab1HRGnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 02:43:32 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Aloisio Almeida <aloisio.almeida@openbossa.org>
CC: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 18 Aug 2011 08:43:21 +0200
Subject: RE: [PATCH 1/4] NFC: Add NFC dev_up and dev_down control operations
Message-ID: <AC090B9732AB2B4DB7FF476E907FE6600131E1CA9A@dnce02.ent.ti.com> (sfid-20110818_084335_721300_4F291AFA)
References: <AC090B9732AB2B4DB7FF476E907FE6600131E1C339@dnce02.ent.ti.com>
 <CAEsZsEjRwJs-YTfWgunzPmh56t4KaQ2sPG_n0W5KitfWL-AcKQ@mail.gmail.com>
In-Reply-To: <CAEsZsEjRwJs-YTfWgunzPmh56t4KaQ2sPG_n0W5KitfWL-AcKQ@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Aloisio,

Thanks for your comments.

> > +int nfc_dev_down(struct nfc_dev *dev)
> > +{
> > +       int rc = 0;
> > +
> > +       nfc_dbg("dev_name=%s", dev_name(&dev->dev));
> > +
> > +       device_lock(&dev->dev);
> > +
> > +       if (!device_is_registered(&dev->dev)) {
> > +               rc = -ENODEV;
> > +               goto error;
> > +       }
> > +
> > +       if (!dev->dev_up) {
> > +               rc = -EINVAL;
> > +               goto error;
> > +       }
> 
> I think -EALREADY would fit better.
Agreed.

> > +
> > +       if (dev->ops->dev_down)
> > +               dev->ops->dev_down(dev);
> > +
> > +       dev->dev_up = false;
> 
> What happens if the driver is polling for targets or even with a
> remote target activated? The nfc_dev structure has some control to
> track the driver state (e.g. dev->polling) that must have their values
> updated. Otherwise, the next start_poll() call would fail with EBUSY.
You're correct, of course.
When dev_down is called and we have some active operation (e.g. polling, 
active target), there are 2 approaches:
1) stop internally any active operations and update internal states 
(e.g. dev->polling). Please note that if we have an active data exchange, 
the callback might not be called at all.
2) simply return EBUSY and let the upper layers handle it.

With both approaches, we'll have to keep track of active target state 
(in addition to dev->polling). Which option do you prefer?

> > +static int nfc_genl_dev_up(struct sk_buff *skb, struct 
> genl_info *info)
> > +{
> > +       struct nfc_dev *dev;
> > +       int rc;
> > +       u32 idx;
> > +
> > +       nfc_dbg("entry");
> > +
> > +       if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
> > +               return -EINVAL;
> > +
> > +       idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
> > +
> > +       dev = nfc_get_device(idx);
> > +       if (!dev)
> > +               return -ENODEV;
> > +
> > +       mutex_lock(&dev->genl_data.genl_data_mutex);
> > +
> > +       rc = nfc_dev_up(dev);
> > +
> > +       mutex_unlock(&dev->genl_data.genl_data_mutex);
> 
> This mutex is used to protect the variable dev->genl_data.poll_req_pid
> in cases when the netlink socket is closed in parallel with start_poll
> or stop_poll calls. As you are not accessing poll_req_pid, you don't
> need to care about this mutex.
Agreed.

> 
> > +static int nfc_genl_dev_down(struct sk_buff *skb, struct 
> genl_info *info)
> > +{
> > +       struct nfc_dev *dev;
> > +       int rc;
> > +       u32 idx;
> > +
> > +       nfc_dbg("entry");
> > +
> > +       if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
> > +               return -EINVAL;
> > +
> > +       idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
> > +
> > +       dev = nfc_get_device(idx);
> > +       if (!dev)
> > +               return -ENODEV;
> > +
> > +       mutex_lock(&dev->genl_data.genl_data_mutex);
> > +
> > +       rc = nfc_dev_down(dev);
> > +
> > +       mutex_unlock(&dev->genl_data.genl_data_mutex);
> 
> The same as above.
Agreed.

Thanks & BR,
Ilan