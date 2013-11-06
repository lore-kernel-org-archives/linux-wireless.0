Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2631 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab3KFIaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 03:30:19 -0500
Message-ID: <5279FE10.4080804@broadcom.com> (sfid-20131106_093025_686554_039ADA5A)
Date: Wed, 6 Nov 2013 09:30:08 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dong Aisheng" <dongas86@gmail.com>
cc: linux-wireless@vger.kernel.org, frankyl@broadcom.com,
	brcm80211-dev-list@broadcom.com
Subject: Re: brcmfmac driver does not work with a BCM4335 WiFi module
References: <CAA+hA=TSonWMWm9gf+n4T9+HxWT=pvJG9jnkdoUyZUNjPpnJfg@mail.gmail.com>
 <5273840F.40808@broadcom.com>
 <CAA+hA=QB3S6nv1sjtiWQxwrzT3qivoWtaz_noLgVpA-5jBhjiw@mail.gmail.com>
 <5273ABAC.1090109@broadcom.com>
 <CAA+hA=TafyyKy3a4i8Kq11DdqnNv6+7LJmHC5=HVFc+qCd5byg@mail.gmail.com>
 <CAA+hA=RHbqQN3Z624A_SxfYO3CgetZvvKxyMNEt3Y+T0HTAapA@mail.gmail.com>
 <52776C67.8080608@broadcom.com>
 <CAA+hA=RjOsZF8JS-H0dLtcFmv_yqhwy3aA=A_nvre0nCi-vK4Q@mail.gmail.com>
 <5278ADFB.2050909@broadcom.com>
 <CAA+hA=Qr2z1OJDQ+Y5eS+gVVjS5_k2uOgSCnS2wOKA4poqxTOA@mail.gmail.com>
 <CAA+hA=R1oWrZvyeVXjYW7cvJiKL+B-nuu61s9EAOVXNJXzddUA@mail.gmail.com>
