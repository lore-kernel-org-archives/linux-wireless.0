Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFA8C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D57E206B7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfBKJvV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:51:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34852 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKJvV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 04:51:21 -0500
Received: by mail-wm1-f67.google.com with SMTP id t200so15994403wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 01:51:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rx3uBnWs7cmb8EKMMjZmjU3scKwIz+JHpJzz3ExMeus=;
        b=ogh4OLnxC8UIDf9zBPIHr9GMrJScckHbJb105YuPhwCH2f5hnbRy3REWrU3UUHaUmq
         OqUdepQy+SNn86Au7O6I72XGgixAQR5SA775/vaNUF1NzPLxWh2KmyLiAiQLS96bq/Gx
         j5QTw4USpf3wDACswKmBzfL/XJ8lP+0X2KFG+CfkVbiCOoUVK0dLYir8KBuJPe38aaZJ
         85FhjazsiIcxsKu7Ny8vqJ0gJRjGkKOdC/NthcLZ0BtyCh5bm+Kgm2b1oj9iribRnWkj
         MC/epI3YrRiEv9674yFhayUEwyrJahShcPszjhMBvmTtvxK7tbOspbSt5yvQ/k6Ocf6X
         LT7g==
X-Gm-Message-State: AHQUAuat0JA6b7CC34aQEBMWxbr/XqeEs8dkITevA/b4Bvew6eO210aU
        L19Ldj9PUDvh8ggBfzSRrjCNrg==
X-Google-Smtp-Source: AHgI3IahOFGFk/cj61hylvbot7hOd89BQy/mhs2ErXPqbeiEHy7hJEtLtD7nJkRA3eBPa9ZD9bVvnQ==
X-Received: by 2002:a1c:e10a:: with SMTP id y10mr8474627wmg.73.1549878678279;
        Mon, 11 Feb 2019 01:51:18 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v1sm20678965wrw.90.2019.02.11.01.51.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Feb 2019 01:51:17 -0800 (PST)
