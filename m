Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13C3C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 14:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89243206E0
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 14:58:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U8yEfKdg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n3IaYc3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfDZO6K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 10:58:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33022 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfDZO6K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 10:58:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E20C66049C; Fri, 26 Apr 2019 14:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556290688;
        bh=0HF5Xu0rP0uQqxcUNFB+re/trfaXq/Jiyt1IEulVvwQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=U8yEfKdg79ito9YhOv1/S42WTxUiOH45LHbbPyFHi+zP6EcRxSgIogx1TXG/7VwSX
         h1UeWTKn/Krifv5lQMqH5qp4UL15pIpWBF7bQZve3NtPE4imrp2qHJuMPeAIEdpQyI
         ULCbHr4B55X2vHSbZeTA4fHrymaskK6MjfPjWpC4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3473C6022B;
        Fri, 26 Apr 2019 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556290687;
        bh=0HF5Xu0rP0uQqxcUNFB+re/trfaXq/Jiyt1IEulVvwQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=n3IaYc3bga9zQsFApaAL9f5WDzcahp/9ex4A8fY93BMJPcq/5BYu7iCPWmZ83i94l
         DicxvOwmHGHcRqlM8IrdvODtSW0zbhaAdjMrivsd/mjVQ3Z0YBkg6fvxWsDiS4TRDI
         QSbWYI2s2yC5pXk5v9ilomdq5UK5GoJOyyL6nLOQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3473C6022B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Julia Lawall <julia.lawall@lip6.fr>
Cc:     Siva Rebbagondla <siva8118@gmail.com>, kbuild-all@01.org,
        linux-wireless@vger.kernel.org
Subject: Re: [wireless-drivers-next:master 21/45] drivers/net/wireless/rsi/rsi_91x_usb.c:774:17-26: ERROR: id is NULL but dereferenced. (fwd)
References: <alpine.DEB.2.20.1904261625060.21912@hadrien>
Date:   Fri, 26 Apr 2019 17:58:03 +0300
In-Reply-To: <alpine.DEB.2.20.1904261625060.21912@hadrien> (Julia Lawall's
        message of "Fri, 26 Apr 2019 16:26:01 +0200 (CEST)")
Message-ID: <871s1ovmo4.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless

Julia Lawall <julia.lawall@lip6.fr> writes:

