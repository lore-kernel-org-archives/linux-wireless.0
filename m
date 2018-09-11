Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa08-07.prod.phx3.secureserver.net ([173.201.193.108]:34096
        "EHLO p3plsmtpa08-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbeIKRzI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 13:55:08 -0400
To: linux-wireless@vger.kernel.org
From: "Peter A. Bigot" <pab@pabigot.com>
Subject: linux-firmware: updating Cypress firmware for Raspberry Pi hardware?
Message-ID: <e413bd24-f11a-ada1-d032-c370b3f994e9@pabigot.com> (sfid-20180911_145559_460863_3E596940)
Date: Tue, 11 Sep 2018 07:48:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How can I help get updated material from Cypress/Broadcom for Bluetooth
and WiFi firmware into linux-firmware?

The Raspberry Pi folks maintain two repositories[1,2] for firmware
required for their hardware under Raspbian.  Their repos have some
firmware not in linux-firmware, and some firmware that is newer than
linux-firmware.

I need to have this hardware work on Raspberry Pi under Yocto [3].  To
do that I currently have to build a linux-firmware package that pulls
from three different locations.  Tracking licenses also becomes an issue
because the in-repo Raspbian license is not up to date with the recent
change to LICENCE.Cypress.

I would really like to be able to use only one source.  If there's some
reason linux-firmware doesn't carry Bluetooth pieces, I can cope with
that.

I don't feel the provenance of what's in RPi-Distro is clear enough to
take its content and make a pull-request for linux-firmware myself.

The pieces needed include:

 From firmware-nonfree [1]:
   brcmfmac43430-sdio.bin  (matches recent update in linux-firmware)
   brcmfmac43430-sdio.txt  (as brcmfmac43430-sdio.RPi.txt ?)
   brcmfmac43455-sdio.bin  (newer than 2015 version in linux-firmware)
   brcmfmac43455-sdio.clm_blob  (as ...?)
   brcmfmac43455-sdio.txt  (as brcmfmac43455-sdio.RPi.txt ?)

 From bluez-firmware [2]:
   BCM43430A1.hcd
   BCM4345C0.hcd

Could somebody help me make this happen?

Thanks.

Peter

[1]: https://github.com/RPi-Distro/firmware-nonfree forked from 
linux-firmware long ago
[2]: https://github.com/RPi-Distro/bluez-firmware
[3]: https://github.com/agherzan/meta-raspberrypi/issues/298
