Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:38716 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXLLGhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 01:37:04 -0500
Received: by an-out-0708.google.com with SMTP id d31so30436and.103
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2007 22:37:02 -0800 (PST)
Message-ID: <40f31dec0712112237rc9f7c06g9c1c5f46943e1d0@mail.gmail.com> (sfid-20071212_063707_761768_F77C5DF9)
Date: Wed, 12 Dec 2007 08:37:01 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Joachim Frieben" <jfrieben@hotmail.com>
Subject: Re: Misleading PCI id information on chipsets supported by ath5k
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAY134-W251B269AE3F727106D931FD4640@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <BAY134-W251B269AE3F727106D931FD4640@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/12/11, Joachim Frieben <jfrieben@hotmail.com>:
>
> There is some misleading information on the chipsets supported by the ath5k driver at
>
>   http://www.linuxwireless.org/en/users/Drivers/ath5k#supportedchips .
>
> In particular, the following entry is incorrect:
>
> Vendor:device   Type       Basic-testing
> 168c:0013      AR5212   OK
>

This is indeed true however 5212 chip has gone through some revisions
and we haven't checked all of them.

> I have a D-Link DWL-G520 Rev. B4 card, and its [chipset's] PCI id is exactly the one indicated above. However, it's based upon an AR5212 802.11 (b/g) chipset, and ath_info reports:
>
>    -==Device Information==-
>   MAC Version:  5213A (0x70)
>   MAC Revision: 5213A (0x79)
>   PHY Revision: 2112a (0x56)
>    -==EEPROM Information==-
>   EEPROM Version:     5.1
>   EEPROM Size:        16K
>   Regulatory Domain:  0x30
>    -==== Capabilities ====-
>   |  802.11a Support: no   |
>   |  802.11b Support: yes  |
>   |  802.11g Support: yes  |
>   |  RFKill  Support: no   |
>   |  32KHz   Crystal: no   |
>    ========================
>   GPIO registers: CR 00000000 DO 00000000 DI 00000010
>
> which is consistent with the information given on the retail box stating that it is a (b/g) device. Thus, 802.11a is not supported, and according to the next section on the support page called "Notes on supported devices", the whole card is not supported by ath5k because
>
> "Please note that 001c is an 802.11bg device. As you can see from above the current driver design is for 802.11a, 802.11ab, or 802.11abg. We'll probably need a new device type in the driver for this device to pass only bg initial register writes and baseband gain settings."
>

This is indeed misleading info, we had reports of bg only devices
working fine with the driver, I got one myself recently thanx to John
and it didn't have any problem. Perhaps you have an old copy of the
driver (it had a bug that is now fixed). Also plz someone remove this
info from the wiki (or give me access to update it), i only said that
it's possible that b/g only phys have a different access method (and i
was wrong).

> Strange enough, 001c is cited as an [unsupported] (b/g) device whereas 0013 should be an (a/b/g) device which is apparently wrong. So, either the PCI id is not an appropriate way to label whether a device is supported or not, or the support page is wrong. Needless to say that the DWL-G520 does not work with ath5k. Right now, it does not even scan access points at all. Could some authorized person have a look into this and make the necessary corrections on the web page?
>

Well yes pci id is not the appropriate way since it doesn't say
anything about the chip's revision, that's why we made ath_info. Also
some vendors are known to use false pci ids.

I'll commit some patches soon and i hope it'll make things better ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
