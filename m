Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:37867 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbeAQWrv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 17:47:51 -0500
Received: by mail-qt0-f175.google.com with SMTP id d54so13683441qtd.4
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jan 2018 14:47:51 -0800 (PST)
Subject: Re: Not work 802.11ac WLAN Adapter
To: Cristian <caravena@gmail.com>, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <CABwnbU=Z7zJd8zL-0qkEnNHgQyvLCQ+85d1oMh+FKM83rzmoSA@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5FD293.2010107@broadcom.com> (sfid-20180117_234755_874618_32995E3C)
Date: Wed, 17 Jan 2018 23:47:47 +0100
MIME-Version: 1.0
In-Reply-To: <CABwnbU=Z7zJd8zL-0qkEnNHgQyvLCQ+85d1oMh+FKM83rzmoSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/17/2018 9:47 PM, Cristian wrote:
> Hello,
>
> Open bug in launchpad.net
> https://bugs.launchpad.net/bugs/1743872
>
> dmesg_4.15.0-041500rc8-generic
>
> dmesg:
> [ 104.468231] usb 3-2: new high-speed USB device number 4 using xhci_hcd
> [ 104.616570] usb 3-2: New USB device found, idVendor=0bda, idProduct=a811
> [ 104.616578] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [ 104.616582] usb 3-2: Product: 802.11ac WLAN Adapter
> [ 104.616585] usb 3-2: Manufacturer: Realtek
> [ 104.616588] usb 3-2: SerialNumber: 00e04c000001

So according to wikidevi it seems to be a RTL8811AU [1]. This does not 
seem supported by an upstream driver. Just search for "rtl8811au linux 
driver" on your favorite internet search engine and I am sure you will 
find a solution. Ubuntu seems to have a dkms package for it [2].

Regards,
Arend

[1] 
https://wikidevi.com/w/index.php?title=Special%3AAsk&q=%5B%5BDevice+ID%3A%3Aa811%5D%5D&po=%3FInterface%0D%0A%3FForm+factor%3DFF%0D%0A%3FInterface+connector+type%3DUSB+conn.%0D%0A%3FFCC+ID%0D%0A%3FManuf%0D%0A%3FManuf+product+model%3DManuf.+mdl%0D%0A%3FVendor+ID%0D%0A%3FDevice+ID%0D%0A%3FChip1+model%0D%0A%3FSupported+802dot11+protocols%3DPHY+modes%0D%0A%3FMIMO+config%0D%0A%3FOUI%0D%0A%3FEstimated+year+of+release%3DEst.+year%0D%0A&eq=yes&p%5Bformat%5D=broadtable&sort_num=&order_num=ASC&p%5Blimit%5D=500&p%5Boffset%5D=&p%5Blink%5D=all&p%5Bsort%5D=&p%5Bheaders%5D=show&p%5Bmainlabel%5D=&p%5Bintro%5D=&p%5Boutro%5D=&p%5Bsearchlabel%5D=%E2%80%A6+further+results&p%5Bdefault%5D=&p%5Bclass%5D=sortable+wikitable+smwtable&p%5Bsep%5D=&eq=yes
[2] https://packages.ubuntu.com/xenial/kernel/rtl8812au-dkms
