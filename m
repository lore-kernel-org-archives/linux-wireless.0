Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4662CC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05449206BF
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DHx5V2uQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfDZLeh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:34:37 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:40078 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDZLeg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 07:34:36 -0400
Received: by mail-vk1-f196.google.com with SMTP id l17so684095vke.7
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2019 04:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rzh6hLDT+RGAIBlIbU5z/r9PIF6C4TXum75Z8Tcdiug=;
        b=DHx5V2uQwLIvnOtA7asM0xWEfntGpbCw7H5j5JOOpGJlYXk6AGsE8pVyEl8XNwx0vs
         sCfHIfh0S/ww60kDWFBno2RFJYWiW2AaYmY/VipmswPcRRkpEIpGbxVrGj06nhZpHwW2
         b3HXYjNAcRtHyAUw84lz16mjo2IV0i+u3tV4I2h33kyBknzHUwt2ROLKshkj/271CkiJ
         SJ4CmbrzTS35zwnj62MuF6VBAze46vKTBR/YPLGyrCXl+pw5/zjGyj+QGmHmhJr204qa
         BCECMjTTe5IO5mhYv7ALErFyhIQ7oINsXraa4H9IrrbhKSflHwVNQXDFzVjqhh976UOy
         AarA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rzh6hLDT+RGAIBlIbU5z/r9PIF6C4TXum75Z8Tcdiug=;
        b=N7I5JpHcwjN0C3Md1yOr3zbVD8BXTM/besd4zmj03aZSkw/oZ4u6buNUZZvXIFVM/R
         Z4G2C731FnjCJc6fiYMETICgv1rlq2aMwzSGqLwSddLGSoEFelZNE+h8vj5TYNVoU84E
         O5r6uHp64VejsYFDlfsWnBd629swkqqNs6xAntTrOmOQOGNiYQuO1M7z33Lfbv0afaKI
         EJvsbZowXnx3nwoJnMBcoRJ7sIafPkN2KR1XmwA7wURuLF2Z2cNMJke8+koNKjCPtOTy
         xsrvyF3pPkKV/7ltHyoGLh1VbreFC+jxbNvHllvOQEVJ5S82OGXLOXeAACd0Tsdy6hvz
         sG2Q==
X-Gm-Message-State: APjAAAUxCqyeslzR7rQGfJQvNIRYMgkPGCMCjpv3BsOyrcBQVBy+0xKT
        yx8VqVBU9KClCWyDy1IrZGmAifpW2e+DiD2Rq5XfQSOITb8=
X-Google-Smtp-Source: APXvYqyMw9AtrEuO6Qu6/koydgXwh/Csc39yGaddbUPN1Xp2AOciGsPf0Ed0z3aEk0Xe/JJBuMgcIRbaU1UHAnqFBX4=
X-Received: by 2002:a1f:3ac9:: with SMTP id h192mr874440vka.31.1556278474947;
 Fri, 26 Apr 2019 04:34:34 -0700 (PDT)
MIME-Version: 1.0
References: <201904260301.nITK1ldv%lkp@intel.com> <CANGSkXQUwyAsQxKFrJSeycDJ-X5SUnoXroJt0a2tjg2btSyZvQ@mail.gmail.com>
 <875zr1wi3z.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <875zr1wi3z.fsf@kamboji.qca.qualcomm.com>
From:   Siva Rebbagondla <siva8118@gmail.com>
Date:   Fri, 26 Apr 2019 17:04:23 +0530
Message-ID: <CANGSkXT=srMR7Xr3d8WQVepaQpPLynm2FxqcB15ff-MuawwfKA@mail.gmail.com>
Subject: Re: [wireless-drivers-next:master 28/45] drivers/net/wireless/rsi/rsi_91x_usb.c:229:27:
 sparse: restricted __le32 degrades to integer
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

