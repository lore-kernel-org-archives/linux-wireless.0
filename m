Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32985 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbdEaMp3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 08:45:29 -0400
Received: by mail-it0-f67.google.com with SMTP id l145so1684047ita.0
        for <linux-wireless@vger.kernel.org>; Wed, 31 May 2017 05:45:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <df03fc22-4141-2c17-db09-6500872d37e6@broadcom.com>
References: <1496147754-2303-1-git-send-email-arend.vanspriel@broadcom.com>
 <CAFqH_51ddok-8NQ0EuNaebU--OS1wkmTH19j-WOufg4JYUo8mA@mail.gmail.com> <df03fc22-4141-2c17-db09-6500872d37e6@broadcom.com>
From: Enric Balletbo Serra <eballetbo@gmail.com>
Date: Wed, 31 May 2017 14:45:27 +0200
Message-ID: <CAFqH_501kOMNRz4d-CfvhPYHrifc1xT9wm=i362_dmtCFEXTnw@mail.gmail.com> (sfid-20170531_144532_948224_5A979801)
Subject: Re: [RFT 0/3] brcmfmac: firmware loading rework
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-05-31 14:00 GMT+02:00 Arend van Spriel <arend.vanspriel@broadcom.com>:
> On 31-05-17 13:10, Enric Balletbo Serra wrote:
>> Hi Arend,
>>
>> 2017-05-30 14:35 GMT+02:00 Arend van Spriel <arend.vanspriel@broadcom.com>:
>>> Hi Enric,
>>>
>>> Could you please try these patches and let me know if they resolve
>>> the issue for you.
>>>
>>> Regards,
>>> Arend
>>>
>>> Arend van Spriel (3):
>>>   brcmfmac: add parameter to pass error code in firmware callback
>>>   brcmfmac: use firmware callback upon failure to load
>>>   brcmfmac: unbind all devices upon failure in firmware callback
>>>
>>>  .../broadcom/brcm80211/brcmfmac/firmware.c         | 35 +++++++++++-----------
>>>  .../broadcom/brcm80211/brcmfmac/firmware.h         |  4 +--
>>>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 17 +++++++----
>>>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 18 +++++++----
>>>  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  6 ++--
>>>  5 files changed, 47 insertions(+), 33 deletions(-)
>>>
>>> --
>>> 1.9.1
>>>
>>
>> After these patches the error path when firmware is not found seems
>> the correct way to proceed but I'm still getting the same kernel panic
>> [1].
>>
>> I added some printk and I saw that when firmware load fails
>>
>> [    7.696463] brcmfmac mmc1:0001:1: Direct firmware load for
>> brcm/brcmfmac4354-sdio.bin failed with error -2
>>
>> The brcmf_sdio_firmware_callback fails, and goes to the fail label and
>> the devices are released.
>>
>>         device_release_driver(dev);
>>         device_release_driver(&sdiodev->func[1]->dev);
>>
>> But PM ops are not unregistered for mmc1:0001:2 and
>> brcmf_ops_sdio_resume is still called, so I'm wondering if you missed
>> here to add
>>
>>         device_release_driver(&sdiodev->func[2]->dev);
>>
>> Adding that seems to solve the problem, not sure if there is any
>> collateral effect.
>
> Looking closer at the firmware load failure message it uses mmc1:0001:1,
> ie. func[1]->dev. I wrongly assume everything was using func[2]->dev
> hence I added the device_release_driver() call for func[1]->dev. So we
> are calling device_release_driver() twice for the same device. Just
> change func[1] into func[2].
>

-       device_release_driver(&sdiodev->func[1]->dev);
+       device_release_driver(&sdiodev->func[2]->dev);

Right this works, thanks Arend. If you send a new patch revision you can add my

Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>

Regards,
 Enric

