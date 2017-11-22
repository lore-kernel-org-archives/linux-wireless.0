Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:45213 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdKVK6V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 05:58:21 -0500
Received: by mail-qt0-f182.google.com with SMTP id r37so15127035qtj.12
        for <linux-wireless@vger.kernel.org>; Wed, 22 Nov 2017 02:58:21 -0800 (PST)
Subject: Re: AP6335 with mainline kernel
To: Vanessa Maegima <vanessa.maegima@nxp.com>,
        "van.ayumi@gmail.com" <van.ayumi@gmail.com>
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com>
 <1510916848.26896.2.camel@nxp.com> <5A0EDC25.7030505@broadcom.com>
 <1510932224.22506.0.camel@nxp.com>
 <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com>
 <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
 <1511347672.18886.2.camel@nxp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "embed3d@gmail.com" <embed3d@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A15584A.9090601@broadcom.com> (sfid-20171122_115825_381105_6088A180)
Date: Wed, 22 Nov 2017 11:58:18 +0100
MIME-Version: 1.0
In-Reply-To: <1511347672.18886.2.camel@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2017 11:48 AM, Vanessa Maegima wrote:
> Hi Arend,
>
> On Seg, 2017-11-20 at 12:12 +0100, Arend van Spriel wrote:
>> On 20-11-17 12:03, Arend van Spriel wrote:
>>>
>>> On 17-11-17 16:24, Vanessa Maegima wrote:
>>>>
>>>> Hi Arend,
>>>>
>>>> On Sex, 2017-11-17 at 13:55 +0100, Arend van Spriel wrote:
>>>>>
>>>>> On 11/17/2017 12:08 PM, Vanessa Maegima wrote:
>>>>>>
>>>>>>
>>>>>> Hi Arend,
>>>>>>
>>>>>> On Sex, 2017-11-10 at 20:58 +0100, Arend van Spriel wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 10-11-17 13:43, Vanessa Maegima wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On Qui, 2017-09-21 at 12:30 -0300, Vanessa Ayumi Maegima
>>>>>>>> wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hi Arend,
>>>>>>>>>
>>>>>>>>> On Thu, Sep 21, 2017 at 4:26 AM, Arend van Spriel
>>>>>>>>> <arend.vanspriel@broadcom.com> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 20-09-17 21:33, Vanessa Ayumi Maegima wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>> I am trying to enable Wifi on imx7d-pico using
>>>>>>>>>>> mainline
>>>>>>>>>>> kernel.
>>>>>>>>>>> imx7d-pico
>>>>>>>>>>> has an AP6335 chip.
>>>>>>>>>>>
>>>>>>>>>>> I am facing some issues related to the nvram file.
>>>>>>>>>>> I am
>>>>>>>>>>> using
>>>>>>>>>>> the
>>>>>>>>>>> firmware
>>>>>>>>>>> provided by Buildroot (brcmfmac4339-sdio.bin). I
>>>>>>>>>>> get the
>>>>>>>>>>> following error:
>>>>>>>>>>>
>>>>>>>>>>> [    8.630380] brcmfmac: brcmf_sdio_htclk: HT Avail
>>>>>>>>>>> timeout
>>>>>>>>>>> (1000000):
>>>>>>>>>>> clkctl 0x50
>>>>>>>>>>>
>>>>>>>>>>> I have tried to use the firmware and nvram provided
>>>>>>>>>>> by
>>>>>>>>>>> TechNexion
>>>>>>>>>>> but I
>>>>>>>>>>> get
>>>>>>>>>>> the same error.
>>>>>>>>>>>
>>>>>>>>>>> Is there anyone that could enable Wifi on AP6335
>>>>>>>>>>> using
>>>>>>>>>>> kernel
>>>>>>>>>>> mainline?
>>>>>>>>>>> What nvram file was used?
>>>>>>>>>>>
>>>>>>>>>>> I am able to use Wifi on the board if I use the
>>>>>>>>>>> firmware,
>>>>>>>>>>> nvram
>>>>>>>>>>> file and
>>>>>>>>>>> kernel
>>>>>>>>>>> provided by TechNexion. They use a 4.1 kernel from
>>>>>>>>>>> NXP
>>>>>>>>>>> with
>>>>>>>>>>> the
>>>>>>>>>>> bcmdhd
>>>>>>>>>>> driver.
>>>>>>>>>>>
>>>>>>>>>>> So I know that the hardware is functional.
>>>>>>>>>>>
>>>>>>>>>>> Any suggestions as how to get it working with a
>>>>>>>>>>> 4.13 and
>>>>>>>>>>> brcmfmac
>>>>>>>>>>> driver
>>>>>>>>>>> is
>>>>>>>>>>> appreciated.
>>>>>>>>>> So the nvram file is specific to the wifi chipset on
>>>>>>>>>> your
>>>>>>>>>> platform
>>>>>>>>>> so best
>>>>>>>>>> to stick with the provided one. The "HT Avail
>>>>>>>>>> timeout" most
>>>>>>>>>> often
>>>>>>>>>> is an
>>>>>>>>>> indication that the firmware crashed. So getting more
>>>>>>>>>> debug
>>>>>>>>>> output
>>>>>>>>>> would
>>>>>>>>>> help us understand how it ended up like that. Can you
>>>>>>>>>> build
>>>>>>>>>> the
>>>>>>>>>> brcmfmac
>>>>>>>>>> with CONFIG_BRCMDBG and load the driver using:
>>>>>>>>>>
>>>>>>>>>> $ insmod brcmfmac.ko debug=0x1416
>>>>>>>>> Thanks for the reply!
>>>>>>>>>
>>>>>>>>> Here is the log (using 4.14-rc1):
>>>>>>>>>
>>>>>>>>> # dmesg | grep brcmfmac
>>>>>>>>> [   19.297206] brcmfmac: brcmfmac_module_init No
>>>>>>>>> platform
>>>>>>>>> data
>>>>>>>>> available.
>>>>>>>>> [   19.307075] brcmfmac: brcmf_sdio_probe Enter
>>>>>>>>> [   19.308384] brcmfmac: F1 signature read
>>>>>>>>> @0x18000000=0x16224335
>>>>>>>>> [   19.309026] brcmfmac: brcmf_chip_recognition found
>>>>>>>>> AXI
>>>>>>>>> chip:
>>>>>>>>> BCM4339, rev=2
>>>>>>>>> [   19.317115] brcmfmac: brcmf_chip_cores_check  [1 ]
>>>>>>>>> core
>>>>>>>>> 0x800:46
>>>>>>>>> base 0x18000000 wrap 0x18100000
>>>>>>>>> [   19.317141] brcmfmac: brcmf_chip_cores_check  [2 ]
>>>>>>>>> core
>>>>>>>>> 0x812:46
>>>>>>>>> base 0x18001000 wrap 0x18101000
>>>>>>>>> [   19.317165] brcmfmac: brcmf_chip_cores_check  [3 ]
>>>>>>>>> core
>>>>>>>>> 0x83e:4
>>>>>>>>> base 0x18002000 wrap 0x18102000
>>>>>>>>> [   19.317188] brcmfmac: brcmf_chip_cores_check  [4 ]
>>>>>>>>> core
>>>>>>>>> 0x83c:4
>>>>>>>>> base 0x18003000 wrap 0x18103000
>>>>>>>>> [   19.317210] brcmfmac: brcmf_chip_cores_check  [5 ]
>>>>>>>>> core
>>>>>>>>> 0x81a:20
>>>>>>>>> base 0x18004000 wrap 0x18104000
>>>>>>>>> [   19.317233] brcmfmac: brcmf_chip_cores_check  [6 ]
>>>>>>>>> core
>>>>>>>>> 0x829:21
>>>>>>>>> base 0x18005000 wrap 0x18105000
>>>>>>>>> [   19.317256] brcmfmac: brcmf_chip_cores_check  [7 ]
>>>>>>>>> core
>>>>>>>>> 0x135:0
>>>>>>>>> base 0x00000000 wrap 0x18109000
>>>>>>>>> [   19.317279] brcmfmac: brcmf_chip_cores_check  [8 ]
>>>>>>>>> core
>>>>>>>>> 0x240:0
>>>>>>>>> base 0x00000000 wrap 0x00000000
>>>>>>>>> [   19.317298] brcmfmac: brcmf_chip_set_passive Enter
>>>>>>>>> [   19.322232] brcmfmac: brcmf_chip_get_raminfo RAM:
>>>>>>>>> base=0x180000
>>>>>>>>> size=786432 (0xc0000) sr=0 (0x0)
>>>>>>>>> [   19.322457] brcmfmac: brcmf_chip_setup ccrev=46,
>>>>>>>>> pmurev=23,
>>>>>>>>> pmucaps=0x39cc5f17
>>>>>>>>> [   19.322481] brcmfmac: brcmf_get_module_param Enter,
>>>>>>>>> bus=0,
>>>>>>>>> chip=17209, rev=2
>>>>>>>>> [   19.322504] brcmfmac: brcmf_sdiod_sgtable_alloc
>>>>>>>>> nents=35
>>>>>>>>> [   19.322531] brcmfmac: brcmf_sdio_kso_init Enter
>>>>>>>>> [   19.322618] brcmfmac: brcmf_sdio_drivestrengthinit
>>>>>>>>> No SDIO
>>>>>>>>> driver
>>>>>>>>> strength init needed for chip 43
>>>>>>>>> 39 rev 2 pmurev 23
>>>>>>>>> [   19.323235] brcmfmac: brcmf_attach Enter
>>>>>>>>> [   19.323725] brcmfmac: brcmf_proto_attach Enter
>>>>>>>>> [   19.323769] brcmfmac: brcmf_fweh_register event
>>>>>>>>> handler
>>>>>>>>> registered
>>>>>>>>> for PSM_WATCHDOG
>>>>>>>>> [   19.324306] brcmfmac: brcmf_sdio_probe completed!!
>>>>>>>>> [   19.324337] brcmfmac: brcmf_fw_map_chip_to_name:
>>>>>>>>> using
>>>>>>>>> brcm/brcmfmac4339-sdio.bin for chip 0x00433
>>>>>>>>> 9(17209) rev 0x000002
>>>>>>>>> [   19.335353] brcmfmac: brcmf_fw_get_firmwares_pcie
>>>>>>>>> enter:
>>>>>>>>> dev=mmc0:0001:1
>>>>>>>>> [   19.351787] brcmfmac: brcmf_fw_request_code_done
>>>>>>>>> enter:
>>>>>>>>> dev=mmc0:0001:1
>>>>>>>>> [   19.353202] brcmfmac: brcmf_fw_request_nvram_done
>>>>>>>>> enter:
>>>>>>>>> dev=mmc0:0001:1
>>>>>>>>> [   19.353424] brcmfmac: brcmf_sdio_firmware_callback
>>>>>>>>> Enter:
>>>>>>>>> dev=mmc0:0001:1, err=0
>>>>>>>>> [   19.353814] brcmfmac: brcmf_sdio_download_code_file
>>>>>>>>> Enter
>>>>>>>>> [   19.388586] brcmfmac: brcmf_sdio_verifymemory
>>>>>>>>> Compare RAM
>>>>>>>>> dl &
>>>>>>>>> ul
>>>>>>>>> at 0x00180000; size=493599
>>>>>>>>> [   19.546675] brcmfmac: brcmf_sdio_download_nvram
>>>>>>>>> Enter
>>>>>>>>> [   19.547432] brcmfmac: brcmf_sdio_verifymemory
>>>>>>>>> Compare RAM
>>>>>>>>> dl &
>>>>>>>>> ul
>>>>>>>>> at 0x0023f730; size=2256
>>>>>>>>> [   19.548665] brcmfmac: brcmf_chip_set_active Enter
>>>>>>>>> [   20.562974] brcmfmac: brcmf_sdio_htclk: HT Avail
>>>>>>>>> timeout
>>>>>>>>> (1000000):
>>>>>>>>> clkctl 0x50
>>>>>>>>> [   20.570490] brcmfmac: brcmf_sdio_firmware_callback
>>>>>>>>> failed:
>>>>>>>>> dev=mmc0:0001:1, err=0
>>>>>>>>> [   20.570739] brcmfmac: brcmf_sdio_remove Enter
>>>>>>>>> [   20.570775] brcmfmac: brcmf_detach Enter
>>>>>>>>> [   20.610414] brcmfmac: brcmf_bus_change_state 0 -> 0
>>>>>>>>> [   20.610441] brcmfmac: brcmf_sdio_bus_stop Enter
>>>>>>>>> [   21.622477] brcmfmac: brcmf_sdio_htclk: HT Avail
>>>>>>>>> timeout
>>>>>>>>> (1000000):
>>>>>>>>> clkctl 0x50
>>>>>>>>> [   21.630912] brcmfmac: brcmf_proto_detach Enter
>>>>>>>>> [   21.630967] brcmfmac: brcmf_fweh_unregister event
>>>>>>>>> handler
>>>>>>>>> cleared
>>>>>>>>> for PSM_WATCHDOG
>>>>>>>>> [   22.642457] brcmfmac: brcmf_sdio_htclk: HT Avail
>>>>>>>>> timeout
>>>>>>>>> (1000000):
>>>>>>>>> clkctl 0x50
>>>>>>>>> [   22.680131] brcmfmac: brcmf_chip_set_passive Enter
>>>>>>>>> [   22.682580] brcmfmac: brcmf_sdio_remove Disconnected
>>>>>>>>>
>>>>>>>> Any suggestions on this?
>>>>>>> Sorry for not getting back to your earlier email. Thanks
>>>>>>> for the
>>>>>>> reminder. So you tried different firmwares, right? Can you
>>>>>>> provide
>>>>>>> output of the following command:
>>>>>>>
>>>>>>> $ strings firmware.bin | tail -1
>>>>>>>
>>>>>>> for the firmwares you tried.
>>>>>>>
>>>>>>> Regards,
>>>>>>> Arend
>>>>>> Thanks for the reply!
>>>>>>
>>>>>> Here's the output:
>>>>>>
>>>>>> For Technexion firmware:
>>>>>>
>>>>>> # strings /lib/firmware/brcm/brcmfmac4339-sdio.bin | tail -1
>>>>>> 4339a0-roml/sdio-ag-pool-p2p-pno-pktfilter-keepalive-aoe-sr-
>>>>>> mchan-
>>>>>> proptxstatus-lpc-tdls-autoabn-txbf-
>>>>>> rcc-wepso-okc-ndoe Version: 6.37.32.28 CRC: 3075f12e Date:
>>>>>> Thu
>>>>>> 2014-04-
>>>>>> 03 12:15:31 CST FWID 01-4ae4ad
>>>>>> 03
>>>>>>
>>>>>> For linux-firmware and Buildroot firmware:
>>>>>>
>>>>>> # strings /lib/firmware/brcm/brcmfmac4339-sdio.bin | tail -1
>>>>>> 4339a0-roml/sdio-ag-pool-autoabn-lpc Version: 6.37.34.28 CRC:
>>>>>> a696897b
>>>>>> Date: Thu 2014-08-28 18:40:12
>>>>>> PDT FWID 01-a13120fc
>>>>>>
>>>>>> In both cases, I am using the nvram provided by Technexion.
>>>>> That should be fine.
>>>>>
>>>>> Can you try the patch below. It would give me more info on
>>>>> state of
>>>>> firmware.
>>>>>
>>>>> Regards,
>>>>> Arend
>>>>>
>>>>> diff --git
>>>>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> b/drivers/ne
>>>>> index f355612..631c5cb 100644
>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> @@ -828,8 +828,27 @@ static int brcmf_sdio_htclk(struct
>>>>> brcmf_sdio
>>>>> *bus,
>>>>> bool on,
>>>>>                            return -EBADE;
>>>>>                    }
>>>>>                    if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
>>>>> +                       struct brcmf_core *pmu =
>>>>> brcmf_chip_get_pmu(bus->ci);
>>>>> +                       u32 regaddr;
>>>>> +                       u32 val;
>>>>> +
>>>>>                            brcmf_err("HT Avail timeout (%d):
>>>>> clkctl
>>>>> 0x%02x\n",
>>>>>                                      PMU_MAX_TRANSITION_DLY,
>>>>> clkctl);
>>>>> +
>>>>> +                       /* DEBUG INFO */
>>>>> +                       regaddr = CORE_CC_REG(pmu->base,
>>>>> pmucontrol);
>>>>> +                       val = brcmf_sdiod_regrl(bus->sdiodev,
>>>>> regaddr,
>>>>> &err);
>>>>> +                       brcmf_err("  pmucontrol   = %08x\n",
>>>>> val);
>>>>> +                       regaddr = CORE_CC_REG(pmu->base,
>>>>> pmustatus);
>>>>> +                       val = brcmf_sdiod_regrl(bus->sdiodev,
>>>>> regaddr,
>>>>> &err);
>>>>> +                       brcmf_err("  pmustatus    = %08x\n",
>>>>> val);
>>>>> +                       regaddr = CORE_CC_REG(pmu->base,
>>>>> min_res_mask);
>>>>> +                       val = brcmf_sdiod_regrl(bus->sdiodev,
>>>>> regaddr,
>>>>> &err);
>>>>> +                       brcmf_err("  min_res_mask = %08x\n",
>>>>> val);
>>>>> +                       regaddr = CORE_CC_REG(pmu->base,
>>>>> max_res_mask);
>>>>> +                       val = brcmf_sdiod_regrl(bus->sdiodev,
>>>>> regaddr,
>>>>> &err);
>>>>> +                       brcmf_err("  max_res_mask = %08x\n",
>>>>> val);
>>>>> +
>>>>>                            return -EBADE;
>>>>>                    }
>>>>>
>>>>>
>>>> Here's the output for both firmwares:
>>>>
>>>> Technexion:
>>>> # dmesg | grep brcmfmac
>>>> [    5.307067] brcmfmac: brcmf_fw_map_chip_to_name: using
>>>> brcm/brcmfmac4339-sdio.bin for chip 0x00433
>>>> 9(17209) rev 0x000002
>>>> [    6.400792] brcmfmac: brcmf_sdio_htclk: HT Avail timeout
>>>> (1000000):
>>>> clkctl 0x50
>>>> [    6.408444] brcmfmac: brcmf_sdio_htclk:   pmucontrol   =
>>>> 01774381
>>>> [    6.415595] brcmfmac: brcmf_sdio_htclk:   pmustatus    =
>>>> 0000002a
>>>> [    6.421915] brcmfmac: brcmf_sdio_htclk:   min_res_mask =
>>>> 0fcaff77
>>>> [    6.428124] brcmfmac: brcmf_sdio_htclk:   max_res_mask =
>>>> 0fceff77
>>>> [    7.482668] brcmfmac: brcmf_sdio_htclk: HT Avail timeout
>>>> (1000000):
>>>> clkctl 0x50
>>>> [    7.490214] brcmfmac: brcmf_sdio_htclk:   pmucontrol   =
>>>> 01774381
>>>> [    7.496414] brcmfmac: brcmf_sdio_htclk:   pmustatus    =
>>>> 0000002a
>>>> [    7.503873] brcmfmac: brcmf_sdio_htclk:   min_res_mask =
>>>> 0fcaff77
>>>> [    7.510182] brcmfmac: brcmf_sdio_htclk:   max_res_mask =
>>>> 0fceff77
>>>> #  strings /lib/firmware/brcm/brcmfmac4339-sdio.bin | tail -1
>>>> 4339a0-roml/sdio-ag-pool-p2p-pno-pktfilter-keepalive-aoe-sr-
>>>> mchan-
>>>> proptxstatus-lpc-tdls-autoabn-txbf-
>>>> rcc-wepso-okc-ndoe Version: 6.37.32.28 CRC: 3075f12e Date: Thu
>>>> 2014-04-
>>>> 03 12:15:31 CST FWID 01-4ae4ad
>>>> 03
>>>>
>>>> Buildroot:
>>>> # dmesg | grep brcmfmac
>>>> [    5.343118] brcmfmac: brcmf_fw_map_chip_to_name: using
>>>> brcm/brcmfmac4339-sdio.bin for chip 0x00433
>>>> 9(17209) rev 0x000002
>>>> [    6.420070] brcmfmac: brcmf_sdio_htclk: HT Avail timeout
>>>> (1000000):
>>>> clkctl 0x50
>>>> [    6.427722] brcmfmac: brcmf_sdio_htclk:   pmucontrol   =
>>>> 01774381
>>>> [    6.434865] brcmfmac: brcmf_sdio_htclk:   pmustatus    =
>>>> 0000002a
>>>> [    6.441174] brcmfmac: brcmf_sdio_htclk:   min_res_mask =
>>>> 0fcaff77
>>>> [    6.447379] brcmfmac: brcmf_sdio_htclk:   max_res_mask =
>>>> 0fceff77
>>>> [    7.502653] brcmfmac: brcmf_sdio_htclk: HT Avail timeout
>>>> (1000000):
>>>> clkctl 0x50
>>>> [    7.510200] brcmfmac: brcmf_sdio_htclk:   pmucontrol   =
>>>> 01774381
>>>> [    7.516398] brcmfmac: brcmf_sdio_htclk:   pmustatus    =
>>>> 0000002a
>>>> [    7.523826] brcmfmac: brcmf_sdio_htclk:   min_res_mask =
>>>> 0fcaff77
>>>> [    7.530117] brcmfmac: brcmf_sdio_htclk:   max_res_mask =
>>>> 0fceff77
>>>> # strings /lib/firmware/brcm/brcmfmac4339-sdio.bin | tail -1
>>>> 4339a0-roml/sdio-ag-pool-autoabn-lpc Version: 6.37.34.28 CRC:
>>>> a696897b
>>>> Date: Thu 2014-08-28 18:40:12
>>>> PDT FWID 01-a13120fc
>>> Thanks for the info. The pmustatus indeed shows there is no HT
>>> clock for
>>> the backplane. Will have to discuss with h/w guys. Meanwhile, can
>>> you
>>> try the patch below. It will create a memory dump of the device
>>> using
>>> the dev_coredump framework, ie. under /sys/class/devcoredump/. It
>>> will
>>> probably create two dumps as the error occurs twice during probe.
>>> Just
>>> sent me the first or put it somewhere on internet so I can download
>>> it
>>> and have a look at it.
>> with patch :-(
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> b/drivers/ne
>> index f355612..f7ded91 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -830,6 +830,11 @@ static int brcmf_sdio_htclk(struct brcmf_sdio
>> *bus,
>> bool on,
>>                   if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
>>                           brcmf_err("HT Avail timeout (%d): clkctl
>> 0x%02x\n",
>>                                     PMU_MAX_TRANSITION_DLY, clkctl);
>> +
>> +                       /* DEBUG INFO */
>> +                       brcmf_debug_create_memdump(bus->sdiodev-
>>> bus_if,
>> +                                                  NULL, 0);
>> +
>>                           return -EBADE;
>>                   }
>>
>>
>
> I am applying this patch and apparently the dumps are not created.
>
> # ls /sys/class/devcoredump/
> disabled
>
> Is there something else I need to modify? I am using mainline kernel.

You need to build brcmfmac with CONFIG_BRCMDBG set in Kconfig. Not sure 
if you already have that. I assume a cat of that 'disabled' file with 
show '0'.

Regards,
Arend