On Fri, Apr 26, 2019 at 9:09 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> + linux-wireless
>
> Siva Rebbagondla <siva8118@gmail.com> writes:
>
> > Hi Kalle,
> >
> > On Fri, Apr 26, 2019 at 1:06 AM kbuild test robot <lkp@intel.com> wrote:
> >>
> >> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> >> head:   147b502bda338f4f2dff19faaa5829b691305ea5
> >> commit: 0a60014b76f512f18e48cfb4efc71e07c6791996 [28/45] rsi: miscallaneous changes for 9116 and common
> >> reproduce:
> >>         # apt-get install sparse
> >>         git checkout 0a60014b76f512f18e48cfb4efc71e07c6791996
> >>         make ARCH=x86_64 allmodconfig
> >>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> >>
> >> If you fix the issue, kindly add following tag
> >> Reported-by: kbuild test robot <lkp@intel.com>
> >>
> >>
> >> sparse warnings: (new ones prefixed by >>)
> >>
> >> >> drivers/net/wireless/rsi/rsi_91x_usb.c:229:27: sparse: restricted __le32 degrades to integer
> >>    drivers/net/wireless/rsi/rsi_91x_usb.c:230:27: sparse: restricted __le32 degrades to integer
> >>    drivers/net/wireless/rsi/rsi_91x_usb.c:231:27: sparse: restricted __le32 degrades to integer
> >>    drivers/net/wireless/rsi/rsi_91x_usb.c:232:27: sparse: restricted __le32 degrades to integer
> >>    drivers/net/wireless/rsi/rsi_91x_usb.c:238:36: sparse: restricted __le32 degrades to integer
> >>    drivers/net/wireless/rsi/rsi_91x_usb.c:239:35: sparse: restricted __le32 degrades to integer
> >>    drivers/net/wireless/rsi/rsi_91x_usb.c:354:28: sparse: expression using sizeof(void)
> >>    drivers/net/wireless/rsi/rsi_91x_usb.c:401:28: sparse: expression using sizeof(void)
> >>
> >> vim +229 drivers/net/wireless/rsi/rsi_91x_usb.c
> >>
> >>    203
> >>    204  /**
> >>    205   * rsi_usb_reg_write() - This function writes the given data into the given
> >>    206   *                       register address.
> >>    207   * @usbdev: Pointer to the usb_device structure.
> >>    208   * @reg: Address of the register.
> >>    209   * @value: Value to write.
> >>    210   * @len: Length of data to be written.
> >>    211   *
> >>    212   * Return: status: 0 on success, a negative error code on failure.
> >>    213   */
> >>    214  static int rsi_usb_reg_write(struct usb_device *usbdev,
> >>    215                               u32 reg,
> >>    216                               u32 value,
> >>    217                               u16 len)
> >>    218  {
> >>    219          u8 *usb_reg_buf;
> >>    220          int status = -ENOMEM;
> >>    221
> >>    222          if (len > RSI_USB_CTRL_BUF_SIZE)
> >>    223                  return -EINVAL;
> >>    224
> >>    225          usb_reg_buf  = kmalloc(RSI_USB_CTRL_BUF_SIZE, GFP_KERNEL);
> >>    226          if (!usb_reg_buf)
> >>    227                  return status;
> >>    228
> >>  > 229          usb_reg_buf[0] = (cpu_to_le32(value) & 0x00ff);
> >>    230          usb_reg_buf[1] = (cpu_to_le32(value) & 0xff00) >> 8;
> >>    231          usb_reg_buf[2] = (cpu_to_le32(value) & 0x00ff0000) >> 16;
> >>    232          usb_reg_buf[3] = (cpu_to_le32(value) & 0xff000000) >> 24;
> >>    233
> >>    234          status = usb_control_msg(usbdev,
> >>    235                                   usb_sndctrlpipe(usbdev, 0),
> >>    236                                   USB_VENDOR_REGISTER_WRITE,
> >>    237                                   RSI_USB_REQ_OUT,
> >>    238                                   ((cpu_to_le32(reg) & 0xffff0000) >> 16),
> >>    239                                   (cpu_to_le32(reg) & 0xffff),
> >>    240                                   (void *)usb_reg_buf,
> >>    241                                   len,
> >>    242                                   USB_CTRL_SET_TIMEOUT);
> >>    243          if (status < 0) {
> >>    244                  rsi_dbg(ERR_ZONE,
> >>    245                          "%s: Reg write failed with error code :%d\n",
> >>    246                          __func__, status);
> >>    247          }
> >>    248          kfree(usb_reg_buf);
> >>    249
> >>    250          return status;
> >>    251  }
> >>    252
> >>
> >> ---
> >> 0-DAY kernel test infrastructure                Open Source Technology Center
> >> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> >
> > Some where went wrong. I fixed this one. I will resend you the patches
> > with changes.
>
> Your patches are now applied and cannot be changed, so no point of
> resending them anymore. You need to send followup patches which fix the
> issues and apply to wireless-drivers-next.
>
> And remember to use Fixes tag so that we know which commit patch fixes.
Sure. I will send a patch which fixes this.

Best regards,
Siva Rebbagondla