> Regards,
> Arend
>
>> + info:
>>
>> Steps to reproduce the Oops:
>>
>> 1. Remove the brcm/brcmfmac4354-sdio.bin firmware
>> 2. modprobe brcmfmac
>> [    6.879679] brcmfmac mmc1:0001:1: Direct firmware load for
>> brcm/brcmfmac4354-sdio.bin failed with error -2
>> 3. Do a suspend/resume cycle
>> echo mem > /sys/power/state && # hit a key
>>
>> [1] Kernel Oops:
>>
>> [   29.375149] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000000
>> [   29.384270] pgd = c0204000
>> [   29.387310] [00000000] *pgd=00000000
>> [   29.391336] Internal error: Oops: 17 [#1] SMP ARM
>> [   29.396628] Modules linked in: cpufreq_powersave cpufreq_userspace
>> cpufreq_conservative bq27xxx_battery_i2c bq27xxx_battery cros_ec_keyb
>> i2c_cros_ec_tunnel cros_ec_devs cros_ec_spi cros_ec_core
>> snd_soc_rockchip_max98090 brcmfmac snd_soc_ts3a227e snd_soc_max98090
>> snd_soc_rockchip_i2s cfg80211 snd_soc_core ac97_bus uvcvideo
>> videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core
>> videodev snd_pcm_dmaengine brcmutil snd_pcm gpio_charger snd_timer
>> media nvmem_rockchip_efuse rk_crypto md5 sha256_generic sha1_generic
>> des_generic phy_rockchip_dp rtc_rk808 snd soundcore pwm_rockchip
>> rockchipdrm tpm_i2c_infineon dw_hdmi tpm analogix_dp pwm_bl
>> spi_rockchip
>> [   29.461958] CPU: 0 PID: 3030 Comm: kworker/u8:28 Not tainted
>> 4.12.0-rc2-next-20170529-00003-g38fc31b-dirty #3
>> [   29.473118] Hardware name: Rockchip (Device Tree)
>> [   29.478415] Workqueue: events_unbound async_run_entry_fn
>> [   29.484384] task: ed6dc200 task.stack: ed27c000
>> [   29.489494] PC is at brcmf_ops_sdio_resume+0x10/0x5c [brcmfmac]
>> [   29.496158] LR is at dpm_run_callback+0x38/0x160
>> [   29.501351] pc : [<bf4c0fc0>]    lr : [<c087fb70>]    psr: 60000113
>> [   29.508394] sp : ed27dec8  ip : 60000113  fp : c1572a54
>> [   29.514262] r10: 00000000  r9 : c0fe196c  r8 : 00000010
>> [   29.520131] r7 : c087b900  r6 : 00000000  r5 : ed1b5208  r4 : 00000001
>> [   29.527476] r3 : 00000000  r2 : 00000002  r1 : ed1b5208  r0 : ed1b5208
>> [   29.537127] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>> [   29.547454] Control: 10c5387d  Table: 2d75c06a  DAC: 00000051
>> [   29.556215] Process kworker/u8:28 (pid: 3030, stack limit = 0xed27c220)
>> [   29.565965] Stack: (0xed27dec8 to 0xed27e000)
>> [   29.573150] dec0:                   00000001 c087fb70 00000001
>> ed1b5208 00000000 00000010
>> [   29.584656] dee0: ed1b523c ed27c000 00000000 c08802d4 c15c54fc
>> ed1b5208 ed542140 ee006500
>> [   29.596172] df00: 00000000 c08804b8 ed542150 c157fda0 ed542140
>> c036525c ec820280 ed542150
>> [   29.607694] df20: ee004800 ee006500 00000000 c035cc28 eef914c0
>> ee004848 ee004818 ee004800
>> [   29.619249] df40: ec820298 00000088 ee004818 c1402d00 ed27c000
>> ee004800 ec820280 c035cf58
>> [   29.630816] df60: ee004960 00000000 ec820280 ec802000 00000000
>> ed7d7ac0 ec820280 c035cf20
>> [   29.642397] df80: ec80201c ec96bee8 00000000 c0362358 ed7d7ac0
>> c036222c 00000000 00000000
>> [   29.654046] dfa0: 00000000 00000000 00000000 c0307e78 00000000
>> 00000000 00000000 00000000
>> [   29.665707] dfc0: 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000 00000000
>> [   29.677322] dfe0: 00000000 00000000 00000000 00000000 00000013
>> 00000000 00000000 00000000
>> [   29.688968] [<bf4c0fc0>] (brcmf_ops_sdio_resume [brcmfmac]) from
>> [<c087fb70>] (dpm_run_callback+0x38/0x160)
>> [   29.702379] [<c087fb70>] (dpm_run_callback) from [<c08802d4>]
>> (device_resume+0x94/0x25c)
>> [   29.713951] [<c08802d4>] (device_resume) from [<c08804b8>]
>> (async_resume+0x1c/0x44)
>> [   29.725063] [<c08804b8>] (async_resume) from [<c036525c>]
>> (async_run_entry_fn+0x44/0x108)
>> [   29.736788] [<c036525c>] (async_run_entry_fn) from [<c035cc28>]
>> (process_one_work+0x14c/0x444)
>> [   29.749022] [<c035cc28>] (process_one_work) from [<c035cf58>]
>> (worker_thread+0x38/0x510)
>> [   29.760675] [<c035cf58>] (worker_thread) from [<c0362358>]
>> (kthread+0x12c/0x15c)
>> [   29.771521] [<c0362358>] (kthread) from [<c0307e78>]
>> (ret_from_fork+0x14/0x3c)
>> [   29.782226] Code: e92d4010 e59021a4 e5903054 e3520002 (e5934000)
>> [   29.791751] ---[ end trace 035307c5087a8fee ]---
>>