In-Reply-To: <CAA+hA=R1oWrZvyeVXjYW7cvJiKL+B-nuu61s9EAOVXNJXzddUA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2013 10:26 AM, Dong Aisheng wrote:
> On Tue, Nov 5, 2013 at 4:57 PM, Dong Aisheng <dongas86@gmail.com> wrote:
>> On Tue, Nov 5, 2013 at 4:36 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 11/05/2013 03:51 AM, Dong Aisheng wrote:
>>>>
>>>> On Mon, Nov 4, 2013 at 5:44 PM, Arend van Spriel <arend@broadcom.com>
>>>> wrote:
>>>>>
>>>>> On 11/04/2013 09:13 AM, Dong Aisheng wrote:
>>>>>>
>>>>>>
>>>>>> Hi Arend,
>>>>>>
>>>>>> On Mon, Nov 4, 2013 at 11:44 AM, Dong Aisheng <dongas86@gmail.com>
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>> Hi Arend,
>>>>>>>
>>>>>>> On Fri, Nov 1, 2013 at 9:25 PM, Arend van Spriel <arend@broadcom.com>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 11/01/2013 01:21 PM, Dong Aisheng wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hi Arend,
>>>>>>>>>
>>>>>>>>> On Fri, Nov 1, 2013 at 6:35 PM, Arend van Spriel <arend@broadcom.com>
>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 11/01/2013 07:22 AM, Dong Aisheng wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Hi ALL,
>>>>>>>>>>>
>>>>>>>>>>> I'm verifying BCM4335 WiFi module on i.MX6SL EVK board.
>>>>>>>>>>> The kernel i ran is latest from:
>>>>>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
>>>>>>>>>>>
>>>>>>>>>>> The firmware is used is from:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>>>>>>>>>>>
>>>>>>>>>>> NVRAM file is got from the vendor which should work for the module.
>>>>>>>>>>>
>>>>>>>>>>> But i ran into the following issues, hope somebody can give me some
>>>>>>>>>>> hints.
>>>>>>>>>>>
>>>>>>>>>>> First, i met error when module is auto loaded, but seems the driver
>>>>>>>>>>> is
>>>>>>>>>>> still loaded successfully since i found the new WiFi interface with
>>>>>>>>>>> ifconfig.
>>>>>>>>>>> But it can not work after run rfkill unblock wlan and a lot error
>>>>>>>>>>> messages comes out.
>>>>>>>>>>>
>>>>>>>>>>> I'm wondering if this driver can support bcm4335 well, can anybody
>>>>>>>>>>> provide some help?
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> I can try. I have used the bcm4335 with a SDIO3.0 controller on a
>>>>>>>>>> x86
>>>>>>>>>> PC.
>>>>>>>>>> Looking at an issue right now, but your log does not show that so
>>>>>>>>>> you
>>>>>>>>>> have a
>>>>>>>>>> different issue. Could you load the module with parameter
>>>>>>>>>> 'debug=0x146'.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Thanks for the help.
>>>>>>>>> So that means the brcmfmac driver should support bcm4335 module well,
>>>>>>>>> right?
>>>>>>>>> The difference is that i'm using a ARM platform.
>>>>>>>>> Below is log with 'debug=0x146'.
>>>>>>>>> It only includes driver probe log.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> That log actually looks fine. Just not sure why software rfkill was
>>>>>>>> enabled.
>>>>>>>> Is that still the case? What distro is running on your platform?
>>>>>>>>
>>>>>>>
>>>>>>> Do you  mean the error message during probe is also fine?
>>>>>>> root@imx6slevk:~# mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
>>>>>>> mmc0: new high speed SDIO card at address 0001
>>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err:
>>>>>>> 0xffffffac
>>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err:
>>>>>>> 0xffffffac
>>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err:
>>>>>>> 0xffffffac
>>>>>>> brcmfmac: brcmf_sdio_regrw_helper: failed with -84     <--- error
>>>>>>> message
>>>>>>> brcmfmac: brcmf_sdio_chip_
>>>>>>> drivestrengthinit: No SDIO Drive strength
>>>>>>> init done for chip 4335 rev 1 pmurev 18
>>>>>>> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Mar 24 2013
>>>>>>> 20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
>>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-23              <---- error
>>>>>>> message
>>>>>>>
>>>>>>> I'm using yocto rootfs, seems rfkill is always enabled by default.
>>>>>>> I could try another rootfs without rfkill.
>>>>>>> But i don't think rfkill should block WiFi driver to work properly.
>>>>>>>
>>>>>>
>>>>>> I tried another rootfs without rfkill, met the same issue when doing
>>>>>> ifconfig wlan0 up, just like 'rfkill unblock wlan'.
>>>>>>
>>>>>> root@freescale ~$ mmc0: mmc_rescan_try_freq: trying to init card at
>>>>>> 400000
>>>>>> Hz
>>>>>> mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
>>>>>> mmc0: new high speed SDIO card at address 0001
>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
>>>>>> brcmfmac: brcmf_sdio_regrw_helper: failed with -84
>>>>>> brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength
>>>>>> init done for chip 4335 rev 1 pmurev 18
>>>>>> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Mar 24 2013
>>>>>> 20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>>>>>
>>>>>> root@freescale ~$
>>>>>> root@freescale ~$
>>>>>> root@freescale ~$ ifconfig -a
>>>>>> ......
>>>>>>
>>>>>> wlan0     Link encap:Ethernet  HWaddr 00:90:4C:C5:12:38
>>>>>>              BROADCAST MULTICAST  MTU:1500  Metric:1
>>>>>>              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>>>>>              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>>>>>              collisions:0 txqueuelen:1000
>>>>>>              RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>>>>>>
>>>>>> root@freescale ~$ ifconfig wlan0 up
>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>>>>> brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>>>>>> brcmfmac: brcmf_add_if: ignore IF event
>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>>>>>
>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>>>>> root@freescale ~$
>>>>>> root@freescale ~$
>>>>>> root@freescale ~$ brcmfmac: brcmf_sdioh_request_byte: Failed to write
>>>>>> byte F1:@0x1001f=01, Err: -110
>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>>
>>>>>> root@freescale ~$ brcmfmac: brcmf_sdioh_request_byte: Failed to write
>>>>>> byte F1:@0x1001f=01, Err: -110
>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>>>>> F1:@0x1001f=01, Err: -110
>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>>
>>>>>> I looked into a bit more about the error and found there's CMD timeout
>>>>>> on the bus during SDIO
>>>>>> command transfer.
>>>>>> ---------------------------------------
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 20 00 df ff 19 00 00 0c 00 35 00 00               ........5..
>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> mmc0: starting CMD52 arg 92001400 flags 00000195
>>>>>> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00010000
>>>>>> mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>>>>> F1:@0x1000a=00, Err: -110
>>>>>> ------------------------------------------
>>>>>> I'm not sure how this happened, whether caused by host side or wifi
>>>>>> driver
>>>>>> side.
>>>>>> But for the host, i tried this host driver with another WiFi
>>>>>> card(Atheros AR6103) with same kernel,
>>>>>> and it worked well. So the host driver seems more like ok to me.
>>>>>>
>>>>>> Since i'm not familar with the WiFi driver, i wonder if you could
>>>>>> provide suggestion
>>>>>> from WiFi driver layer to see what the issue could be.
>>>>>>
>>>>>> Below is the detailed log when run 'ifconfig wlan0 up'
>>>>>>
>>>>>> root@freescale ~$ ifconfig wlan0 up
>>>>>> brcmfmac: brcmf_netdev_open Enter, idx=0
>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmutil: TxHdr:
>>>>>> 00000000: 2f 00 d0 ff 10 00 00 14 00 00 00 00 00 00 00 00
>>>>>> /...............
>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>>
>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_checkdied firmware not built with -assert
>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 27 00 d8 ff 12 00 00 0c 00 26 00 00              '........&..
>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmutil: TxHdr:
>>>>>> 00000000: 28 00 d7 ff 11 00 00 14 00 00 00 00 00 00 00 00
>>>>>> (...............
>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 20 00 df ff 13 00 00 0c 00 32 00 00               ........2..
>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmutil: TxHdr:
>>>>>> 00000000: 28 00 d7 ff 12 00 00 14 00 00 00 00 00 00 00 00
>>>>>> (...............
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 10 00 ef ff 14 83 0f 0c 00 32 00 00              .........2..
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 88, sig 8
>>>>>> brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
>>>>>> brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 87, sig 8
>>>>>> brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
>>>>>> brcmfmac: brcmf_fws_notify_credit_map enter: credits 09:27:12:09:09:02
>>>>>> brcmfmac: brcmf_add_if Enter, idx=0, ifidx=0
>>>>>> brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>>>>>> brcmfmac: brcmf_add_if: ignore IF event
>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 20 00 df ff 17 00 00 0c 00 33 00 00               ........3..
>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmutil: TxHdr:
>>>>>> 00000000: 28 00 d7 ff 13 00 00 14 00 00 00 00 00 00 00 00
>>>>>> (...............
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 20 00 df ff 18 00 00 0c 00 34 00 00               ........4..
>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmutil: TxHdr:
>>>>>> 00000000: 28 00 d7 ff 14 00 00 14 00 00 00 00 00 00 00 00
>>>>>> (...............
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 20 00 df ff 19 00 00 0c 00 35 00 00               ........5..
>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmutil: TxHdr:
>>>>>> 00000000: 28 00 d7 ff 15 00 00 14 00 00 00 00 00 00 00 00
>>>>>> (...............
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>> brcmutil: RxHdr:
>>>>>> 00000000: 20 00 df ff 1a 00 00 0c 00 36 00 00               ........6..
>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>> brcmfmac: brcmf_config_dongle power save set to enabled
>>>>>> brcmfmac: brcmf_dongle_roam Internal Roaming = On
>>>>>
>>>>>
>>>>>
>>>>> It seem this is the last command being sent. Could you provide file
>>>>> contents
>>>>> in /sys/kernel/debug/brcmfmac/mmc*/
>>>>>
>>>>> Not sure if Yocto mounts debugfs on /sys/kernel/debug. Otherwise you can
>>>>> do:
>>>>>
>>>>> # mkdir /tmp/debugfs
>>>>> # mount -t debugfs none /tmp/debugfs
>>>>>
>>>>
>>>> Please see below:
>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# ls
>>>> counters  forensics  fws_stats
>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# ls -l
>>>> total 0
>>>> -r--r--r-- 1 root root 0 Sep  6 23:21 counters
>>>> -r--r--r-- 1 root root 0 Sep  6 23:21 forensics
>>>> -r--r--r-- 1 root root 0 Sep  6 23:21 fws_stats
>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# cat counters
>>>> intrcount:    19
>>>> lastintrs:    0
>>>> pollcnt:      0
>>>> regfails:     0
>>>> tx_sderrs:    0
>>>> fcqueued:     0
>>>> rxrtx:        0
>>>> rx_toolong:   0
>>>> rxc_errors:   0
>>>> rx_hdrfail:   0
>>>> rx_badhdr:    0
>>>> rx_badseq:    0
>>>> fc_rcvd:      0
>>>> fc_xoff:      0
>>>> fc_xon:       0
>>>> rxglomfail:   0
>>>> rxglomframes: 0
>>>> rxglompkts:   0
>>>> f2rxhdrs:     36
>>>> f2rxdata:     3
>>>> f2txdata:     0
>>>> f1regdata:    42
>>>> tickcnt:      53
>>>> tx_ctlerrs:   0
>>>> tx_ctlpkts:   17
>>>> rx_ctlerrs:   0
>>>> rx_ctlpkts:   17
>>>> rx_readahead: 0
>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# cat forensics
>>>>
>>>> RTE (USB-SDIO-CDC) 6.30.171.24.20 (B0 Station/P2P) on BCM4335 r1 @
>>>> 37.4/161.3/161.3MHz
>>>> 000000.011 sdpcmdcdc0: Broadcom SDPCMD CDC driver
>>>> 000000.018 reclaim section 0: Returned 42772 bytes to the heap
>>>> 000000.061 wl0: Broadcom BCM4335 802.11 Wireless Controller
>>>> 6.30.171.24.20 (B0 Station/P2P)
>>>> 000000.070 reclaim section 1: Returned 62128 bytes to the heap
>>>> 000000.209 wl0: wlc_enable_probe_req: state down, deferring setting of
>>>> host flags
>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# ring setting of
>>>> host flags
>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# cat fws_stats
>>>> header_pulls:      0
>>>> header_only_pkt:   0
>>>> tlv_parse_failed:  0
>>>> tlv_invalid_type:  0
>>>> mac_update_fails:  0
>>>> ps_update_fails:   0
>>>> if_update_fails:   0
>>>> pkt2bus:           0
>>>> generic_error:     0
>>>> rollback_success:  0
>>>> rollback_failed:   0
>>>> delayq_full:       0
>>>> supprq_full:       0
>>>> txs_indicate:      0
>>>> txs_discard:       0
>>>> txs_suppr_core:    0
>>>> txs_suppr_ps:      0
>>>> txs_tossed:        0
>>>> txs_host_tossed:   0
>>>> bus_flow_block:    0
>>>> fws_flow_block:    0
>>>> send_pkts:         BK:0 BE:0 VO:0 VI:0 BCMC:0
>>>> requested_sent:    BK:0 BE:0 VO:0 VI:0 BCMC:0
>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1#
>>>
>>>
>>> Nothing exciting there either. Let's take a step back. The rfkill seems an
>>> issue, but I first would like to know if you can get connectivity. Does the
>>> 'ifconfig wlan0 up' complete at all and is it successful.
>>>
>>
>> The second rootfs i tried does not have rfkill.
>> But shows the similar issue with 'ifconfig wlan0 up'.
>>
>>> As you noticed during the up sequence there is a timeout. I would like to
>>> know what command that is. Could you run it again with debug=1546?
>>>
>>
>> Will run the test now.
>> Thanks for the help.
>>
>
> Please see blow log:
> Note: there's no rfkill in this rootfs.
>
> root@freescale ~$ ifconfgiig wlan0
> brcmfmac: brcmf_netdev_get_stats Enter, idx=0
> wlan0     Link encap:Ethernet  HWaddr 00:90:4C:C5:12:38
>            BROADCAST MULTICAST  MTU:1500  Metric:1
>            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:1000
>            RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>
> root@freescale ~$ ifconfig wlan0 up
> brcmfmac: brcmf_netdev_open Enter, idx=0
> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmutil: TxHdr:
> 00000000: 2f 00 d0 ff 10 00 00 14 00 00 00 00 00 00 00 00  /...............
> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> brcmfmac: brcmf_sdbrcm_isr Enter
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>
> <--------- I noticed a few seconds stall here
>
> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> brcmfmac: brcmf_sdbrcm_isr Enter
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdio_readframes Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_checkdied firmware not built with -assert
> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
> brcmfmac: brcmf_fil_iovar_data_get name=toe_ol, len=4
> brcmutil: data
> 00000000: 28 aa 49 80                                      (.I.
>
> brcmutil: RxHdr:
> 00000000: 27 00 d8 ff 12 00 00 0c 00 26 00 00              '........&..
> brcmfmac: brcmf_sdbrcm_read_control Enter
> brcmfmac: brcmf_fil_cmd_int_set cmd=2, value=0
> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmutil: TxHdr:
> 00000000: 28 00 d7 ff 11 00 00 14 00 00 00 00 00 00 00 00  (...............
> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> brcmfmac: brcmf_sdbrcm_isr Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmutil: RxHdr:
> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> brcmfmac: brcmf_sdbrcm_isr Enter
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdio_readframes Enter
> brcmutil: RxHdr:
> 00000000: 20 00 df ff 13 00 00 0c 00 32 00 00               ........2..
> brcmfmac: brcmf_sdbrcm_read_control Enter
>
> brcmfmac: brcmf_fil_cmd_int_set cmd=185, value=40
> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmutil: TxHdr:
> 00000000: 28 00 d7 ff 12 00 00 14 00 00 00 00 00 00 00 00  (...............
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> brcmutil: RxHdr:
> 00000000: 10 00 ef ff 14 83 0f 0c 00 32 00 00              .........2..
> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> brcmfmac: brcmf_sdbrcm_isr Enter
> brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 88, sig 8
> brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
> brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 87, sig 8
> brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_fweh_event_worker event FIFO_CREDIT_MAP (74) ifidx 0
> bsscfg 0 addr 80:80:80:80:80:80
> brcmfmac: brcmf_fweh_event_worker   version 2 flags 24 status 0 reason 0
> brcmutil: event payload, len=6
> 00000000: 09 27 12 09 09 02                                .'....
> brcmfmac: brcmf_fws_notify_credit_map enter: credits 09:27:12:09:09:02
> brcmfmac: brcmf_fweh_event_worker event IF (54) ifidx 0 bsscfg 0 addr
> 00:90:4c:c5:12:38
> brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 0 reason 0
> brcmutil: event payload, len=5
> 00000000: 00 01 00 00 00                                   .....
> brcmfmac: brcmf_fweh_handle_if_event action: 1 idx: 0 bsscfg: 0 flags: 0 role: 0
> brcmfmac: brcmf_fweh_handle_if_event adding wl0 (00:90:4c:c5:12:38)
> brcmfmac: brcmf_add_if Enter, idx=0, ifidx=0
> brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
> brcmfmac: brcmf_add_if: ignore IF event
> brcmutil: RxHdr:
> 00000000: 20 00 df ff 17 00 00 0c 00 33 00 00               ........3..
> brcmfmac: brcmf_sdbrcm_read_control Enter
> brcmfmac: brcmf_fil_cmd_int_set cmd=187, value=40
> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmutil: RxHdr:
> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmutil: TxHdr:
> 00000000: 28 00 d7 ff 13 00 00 14 00 00 00 00 00 00 00 00  (...............
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdio_readframes Enter
> brcmutil: RxHdr:
> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> .......
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> brcmfmac: brcmf_sdbrcm_isr Enter
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdio_readframes Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_checkdied firmware not built with -assert
> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
> brcmfmac: brcmf_dongle_scantime: Scan unassoc time error (-110)
> brcmutil: RxHdr:
> 00000000: 20 00 df ff 18 00 00 0c 00 34 00 00               ........4..
> brcmfmac: brcmf_sdbrcm_read_control Enter
> brcmfmac: brcmf_fil_cmd_int_set cmd=86, value=2
> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmutil: RxHdr:
> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmutil: TxHdr:
> 00000000: 28 00 d7 ff 14 00 00 14 00 00 00 00 00 00 00 00  (...............
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> .................................
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> brcmfmac: brcmf_sdbrcm_isr Enter
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdio_readframes Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_checkdied firmware not built with -assert
> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
> brcmfmac: brcmf_netdev_open: failed to bring up cfg80211
> brcmutil: RxHdr:
> 00000000: 20 00 df ff 19 00 00 0c 00 35 00 00               ........5..
> brcmfmac: brcmf_sdbrcm_read_control Enter
> ifconfig: SIOCSIFFLAGS: Operationbrcmfmac: brcmf_sdbrcm_bus_sleep Enter
>   not permitted
> root@freescale ~$ brcmfmac: brcmf_sdio_readframes: RXHEADER FAILED: -110
>
> brcmfmac: brcmf_sdbrcm_rxfail: abort command, terminate frame, send NAK
> root@freescale ~$
> root@freescale ~$ brcmfmac: brcmf_sdioh_request_word: Failed to write
> word, Err: 0xffffff92
>
> root@freescale ~$
> root@freescale ~$
> root@freescale ~$ brcmfmac: brcmf_sdioh_request_word: Failed to write
> word, Err: 0xffffff92
>
> root@freescale ~$ brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> brcmfmac: brcmf_sdbrcm_isr Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
> brcmfmac: brcmf_sdio_readframes Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmutil: RxHdr:
> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
> F1:@0x1001f=01, Err: -110
> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
> F1:@0x1001f=01, Err: -110
> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
> F1:@0x1001f=01, Err: -110
> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
> brcmfmac: brcmf_sdbrcm_isr Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_dpc Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_kso_control Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
> brcmfmac: brcmf_sdbrcm_bus_sleep Enter

One more question. I looked up the board you mentioined. What I found 
has a dedicated SDIO slot for Wifi. Are you using that and do you know 
if that is an SDIO3.0 or not? Earlier in the thread i found this logging:

 > root@imx6slevk:~# mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
 > mmc0: new high speed SDIO card at address 0001

I think it means it is a SDIO2, but I like to be sure.

Gr. AvS

> Regards
> Dong Aisheng
>


