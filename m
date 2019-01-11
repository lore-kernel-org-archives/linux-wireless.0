Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1163CC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 17:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D189220836
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 17:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfAKR3P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 12:29:15 -0500
Received: from mail-io1-f45.google.com ([209.85.166.45]:34469 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729727AbfAKR3O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Jan 2019 12:29:14 -0500
Received: by mail-io1-f45.google.com with SMTP id b16so12784397ior.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2019 09:29:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AJuvHd8wS2rf/as08VgJ333vpo55mbqeGyD2/FlDgLM=;
        b=iYz9ENhZfa+Sea24x+ZlziGuKEh5ZPIhTR9j91NeFsMJRFHmvSyka84sUp97gnhCNe
         ldaMPbbaURQW6uMZxdNE5gkhVZoGYBSnq4jUCBTO0sIMGfUTldCKfHM9S14W0i2CuJDY
         HPIYaYT6Hlubb3+L1eQoM8D0MqeGZUmzxnUt9476LAMrNtuUBWrGIAFxXModEWpKVdZa
         e34DF48bSmMx7mmPEykUccf/B3tk5ekiRYoXbTTb8GL002/TMS6m1EJ5zAcxL+7TX3R2
         iJqKCZKTTCSLjoihptBSg+6b1C0pi/hhw7S+o62b7te4q9HYkk1ncvPumI9pCr9yaWUM
         Fucw==
X-Gm-Message-State: AJcUukfIEiTHtQ5IRkmfoyxQrIcCSplodaLoE5A5FaO5s02RGRi7WOsh
        7IXMlOPeqG7UB/IV2oHeAs+u8Z81pj6xT4f22UqY4Q==
X-Google-Smtp-Source: ALg8bN4o7OQNpbPXjwLgCqCrEnhFv8lb8YE8NACIjVY+9CBugdCd0IQ2jHzLgd29iWaOn7hya5a7LhNHOS+KuWNXdMA=
X-Received: by 2002:a6b:ea09:: with SMTP id m9mr7436502ioc.297.1547227753787;
 Fri, 11 Jan 2019 09:29:13 -0800 (PST)
MIME-Version: 1.0
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
In-Reply-To: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 11 Jan 2019 18:29:02 +0100
Message-ID: <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     Rosen Penev <rosenp@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> I have an ALFA AWUS036ACM and whenever I plug it in, the XHCI driver
> dies. This is on an ASRock X370 motherboard. Kernel 4.20 Arch Linux.
>
> After plugging in the adapter, the integrated wireless chip (Intel
> 3168) also dies. Disabling the motherboard wireless does not help.
> Here are two fairly similar logs. First with Intel 3168 and the second
> with it disabled in UEFI.
>

[...]

> Without iwlwifi:
>
> kernel: usb 1-14: new high-speed USB device number 3 using xhci_hcd
> kernel: usb 1-14: New USB device found, idVendor=0e8d, idProduct=7612,
> bcdDevice= 1.00
> kernel: usb 1-14: New USB device strings: Mfr=2, Product=3, SerialNumber=4
> usb 1-14: Product: Wireless
> kernel: usb 1-14: Manufacturer: MediaTek Inc.
> kernel: usb 1-14: SerialNumber: 000000000
> mtp-probe[1400]: checking bus 1, device 3:
> "/sys/devices/pci0000:00/0000:00:01.3/0000:03:00.0/usb1/1-14"
> mtp-probe[1400]: bus: 1, device: 3 was not an MTP device
> kernel: usb 1-14: reset high-speed USB device number 3 using xhci_hcd
> kernel: mt76x2u 1-14:1.0: ASIC revision: 76120044
> kernel: mt76x2u 1-14:1.0: ROM patch build: 20140408060640a
> kernel: xhci_hcd 0000:03:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT

Are you using the driver in a VM or directly in the host? This is an
error reported by AMD iommu driver

Regards,
Lorenzo
