Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:42373 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754537AbeALUSl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 15:18:41 -0500
Received: by mail-it0-f43.google.com with SMTP id p139so10462549itb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jan 2018 12:18:41 -0800 (PST)
Subject: Re: brcmfmac4329-sdio firmware load failed.
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
References: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com>
 <5A55D325.60805@broadcom.com>
From: Kyle Evans <kvans32@gmail.com>
Message-ID: <3842a299-cd14-65db-1222-6849bc95ef74@gmail.com> (sfid-20180112_211846_494718_FD6CF4F5)
Date: Fri, 12 Jan 2018 15:18:36 -0500
MIME-Version: 1.0
In-Reply-To: <5A55D325.60805@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Arend. I updated to master again, v4.15-rc7+, and applied your 
patch. All log snips are grabbed with dmesg|grep -E 'mmc0|brcm', as the 
sdio device is on mmc0.

Without patch [1], for reference...

[    0.000000] Kernel command line: console=tty0 selinux=0 
video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
[    3.952561] mmc0: Invalid maximum block size, assuming 512 bytes
[    4.010466] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci] 
using ADMA
[    4.338545] mmc0: queuing unknown CIS tuple 0x80 (50 bytes)
[    4.347098] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
[    4.350099] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
[    4.378430] mmc0: queuing unknown CIS tuple 0x02 (1 bytes)
[    4.388387] mmc0: new SDIO card at address 0001
[    4.401773] brcmfmac: F1 signature read @0x18000000=0x9934329
[    4.407624] brcmfmac: brcmf_sdiod_regrw_helper: failed to read data 
F1@0x080ac, err: -84
[    4.410159] brcmfmac: brcmf_fw_map_chip_to_name: using 
brcm/brcmfmac4329-sdio.bin for chip 0x004329(17193) rev 0x000003
[    4.781374] brcmfmac mmc0:0001:1: Direct firmware load for 
brcm/brcmfmac4329-sdio.clm_blob failed with error -2
[    4.781491] brcmfmac mmc0:0001:1: Falling back to user helper
[   69.601645] brcmfmac: brcmf_c_process_clm_blob: request CLM blob file 
failed (-11)
[   69.601668] brcmfmac: brcmf_c_preinit_dcmds: download CLM blob file 
failed, -11
[   69.601685] brcmfmac: brcmf_bus_started: failed: -11
[   69.601728] brcmfmac: brcmf_sdio_firmware_callback: dongle is not 
responding


With patch [1]...

[    0.000000] Kernel command line: console=tty0 selinux=0 
video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
[    3.954628] mmc0: Invalid maximum block size, assuming 512 bytes
[    4.010608] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci] 
using ADMA
[    4.341727] mmc0: queuing unknown CIS tuple 0x80 (50 bytes)
[    4.349595] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
[    4.352695] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
[    4.381292] mmc0: queuing unknown CIS tuple 0x02 (1 bytes)
[    4.387377] mmc0: new SDIO card at address 0001
[    4.399393] brcmfmac: F1 signature read @0x18000000=0x9934329
[    4.405883] brcmfmac: brcmf_sdiod_regrw_helper: failed to read data 
F1@0x080ac, err: -84
[    4.407207] brcmfmac: brcmf_fw_map_chip_to_name: using 
brcm/brcmfmac4329-sdio.bin for chip 0x004329(17193) rev 0x000003
[    4.709436] brcmfmac mmc0:0001:1: Direct firmware load for 
brcm/brcmfmac4329-sdio.clm_blob failed with error -2
[    4.709517] brcmfmac mmc0:0001:1: Falling back to user helper
[   69.710122] brcmfmac mmc0:0001:1: Direct firmware load for 
brcm/brcmfmac4329-sdio.clm_blob failed with error -2
[   69.710137] brcmfmac mmc0:0001:1: Falling back to user helper
[  131.054899] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: 
Sep  2 2011 14:48:19 version 4.220.48
[  131.072561] brcmfmac: brcmf_setup_wiphybands: rxchain error (-23)
[  131.388384] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  131.392390] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  131.920861] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  131.924183] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  132.593074] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  133.135973] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  133.138223] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  133.152149] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  134.311983] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  134.458577] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  134.461640] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23
[  134.555048] brcmfmac: _brcmf_set_multicast_list: Setting 
BRCMF_C_SET_PROMISC failed, -23


I can now connect to an AP with the following caveats:

1) It takes about two minutes before the wlan device is available. For a 
long while I didn't think it was working because I would check dmesg and 
check ifconfig -a before the wlan would be present.

