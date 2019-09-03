Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5588CC3A5A7
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 14:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D47E23402
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 14:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KiOMKliE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y/go4IHw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfICOOU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:14:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48612 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729117AbfICOOU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 10:14:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9A6716090F; Tue,  3 Sep 2019 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567520059;
        bh=zXyYEMXgxwMe5kM6w/V7cIEreB+fNKc7naZiALNTuV0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KiOMKliERg7LuKGLumbuTIJ+UJL6E16SGVratZI6NIzYldjnimsKv2QvcAQV5XHO4
         WwpZ1pBMjBso7JOeTQ+2vgL3verNFkH1LumYPZjaubGlS6kLW7cIbDL+HXDzTiT8rX
         JpoYnqpTze27eHIU3lZonO0fJyF39wANCedKN4M4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4C3D56013C;
        Tue,  3 Sep 2019 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567520056;
        bh=zXyYEMXgxwMe5kM6w/V7cIEreB+fNKc7naZiALNTuV0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Y/go4IHw5C2+Czr7z7sw1YY2om5Qpc43pr14YwOkFu3rW4sx63XNo/9WjnRnjEz+h
         iOaeD/GBzmWPmUWxK3+bY5oueaSiTPPfbPWaG4cxjaHKbHJiOIIm3MULYdr94wPRpL
         HK760yQDod/5l0ijZ3wIKP/xYHSIgKWNfWytub+g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4C3D56013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] Fix a NULL-ptr-deref bug in
 ath10k_usb_alloc_urb_from_pipe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190804003101.11541-1-benquike@gmail.com>
References: <20190804003101.11541-1-benquike@gmail.com>
To:     Hui Peng <benquike@gmail.com>
Cc:     davem@davemloft.net, Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903141418.9A6716090F@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 14:14:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hui Peng <benquike@gmail.com> wrote:

> The `ar_usb` field of `ath10k_usb_pipe_usb_pipe` objects
> are initialized to point to the containing `ath10k_usb` object
> according to endpoint descriptors read from the device side, as shown
> below in `ath10k_usb_setup_pipe_resources`:
> 
> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
>         endpoint = &iface_desc->endpoint[i].desc;
> 
>         // get the address from endpoint descriptor
>         pipe_num = ath10k_usb_get_logical_pipe_num(ar_usb,
>                                                 endpoint->bEndpointAddress,
>                                                 &urbcount);
>         ......
>         // select the pipe object
>         pipe = &ar_usb->pipes[pipe_num];
> 
>         // initialize the ar_usb field
>         pipe->ar_usb = ar_usb;
> }
> 
> The driver assumes that the addresses reported in endpoint
> descriptors from device side  to be complete. If a device is
> malicious and does not report complete addresses, it may trigger
> NULL-ptr-deref `ath10k_usb_alloc_urb_from_pipe` and
> `ath10k_usb_free_urb_to_pipe`.
> 
> This patch fixes the bug by preventing potential NULL-ptr-deref.
> 
> Signed-off-by: Hui Peng <benquike@gmail.com>
> Reported-by: Hui Peng <benquike@gmail.com>
> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This causes a new warning, please build test your patches.

In file included from ./include/uapi/linux/posix_types.h:5,
                 from ./include/uapi/linux/types.h:14,
                 from ./include/linux/types.h:6,
                 from ./include/linux/list.h:5,
                 from ./include/linux/module.h:9,
                 from drivers/net/wireless/ath/ath10k/usb.c:8:
drivers/net/wireless/ath/ath10k/usb.c: In function 'ath10k_usb_free_urb_to_pipe':
./include/linux/stddef.h:8:14: warning: 'return' with a value, in function returning void
 #define NULL ((void *)0)
              ^
drivers/net/wireless/ath/ath10k/usb.c:64:10: note: in expansion of macro 'NULL'
   return NULL;
          ^~~~
drivers/net/wireless/ath/ath10k/usb.c:57:13: note: declared here
 static void ath10k_usb_free_urb_to_pipe(struct ath10k_usb_pipe *pipe,
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11074657/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

