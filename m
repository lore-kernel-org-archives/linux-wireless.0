Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:47215 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdJYTfi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 15:35:38 -0400
Received: by mail-oi0-f46.google.com with SMTP id h200so1940123oib.4
        for <linux-wireless@vger.kernel.org>; Wed, 25 Oct 2017 12:35:37 -0700 (PDT)
Subject: Re: RTL usb adapter question
To: David Ashley <dashxdr@gmail.com>, linux-wireless@vger.kernel.org
References: <CABkE59DHPoLD5PGRHpKMAwy0w3vR9M_qoHEQ1AkK-ELDcUXD9Q@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5f907d16-b889-f7c0-0873-880e5c812ab9@lwfinger.net> (sfid-20171025_213549_211974_215C1A83)
Date: Wed, 25 Oct 2017 14:35:35 -0500
MIME-Version: 1.0
In-Reply-To: <CABkE59DHPoLD5PGRHpKMAwy0w3vR9M_qoHEQ1AkK-ELDcUXD9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2017 01:43 PM, David Ashley wrote:
> I'm trying to understand how the linux kernel loads RTL8188CUS firmware
> rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin
> when that file isn't available anywhere in my embedded system's filesystem.
> 
> Basically I'm trying to understand the theory. We have a product that
> is making use of the device
> 
> Bus 001 Device 007: ID 7392:7811 Edimax Technology Co., Ltd
> EW-7811Un802.11n Wireless Adapter [Realtek RTL8188CUS]
> 
> It has not been especially reliable. I've never provided firmware
> files for the device in the root filesystem. I've started to pay
> attention to the kernel error messages. Now the kernel drivers seem to
> be loading the rtlwifi/rtl8192cufw_TMSC.bin file and I'm trying to
> understand if this is actually working, if it makes any difference in
> reliability...
> 
> It's like I can't figure out how the usb dongle even worked without
> its firmware file...
> 
> My working theory is that the usb dongle comes from the factory with a
> hardcoded firmware file (rtlwifi/rtl8192cufw.bin) but it is buggy or
> inferior. And the performance and reliability can be improved if the
> driver successfully manages to load the rtl8192cufw_TMSC.bin file. I
> don't know if the firmware load persists across a power cycle (my
> assumption is it doesn't).

There is NO firmware coded by the factory in the device. It only has enough 
intelligence to load the real firmware. The exact file that it loads is 
determined by the model. If you provide the appropriate section of the output of 
dmesg where the above firmware messages occur, and a file listing of 
/lib/firmware/rtlwifi/, I can tell you what firmware is being loaded.

No, firmware will not persist across a power failure.

The driver has never been particularly reliable, and the USB group at Realtek 
seems not to care. You might try their other driver, but you will be on your 
own, as I will not support that particular piece of ****.

Please reply to all on any followups.

Larry
