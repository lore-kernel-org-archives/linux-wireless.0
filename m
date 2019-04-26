Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D3DC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD27F206E0
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YmP2/muJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfDZPNx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:13:53 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:36074 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfDZPNx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:13:53 -0400
Received: by mail-ua1-f68.google.com with SMTP id k32so1307962uae.3
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2019 08:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=htGSmOlc/Sn9Ze+PaSSshIZRhPxLTJA+hkWQrIR3Ziw=;
        b=YmP2/muJeJvoWX2NWjjrqs8jt0PigytFB3QqwIbvVnleUcNYe61SybMwyG09sIUkym
         t9dTWbdDzFBFJ9XUItzL34xS/Qo3sGkVXU2pGW65yROPcgGgGnL1eNtUcOOMilU1sjIi
         jqY+rr0ze9/wNbnOdp865C6j3rbGrCGqxyczHIbwEgut3YvkQ3CfRwxngLEjULpnn1Oj
         6Bq7ST6+EdJJXzN8U09Mle0SByju4FZ+5kVY+MRG7wf4kOAH1bSfCvX++eKUxuowQmUN
         GrtqNY7LxBen/7MrAgn2bK7yB1jRmYSkh8Nvj3G0lqJBNXNgzaufThVXEQw0Wxv4SitF
         A7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=htGSmOlc/Sn9Ze+PaSSshIZRhPxLTJA+hkWQrIR3Ziw=;
        b=b4s16fER1VhQ/v2g8tC3W9aiGTsRNdUtQ/twLLFQsrwG55Yl4Fov0+otP3WW6KWx/6
         7hKcmLyarglefefDX3Twt+y1UdmC6ncpr3H2JNcacAg6FezmD9laksg6L+PW/AlF4Pj6
         jAdx1gZRQa1dMOsc4G5k/TX/q0t8AacWFVD8UhnIPvLVESlbZ64w9l3b3sfRfPmClm4g
         jSKLkrAVJSdxECXNE1BMU6GOBrbvOf0OXp6UYPkVd7sFVIMS4D4zB9QNuHsz95KRgEzL
         Q4mV92JeMYZSWx4ojHEU3y9ZKJWtauKGTdn4Mnl3PS3UtCuP4DS3NX/pitkpFd5K+Yxq
         JWjQ==
X-Gm-Message-State: APjAAAUoNjMjTFFuqRvoe8ukLof2XkS7TIlI1GZr/C48mpTxwSJXVLT8
        +rJORDYF9zqnk4Q2tSWBuRDUQf9zQ5I9KbJ8a3c=
X-Google-Smtp-Source: APXvYqysSgQ2maVcGHOZHawrc0gjIxU2zhXK/SU3Tfh9fk8nBZp4qS/ELRCDfovdC02+rGkB7iN2F0bZcG5mCaVLE4c=
X-Received: by 2002:ab0:6410:: with SMTP id x16mr7611251uao.7.1556291631581;
 Fri, 26 Apr 2019 08:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.20.1904261625060.21912@hadrien> <871s1ovmo4.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871s1ovmo4.fsf@kamboji.qca.qualcomm.com>
