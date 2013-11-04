Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:44531 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3KDINE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 03:13:04 -0500
Received: by mail-qa0-f49.google.com with SMTP id cm18so60453qab.15
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 00:13:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA+hA=TafyyKy3a4i8Kq11DdqnNv6+7LJmHC5=HVFc+qCd5byg@mail.gmail.com>
References: <CAA+hA=TSonWMWm9gf+n4T9+HxWT=pvJG9jnkdoUyZUNjPpnJfg@mail.gmail.com>
	<5273840F.40808@broadcom.com>
	<CAA+hA=QB3S6nv1sjtiWQxwrzT3qivoWtaz_noLgVpA-5jBhjiw@mail.gmail.com>
	<5273ABAC.1090109@broadcom.com>
	<CAA+hA=TafyyKy3a4i8Kq11DdqnNv6+7LJmHC5=HVFc+qCd5byg@mail.gmail.com>
Date: Mon, 4 Nov 2013 16:13:03 +0800
Message-ID: <CAA+hA=RHbqQN3Z624A_SxfYO3CgetZvvKxyMNEt3Y+T0HTAapA@mail.gmail.com> (sfid-20131104_091312_694798_26AFD2CD)
Subject: Re: brcmfmac driver does not work with a BCM4335 WiFi module
From: Dong Aisheng <dongas86@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, frankyl@broadcom.com,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Mon, Nov 4, 2013 at 11:44 AM, Dong Aisheng <dongas86@gmail.com> wrote:
> Hi Arend,
>
> On Fri, Nov 1, 2013 at 9:25 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 11/01/2013 01:21 PM, Dong Aisheng wrote:
>>>
>>> Hi Arend,
>>>
>>> On Fri, Nov 1, 2013 at 6:35 PM, Arend van Spriel <arend@broadcom.com>
>>> wrote:
>>>>
>>>> On 11/01/2013 07:22 AM, Dong Aisheng wrote:
>>>>>
>>>>>
>>>>> Hi ALL,
>>>>>
>>>>> I'm verifying BCM4335 WiFi module on i.MX6SL EVK board.
>>>>> The kernel i ran is latest from:
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
>>>>>
>>>>> The firmware is used is from:
>>>>>
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>>>>>
>>>>> NVRAM file is got from the vendor which should work for the module.
>>>>>
>>>>> But i ran into the following issues, hope somebody can give me some
>>>>> hints.
>>>>>
>>>>> First, i met error when module is auto loaded, but seems the driver is
>>>>> still loaded successfully since i found the new WiFi interface with
>>>>> ifconfig.
>>>>> But it can not work after run rfkill unblock wlan and a lot error
>>>>> messages comes out.
>>>>>
>>>>> I'm wondering if this driver can support bcm4335 well, can anybody
>>>>> provide some help?
>>>>
>>>>
>>>>
>>>> I can try. I have used the bcm4335 with a SDIO3.0 controller on a x86 PC.
>>>> Looking at an issue right now, but your log does not show that so you
>>>> have a
>>>> different issue. Could you load the module with parameter 'debug=0x146'.
>>>>
>>>
>>> Thanks for the help.
>>> So that means the brcmfmac driver should support bcm4335 module well,
>>> right?
>>> The difference is that i'm using a ARM platform.
>>> Below is log with 'debug=0x146'.
>>> It only includes driver probe log.
>>
>>
>> That log actually looks fine. Just not sure why software rfkill was enabled.
>> Is that still the case? What distro is running on your platform?
>>
>
> Do you  mean the error message during probe is also fine?
> root@imx6slevk:~# mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
> mmc0: new high speed SDIO card at address 0001
> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
> brcmfmac: brcmf_sdio_regrw_helper: failed with -84     <--- error message
> brcmfmac: brcmf_sdio_chip_
> drivestrengthinit: No SDIO Drive strength
> init done for chip 4335 rev 1 pmurev 18
> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Mar 24 2013
> 20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
> brcmfmac: brcmf_fil_cmd_data: Failed err=-23              <---- error message
>
> I'm using yocto rootfs, seems rfkill is always enabled by default.
> I could try another rootfs without rfkill.
> But i don't think rfkill should block WiFi driver to work properly.
>

I tried another rootfs without rfkill, met the same issue when doing
ifconfig wlan0 up, just like 'rfkill unblock wlan'.

root@freescale ~$ mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
mmc0: new high speed SDIO card at address 0001
brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
brcmfmac: brcmf_sdio_regrw_helper: failed with -84
brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength
init done for chip 4335 rev 1 pmurev 18
brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Mar 24 2013
20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
brcmfmac: brcmf_fil_cmd_data: Failed err=-23

root@freescale ~$
root@freescale ~$
root@freescale ~$ ifconfig -a
......

wlan0     Link encap:Ethernet  HWaddr 00:90:4C:C5:12:38
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

root@freescale ~$ ifconfig wlan0 up
brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
brcmfmac: brcmf_add_if: ignore IF event
brcmfmac: brcmf_fil_cmd_data: Failed err=-110

brcmfmac: brcmf_fil_cmd_data: Failed err=-23
root@freescale ~$
root@freescale ~$
root@freescale ~$ brcmfmac: brcmf_sdioh_request_byte: Failed to write
byte F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110

