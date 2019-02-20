Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDE0C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D548320700
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfBTKiQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:38:16 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38341 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbfBTKiQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 05:38:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id v13so25355796wrw.5
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 02:38:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tC88A7HMqJC9eCCd/9WUuyY43c1DfchQ0dFZKj0JBQY=;
        b=e2SUYqu9pPUoRoP5EKaIgyd/qRZXVitPvtQv6Mia7lQNAH7cSkhBd88OgzaUmr/K6y
         BDiZZXVj/KgINf9ymtNIeM992QPXbxAKBVuFLzt8BaQaDTyYkNn99H+3O4Rfde1uFT1Q
         p0Oc4F/U1IVYgC6u4qOET3WiFHoCUuGSQBaNsyH2mx1wt+WFJQ00Gx6P/zJ9qO/y0ijw
         ABhUfYnNGS+jAppORxmlBkbl7h9uToJC6kbiPNACoAbaOhzQJJYcAY4ImLc9dP04bGKb
         72OpIlRS5Xuhpx0OjMy6m4pxkENKYQznK75v3xIEiVqgocLBTQVoP32iaC4rh8QppiR8
         O8ww==
X-Gm-Message-State: AHQUAuZXQjKoKJCt4ieCDH5IP+69Ec0cR83JV4/dizV8c0c3I1WILSwP
        Ju9SkM3sU23f1HxNoWOCDow7uh45QhY=
X-Google-Smtp-Source: AHgI3IYg7tiLmsUpsh/TEx6k83LTldmy5XQpLY+JIN59INjn+uWVpcGbYruCP3kAe4degEtuVc/Tow==
X-Received: by 2002:adf:f688:: with SMTP id v8mr23084697wrp.159.1550659094058;
        Wed, 20 Feb 2019 02:38:14 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v6sm33164399wrd.88.2019.02.20.02.38.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 02:38:13 -0800 (PST)
Date:   Wed, 20 Feb 2019 11:38:11 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] mt76usb: use synchronous msg for mcu command
 responses
Message-ID: <20190220103810.GC2626@localhost.localdomain>
References: <1550657565-7263-1-git-send-email-sgruszka@redhat.com>
 <1550657565-7263-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550657565-7263-2-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Use usb_bulk_msg for reading MCU command responses. This simplify code
> a lot.
> 
> Together with 97a3005759c ("mt76usb: allow mt76u_bulk_msg be used
> for reads") it also fix possible problems with rx data buffers
> not being aligned and contained within single page. After doing
> page_frag_alloc(1024) consecutive page_frag_alloc(PAGE_SIZE) will
> alloc PAGE_SIZE buffer at PAGE_SIZE - 1024 offset.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Hi Stanislaw,

very nice simplification. I need to post a series and this patch will help
me a lot, thx :)
Just few comments inline

Regards,
Lorenzo

> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h          |  3 +-
>  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 11 --------
>  .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   | 32 +++++++---------------
>  drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    | 11 --------
>  drivers/net/wireless/mediatek/mt76/usb.c           |  1 -
>  drivers/net/wireless/mediatek/mt76/usb_mcu.c       | 31 +++------------------
>  6 files changed, 15 insertions(+), 74 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> index 45e44bcaa523..ce53069461ec 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -384,8 +384,7 @@ struct mt76_usb {
>  
>  	struct mt76u_mcu {
>  		struct mutex mutex;
> -		struct completion cmpl;
> -		struct mt76u_buf res;
> +		u8 *data;
>  		u32 msg_seq;
>  
>  		/* multiple reads */
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> index da9d05f6074d..f0c33890f1a5 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> @@ -311,13 +311,11 @@ static int __maybe_unused mt76x0_suspend(struct usb_interface *usb_intf,
>  					 pm_message_t state)
>  {
>  	struct mt76x02_dev *dev = usb_get_intfdata(usb_intf);
> -	struct mt76_usb *usb = &dev->mt76.usb;
>  
>  	mt76u_stop_queues(&dev->mt76);
>  	mt76x0u_mac_stop(dev);
>  	clear_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
>  	mt76x0_chip_onoff(dev, false, false);
> -	usb_kill_urb(usb->mcu.res.urb);
>  
>  	return 0;
>  }
> @@ -328,15 +326,6 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
>  	struct mt76_usb *usb = &dev->mt76.usb;
>  	int ret;
>  
> -	reinit_completion(&usb->mcu.cmpl);
> -	ret = mt76u_submit_buf(&dev->mt76, USB_DIR_IN,
> -			       MT_EP_IN_CMD_RESP,
> -			       &usb->mcu.res, GFP_KERNEL,
> -			       mt76u_mcu_complete_urb,
> -			       &usb->mcu.cmpl);
> -	if (ret < 0)
> -		goto err;
> -
>  	ret = mt76u_submit_rx_buffers(&dev->mt76);
>  	if (ret < 0)
>  		goto err;
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> index f497c8e4332a..0cb8751321a1 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> @@ -61,33 +61,21 @@ mt76x02u_multiple_mcu_reads(struct mt76_dev *dev, u8 *data, int len)
>  static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
>  {
>  	struct mt76_usb *usb = &dev->usb;
> -	struct mt76u_buf *buf = &usb->mcu.res;
> -	struct urb *urb = buf->urb;
> -	u8 *data = buf->buf;
> -	int i, ret;
> +	u8 *data = usb->mcu.data;
> +	int i, len, ret;
>  	u32 rxfce;
>  
>  	for (i = 0; i < 5; i++) {
> -		if (!wait_for_completion_timeout(&usb->mcu.cmpl,
> -						 msecs_to_jiffies(300)))
> +		ret = mt76u_bulk_msg(dev, data, MCU_RESP_URB_SIZE, &len, 300);
> +		if (ret == -ETIMEDOUT)
>  			continue;
> -
> -		if (urb->status)
> -			return -EIO;
> +		if (ret)
> +			goto out;
>  
>  		if (usb->mcu.rp)
> -			mt76x02u_multiple_mcu_reads(dev, data + 4,
> -						    urb->actual_length - 8);
> +			mt76x02u_multiple_mcu_reads(dev, data + 4, len - 8);
>  
>  		rxfce = get_unaligned_le32(data);
> -		ret = mt76u_submit_buf(dev, USB_DIR_IN,
> -				       MT_EP_IN_CMD_RESP,
> -				       buf, GFP_KERNEL,
> -				       mt76u_mcu_complete_urb,
> -				       &usb->mcu.cmpl);
> -		if (ret)
> -			return ret;
> -
>  		if (seq == FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce) &&
>  		    FIELD_GET(MT_RX_FCE_INFO_EVT_TYPE, rxfce) == EVT_CMD_DONE)
>  			return 0;
> @@ -96,9 +84,9 @@ static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
>  			FIELD_GET(MT_RX_FCE_INFO_EVT_TYPE, rxfce),
>  			seq, FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce));
>  	}
> -
> -	dev_err(dev->dev, "error: %s timed out\n", __func__);
> -	return -ETIMEDOUT;
> +out:
> +	dev_err(dev->dev, "error: %s failed with %d\n", __func__, ret);
> +	return ret;
>  }
>  
>  static int
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
> index f81a85e96922..ddb6b2c48e01 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
> @@ -100,11 +100,9 @@ static int __maybe_unused mt76x2u_suspend(struct usb_interface *intf,
>  					  pm_message_t state)
>  {
>  	struct mt76x02_dev *dev = usb_get_intfdata(intf);
> -	struct mt76_usb *usb = &dev->mt76.usb;
>  
>  	mt76u_stop_queues(&dev->mt76);
>  	mt76x2u_stop_hw(dev);
> -	usb_kill_urb(usb->mcu.res.urb);
>  
>  	return 0;
>  }
> @@ -115,15 +113,6 @@ static int __maybe_unused mt76x2u_resume(struct usb_interface *intf)
>  	struct mt76_usb *usb = &dev->mt76.usb;
>  	int err;
>  
> -	reinit_completion(&usb->mcu.cmpl);
> -	err = mt76u_submit_buf(&dev->mt76, USB_DIR_IN,
> -			       MT_EP_IN_CMD_RESP,
> -			       &usb->mcu.res, GFP_KERNEL,
> -			       mt76u_mcu_complete_urb,
> -			       &usb->mcu.cmpl);
> -	if (err < 0)
> -		goto err;
> -
>  	err = mt76u_submit_rx_buffers(&dev->mt76);
>  	if (err < 0)
>  		goto err;
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> index 78191968b4fa..5c3b7f735aae 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -933,7 +933,6 @@ int mt76u_init(struct mt76_dev *dev,
>  	INIT_DELAYED_WORK(&usb->stat_work, mt76u_tx_status_data);
>  	skb_queue_head_init(&dev->rx_skb[MT_RXQ_MAIN]);
>  
> -	init_completion(&usb->mcu.cmpl);
>  	mutex_init(&usb->mcu.mutex);
>  
>  	mutex_init(&usb->usb_ctrl_mtx);
> diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
> index 72c8607da4b4..747231edc57d 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
> @@ -16,42 +16,19 @@
>  
>  #include "mt76.h"
>  
> -void mt76u_mcu_complete_urb(struct urb *urb)
> -{
> -	struct completion *cmpl = urb->context;
> -
> -	complete(cmpl);
> -}
> -EXPORT_SYMBOL_GPL(mt76u_mcu_complete_urb);
> -
>  int mt76u_mcu_init_rx(struct mt76_dev *dev)
>  {
>  	struct mt76_usb *usb = &dev->usb;
> -	int err;
>  
> -	err = mt76u_buf_alloc(dev, &usb->mcu.res, MCU_RESP_URB_SIZE,
> -			      MCU_RESP_URB_SIZE, GFP_KERNEL);
> -	if (err < 0)
> -		return err;
> -
> -	err = mt76u_submit_buf(dev, USB_DIR_IN, MT_EP_IN_CMD_RESP,
> -			       &usb->mcu.res, GFP_KERNEL,
> -			       mt76u_mcu_complete_urb,
> -			       &usb->mcu.cmpl);
> -	if (err < 0)
> -		mt76u_buf_free(&usb->mcu.res);
> -
> -	return err;
> +	usb->mcu.data = kmalloc(MCU_RESP_URB_SIZE, GFP_KERNEL);

if you use devm_kmalloc() you can drop mt76u_mcu_deinit

Regards,
Lorenzo

> +	return usb->mcu.data ? 0 : -ENOMEM;
>  }
>  EXPORT_SYMBOL_GPL(mt76u_mcu_init_rx);
>  
>  void mt76u_mcu_deinit(struct mt76_dev *dev)
>  {
> -	struct mt76u_buf *buf = &dev->usb.mcu.res;
> +	struct mt76_usb *usb = &dev->usb;
>  
> -	if (buf->urb) {
> -		usb_kill_urb(buf->urb);
> -		mt76u_buf_free(buf);
> -	}
> +	kfree(usb->mcu.data);
>  }
>  EXPORT_SYMBOL_GPL(mt76u_mcu_deinit);
> -- 
> 2.7.5
> 
