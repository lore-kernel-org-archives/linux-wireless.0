Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53800 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207Ab3IPVgN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 17:36:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 16 Sep 2013 14:17:54 -0700
Subject: RE: [PATCH v4] Bluetooth: btmrvl: add calibration data download
 support
Message-ID: <477F20668A386D41ADCC57781B1F70430F44C584A1@SC-VEXCH1.marvell.com> (sfid-20130916_233618_276598_E31A5892)
References: <1379115162-10194-1-git-send-email-bzhao@marvell.com>
 <525C3DAD-2AD3-468F-8309-630EEE54A3CE@holtmann.org>
In-Reply-To: <525C3DAD-2AD3-468F-8309-630EEE54A3CE@holtmann.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

Thanks for your comment.

> > +	bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
> > +	skb_put(skb, sizeof(*cmd));
> > +	skb->dev = (void *)priv->btmrvl_dev.hcidev;
> > +	skb_queue_head(&priv->adapter->tx_queue, skb);
> > +	priv->btmrvl_dev.sendcmdflag = true;
> > +	priv->adapter->cmd_complete = false;
> 
> since the Bluetooth HCI core got ->setup() support with proper synchronous HCI request handling
> available for every single driver (see the Intel support in btusb.c), why not start using that with
> this driver as well.

We will convert btmrvl driver to use ->setup() callback.

Thanks,
Bing

