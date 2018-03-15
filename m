Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:43396 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932395AbeCOP52 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 11:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <EE0D5CBE-0867-4FE0-B157-CA4086C84233@holtmann.org>
References: <20180315154312.3941446-1-arnd@arndb.de> <EE0D5CBE-0867-4FE0-B157-CA4086C84233@holtmann.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 15 Mar 2018 16:57:26 +0100
Message-ID: <CAK8P3a3y00nUVuYopxXWaJjo_OxXhVsATyiSOfXz5b09JFq2dA@mail.gmail.com> (sfid-20180315_165749_010223_363C43D1)
Subject: Re: [PATCH] Bluetooth: btrsi: rework dependencies
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2018 at 4:50 PM, Marcel Holtmann <marcel@holtmann.org> wrote:

>> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
>> index 03cfc1b20c4a..9e8d22712ff3 100644
>> --- a/drivers/bluetooth/Makefile
>> +++ b/drivers/bluetooth/Makefile
>> @@ -28,7 +28,7 @@ obj-$(CONFIG_BT_QCA)                += btqca.o
>>
>> obj-$(CONFIG_BT_HCIUART_NOKIA)        += hci_nokia.o
>>
>> -obj-$(CONFIG_BT_HCIRSI)              += btrsi.o
>> +obj-$(CONFIG_BT_HCIRSI_MODULE)       += btrsi.o
>
> do we need this new option? I have avoided these kind of complex things multi config entries. Can we not just select the RSI_91X?
>

I couldn't come up with a simpler way to do this.
Selecting RSI_91X is not possible unless we make the BT
driver 'depend on WLAN_VENDOR_RSI && MAC80211',
which is even more backwards.

The problem here is that it's actually a reverse dependency:
the wlan driver calls into the bt driver.

What we could do is to make BT_HCIRSI a silent symbol
and have that selected by RSI_COEX, which can then
be user-visible. With that, the Kconfig structure would follow
what the code does.

       Arnd
