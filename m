Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:46936 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeAPUSD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 15:18:03 -0500
Received: by mail-wm0-f48.google.com with SMTP id 143so10782956wma.5
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jan 2018 12:18:02 -0800 (PST)
Subject: Re: brcmfmac4329-sdio firmware load failed.
To: Kyle Evans <kvans32@gmail.com>
References: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com>
 <5A55D325.60805@broadcom.com>
 <3842a299-cd14-65db-1222-6849bc95ef74@gmail.com>
 <5A59CF17.6040706@broadcom.com>
 <20180116012011.GA22945@localhost.localdomain>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5E5DF8.9090307@broadcom.com> (sfid-20180116_211828_126793_56E7B38D)
Date: Tue, 16 Jan 2018 21:18:00 +0100
MIME-Version: 1.0
In-Reply-To: <20180116012011.GA22945@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/16/2018 2:20 AM, Kyle Evans wrote:
> On Sat, Jan 13, 2018 at 10:19:19AM +0100, Arend van Spriel wrote:
>> On 1/12/2018 9:18 PM, Kyle Evans wrote:
>>> Thank you Arend. I updated to master again, v4.15-rc7+, and applied your
>>> patch. All log snips are grabbed with dmesg|grep -E 'mmc0|brcm', as the
>>> sdio device is on mmc0.
>>
>> Could you follow the reply convention of not top-posting.
>>
>>> Without patch [1], for reference...
>>>
>>> [    0.000000] Kernel command line: console=tty0 selinux=0
>>> video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
>>
>> You made a type in the kernel command line, ie. "bebug" should be
>> "debug". Anyway, that is not that important for now.
>>
>>> [    3.952561] mmc0: Invalid maximum block size, assuming 512 bytes
>>> [    4.010466] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci]
>>> using ADMA
>>> [    4.338545] mmc0: queuing unknown CIS tuple 0x80 (50 bytes)
>>> [    4.347098] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
>>> [    4.350099] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
>>> [    4.378430] mmc0: queuing unknown CIS tuple 0x02 (1 bytes)
>>> [    4.388387] mmc0: new SDIO card at address 0001
>>> [    4.401773] brcmfmac: F1 signature read @0x18000000=0x9934329
>>> [    4.407624] brcmfmac: brcmf_sdiod_regrw_helper: failed to read data
>>> F1@0x080ac, err: -84
>>> [    4.410159] brcmfmac: brcmf_fw_map_chip_to_name: using
>>> brcm/brcmfmac4329-sdio.bin for chip 0x004329(17193) rev 0x000003
>>> [    4.781374] brcmfmac mmc0:0001:1: Direct firmware load for
>>> brcm/brcmfmac4329-sdio.clm_blob failed with error -2
>>> [    4.781491] brcmfmac mmc0:0001:1: Falling back to user helper
>>> [   69.601645] brcmfmac: brcmf_c_process_clm_blob: request CLM blob file
>>> failed (-11)
>>> [   69.601668] brcmfmac: brcmf_c_preinit_dcmds: download CLM blob file
>>> failed, -11
>>> [   69.601685] brcmfmac: brcmf_bus_started: failed: -11
>>> [   69.601728] brcmfmac: brcmf_sdio_firmware_callback: dongle is not
>>> responding
>>>
>>>
>>> With patch [1]...
>>>
>>> [    0.000000] Kernel command line: console=tty0 selinux=0
>>> video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
>>> [    3.954628] mmc0: Invalid maximum block size, assuming 512 bytes
>>> [    4.010608] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci]
>>> using ADMA
>>> [    4.341727] mmc0: queuing unknown CIS tuple 0x80 (50 bytes)
>>> [    4.349595] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
>>> [    4.352695] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
>>> [    4.381292] mmc0: queuing unknown CIS tuple 0x02 (1 bytes)
>>> [    4.387377] mmc0: new SDIO card at address 0001
>>> [    4.399393] brcmfmac: F1 signature read @0x18000000=0x9934329
>>> [    4.405883] brcmfmac: brcmf_sdiod_regrw_helper: failed to read data
>>> F1@0x080ac, err: -84
>>> [    4.407207] brcmfmac: brcmf_fw_map_chip_to_name: using
>>> brcm/brcmfmac4329-sdio.bin for chip 0x004329(17193) rev 0x000003
>>> [    4.709436] brcmfmac mmc0:0001:1: Direct firmware load for
>>> brcm/brcmfmac4329-sdio.clm_blob failed with error -2
>>> [    4.709517] brcmfmac mmc0:0001:1: Falling back to user helper
>>> [   69.710122] brcmfmac mmc0:0001:1: Direct firmware load for
>>> brcm/brcmfmac4329-sdio.clm_blob failed with error -2
>>> [   69.710137] brcmfmac mmc0:0001:1: Falling back to user helper
>>> [  131.054899] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
>>> Sep  2 2011 14:48:19 version 4.220.48
>>> [  131.072561] brcmfmac: brcmf_setup_wiphybands: rxchain error (-23)
>>> [  131.388384] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  131.392390] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  131.920861] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  131.924183] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  132.593074] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  133.135973] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  133.138223] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  133.152149] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  134.311983] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  134.458577] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  134.461640] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>> [  134.555048] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -23
>>>
>>>
>>> I can now connect to an AP with the following caveats:
>>>
>>> 1) It takes about two minutes before the wlan device is available. For a
>>> long while I didn't think it was working because I would check dmesg and
>>> check ifconfig -a before the wlan would be present.
>>
>> Those two minutes are a direct result of the clm_blob requests. Your
>> kernel config has user-mode helper fallback selected, which causes 60
>> seconds timeout waiting for user-space to provide the blob. You could
>> try and disable it. It is CONFIG_FW_LOADER_USER_HELPER_FALLBACK in your
>> .config.
>
> Yes, it's better without it.
>
>>
>>> 2) After reboot I get this nasty error...
>>> [    0.000000] Kernel command line: console=tty0 selinux=0
>>> video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
>>> [    2.269750] mmc0: Invalid maximum block size, assuming 512 bytes
>>> [    2.330010] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci]
>>> using ADMA
>>> [    2.645242] mmc0: error -110 whilst initialising SDIO card
>>
>> Ok. I suppose you mean a warm reboot. So I suppose the card is not
>> properly power cycled. If your SDHCI controller driver (is it
>> sdhci-acpi?) is loaded as a module, you could try to unload it and load
>> it again. Let me know if that works for you to confirm my guess.
>
> Yes, reboot = warm boot. The driver is sdhci-tegra. I have it built in as
> I am booting without an initrd. I have tried modprobe -r brcmfmac before
> reboot with no difference. It will take some work to create a ramdisk.
>
>>
>>> Regarding the patch, brcmfmac tries to load a firmware file twice for a
>>> device which the firmware file does not exist. Is there a know list of
>>> devices which do not need it that we can use to bypass
>>> brcmf_c_process_clm_blob()?
>>
>> It is unclear to me why the firmware load is done twice. Could it be in
>> the firmware class itself? In brcmfmac there is only one
>> request_firmware() call for the clm blob. At least in my version of it.
>> Do you have something else?
>
> It is your patch [1]. The helper function triggers the while loop.

That actually is not my patch. I just mentioned that one for reference. 
My patch was at the end of my email message or here [3].

Anyway, Kalle just applied a similar patch [4] which hopefully makes it 
into v4.15 release.

Regards,
Arend

[3] https://patchwork.kernel.org/patch/10154595/
[4] https://patchwork.kernel.org/patch/10166257/
