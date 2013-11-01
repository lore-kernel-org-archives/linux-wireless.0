Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2503 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab3KANZO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:25:14 -0400
Message-ID: <5273ABAC.1090109@broadcom.com> (sfid-20131101_142523_319633_0B07A000)
Date: Fri, 1 Nov 2013 14:25:00 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dong Aisheng" <dongas86@gmail.com>
cc: linux-wireless@vger.kernel.org, frankyl@broadcom.com,
	brcm80211-dev-list@broadcom.com
Subject: Re: brcmfmac driver does not work with a BCM4335 WiFi module
References: <CAA+hA=TSonWMWm9gf+n4T9+HxWT=pvJG9jnkdoUyZUNjPpnJfg@mail.gmail.com>
 <5273840F.40808@broadcom.com>
 <CAA+hA=QB3S6nv1sjtiWQxwrzT3qivoWtaz_noLgVpA-5jBhjiw@mail.gmail.com>
In-Reply-To: <CAA+hA=QB3S6nv1sjtiWQxwrzT3qivoWtaz_noLgVpA-5jBhjiw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2013 01:21 PM, Dong Aisheng wrote:
> Hi Arend,
>
> On Fri, Nov 1, 2013 at 6:35 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 11/01/2013 07:22 AM, Dong Aisheng wrote:
>>>
>>> Hi ALL,
>>>
>>> I'm verifying BCM4335 WiFi module on i.MX6SL EVK board.
>>> The kernel i ran is latest from:
>>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
>>>
>>> The firmware is used is from:
>>> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>>>
>>> NVRAM file is got from the vendor which should work for the module.
>>>
>>> But i ran into the following issues, hope somebody can give me some hints.
>>>
>>> First, i met error when module is auto loaded, but seems the driver is
>>> still loaded successfully since i found the new WiFi interface with
>>> ifconfig.
>>> But it can not work after run rfkill unblock wlan and a lot error
>>> messages comes out.
>>>
>>> I'm wondering if this driver can support bcm4335 well, can anybody
>>> provide some help?
>>
>>
>> I can try. I have used the bcm4335 with a SDIO3.0 controller on a x86 PC.
>> Looking at an issue right now, but your log does not show that so you have a
>> different issue. Could you load the module with parameter 'debug=0x146'.
>>
>
> Thanks for the help.
> So that means the brcmfmac driver should support bcm4335 module well, right?
> The difference is that i'm using a ARM platform.
> Below is log with 'debug=0x146'.
> It only includes driver probe log.

That log actually looks fine. Just not sure why software rfkill was 
enabled. Is that still the case? What distro is running on your platform?

Regards,
Arend

