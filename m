Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33547 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2B1PLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 10:11:40 -0500
Received: by vbbff1 with SMTP id ff1so1910202vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2012 07:11:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330441305.3368.12.camel@jlt3.sipsolutions.net>
References: <CAD2nsn1_DzbRHuSbS_1rFNzuux_9pW1-pABEasQ01_y7-ndO5w@mail.gmail.com>
	<1330441305.3368.12.camel@jlt3.sipsolutions.net>
Date: Tue, 28 Feb 2012 20:41:40 +0530
Message-ID: <CAD2nsn0p=owQVumNVhxfPgtxyj7M6o5OkRcEYKhn8sQzQBCi+g@mail.gmail.com> (sfid-20120228_161144_995329_A423406F)
Subject: Re: WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
 iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> got this following warning  for the following card, it was my inbuilt
>> card it was just associated with an AP, wireless-testing 3.3.0-rc4-wl
>>
>> 03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN
>> [Shiloh] Network Connection
>>         Subsystem: Intel Corporation Device 1211
>
>> [11056.342672] WARNING: at
>> drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
>> iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
>> [11056.342681] Hardware name: 64756D6
>> [11056.342687] reclaim is false, SEQ_RX_FRAME unset: STATISTICS_NOTIFICATION
>
> Thanks for the report. The warning is harmless, but we were hoping this
> code was only to handle 4965 (this code comes from pre-driver-split
> days). As we weren't sure, we put in the warning. Since you ran into it,
> evidently this does in fact happen on later devices; it will complicate
> our life a bit but we'll handle it.

oh ok,  also i am just using the default firmware thats in my system
[36762.942612] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1
build 33692

[36762.886932] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[36762.886935] Copyright(c) 2003-2012 Intel Corporation
[36762.887170] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[36762.887173] iwlwifi 0000:03:00.0: pci_resource_base = f8190000
[36762.887176] iwlwifi 0000:03:00.0: HW Revision ID = 0x0
[36762.887353] iwlwifi 0000:03:00.0: irq 48 for MSI/MSI-X
[36762.887691] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
[36762.887694] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[36762.887696] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[36762.887698] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[36762.887700] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[36762.887704] iwlwifi 0000:03:00.0: Detected Intel(R) WiFi Link 5100
AGN, REV=0x54
[36762.888228] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[36762.907566] iwlwifi 0000:03:00.0: device EEPROM VER=0x11e, CALIB=0x4
[36762.907569] iwlwifi 0000:03:00.0: Device SKU: 0xF0
[36762.907829] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[36762.942612] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1
build 33692
[36762.943763] Registered led device: phy5-led

>
> For you, there's nothing to worry about, the driver handles this
> situation just fine. :-)


ok , thank you!


-- 
thanks,
shafi
