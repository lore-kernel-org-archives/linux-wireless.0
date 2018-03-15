Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:43224 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbeCOQDz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 12:03:55 -0400
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH] Bluetooth: btrsi: rework dependencies
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAK8P3a3y00nUVuYopxXWaJjo_OxXhVsATyiSOfXz5b09JFq2dA@mail.gmail.com>
Date: Thu, 15 Mar 2018 17:03:52 +0100
Cc: Johan Hedberg <johan.hedberg@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Message-Id: <F9369C84-62C6-4881-8089-40F3F912F871@holtmann.org> (sfid-20180315_170439_581186_9559AD5C)
References: <20180315154312.3941446-1-arnd@arndb.de>
 <EE0D5CBE-0867-4FE0-B157-CA4086C84233@holtmann.org>
 <CAK8P3a3y00nUVuYopxXWaJjo_OxXhVsATyiSOfXz5b09JFq2dA@mail.gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd,

>>> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
>>> index 03cfc1b20c4a..9e8d22712ff3 100644
>>> --- a/drivers/bluetooth/Makefile
>>> +++ b/drivers/bluetooth/Makefile
>>> @@ -28,7 +28,7 @@ obj-$(CONFIG_BT_QCA)                += btqca.o
>>> 
>>> obj-$(CONFIG_BT_HCIUART_NOKIA)        += hci_nokia.o
>>> 
>>> -obj-$(CONFIG_BT_HCIRSI)              += btrsi.o
>>> +obj-$(CONFIG_BT_HCIRSI_MODULE)       += btrsi.o
>> 
>> do we need this new option? I have avoided these kind of complex things multi config entries. Can we not just select the RSI_91X?
>> 
> 
> I couldn't come up with a simpler way to do this.
> Selecting RSI_91X is not possible unless we make the BT
> driver 'depend on WLAN_VENDOR_RSI && MAC80211',
> which is even more backwards.
> 
> The problem here is that it's actually a reverse dependency:
> the wlan driver calls into the bt driver.
> 
> What we could do is to make BT_HCIRSI a silent symbol
> and have that selected by RSI_COEX, which can then
> be user-visible. With that, the Kconfig structure would follow
> what the code does.

that sounds a bit better to me. If the RSI driver maintainers don’t like that, then they should re-architect the code to make this more dynamic and flexible.

Regards

Marcel