> The ifs starting on line 766 can fail because id is NULL.
>
> julia
>
> ---------- Forwarded message ----------
> Date: Fri, 26 Apr 2019 06:39:46 +0800
> From: kbuild test robot <lkp@intel.com>
> To: kbuild@01.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Subject: [wireless-drivers-next:master 21/45]
>     drivers/net/wireless/rsi/rsi_91x_usb.c:774:17-26: ERROR: id is NULL but
>     dereferenced.
>
> CC: kbuild-all@01.org
> TO: Siva Rebbagondla <siva8118@gmail.com>
> CC: Kalle Valo <kvalo@codeaurora.org>
>
> tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
> master
> head:   147b502bda338f4f2dff19faaa5829b691305ea5
> commit: 54fdb318c1116814711fad4bd166e6c85a477ef0 [21/45] rsi: add new
> device model for 9116
> :::::: branch date: 5 hours ago
> :::::: commit date: 6 hours ago
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
>
>>> drivers/net/wireless/rsi/rsi_91x_usb.c:774:17-26: ERROR: id is NULL
> but dereferenced.
>
> #
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=54fdb318c1116814711fad4bd166e6c85a477ef0
> git remote add wireless-drivers-next
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
> git remote update wireless-drivers-next
> git checkout 54fdb318c1116814711fad4bd166e6c85a477ef0
> vim +774 drivers/net/wireless/rsi/rsi_91x_usb.c
>
> ea0676c47 Karun Eagalapati        2017-07-06  729
> dad0d04fa Fariya Fatima           2014-03-16  730  /**
> dad0d04fa Fariya Fatima 2014-03-16 731 * rsi_probe() - This function
> is called by kernel when the driver provided
> dad0d04fa Fariya Fatima 2014-03-16 732 * Vendor and device IDs are
> matched. All the initialization
> dad0d04fa Fariya Fatima           2014-03-16  733   *		 work is done here.
> dad0d04fa Fariya Fatima 2014-03-16 734 * @pfunction: Pointer to the
> USB interface structure.
> dad0d04fa Fariya Fatima 2014-03-16 735 * @id: Pointer to the
> usb_device_id structure.
> dad0d04fa Fariya Fatima           2014-03-16  736   *
> 50591c60a Alexey Khoroshilov 2014-06-27 737 * Return: 0 on success, a
> negative error code on failure.
> dad0d04fa Fariya Fatima           2014-03-16  738   */
> dad0d04fa Fariya Fatima 2014-03-16 739 static int rsi_probe(struct
> usb_interface *pfunction,
> dad0d04fa Fariya Fatima 2014-03-16 740 const struct usb_device_id *id)
> dad0d04fa Fariya Fatima           2014-03-16  741  {
> dad0d04fa Fariya Fatima           2014-03-16  742  	struct rsi_hw *adapter;
> dad0d04fa Fariya Fatima           2014-03-16  743  	struct rsi_91x_usbdev *dev;
> dad0d04fa Fariya Fatima           2014-03-16  744  	u16 fw_status;
> 50591c60a Alexey Khoroshilov      2014-06-27  745  	int status;
> dad0d04fa Fariya Fatima           2014-03-16  746
> dad0d04fa Fariya Fatima 2014-03-16 747 rsi_dbg(INIT_ZONE, "%s: Init
> function called\n", __func__);
> dad0d04fa Fariya Fatima           2014-03-16  748
> 898b25533 Prameela Rani Garnepudi 2018-02-27 749 adapter =
> rsi_91x_init(dev_oper_mode);
> dad0d04fa Fariya Fatima           2014-03-16  750  	if (!adapter) {
> dad0d04fa Fariya Fatima 2014-03-16 751 rsi_dbg(ERR_ZONE, "%s: Failed
> to init os intf ops\n",
> dad0d04fa Fariya Fatima           2014-03-16  752  			__func__);
> 50591c60a Alexey Khoroshilov      2014-06-27  753  		return -ENOMEM;
> dad0d04fa Fariya Fatima           2014-03-16  754  	}
> b78e91bcf Prameela Rani Garnepudi 2017-05-16 755
> adapter->rsi_host_intf = RSI_HOST_INTF_USB;
> dad0d04fa Fariya Fatima           2014-03-16  756
> 50591c60a Alexey Khoroshilov 2014-06-27 757 status =
> rsi_init_usb_interface(adapter, pfunction);
> 50591c60a Alexey Khoroshilov      2014-06-27  758  	if (status) {
> dad0d04fa Fariya Fatima 2014-03-16 759 rsi_dbg(ERR_ZONE, "%s: Failed
> to init usb interface\n",
> dad0d04fa Fariya Fatima           2014-03-16  760  			__func__);
> dad0d04fa Fariya Fatima           2014-03-16  761  		goto err;
> dad0d04fa Fariya Fatima           2014-03-16  762  	}
> dad0d04fa Fariya Fatima           2014-03-16  763
> dad0d04fa Fariya Fatima 2014-03-16 764 rsi_dbg(ERR_ZONE, "%s:
> Initialized os intf ops\n", __func__);
> dad0d04fa Fariya Fatima           2014-03-16  765
> 54fdb318c Siva Rebbagondla 2019-04-03 766 if (id && id->idProduct ==
> RSI_USB_PID_9113) {
> 54fdb318c Siva Rebbagondla 2019-04-03 767 rsi_dbg(INIT_ZONE, "%s: 9113
> module detected\n", __func__);
> 54fdb318c Siva Rebbagondla 2019-04-03 768 adapter->device_model =
> RSI_DEV_9113;
> 54fdb318c Siva Rebbagondla 2019-04-03 769 } else if (id &&
> id->idProduct == RSI_USB_PID_9116) {
> 54fdb318c Siva Rebbagondla 2019-04-03 770 rsi_dbg(INIT_ZONE, "%s: 9116
> module detected\n", __func__);
> 54fdb318c Siva Rebbagondla 2019-04-03 771 adapter->device_model =
> RSI_DEV_9116;
> 54fdb318c Siva Rebbagondla        2019-04-03  772  	} else {
> 54fdb318c Siva Rebbagondla 2019-04-03 773 rsi_dbg(ERR_ZONE, "%s:
> Unsupported RSI device id 0x%x\n",
> 54fdb318c Siva Rebbagondla 2019-04-03 @774 __func__, id->idProduct);
> 54fdb318c Siva Rebbagondla        2019-04-03  775  		goto err1;
> 54fdb318c Siva Rebbagondla        2019-04-03  776  	}
> 54fdb318c Siva Rebbagondla        2019-04-03  777
> dad0d04fa Fariya Fatima 2014-03-16 778 dev = (struct rsi_91x_usbdev
> *)adapter->rsi_dev;
> dad0d04fa Fariya Fatima           2014-03-16  779
> 50591c60a Alexey Khoroshilov 2014-06-27 780 status =
> rsi_usb_reg_read(dev->usbdev, FW_STATUS_REG, &fw_status, 2);
> b78e91bcf Prameela Rani Garnepudi 2017-05-16  781  	if (status < 0)
> dad0d04fa Fariya Fatima           2014-03-16  782  		goto err1;
> dad0d04fa Fariya Fatima           2014-03-16  783  	else
> dad0d04fa Fariya Fatima           2014-03-16  784  		fw_status &= 1;
> dad0d04fa Fariya Fatima           2014-03-16  785
> dad0d04fa Fariya Fatima           2014-03-16  786  	if (!fw_status) {
> b78e91bcf Prameela Rani Garnepudi 2017-05-16 787 rsi_dbg(INIT_ZONE,
> "Loading firmware...\n");
> b78e91bcf Prameela Rani Garnepudi 2017-05-16 788 status =
> rsi_hal_device_init(adapter);
> 50591c60a Alexey Khoroshilov      2014-06-27  789  		if (status) {
> dad0d04fa Fariya Fatima 2014-03-16 790 rsi_dbg(ERR_ZONE, "%s: Failed
> in device init\n",
> dad0d04fa Fariya Fatima 2014-03-16 791 __func__);
> dad0d04fa Fariya Fatima           2014-03-16  792  			goto err1;
> dad0d04fa Fariya Fatima           2014-03-16  793  		}
> b78e91bcf Prameela Rani Garnepudi 2017-05-16 794 rsi_dbg(INIT_ZONE,
> "%s: Device Init Done\n", __func__);
> dad0d04fa Fariya Fatima           2014-03-16  795  	}
> dad0d04fa Fariya Fatima           2014-03-16  796
> 1100f81bb Prameela Rani Garnepudi 2018-02-27 797 status =
> rsi_rx_urb_submit(adapter, WLAN_EP);
> 50591c60a Alexey Khoroshilov      2014-06-27  798  	if (status)
> dad0d04fa Fariya Fatima           2014-03-16  799  		goto err1;
> dad0d04fa Fariya Fatima           2014-03-16  800
> a4302bff2 Siva Rebbagondla 2018-02-27 801 if (adapter->priv->coex_mode
>> 1) {
> a4302bff2 Siva Rebbagondla 2018-02-27 802 status =
> rsi_rx_urb_submit(adapter, BT_EP);
> a4302bff2 Siva Rebbagondla        2018-02-27  803  		if (status)
> a4302bff2 Siva Rebbagondla        2018-02-27  804  			goto err1;
> a4302bff2 Siva Rebbagondla        2018-02-27  805  	}
> a4302bff2 Siva Rebbagondla        2018-02-27  806
> dad0d04fa Fariya Fatima           2014-03-16  807  	return 0;
> dad0d04fa Fariya Fatima           2014-03-16  808  err1:
> dad0d04fa Fariya Fatima 2014-03-16 809
> rsi_deinit_usb_interface(adapter);
> dad0d04fa Fariya Fatima           2014-03-16  810  err:
> dad0d04fa Fariya Fatima           2014-03-16  811  	rsi_91x_deinit(adapter);
> dad0d04fa Fariya Fatima 2014-03-16 812 rsi_dbg(ERR_ZONE, "%s: Failed
> in probe...Exiting\n", __func__);
> 50591c60a Alexey Khoroshilov      2014-06-27  813  	return status;
> dad0d04fa Fariya Fatima           2014-03-16  814  }
> dad0d04fa Fariya Fatima           2014-03-16  815
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

-- 
Kalle Valo