>
> [   43.776870] brcmfmac: brcmf_sdbrcm_probe Enter
> [   43.778413] brcmfmac: F1 signature read @0x18000000=0x16214335
> [   43.778528] brcmfmac: brcmf_sdio_chip_attach Enter
> [   43.779078] brcmfmac: brcmf_sdio_chip_recognition chipid=0x4335 chiprev=1
> [   43.779269] brcmfmac: brcmf_sdio_chip_buscoresetup ccrev=43,
> pmurev=18, buscore rev/type=15/0x829
> [   43.780505] brcmfmac: brcmf_sdioh_request_word: Failed to read
> word, Err: 0xffffffac
> [   43.790834] brcmfmac: brcmf_sdioh_request_word: Failed to read
> word, Err: 0xffffffac
> [   43.801418] brcmfmac: brcmf_sdioh_request_word: Failed to read
> word, Err: 0xffffffac
> [   43.808005] brcmfmac: brcmf_sdio_regrw_helper: failed with -84
> [   43.813607] brcmfmac: brcmf_sdbrcm_kso_init Enter
> [   43.813689] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO
> Drive strength init done for chip 4335 rev 1 pmurev 18
> [   43.829540] brcmfmac: brcmf_attach Enter
> [   43.829624] brcmfmac: brcmf_sdbrcm_probe_malloc Enter
> [   43.829640] brcmfmac: brcmf_sdbrcm_probe_init Enter
> [   43.830753] brcmfmac: brcmf_sdbrcm_probe completed!!
> [   43.830772] brcmfmac: brcmf_bus_start
> [   43.830783] brcmfmac: brcmf_sdbrcm_bus_init Enter
> [   43.833893] brcmfmac: brcmf_sdbrcm_download_code_file Enter
> [   44.092239] brcmfmac: brcmf_sdio_chip_verifynvram Compare NVRAM dl
> & ul; size=2216
> [   44.092843] brcmfmac: brcmf_sdio_chip_writenvram RAM size: 786432
> [   44.092865] brcmfmac: brcmf_sdio_chip_writenvram nvram is placed at
> 2357076, size 2216, token=0xfdd5022a
> [   44.246583] brcmfmac: brcmf_sdbrcm_bus_init enable 0x06, ready 0x06
> [   44.246739] brcmfmac: brcmf_sdbrcm_sr_capable Enter
> [   44.246915] brcmfmac: brcmf_sdbrcm_sr_init Enter
> [   44.247096] brcmfmac: brcmf_sdbrcm_sr_init SR enabled
> [   44.247436] brcmfmac: brcmf_add_if Enter, idx=0, ifidx=0
> [   44.247451] brcmfmac: brcmf_add_if allocate netdev interface
> [   44.247478] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.247489] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.247615] brcmfmac: brcmf_add_if  ==== pid:18, if:wlan%d
> (00:00:00:00:00:00) created ===
> [   44.247635] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.247739] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.247751] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.250918] brcmutil: TxHdr:
> [   44.250940] 00000000: 38 00 c7 ff ff 00 00 14 00 00 00 00 00 00 00
> 00  8...............
> [   44.251012] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.251023] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.251237] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.251252] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.251447] brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
> [   44.251460] brcmfmac: brcmf_sdio_readframes Enter
> [   44.251592] brcmutil: RxHdr:
> [   44.251610] 00000000: 0c 00 f3 ff 00 01 00 0c 00 16 00 00
>     ............
> [   44.251703] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.251716] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.252029] brcmutil: RxHdr:
> [   44.252048] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.252070] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.252083] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.252284] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.252298] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.252425] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.266638] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.266657] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.266880] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.266893] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.267125] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.267140] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.267151] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.270317] brcmfmac: brcmf_sdio_readframes Enter
> [   44.270441] brcmutil: RxHdr:
> [   44.270461] 00000000: 30 00 cf ff 01 00 00 0c 00 15 00 00
>     0...........
> [   44.270474] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.270675] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.270708] brcmutil: RxHdr:
> [   44.270724] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.270761] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.270775] brcmutil: TxHdr:
> [   44.270789] 00000000: 28 01 d7 fe 00 00 00 14 00 00 00 00 00 00 00
> 00  (...............
> [   44.270911] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.286654] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.286671] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.286889] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.286903] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.287131] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.287146] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.287157] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.290320] brcmfmac: brcmf_sdio_readframes Enter
> [   44.290444] brcmutil: RxHdr:
> [   44.290467] 00000000: 20 01 df fe 02 00 00 0c 00 16 00 00
>      ...........
> [   44.290479] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.290766] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
> wl0: Mar 24 2013 20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
> [   44.301838] brcmutil: RxHdr:
> [   44.301859] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.302724] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.302743] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.302757] brcmutil: TxHdr:
> [   44.302775] 00000000: 34 00 cb ff 01 00 00 14 00 00 00 00 00 00 00
> 00  4...............
> [   44.302940] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.316613] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.316630] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.316841] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.316854] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.317073] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.317088] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.317098] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.320259] brcmfmac: brcmf_sdio_readframes Enter
> [   44.320384] brcmutil: RxHdr:
> [   44.320404] 00000000: 2c 00 d3 ff 03 00 00 0c 00 17 00 00
>     ,...........
> [   44.320417] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.320584] brcmutil: RxHdr:
> [   44.320602] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.320658] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.320671] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.320683] brcmutil: TxHdr:
> [   44.320697] 00000000: 31 00 ce ff 02 00 00 14 00 00 00 00 00 00 00
> 00  1...............
> [   44.320818] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.336673] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.336688] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.336902] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.336915] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.337135] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.337150] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.337160] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.340327] brcmfmac: brcmf_sdio_readframes Enter
> [   44.340452] brcmutil: RxHdr:
> [   44.340473] 00000000: 29 00 d6 ff 04 00 00 0c 00 18 00 00
>     )...........
> [   44.340486] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.340651] brcmutil: RxHdr:
> [   44.340669] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.340723] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.340737] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.340750] brcmutil: TxHdr:
> [   44.340763] 00000000: 3f 00 c0 ff 03 00 00 14 00 00 00 00 00 00 00
> 00  ?...............
> [   44.340884] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.356629] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.356647] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.356863] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.356877] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.357102] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.357117] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.357128] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.360290] brcmfmac: brcmf_sdio_readframes Enter
> [   44.360416] brcmutil: RxHdr:
> [   44.360437] 00000000: 37 00 c8 ff 05 00 00 0c 00 19 00 00
>     7...........
> [   44.360448] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.360614] brcmutil: RxHdr:
> [   44.360633] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.360687] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.360701] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.360713] brcmutil: TxHdr:
> [   44.360728] 00000000: 3f 00 c0 ff 04 00 00 14 00 00 00 00 00 00 00
> 00  ?...............
> [   44.360850] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.376617] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.376634] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.376849] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.376862] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.377087] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.377103] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.377113] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.380275] brcmfmac: brcmf_sdio_readframes Enter
> [   44.380397] brcmutil: RxHdr:
> [   44.380417] 00000000: 37 00 c8 ff 06 00 00 0c 00 1a 00 00
>     7...........
> [   44.380430] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.380601] brcmutil: RxHdr:
> [   44.380620] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.380674] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.380687] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.380699] brcmutil: TxHdr:
> [   44.380714] 00000000: 28 00 d7 ff 05 00 00 14 00 00 00 00 00 00 00
> 00  (...............
> [   44.380837] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.396621] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.396639] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.396850] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.396865] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.397091] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.397106] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.397117] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.400276] brcmfmac: brcmf_sdio_readframes Enter
> [   44.400400] brcmutil: RxHdr:
> [   44.400421] 00000000: 20 00 df ff 07 00 00 0c 00 1b 00 00
>      ...........
> [   44.400434] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.400600] brcmutil: RxHdr:
> [   44.400618] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.400672] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.400685] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.400696] brcmutil: TxHdr:
> [   44.400709] 00000000: 28 00 d7 ff 06 00 00 14 00 00 00 00 00 00 00
> 00  (...............
> [   44.400812] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.416618] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.416635] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.416847] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.416860] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.417086] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.417102] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.417112] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.420271] brcmfmac: brcmf_sdio_readframes Enter
> [   44.420394] brcmutil: RxHdr:
> [   44.420414] 00000000: 20 00 df ff 08 00 00 0c 00 1c 00 00
>      ...........
> [   44.420427] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.420588] brcmutil: RxHdr:
> [   44.420605] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.420670] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.420684] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.420696] brcmutil: TxHdr:
> [   44.420710] 00000000: 49 00 b6 ff 07 00 00 14 00 00 00 00 00 00 00
> 00  I...............
> [   44.420835] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.436617] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.436634] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.436851] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.436865] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.437091] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.437106] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.437116] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.440273] brcmfmac: brcmf_sdio_readframes Enter
> [   44.440398] brcmutil: RxHdr:
> [   44.440419] 00000000: 41 00 be ff 09 00 00 0c 00 1d 00 00
>     A...........
> [   44.440431] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.440695] brcmutil: RxHdr:
> [   44.440713] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.440775] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.440789] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.440802] brcmutil: TxHdr:
> [   44.440815] 00000000: 3e 00 c1 ff 08 00 00 14 00 00 00 00 00 00 00
> 00  >...............
> [   44.440926] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.456621] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.456639] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.456853] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.456867] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.457086] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.457102] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.457113] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.460278] brcmfmac: brcmf_sdio_readframes Enter
> [   44.460401] brcmutil: RxHdr:
> [   44.460421] 00000000: 36 00 c9 ff 0a 00 00 0c 00 1e 00 00
>     6...........
> [   44.460435] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.460616] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.460649] brcmutil: RxHdr:
> [   44.460665] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.460702] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.460715] brcmutil: TxHdr:
> [   44.460730] 00000000: 38 00 c7 ff 09 00 00 14 00 00 00 00 00 00 00
> 00  8...............
> [   44.460848] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.476620] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.476637] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.476848] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.476861] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.477081] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.477097] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.477106] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.480268] brcmfmac: brcmf_sdio_readframes Enter
> [   44.480394] brcmutil: RxHdr:
> [   44.480415] 00000000: 30 00 cf ff 0b 00 00 0c 00 1f 00 00
>     0...........
> [   44.480427] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.480612] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.480646] brcmutil: RxHdr:
> [   44.480663] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.480700] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.480715] brcmutil: TxHdr:
> [   44.480728] 00000000: 38 00 c7 ff 0a 00 00 14 00 00 00 00 00 00 00
> 00  8...............
> [   44.480850] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.496616] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.496634] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.496850] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.496864] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.497078] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.497093] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.497104] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.500272] brcmfmac: brcmf_sdio_readframes Enter
> [   44.500395] brcmutil: RxHdr:
> [   44.500416] 00000000: 30 00 cf ff 0c 00 00 0c 00 20 00 00
>     0........ ..
> [   44.500428] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.500793] brcmutil: RxHdr:
> [   44.500814] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.500882] brcmfmac: brcmf_fweh_register event handler registered
> for FIFO_CREDIT_MAP
> [   44.500896] brcmfmac: brcmf_fweh_register event handler registered
> for BCMC_CREDIT_SUPPORT
> [   44.500914] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.500927] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.500939] brcmutil: TxHdr:
> [   44.500954] 00000000: 2c 00 d3 ff 0b 00 00 14 00 00 00 00 00 00 00
> 00  ,...............
> [   44.501092] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.516625] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.516643] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.516863] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.516877] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.517098] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.517113] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.517124] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.520288] brcmfmac: brcmf_sdio_readframes Enter
> [   44.520414] brcmutil: RxHdr:
> [   44.520435] 00000000: 24 00 db ff 0d 00 00 0c 00 21 00 00
>     $........!..
> [   44.520448] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.520632] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.520665] brcmutil: RxHdr:
> [   44.520681] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.520718] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.520731] brcmutil: TxHdr:
> [   44.520744] 00000000: 3a 00 c5 ff 0c 00 00 14 00 00 00 00 00 00 00
> 00  :...............
> [   44.520864] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.536673] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.536689] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.536908] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.536922] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.537141] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.537155] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.537167] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.540333] brcmfmac: brcmf_sdio_readframes Enter
> [   44.540456] brcmutil: RxHdr:
> [   44.540477] 00000000: 32 00 cd ff 0e 00 00 0c 00 22 00 00
>     2........"..
> [   44.540490] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.540676] brcmfmac: brcmf_fil_cmd_data: Failed err=-23
> [   44.544707] brcmfmac: brcmf_fws_init enabling AMPDU host-reorder failed
> [   44.544740] brcmfmac: brcmf_fws_macdesc_init enter: desc 9f20e7f0
> ea=  (null), ifidx=0
> [   44.544795] brcmfmac: brcmf_fws_init enabled bdcv2 tlv signaling [1]
> [   44.544814] brcmfmac: brcmf_fws_macdesc_init enter: desc 9f20d030
> ea=00:90:4c:c5:12:38, ifidx=0
> [   44.544828] brcmfmac: brcmf_fws_add_interface added MACIF:0
> [   44.544965] brcmfmac: brcmf_setup_wiphy Registering custom regulatory
> [   44.547564] brcmutil: RxHdr:
> [   44.547589] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.554565] brcmfmac: brcmf_alloc_vif allocating virtual interface
> (size=2332)
> [   44.554596] brcmfmac: brcmf_fweh_register event handler registered for LINK
> [   44.554609] brcmfmac: brcmf_fweh_register event handler registered
> for DEAUTH_IND
> [   44.554619] brcmfmac: brcmf_fweh_register event handler registered for DEAUTH
> [   44.554630] brcmfmac: brcmf_fweh_register event handler registered
> for DISASSOC_IND
> [   44.554639] brcmfmac: brcmf_fweh_register event handler registered
> for ASSOC_IND
> [   44.554649] brcmfmac: brcmf_fweh_register event handler registered
> for REASSOC_IND
> [   44.554658] brcmfmac: brcmf_fweh_register event handler registered for ROAM
> [   44.554668] brcmfmac: brcmf_fweh_register event handler registered
> for MIC_ERROR
> [   44.554679] brcmfmac: brcmf_fweh_register event handler registered
> for SET_SSID
> [   44.554691] brcmfmac: brcmf_fweh_register event handler registered
> for PFN_NET_FOUND
> [   44.554702] brcmfmac: brcmf_fweh_register event handler registered for IF
> [   44.554713] brcmfmac: brcmf_fweh_register event handler registered
> for P2P_PROBEREQ_MSG
> [   44.554723] brcmfmac: brcmf_fweh_register event handler registered
> for P2P_DISC_LISTEN_COMPLETE
> [   44.554734] brcmfmac: brcmf_fweh_register event handler registered
> for ACTION_FRAME_RX
> [   44.554744] brcmfmac: brcmf_fweh_register event handler registered
> for ACTION_FRAME_COMPLETE
> [   44.554755] brcmfmac: brcmf_fweh_register event handler registered
> for ACTION_FRAME_OFF_CHAN_COMPLETE
> [   44.554765] brcmfmac: brcmf_fweh_register event handler registered
> for ESCAN_RESULT
> [   44.554778] brcmfmac: brcmf_btcoex_attach enter
> [   44.555320] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.555341] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.555356] brcmutil: TxHdr:
> [   44.555376] 00000000: 34 00 cb ff 0d 00 00 14 00 00 00 00 00 00 00
> 00  4...............
> [   44.555517] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.566688] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.566708] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.566939] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.566952] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.567179] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.567195] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.567205] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.570374] brcmfmac: brcmf_sdio_readframes Enter
> [   44.570500] brcmutil: RxHdr:
> [   44.570522] 00000000: 2c 00 d3 ff 0f 00 00 0c 00 23 00 00
>     ,........#..
> [   44.570534] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.570710] brcmutil: RxHdr:
> [   44.570728] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.570786] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.570800] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.570812] brcmutil: TxHdr:
> [   44.570826] 00000000: 28 00 d7 ff 0e 00 00 14 00 00 00 00 00 00 00
> 00  (...............
> [   44.570950] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.586650] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.586669] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.586907] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.586922] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.587144] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.587159] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.587169] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.590336] brcmfmac: brcmf_sdio_readframes Enter
> [   44.590457] brcmutil: RxHdr:
> [   44.590478] 00000000: 20 00 df ff 10 00 00 0c 00 24 00 00
>      ........$..
> [   44.590491] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.590691] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> [   44.590725] brcmutil: RxHdr:
> [   44.590741] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.590775] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.590789] brcmutil: TxHdr:
> [   44.590803] 00000000: 3f 00 c0 ff 0f 00 00 14 00 00 00 00 00 00 00
> 00  ?...............
> [   44.590925] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> [   44.606621] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.606639] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.606856] brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> [   44.606870] brcmfmac: brcmf_sdbrcm_isr Enter
> [   44.607090] brcmfmac: brcmf_sdbrcm_dpc Enter
> [   44.607106] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.607115] brcmfmac: brcmf_sdbrcm_kso_control Enter
> [   44.610279] brcmfmac: brcmf_sdio_readframes Enter
> [   44.610403] brcmutil: RxHdr:
> [   44.610425] 00000000: 37 00 c8 ff 11 00 00 0c 00 25 00 00
>     7........%..
> [   44.610438] brcmfmac: brcmf_sdbrcm_read_control Enter
> [   44.610622] brcmfmac: brcmf_net_attach Enter, idx=0 mac=00:90:4c:c5:12:38
> [   44.611733] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
> [   44.611831] brcmfmac: brcmf_net_attach wlan0: Broadcom Dongle Host Driver
> [   44.619217] brcmutil: RxHdr:
> [   44.619243] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>     ............
> [   44.626752] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> [   44.626771] brcmfmac: brcmf_sdbrcm_kso_control Enter
>
>
> Regards
> Dong Aisheng
>
>> Regards, Arend
>>
>>
>>> Regards
>>> Dong Aisheng
>>>
>>> Below is the log FYI.
>>>
>>> root@imx6slevk:~# mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
>>> mmc0: new high speed SDIO card at address 0001
>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
>>> brcmfmac: brcmf_sdio_regrw_helper: failed with -84
>>> brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength
>>> init done for chip 4335 rev 1 pmurev 18
>>> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Mar 24 2013
>>> 20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>>
>>> root@imx6slevk:~#
>>> root@imx6slevk:~# ifconfig -a
>>> eth0      Link encap:Ethernet  HWaddr 00:04:9F:02:76:E5
>>>             inet addr:10.192.242.69  Bcast:10.192.242.255
>>> Mask:255.255.255.0
>>>             inet6 addr: fe80::204:9fff:fe02:76e5/64 Scope:Link
>>>             UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>>             RX packets:20301 errors:0 dropped:1 overruns:0 frame:0
>>>             TX packets:16888 errors:0 dropped:0 overruns:0 carrier:0
>>>             collisions:0 txqueuelen:1000
>>>             RX bytes:22233761 (21.2 MiB)  TX bytes:2373414 (2.2 MiB)
>>>
>>> lo        Link encap:Local Loopback
>>>             inet addr:127.0.0.1  Mask:255.0.0.0
>>>             inet6 addr: ::1/128 Scope:Host
>>>             UP LOOPBACK RUNNING  MTU:65536  Metric:1
>>>             RX packets:34 errors:0 dropped:0 overruns:0 frame:0
>>>             TX packets:34 errors:0 dropped:0 overruns:0 carrier:0
>>>             collisions:0 txqueuelen:0
>>>             RX bytes:2340 (2.2 KiB)  TX bytes:2340 (2.2 KiB)
>>>
>>> sit0      Link encap:IPv6-in-IPv4
>>>             NOARP  MTU:1480  Metric:1
>>>             RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>>             TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>>             collisions:0 txqueuelen:0
>>>             RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>>>
>>> wlan0     Link encap:Ethernet  HWaddr 00:90:4C:C5:12:38
>>>             BROADCAST MULTICAST  MTU:1500  Metric:1
>>>             RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>>             TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>>             collisions:0 txqueuelen:1000
>>>             RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>>>
>>> root@imx6slevk:~#
>>> root@imx6slevk:~# rfkill list
>>> 0: phy0: wlan
>>>           Soft blocked: yes
>>>           Hard blocked: no
>>>
>>> root@imx6slevk:~# rfkill unblock wlan
>>> root@imx6slevk:~# brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>> brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>>> brcmfmac: brcmf_add_if: ignore IF event
>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>> F1:@0x1001f=ff, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>> F1:@0x1001f=ff, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>> F1:@0x1001f=ff, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>> F1:@0x1001f=ff, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>> F1:@0x1001f=ff, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>> F1:@0x1001f=ff, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>> F1:@0x1001f=ff, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>> F1:@0x1001f=ff, Err: -110
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>> brcmfmac: brcmf_set_mpc: fail to set mpc
>>> brcmfmac: brcmf_escan_timeout: timer expired
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>> brcmfmac: brcmf_set_mpc: fail to set mpc
>>> ............
>>>
>>> The following detailed Log for drver probe, if you also need the full
>>> log after run rfkill please let me know.
>>>
>>> [   36.555580] brcmfmac: brcmf_sdbrcm_probe Enter
>>> [   36.564293] brcmfmac: F1 signature read @0x18000000=0x16214335
>>> [   36.564425] brcmfmac: brcmf_sdio_chip_attach Enter
>>> [   36.564973] brcmfmac: brcmf_sdio_chip_recognition chipid=0x4335
>>> chiprev=1
>>> [   36.565163] brcmfmac: brcmf_sdio_chip_buscoresetup ccrev=43,
>>> pmurev=18, buscore rev/type=15/0x829
>>> [   36.566410] brcmfmac: brcmf_sdioh_request_word: Failed to read
>>> word, Err: 0xffffffac
>>> [   36.594407] brcmfmac: brcmf_sdioh_request_word: Failed to read
>>> word, Err: 0xffffffac
>>> [   36.621092] brcmfmac: brcmf_sdioh_request_word: Failed to read
>>> word, Err: 0xffffffac
>>> [   36.627684] brcmfmac: brcmf_sdio_regrw_helper: failed with -84
>>> [   36.638085] brcmfmac: brcmf_sdbrcm_kso_init Enter
>>> [   36.638167] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO
>>> Drive strength init done for chip 4335 rev 1 pmurev 18
>>> [   36.648862] brcmfmac: brcmf_attach Enter
>>> [   36.648947] brcmfmac: brcmf_sdbrcm_probe_malloc Enter
>>> [   36.648965] brcmfmac: brcmf_sdbrcm_probe_init Enter
>>> [   36.649174] brcmfmac: brcmf_sdbrcm_probe completed!!
>>> [   36.649190] brcmfmac: brcmf_bus_start
>>> [   36.649201] brcmfmac: brcmf_sdbrcm_bus_init Enter
>>> [   36.650399] brcmfmac: brcmf_sdbrcm_download_code_file Enter
>>> [   37.065998] brcmfmac: brcmf_sdio_chip_verifynvram Compare NVRAM dl
>>> & ul; size=2216
>>> [   37.067114] brcmfmac: brcmf_sdio_chip_writenvram RAM size: 786432
>>> [   37.067137] brcmfmac: brcmf_sdio_chip_writenvram nvram is placed at
>>> 2357076, size 2216, token=0xfdd5022a
>>> [   37.226519] brcmfmac: brcmf_sdbrcm_bus_init enable 0x06, ready 0x06
>>> [   37.226674] brcmfmac: brcmf_sdbrcm_sr_capable Enter
>>> [   37.226845] brcmfmac: brcmf_sdbrcm_sr_init Enter
>>> [   37.227026] brcmfmac: brcmf_sdbrcm_sr_init SR enabled
>>> [   37.227368] brcmfmac: brcmf_add_if Enter, idx=0, ifidx=0
>>> [   37.227383] brcmfmac: brcmf_add_if allocate netdev interface
>>> [   37.227408] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.227419] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.227548] brcmfmac: brcmf_add_if  ==== pid:11, if:wlan%d
>>> (00:00:00:00:00:00) created ===
>>> [   37.227567] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.227675] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.227688] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.230910] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.231124] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.231139] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.231337] brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
>>> [   37.231350] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.231550] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.231870] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.231883] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.232082] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.232097] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.232224] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.246569] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.246587] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.246807] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.247031] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.247047] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.247059] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.250219] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.250346] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.250549] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.250606] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.250730] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.266635] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.266651] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.266869] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.267097] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.267112] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.267123] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.270283] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.270410] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.270709] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
>>> wl0: Mar 24 2013 20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
>>> [   37.282106] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.282125] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.282281] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.296548] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.296564] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.296775] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.297000] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.297015] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.297025] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.300190] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.300317] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.300523] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.300538] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.300657] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.316546] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.316562] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.316767] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.316989] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.317005] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.317015] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.320178] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.320302] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.320506] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.320522] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.320644] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.336555] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.336571] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.336782] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.337005] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.337020] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.337031] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.340209] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.340334] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.340542] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.340558] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.340680] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.356551] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.356568] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.356781] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.357012] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.357027] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.357037] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.360196] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.360323] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.360524] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.360539] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.360659] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.376550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.376567] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.376772] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.376995] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.377012] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.377021] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.380178] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.380306] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.380506] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.380522] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.380645] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.396550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.396568] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.396774] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.397002] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.397018] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.397029] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.400187] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.400316] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.400533] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.400549] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.400674] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.416549] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.416566] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.416774] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.416998] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.417015] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.417026] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.420187] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.420310] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.420617] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.420633] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.420753] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.436550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.436566] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.436777] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.437003] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.437018] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.437028] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.440189] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.440311] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.440518] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.440533] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.440654] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.456547] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.456563] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.456773] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.456999] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.457015] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.457025] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.460185] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.460312] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.460518] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.460534] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.460651] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.466742] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.466953] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.466967] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.466981] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.467102] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.469141] brcmfmac: brcmf_fweh_register event handler registered
>>> for FIFO_CREDIT_MAP
>>> [   37.469161] brcmfmac: brcmf_fweh_register event handler registered
>>> for BCMC_CREDIT_SUPPORT
>>> [   37.469178] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.469193] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.469334] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.486546] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.486563] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.486778] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.487004] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.487020] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.487031] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.490190] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.490316] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.490525] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.490542] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.490661] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.506550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.506568] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.506781] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.507008] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.507024] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.507035] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.510194] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.510318] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.510507] brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>> [   37.514539] brcmfmac: brcmf_fws_init enabling AMPDU host-reorder failed
>>> [   37.514573] brcmfmac: brcmf_fws_macdesc_init enter: desc bec567f0
>>> ea=  (null), ifidx=0
>>> [   37.514626] brcmfmac: brcmf_fws_init enabled bdcv2 tlv signaling [1]
>>> [   37.514644] brcmfmac: brcmf_fws_macdesc_init enter: desc bec55030
>>> ea=00:90:4c:c5:12:38, ifidx=0
>>> [   37.514658] brcmfmac: brcmf_fws_add_interface added MACIF:0
>>> [   37.514796] brcmfmac: brcmf_setup_wiphy Registering custom regulatory
>>> [   37.522518] brcmfmac: brcmf_alloc_vif allocating virtual interface
>>> (size=2332)
>>> [   37.522550] brcmfmac: brcmf_fweh_register event handler registered for
>>> LINK
>>> [   37.522563] brcmfmac: brcmf_fweh_register event handler registered
>>> for DEAUTH_IND
>>> [   37.522574] brcmfmac: brcmf_fweh_register event handler registered for
>>> DEAUTH
>>> [   37.522584] brcmfmac: brcmf_fweh_register event handler registered
>>> for DISASSOC_IND
>>> [   37.522593] brcmfmac: brcmf_fweh_register event handler registered
>>> for ASSOC_IND
>>> [   37.522603] brcmfmac: brcmf_fweh_register event handler registered
>>> for REASSOC_IND
>>> [   37.522613] brcmfmac: brcmf_fweh_register event handler registered for
>>> ROAM
>>> [   37.522622] brcmfmac: brcmf_fweh_register event handler registered
>>> for MIC_ERROR
>>> [   37.522633] brcmfmac: brcmf_fweh_register event handler registered
>>> for SET_SSID
>>> [   37.522644] brcmfmac: brcmf_fweh_register event handler registered
>>> for PFN_NET_FOUND
>>> [   37.522655] brcmfmac: brcmf_fweh_register event handler registered for
>>> IF
>>> [   37.522667] brcmfmac: brcmf_fweh_register event handler registered
>>> for P2P_PROBEREQ_MSG
>>> [   37.522677] brcmfmac: brcmf_fweh_register event handler registered
>>> for P2P_DISC_LISTEN_COMPLETE
>>> [   37.522688] brcmfmac: brcmf_fweh_register event handler registered
>>> for ACTION_FRAME_RX
>>> [   37.522699] brcmfmac: brcmf_fweh_register event handler registered
>>> for ACTION_FRAME_COMPLETE
>>> [   37.522710] brcmfmac: brcmf_fweh_register event handler registered
>>> for ACTION_FRAME_OFF_CHAN_COMPLETE
>>> [   37.522720] brcmfmac: brcmf_fweh_register event handler registered
>>> for ESCAN_RESULT
>>> [   37.522732] brcmfmac: brcmf_btcoex_attach enter
>>> [   37.523262] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.523284] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.523429] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.536624] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.536644] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.536879] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.537111] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.537126] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.537137] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.540301] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.540434] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.540656] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.540672] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.540796] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.556688] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.556706] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.556927] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.557152] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.557167] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.557178] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.560348] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.560476] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.560705] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> [   37.560721] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.560846] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> [   37.576550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.576567] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.576777] brcmfmac: brcmf_sdbrcm_isr Enter
>>> [   37.577001] brcmfmac: brcmf_sdbrcm_dpc Enter
>>> [   37.577016] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.577026] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   37.580188] brcmfmac: brcmf_sdio_readframes Enter
>>> [   37.580311] brcmfmac: brcmf_sdbrcm_read_control Enter
>>> [   37.580518] brcmfmac: brcmf_net_attach Enter, idx=0
>>> mac=00:90:4c:c5:12:38
>>> [   37.581610] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>>> [   37.581704] brcmfmac: brcmf_net_attach wlan0: Broadcom Dongle Host
>>> Driver
>>> [   37.596623] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> [   37.596641] brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> [   45.955942] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>>>
>>
>>
>


