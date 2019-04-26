Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33237C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 03:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40EC206C1
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 03:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HBUKa0Ug";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hpTByOzT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfDZDjC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 23:39:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfDZDjC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 23:39:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D1A1605A5; Fri, 26 Apr 2019 03:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556249941;
        bh=acnty/A1O5GRw+Gk1FBspe63pZxK8v5mwfTS6Jc3DEw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HBUKa0Ug6F96+Ms+Xl/R8M7hs5D6d7GkvlZNeUciigWRB7LU6AkgIVGbl0owqdKjS
         iEgnOpMQWH+Y6CvU84pujPr81HcXN+8WcQK1NWFYEo88A/68sZ00lNkj+K7xnQtnOo
         d+ofF5M1GaSy5VtvUGPwDysCVoA8yA0ABdC7kTBE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 291C860388;
        Fri, 26 Apr 2019 03:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556249940;
        bh=acnty/A1O5GRw+Gk1FBspe63pZxK8v5mwfTS6Jc3DEw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hpTByOzTWXIeMQk3SCM8SWTZ8j6um5U4zUyjWUxSnm0yXyUnsW58A60f7cyrbCYn+
         FuMj67hYwV7nvIxqVgifh21k+Hq08UYy3D+H7NJFygOsrEmMhUgXVJiBuGbTw8KIlJ
         5TvhVdIsL+4vWKJJqce0JrPlRPSD8cHB68wd6H5M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 291C860388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        linux-wireless@vger.kernel.org
Subject: Re: [wireless-drivers-next:master 28/45] drivers/net/wireless/rsi/rsi_91x_usb.c:229:27: sparse: restricted __le32 degrades to integer
References: <201904260301.nITK1ldv%lkp@intel.com>
        <CANGSkXQUwyAsQxKFrJSeycDJ-X5SUnoXroJt0a2tjg2btSyZvQ@mail.gmail.com>
Date:   Fri, 26 Apr 2019 06:38:56 +0300
In-Reply-To: <CANGSkXQUwyAsQxKFrJSeycDJ-X5SUnoXroJt0a2tjg2btSyZvQ@mail.gmail.com>
        (Siva Rebbagondla's message of "Fri, 26 Apr 2019 05:50:08 +0530")
Message-ID: <875zr1wi3z.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless

Siva Rebbagondla <siva8118@gmail.com> writes:

> Hi Kalle,
>
> On Fri, Apr 26, 2019 at 1:06 AM kbuild test robot <lkp@intel.com> wrote:
>>
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
>> head:   147b502bda338f4f2dff19faaa5829b691305ea5
>> commit: 0a60014b76f512f18e48cfb4efc71e07c6791996 [28/45] rsi: miscallaneous changes for 9116 and common
>> reproduce:
>>         # apt-get install sparse
>>         git checkout 0a60014b76f512f18e48cfb4efc71e07c6791996
>>         make ARCH=x86_64 allmodconfig
>>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
>>
>> If you fix the issue, kindly add following tag
>> Reported-by: kbuild test robot <lkp@intel.com>
>>
>>
>> sparse warnings: (new ones prefixed by >>)
>>
>> >> drivers/net/wireless/rsi/rsi_91x_usb.c:229:27: sparse: restricted __le32 degrades to integer
>>    drivers/net/wireless/rsi/rsi_91x_usb.c:230:27: sparse: restricted __le32 degrades to integer
>>    drivers/net/wireless/rsi/rsi_91x_usb.c:231:27: sparse: restricted __le32 degrades to integer
>>    drivers/net/wireless/rsi/rsi_91x_usb.c:232:27: sparse: restricted __le32 degrades to integer
>>    drivers/net/wireless/rsi/rsi_91x_usb.c:238:36: sparse: restricted __le32 degrades to integer
>>    drivers/net/wireless/rsi/rsi_91x_usb.c:239:35: sparse: restricted __le32 degrades to integer
>>    drivers/net/wireless/rsi/rsi_91x_usb.c:354:28: sparse: expression using sizeof(void)
>>    drivers/net/wireless/rsi/rsi_91x_usb.c:401:28: sparse: expression using sizeof(void)
>>
>> vim +229 drivers/net/wireless/rsi/rsi_91x_usb.c
>>
>>    203
>>    204  /**
>>    205   * rsi_usb_reg_write() - This function writes the given data into the given
>>    206   *                       register address.
>>    207   * @usbdev: Pointer to the usb_device structure.
>>    208   * @reg: Address of the register.
>>    209   * @value: Value to write.
>>    210   * @len: Length of data to be written.
>>    211   *
>>    212   * Return: status: 0 on success, a negative error code on failure.
>>    213   */
>>    214  static int rsi_usb_reg_write(struct usb_device *usbdev,
>>    215                               u32 reg,
>>    216                               u32 value,
>>    217                               u16 len)
>>    218  {
>>    219          u8 *usb_reg_buf;
>>    220          int status = -ENOMEM;
>>    221
>>    222          if (len > RSI_USB_CTRL_BUF_SIZE)
>>    223                  return -EINVAL;
>>    224
>>    225          usb_reg_buf  = kmalloc(RSI_USB_CTRL_BUF_SIZE, GFP_KERNEL);
>>    226          if (!usb_reg_buf)
>>    227                  return status;
>>    228
>>  > 229          usb_reg_buf[0] = (cpu_to_le32(value) & 0x00ff);
>>    230          usb_reg_buf[1] = (cpu_to_le32(value) & 0xff00) >> 8;
>>    231          usb_reg_buf[2] = (cpu_to_le32(value) & 0x00ff0000) >> 16;
>>    232          usb_reg_buf[3] = (cpu_to_le32(value) & 0xff000000) >> 24;
>>    233
>>    234          status = usb_control_msg(usbdev,
>>    235                                   usb_sndctrlpipe(usbdev, 0),
>>    236                                   USB_VENDOR_REGISTER_WRITE,
>>    237                                   RSI_USB_REQ_OUT,
>>    238                                   ((cpu_to_le32(reg) & 0xffff0000) >> 16),
>>    239                                   (cpu_to_le32(reg) & 0xffff),
>>    240                                   (void *)usb_reg_buf,
>>    241                                   len,
>>    242                                   USB_CTRL_SET_TIMEOUT);
>>    243          if (status < 0) {
>>    244                  rsi_dbg(ERR_ZONE,
>>    245                          "%s: Reg write failed with error code :%d\n",
>>    246                          __func__, status);
>>    247          }
>>    248          kfree(usb_reg_buf);
>>    249
>>    250          return status;
>>    251  }
>>    252
>>
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
> Some where went wrong. I fixed this one. I will resend you the patches
> with changes.

Your patches are now applied and cannot be changed, so no point of
resending them anymore. You need to send followup patches which fix the
issues and apply to wireless-drivers-next.

And remember to use Fixes tag so that we know which commit patch fixes.

-- 
Kalle Valo
