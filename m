Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37515 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbcJRToW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 15:44:22 -0400
Received: by mail-wm0-f48.google.com with SMTP id c78so12531052wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2016 12:44:22 -0700 (PDT)
Received: from localhost.localdomain (127.7.150.83.ftth.as8758.net. [83.150.7.127])
        by smtp.gmail.com with ESMTPSA id za1sm60719759wjb.8.2016.10.18.12.44.16
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Oct 2016 12:44:17 -0700 (PDT)
Subject: Re: Intel 7260 not working on 4.4.24 / armv7
To: linux-wireless@vger.kernel.org
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com>
 <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
 <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com>
 <fa098763-cdf6-03f8-6d75-0fa9dfb270e4@gmail.com>
 <1476817578.6425.40.camel@sipsolutions.net>
From: Oliver Zemann <oliver.zemann@gmail.com>
Message-ID: <1dce4f5d-b905-9f26-17f3-d8b1ae0d1b13@gmail.com> (sfid-20161018_214426_857029_72ADE60C)
Date: Tue, 18 Oct 2016 21:44:16 +0200
MIME-Version: 1.0
In-Reply-To: <1476817578.6425.40.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there some way to disable the bluetooth functionality?


Am 18.10.2016 um 21:06 schrieb Johannes Berg:
> On Tue, 2016-10-18 at 18:22 +0200, Oliver Zemann wrote:
>> Because of the problems with the ath10 card, i bought an intel 7260
>> (mpcie) wifi card. Unfortunately it is also not working.
>> I get tons of those messages:
>>
>> [  175.777030] usb 1-1: new full-speed USB device number 2 using
>> orion-ehci
>> [  175.933953] usb 1-1: New USB device found, idVendor=8087,
>> idProduct=07dc
>> [  175.940681] usb 1-1: New USB device strings: Mfr=0, Product=0,
>> SerialNumber=0
>> [  175.966954] Bluetooth: hci0: read Intel version:
>> 3707100180012d0d00
>> [  175.973313] Bluetooth: hci0: Intel Bluetooth firmware file:
>> intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
>> [  176.183954] Bluetooth: hci0: Intel Bluetooth firmware patch
>> completed
>> and activated
>> [  176.749831] usb 1-1: USB disconnect, device number 2
> This is odd. However, it's entirely related to the NICs *Bluetooth*
> function, which lives on USB.
>
>> What's confusing me is that this device is connected through pcie,
>> not usb. When i use lspci i get:
>> [root@alarm log]# lspci
>> 00:02.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev
>> 04)
>> 00:03.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev
>> 04)
>> 02:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac
>> Wireless Network Adapter (rev ff)
>>
>> So the other card is seen as pci device, but the intel is not. I am
>> really lost now.
> The NICs *WiFi* function should be a PCIe device, but the USB
> connect/disconnect cycles suggest that there's something wrong with the
> electrical connection, which presumably causes the PCIe part of the
> device to never appear on the bus.
>
> johannes
