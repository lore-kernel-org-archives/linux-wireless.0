Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61057 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab1HWNQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 09:16:53 -0400
Received: by ywf7 with SMTP id 7so66812ywf.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 06:16:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108231009.35292.florian@openwrt.org>
References: <1314058119-3441-1-git-send-email-lrodriguez@qca.qualcomm.com>
 <1314058119-3441-3-git-send-email-lrodriguez@qca.qualcomm.com>
 <201108231007.44737.florian@openwrt.org> <201108231009.35292.florian@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Tue, 23 Aug 2011 06:16:32 -0700
Message-ID: <CAB=NE6X4GyqubQB84T==apyUVYP1JYn3g36Qa4_=CsmjJXsLZw@mail.gmail.com> (sfid-20110823_151656_752249_0C11BC39)
Subject: Re: [RFT v2 2/2] ath9k: add AR9580 support
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2011 at 1:09 AM, Florian Fainelli <florian@openwrt.org> wrote:
> On Tuesday 23 August 2011 10:07:44 Florian Fainelli wrote:
>> Hello Luis,
>>
>> On Tuesday 23 August 2011 02:08:39 Luis R. Rodriguez wrote:
>> > From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
>> >
>> > Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
>> > ---
>> >
>> >  drivers/net/wireless/ath/ath9k/pci.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath9k/pci.c
>> > b/drivers/net/wireless/ath/ath9k/pci.c index daa26b5..6cb90ee 100644
>> > --- a/drivers/net/wireless/ath/ath9k/pci.c
>> > +++ b/drivers/net/wireless/ath/ath9k/pci.c
>> > @@ -32,6 +32,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
>> >
>> >     { PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
>> >     { PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
>> >     { PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
>> >
>> > +   { PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
>> >
>> >     { 0 }
>> >
>> >  };
>>
>> You also need this change in hw.{c,h} for ath9k not to bail out with "ath:
>> Hardware device ID 0x0033 not supported":
>>
>> Index: compat-wireless-2011-08-10/drivers/net/wireless/ath/ath9k/hw.c
>> ===================================================================
>> --- compat-wireless-2011-08-10.orig/drivers/net/wireless/ath/ath9k/hw.c
>> 2011-08-23 10:01:30.804054398 +0200
>> +++ compat-wireless-2011-08-10/drivers/net/wireless/ath/ath9k/hw.c
>> 2011-08-23 10:01:46.314054408 +0200
>> @@ -672,6 +672,7 @@
>>         case AR9300_DEVID_AR9485_PCIE:
>>         case AR9300_DEVID_AR9330:
>>         case AR9300_DEVID_AR9340:
>> +       case AR9300_DEVID_AR9580:
>>                 break;
>>         default:
>>                 if (common->bus_ops->ath_bus_type == ATH_USB)
>> Index: compat-wireless-2011-08-10/drivers/net/wireless/ath/ath9k/hw.h
>> ===================================================================
>> --- compat-wireless-2011-08-10.orig/drivers/net/wireless/ath/ath9k/hw.h
>> 2011-08-23 10:01:32.504054400 +0200
>> +++ compat-wireless-2011-08-10/drivers/net/wireless/ath/ath9k/hw.h
>> 2011-08-23 10:01:59.124054416 +0200
>> @@ -45,6 +45,7 @@
>>  #define AR9300_DEVID_PCIE      0x0030
>>  #define AR9300_DEVID_AR9340    0x0031
>>  #define AR9300_DEVID_AR9485_PCIE 0x0032
>> +#define AR9300_DEVID_AR9580    0x0033
>>  #define AR9300_DEVID_AR9330    0x0035
>>
>>  #define AR5416_AR9100_DEVID    0x000b
>>
>> With the above two patches applied, I get the following:
>>
>> iw dev wlan0 scan
>> command failed: Device or resource busy (-16)
>
> I had wpa_supplicant running in background, scan does no longer report Device
> or resource busy now.

You do get scan results now?

>> iw phy0 info shows the 5GHz band has being listed
>>
>> iw dev wlan0 survey dump seems to correctly list the activity on the 5Ghz
>> channels (it's updated from one call to another)
>>
>> if I start the interface in AP mode, my laptop does not see it's beacon, I
>> have not had a chance yet to use a monitor interface.
>
> I will test later the opposite, where my laptop is in AP mode, and try to get
> this AR9580 device in STA mode.

OK thanks.

  Luis