2) After reboot I get this nasty error...
[    0.000000] Kernel command line: console=tty0 selinux=0 
video=1280x800 root=/dev/mmcblk1p1 brcmfmac.bebug=0x20000
[    2.269750] mmc0: Invalid maximum block size, assuming 512 bytes
[    2.330010] mmc0: SDHCI controller on c8000000.sdhci [c8000000.sdhci] 
using ADMA
[    2.645242] mmc0: error -110 whilst initialising SDIO card

Regarding the patch, brcmfmac tries to load a firmware file twice for a 
device which the firmware file does not exist. Is there a know list of 
devices which do not need it that we can use to bypass 
brcmf_c_process_clm_blob()?

Thanks,
Kyle

On 01/10/2018 03:47 AM, Arend van Spriel wrote:
> On 1/9/2018 1:51 PM, Kyle Evans wrote:
>> This is linux-4.15-rc2 on an ASUS TF101. This device was shipped with
>> Android and a custom kernel using bcmdhd. I have taken nvram.txt from
>> /system/etc/ on the stock filesystem and copied to
>> /lib/firmware/brcm/brcmfmac4329-sdio.txt. Below is the result.
> 
> Ok. So far so good as that nvram.txt is indeed what you want to use.
>> [    2.729157] brcmfmac: F1 signature read @0x18000000=0x9934329
>> [    2.734313] brcmfmac: brcmf_sdiod_regrw_helper: failed to read data
>> F1@0x080ac, err: -84
> 
> The read failure is a bit concerning, but I ignore it for now.
> 
>> [    2.739952] brcmfmac: brcmf_fw_map_chip_to_name: using
>> brcm/brcmfmac4329-sdio.bin for chip 0x004329(17193) rev 0x000003
>> [    2.965820] brcmfmac mmc0:0001:1: Direct firmware load for
>> brcm/brcmfmac4329-sdio.clm_blob failed with error -2
> 
> Expected as you did not put a clm_blob file in /lib/firmware/brcm/. 
> However, ...
> 
>> [    2.969658] brcmfmac mmc0:0001:1: Falling back to user helper
>> [   64.489695] brcmfmac: brcmf_c_process_clm_blob: request CLM blob file
>> failed (-11)
> 
> ...in one of the review cycles for the CLM blob feature it was made 
> clear that this should not result in a probe failure...
> 
>> [   64.489720] brcmfmac: brcmf_c_preinit_dcmds: download CLM blob file
>> failed, -11
>> [   64.489739] brcmfmac: brcmf_bus_started: failed: -11
> 
> ... but it does bail out. Turns out the driver is checking for a 
> specific error code -ENOENT (-2) and not -EAGAIN(-11). A patch has been 
> submitted for it earlier [1], but it was rejected. I have taken another 
> stab at it (see below). Let me know if it works for you.
> 
>> [   64.489783] brcmfmac: brcmf_sdio_firmware_callback: dongle is not
>> responding
>> [   64.596281] [<c061fd98>] (device_release_driver_internal) from
>> [<c068f394>] (brcmf_sdio_firmware_callback+0x244/0x5b8)
>> [   64.596500] [<c068f394>] (brcmf_sdio_firmware_callback) from
>> [<c0686870>] (brcmf_fw_request_nvram_done+0x1cc/0x73c)
>> [   64.596716] [<c0686870>] (brcmf_fw_request_nvram_done) from
>> [<c063337c>] (request_firmware_work_func+0x3c/0x64)
> 
> This stack trace is from a driver bug that has been fixed in later -rc [2].
> 
> Regards,
> Arend
> 
> [1] https://patchwork.kernel.org/patch/10106571/
> [2] https://patchwork.kernel.org/patch/10075091/
> 
> ---
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c 
> b/driver
> index 6a59d06..f805600 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -182,12 +182,8 @@ static int brcmf_c_process_clm_blob(struct brcmf_if 
> *ifp)
> 
>          err = request_firmware(&clm, clm_name, dev);
>          if (err) {
> -               if (err == -ENOENT) {
> -                       brcmf_dbg(INFO, "continue with CLM data 
> currently prese
> -                       return 0;
> -               }
> -               brcmf_err("request CLM blob file failed (%d)\n", err);
> -               return err;
> +               brcmf_info("no CLM blob. Firmware may still need it.\n");
> +               return 0;
>          }
> 
>          chunk_buf = kzalloc(sizeof(*chunk_buf) + MAX_CHUNK_LEN - 1, 
> GFP_KERNEL)
> 