root@freescale ~$ brcmfmac: brcmf_sdioh_request_byte: Failed to write
byte F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110

I looked into a bit more about the error and found there's CMD timeout
on the bus during SDIO
command transfer.
---------------------------------------
brcmutil: RxHdr:
00000000: 20 00 df ff 19 00 00 0c 00 35 00 00               ........5..
brcmfmac: brcmf_sdbrcm_read_control Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
mmc0: starting CMD52 arg 92001400 flags 00000195
sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00010000
mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
F1:@0x1000a=00, Err: -110
------------------------------------------
I'm not sure how this happened, whether caused by host side or wifi driver side.
But for the host, i tried this host driver with another WiFi
card(Atheros AR6103) with same kernel,
and it worked well. So the host driver seems more like ok to me.

Since i'm not familar with the WiFi driver, i wonder if you could
provide suggestion
from WiFi driver layer to see what the issue could be.

Below is the detailed log when run 'ifconfig wlan0 up'

root@freescale ~$ ifconfig wlan0 up
brcmfmac: brcmf_netdev_open Enter, idx=0
brcmfmac: brcmf_sdbrcm_bus_txctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmutil: TxHdr:
00000000: 2f 00 d0 ff 10 00 00 14 00 00 00 00 00 00 00 00  /...............
brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
brcmfmac: brcmf_sdbrcm_isr Enter
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_rxctl Enter

brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
brcmfmac: brcmf_sdbrcm_isr Enter
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_checkdied firmware not built with -assert
brcmfmac: brcmf_fil_cmd_data: Failed err=-110
brcmutil: RxHdr:
00000000: 27 00 d8 ff 12 00 00 0c 00 26 00 00              '........&..
brcmfmac: brcmf_sdbrcm_read_control Enter
brcmfmac: brcmf_sdbrcm_bus_txctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmutil: TxHdr:
00000000: 28 00 d7 ff 11 00 00 14 00 00 00 00 00 00 00 00  (...............
brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
brcmfmac: brcmf_sdbrcm_isr Enter
brcmutil: RxHdr:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
brcmfmac: brcmf_sdbrcm_isr Enter
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmutil: RxHdr:
00000000: 20 00 df ff 13 00 00 0c 00 32 00 00               ........2..
brcmfmac: brcmf_sdbrcm_read_control Enter
brcmfmac: brcmf_sdbrcm_bus_txctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmutil: TxHdr:
00000000: 28 00 d7 ff 12 00 00 14 00 00 00 00 00 00 00 00  (...............
brcmutil: RxHdr:
00000000: 10 00 ef ff 14 83 0f 0c 00 32 00 00              .........2..
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 88, sig 8
brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 87, sig 8
brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
brcmfmac: brcmf_fws_notify_credit_map enter: credits 09:27:12:09:09:02
brcmfmac: brcmf_add_if Enter, idx=0, ifidx=0
brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
brcmfmac: brcmf_add_if: ignore IF event
brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmutil: RxHdr:
00000000: 20 00 df ff 17 00 00 0c 00 33 00 00               ........3..
brcmfmac: brcmf_sdbrcm_read_control Enter
brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
brcmfmac: brcmf_sdbrcm_isr Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_txctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmutil: TxHdr:
00000000: 28 00 d7 ff 13 00 00 14 00 00 00 00 00 00 00 00  (...............
brcmutil: RxHdr:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmutil: RxHdr:
00000000: 20 00 df ff 18 00 00 0c 00 34 00 00               ........4..
brcmfmac: brcmf_sdbrcm_read_control Enter
brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
brcmfmac: brcmf_sdbrcm_isr Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_txctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmutil: TxHdr:
00000000: 28 00 d7 ff 14 00 00 14 00 00 00 00 00 00 00 00  (...............
brcmutil: RxHdr:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmutil: RxHdr:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
brcmfmac: brcmf_sdbrcm_isr Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmutil: RxHdr:
00000000: 20 00 df ff 19 00 00 0c 00 35 00 00               ........5..
brcmfmac: brcmf_sdbrcm_read_control Enter
brcmfmac: brcmf_sdbrcm_bus_txctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmutil: TxHdr:
00000000: 28 00 d7 ff 15 00 00 14 00 00 00 00 00 00 00 00  (...............
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmutil: RxHdr:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
brcmfmac: brcmf_sdbrcm_isr Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdio_readframes Enter
brcmutil: RxHdr:
00000000: 20 00 df ff 1a 00 00 0c 00 36 00 00               ........6..
brcmfmac: brcmf_sdbrcm_read_control Enter
brcmfmac: brcmf_config_dongle power save set to enabled
brcmfmac: brcmf_dongle_roam Internal Roaming = On
brcmfmac: brcmf_sdbrcm_bus_txctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmutil: RxHdr:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_sdbrcm_dpc Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmutil: TxHdr:
00000000: 31 00 ce ff 16 00 00 14 00 00 00 00 00 00 00 00  1...............
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_kso_control Enter
brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter

brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter
brcmfmac: brcmf_sdbrcm_bus_sleep Enter        <-- the driver loops
here by running this function
.................


Regards
Dong Aisheng
