Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34220 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbdGGScZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 14:32:25 -0400
Received: by mail-lf0-f54.google.com with SMTP id t72so30049644lff.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jul 2017 11:32:24 -0700 (PDT)
Date: Fri, 7 Jul 2017 20:32:22 +0200
From: Johan Hovold <johan@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: johan@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [bug report] NFC: fix broken device allocation
Message-ID: <20170707183222.GF29638@localhost> (sfid-20170707_203229_124841_990E7E66)
References: <20170707093334.zhnn3jrtqosbqdib@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170707093334.zhnn3jrtqosbqdib@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 07, 2017 at 12:33:34PM +0300, Dan Carpenter wrote:
> Hello Johan Hovold,
> 
> The patch 20777bc57c34: "NFC: fix broken device allocation" from Mar
> 30, 2017, leads to the following static checker warning:
> 
> 	drivers/nfc/pn533/pn533.c:2653 pn533_register_device()
> 	error: 'priv->nfc_dev' dereferencing possible ERR_PTR()

> drivers/nfc/pn533/pn533.c
>   2639          skb_queue_head_init(&priv->resp_q);
>   2640          skb_queue_head_init(&priv->fragment_skb);
>   2641  
>   2642          INIT_LIST_HEAD(&priv->cmd_queue);
>   2643  
>   2644          priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
>   2645                                             priv->ops->tx_header_len +
>   2646                                             PN533_CMD_DATAEXCH_HEAD_LEN,
>   2647                                             priv->ops->tx_tail_len);
> 
> We changed this to return error pointers as well as NULL.  When
> functions return a NULL as well as error pointers, then NULL is supposed
> to be a special case of success but here it's just a failure.  That's
> messy and bug prone.

Thanks for reporting this, Dan.

I'll take a closer look at this tomorrow, but I guess we could just
continue using NULL for all errors for now.

Thanks,
Johan