From:   Siva Rebbagondla <siva8118@gmail.com>
Date:   Fri, 26 Apr 2019 20:43:40 +0530
Message-ID: <CANGSkXSYfzn5oxsRvCrAWiS0itY-aVVC+=Qea506kkjq6TfYjg@mail.gmail.com>
Subject: Re: [wireless-drivers-next:master 21/45] drivers/net/wireless/rsi/rsi_91x_usb.c:774:17-26:
 ERROR: id is NULL but dereferenced. (fwd)
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Julia Lawall <julia.lawall@lip6.fr>, kbuild-all@01.org,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Fri, Apr 26, 2019 at 8:28 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> + linux-wireless
>
> Julia Lawall <julia.lawall@lip6.fr> writes:
>
> > The ifs starting on line 766 can fail because id is NULL.
I don't think id will be NULL here. id is coming from probe.
Is there any other opinions?.
> >
> > julia
> >
> > ---------- Forwarded message ----------
> > Date: Fri, 26 Apr 2019 06:39:46 +0800
> > From: kbuild test robot <lkp@intel.com>
> > To: kbuild@01.org
> > Cc: Julia Lawall <julia.lawall@lip6.fr>
> > Subject: [wireless-drivers-next:master 21/45]
> >     drivers/net/wireless/rsi/rsi_91x_usb.c:774:17-26: ERROR: id is NULL but
> >     dereferenced.
> >
> > CC: kbuild-all@01.org
> > TO: Siva Rebbagondla <siva8118@gmail.com>
> > CC: Kalle Valo <kvalo@codeaurora.org>
> >
> > tree:
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
> > master
> > head:   147b502bda338f4f2dff19faaa5829b691305ea5
> > commit: 54fdb318c1116814711fad4bd166e6c85a477ef0 [21/45] rsi: add new
> > device model for 9116
> > :::::: branch date: 5 hours ago
> > :::::: commit date: 6 hours ago
> >
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> >
> >>> drivers/net/wireless/rsi/rsi_91x_usb.c:774:17-26: ERROR: id is NULL
> > but dereferenced.
> >
> > #
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=54fdb318c1116814711fad4bd166e6c85a477ef0
> > git remote add wireless-drivers-next
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
> > git remote update wireless-drivers-next
> > git checkout 54fdb318c1116814711fad4bd166e6c85a477ef0
> > vim +774 drivers/net/wireless/rsi/rsi_91x_usb.c
> >
> > ea0676c47 Karun Eagalapati        2017-07-06  729
> > dad0d04fa Fariya Fatima           2014-03-16  730  /**
> > dad0d04fa Fariya Fatima 2014-03-16 731 * rsi_probe() - This function
> > is called by kernel when the driver provided
> > dad0d04fa Fariya Fatima 2014-03-16 732 * Vendor and device IDs are
> > matched. All the initialization
> > dad0d04fa Fariya Fatima           2014-03-16  733   *          work is done here.
> > dad0d04fa Fariya Fatima 2014-03-16 734 * @pfunction: Pointer to the
> > USB interface structure.
> > dad0d04fa Fariya Fatima 2014-03-16 735 * @id: Pointer to the
> > usb_device_id structure.
> > dad0d04fa Fariya Fatima           2014-03-16  736   *
> > 50591c60a Alexey Khoroshilov 2014-06-27 737 * Return: 0 on success, a
> > negative error code on failure.
> > dad0d04fa Fariya Fatima           2014-03-16  738   */
> > dad0d04fa Fariya Fatima 2014-03-16 739 static int rsi_probe(struct
> > usb_interface *pfunction,
> > dad0d04fa Fariya Fatima 2014-03-16 740 const struct usb_device_id *id)
> > dad0d04fa Fariya Fatima           2014-03-16  741  {
> > dad0d04fa Fariya Fatima           2014-03-16  742     struct rsi_hw *adapter;
> > dad0d04fa Fariya Fatima           2014-03-16  743     struct rsi_91x_usbdev *dev;
> > dad0d04fa Fariya Fatima           2014-03-16  744     u16 fw_status;
> > 50591c60a Alexey Khoroshilov      2014-06-27  745     int status;
> > dad0d04fa Fariya Fatima           2014-03-16  746
> > dad0d04fa Fariya Fatima 2014-03-16 747 rsi_dbg(INIT_ZONE, "%s: Init
> > function called\n", __func__);
> > dad0d04fa Fariya Fatima           2014-03-16  748
> > 898b25533 Prameela Rani Garnepudi 2018-02-27 749 adapter =
> > rsi_91x_init(dev_oper_mode);
> > dad0d04fa Fariya Fatima           2014-03-16  750     if (!adapter) {
> > dad0d04fa Fariya Fatima 2014-03-16 751 rsi_dbg(ERR_ZONE, "%s: Failed
> > to init os intf ops\n",
> > dad0d04fa Fariya Fatima           2014-03-16  752                     __func__);
> > 50591c60a Alexey Khoroshilov      2014-06-27  753             return -ENOMEM;
> > dad0d04fa Fariya Fatima           2014-03-16  754     }
> > b78e91bcf Prameela Rani Garnepudi 2017-05-16 755
> > adapter->rsi_host_intf = RSI_HOST_INTF_USB;
> > dad0d04fa Fariya Fatima           2014-03-16  756
> > 50591c60a Alexey Khoroshilov 2014-06-27 757 status =
> > rsi_init_usb_interface(adapter, pfunction);
> > 50591c60a Alexey Khoroshilov      2014-06-27  758     if (status) {
> > dad0d04fa Fariya Fatima 2014-03-16 759 rsi_dbg(ERR_ZONE, "%s: Failed
> > to init usb interface\n",
> > dad0d04fa Fariya Fatima           2014-03-16  760                     __func__);
> > dad0d04fa Fariya Fatima           2014-03-16  761             goto err;
> > dad0d04fa Fariya Fatima           2014-03-16  762     }
> > dad0d04fa Fariya Fatima           2014-03-16  763
> > dad0d04fa Fariya Fatima 2014-03-16 764 rsi_dbg(ERR_ZONE, "%s:
> > Initialized os intf ops\n", __func__);
> > dad0d04fa Fariya Fatima           2014-03-16  765
> > 54fdb318c Siva Rebbagondla 2019-04-03 766 if (id && id->idProduct ==
> > RSI_USB_PID_9113) {
> > 54fdb318c Siva Rebbagondla 2019-04-03 767 rsi_dbg(INIT_ZONE, "%s: 9113
> > module detected\n", __func__);
> > 54fdb318c Siva Rebbagondla 2019-04-03 768 adapter->device_model =
> > RSI_DEV_9113;
> > 54fdb318c Siva Rebbagondla 2019-04-03 769 } else if (id &&
> > id->idProduct == RSI_USB_PID_9116) {
> > 54fdb318c Siva Rebbagondla 2019-04-03 770 rsi_dbg(INIT_ZONE, "%s: 9116
> > module detected\n", __func__);
> > 54fdb318c Siva Rebbagondla 2019-04-03 771 adapter->device_model =
> > RSI_DEV_9116;
> > 54fdb318c Siva Rebbagondla        2019-04-03  772     } else {
> > 54fdb318c Siva Rebbagondla 2019-04-03 773 rsi_dbg(ERR_ZONE, "%s:
> > Unsupported RSI device id 0x%x\n",
> > 54fdb318c Siva Rebbagondla 2019-04-03 @774 __func__, id->idProduct);
> > 54fdb318c Siva Rebbagondla        2019-04-03  775             goto err1;
> > 54fdb318c Siva Rebbagondla        2019-04-03  776     }
> > 54fdb318c Siva Rebbagondla        2019-04-03  777
> > dad0d04fa Fariya Fatima 2014-03-16 778 dev = (struct rsi_91x_usbdev
> > *)adapter->rsi_dev;
> > dad0d04fa Fariya Fatima           2014-03-16  779
> > 50591c60a Alexey Khoroshilov 2014-06-27 780 status =
> > rsi_usb_reg_read(dev->usbdev, FW_STATUS_REG, &fw_status, 2);
> > b78e91bcf Prameela Rani Garnepudi 2017-05-16  781     if (status < 0)
> > dad0d04fa Fariya Fatima           2014-03-16  782             goto err1;
> > dad0d04fa Fariya Fatima           2014-03-16  783     else
> > dad0d04fa Fariya Fatima           2014-03-16  784             fw_status &= 1;
> > dad0d04fa Fariya Fatima           2014-03-16  785
> > dad0d04fa Fariya Fatima           2014-03-16  786     if (!fw_status) {
> > b78e91bcf Prameela Rani Garnepudi 2017-05-16 787 rsi_dbg(INIT_ZONE,
> > "Loading firmware...\n");
> > b78e91bcf Prameela Rani Garnepudi 2017-05-16 788 status =
> > rsi_hal_device_init(adapter);
> > 50591c60a Alexey Khoroshilov      2014-06-27  789             if (status) {
> > dad0d04fa Fariya Fatima 2014-03-16 790 rsi_dbg(ERR_ZONE, "%s: Failed
> > in device init\n",
> > dad0d04fa Fariya Fatima 2014-03-16 791 __func__);
> > dad0d04fa Fariya Fatima           2014-03-16  792                     goto err1;
> > dad0d04fa Fariya Fatima           2014-03-16  793             }
> > b78e91bcf Prameela Rani Garnepudi 2017-05-16 794 rsi_dbg(INIT_ZONE,
> > "%s: Device Init Done\n", __func__);
> > dad0d04fa Fariya Fatima           2014-03-16  795     }
> > dad0d04fa Fariya Fatima           2014-03-16  796
> > 1100f81bb Prameela Rani Garnepudi 2018-02-27 797 status =
> > rsi_rx_urb_submit(adapter, WLAN_EP);
> > 50591c60a Alexey Khoroshilov      2014-06-27  798     if (status)
> > dad0d04fa Fariya Fatima           2014-03-16  799             goto err1;
> > dad0d04fa Fariya Fatima           2014-03-16  800
> > a4302bff2 Siva Rebbagondla 2018-02-27 801 if (adapter->priv->coex_mode
> >> 1) {
> > a4302bff2 Siva Rebbagondla 2018-02-27 802 status =
> > rsi_rx_urb_submit(adapter, BT_EP);
> > a4302bff2 Siva Rebbagondla        2018-02-27  803             if (status)
> > a4302bff2 Siva Rebbagondla        2018-02-27  804                     goto err1;
> > a4302bff2 Siva Rebbagondla        2018-02-27  805     }
> > a4302bff2 Siva Rebbagondla        2018-02-27  806
> > dad0d04fa Fariya Fatima           2014-03-16  807     return 0;
> > dad0d04fa Fariya Fatima           2014-03-16  808  err1:
> > dad0d04fa Fariya Fatima 2014-03-16 809
> > rsi_deinit_usb_interface(adapter);
> > dad0d04fa Fariya Fatima           2014-03-16  810  err:
> > dad0d04fa Fariya Fatima           2014-03-16  811     rsi_91x_deinit(adapter);
> > dad0d04fa Fariya Fatima 2014-03-16 812 rsi_dbg(ERR_ZONE, "%s: Failed
> > in probe...Exiting\n", __func__);
> > 50591c60a Alexey Khoroshilov      2014-06-27  813     return status;
> > dad0d04fa Fariya Fatima           2014-03-16  814  }
> > dad0d04fa Fariya Fatima           2014-03-16  815
> >
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
> --
> Kalle Valo

--
Siva Rebbagondla