Date:   Mon, 11 Feb 2019 10:51:15 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x02u: use usb_bulk_msg to upload firmware
Message-ID: <20190211095114.GB3467@localhost.localdomain>
References: <1549872974-7268-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549872974-7268-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> We don't need to send firmware data asynchronously, much simpler is just
> use synchronous usb_bulk_msg().
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Tested-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h     | 13 +++++
>  .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  | 52 ++++++-------------
>  drivers/net/wireless/mediatek/mt76/usb.c      |  1 -
>  3 files changed, 29 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> index 2e5bcb3fdff7..94e0f1379e68 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -664,6 +664,19 @@ static inline bool mt76u_check_sg(struct mt76_dev *dev)
>  		 udev->speed == USB_SPEED_WIRELESS));
>  }
>  
> +static inline int
> +mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int timeout)
> +{
> +	struct usb_interface *intf = to_usb_interface(dev->dev);
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	struct mt76_usb *usb = &dev->usb;
> +	unsigned int pipe;
> +	int sent;
> +
> +	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
> +	return usb_bulk_msg(udev, pipe, data, len, &sent, timeout);
> +}
> +
>  int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
>  			 u8 req_type, u16 val, u16 offset,
>  			 void *buf, size_t len);
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> index da299b8a1334..642df4287082 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> @@ -121,11 +121,8 @@ static int
>  __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
>  			int cmd, bool wait_resp)
>  {
> -	struct usb_interface *intf = to_usb_interface(dev->dev);
> -	struct usb_device *udev = interface_to_usbdev(intf);
>  	struct mt76_usb *usb = &dev->usb;
> -	unsigned int pipe;
> -	int ret, sent;
> +	int ret;
>  	u8 seq = 0;
>  	u32 info;
>  
> @@ -135,7 +132,6 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
>  	if (test_bit(MT76_REMOVED, &dev->state))
>  		return 0;
>  
> -	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
>  	if (wait_resp) {
>  		seq = ++usb->mcu.msg_seq & 0xf;
>  		if (!seq)
> @@ -149,7 +145,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
>  	if (ret)
>  		return ret;
>  
> -	ret = usb_bulk_msg(udev, pipe, skb->data, skb->len, &sent, 500);
> +	ret = mt76u_bulk_msg(dev, skb->data, skb->len, 500);
>  	if (ret)
>  		return ret;
>  
> @@ -263,14 +259,12 @@ void mt76x02u_mcu_fw_reset(struct mt76x02_dev *dev)
>  EXPORT_SYMBOL_GPL(mt76x02u_mcu_fw_reset);
>  
>  static int
> -__mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
> +__mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, u8 *data,
>  			    const void *fw_data, int len, u32 dst_addr)
>  {
> -	u8 *data = sg_virt(&buf->urb->sg[0]);
> -	DECLARE_COMPLETION_ONSTACK(cmpl);
>  	__le32 info;
>  	u32 val;
> -	int err;
> +	int err, data_len;
>  
>  	info = cpu_to_le32(FIELD_PREP(MT_MCU_MSG_PORT, CPU_TX_PORT) |
>  			   FIELD_PREP(MT_MCU_MSG_LEN, len) |
> @@ -286,25 +280,12 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
>  	mt76u_single_wr(&dev->mt76, MT_VEND_WRITE_FCE,
>  			MT_FCE_DMA_LEN, len << 16);
>  
> -	buf->len = MT_CMD_HDR_LEN + len + sizeof(info);
> -	err = mt76u_submit_buf(&dev->mt76, USB_DIR_OUT,
> -			       MT_EP_OUT_INBAND_CMD,
> -			       buf, GFP_KERNEL,
> -			       mt76u_mcu_complete_urb, &cmpl);
> -	if (err < 0)
> -		return err;
> -
> -	if (!wait_for_completion_timeout(&cmpl,
> -					 msecs_to_jiffies(1000))) {
> -		dev_err(dev->mt76.dev, "firmware upload timed out\n");
> -		usb_kill_urb(buf->urb);
> -		return -ETIMEDOUT;
> -	}
> +	data_len = MT_CMD_HDR_LEN + len + sizeof(info);
>  
> -	if (mt76u_urb_error(buf->urb)) {
> -		dev_err(dev->mt76.dev, "firmware upload failed: %d\n",
> -			buf->urb->status);
> -		return buf->urb->status;
> +	err = mt76u_bulk_msg(&dev->mt76, data, data_len, 1000);
> +	if (err) {
> +		dev_err(dev->mt76.dev, "firmware upload failed: %d\n", err);
> +		return err;
>  	}
>  
>  	val = mt76_rr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX);
> @@ -317,17 +298,16 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
>  int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
>  			      int data_len, u32 max_payload, u32 offset)
>  {
> -	int err, len, pos = 0, max_len = max_payload - 8;
> -	struct mt76u_buf buf;
> +	int len, err = 0, pos = 0, max_len = max_payload - 8;
> +	u8 *buf;
>  
> -	err = mt76u_buf_alloc(&dev->mt76, &buf, 1, max_payload, max_payload,
> -			      GFP_KERNEL);
> -	if (err < 0)
> -		return err;
> +	buf = kmalloc(max_payload, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
>  
>  	while (data_len > 0) {
>  		len = min_t(int, data_len, max_len);
> -		err = __mt76x02u_mcu_fw_send_data(dev, &buf, data + pos,
> +		err = __mt76x02u_mcu_fw_send_data(dev, buf, data + pos,
>  						  len, offset + pos);
>  		if (err < 0)
>  			break;
> @@ -336,7 +316,7 @@ int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
>  		pos += len;
>  		usleep_range(5000, 10000);
>  	}
> -	mt76u_buf_free(&buf);
> +	kfree(buf);
>  
>  	return err;
>  }
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> index 5f0faf07c346..358a95a2bbcb 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -328,7 +328,6 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
>  
>  	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
>  }
> -EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
>  
>  void mt76u_buf_free(struct mt76u_buf *buf)
>  {
> -- 
> 2.19.2
> 
