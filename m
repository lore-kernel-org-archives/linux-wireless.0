Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55936 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753264AbeGEPcV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 11:32:21 -0400
Received: by mail-wm0-f68.google.com with SMTP id v16-v6so11989491wmv.5
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 08:32:21 -0700 (PDT)
Date: Thu, 5 Jul 2018 17:32:17 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 00/11] Add mt76x0 driver
Message-ID: <20180705153216.GE17524@localhost.localdomain> (sfid-20180705_173226_357198_1F13DE38)
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jul 05, Stanislaw Gruszka wrote:
> Add mt76x0 driver for MT7610U based USB dongles. Currently driver
> support only STA mode.

Hi Stanislaw,

> 
> mt76x0 is based on Jakub's mt7601u driver already included
> in the kernel. I would like the driver be integrated as part
> of mt76 (instead of separate driver in mediatek dir like mt7601u)
> to utilize mt76 code for adding support for MT76x0 PCIe devices
> in further development.
> 
> To do not collide with current mt76x2u work from Lorenzo, I did not
> remove some code duplication. This will be done in the future, when
> Lorenzo patches will be merged. I plan to do more close integration
> with mt76x2u into common mt76 layer and add support for MT76x0 PCIe
> devices (i.e. MT7630E). Any help with this work is obviously welcome.
> My integration efforts can be traced here:
> https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft
> 

I just had a brief review of the code and I compiled the driver since at
the moment I had no adapter for that chipset.
As a remainder for future improvements/integration most of the code in 
dma.c, usb.c (except probe/disconnect functions) and tx.c can use the related
routines in the mt76-usb layer (we need to fill function pointer for chipset
related stuff if there are differences with mt76x2u, not looked yet).
Moreover mcu code can use utility routines in usb-mcu.c
I have not looked at mt76x2 common code yet.

Regards,
Lorenzo

> For full support mt7610.bin firmware blob is need, hopefully with 
> the permission of Mediatek, the blob will be pushed into linux-firmware
> git tree.
> 
> Stanislaw Gruszka (11):
>   mt76: add more states
>   mt76x0: core files
>   mt76x0: mac files
>   mt76x0: usb files
>   mt76x0: mcu files
>   mt76x0: phy files
>   mt76x0: init files
>   mt76x0: eeprom files
>   mt76x0: trace and debugfs files
>   mt76x0: dma and tx files
>   mt76: Kconfig and Makefile for mt76x0 driver
> 
>  drivers/net/wireless/mediatek/mt76/Kconfig         |    7 +
>  drivers/net/wireless/mediatek/mt76/Makefile        |    1 +
>  drivers/net/wireless/mediatek/mt76/mt76.h          |    4 +
>  drivers/net/wireless/mediatek/mt76/mt76x0/Makefile |    7 +
>  drivers/net/wireless/mediatek/mt76/mt76x0/core.c   |   34 +
>  .../net/wireless/mediatek/mt76/mt76x0/debugfs.c    |  166 ++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/dma.c    |  522 ++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/dma.h    |  126 +++
>  drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  445 +++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |  149 +++
>  drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  720 ++++++++++++++
>  .../net/wireless/mediatek/mt76/mt76x0/initvals.h   |  282 ++++++
>  .../wireless/mediatek/mt76/mt76x0/initvals_phy.h   |  772 +++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    |  661 +++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |  154 +++
>  drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c    |  650 +++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h    |  101 ++
>  drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  376 ++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 1007 ++++++++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/phy.h    |   81 ++
>  drivers/net/wireless/mediatek/mt76/mt76x0/regs.h   |  651 +++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/trace.c  |   21 +
>  drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  |  366 +++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  270 ++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  377 ++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/usb.h    |   61 ++
>  drivers/net/wireless/mediatek/mt76/mt76x0/util.c   |   42 +
>  27 files changed, 8053 insertions(+)
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/core.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/init.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/phy.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/util.c
> 
> -- 
> 1.9.3
> 
