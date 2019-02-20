Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C22C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 11:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF447206B7
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 11:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfBTL2n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:28:43 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41777 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfBTL2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 06:28:43 -0500
Received: by mail-wr1-f66.google.com with SMTP id n2so13380179wrw.8
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 03:28:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mv1/kqJbkK+InRSFNSHGisobeSmhPuJdF0H8L6nyuns=;
        b=IUd/x4jQ7cFTblMgc6JRg5mPOXn3gAPQyC4KlCS0FcCLd7ntQgFx7wvjRl8N6MPWrS
         BxRi9ypqf3c62jAr59clmPh5ylzEoWWpWRD2ViSrW8YCbDJTCiQ0bl+sXoLb1kTnM42B
         SnZGsWS07F6vV/6ulymx5azlAvxcZROpOfI1c9cEvvRKigUGVcg86iqklCkOtE+CEkQP
         oYI/e5LFIZQUXozuozEolTsBnsqWYZ5CL8yCnuLzSGOizrbFN4hpkbsfo3crG8xuk4Xv
         c4/i+WA/+dvUVa125uI1ngUQ1YsT2G+uQOYw5CpqQMYQumAL3FDi63Wj06hvkqKdsmL8
         +rVQ==
X-Gm-Message-State: AHQUAuZJUSdaOC34BaEZTvMMskrVx0Z5QbQ+7PC6c0HP7hCu7LcTKbsD
        iD+TPfjldKzWYrAA9XLtWocRC8OXM6I=
X-Google-Smtp-Source: AHgI3IY5XB3WnAG+A1zKXtkoDxAA64/9+D4UZAdmTz7aZxCmil+MMLY36vrnycOOoswkk6YobyFSdQ==
X-Received: by 2002:adf:f7c9:: with SMTP id a9mr25703948wrq.39.1550662121067;
        Wed, 20 Feb 2019 03:28:41 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s3sm4003452wmj.23.2019.02.20.03.28.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 03:28:40 -0800 (PST)
Date:   Wed, 20 Feb 2019 12:28:38 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] mt76usb: allow mt76u_bulk_msg be used for reads
Message-ID: <20190220112837.GE2626@localhost.localdomain>
References: <1550657565-7263-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550657565-7263-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Extend mt76u_bulk_msg() such it can be used for synchronous bulk reads.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---

Hi Stanislaw,

testing this series I got the following error:

[    3.448267] mt76x0u 1-1:1.0: ASIC revision: 76100002 MAC revision: 76502000
[    3.451220] INFO: trying to register non-static key.
[    3.452055] the code is fine but needs lockdep annotation.
[    3.452945] turning off the locking correctness validator.
[    3.453590] CPU: 0 PID: 18 Comm: kworker/0:1 Not tainted 5.0.0-rc4+ #2963
[    3.454390] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
?-20180724_192412-buildhw-07.phx2.fedoraproject.org-1.fc29 04/01/2014
[    3.455973] Workqueue: usb_hub_wq hub_event
[    3.456642] Call Trace:
[    3.456989]  register_lock_class+0x4fd/0x510
[    3.457619]  ? mark_held_locks+0x4f/0x80
[    3.458172]  __lock_acquire+0x6c/0x1580
[    3.458675]  ? __mt76u_vendor_request+0xc0/0x110
[    3.459302]  ? find_held_lock+0x2d/0x90
[    3.459802]  lock_acquire+0x88/0x120
[    3.460283]  ? mt76u_queues_deinit+0x4e/0x120
[    3.460875]  _raw_spin_lock_bh+0x38/0x80
[    3.461412]  ? mt76u_queues_deinit+0x4e/0x120
[    3.461999]  mt76u_queues_deinit+0x4e/0x120
[    3.462565]  mt76x0u_probe+0x1e6/0x220
[    3.463070]  usb_probe_interface+0xa7/0x1d0
[    3.463639]  ? __driver_attach+0xd0/0xd0
[    3.464167]  really_probe+0xda/0x250
[    3.464754]  ? __driver_attach+0xd0/0xd0
[    3.465285]  bus_for_each_drv+0x66/0x90
[    3.465801]  __device_attach+0xa8/0xe0
[    3.466309]  bus_probe_device+0x9f/0xb0
[    3.466880]  device_add+0x3a2/0x5f0
[    3.467338]  usb_set_configuration+0x471/0x7d0
[    3.467942]  ? __driver_attach+0xd0/0xd0
[    3.468454]  generic_probe+0x48/0x70
[    3.468929]  really_probe+0xda/0x250
[    3.469411]  ? __driver_attach+0xd0/0xd0
[    3.469931]  bus_for_each_drv+0x66/0x90
[    3.470433]  __device_attach+0xa8/0xe0
[    3.470920]  bus_probe_device+0x9f/0xb0
[    3.471420]  device_add+0x3a2/0x5f0
[    3.471875]  usb_new_device+0x193/0x320
[    3.472382]  hub_event+0xbf7/0x1160
[    3.472840]  process_one_work+0x2a4/0x580
[    3.473367]  ? process_one_work+0x580/0x580
[    3.473912]  worker_thread+0x2d/0x3d0
[    3.474390]  ? process_one_work+0x580/0x580
[    3.474940]  kthread+0x115/0x130
[    3.475392]  ? kthread_create_on_node+0x40/0x40
[    3.475968]  ret_from_fork+0x3a/0x50
[    3.476492] mt76x0u: probe of 1-1:1.0 failed with error -12

Regards,
Lorenzo

>  drivers/net/wireless/mediatek/mt76/mt76.h            | 13 ++++++++++---
>  drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c |  4 ++--
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> index f55dc621e060..45e44bcaa523 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -729,7 +729,8 @@ static inline u8 q2ep(u8 qid)
>  }
>  
>  static inline int
> -mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int timeout)
> +mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int *actual_len,
> +	       int timeout)
>  {
>  	struct usb_interface *intf = to_usb_interface(dev->dev);
>  	struct usb_device *udev = interface_to_usbdev(intf);
> @@ -737,8 +738,14 @@ mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int timeout)
>  	unsigned int pipe;
>  	int sent;
>  
> -	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
> -	return usb_bulk_msg(udev, pipe, data, len, &sent, timeout);
> +	if (actual_len) {
> +		pipe = usb_rcvbulkpipe(udev, usb->in_ep[MT_EP_IN_CMD_RESP]);
> +	} else {
> +		actual_len = &sent;
> +		pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
> +	}
> +
> +	return usb_bulk_msg(udev, pipe, data, len, actual_len, timeout);
>  }
>  
>  int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> index e469e383cb88..f497c8e4332a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> @@ -126,7 +126,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
>  	if (ret)
>  		return ret;
>  
> -	ret = mt76u_bulk_msg(dev, skb->data, skb->len, 500);
> +	ret = mt76u_bulk_msg(dev, skb->data, skb->len, NULL, 500);
>  	if (ret)
>  		return ret;
>  
> @@ -271,7 +271,7 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, u8 *data,
>  
>  	data_len = MT_CMD_HDR_LEN + len + sizeof(info);
>  
> -	err = mt76u_bulk_msg(&dev->mt76, data, data_len, 1000);
> +	err = mt76u_bulk_msg(&dev->mt76, data, data_len, NULL, 1000);
>  	if (err) {
>  		dev_err(dev->mt76.dev, "firmware upload failed: %d\n", err);
>  		return err;
> -- 
> 2.7.5
> 
