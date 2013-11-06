Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:49455 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab3KFKr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:47:28 -0500
Received: by mail-qc0-f176.google.com with SMTP id s19so5617204qcw.7
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 02:47:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <527A127F.7020909@broadcom.com>
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
	<5279FE10.4080804@broadcom.com>
	<527A127F.7020909@broadcom.com>
Date: Wed, 6 Nov 2013 18:47:27 +0800
Message-ID: <CAA+hA=REJ0R+XXj4aDzro+OJC=Z8Hx=_G-VmK4X61n3JmB-c_A@mail.gmail.com> (sfid-20131106_114735_669679_AA739F15)
Subject: Re: brcmfmac driver does not work with a BCM4335 WiFi module
From: Dong Aisheng <dongas86@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, frankyl@broadcom.com,
	brcm80211-dev-list@broadcom.com
Content-Type: multipart/mixed; boundary=001a11c305a40e212104ea7fe0a0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a11c305a40e212104ea7fe0a0
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Nov 6, 2013 at 5:57 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 11/06/2013 09:30 AM, Arend van Spriel wrote:
>>
>> On 11/05/2013 10:26 AM, Dong Aisheng wrote:
>>>
>>> On Tue, Nov 5, 2013 at 4:57 PM, Dong Aisheng <dongas86@gmail.com> wrote:
>>>>
>>>> On Tue, Nov 5, 2013 at 4:36 PM, Arend van Spriel <arend@broadcom.com>
>>>> wrote:
>>>>>
>>>>> On 11/05/2013 03:51 AM, Dong Aisheng wrote:
>>>>>>
>>>>>>
>>>>>> On Mon, Nov 4, 2013 at 5:44 PM, Arend van Spriel <arend@broadcom.com>
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 11/04/2013 09:13 AM, Dong Aisheng wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Hi Arend,
>>>>>>>>
>>>>>>>> On Mon, Nov 4, 2013 at 11:44 AM, Dong Aisheng <dongas86@gmail.com>
>>>>>>>> wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hi Arend,
>>>>>>>>>
>>>>>>>>> On Fri, Nov 1, 2013 at 9:25 PM, Arend van Spriel
>>>>>>>>> <arend@broadcom.com>
>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 11/01/2013 01:21 PM, Dong Aisheng wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Hi Arend,
>>>>>>>>>>>
>>>>>>>>>>> On Fri, Nov 1, 2013 at 6:35 PM, Arend van Spriel
>>>>>>>>>>> <arend@broadcom.com>
>>>>>>>>>>> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> On 11/01/2013 07:22 AM, Dong Aisheng wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> Hi ALL,
>>>>>>>>>>>>>
>>>>>>>>>>>>> I'm verifying BCM4335 WiFi module on i.MX6SL EVK board.
>>>>>>>>>>>>> The kernel i ran is latest from:
>>>>>>>>>>>>>
>>>>>>>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> The firmware is used is from:
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> NVRAM file is got from the vendor which should work for the
>>>>>>>>>>>>> module.
>>>>>>>>>>>>>
>>>>>>>>>>>>> But i ran into the following issues, hope somebody can give
>>>>>>>>>>>>> me some
>>>>>>>>>>>>> hints.
>>>>>>>>>>>>>
>>>>>>>>>>>>> First, i met error when module is auto loaded, but seems the
>>>>>>>>>>>>> driver
>>>>>>>>>>>>> is
>>>>>>>>>>>>> still loaded successfully since i found the new WiFi
>>>>>>>>>>>>> interface with
>>>>>>>>>>>>> ifconfig.
>>>>>>>>>>>>> But it can not work after run rfkill unblock wlan and a lot
>>>>>>>>>>>>> error
>>>>>>>>>>>>> messages comes out.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I'm wondering if this driver can support bcm4335 well, can
>>>>>>>>>>>>> anybody
>>>>>>>>>>>>> provide some help?
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> I can try. I have used the bcm4335 with a SDIO3.0 controller
>>>>>>>>>>>> on a
>>>>>>>>>>>> x86
>>>>>>>>>>>> PC.
>>>>>>>>>>>> Looking at an issue right now, but your log does not show
>>>>>>>>>>>> that so
>>>>>>>>>>>> you
>>>>>>>>>>>> have a
>>>>>>>>>>>> different issue. Could you load the module with parameter
>>>>>>>>>>>> 'debug=0x146'.
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Thanks for the help.
>>>>>>>>>>> So that means the brcmfmac driver should support bcm4335
>>>>>>>>>>> module well,
>>>>>>>>>>> right?
>>>>>>>>>>> The difference is that i'm using a ARM platform.
>>>>>>>>>>> Below is log with 'debug=0x146'.
>>>>>>>>>>> It only includes driver probe log.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> That log actually looks fine. Just not sure why software rfkill
>>>>>>>>>> was
>>>>>>>>>> enabled.
>>>>>>>>>> Is that still the case? What distro is running on your platform?
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Do you  mean the error message during probe is also fine?
>>>>>>>>> root@imx6slevk:~# mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
>>>>>>>>> mmc0: new high speed SDIO card at address 0001
>>>>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err:
>>>>>>>>> 0xffffffac
>>>>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err:
>>>>>>>>> 0xffffffac
>>>>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err:
>>>>>>>>> 0xffffffac
>>>>>>>>> brcmfmac: brcmf_sdio_regrw_helper: failed with -84     <--- error
>>>>>>>>> message
>>>>>>>>> brcmfmac: brcmf_sdio_chip_
>>>>>>>>> drivestrengthinit: No SDIO Drive strength
>>>>>>>>> init done for chip 4335 rev 1 pmurev 18
>>>>>>>>> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Mar 24
>>>>>>>>> 2013
>>>>>>>>> 20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
>>>>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-23              <----
>>>>>>>>> error
>>>>>>>>> message
>>>>>>>>>
>>>>>>>>> I'm using yocto rootfs, seems rfkill is always enabled by default.
>>>>>>>>> I could try another rootfs without rfkill.
>>>>>>>>> But i don't think rfkill should block WiFi driver to work properly.
>>>>>>>>>
>>>>>>>>
>>>>>>>> I tried another rootfs without rfkill, met the same issue when doing
>>>>>>>> ifconfig wlan0 up, just like 'rfkill unblock wlan'.
>>>>>>>>
>>>>>>>> root@freescale ~$ mmc0: mmc_rescan_try_freq: trying to init card at
>>>>>>>> 400000
>>>>>>>> Hz
>>>>>>>> mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
>>>>>>>> mmc0: new high speed SDIO card at address 0001
>>>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err:
>>>>>>>> 0xffffffac
>>>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err:
>>>>>>>> 0xffffffac
>>>>>>>> brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err:
>>>>>>>> 0xffffffac
>>>>>>>> brcmfmac: brcmf_sdio_regrw_helper: failed with -84
>>>>>>>> brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength
>>>>>>>> init done for chip 4335 rev 1 pmurev 18
>>>>>>>> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Mar 24 2013
>>>>>>>> 20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
>>>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>>>>>>>
>>>>>>>> root@freescale ~$
>>>>>>>> root@freescale ~$
>>>>>>>> root@freescale ~$ ifconfig -a
>>>>>>>> ......
>>>>>>>>
>>>>>>>> wlan0     Link encap:Ethernet  HWaddr 00:90:4C:C5:12:38
>>>>>>>>              BROADCAST MULTICAST  MTU:1500  Metric:1
>>>>>>>>              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>>>>>>>              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>>>>>>>              collisions:0 txqueuelen:1000
>>>>>>>>              RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>>>>>>>>
>>>>>>>> root@freescale ~$ ifconfig wlan0 up
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>>>>>>> brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>>>>>>>> brcmfmac: brcmf_add_if: ignore IF event
>>>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>>>>>>>
>>>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>>>>>>> root@freescale ~$
>>>>>>>> root@freescale ~$
>>>>>>>> root@freescale ~$ brcmfmac: brcmf_sdioh_request_byte: Failed to
>>>>>>>> write
>>>>>>>> byte F1:@0x1001f=01, Err: -110
>>>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>>>>
>>>>>>>> root@freescale ~$ brcmfmac: brcmf_sdioh_request_byte: Failed to
>>>>>>>> write
>>>>>>>> byte F1:@0x1001f=01, Err: -110
>>>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>>>>>>> F1:@0x1001f=01, Err: -110
>>>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
>>>>>>>> F1:@0x1001f=ff, Err: -110
>>>>>>>>
>>>>>>>> I looked into a bit more about the error and found there's CMD
>>>>>>>> timeout
>>>>>>>> on the bus during SDIO
>>>>>>>> command transfer.
>>>>>>>> ---------------------------------------
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 20 00 df ff 19 00 00 0c 00 35 00 00
>>>>>>>> ........5..
>>>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> mmc0: starting CMD52 arg 92001400 flags 00000195
>>>>>>>> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00010000
>>>>>>>> mmc0: req done (CMD52): -110: 00000000 00000000 00000000 00000000
>>>>>>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>>>>>>> F1:@0x1000a=00, Err: -110
>>>>>>>> ------------------------------------------
>>>>>>>> I'm not sure how this happened, whether caused by host side or wifi
>>>>>>>> driver
>>>>>>>> side.
>>>>>>>> But for the host, i tried this host driver with another WiFi
>>>>>>>> card(Atheros AR6103) with same kernel,
>>>>>>>> and it worked well. So the host driver seems more like ok to me.
>>>>>>>>
>>>>>>>> Since i'm not familar with the WiFi driver, i wonder if you could
>>>>>>>> provide suggestion
>>>>>>>> from WiFi driver layer to see what the issue could be.
>>>>>>>>
>>>>>>>> Below is the detailed log when run 'ifconfig wlan0 up'
>>>>>>>>
>>>>>>>> root@freescale ~$ ifconfig wlan0 up
>>>>>>>> brcmfmac: brcmf_netdev_open Enter, idx=0
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmutil: TxHdr:
>>>>>>>> 00000000: 2f 00 d0 ff 10 00 00 14 00 00 00 00 00 00 00 00
>>>>>>>> /...............
>>>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>>>>
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_checkdied firmware not built with -assert
>>>>>>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 27 00 d8 ff 12 00 00 0c 00 26 00 00
>>>>>>>> '........&..
>>>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmutil: TxHdr:
>>>>>>>> 00000000: 28 00 d7 ff 11 00 00 14 00 00 00 00 00 00 00 00
>>>>>>>> (...............
>>>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>>>>>>>> ............
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 20 00 df ff 13 00 00 0c 00 32 00 00
>>>>>>>> ........2..
>>>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmutil: TxHdr:
>>>>>>>> 00000000: 28 00 d7 ff 12 00 00 14 00 00 00 00 00 00 00 00
>>>>>>>> (...............
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 10 00 ef ff 14 83 0f 0c 00 32 00 00
>>>>>>>> .........2..
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 88, sig 8
>>>>>>>> brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
>>>>>>>> brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 87, sig 8
>>>>>>>> brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
>>>>>>>> brcmfmac: brcmf_fws_notify_credit_map enter: credits
>>>>>>>> 09:27:12:09:09:02
>>>>>>>> brcmfmac: brcmf_add_if Enter, idx=0, ifidx=0
>>>>>>>> brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>>>>>>>> brcmfmac: brcmf_add_if: ignore IF event
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 20 00 df ff 17 00 00 0c 00 33 00 00
>>>>>>>> ........3..
>>>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmutil: TxHdr:
>>>>>>>> 00000000: 28 00 d7 ff 13 00 00 14 00 00 00 00 00 00 00 00
>>>>>>>> (...............
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>>>>>>>> ............
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 20 00 df ff 18 00 00 0c 00 34 00 00
>>>>>>>> ........4..
>>>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmutil: TxHdr:
>>>>>>>> 00000000: 28 00 d7 ff 14 00 00 14 00 00 00 00 00 00 00 00
>>>>>>>> (...............
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>>>>>>>> ............
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>>>>>>>> ............
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 20 00 df ff 19 00 00 0c 00 35 00 00
>>>>>>>> ........5..
>>>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmutil: TxHdr:
>>>>>>>> 00000000: 28 00 d7 ff 15 00 00 14 00 00 00 00 00 00 00 00
>>>>>>>> (...............
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
>>>>>>>> ............
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>>>>>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>>>>>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>>>>>> brcmfmac: brcmf_sdio_readframes Enter
>>>>>>>> brcmutil: RxHdr:
>>>>>>>> 00000000: 20 00 df ff 1a 00 00 0c 00 36 00 00
>>>>>>>> ........6..
>>>>>>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>>>>>> brcmfmac: brcmf_config_dongle power save set to enabled
>>>>>>>> brcmfmac: brcmf_dongle_roam Internal Roaming = On
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> It seem this is the last command being sent. Could you provide file
>>>>>>> contents
>>>>>>> in /sys/kernel/debug/brcmfmac/mmc*/
>>>>>>>
>>>>>>> Not sure if Yocto mounts debugfs on /sys/kernel/debug. Otherwise
>>>>>>> you can
>>>>>>> do:
>>>>>>>
>>>>>>> # mkdir /tmp/debugfs
>>>>>>> # mount -t debugfs none /tmp/debugfs
>>>>>>>
>>>>>>
>>>>>> Please see below:
>>>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# ls
>>>>>> counters  forensics  fws_stats
>>>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# ls -l
>>>>>> total 0
>>>>>> -r--r--r-- 1 root root 0 Sep  6 23:21 counters
>>>>>> -r--r--r-- 1 root root 0 Sep  6 23:21 forensics
>>>>>> -r--r--r-- 1 root root 0 Sep  6 23:21 fws_stats
>>>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# cat counters
>>>>>> intrcount:    19
>>>>>> lastintrs:    0
>>>>>> pollcnt:      0
>>>>>> regfails:     0
>>>>>> tx_sderrs:    0
>>>>>> fcqueued:     0
>>>>>> rxrtx:        0
>>>>>> rx_toolong:   0
>>>>>> rxc_errors:   0
>>>>>> rx_hdrfail:   0
>>>>>> rx_badhdr:    0
>>>>>> rx_badseq:    0
>>>>>> fc_rcvd:      0
>>>>>> fc_xoff:      0
>>>>>> fc_xon:       0
>>>>>> rxglomfail:   0
>>>>>> rxglomframes: 0
>>>>>> rxglompkts:   0
>>>>>> f2rxhdrs:     36
>>>>>> f2rxdata:     3
>>>>>> f2txdata:     0
>>>>>> f1regdata:    42
>>>>>> tickcnt:      53
>>>>>> tx_ctlerrs:   0
>>>>>> tx_ctlpkts:   17
>>>>>> rx_ctlerrs:   0
>>>>>> rx_ctlpkts:   17
>>>>>> rx_readahead: 0
>>>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# cat forensics
>>>>>>
>>>>>> RTE (USB-SDIO-CDC) 6.30.171.24.20 (B0 Station/P2P) on BCM4335 r1 @
>>>>>> 37.4/161.3/161.3MHz
>>>>>> 000000.011 sdpcmdcdc0: Broadcom SDPCMD CDC driver
>>>>>> 000000.018 reclaim section 0: Returned 42772 bytes to the heap
>>>>>> 000000.061 wl0: Broadcom BCM4335 802.11 Wireless Controller
>>>>>> 6.30.171.24.20 (B0 Station/P2P)
>>>>>> 000000.070 reclaim section 1: Returned 62128 bytes to the heap
>>>>>> 000000.209 wl0: wlc_enable_probe_req: state down, deferring setting of
>>>>>> host flags
>>>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# ring setting of
>>>>>> host flags
>>>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1# cat fws_stats
>>>>>> header_pulls:      0
>>>>>> header_only_pkt:   0
>>>>>> tlv_parse_failed:  0
>>>>>> tlv_invalid_type:  0
>>>>>> mac_update_fails:  0
>>>>>> ps_update_fails:   0
>>>>>> if_update_fails:   0
>>>>>> pkt2bus:           0
>>>>>> generic_error:     0
>>>>>> rollback_success:  0
>>>>>> rollback_failed:   0
>>>>>> delayq_full:       0
>>>>>> supprq_full:       0
>>>>>> txs_indicate:      0
>>>>>> txs_discard:       0
>>>>>> txs_suppr_core:    0
>>>>>> txs_suppr_ps:      0
>>>>>> txs_tossed:        0
>>>>>> txs_host_tossed:   0
>>>>>> bus_flow_block:    0
>>>>>> fws_flow_block:    0
>>>>>> send_pkts:         BK:0 BE:0 VO:0 VI:0 BCMC:0
>>>>>> requested_sent:    BK:0 BE:0 VO:0 VI:0 BCMC:0
>>>>>> root@imx6slevk:/sys/kernel/debug/brcmfmac/mmc0:0001:1#
>>>>>
>>>>>
>>>>>
>>>>> Nothing exciting there either. Let's take a step back. The rfkill
>>>>> seems an
>>>>> issue, but I first would like to know if you can get connectivity.
>>>>> Does the
>>>>> 'ifconfig wlan0 up' complete at all and is it successful.
>>>>>
>>>>
>>>> The second rootfs i tried does not have rfkill.
>>>> But shows the similar issue with 'ifconfig wlan0 up'.
>>>>
>>>>> As you noticed during the up sequence there is a timeout. I would
>>>>> like to
>>>>> know what command that is. Could you run it again with debug=1546?
>>>>>
>>>>
>>>> Will run the test now.
>>>> Thanks for the help.
>>>>
>>>
>>> Please see blow log:
>>> Note: there's no rfkill in this rootfs.
>>>
>>> root@freescale ~$ ifconfgi  ig wlan0
>>> brcmfmac: brcmf_netdev_get_stats Enter, idx=0
>>> wlan0     Link encap:Ethernet  HWaddr 00:90:4C:C5:12:38
>>>            BROADCAST MULTICAST  MTU:1500  Metric:1
>>>            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>>            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>>            collisions:0 txqueuelen:1000
>>>            RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>>>
>>> root@freescale ~$ ifconfig wlan0 up
>>> brcmfmac: brcmf_netdev_open Enter, idx=0
>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmutil: TxHdr:
>>> 00000000: 2f 00 d0 ff 10 00 00 14 00 00 00 00 00 00 00 00
>>> /...............
>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>>
>>> <--------- I noticed a few seconds stall here
>>>
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdio_readframes Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_checkdied firmware not built with -assert
>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>> brcmfmac: brcmf_fil_iovar_data_get name=toe_ol, len=4
>>> brcmutil: data
>>> 00000000: 28 aa 49 80                                      (.I.
>>>
>>> brcmutil: RxHdr:
>>> 00000000: 27 00 d8 ff 12 00 00 0c 00 26 00 00              '........&..
>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>> brcmfmac: brcmf_fil_cmd_int_set cmd=2, value=0
>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmutil: TxHdr:
>>> 00000000: 28 00 d7 ff 11 00 00 14 00 00 00 00 00 00 00 00
>>> (...............
>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmutil: RxHdr:
>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdio_readframes Enter
>>> brcmutil: RxHdr:
>>> 00000000: 20 00 df ff 13 00 00 0c 00 32 00 00               ........2..
>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>>
>>> brcmfmac: brcmf_fil_cmd_int_set cmd=185, value=40
>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmutil: TxHdr:
>>> 00000000: 28 00 d7 ff 12 00 00 14 00 00 00 00 00 00 00 00
>>> (...............
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> brcmutil: RxHdr:
>>> 00000000: 10 00 ef ff 14 83 0f 0c 00 32 00 00              .........2..
>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>> brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 88, sig 8
>>> brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
>>> brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 87, sig 8
>>> brcmfmac: brcmf_fws_hdrpull tlv type=TRANS_ID (18), len=6 (6)
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_fweh_event_worker event FIFO_CREDIT_MAP (74) ifidx 0
>>> bsscfg 0 addr 80:80:80:80:80:80
>>> brcmfmac: brcmf_fweh_event_worker   version 2 flags 24 status 0 reason 0
>>> brcmutil: event payload, len=6
>>> 00000000: 09 27 12 09 09 02                                .'....
>>> brcmfmac: brcmf_fws_notify_credit_map enter: credits 09:27:12:09:09:02
>>> brcmfmac: brcmf_fweh_event_worker event IF (54) ifidx 0 bsscfg 0 addr
>>> 00:90:4c:c5:12:38
>>> brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 0 reason 0
>>> brcmutil: event payload, len=5
>>> 00000000: 00 01 00 00 00                                   .....
>>> brcmfmac: brcmf_fweh_handle_if_event action: 1 idx: 0 bsscfg: 0 flags:
>>> 0 role: 0
>>> brcmfmac: brcmf_fweh_handle_if_event adding wl0 (00:90:4c:c5:12:38)
>>> brcmfmac: brcmf_add_if Enter, idx=0, ifidx=0
>>> brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>>> brcmfmac: brcmf_add_if: ignore IF event
>>> brcmutil: RxHdr:
>>> 00000000: 20 00 df ff 17 00 00 0c 00 33 00 00               ........3..
>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>> brcmfmac: brcmf_fil_cmd_int_set cmd=187, value=40
>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmutil: RxHdr:
>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmutil: TxHdr:
>>> 00000000: 28 00 d7 ff 13 00 00 14 00 00 00 00 00 00 00 00
>>> (...............
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdio_readframes Enter
>>> brcmutil: RxHdr:
>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> .......
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdio_readframes Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_checkdied firmware not built with -assert
>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>> brcmfmac: brcmf_dongle_scantime: Scan unassoc time error (-110)
>>> brcmutil: RxHdr:
>>> 00000000: 20 00 df ff 18 00 00 0c 00 34 00 00               ........4..
>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>> brcmfmac: brcmf_fil_cmd_int_set cmd=86, value=2
>>> brcmfmac: brcmf_sdbrcm_bus_txctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmutil: RxHdr:
>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmutil: TxHdr:
>>> 00000000: 28 00 d7 ff 14 00 00 14 00 00 00 00 00 00 00 00
>>> (...............
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> .................................
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdio_readframes Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_checkdied firmware not built with -assert
>>> brcmfmac: brcmf_fil_cmd_data: Failed err=-110
>>> brcmfmac: brcmf_netdev_open: failed to bring up cfg80211
>>> brcmutil: RxHdr:
>>> 00000000: 20 00 df ff 19 00 00 0c 00 35 00 00               ........5..
>>> brcmfmac: brcmf_sdbrcm_read_control Enter
>>> ifconfig: SIOCSIFFLAGS: Operationbrcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>>   not permitted
>>> root@freescale ~$ brcmfmac: brcmf_sdio_readframes: RXHEADER FAILED: -110
>>>
>>> brcmfmac: brcmf_sdbrcm_rxfail: abort command, terminate frame, send NAK
>>> root@freescale ~$
>>> root@freescale ~$ brcmfmac: brcmf_sdioh_request_word: Failed to write
>>> word, Err: 0xffffff92
>>>
>>> root@freescale ~$
>>> root@freescale ~$
>>> root@freescale ~$ brcmfmac: brcmf_sdioh_request_word: Failed to write
>>> word, Err: 0xffffff92
>>>
>>> root@freescale ~$ brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
>>> brcmfmac: brcmf_sdio_readframes Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmutil: RxHdr:
>>> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>>> F1:@0x1001f=01, Err: -110
>>> brcmfmac: brcmf_sdio_ib_irqhandler IB intr triggered
>>> brcmfmac: brcmf_sdbrcm_isr Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_kso_control Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>> brcmfmac: brcmf_sdbrcm_bus_sleep Enter
>>
>>
>> One more question. I looked up the board you mentioined. What I found
>> has a dedicated SDIO slot for Wifi. Are you using that and do you know
>> if that is an SDIO3.0 or not? Earlier in the thread i found this logging:
>>
>>  > root@imx6slevk:~# mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
>>  > mmc0: new high speed SDIO card at address 0001
>>
>> I think it means it is a SDIO2, but I like to be sure.
>
>
> And just for the hack of it. Can you send your .config and a full kernel log
> (as attachments).
>
>

Please see attachment.

Regards
Dong Aisheng

>> Gr. AvS
>>
>>> Regards
>>> Dong Aisheng
>>>
>>
>
>

--001a11c305a40e212104ea7fe0a0
Content-Type: text/x-log; charset=US-ASCII; name="minicom-1106-sl-1.log"
Content-Disposition: attachment; filename="minicom-1106-sl-1.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hnofvfle0

CgpVLUJvb3QgMjAxMy4wNCAoU2VwIDA2IDIwMTMgLSAxMjowNzowNSkKCkNQVTogICBGcmVlc2Nh
bGUgaS5NWDZTTCByZXYxLjIgYXQgMzk2IE1IegpDUFU6ICAgVGVtcGVyYXR1cmUgNDMgQywgY2Fs
aWJyYXRpb24gZGF0YTogMHg1OTU1MTI1ZgpSZXNldCBjYXVzZTogUE9SCkJvYXJkOiBNWDZTTEVW
SwpJMkM6ICAgcmVhZHkKRFJBTTogIDEgR2lCCk1NQzogICBGU0xfU0RIQzogMApJbjogICAgc2Vy
aWFsCk91dDogICBzZXJpYWwKRXJyOiAgIHNlcmlhbApGb3VuZCBQRlVaRTEwMCEgZGV2aWNlaWQ9
MTAscmV2aWQ9MTEKTmV0OiAgIEZFQyBbUFJJTUVdCk5vcm1hbCBCb290CkhpdCBhbnkga2V5IHRv
IHN0b3AgYXV0b2Jvb3Q6ICAzIAgICCAyIAgICCAxIAgICCAwIApCb290aW5nIGZyb20gbmV0IC4u
LgpVc2luZyBGRUMgZGV2aWNlClRGVFAgZnJvbSBzZXJ2ZXIgMTAuMTkyLjIyNC40NDsgb3VyIElQ
IGFkZHJlc3MgaXMgMTAuMTkyLjI0Mi4xNTM7IHNlbmRpbmcgdGhyb3VnaCBnYXRld2F5IDEwLjE5
Mi4yNDIuMjU0CkZpbGVuYW1lICd6SW1hZ2UuYXMuaW14Jy4KTG9hZCBhZGRyZXNzOiAweDgwODAw
MDAwCkxvYWRpbmc6ICoIIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKCSAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwoJICMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCgkgIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMK
CSAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIwoJICMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjCgkgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKCSAjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwoJICMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCgkg
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMKCSAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIwoJICMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCgkgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKCSAjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKCSA4ODEuOCBLaUIvcwpk
b25lCkJ5dGVzIHRyYW5zZmVycmVkID0gNDYwMTczNiAoNDYzNzg4IGhleCkKVXNpbmcgRkVDIGRl
dmljZQpURlRQIGZyb20gc2VydmVyIDEwLjE5Mi4yMjQuNDQ7IG91ciBJUCBhZGRyZXNzIGlzIDEw
LjE5Mi4yNDIuMTUzOyBzZW5kaW5nIHRocm91Z2ggZ2F0ZXdheSAxMC4xOTIuMjQyLjI1NApGaWxl
bmFtZSAnaW14NnNsLWV2ay5kdGInLgpMb2FkIGFkZHJlc3M6IDB4ODI4MDAwMDAKTG9hZGluZzog
KggjIyMjCgkgNjU1LjMgS2lCL3MKZG9uZQpCeXRlcyB0cmFuc2ZlcnJlZCA9IDE2MTE4ICgzZWY2
IGhleCkKIyMgRmxhdHRlbmVkIERldmljZSBUcmVlIGJsb2IgYXQgODI4MDAwMDAKICAgQm9vdGlu
ZyB1c2luZyB0aGUgZmR0IGJsb2IgYXQgMHg4MjgwMDAwMAogICBVc2luZyBEZXZpY2UgVHJlZSBp
biBwbGFjZSBhdCA4MjgwMDAwMCwgZW5kIDgyODA2ZWY1CgpTdGFydGluZyBrZXJuZWwgLi4uCgpC
b290aW5nIExpbnV4IG9uIHBoeXNpY2FsIENQVSAweDAKTGludXggdmVyc2lvbiAzLjEyLjAtcmMz
KyAoYjI5Mzk2QHNobGludXgyKSAoZ2NjIHZlcnNpb24gNC42LjIgMjAxMTA2MzAgKHByZXJlbGVh
c2UpIChGcmVlc2NhbGUgTUFEIC0tIExpbmFybyAyMDExLjA3IC0tIEJ1aWx0IGF0IDIwMTEvMDgv
MTAgMDk6MjApICkgIzI0MCBTTVAgVHVlIE5vdiA1IDE2OjQyOjA1IENTVCAyMDEzCkNQVTogQVJN
djcgUHJvY2Vzc29yIFs0MTJmYzA5YV0gcmV2aXNpb24gMTAgKEFSTXY3KSwgY3I9MTBjNTNjN2QK
Q1BVOiBQSVBUIC8gVklQVCBub25hbGlhc2luZyBkYXRhIGNhY2hlLCBWSVBUIGFsaWFzaW5nIGlu
c3RydWN0aW9uIGNhY2hlCk1hY2hpbmU6IEZyZWVzY2FsZSBpLk1YNiBTb2xvTGl0ZSAoRGV2aWNl
IFRyZWUpLCBtb2RlbDogRnJlZXNjYWxlIGkuTVg2IFNvbG9MaXRlIEVWSyBCb2FyZApNZW1vcnkg
cG9saWN5OiBFQ0MgZGlzYWJsZWQsIERhdGEgY2FjaGUgd3JpdGVhbGxvYwpQRVJDUFU6IEVtYmVk
ZGVkIDcgcGFnZXMvY3B1IEA4MTA5ODAwMCBzNzQ4OCByODE5MiBkMTI5OTIgdTMyNzY4CkJ1aWx0
IDEgem9uZWxpc3RzIGluIFpvbmUgb3JkZXIsIG1vYmlsaXR5IGdyb3VwaW5nIG9uLiAgVG90YWwg
cGFnZXM6IDI2MDA5NgpLZXJuZWwgY29tbWFuZCBsaW5lOiBjb25zb2xlPXR0eW14YzAsMTE1MjAw
IHJvb3Q9L2Rldi9uZnMgaXA9ZGhjcCBuZnNyb290PTEwLjE5Mi4yMjQuNDQ6L2RhdGEvcm9vdGZz
X2hvbWUvYjI5Mzk2L3Jvb3Rmcy1teDZ4LXVwLHYzLHRjcCBicmNtZm1hYy5kZWJ1Zz0weDE1NDYK
UElEIGhhc2ggdGFibGUgZW50cmllczogNDA5NiAob3JkZXI6IDIsIDE2Mzg0IGJ5dGVzKQpEZW50
cnkgY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAxMzEwNzIgKG9yZGVyOiA3LCA1MjQyODggYnl0
ZXMpCklub2RlLWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogNjU1MzYgKG9yZGVyOiA2LCAyNjIx
NDQgYnl0ZXMpCk1lbW9yeTogMTAzMDc0MEsvMTA0ODU3NksgYXZhaWxhYmxlICg1OTE5SyBrZXJu
ZWwgY29kZSwgMjg3SyByd2RhdGEsIDE4MDhLIHJvZGF0YSwgMzIzSyBpbml0LCAzNzVLIGJzcywg
MTc4MzZLIHJlc2VydmVkKQpWaXJ0dWFsIGtlcm5lbCBtZW1vcnkgbGF5b3V0OgogICAgdmVjdG9y
ICA6IDB4ZmZmZjAwMDAgLSAweGZmZmYxMDAwICAgKCAgIDQga0IpCiAgICBmaXhtYXAgIDogMHhm
ZmYwMDAwMCAtIDB4ZmZmZTAwMDAgICAoIDg5NiBrQikKICAgIHZtYWxsb2MgOiAweGMwODAwMDAw
IC0gMHhmZjAwMDAwMCAgICgxMDAwIE1CKQogICAgbG93bWVtICA6IDB4ODAwMDAwMDAgLSAweGMw
MDAwMDAwICAgKDEwMjQgTUIpCiAgICBtb2R1bGVzIDogMHg3ZjAwMDAwMCAtIDB4ODAwMDAwMDAg
ICAoICAxNiBNQikKICAgICAgLnRleHQgOiAweDgwMDA4MDAwIC0gMHg4MDc5M2YyNCAgICg3NzI4
IGtCKQogICAgICAuaW5pdCA6IDB4ODA3OTQwMDAgLSAweDgwN2U0ZDQwICAgKCAzMjQga0IpCiAg
ICAgIC5kYXRhIDogMHg4MDdlNjAwMCAtIDB4ODA4MmRjNjAgICAoIDI4OCBrQikKICAgICAgIC5i
c3MgOiAweDgwODJkYzY4IC0gMHg4MDg4YmFlYyAgICggMzc2IGtCKQpTTFVCOiBIV2FsaWduPTY0
LCBPcmRlcj0wLTMsIE1pbk9iamVjdHM9MCwgQ1BVcz0xLCBOb2Rlcz0xCkhpZXJhcmNoaWNhbCBS
Q1UgaW1wbGVtZW50YXRpb24uCglSQ1UgcmVzdHJpY3RpbmcgQ1BVcyBmcm9tIE5SX0NQVVM9NCB0
byBucl9jcHVfaWRzPTEuCk5SX0lSUVM6MTYgbnJfaXJxczoxNiAxNgpMMzEwIGNhY2hlIGNvbnRy
b2xsZXIgZW5hYmxlZApsMngwOiAxNiB3YXlzLCBDQUNIRV9JRCAweDQxMDAwMGM4LCBBVVhfQ1RS
TCAweDMyMDMwMDAwLCBDYWNoZSBzaXplOiAyNTYga0IKc2NoZWRfY2xvY2s6IDMyIGJpdHMgYXQg
NDlNSHosIHJlc29sdXRpb24gMjBucywgd3JhcHMgZXZlcnkgODY3NjdtcwpDb25zb2xlOiBjb2xv
dXIgZHVtbXkgZGV2aWNlIDgweDMwCkNhbGlicmF0aW5nIGRlbGF5IGxvb3AuLi4gNzg5LjcwIEJv
Z29NSVBTIChscGo9Mzk0ODU0NCkKcGlkX21heDogZGVmYXVsdDogMzI3NjggbWluaW11bTogMzAx
Ck1vdW50LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogNTEyCkNQVTogVGVzdGluZyB3cml0ZSBi
dWZmZXIgY29oZXJlbmN5OiBvawpDUFUwOiB0aHJlYWQgLTEsIGNwdSAwLCBzb2NrZXQgMCwgbXBp
ZHIgODAwMDAwMDAKU2V0dGluZyB1cCBzdGF0aWMgaWRlbnRpdHkgbWFwIGZvciAweDgwNWNlMDcw
IC0gMHg4MDVjZTBlMApCcm91Z2h0IHVwIDEgQ1BVcwpTTVA6IFRvdGFsIG9mIDEgcHJvY2Vzc29y
cyBhY3RpdmF0ZWQuCkNQVTogQWxsIENQVShzKSBzdGFydGVkIGluIFNWQyBtb2RlLgpkZXZ0bXBm
czogaW5pdGlhbGl6ZWQKVkZQIHN1cHBvcnQgdjAuMzogaW1wbGVtZW50b3IgNDEgYXJjaGl0ZWN0
dXJlIDMgcGFydCAzMCB2YXJpYW50IDkgcmV2IDQKcGluY3RybCBjb3JlOiBpbml0aWFsaXplZCBw
aW5jdHJsIHN1YnN5c3RlbQpyZWd1bGF0b3ItZHVtbXk6IG5vIHBhcmFtZXRlcnMKTkVUOiBSZWdp
c3RlcmVkIHByb3RvY29sIGZhbWlseSAxNgpETUE6IHByZWFsbG9jYXRlZCAyNTYgS2lCIHBvb2wg
Zm9yIGF0b21pYyBjb2hlcmVudCBhbGxvY2F0aW9ucwpzeXNjb24gMjBjODAwMC5hbmF0b3A6IHJl
Z21hcCBbbWVtIDB4MDIwYzgwMDAtMHgwMjBjOGZmZl0gcmVnaXN0ZXJlZAp2ZGQxcDE6IDgwMCA8
LS0+IDEzNzUgbVYgYXQgMTEwMCBtViAKdmRkM3AwOiAyODAwIDwtLT4gMzE1MCBtViBhdCAzMDAw
IG1WIAp2ZGQycDU6IDIxMDAgPC0tPiAyODUwIG1WIGF0IDI1MDAgbVYgCmNwdTogNzI1IDwtLT4g
MTQ1MCBtViBhdCAxMTAwIG1WIAp2ZGRwdTogNzI1IDwtLT4gMTQ1MCBtViAKdmRkc29jOiA3MjUg
PC0tPiAxNDUwIG1WIGF0IDEyMDAgbVYgCmh3LWJyZWFrcG9pbnQ6IGZvdW5kIDUgKCsxIHJlc2Vy
dmVkKSBicmVha3BvaW50IGFuZCAxIHdhdGNocG9pbnQgcmVnaXN0ZXJzLgpody1icmVha3BvaW50
OiBtYXhpbXVtIHdhdGNocG9pbnQgc2l6ZSBpcyA0IGJ5dGVzLgppbXg2c2wtcGluY3RybCAyMGUw
MDAwLmlvbXV4YzogaW5pdGlhbGl6ZWQgSU1YIHBpbmN0cmwgZHJpdmVyCmJpbzogY3JlYXRlIHNs
YWIgPGJpby0wPiBhdCAwClNDU0kgc3Vic3lzdGVtIGluaXRpYWxpemVkCnVzYmNvcmU6IHJlZ2lz
dGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiZnMKdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcg
aW50ZXJmYWNlIGRyaXZlciBodWIKdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgZGV2aWNlIGRyaXZl
ciB1c2IKTGludXggdmlkZW8gY2FwdHVyZSBpbnRlcmZhY2U6IHYyLjAwCnBwc19jb3JlOiBMaW51
eFBQUyBBUEkgdmVyLiAxIHJlZ2lzdGVyZWQKcHBzX2NvcmU6IFNvZnR3YXJlIHZlci4gNS4zLjYg
LSBDb3B5cmlnaHQgMjAwNS0yMDA3IFJvZG9sZm8gR2lvbWV0dGkgPGdpb21ldHRpQGxpbnV4Lml0
PgpQVFAgY2xvY2sgc3VwcG9ydCByZWdpc3RlcmVkCkFkdmFuY2VkIExpbnV4IFNvdW5kIEFyY2hp
dGVjdHVyZSBEcml2ZXIgSW5pdGlhbGl6ZWQuClN3aXRjaGVkIHRvIGNsb2Nrc291cmNlIG14Y190
aW1lcjEKY2ZnODAyMTE6IENhbGxpbmcgQ1JEQSB0byB1cGRhdGUgd29ybGQgcmVndWxhdG9yeSBk
b21haW4KTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAyClRDUCBlc3RhYmxpc2hlZCBo
YXNoIHRhYmxlIGVudHJpZXM6IDgxOTIgKG9yZGVyOiA0LCA2NTUzNiBieXRlcykKVENQIGJpbmQg
aGFzaCB0YWJsZSBlbnRyaWVzOiA4MTkyIChvcmRlcjogNCwgNjU1MzYgYnl0ZXMpClRDUDogSGFz
aCB0YWJsZXMgY29uZmlndXJlZCAoZXN0YWJsaXNoZWQgODE5MiBiaW5kIDgxOTIpClRDUDogcmVu
byByZWdpc3RlcmVkClVEUCBoYXNoIHRhYmxlIGVudHJpZXM6IDUxMiAob3JkZXI6IDIsIDE2Mzg0
IGJ5dGVzKQpVRFAtTGl0ZSBoYXNoIHRhYmxlIGVudHJpZXM6IDUxMiAob3JkZXI6IDIsIDE2Mzg0
IGJ5dGVzKQpORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5IDEKUlBDOiBSZWdpc3RlcmVk
IG5hbWVkIFVOSVggc29ja2V0IHRyYW5zcG9ydCBtb2R1bGUuClJQQzogUmVnaXN0ZXJlZCB1ZHAg
dHJhbnNwb3J0IG1vZHVsZS4KUlBDOiBSZWdpc3RlcmVkIHRjcCB0cmFuc3BvcnQgbW9kdWxlLgpS
UEM6IFJlZ2lzdGVyZWQgdGNwIE5GU3Y0LjEgYmFja2NoYW5uZWwgdHJhbnNwb3J0IG1vZHVsZS4K
aHcgcGVyZmV2ZW50czogZW5hYmxlZCB3aXRoIEFSTXY3IENvcnRleC1BOSBQTVUgZHJpdmVyLCA3
IGNvdW50ZXJzIGF2YWlsYWJsZQpWRlM6IERpc2sgcXVvdGFzIGRxdW90XzYuNS4yCkRxdW90LWNh
Y2hlIGhhc2ggdGFibGUgZW50cmllczogMTAyNCAob3JkZXIgMCwgNDA5NiBieXRlcykKTkZTOiBS
ZWdpc3RlcmluZyB0aGUgaWRfcmVzb2x2ZXIga2V5IHR5cGUKS2V5IHR5cGUgaWRfcmVzb2x2ZXIg
cmVnaXN0ZXJlZApLZXkgdHlwZSBpZF9sZWdhY3kgcmVnaXN0ZXJlZApqZmZzMjogdmVyc2lvbiAy
LjIuIChOQU5EKSDCqSAyMDAxLTIwMDYgUmVkIEhhdCwgSW5jLgpmdXNlIGluaXQgKEFQSSB2ZXJz
aW9uIDcuMjIpCm1zZ21uaSBoYXMgYmVlbiBzZXQgdG8gMjAxMwppbyBzY2hlZHVsZXIgbm9vcCBy
ZWdpc3RlcmVkCmlvIHNjaGVkdWxlciBkZWFkbGluZSByZWdpc3RlcmVkCmlvIHNjaGVkdWxlciBj
ZnEgcmVnaXN0ZXJlZCAoZGVmYXVsdCkKaW14LXNkbWEgMjBlYzAwMC5zZG1hOiBpbml0aWFsaXpl
ZApTZXJpYWw6IElNWCBkcml2ZXIKMjAyMDAwMC5zZXJpYWw6IHR0eW14YzAgYXQgTU1JTyAweDIw
MjAwMDAgKGlycSA9IDU4LCBiYXNlX2JhdWQgPSA1MDAwMDAwKSBpcyBhIElNWApjb25zb2xlIFt0
dHlteGMwXSBlbmFibGVkCnNlcmlhbDogRnJlZXNjYWxlIGxwdWFydCBkcml2ZXIKW2RybV0gSW5p
dGlhbGl6ZWQgZHJtIDEuMS4wIDIwMDYwODEwCmJyZDogbW9kdWxlIGxvYWRlZApsb29wOiBtb2R1
bGUgbG9hZGVkCmxpYnBoeTogZmVjX2VuZXRfbWlpX2J1czogcHJvYmVkCmVoY2lfaGNkOiBVU0Ig
Mi4wICdFbmhhbmNlZCcgSG9zdCBDb250cm9sbGVyIChFSENJKSBEcml2ZXIKZWhjaS1teGM6IEZy
ZWVzY2FsZSBPbi1DaGlwIEVIQ0kgSG9zdCBkcml2ZXIKdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcg
aW50ZXJmYWNlIGRyaXZlciB1c2Itc3RvcmFnZQptb3VzZWRldjogUFMvMiBtb3VzZSBkZXZpY2Ug
Y29tbW9uIGZvciBhbGwgbWljZQpzbnZzX3J0YyAyMGNjMDM0LnNudnMtcnRjLWxwOiBydGMgY29y
ZTogcmVnaXN0ZXJlZCAyMGNjMDM0LnNudnMtcnRjLWxwIGFzIHJ0YzAKaTJjIC9kZXYgZW50cmll
cyBkcml2ZXIKaW14Mi13ZHQgMjBiYzAwMC53ZG9nOiBJTVgyKyBXYXRjaGRvZyBUaW1lciBlbmFi
bGVkLiB0aW1lb3V0PTYwcyAobm93YXlvdXQ9MCkKc2RoY2k6IFNlY3VyZSBEaWdpdGFsIEhvc3Qg
Q29udHJvbGxlciBJbnRlcmZhY2UgZHJpdmVyCnNkaGNpOiBDb3B5cmlnaHQoYykgUGllcnJlIE9z
c21hbgpzZGhjaS1wbHRmbTogU0RIQ0kgcGxhdGZvcm0gYW5kIE9GIGRyaXZlciBoZWxwZXIKbW1j
MDogbm8gdnFtbWMgcmVndWxhdG9yIGZvdW5kCm1tYzA6IG5vIHZtbWMgcmVndWxhdG9yIGZvdW5k
Cm1tYzA6IFNESENJIGNvbnRyb2xsZXIgb24gMjE5MDAwMC51c2RoYyBbMjE5MDAwMC51c2RoY10g
dXNpbmcgQURNQQptbWMxOiBubyB2cW1tYyByZWd1bGF0b3IgZm91bmQKbW1jMTogbm8gdm1tYyBy
ZWd1bGF0b3IgZm91bmQKbW1jMTogU0RIQ0kgY29udHJvbGxlciBvbiAyMTk0MDAwLnVzZGhjIFsy
MTk0MDAwLnVzZGhjXSB1c2luZyBBRE1BCm1tYzI6IG5vIHZxbW1jIHJlZ3VsYXRvciBmb3VuZApt
bWMyOiBubyB2bW1jIHJlZ3VsYXRvciBmb3VuZAptbWMyOiBTREhDSSBjb250cm9sbGVyIG9uIDIx
OTgwMDAudXNkaGMgWzIxOTgwMDAudXNkaGNdIHVzaW5nIEFETUEKdXNiY29yZTogcmVnaXN0ZXJl
ZCBuZXcgaW50ZXJmYWNlIGRyaXZlciB1c2JoaWQKdXNiaGlkOiBVU0IgSElEIGNvcmUgZHJpdmVy
Cltkcm1dIFN1cHBvcnRzIHZibGFuayB0aW1lc3RhbXAgY2FjaGluZyBSZXYgMSAoMTAuMTAuMjAx
MCkuCltkcm1dIE5vIGRyaXZlciBzdXBwb3J0IGZvciB2YmxhbmsgdGltZXN0YW1wIHF1ZXJ5Lgpb
ZHJtXSBJbml0aWFsaXplZCBpbXgtZHJtIDEuMC4wIDIwMTIwNTA3IG9uIG1pbm9yIDAKVENQOiBj
dWJpYyByZWdpc3RlcmVkCk5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMTAKc2l0OiBJ
UHY2IG92ZXIgSVB2NCB0dW5uZWxpbmcgZHJpdmVyCk5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBm
YW1pbHkgMTcKS2V5IHR5cGUgZG5zX3Jlc29sdmVyIHJlZ2lzdGVyZWQKc252c19ydGMgMjBjYzAz
NC5zbnZzLXJ0Yy1scDogc2V0dGluZyBzeXN0ZW0gY2xvY2sgdG8gMTk3MC0wMS0wMSAwMDowMDow
MCBVVEMgKDApCmlteC1kcm0gaW14LWRybTogTm8gY29ubmVjdG9ycyByZXBvcnRlZCBjb25uZWN0
ZWQgd2l0aCBtb2RlcwpbZHJtXSBDYW5ub3QgZmluZCBhbnkgY3J0YyBvciBzaXplcyAtIGdvaW5n
IDEwMjR4NzY4CkNvbnNvbGU6IHN3aXRjaGluZyB0byBjb2xvdXIgZnJhbWUgYnVmZmVyIGRldmlj
ZSAxMjh4NDgKaW14LWRybSBpbXgtZHJtOiBmYjA6ICBmcmFtZSBidWZmZXIgZGV2aWNlCmlteC1k
cm0gaW14LWRybTogcmVnaXN0ZXJlZCBwYW5pYyBub3RpZmllcgptbWMxOiBuZXcgaGlnaCBzcGVl
ZCBTREhDIGNhcmQgYXQgYWRkcmVzcyBhYWFhCmZlYyAyMTg4MDAwLmV0aGVybmV0IGV0aDA6IEZy
ZWVzY2FsZSBGRUMgUEhZIGRyaXZlciBbR2VuZXJpYyBQSFldIChtaWlfYnVzOnBoeV9hZGRyPTIx
ODgwMDAuZXRoZXJuZXQ6MDAsIGlycT0tMSkKbW1jYmxrMDogbW1jMTphYWFhIFNVMDhHIDcuNDAg
R2lCIApJUHY2OiBBRERSQ09ORihORVRERVZfVVApOiBldGgwOiBsaW5rIGlzIG5vdCByZWFkeQog
bW1jYmxrMDogcDEgcDIKbGlicGh5OiAyMTg4MDAwLmV0aGVybmV0OjAwIC0gTGluayBpcyBVcCAt
IDEwMC9GdWxsCklQdjY6IEFERFJDT05GKE5FVERFVl9DSEFOR0UpOiBldGgwOiBsaW5rIGJlY29t
ZXMgcmVhZHkKU2VuZGluZyBESENQIHJlcXVlc3RzIC4sIE9LCklQLUNvbmZpZzogR290IERIQ1Ag
YW5zd2VyIGZyb20gMTAuMTkyLjI0Mi4yNTIsIG15IGFkZHJlc3MgaXMgMTAuMTkyLjI0Mi42OQpJ
UC1Db25maWc6IENvbXBsZXRlOgogICAgIGRldmljZT1ldGgwLCBod2FkZHI9MDA6MDQ6OWY6MDI6
NzY6ZTUsIGlwYWRkcj0xMC4xOTIuMjQyLjY5LCBtYXNrPTI1NS4yNTUuMjU1LjAsIGd3PTEwLjE5
Mi4yNDIuMjU0CiAgICAgaG9zdD0xMC4xOTIuMjQyLjY5LCBkb21haW49YXAuZnJlZXNjYWxlLm5l
dCwgbmlzLWRvbWFpbj0obm9uZSkKICAgICBib290c2VydmVyPTAuMC4wLjAsIHJvb3RzZXJ2ZXI9
MTAuMTkyLjIyNC40NCwgcm9vdHBhdGg9CiAgICAgbmFtZXNlcnZlcjA9MTAuMTkyLjEzMC4yMDEs
IG5hbWVzZXJ2ZXIxPTEwLjIxMS4wLjMsIG5hbWVzZXJ2ZXIyPTEwLjE5Ni41MS4yMDAKQUxTQSBk
ZXZpY2UgbGlzdDoKICBObyBzb3VuZGNhcmRzIGZvdW5kLgpWRlM6IE1vdW50ZWQgcm9vdCAobmZz
IGZpbGVzeXN0ZW0pIHJlYWRvbmx5IG9uIGRldmljZSAwOjExLgpkZXZ0bXBmczogbW91bnRlZApG
cmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiAzMjBLICg4MDc5NDAwMCAtIDgwN2U0MDAwKQpz
dGFydGluZyBwaWQgNTAsIHR0eSAnJzogJy9ldGMvcmMuZC9yY1MnCk1vdW50aW5nIC9wcm9jIGFu
ZCAvc3lzIApTdGFydGluZyB0aGUgaG90cGx1ZyBldmVudHMgZGlzcGF0Y2hlciB1ZGV2ZApTeW50
aGVzaXppbmcgaW5pdGlhbCBob3RwbHVnIGV2ZW51ZGV2ZCAoNTkpOiAvcHJvYy81OS9vb21fYWRq
IGlzIGRlcHJlY2F0ZWQsIHBsZWFzZSB1c2UgL3Byb2MvNTkvb29tX3Njb3JlX2FkaiBpbnN0ZWFk
Lgp0cwppbXgtc2RtYSAyMGVjMDAwLnNkbWE6IGZpcm13YXJlIG5vdCBmb3VuZApTZXR0aW5nIHRo
ZSBob3N0bmFtZSB0byBmcmVlc2NhbGUKTW91bnRpbmcgZmlsZXN5c3RlbXMKbW91bnQ6IG1vdW50
aW5nIHVzYmZzIG9uIC9wcm9jL2J1cy91c2IgZmFpbGVkOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0
b3J5CkdlbmVyYXRpbmcga2V5cyBmb3IgdGhlIGRyb3BiZWFyIHNzaCBzZXJ2ZXI6IAovZXRjL3Jj
LmQvaW5pdC5kL2Ryb3BiZWFyOiBsaW5lIDI0OiBkcm9wYmVhcmtleTogbm90IGZvdW5kClN0YXJ0
aW5nIHRoZSBkcm9wYmVhciBzc2ggc2VydmVyOiAKL3Vzci9zYmluL2Ryb3BiZWFyOiBlcnJvciB3
aGlsZSBsb2FkaW5nIHNoYXJlZCBsaWJyYXJpZXM6IGxpYnouc28uMTogY2Fubm90IG9wZW4gc2hh
cmVkIG9iamVjdCBmaWxlOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Cmd0azogY3JlYXRpbmcg
Z2RrLXBpeGJ1Zi5sb2FkZXJzCnBhbmdvOiBjcmVhdGluZyBtb2R1bGUgbGlzdApzdGFydGluZyBw
aWQgNTMyLCB0dHkgJyc6ICcvZXRjL3JjLmQvcmNfbXhjLlMnCgphcm0tbm9uZS1saW51eC1nbnVl
YWJpLWdjYyAoNC40LjRfMDkuMDYuMjAxMCkgNC40LjQKcm9vdCBmaWxlc3lzdGVtIGJ1aWx0IG9u
IFN1biwgMTggU2VwIDIwMTEgMDU6NDk6NTYgLTA1MDAKRnJlZXNjYWxlIFNlbWljb25kdWN0b3Is
IEluYy4KCmZyZWVzY2FsZSBsb2dpbjogcm9vdApsb2dpbls1MzRdOiByb290IGxvZ2luIG9uICd0
dHlteGMwJwoKCkJ1c3lCb3ggdjEuMTguNSAoKSBidWlsdC1pbiBzaGVsbCAoYXNoKQpFbnRlciAn
aGVscCcgZm9yIGEgbGlzdCBvZiBidWlsdC1pbiBjb21tYW5kcy4KCnJvb3RAZnJlZXNjYWxlIH4k
IApyb290QGZyZWVzY2FsZSB+JCAKcm9vdEBmcmVlc2NhbGUgfiQgCnJvb3RAZnJlZXNjYWxlIH4k
IApyb290QGZyZWVzY2FsZSB+JCAKcm9vdEBmcmVlc2NhbGUgfiQgCnJvb3RAZnJlZXNjYWxlIH4k
IApyb290QGZyZWVzY2FsZSB+JCAKcm9vdEBmcmVlc2NhbGUgfiQgbW1jMDogcXVldWluZyB1bmtu
b3duIENJUyB0dXBsZSAweDkxICgzIGJ5dGVzKQptbWMwOiBuZXcgaGlnaCBzcGVlZCBTRElPIGNh
cmQgYXQgYWRkcmVzcyAwMDAxCmJyY21mbWFjOiBicmNtZl9zZGlvaF9yZXF1ZXN0X3dvcmQ6IEZh
aWxlZCB0byByZWFkIHdvcmQsIEVycjogMHhmZmZmZmZhYwpicmNtZm1hYzogYnJjbWZfc2Rpb2hf
cmVxdWVzdF93b3JkOiBGYWlsZWQgdG8gcmVhZCB3b3JkLCBFcnI6IDB4ZmZmZmZmYWMKYnJjbWZt
YWM6IGJyY21mX3NkaW9oX3JlcXVlc3Rfd29yZDogRmFpbGVkIHRvIHJlYWQgd29yZCwgRXJyOiAw
eGZmZmZmZmFjCmJyY21mbWFjOiBicmNtZl9zZGlvX3JlZ3J3X2hlbHBlcjogZmFpbGVkIHdpdGgg
LTg0CmJyY21mbWFjOiBicmNtZl9zZGlvX2NoaXBfZHJpdmVzdHJlbmd0aGluaXQ6IE5vIFNESU8g
RHJpdmUgc3RyZW5ndGggaW5pdCBkb25lIGZvciBjaGlwIDQzMzUgcmV2IDEgcG11cmV2IDE4CmJy
Y21mbWFjOiBicmNtZl9jX3ByZWluaXRfZGNtZHM6IEZpcm13YXJlIHZlcnNpb24gPSB3bDA6IE1h
ciAyNCAyMDEzIDIwOjM2OjAxIHZlcnNpb24gNi4zMC4xNzEuMjQuMjAgKEIwIFN0YXRpb24vUDJQ
KQpicmNtZm1hYzogYnJjbWZfZmlsX2NtZF9kYXRhOiBGYWlsZWQgZXJyPS0yMwoKcm9vdEBmcmVl
c2NhbGUgfiQgCnJvb3RAZnJlZXNjYWxlIH4kIApyb290QGZyZWVzY2FsZSB+JCB3bGFuCAgICGlm
b24ICGNvbmZpZyAtCHdsYW4wCndsYW4wICAgICBMaW5rIGVuY2FwOkV0aGVybmV0ICBIV2FkZHIg
MDA6OTA6NEM6QzU6MTI6MzggIAogICAgICAgICAgQlJPQURDQVNUIE1VTFRJQ0FTVCAgTVRVOjE1
MDAgIE1ldHJpYzoxCiAgICAgICAgICBSWCBwYWNrZXRzOjAgZXJyb3JzOjAgZHJvcHBlZDowIG92
ZXJydW5zOjAgZnJhbWU6MAogICAgICAgICAgVFggcGFja2V0czowIGVycm9yczowIGRyb3BwZWQ6
MCBvdmVycnVuczowIGNhcnJpZXI6MAogICAgICAgICAgY29sbGlzaW9uczowIHR4cXVldWVsZW46
MTAwMCAKICAgICAgICAgIFJYIGJ5dGVzOjAgKDAuMCBCKSAgVFggYnl0ZXM6MCAoMC4wIEIpCgpy
b290QGZyZWVzY2FsZSB+JCAKcm9vdEBmcmVlc2NhbGUgfiQgCnJvb3RAZnJlZXNjYWxlIH4kIGlm
Y29uZmlnIHdsYW4wIHVwCmJyY21mbWFjOiBicmNtZl9zZGJyY21fYnVzX3J4Y3RsOiByZXN1bWVk
IG9uIHRpbWVvdXQKYnJjbWZtYWM6IGJyY21mX2FkZF9pZjogRVJST1I6IG5ldGRldjp3bGFuMCBh
bHJlYWR5IGV4aXN0cwpicmNtZm1hYzogYnJjbWZfYWRkX2lmOiBpZ25vcmUgSUYgZXZlbnQKYnJj
bWZtYWM6IGJyY21mX2ZpbF9jbWRfZGF0YTogRmFpbGVkIGVycj0tMTEwCmJyY21mbWFjOiBicmNt
Zl9maWxfY21kX2RhdGE6IEZhaWxlZCBlcnI9LTIzCnJvb3RAZnJlZXNjYWxlIH4kIApyb290QGZy
ZWVzY2FsZSB+JCBicmNtZm1hYzogYnJjbWZfc2Rpb2hfcmVxdWVzdF9ieXRlOiBGYWlsZWQgdG8g
d3JpdGUgYnl0ZSBGMTpAMHgxMDAxZj0wMSwgRXJyOiAtMTEwCmJyY21mbWFjOiBicmNtZl9zZGlv
aF9yZXF1ZXN0X2J5dGU6IEZhaWxlZCB0byByZWFkIGJ5dGUgRjE6QDB4MTAwMWY9ZmYsIEVycjog
LTExMApicmNtZm1hYzogYnJjbWZfc2Rpb2hfcmVxdWVzdF9ieXRlOiBGYWlsZWQgdG8gcmVhZCBi
eXRlIEYxOkAweDEwMDFmPWZmLCBFcnI6IC0xMTAKCnJvb3RAZnJlZXNjYWxlIH4kIApyb290QGZy
ZWVzY2FsZSB+JCAKcm9vdEBmcmVlc2NhbGUgfiQgYnJjbWZtYWM6IGJyY21mX3NkaW9oX3JlcXVl
c3RfYnl0ZTogRmFpbGVkIHRvIHdyaXRlIGJ5dGUgRjE6QDB4MTAwMWY9MDEsIEVycjogLTExMApi
cmNtZm1hYzogYnJjbWZfc2Rpb2hfcmVxdWVzdF9ieXRlOiBGYWlsZWQgdG8gcmVhZCBieXRlIEYx
OkAweDEwMDFmPWZmLCBFcnI6IC0xMTAKYnJjbWZtYWM6IGJyY21mX3NkaW9oX3JlcXVlc3RfYnl0
ZTogRmFpbGVkIHRvIHJlYWQgYnl0ZSBGMTpAMHgxMDAxZj1mZiwgRXJyOiAtMTEwCgpyb290QGZy
ZWVzY2FsZSB+JCAKcm9vdEBmcmVlc2NhbGUgfiQgCnJvb3RAZnJlZXNjYWxlIH4kIApyb290QGZy
ZWVzY2FsZSB+JCAKClUtQm9vdCAyMDEzLjA0IChTZXAgMDYgMjAxMyAtIDEyOjA3OjA1KQoKQ1BV
OiAgIEZyZWVzY2FsZSBpLk1YNlNMIHJldjEuMiBhdCAzOTYgTUh6CkNQVTogICBUZW1wZXJhdHVy
ZSA0MiBDLCBjYWxpYnJhdGlvbiBkYXRhOiAweDU5NTUxMjVmClJlc2V0IGNhdXNlOiBQT1IKQm9h
cmQ6IE1YNlNMRVZLCkkyQzogICByZWFkeQpEUkFNOiAgMSBHaUIKTU1DOiAgIEZTTF9TREhDOiAw
CkluOiAgICBzZXJpYWwKT3V0OiAgIHNlcmlhbApFcnI6ICAgc2VyaWFsCkZvdW5kIFBGVVpFMTAw
ISBkZXZpY2VpZD0xMCxyZXZpZD0xMQpOZXQ6ICAgRkVDIFtQUklNRV0KTm9ybWFsIEJvb3QKSGl0
IGFueSBrZXkgdG8gc3RvcCBhdXRvYm9vdDogIDMgCAgIIDAgCj0+IAo9PiAKPT4gCj0+IAo9PiAK
PT4g
--001a11c305a40e212104ea7fe0a0
Content-Type: application/octet-stream; name=".config"
Content-Disposition: attachment; filename=".config"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hnofvx581

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIGZpbGU7IERPIE5PVCBFRElULgojIExpbnV4L2Fy
bSAzLjEyLjAtcmMzIEtlcm5lbCBDb25maWd1cmF0aW9uCiMKQ09ORklHX0FSTT15CkNPTkZJR19T
WVNfU1VQUE9SVFNfQVBNX0VNVUxBVElPTj15CkNPTkZJR19IQVZFX1BST0NfQ1BVPXkKQ09ORklH
X1NUQUNLVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19MT0NLREVQX1NVUFBPUlQ9eQpDT05GSUdfVFJB
Q0VfSVJRRkxBR1NfU1VQUE9SVD15CkNPTkZJR19SV1NFTV9HRU5FUklDX1NQSU5MT0NLPXkKQ09O
RklHX0FSQ0hfSEFTX0NQVUZSRVE9eQpDT05GSUdfR0VORVJJQ19IV0VJR0hUPXkKQ09ORklHX0dF
TkVSSUNfQ0FMSUJSQVRFX0RFTEFZPXkKQ09ORklHX05FRURfRE1BX01BUF9TVEFURT15CkNPTkZJ
R19GSVE9eQpDT05GSUdfVkVDVE9SU19CQVNFPTB4ZmZmZjAwMDAKQ09ORklHX0FSTV9QQVRDSF9Q
SFlTX1ZJUlQ9eQpDT05GSUdfR0VORVJJQ19CVUc9eQpDT05GSUdfREVGQ09ORklHX0xJU1Q9Ii9s
aWIvbW9kdWxlcy8kVU5BTUVfUkVMRUFTRS8uY29uZmlnIgpDT05GSUdfSVJRX1dPUks9eQpDT05G
SUdfQlVJTERUSU1FX0VYVEFCTEVfU09SVD15CgojCiMgR2VuZXJhbCBzZXR1cAojCkNPTkZJR19J
TklUX0VOVl9BUkdfTElNSVQ9MzIKQ09ORklHX0NST1NTX0NPTVBJTEU9IiIKIyBDT05GSUdfQ09N
UElMRV9URVNUIGlzIG5vdCBzZXQKQ09ORklHX0xPQ0FMVkVSU0lPTj0iIgojIENPTkZJR19MT0NB
TFZFUlNJT05fQVVUTyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0tFUk5FTF9HWklQPXkKQ09ORklH
X0hBVkVfS0VSTkVMX0xaTUE9eQpDT05GSUdfSEFWRV9LRVJORUxfWFo9eQpDT05GSUdfSEFWRV9L
RVJORUxfTFpPPXkKQ09ORklHX0hBVkVfS0VSTkVMX0xaND15CiMgQ09ORklHX0tFUk5FTF9HWklQ
IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VSTkVMX0xaTUEgaXMgbm90IHNldAojIENPTkZJR19LRVJO
RUxfWFogaXMgbm90IHNldApDT05GSUdfS0VSTkVMX0xaTz15CiMgQ09ORklHX0tFUk5FTF9MWjQg
aXMgbm90IHNldApDT05GSUdfREVGQVVMVF9IT1NUTkFNRT0iKG5vbmUpIgpDT05GSUdfU1dBUD15
CkNPTkZJR19TWVNWSVBDPXkKQ09ORklHX1NZU1ZJUENfU1lTQ1RMPXkKIyBDT05GSUdfUE9TSVhf
TVFVRVVFIGlzIG5vdCBzZXQKIyBDT05GSUdfRkhBTkRMRSBpcyBub3Qgc2V0CiMgQ09ORklHX0FV
RElUIGlzIG5vdCBzZXQKCiMKIyBJUlEgc3Vic3lzdGVtCiMKQ09ORklHX0dFTkVSSUNfSVJRX1BS
T0JFPXkKQ09ORklHX0dFTkVSSUNfSVJRX1NIT1c9eQpDT05GSUdfSEFSRElSUVNfU1dfUkVTRU5E
PXkKQ09ORklHX0dFTkVSSUNfSVJRX0NISVA9eQpDT05GSUdfSVJRX0RPTUFJTj15CiMgQ09ORklH
X0lSUV9ET01BSU5fREVCVUcgaXMgbm90IHNldApDT05GSUdfSVJRX0ZPUkNFRF9USFJFQURJTkc9
eQpDT05GSUdfU1BBUlNFX0lSUT15CkNPTkZJR19LVElNRV9TQ0FMQVI9eQpDT05GSUdfR0VORVJJ
Q19DTE9DS0VWRU5UUz15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTX0JVSUxEPXkKQ09ORklH
X0FSQ0hfSEFTX1RJQ0tfQlJPQURDQVNUPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfQlJP
QURDQVNUPXkKCiMKIyBUaW1lcnMgc3Vic3lzdGVtCiMKQ09ORklHX1RJQ0tfT05FU0hPVD15CkNP
TkZJR19OT19IWl9DT01NT049eQojIENPTkZJR19IWl9QRVJJT0RJQyBpcyBub3Qgc2V0CkNPTkZJ
R19OT19IWl9JRExFPXkKQ09ORklHX05PX0haPXkKQ09ORklHX0hJR0hfUkVTX1RJTUVSUz15Cgoj
CiMgQ1BVL1Rhc2sgdGltZSBhbmQgc3RhdHMgYWNjb3VudGluZwojCkNPTkZJR19USUNLX0NQVV9B
Q0NPVU5USU5HPXkKIyBDT05GSUdfSVJRX1RJTUVfQUNDT1VOVElORyBpcyBub3Qgc2V0CiMgQ09O
RklHX0JTRF9QUk9DRVNTX0FDQ1QgaXMgbm90IHNldAojIENPTkZJR19UQVNLU1RBVFMgaXMgbm90
IHNldAoKIwojIFJDVSBTdWJzeXN0ZW0KIwpDT05GSUdfVFJFRV9SQ1U9eQojIENPTkZJR19QUkVF
TVBUX1JDVSBpcyBub3Qgc2V0CkNPTkZJR19SQ1VfU1RBTExfQ09NTU9OPXkKIyBDT05GSUdfUkNV
X1VTRVJfUVMgaXMgbm90IHNldApDT05GSUdfUkNVX0ZBTk9VVD0zMgpDT05GSUdfUkNVX0ZBTk9V
VF9MRUFGPTE2CiMgQ09ORklHX1JDVV9GQU5PVVRfRVhBQ1QgaXMgbm90IHNldAojIENPTkZJR19S
Q1VfRkFTVF9OT19IWiBpcyBub3Qgc2V0CiMgQ09ORklHX1RSRUVfUkNVX1RSQUNFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkNVX05PQ0JfQ1BVIGlzIG5vdCBzZXQKIyBDT05GSUdfSUtDT05GSUcgaXMg
bm90IHNldApDT05GSUdfTE9HX0JVRl9TSElGVD0xOApDT05GSUdfR0VORVJJQ19TQ0hFRF9DTE9D
Sz15CkNPTkZJR19DR1JPVVBTPXkKIyBDT05GSUdfQ0dST1VQX0RFQlVHIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ0dST1VQX0ZSRUVaRVIgaXMgbm90IHNldAojIENPTkZJR19DR1JPVVBfREVWSUNFIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1BVU0VUUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NHUk9VUF9DUFVB
Q0NUIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVTT1VSQ0VfQ09VTlRFUlMgaXMgbm90IHNldAojIENP
TkZJR19DR1JPVVBfUEVSRiBpcyBub3Qgc2V0CiMgQ09ORklHX0NHUk9VUF9TQ0hFRCBpcyBub3Qg
c2V0CiMgQ09ORklHX0JMS19DR1JPVVAgaXMgbm90IHNldAojIENPTkZJR19DSEVDS1BPSU5UX1JF
U1RPUkUgaXMgbm90IHNldAojIENPTkZJR19OQU1FU1BBQ0VTIGlzIG5vdCBzZXQKIyBDT05GSUdf
VUlER0lEX1NUUklDVF9UWVBFX0NIRUNLUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDSEVEX0FVVE9H
Uk9VUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU0ZTX0RFUFJFQ0FURUQgaXMgbm90IHNldApDT05G
SUdfUkVMQVk9eQpDT05GSUdfQkxLX0RFVl9JTklUUkQ9eQpDT05GSUdfSU5JVFJBTUZTX1NPVVJD
RT0iIgpDT05GSUdfUkRfR1pJUD15CiMgQ09ORklHX1JEX0JaSVAyIGlzIG5vdCBzZXQKIyBDT05G
SUdfUkRfTFpNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1JEX1haIGlzIG5vdCBzZXQKIyBDT05GSUdf
UkRfTFpPIGlzIG5vdCBzZXQKIyBDT05GSUdfUkRfTFo0IGlzIG5vdCBzZXQKIyBDT05GSUdfQ0Nf
T1BUSU1JWkVfRk9SX1NJWkUgaXMgbm90IHNldApDT05GSUdfU1lTQ1RMPXkKQ09ORklHX0FOT05f
SU5PREVTPXkKQ09ORklHX0hBVkVfVUlEMTY9eQpDT05GSUdfRVhQRVJUPXkKQ09ORklHX1VJRDE2
PXkKIyBDT05GSUdfU1lTQ1RMX1NZU0NBTEwgaXMgbm90IHNldApDT05GSUdfS0FMTFNZTVM9eQoj
IENPTkZJR19LQUxMU1lNU19BTEwgaXMgbm90IHNldApDT05GSUdfUFJJTlRLPXkKQ09ORklHX0JV
Rz15CkNPTkZJR19FTEZfQ09SRT15CkNPTkZJR19CQVNFX0ZVTEw9eQpDT05GSUdfRlVURVg9eQpD
T05GSUdfRVBPTEw9eQpDT05GSUdfU0lHTkFMRkQ9eQpDT05GSUdfVElNRVJGRD15CkNPTkZJR19F
VkVOVEZEPXkKQ09ORklHX1NITUVNPXkKQ09ORklHX0FJTz15CiMgQ09ORklHX0VNQkVEREVEIGlz
IG5vdCBzZXQKQ09ORklHX0hBVkVfUEVSRl9FVkVOVFM9eQpDT05GSUdfUEVSRl9VU0VfVk1BTExP
Qz15CgojCiMgS2VybmVsIFBlcmZvcm1hbmNlIEV2ZW50cyBBbmQgQ291bnRlcnMKIwpDT05GSUdf
UEVSRl9FVkVOVFM9eQojIENPTkZJR19ERUJVR19QRVJGX1VTRV9WTUFMTE9DIGlzIG5vdCBzZXQK
Q09ORklHX1ZNX0VWRU5UX0NPVU5URVJTPXkKIyBDT05GSUdfU0xVQl9ERUJVRyBpcyBub3Qgc2V0
CiMgQ09ORklHX0NPTVBBVF9CUksgaXMgbm90IHNldAojIENPTkZJR19TTEFCIGlzIG5vdCBzZXQK
Q09ORklHX1NMVUI9eQojIENPTkZJR19TTE9CIGlzIG5vdCBzZXQKQ09ORklHX1NMVUJfQ1BVX1BB
UlRJQUw9eQojIENPTkZJR19QUk9GSUxJTkcgaXMgbm90IHNldApDT05GSUdfSEFWRV9PUFJPRklM
RT15CiMgQ09ORklHX0tQUk9CRVMgaXMgbm90IHNldAojIENPTkZJR19KVU1QX0xBQkVMIGlzIG5v
dCBzZXQKIyBDT05GSUdfSEFWRV82NEJJVF9BTElHTkVEX0FDQ0VTUyBpcyBub3Qgc2V0CkNPTkZJ
R19IQVZFX0tQUk9CRVM9eQpDT05GSUdfSEFWRV9LUkVUUFJPQkVTPXkKQ09ORklHX0hBVkVfQVJD
SF9UUkFDRUhPT0s9eQpDT05GSUdfSEFWRV9ETUFfQVRUUlM9eQpDT05GSUdfSEFWRV9ETUFfQ09O
VElHVU9VUz15CkNPTkZJR19VU0VfR0VORVJJQ19TTVBfSEVMUEVSUz15CkNPTkZJR19HRU5FUklD
X1NNUF9JRExFX1RIUkVBRD15CkNPTkZJR19HRU5FUklDX0lETEVfUE9MTF9TRVRVUD15CkNPTkZJ
R19IQVZFX1JFR1NfQU5EX1NUQUNLX0FDQ0VTU19BUEk9eQpDT05GSUdfSEFWRV9DTEs9eQpDT05G
SUdfSEFWRV9ETUFfQVBJX0RFQlVHPXkKQ09ORklHX0hBVkVfSFdfQlJFQUtQT0lOVD15CkNPTkZJ
R19IQVZFX0FSQ0hfSlVNUF9MQUJFTD15CkNPTkZJR19BUkNIX1dBTlRfSVBDX1BBUlNFX1ZFUlNJ
T049eQpDT05GSUdfSEFWRV9BUkNIX1NFQ0NPTVBfRklMVEVSPXkKQ09ORklHX0hBVkVfQ09OVEVY
VF9UUkFDS0lORz15CkNPTkZJR19IQVZFX0lSUV9USU1FX0FDQ09VTlRJTkc9eQpDT05GSUdfTU9E
VUxFU19VU0VfRUxGX1JFTD15CkNPTkZJR19DTE9ORV9CQUNLV0FSRFM9eQpDT05GSUdfT0xEX1NJ
R1NVU1BFTkQzPXkKQ09ORklHX09MRF9TSUdBQ1RJT049eQoKIwojIEdDT1YtYmFzZWQga2VybmVs
IHByb2ZpbGluZwojCiMgQ09ORklHX0dDT1ZfS0VSTkVMIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVf
R0VORVJJQ19ETUFfQ09IRVJFTlQ9eQpDT05GSUdfUlRfTVVURVhFUz15CkNPTkZJR19CQVNFX1NN
QUxMPTAKQ09ORklHX01PRFVMRVM9eQojIENPTkZJR19NT0RVTEVfRk9SQ0VfTE9BRCBpcyBub3Qg
c2V0CkNPTkZJR19NT0RVTEVfVU5MT0FEPXkKIyBDT05GSUdfTU9EVUxFX0ZPUkNFX1VOTE9BRCBp
cyBub3Qgc2V0CkNPTkZJR19NT0RWRVJTSU9OUz15CkNPTkZJR19NT0RVTEVfU1JDVkVSU0lPTl9B
TEw9eQojIENPTkZJR19NT0RVTEVfU0lHIGlzIG5vdCBzZXQKQ09ORklHX1NUT1BfTUFDSElORT15
CkNPTkZJR19CTE9DSz15CkNPTkZJR19MQkRBRj15CiMgQ09ORklHX0JMS19ERVZfQlNHIGlzIG5v
dCBzZXQKIyBDT05GSUdfQkxLX0RFVl9CU0dMSUIgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVW
X0lOVEVHUklUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19DTURMSU5FX1BBUlNFUiBpcyBub3Qg
c2V0CgojCiMgUGFydGl0aW9uIFR5cGVzCiMKIyBDT05GSUdfUEFSVElUSU9OX0FEVkFOQ0VEIGlz
IG5vdCBzZXQKQ09ORklHX01TRE9TX1BBUlRJVElPTj15CkNPTkZJR19FRklfUEFSVElUSU9OPXkK
CiMKIyBJTyBTY2hlZHVsZXJzCiMKQ09ORklHX0lPU0NIRURfTk9PUD15CkNPTkZJR19JT1NDSEVE
X0RFQURMSU5FPXkKQ09ORklHX0lPU0NIRURfQ0ZRPXkKIyBDT05GSUdfREVGQVVMVF9ERUFETElO
RSBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX0NGUT15CiMgQ09ORklHX0RFRkFVTFRfTk9PUCBp
cyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX0lPU0NIRUQ9ImNmcSIKQ09ORklHX0lOTElORV9TUElO
X1VOTE9DS19JUlE9eQpDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NLPXkKQ09ORklHX0lOTElORV9S
RUFEX1VOTE9DS19JUlE9eQpDT05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DSz15CkNPTkZJR19JTkxJ
TkVfV1JJVEVfVU5MT0NLX0lSUT15CkNPTkZJR19NVVRFWF9TUElOX09OX09XTkVSPXkKQ09ORklH
X0ZSRUVaRVI9eQoKIwojIFN5c3RlbSBUeXBlCiMKQ09ORklHX01NVT15CkNPTkZJR19BUkNIX01V
TFRJUExBVEZPUk09eQojIENPTkZJR19BUkNIX0lOVEVHUkFUT1IgaXMgbm90IHNldAojIENPTkZJ
R19BUkNIX1JFQUxWSUVXIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9WRVJTQVRJTEUgaXMgbm90
IHNldAojIENPTkZJR19BUkNIX0FUOTEgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0NMUFM3MTFY
IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9HRU1JTkkgaXMgbm90IHNldAojIENPTkZJR19BUkNI
X0VCU0ExMTAgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0VQOTNYWCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FSQ0hfRk9PVEJSSURHRSBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfTkVUWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0FSQ0hfSU9QMTNYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfSU9QMzJY
IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9JT1AzM1ggaXMgbm90IHNldAojIENPTkZJR19BUkNI
X0lYUDRYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfRE9WRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0FSQ0hfS0lSS1dPT0QgaXMgbm90IHNldAojIENPTkZJR19BUkNIX01WNzhYWDAgaXMgbm90IHNl
dAojIENPTkZJR19BUkNIX09SSU9ONVggaXMgbm90IHNldAojIENPTkZJR19BUkNIX01NUCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FSQ0hfS1M4Njk1IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9XOTBY
OTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9MUEMzMlhYIGlzIG5vdCBzZXQKIyBDT05GSUdf
QVJDSF9QWEEgaXMgbm90IHNldAojIENPTkZJR19BUkNIX01TTSBpcyBub3Qgc2V0CiMgQ09ORklH
X0FSQ0hfU0hNT0JJTEUgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1JQQyBpcyBub3Qgc2V0CiMg
Q09ORklHX0FSQ0hfU0ExMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9TM0MyNFhYIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVJDSF9TM0M2NFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9TNVA2
NFgwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9TNVBDMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdf
QVJDSF9TNVBWMjEwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9FWFlOT1MgaXMgbm90IHNldAoj
IENPTkZJR19BUkNIX1NIQVJLIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9EQVZJTkNJIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVJDSF9PTUFQMSBpcyBub3Qgc2V0CgojCiMgTXVsdGlwbGUgcGxhdGZv
cm0gc2VsZWN0aW9uCiMKCiMKIyBDUFUgQ29yZSBmYW1pbHkgc2VsZWN0aW9uCiMKQ09ORklHX0FS
Q0hfTVVMVElfVjY9eQpDT05GSUdfQVJDSF9NVUxUSV9WNz15CkNPTkZJR19BUkNIX01VTFRJX1Y2
X1Y3PXkKIyBDT05GSUdfQVJDSF9NVUxUSV9DUFVfQVVUTyBpcyBub3Qgc2V0CiMgQ09ORklHX0FS
Q0hfTVZFQlUgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0JDTSBpcyBub3Qgc2V0CiMgQ09ORklH
X0FSQ0hfQkNNMjgzNSBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfQ05TM1hYWCBpcyBub3Qgc2V0
CiMgQ09ORklHX0dQSU9fUENBOTUzWCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0dQSU9f
UE9MTEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9ISUdIQkFOSyBpcyBub3Qgc2V0CiMgQ09O
RklHX0FSQ0hfS0VZU1RPTkUgaXMgbm90IHNldApDT05GSUdfQVJDSF9NWEM9eQoKIwojIEZyZWVz
Y2FsZSBpLk1YIHN1cHBvcnQKIwojIENPTkZJR19NWENfSVJRX1BSSU9SIGlzIG5vdCBzZXQKQ09O
RklHX01YQ19UWklDPXkKQ09ORklHX01YQ19BVklDPXkKQ09ORklHX01YQ19ERUJVR19CT0FSRD15
CkNPTkZJR19IQVZFX0VQSVQ9eQojIENPTkZJR19NWENfVVNFX0VQSVQgaXMgbm90IHNldApDT05G
SUdfQVJDSF9IQVNfUk5HQT15CkNPTkZJR19IQVZFX0lNWF9BTkFUT1A9eQpDT05GSUdfSEFWRV9J
TVhfR1BDPXkKQ09ORklHX0hBVkVfSU1YX01NREM9eQpDT05GSUdfSEFWRV9JTVhfU1JDPXkKQ09O
RklHX0FSQ0hfTVhDX0lPTVVYX1YzPXkKQ09ORklHX1NPQ19JTVgzMT15CkNPTkZJR19TT0NfSU1Y
MzU9eQpDT05GSUdfU09DX0lNWDU9eQpDT05GSUdfU09DX0lNWDUxPXkKCiMKIyBNWDMxIHBsYXRm
b3JtczoKIwpDT05GSUdfTUFDSF9NWDMxQURTPXkKQ09ORklHX01BQ0hfTVgzMUxJTExZPXkKQ09O
RklHX01BQ0hfTVgzMUxJVEU9eQpDT05GSUdfTUFDSF9QQ00wMzc9eQpDT05GSUdfTUFDSF9QQ00w
MzdfRUVUPXkKQ09ORklHX01BQ0hfTVgzMV8zRFM9eQojIENPTkZJR19NQUNIX01YMzFfM0RTX01Y
Q19OQU5EX1VTRV9CQlQgaXMgbm90IHNldApDT05GSUdfTUFDSF9NWDMxTU9CT0FSRD15CkNPTkZJ
R19NQUNIX1FPTkc9eQpDT05GSUdfTUFDSF9BUk1BRElMTE81WDA9eQpDT05GSUdfTUFDSF9LWk1f
QVJNMTFfMDE9eQpDT05GSUdfTUFDSF9CVUc9eQpDT05GSUdfTUFDSF9JTVgzMV9EVD15CgojCiMg
TVgzNSBwbGF0Zm9ybXM6CiMKQ09ORklHX01BQ0hfUENNMDQzPXkKQ09ORklHX01BQ0hfTVgzNV8z
RFM9eQojIENPTkZJR19NQUNIX0VVS1JFQV9DUFVJTVgzNVNEIGlzIG5vdCBzZXQKQ09ORklHX01B
Q0hfVlBSMjAwPXkKCiMKIyBpLk1YNTEgbWFjaGluZXM6CiMKQ09ORklHX01BQ0hfSU1YNTFfRFQ9
eQojIENPTkZJR19NQUNIX01YNTFfQkFCQkFHRSBpcyBub3Qgc2V0CkNPTkZJR19NQUNIX0VVS1JF
QV9DUFVJTVg1MVNEPXkKQ09ORklHX01BQ0hfRVVLUkVBX01CSU1YU0Q1MV9CQVNFQk9BUkQ9eQoK
IwojIERldmljZSB0cmVlIG9ubHkKIwpDT05GSUdfU09DX0lNWDUzPXkKQ09ORklHX1NPQ19JTVg2
UT15CkNPTkZJR19TT0NfSU1YNlNMPXkKQ09ORklHX1NPQ19WRjYxMD15CkNPTkZJR19JTVhfSEFW
RV9QTEFURk9STV9GRUM9eQpDT05GSUdfSU1YX0hBVkVfUExBVEZPUk1fRkxFWENBTj15CkNPTkZJ
R19JTVhfSEFWRV9QTEFURk9STV9GU0xfVVNCMl9VREM9eQpDT05GSUdfSU1YX0hBVkVfUExBVEZP
Uk1fR1BJT19LRVlTPXkKQ09ORklHX0lNWF9IQVZFX1BMQVRGT1JNX0lNWDJfV0RUPXkKQ09ORklH
X0lNWF9IQVZFX1BMQVRGT1JNX0lNWF9GQj15CkNPTkZJR19JTVhfSEFWRV9QTEFURk9STV9JTVhf
STJDPXkKQ09ORklHX0lNWF9IQVZFX1BMQVRGT1JNX0lNWF9LRVlQQUQ9eQpDT05GSUdfSU1YX0hB
VkVfUExBVEZPUk1fSU1YX1NTST15CkNPTkZJR19JTVhfSEFWRV9QTEFURk9STV9JTVhfVUFSVD15
CkNPTkZJR19JTVhfSEFWRV9QTEFURk9STV9JUFVfQ09SRT15CkNPTkZJR19JTVhfSEFWRV9QTEFU
Rk9STV9NWENfRUhDST15CkNPTkZJR19JTVhfSEFWRV9QTEFURk9STV9NWENfTU1DPXkKQ09ORklH
X0lNWF9IQVZFX1BMQVRGT1JNX01YQ19OQU5EPXkKQ09ORklHX0lNWF9IQVZFX1BMQVRGT1JNX01Y
Q19STkdBPXkKQ09ORklHX0lNWF9IQVZFX1BMQVRGT1JNX01YQ19SVEM9eQpDT05GSUdfSU1YX0hB
VkVfUExBVEZPUk1fTVhDX1cxPXkKQ09ORklHX0lNWF9IQVZFX1BMQVRGT1JNX1NESENJX0VTREhD
X0lNWD15CkNPTkZJR19JTVhfSEFWRV9QTEFURk9STV9TUElfSU1YPXkKIyBDT05GSUdfQVJDSF9P
TUFQMiBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfT01BUDMgaXMgbm90IHNldAojIENPTkZJR19B
UkNIX09NQVA0IGlzIG5vdCBzZXQKIyBDT05GSUdfU09DX09NQVA1IGlzIG5vdCBzZXQKIyBDT05G
SUdfU09DX0FNMzNYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NPQ19BTTQzWFggaXMgbm90IHNldAoj
IENPTkZJR19BUkNIX1BJQ09YQ0VMTCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUk9DS0NISVAg
aXMgbm90IHNldAojIENPTkZJR19BUkNIX1NPQ0ZQR0EgaXMgbm90IHNldAojIENPTkZJR19QTEFU
X1NQRUFSIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9TVEkgaXMgbm90IHNldAojIENPTkZJR19B
UkNIX1NITU9CSUxFX01VTFRJIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9TVU5YSSBpcyBub3Qg
c2V0CiMgQ09ORklHX0FSQ0hfU0lSRiBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfVEVHUkEgaXMg
bm90IHNldAojIENPTkZJR19BUkNIX1U4NTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9WRVhQ
UkVTUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfVklSVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FS
Q0hfV004NzUwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9XTTg4NTAgaXMgbm90IHNldAojIENP
TkZJR19BUkNIX1pZTlEgaXMgbm90IHNldAoKIwojIFByb2Nlc3NvciBUeXBlCiMKQ09ORklHX0NQ
VV9WNj15CkNPTkZJR19DUFVfVjZLPXkKQ09ORklHX0NQVV9WNz15CkNPTkZJR19DUFVfMzJ2Nj15
CkNPTkZJR19DUFVfMzJ2Nks9eQpDT05GSUdfQ1BVXzMydjc9eQpDT05GSUdfQ1BVX0FCUlRfRVY2
PXkKQ09ORklHX0NQVV9BQlJUX0VWNz15CkNPTkZJR19DUFVfUEFCUlRfVjY9eQpDT05GSUdfQ1BV
X1BBQlJUX1Y3PXkKQ09ORklHX0NQVV9DQUNIRV9WNj15CkNPTkZJR19DUFVfQ0FDSEVfVjc9eQpD
T05GSUdfQ1BVX0NBQ0hFX1ZJUFQ9eQpDT05GSUdfQ1BVX0NPUFlfVjY9eQpDT05GSUdfQ1BVX1RM
Ql9WNj15CkNPTkZJR19DUFVfVExCX1Y3PXkKQ09ORklHX0NQVV9IQVNfQVNJRD15CkNPTkZJR19D
UFVfQ1AxNT15CkNPTkZJR19DUFVfQ1AxNV9NTVU9eQpDT05GSUdfQ1BVX1VTRV9ET01BSU5TPXkK
CiMKIyBQcm9jZXNzb3IgRmVhdHVyZXMKIwojIENPTkZJR19BUkNIX1BIWVNfQUREUl9UXzY0QklU
IGlzIG5vdCBzZXQKQ09ORklHX0FSTV9USFVNQj15CiMgQ09ORklHX0FSTV9USFVNQkVFIGlzIG5v
dCBzZXQKQ09ORklHX0FSTV9WSVJUX0VYVD15CiMgQ09ORklHX0NQVV9JQ0FDSEVfRElTQUJMRSBp
cyBub3Qgc2V0CiMgQ09ORklHX0NQVV9EQ0FDSEVfRElTQUJMRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0NQVV9CUFJFRElDVF9ESVNBQkxFIGlzIG5vdCBzZXQKQ09ORklHX0tVU0VSX0hFTFBFUlM9eQpD
T05GSUdfRE1BX0NBQ0hFX1JXRk89eQpDT05GSUdfT1VURVJfQ0FDSEU9eQpDT05GSUdfT1VURVJf
Q0FDSEVfU1lOQz15CkNPTkZJR19NSUdIVF9IQVZFX0NBQ0hFX0wyWDA9eQpDT05GSUdfQ0FDSEVf
TDJYMD15CkNPTkZJR19BUk1fTDFfQ0FDSEVfU0hJRlRfNj15CkNPTkZJR19BUk1fTDFfQ0FDSEVf
U0hJRlQ9NgpDT05GSUdfQVJNX0RNQV9NRU1fQlVGRkVSQUJMRT15CkNPTkZJR19BUk1fTlJfQkFO
S1M9OApDT05GSUdfTVVMVElfSVJRX0hBTkRMRVI9eQojIENPTkZJR19BUk1fRVJSQVRBXzMyNjEw
MyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSTV9FUlJBVEFfNDExOTIwIGlzIG5vdCBzZXQKIyBDT05G
SUdfQVJNX0VSUkFUQV80MzA5NzMgaXMgbm90IHNldAojIENPTkZJR19QTDMxMF9FUlJBVEFfNTg4
MzY5IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJNX0VSUkFUQV82NDM3MTkgaXMgbm90IHNldAojIENP
TkZJR19BUk1fRVJSQVRBXzcyMDc4OSBpcyBub3Qgc2V0CiMgQ09ORklHX1BMMzEwX0VSUkFUQV83
Mjc5MTUgaXMgbm90IHNldApDT05GSUdfQVJNX0VSUkFUQV83NTQzMjI9eQojIENPTkZJR19BUk1f
RVJSQVRBXzc1NDMyNyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSTV9FUlJBVEFfMzY0Mjk2IGlzIG5v
dCBzZXQKQ09ORklHX0FSTV9FUlJBVEFfNzY0MzY5PXkKIyBDT05GSUdfUEwzMTBfRVJSQVRBXzc2
OTQxOSBpcyBub3Qgc2V0CkNPTkZJR19BUk1fRVJSQVRBXzc3NTQyMD15CiMgQ09ORklHX0FSTV9F
UlJBVEFfNzk4MTgxIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJNX0VSUkFUQV83NzMwMjIgaXMgbm90
IHNldAoKIwojIEJ1cyBzdXBwb3J0CiMKIyBDT05GSUdfUENJX1NZU0NBTEwgaXMgbm90IHNldAoj
IENPTkZJR19QQ0NBUkQgaXMgbm90IHNldAoKIwojIEtlcm5lbCBGZWF0dXJlcwojCkNPTkZJR19I
QVZFX1NNUD15CkNPTkZJR19TTVA9eQpDT05GSUdfU01QX09OX1VQPXkKQ09ORklHX0FSTV9DUFVf
VE9QT0xPR1k9eQojIENPTkZJR19TQ0hFRF9NQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDSEVEX1NN
VCBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0FSTV9TQ1U9eQojIENPTkZJR19IQVZFX0FSTV9BUkNI
X1RJTUVSIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJNX1RXRD15CiMgQ09ORklHX01DUE0gaXMg
bm90IHNldAojIENPTkZJR19WTVNQTElUXzNHIGlzIG5vdCBzZXQKQ09ORklHX1ZNU1BMSVRfMkc9
eQojIENPTkZJR19WTVNQTElUXzFHIGlzIG5vdCBzZXQKQ09ORklHX1BBR0VfT0ZGU0VUPTB4ODAw
MDAwMDAKQ09ORklHX05SX0NQVVM9NApDT05GSUdfSE9UUExVR19DUFU9eQojIENPTkZJR19BUk1f
UFNDSSBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX05SX0dQSU89MAojIENPTkZJR19QUkVFTVBUX05P
TkUgaXMgbm90IHNldApDT05GSUdfUFJFRU1QVF9WT0xVTlRBUlk9eQojIENPTkZJR19QUkVFTVBU
IGlzIG5vdCBzZXQKQ09ORklHX0haX0ZJWEVEPTAKQ09ORklHX0haXzEwMD15CiMgQ09ORklHX0ha
XzIwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzI1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzMw
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzUwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzEwMDAg
aXMgbm90IHNldApDT05GSUdfSFo9MTAwCkNPTkZJR19TQ0hFRF9IUlRJQ0s9eQpDT05GSUdfQUVB
Qkk9eQojIENPTkZJR19PQUJJX0NPTVBBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfU1BBUlNF
TUVNX0RFRkFVTFQgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1NFTEVDVF9NRU1PUllfTU9ERUwg
aXMgbm90IHNldApDT05GSUdfSEFWRV9BUkNIX1BGTl9WQUxJRD15CiMgQ09ORklHX0hJR0hNRU0g
aXMgbm90IHNldApDT05GSUdfSFdfUEVSRl9FVkVOVFM9eQpDT05GSUdfQVJDSF9XQU5UX0dFTkVS
QUxfSFVHRVRMQj15CkNPTkZJR19GTEFUTUVNPXkKQ09ORklHX0ZMQVRfTk9ERV9NRU1fTUFQPXkK
Q09ORklHX0hBVkVfTUVNQkxPQ0s9eQojIENPTkZJR19IQVZFX0JPT1RNRU1fSU5GT19OT0RFIGlz
IG5vdCBzZXQKQ09ORklHX1BBR0VGTEFHU19FWFRFTkRFRD15CkNPTkZJR19TUExJVF9QVExPQ0tf
Q1BVUz00CkNPTkZJR19DT01QQUNUSU9OPXkKQ09ORklHX01JR1JBVElPTj15CiMgQ09ORklHX1BI
WVNfQUREUl9UXzY0QklUIGlzIG5vdCBzZXQKQ09ORklHX1pPTkVfRE1BX0ZMQUc9MAojIENPTkZJ
R19LU00gaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9NTUFQX01JTl9BRERSPTQwOTYKQ09ORklH
X0NST1NTX01FTU9SWV9BVFRBQ0g9eQojIENPTkZJR19DTEVBTkNBQ0hFIGlzIG5vdCBzZXQKIyBD
T05GSUdfRlJPTlRTV0FQIGlzIG5vdCBzZXQKIyBDT05GSUdfQ01BIGlzIG5vdCBzZXQKIyBDT05G
SUdfWkJVRCBpcyBub3Qgc2V0CkNPTkZJR19GT1JDRV9NQVhfWk9ORU9SREVSPTExCkNPTkZJR19B
TElHTk1FTlRfVFJBUD15CiMgQ09ORklHX1VBQ0NFU1NfV0lUSF9NRU1DUFkgaXMgbm90IHNldAoj
IENPTkZJR19TRUNDT01QIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0NfU1RBQ0tQUk9URUNUT1IgaXMg
bm90IHNldAoKIwojIEJvb3Qgb3B0aW9ucwojCkNPTkZJR19VU0VfT0Y9eQpDT05GSUdfQVRBR1M9
eQojIENPTkZJR19ERVBSRUNBVEVEX1BBUkFNX1NUUlVDVCBpcyBub3Qgc2V0CkNPTkZJR19aQk9P
VF9ST01fVEVYVD0wCkNPTkZJR19aQk9PVF9ST01fQlNTPTAKIyBDT05GSUdfQVJNX0FQUEVOREVE
X0RUQiBpcyBub3Qgc2V0CkNPTkZJR19DTURMSU5FPSJub2luaXRyZCBjb25zb2xlPXR0eW14YzAs
MTE1MjAwIgpDT05GSUdfQ01ETElORV9GUk9NX0JPT1RMT0FERVI9eQojIENPTkZJR19DTURMSU5F
X0VYVEVORCBpcyBub3Qgc2V0CiMgQ09ORklHX0NNRExJTkVfRk9SQ0UgaXMgbm90IHNldAojIENP
TkZJR19LRVhFQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSQVNIX0RVTVAgaXMgbm90IHNldApDT05G
SUdfQVVUT19aUkVMQUREUj15CgojCiMgQ1BVIFBvd2VyIE1hbmFnZW1lbnQKIwoKIwojIENQVSBG
cmVxdWVuY3kgc2NhbGluZwojCiMgQ09ORklHX0NQVV9GUkVRIGlzIG5vdCBzZXQKCiMKIyBDUFUg
SWRsZQojCiMgQ09ORklHX0NQVV9JRExFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9ORUVEU19D
UFVfSURMRV9DT1VQTEVEIGlzIG5vdCBzZXQKCiMKIyBGbG9hdGluZyBwb2ludCBlbXVsYXRpb24K
IwoKIwojIEF0IGxlYXN0IG9uZSBlbXVsYXRpb24gbXVzdCBiZSBzZWxlY3RlZAojCkNPTkZJR19W
RlA9eQpDT05GSUdfVkZQdjM9eQpDT05GSUdfTkVPTj15CiMgQ09ORklHX0tFUk5FTF9NT0RFX05F
T04gaXMgbm90IHNldAoKIwojIFVzZXJzcGFjZSBiaW5hcnkgZm9ybWF0cwojCkNPTkZJR19CSU5G
TVRfRUxGPXkKQ09ORklHX0FSQ0hfQklORk1UX0VMRl9SQU5ET01JWkVfUElFPXkKQ09ORklHX0NP
UkVfRFVNUF9ERUZBVUxUX0VMRl9IRUFERVJTPXkKQ09ORklHX0JJTkZNVF9TQ1JJUFQ9eQojIENP
TkZJR19IQVZFX0FPVVQgaXMgbm90IHNldApDT05GSUdfQklORk1UX01JU0M9bQpDT05GSUdfQ09S
RURVTVA9eQoKIwojIFBvd2VyIG1hbmFnZW1lbnQgb3B0aW9ucwojCkNPTkZJR19TVVNQRU5EPXkK
Q09ORklHX1NVU1BFTkRfRlJFRVpFUj15CkNPTkZJR19QTV9TTEVFUD15CkNPTkZJR19QTV9TTEVF
UF9TTVA9eQojIENPTkZJR19QTV9BVVRPU0xFRVAgaXMgbm90IHNldAojIENPTkZJR19QTV9XQUtF
TE9DS1MgaXMgbm90IHNldApDT05GSUdfUE1fUlVOVElNRT15CkNPTkZJR19QTT15CkNPTkZJR19Q
TV9ERUJVRz15CiMgQ09ORklHX1BNX0FEVkFOQ0VEX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1BN
X1RFU1RfU1VTUEVORD15CkNPTkZJR19QTV9TTEVFUF9ERUJVRz15CiMgQ09ORklHX0FQTV9FTVVM
QVRJT04gaXMgbm90IHNldApDT05GSUdfQVJDSF9IQVNfT1BQPXkKQ09ORklHX1BNX09QUD15CkNP
TkZJR19QTV9DTEs9eQojIENPTkZJR19XUV9QT1dFUl9FRkZJQ0lFTlRfREVGQVVMVCBpcyBub3Qg
c2V0CkNPTkZJR19DUFVfUE09eQpDT05GSUdfQVJDSF9TVVNQRU5EX1BPU1NJQkxFPXkKQ09ORklH
X0FSTV9DUFVfU1VTUEVORD15CkNPTkZJR19ORVQ9eQoKIwojIE5ldHdvcmtpbmcgb3B0aW9ucwoj
CkNPTkZJR19QQUNLRVQ9eQojIENPTkZJR19QQUNLRVRfRElBRyBpcyBub3Qgc2V0CkNPTkZJR19V
TklYPXkKIyBDT05GSUdfVU5JWF9ESUFHIGlzIG5vdCBzZXQKQ09ORklHX1hGUk09eQojIENPTkZJ
R19YRlJNX1VTRVIgaXMgbm90IHNldAojIENPTkZJR19YRlJNX1NVQl9QT0xJQ1kgaXMgbm90IHNl
dAojIENPTkZJR19YRlJNX01JR1JBVEUgaXMgbm90IHNldAojIENPTkZJR19YRlJNX1NUQVRJU1RJ
Q1MgaXMgbm90IHNldAojIENPTkZJR19ORVRfS0VZIGlzIG5vdCBzZXQKQ09ORklHX0lORVQ9eQoj
IENPTkZJR19JUF9NVUxUSUNBU1QgaXMgbm90IHNldAojIENPTkZJR19JUF9BRFZBTkNFRF9ST1VU
RVIgaXMgbm90IHNldApDT05GSUdfSVBfUE5QPXkKQ09ORklHX0lQX1BOUF9ESENQPXkKIyBDT05G
SUdfSVBfUE5QX0JPT1RQIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfUE5QX1JBUlAgaXMgbm90IHNl
dAojIENPTkZJR19ORVRfSVBJUCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9JUEdSRV9ERU1VWCBp
cyBub3Qgc2V0CkNPTkZJR19ORVRfSVBfVFVOTkVMPXkKIyBDT05GSUdfU1lOX0NPT0tJRVMgaXMg
bm90IHNldAojIENPTkZJR19JTkVUX0FIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9FU1AgaXMg
bm90IHNldAojIENPTkZJR19JTkVUX0lQQ09NUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfWEZS
TV9UVU5ORUwgaXMgbm90IHNldApDT05GSUdfSU5FVF9UVU5ORUw9eQojIENPTkZJR19JTkVUX1hG
Uk1fTU9ERV9UUkFOU1BPUlQgaXMgbm90IHNldAojIENPTkZJR19JTkVUX1hGUk1fTU9ERV9UVU5O
RUwgaXMgbm90IHNldAojIENPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5FVF9MUk8gaXMgbm90IHNldApDT05GSUdfSU5FVF9ESUFHPXkKQ09ORklHX0lORVRf
VENQX0RJQUc9eQojIENPTkZJR19JTkVUX1VEUF9ESUFHIGlzIG5vdCBzZXQKIyBDT05GSUdfVENQ
X0NPTkdfQURWQU5DRUQgaXMgbm90IHNldApDT05GSUdfVENQX0NPTkdfQ1VCSUM9eQpDT05GSUdf
REVGQVVMVF9UQ1BfQ09ORz0iY3ViaWMiCiMgQ09ORklHX1RDUF9NRDVTSUcgaXMgbm90IHNldApD
T05GSUdfSVBWNj15CiMgQ09ORklHX0lQVjZfUFJJVkFDWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lQ
VjZfUk9VVEVSX1BSRUYgaXMgbm90IHNldAojIENPTkZJR19JUFY2X09QVElNSVNUSUNfREFEIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5FVDZfQUggaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9FU1Ag
aXMgbm90IHNldAojIENPTkZJR19JTkVUNl9JUENPTVAgaXMgbm90IHNldAojIENPTkZJR19JUFY2
X01JUDYgaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9YRlJNX1RVTk5FTCBpcyBub3Qgc2V0CiMg
Q09ORklHX0lORVQ2X1RVTk5FTCBpcyBub3Qgc2V0CkNPTkZJR19JTkVUNl9YRlJNX01PREVfVFJB
TlNQT1JUPXkKQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9UVU5ORUw9eQpDT05GSUdfSU5FVDZfWEZS
TV9NT0RFX0JFRVQ9eQojIENPTkZJR19JTkVUNl9YRlJNX01PREVfUk9VVEVPUFRJTUlaQVRJT04g
aXMgbm90IHNldApDT05GSUdfSVBWNl9TSVQ9eQojIENPTkZJR19JUFY2X1NJVF82UkQgaXMgbm90
IHNldApDT05GSUdfSVBWNl9ORElTQ19OT0RFVFlQRT15CiMgQ09ORklHX0lQVjZfVFVOTkVMIGlz
IG5vdCBzZXQKIyBDT05GSUdfSVBWNl9HUkUgaXMgbm90IHNldAojIENPTkZJR19JUFY2X01VTFRJ
UExFX1RBQkxFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjZfTVJPVVRFIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUV09SS19TRUNNQVJLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUV09SS19QSFlfVElN
RVNUQU1QSU5HIGlzIG5vdCBzZXQKQ09ORklHX05FVEZJTFRFUj15CiMgQ09ORklHX05FVEZJTFRF
Ul9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfQURWQU5DRUQ9eQoKIwojIENvcmUg
TmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwojIENPTkZJR19ORVRGSUxURVJfTkVUTElOS19BQ0NU
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX05FVExJTktfUVVFVUUgaXMgbm90IHNldAoj
IENPTkZJR19ORVRGSUxURVJfTkVUTElOS19MT0cgaXMgbm90IHNldAojIENPTkZJR19ORl9DT05O
VFJBQ0sgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRBQkxFUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0lQX1ZTIGlzIG5vdCBzZXQKCiMKIyBJUDogTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24K
IwojIENPTkZJR19ORl9ERUZSQUdfSVBWNCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX05GX0lQVEFC
TEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfTkZfQVJQVEFCTEVTIGlzIG5vdCBzZXQKCiMKIyBJ
UHY2OiBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgojCiMgQ09ORklHX05GX0RFRlJBR19JUFY2IGlz
IG5vdCBzZXQKIyBDT05GSUdfSVA2X05GX0lQVEFCTEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBf
RENDUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX1NDVFAgaXMgbm90IHNldAojIENPTkZJR19SRFMg
aXMgbm90IHNldAojIENPTkZJR19USVBDIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTDJUUCBpcyBub3Qgc2V0CiMgQ09ORklHX0JSSURHRSBpcyBub3Qgc2V0CkNP
TkZJR19IQVZFX05FVF9EU0E9eQojIENPTkZJR19WTEFOXzgwMjFRIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVDTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfTExDMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQ
WCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQUxLIGlzIG5vdCBzZXQKIyBDT05GSUdfWDI1IGlzIG5v
dCBzZXQKIyBDT05GSUdfTEFQQiBpcyBub3Qgc2V0CiMgQ09ORklHX1BIT05FVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lFRUU4MDIxNTQgaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIRUQgaXMgbm90
IHNldAojIENPTkZJR19EQ0IgaXMgbm90IHNldApDT05GSUdfRE5TX1JFU09MVkVSPXkKIyBDT05G
SUdfQkFUTUFOX0FEViBpcyBub3Qgc2V0CiMgQ09ORklHX09QRU5WU1dJVENIIGlzIG5vdCBzZXQK
IyBDT05GSUdfVlNPQ0tFVFMgaXMgbm90IHNldAojIENPTkZJR19ORVRMSU5LX01NQVAgaXMgbm90
IHNldAojIENPTkZJR19ORVRMSU5LX0RJQUcgaXMgbm90IHNldAojIENPTkZJR19ORVRfTVBMU19H
U08gaXMgbm90IHNldApDT05GSUdfUlBTPXkKQ09ORklHX1JGU19BQ0NFTD15CkNPTkZJR19YUFM9
eQojIENPTkZJR19ORVRQUklPX0NHUk9VUCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfUlhfQlVTWV9Q
T0xMPXkKQ09ORklHX0JRTD15CiMgQ09ORklHX0JQRl9KSVQgaXMgbm90IHNldApDT05GSUdfTkVU
X0ZMT1dfTElNSVQ9eQoKIwojIE5ldHdvcmsgdGVzdGluZwojCiMgQ09ORklHX05FVF9QS1RHRU4g
aXMgbm90IHNldAojIENPTkZJR19IQU1SQURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0NBTiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lSREEgaXMgbm90IHNldAojIENPTkZJR19CVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FGX1JYUlBDIGlzIG5vdCBzZXQKQ09ORklHX1dJUkVMRVNTPXkKQ09ORklHX0NGRzgw
MjExPXkKIyBDT05GSUdfTkw4MDIxMV9URVNUTU9ERSBpcyBub3Qgc2V0CiMgQ09ORklHX0NGRzgw
MjExX0RFVkVMT1BFUl9XQVJOSU5HUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NGRzgwMjExX1JFR19E
RUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0NGRzgwMjExX0NFUlRJRklDQVRJT05fT05VUyBpcyBu
b3Qgc2V0CkNPTkZJR19DRkc4MDIxMV9ERUZBVUxUX1BTPXkKIyBDT05GSUdfQ0ZHODAyMTFfREVC
VUdGUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NGRzgwMjExX0lOVEVSTkFMX1JFR0RCIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ0ZHODAyMTFfV0VYVCBpcyBub3Qgc2V0CiMgQ09ORklHX0xJQjgwMjExIGlz
IG5vdCBzZXQKQ09ORklHX01BQzgwMjExPXkKQ09ORklHX01BQzgwMjExX0hBU19SQz15CiMgQ09O
RklHX01BQzgwMjExX1JDX1BJRCBpcyBub3Qgc2V0CkNPTkZJR19NQUM4MDIxMV9SQ19NSU5TVFJF
TD15CkNPTkZJR19NQUM4MDIxMV9SQ19NSU5TVFJFTF9IVD15CkNPTkZJR19NQUM4MDIxMV9SQ19E
RUZBVUxUX01JTlNUUkVMPXkKQ09ORklHX01BQzgwMjExX1JDX0RFRkFVTFQ9Im1pbnN0cmVsX2h0
IgojIENPTkZJR19NQUM4MDIxMV9NRVNIIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFDODAyMTFfTEVE
UyBpcyBub3Qgc2V0CiMgQ09ORklHX01BQzgwMjExX0RFQlVHRlMgaXMgbm90IHNldAojIENPTkZJ
R19NQUM4MDIxMV9NRVNTQUdFX1RSQUNJTkcgaXMgbm90IHNldAojIENPTkZJR19NQUM4MDIxMV9E
RUJVR19NRU5VIGlzIG5vdCBzZXQKIyBDT05GSUdfV0lNQVggaXMgbm90IHNldApDT05GSUdfUkZL
SUxMPXkKQ09ORklHX1JGS0lMTF9JTlBVVD15CiMgQ09ORklHX1JGS0lMTF9SRUdVTEFUT1IgaXMg
bm90IHNldAojIENPTkZJR19SRktJTExfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF85UCBp
cyBub3Qgc2V0CiMgQ09ORklHX0NBSUYgaXMgbm90IHNldAojIENPTkZJR19DRVBIX0xJQiBpcyBu
b3Qgc2V0CiMgQ09ORklHX05GQyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0JQRl9KSVQ9eQoKIwoj
IERldmljZSBEcml2ZXJzCiMKCiMKIyBHZW5lcmljIERyaXZlciBPcHRpb25zCiMKQ09ORklHX1VF
VkVOVF9IRUxQRVJfUEFUSD0iIgpDT05GSUdfREVWVE1QRlM9eQpDT05GSUdfREVWVE1QRlNfTU9V
TlQ9eQojIENPTkZJR19TVEFOREFMT05FIGlzIG5vdCBzZXQKQ09ORklHX1BSRVZFTlRfRklSTVdB
UkVfQlVJTEQ9eQpDT05GSUdfRldfTE9BREVSPXkKQ09ORklHX0ZJUk1XQVJFX0lOX0tFUk5FTD15
CkNPTkZJR19FWFRSQV9GSVJNV0FSRT0iIgpDT05GSUdfRldfTE9BREVSX1VTRVJfSEVMUEVSPXkK
IyBDT05GSUdfREVCVUdfRFJJVkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfREVWUkVTIGlz
IG5vdCBzZXQKIyBDT05GSUdfU1lTX0hZUEVSVklTT1IgaXMgbm90IHNldAojIENPTkZJR19HRU5F
UklDX0NQVV9ERVZJQ0VTIGlzIG5vdCBzZXQKQ09ORklHX1JFR01BUD15CkNPTkZJR19SRUdNQVBf
STJDPXkKQ09ORklHX1JFR01BUF9TUEk9eQpDT05GSUdfUkVHTUFQX01NSU89eQpDT05GSUdfUkVH
TUFQX0lSUT15CkNPTkZJR19ETUFfU0hBUkVEX0JVRkZFUj15CgojCiMgQnVzIGRldmljZXMKIwpD
T05GSUdfSU1YX1dFSU09eQojIENPTkZJR19BUk1fQ0NJIGlzIG5vdCBzZXQKQ09ORklHX0NPTk5F
Q1RPUj15CkNPTkZJR19QUk9DX0VWRU5UUz15CkNPTkZJR19NVEQ9eQojIENPTkZJR19NVERfVEVT
VFMgaXMgbm90IHNldAojIENPTkZJR19NVERfUkVEQk9PVF9QQVJUUyBpcyBub3Qgc2V0CkNPTkZJ
R19NVERfQ01ETElORV9QQVJUUz15CiMgQ09ORklHX01URF9BRlNfUEFSVFMgaXMgbm90IHNldApD
T05GSUdfTVREX09GX1BBUlRTPXkKIyBDT05GSUdfTVREX0FSN19QQVJUUyBpcyBub3Qgc2V0Cgoj
CiMgVXNlciBNb2R1bGVzIEFuZCBUcmFuc2xhdGlvbiBMYXllcnMKIwpDT05GSUdfTVREX0JMS0RF
VlM9eQpDT05GSUdfTVREX0JMT0NLPXkKIyBDT05GSUdfRlRMIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkZUTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORlRMIGlzIG5vdCBzZXQKIyBDT05GSUdfUkZEX0ZU
TCBpcyBub3Qgc2V0CiMgQ09ORklHX1NTRkRDIGlzIG5vdCBzZXQKIyBDT05GSUdfU01fRlRMIGlz
IG5vdCBzZXQKIyBDT05GSUdfTVREX09PUFMgaXMgbm90IHNldAojIENPTkZJR19NVERfU1dBUCBp
cyBub3Qgc2V0CgojCiMgUkFNL1JPTS9GbGFzaCBjaGlwIGRyaXZlcnMKIwpDT05GSUdfTVREX0NG
ST15CkNPTkZJR19NVERfSkVERUNQUk9CRT15CkNPTkZJR19NVERfR0VOX1BST0JFPXkKIyBDT05G
SUdfTVREX0NGSV9BRFZfT1BUSU9OUyBpcyBub3Qgc2V0CkNPTkZJR19NVERfTUFQX0JBTktfV0lE
VEhfMT15CkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhfMj15CkNPTkZJR19NVERfTUFQX0JBTktf
V0lEVEhfND15CiMgQ09ORklHX01URF9NQVBfQkFOS19XSURUSF84IGlzIG5vdCBzZXQKIyBDT05G
SUdfTVREX01BUF9CQU5LX1dJRFRIXzE2IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX01BUF9CQU5L
X1dJRFRIXzMyIGlzIG5vdCBzZXQKQ09ORklHX01URF9DRklfSTE9eQpDT05GSUdfTVREX0NGSV9J
Mj15CiMgQ09ORklHX01URF9DRklfSTQgaXMgbm90IHNldAojIENPTkZJR19NVERfQ0ZJX0k4IGlz
IG5vdCBzZXQKQ09ORklHX01URF9DRklfSU5URUxFWFQ9eQpDT05GSUdfTVREX0NGSV9BTURTVEQ9
eQpDT05GSUdfTVREX0NGSV9TVEFBPXkKQ09ORklHX01URF9DRklfVVRJTD15CiMgQ09ORklHX01U
RF9SQU0gaXMgbm90IHNldAojIENPTkZJR19NVERfUk9NIGlzIG5vdCBzZXQKIyBDT05GSUdfTVRE
X0FCU0VOVCBpcyBub3Qgc2V0CgojCiMgTWFwcGluZyBkcml2ZXJzIGZvciBjaGlwIGFjY2Vzcwoj
CiMgQ09ORklHX01URF9DT01QTEVYX01BUFBJTkdTIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX1BI
WVNNQVAgaXMgbm90IHNldApDT05GSUdfTVREX1BIWVNNQVBfT0Y9eQojIENPTkZJR19NVERfSU1Q
QTcgaXMgbm90IHNldAojIENPTkZJR19NVERfUExBVFJBTSBpcyBub3Qgc2V0CgojCiMgU2VsZi1j
b250YWluZWQgTVREIGRldmljZSBkcml2ZXJzCiMKQ09ORklHX01URF9EQVRBRkxBU0g9eQojIENP
TkZJR19NVERfREFUQUZMQVNIX1dSSVRFX1ZFUklGWSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9E
QVRBRkxBU0hfT1RQIGlzIG5vdCBzZXQKQ09ORklHX01URF9NMjVQODA9eQpDT05GSUdfTTI1UFhY
X1VTRV9GQVNUX1JFQUQ9eQpDT05GSUdfTVREX1NTVDI1TD15CiMgQ09ORklHX01URF9TTFJBTSBp
cyBub3Qgc2V0CiMgQ09ORklHX01URF9QSFJBTSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9NVERS
QU0gaXMgbm90IHNldAojIENPTkZJR19NVERfQkxPQ0syTVREIGlzIG5vdCBzZXQKCiMKIyBEaXNr
LU9uLUNoaXAgRGV2aWNlIERyaXZlcnMKIwojIENPTkZJR19NVERfRE9DRzMgaXMgbm90IHNldApD
T05GSUdfTVREX05BTkRfRUNDPXkKIyBDT05GSUdfTVREX05BTkRfRUNDX1NNQyBpcyBub3Qgc2V0
CkNPTkZJR19NVERfTkFORD15CiMgQ09ORklHX01URF9OQU5EX0VDQ19CQ0ggaXMgbm90IHNldAoj
IENPTkZJR19NVERfU01fQ09NTU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX05BTkRfREVOQUxJ
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX05BTkRfR1BJTyBpcyBub3Qgc2V0CkNPTkZJR19NVERf
TkFORF9JRFM9eQojIENPTkZJR19NVERfTkFORF9ESVNLT05DSElQIGlzIG5vdCBzZXQKIyBDT05G
SUdfTVREX05BTkRfRE9DRzQgaXMgbm90IHNldAojIENPTkZJR19NVERfTkFORF9OQU5EU0lNIGlz
IG5vdCBzZXQKQ09ORklHX01URF9OQU5EX0dQTUlfTkFORD15CiMgQ09ORklHX01URF9OQU5EX1BM
QVRGT1JNIGlzIG5vdCBzZXQKQ09ORklHX01URF9OQU5EX01YQz15CiMgQ09ORklHX01URF9PTkVO
QU5EIGlzIG5vdCBzZXQKCiMKIyBMUEREUiBmbGFzaCBtZW1vcnkgZHJpdmVycwojCiMgQ09ORklH
X01URF9MUEREUiBpcyBub3Qgc2V0CkNPTkZJR19NVERfVUJJPXkKQ09ORklHX01URF9VQklfV0xf
VEhSRVNIT0xEPTQwOTYKQ09ORklHX01URF9VQklfQkVCX0xJTUlUPTIwCiMgQ09ORklHX01URF9V
QklfRkFTVE1BUCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9VQklfR0xVRUJJIGlzIG5vdCBzZXQK
Q09ORklHX0RUQz15CkNPTkZJR19PRj15CgojCiMgRGV2aWNlIFRyZWUgYW5kIE9wZW4gRmlybXdh
cmUgc3VwcG9ydAojCiMgQ09ORklHX1BST0NfREVWSUNFVFJFRSBpcyBub3Qgc2V0CiMgQ09ORklH
X09GX1NFTEZURVNUIGlzIG5vdCBzZXQKQ09ORklHX09GX0ZMQVRUUkVFPXkKQ09ORklHX09GX0VB
UkxZX0ZMQVRUUkVFPXkKQ09ORklHX09GX0FERFJFU1M9eQpDT05GSUdfT0ZfSVJRPXkKQ09ORklH
X09GX05FVD15CkNPTkZJR19PRl9NRElPPXkKQ09ORklHX09GX01URD15CkNPTkZJR19PRl9SRVNF
UlZFRF9NRU09eQojIENPTkZJR19QQVJQT1JUIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVY9eQoj
IENPTkZJR19CTEtfREVWX0NPV19DT01NT04gaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9MT09Q
PXkKQ09ORklHX0JMS19ERVZfTE9PUF9NSU5fQ09VTlQ9OAojIENPTkZJR19CTEtfREVWX0NSWVBU
T0xPT1AgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0RSQkQgaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX05CRCBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1JBTT15CkNPTkZJR19CTEtf
REVWX1JBTV9DT1VOVD0xNgpDT05GSUdfQkxLX0RFVl9SQU1fU0laRT02NTUzNgojIENPTkZJR19C
TEtfREVWX1hJUCBpcyBub3Qgc2V0CiMgQ09ORklHX0NEUk9NX1BLVENEVkQgaXMgbm90IHNldAoj
IENPTkZJR19BVEFfT1ZFUl9FVEggaXMgbm90IHNldAojIENPTkZJR19NR19ESVNLIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQkxLX0RFVl9SQkQgaXMgbm90IHNldAoKIwojIE1pc2MgZGV2aWNlcwojCiMg
Q09ORklHX1NFTlNPUlNfTElTM0xWMDJEIGlzIG5vdCBzZXQKIyBDT05GSUdfQUQ1MjVYX0RQT1Qg
aXMgbm90IHNldAojIENPTkZJR19BVE1FTF9QV00gaXMgbm90IHNldAojIENPTkZJR19EVU1NWV9J
UlEgaXMgbm90IHNldAojIENPTkZJR19JQ1M5MzJTNDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRN
RUxfU1NDIGlzIG5vdCBzZXQKIyBDT05GSUdfRU5DTE9TVVJFX1NFUlZJQ0VTIGlzIG5vdCBzZXQK
IyBDT05GSUdfQVBEUzk4MDJBTFMgaXMgbm90IHNldAojIENPTkZJR19JU0wyOTAwMyBpcyBub3Qg
c2V0CiMgQ09ORklHX0lTTDI5MDIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UU0wyNTUw
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19CSDE3ODAgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0JIMTc3MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVBEUzk5MFggaXMgbm90
IHNldAojIENPTkZJR19ITUM2MzUyIGlzIG5vdCBzZXQKIyBDT05GSUdfRFMxNjgyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVElfREFDNzUxMiBpcyBub3Qgc2V0CiMgQ09ORklHX0JNUDA4NV9JMkMgaXMg
bm90IHNldAojIENPTkZJR19CTVAwODVfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NXSVRD
SF9GU0E5NDgwIGlzIG5vdCBzZXQKIyBDT05GSUdfTEFUVElDRV9FQ1AzX0NPTkZJRyBpcyBub3Qg
c2V0CkNPTkZJR19TUkFNPXkKIyBDT05GSUdfQzJQT1JUIGlzIG5vdCBzZXQKCiMKIyBFRVBST00g
c3VwcG9ydAojCkNPTkZJR19FRVBST01fQVQyND15CkNPTkZJR19FRVBST01fQVQyNT15CiMgQ09O
RklHX0VFUFJPTV9MRUdBQ1kgaXMgbm90IHNldAojIENPTkZJR19FRVBST01fTUFYNjg3NSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0VFUFJPTV85M0NYNiBpcyBub3Qgc2V0CiMgQ09ORklHX0VFUFJPTV85
M1hYNDYgaXMgbm90IHNldAoKIwojIFRleGFzIEluc3RydW1lbnRzIHNoYXJlZCB0cmFuc3BvcnQg
bGluZSBkaXNjaXBsaW5lCiMKIyBDT05GSUdfVElfU1QgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX0xJUzNfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MSVMzX0kyQyBpcyBub3Qg
c2V0CgojCiMgQWx0ZXJhIEZQR0EgZmlybXdhcmUgZG93bmxvYWQgbW9kdWxlCiMKIyBDT05GSUdf
QUxURVJBX1NUQVBMIGlzIG5vdCBzZXQKCiMKIyBTQ1NJIGRldmljZSBzdXBwb3J0CiMKQ09ORklH
X1NDU0lfTU9EPXkKIyBDT05GSUdfUkFJRF9BVFRSUyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJPXkK
Q09ORklHX1NDU0lfRE1BPXkKIyBDT05GSUdfU0NTSV9UR1QgaXMgbm90IHNldAojIENPTkZJR19T
Q1NJX05FVExJTksgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1BST0NfRlMgaXMgbm90IHNldAoK
IwojIFNDU0kgc3VwcG9ydCB0eXBlIChkaXNrLCB0YXBlLCBDRC1ST00pCiMKQ09ORklHX0JMS19E
RVZfU0Q9eQojIENPTkZJR19DSFJfREVWX1NUIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hSX0RFVl9P
U1NUIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9TUiBpcyBub3Qgc2V0CiMgQ09ORklHX0NI
Ul9ERVZfU0cgaXMgbm90IHNldAojIENPTkZJR19DSFJfREVWX1NDSCBpcyBub3Qgc2V0CkNPTkZJ
R19TQ1NJX01VTFRJX0xVTj15CkNPTkZJR19TQ1NJX0NPTlNUQU5UUz15CkNPTkZJR19TQ1NJX0xP
R0dJTkc9eQpDT05GSUdfU0NTSV9TQ0FOX0FTWU5DPXkKCiMKIyBTQ1NJIFRyYW5zcG9ydHMKIwoj
IENPTkZJR19TQ1NJX1NQSV9BVFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfRkNfQVRUUlMg
aXMgbm90IHNldAojIENPTkZJR19TQ1NJX0lTQ1NJX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0NTSV9TQVNfQVRUUlMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NBU19MSUJTQVMgaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX1NSUF9BVFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfTE9X
TEVWRUwgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0RIIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9PU0RfSU5JVElBVE9SIGlzIG5vdCBzZXQKQ09ORklHX0FUQT15CiMgQ09ORklHX0FUQV9OT05T
VEFOREFSRCBpcyBub3Qgc2V0CkNPTkZJR19BVEFfVkVSQk9TRV9FUlJPUj15CkNPTkZJR19TQVRB
X1BNUD15CgojCiMgQ29udHJvbGxlcnMgd2l0aCBub24tU0ZGIG5hdGl2ZSBpbnRlcmZhY2UKIwpD
T05GSUdfU0FUQV9BSENJX1BMQVRGT1JNPXkKQ09ORklHX0FIQ0lfSU1YPXkKQ09ORklHX0FUQV9T
RkY9eQoKIwojIFNGRiBjb250cm9sbGVycyB3aXRoIGN1c3RvbSBETUEgaW50ZXJmYWNlCiMKQ09O
RklHX0FUQV9CTURNQT15CgojCiMgU0FUQSBTRkYgY29udHJvbGxlcnMgd2l0aCBCTURNQQojCiMg
Q09ORklHX1NBVEFfSElHSEJBTksgaXMgbm90IHNldAojIENPTkZJR19TQVRBX01WIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0FUQV9SQ0FSIGlzIG5vdCBzZXQKCiMKIyBQQVRBIFNGRiBjb250cm9sbGVy
cyB3aXRoIEJNRE1BCiMKIyBDT05GSUdfUEFUQV9BUkFTQU5fQ0YgaXMgbm90IHNldApDT05GSUdf
UEFUQV9JTVg9eQoKIwojIFBJTy1vbmx5IFNGRiBjb250cm9sbGVycwojCiMgQ09ORklHX1BBVEFf
UExBVEZPUk0gaXMgbm90IHNldAoKIwojIEdlbmVyaWMgZmFsbGJhY2sgLyBsZWdhY3kgZHJpdmVy
cwojCiMgQ09ORklHX01EIGlzIG5vdCBzZXQKIyBDT05GSUdfVEFSR0VUX0NPUkUgaXMgbm90IHNl
dApDT05GSUdfTkVUREVWSUNFUz15CkNPTkZJR19NSUk9eQpDT05GSUdfTkVUX0NPUkU9eQojIENP
TkZJR19CT05ESU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfRFVNTVkgaXMgbm90IHNldAojIENPTkZJ
R19FUVVBTElaRVIgaXMgbm90IHNldAojIENPTkZJR19ORVRfVEVBTSBpcyBub3Qgc2V0CiMgQ09O
RklHX01BQ1ZMQU4gaXMgbm90IHNldAojIENPTkZJR19WWExBTiBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVENPTlNPTEUgaXMgbm90IHNldAojIENPTkZJR19ORVRQT0xMIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVUX1BPTExfQ09OVFJPTExFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1RVTiBpcyBub3Qgc2V0
CiMgQ09ORklHX1ZFVEggaXMgbm90IHNldAojIENPTkZJR19OTE1PTiBpcyBub3Qgc2V0CgojCiMg
Q0FJRiB0cmFuc3BvcnQgZHJpdmVycwojCgojCiMgRGlzdHJpYnV0ZWQgU3dpdGNoIEFyY2hpdGVj
dHVyZSBkcml2ZXJzCiMKIyBDT05GSUdfTkVUX0RTQV9NVjg4RTZYWFggaXMgbm90IHNldAojIENP
TkZJR19ORVRfRFNBX01WODhFNjA2MCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9EU0FfTVY4OEU2
WFhYX05FRURfUFBVIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RTQV9NVjg4RTYxMzEgaXMgbm90
IHNldAojIENPTkZJR19ORVRfRFNBX01WODhFNjEyM182MV82NSBpcyBub3Qgc2V0CkNPTkZJR19F
VEhFUk5FVD15CkNPTkZJR19ORVRfVkVORE9SX0FSQz15CiMgQ09ORklHX0FSQ19FTUFDIGlzIG5v
dCBzZXQKQ09ORklHX05FVF9DQURFTkNFPXkKIyBDT05GSUdfQVJNX0FUOTFfRVRIRVIgaXMgbm90
IHNldAojIENPTkZJR19NQUNCIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9CUk9BRENP
TSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9DQUxYRURBX1hHTUFDIGlzIG5vdCBzZXQKQ09ORklH
X05FVF9WRU5ET1JfQ0lSUlVTPXkKQ09ORklHX0NTODl4MD15CkNPTkZJR19DUzg5eDBfUExBVEZP
Uk09eQojIENPTkZJR19ETTkwMDAgaXMgbm90IHNldAojIENPTkZJR19ETkVUIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkVUX1ZFTkRPUl9GQVJBREFZIGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1Jf
RlJFRVNDQUxFPXkKQ09ORklHX0ZFQz15CiMgQ09ORklHX05FVF9WRU5ET1JfSU5URUwgaXMgbm90
IHNldAojIENPTkZJR19ORVRfVkVORE9SX01BUlZFTEwgaXMgbm90IHNldAojIENPTkZJR19ORVRf
VkVORE9SX01JQ1JFTCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfTUlDUk9DSElQIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9OQVRTRU1JIGlzIG5vdCBzZXQKIyBDT05GSUdf
RVRIT0MgaXMgbm90IHNldAojIENPTkZJR19TSF9FVEggaXMgbm90IHNldAojIENPTkZJR19ORVRf
VkVORE9SX1NFRVEgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9TTVNDPXkKQ09ORklHX1NN
QzkxWD15CkNPTkZJR19TTUM5MTFYPXkKQ09ORklHX1NNU0M5MTFYPXkKIyBDT05GSUdfU01TQzkx
MVhfQVJDSF9IT09LUyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfU1RNSUNSTyBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1ZJQT15CiMgQ09ORklHX1ZJQV9WRUxPQ0lUWSBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1dJWk5FVD15CiMgQ09ORklHX1dJWk5FVF9XNTEwMCBp
cyBub3Qgc2V0CiMgQ09ORklHX1dJWk5FVF9XNTMwMCBpcyBub3Qgc2V0CkNPTkZJR19QSFlMSUI9
eQoKIwojIE1JSSBQSFkgZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJR19BVDgwM1hfUEhZIGlzIG5v
dCBzZXQKIyBDT05GSUdfQU1EX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX01BUlZFTExfUEhZIGlz
IG5vdCBzZXQKIyBDT05GSUdfREFWSUNPTV9QSFkgaXMgbm90IHNldAojIENPTkZJR19RU0VNSV9Q
SFkgaXMgbm90IHNldAojIENPTkZJR19MWFRfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0lDQURB
X1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJVEVTU0VfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdf
U01TQ19QSFkgaXMgbm90IHNldAojIENPTkZJR19CUk9BRENPTV9QSFkgaXMgbm90IHNldAojIENP
TkZJR19CQ004N1hYX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lDUExVU19QSFkgaXMgbm90IHNl
dAojIENPTkZJR19SRUFMVEVLX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX05BVElPTkFMX1BIWSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NURTEwWFAgaXMgbm90IHNldAojIENPTkZJR19MU0lfRVQxMDEx
Q19QSFkgaXMgbm90IHNldAojIENPTkZJR19NSUNSRUxfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdf
RklYRURfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTURJT19CSVRCQU5HIGlzIG5vdCBzZXQKIyBD
T05GSUdfTURJT19CVVNfTVVYX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19NRElPX0JVU19NVVhf
TU1JT1JFRyBpcyBub3Qgc2V0CiMgQ09ORklHX01JQ1JFTF9LUzg5OTVNQSBpcyBub3Qgc2V0CiMg
Q09ORklHX1BQUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NMSVAgaXMgbm90IHNldAoKIwojIFVTQiBO
ZXR3b3JrIEFkYXB0ZXJzCiMKIyBDT05GSUdfVVNCX0NBVEMgaXMgbm90IHNldAojIENPTkZJR19V
U0JfS0FXRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1BFR0FTVVMgaXMgbm90IHNldAojIENP
TkZJR19VU0JfUlRMODE1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9SVEw4MTUyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1VTQk5FVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9IU08gaXMgbm90
IHNldAojIENPTkZJR19VU0JfSVBIRVRIIGlzIG5vdCBzZXQKQ09ORklHX1dMQU49eQojIENPTkZJ
R19MSUJFUlRBU19USElORklSTSBpcyBub3Qgc2V0CiMgQ09ORklHX0FUNzZDNTBYX1VTQiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9aRDEyMDEgaXMgbm90IHNldAojIENPTkZJR19VU0JfTkVUX1JO
RElTX1dMQU4gaXMgbm90IHNldAojIENPTkZJR19SVEw4MTg3IGlzIG5vdCBzZXQKIyBDT05GSUdf
TUFDODAyMTFfSFdTSU0gaXMgbm90IHNldAojIENPTkZJR19BVEhfQ0FSRFMgaXMgbm90IHNldAoj
IENPTkZJR19CNDMgaXMgbm90IHNldAojIENPTkZJR19CNDNMRUdBQ1kgaXMgbm90IHNldApDT05G
SUdfQlJDTVVUSUw9bQpDT05GSUdfQlJDTUZNQUM9bQpDT05GSUdfQlJDTUZNQUNfU0RJTz15CiMg
Q09ORklHX0JSQ01GTUFDX1VTQiBpcyBub3Qgc2V0CkNPTkZJR19CUkNNX1RSQUNJTkc9eQpDT05G
SUdfQlJDTURCRz15CiMgQ09ORklHX0hPU1RBUCBpcyBub3Qgc2V0CiMgQ09ORklHX0xJQkVSVEFT
IGlzIG5vdCBzZXQKIyBDT05GSUdfUDU0X0NPTU1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUMlgw
MCBpcyBub3Qgc2V0CkNPTkZJR19SVExfQ0FSRFM9eQojIENPTkZJR19SVEw4MTkyQ1UgaXMgbm90
IHNldAojIENPTkZJR19XTF9USSBpcyBub3Qgc2V0CiMgQ09ORklHX1pEMTIxMVJXIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTVdJRklFWCBpcyBub3Qgc2V0CiMgQ09ORklHX0NXMTIwMCBpcyBub3Qgc2V0
CgojCiMgRW5hYmxlIFdpTUFYIChOZXR3b3JraW5nIG9wdGlvbnMpIHRvIHNlZSB0aGUgV2lNQVgg
ZHJpdmVycwojCiMgQ09ORklHX1dBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lTRE4gaXMgbm90IHNl
dAoKIwojIElucHV0IGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0lOUFVUPXkKIyBDT05GSUdfSU5Q
VVRfRkZfTUVNTEVTUyBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9QT0xMREVWPXkKIyBDT05GSUdf
SU5QVVRfU1BBUlNFS01BUCBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9NQVRSSVhLTUFQPXkKCiMK
IyBVc2VybGFuZCBpbnRlcmZhY2VzCiMKQ09ORklHX0lOUFVUX01PVVNFREVWPXkKIyBDT05GSUdf
SU5QVVRfTU9VU0VERVZfUFNBVVggaXMgbm90IHNldApDT05GSUdfSU5QVVRfTU9VU0VERVZfU0NS
RUVOX1g9MTAyNApDT05GSUdfSU5QVVRfTU9VU0VERVZfU0NSRUVOX1k9NzY4CiMgQ09ORklHX0lO
UFVUX0pPWURFViBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9FVkRFVj15CkNPTkZJR19JTlBVVF9F
VkJVRz1tCgojCiMgSW5wdXQgRGV2aWNlIERyaXZlcnMKIwpDT05GSUdfSU5QVVRfS0VZQk9BUkQ9
eQojIENPTkZJR19LRVlCT0FSRF9BRFA1NTg4IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRf
QURQNTU4OSBpcyBub3Qgc2V0CkNPTkZJR19LRVlCT0FSRF9BVEtCRD15CiMgQ09ORklHX0tFWUJP
QVJEX1FUMTA3MCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1FUMjE2MCBpcyBub3Qgc2V0
CiMgQ09ORklHX0tFWUJPQVJEX0xLS0JEIGlzIG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX0dQSU89
eQojIENPTkZJR19LRVlCT0FSRF9UQ0E2NDE2IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRf
VENBODQxOCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX01BVFJJWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0tFWUJPQVJEX0xNODMyMyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0xNODMz
MyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX01BWDczNTkgaXMgbm90IHNldAojIENPTkZJ
R19LRVlCT0FSRF9NQ1MgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9NUFIxMjEgaXMgbm90
IHNldApDT05GSUdfS0VZQk9BUkRfSU1YPXkKIyBDT05GSUdfS0VZQk9BUkRfTkVXVE9OIGlzIG5v
dCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfT1BFTkNPUkVTIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZ
Qk9BUkRfU0FNU1VORyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1NUT1dBV0FZIGlzIG5v
dCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfU1VOS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9B
UkRfWFRLQkQgaXMgbm90IHNldApDT05GSUdfSU5QVVRfTU9VU0U9eQpDT05GSUdfTU9VU0VfUFMy
PW0KQ09ORklHX01PVVNFX1BTMl9BTFBTPXkKQ09ORklHX01PVVNFX1BTMl9MT0dJUFMyUFA9eQpD
T05GSUdfTU9VU0VfUFMyX1NZTkFQVElDUz15CkNPTkZJR19NT1VTRV9QUzJfQ1lQUkVTUz15CkNP
TkZJR19NT1VTRV9QUzJfVFJBQ0tQT0lOVD15CkNPTkZJR19NT1VTRV9QUzJfRUxBTlRFQ0g9eQoj
IENPTkZJR19NT1VTRV9QUzJfU0VOVEVMSUMgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9QUzJf
VE9VQ0hLSVQgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9TRVJJQUwgaXMgbm90IHNldAojIENP
TkZJR19NT1VTRV9BUFBMRVRPVUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfQkNNNTk3NCBp
cyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX0NZQVBBIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0Vf
VlNYWFhBQSBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX0dQSU8gaXMgbm90IHNldAojIENPTkZJ
R19NT1VTRV9TWU5BUFRJQ1NfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfU1lOQVBUSUNT
X1VTQiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0pPWVNUSUNLIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5QVVRfVEFCTEVUIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX1RPVUNIU0NSRUVOPXkKIyBD
T05GSUdfVE9VQ0hTQ1JFRU5fQURTNzg0NiBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVO
X0FENzg3NyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0FENzg3OSBpcyBub3Qgc2V0
CiMgQ09ORklHX1RPVUNIU0NSRUVOX0FUTUVMX01YVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNI
U0NSRUVOX0FVT19QSVhDSVIgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9CVTIxMDEz
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQ1k4Q1RNRzExMCBpcyBub3Qgc2V0CiMg
Q09ORklHX1RPVUNIU0NSRUVOX0NZVFRTUF9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hT
Q1JFRU5fQ1lUVFNQNF9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fREE5MDUy
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fRFlOQVBSTyBpcyBub3Qgc2V0CiMgQ09O
RklHX1RPVUNIU0NSRUVOX0hBTVBTSElSRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVO
X0VFVEkgaXMgbm90IHNldApDT05GSUdfVE9VQ0hTQ1JFRU5fRUdBTEFYPXkKIyBDT05GSUdfVE9V
Q0hTQ1JFRU5fRlVKSVRTVSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0lMSTIxMFgg
aXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9HVU5aRSBpcyBub3Qgc2V0CiMgQ09ORklH
X1RPVUNIU0NSRUVOX0VMTyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1dBQ09NX1c4
MDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fV0FDT01fSTJDIGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fTUFYMTE4MDEgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFND
UkVFTl9NQ1M1MDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTU1TMTE0IGlzIG5v
dCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTVRPVUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9V
Q0hTQ1JFRU5fSU5FWElPIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTUs3MTIgaXMg
bm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9QRU5NT1VOVCBpcyBub3Qgc2V0CiMgQ09ORklH
X1RPVUNIU0NSRUVOX0VEVF9GVDVYMDYgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9U
T1VDSFJJR0hUIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hXSU4gaXMgbm90
IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9QSVhDSVIgaXMgbm90IHNldAojIENPTkZJR19UT1VD
SFNDUkVFTl9XTTk3WFggaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9VU0JfQ09NUE9T
SVRFIGlzIG5vdCBzZXQKQ09ORklHX1RPVUNIU0NSRUVOX01DMTM3ODM9eQojIENPTkZJR19UT1VD
SFNDUkVFTl9UT1VDSElUMjEzIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFNDX1NF
UklPIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFNDMjAwNSBpcyBub3Qgc2V0CiMg
Q09ORklHX1RPVUNIU0NSRUVOX1RTQzIwMDcgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVF
Tl9XOTBYOTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fU1QxMjMyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFBTNjUwN1ggaXMgbm90IHNldApDT05GSUdfSU5QVVRf
TUlTQz15CiMgQ09ORklHX0lOUFVUX0FENzE0WCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0JN
QTE1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX01DMTM3ODNfUFdSQlVUVE9OIGlzIG5vdCBz
ZXQKQ09ORklHX0lOUFVUX01NQTg0NTA9eQojIENPTkZJR19JTlBVVF9NUFUzMDUwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSU5QVVRfR1AyQSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0dQSU9fVElM
VF9QT0xMRUQgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9BVElfUkVNT1RFMiBpcyBub3Qgc2V0
CiMgQ09ORklHX0lOUFVUX0tFWVNQQU5fUkVNT1RFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRf
S1hUSjkgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9QT1dFUk1BVEUgaXMgbm90IHNldAojIENP
TkZJR19JTlBVVF9ZRUFMSU5LIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQ00xMDkgaXMgbm90
IHNldAojIENPTkZJR19JTlBVVF9VSU5QVVQgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9QQ0Y4
NTc0IGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfUFdNX0JFRVBFUiBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOUFVUX0dQSU9fUk9UQVJZX0VOQ09ERVIgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9E
QTkwNTJfT05LRVkgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9BRFhMMzRYIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5QVVRfSU1TX1BDVSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0NNQTMwMDAg
aXMgbm90IHNldAoKIwojIEhhcmR3YXJlIEkvTyBwb3J0cwojCkNPTkZJR19TRVJJTz15CkNPTkZJ
R19TRVJJT19TRVJQT1JUPW0KQ09ORklHX1NFUklPX0xJQlBTMj15CiMgQ09ORklHX1NFUklPX1JB
VyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklPX0FMVEVSQV9QUzIgaXMgbm90IHNldAojIENPTkZJ
R19TRVJJT19QUzJNVUxUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fQVJDX1BTMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFUklPX0FQQlBTMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklPX09MUENf
QVBTUCBpcyBub3Qgc2V0CiMgQ09ORklHX0dBTUVQT1JUIGlzIG5vdCBzZXQKCiMKIyBDaGFyYWN0
ZXIgZGV2aWNlcwojCkNPTkZJR19UVFk9eQpDT05GSUdfVlQ9eQpDT05GSUdfQ09OU09MRV9UUkFO
U0xBVElPTlM9eQpDT05GSUdfVlRfQ09OU09MRT15CkNPTkZJR19WVF9DT05TT0xFX1NMRUVQPXkK
Q09ORklHX0hXX0NPTlNPTEU9eQpDT05GSUdfVlRfSFdfQ09OU09MRV9CSU5ESU5HPXkKQ09ORklH
X1VOSVg5OF9QVFlTPXkKIyBDT05GSUdfREVWUFRTX01VTFRJUExFX0lOU1RBTkNFUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0xFR0FDWV9QVFlTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX05PTlNU
QU5EQVJEIGlzIG5vdCBzZXQKIyBDT05GSUdfTl9HU00gaXMgbm90IHNldAojIENPTkZJR19UUkFD
RV9TSU5LIGlzIG5vdCBzZXQKIyBDT05GSUdfREVWS01FTSBpcyBub3Qgc2V0CgojCiMgU2VyaWFs
IGRyaXZlcnMKIwojIENPTkZJR19TRVJJQUxfODI1MCBpcyBub3Qgc2V0CgojCiMgTm9uLTgyNTAg
c2VyaWFsIHBvcnQgc3VwcG9ydAojCiMgQ09ORklHX1NFUklBTF9NQVgzMTAwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VSSUFMX01BWDMxMFggaXMgbm90IHNldApDT05GSUdfU0VSSUFMX0lNWD15CkNP
TkZJR19TRVJJQUxfSU1YX0NPTlNPTEU9eQpDT05GSUdfU0VSSUFMX0NPUkU9eQpDT05GSUdfU0VS
SUFMX0NPUkVfQ09OU09MRT15CiMgQ09ORklHX1NFUklBTF9TQ0NOWFAgaXMgbm90IHNldAojIENP
TkZJR19TRVJJQUxfVElNQkVSREFMRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9BTFRFUkFf
SlRBR1VBUlQgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfQUxURVJBX1VBUlQgaXMgbm90IHNl
dAojIENPTkZJR19TRVJJQUxfSUZYNlg2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9YSUxJ
TlhfUFNfVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9BUkMgaXMgbm90IHNldApDT05G
SUdfU0VSSUFMX0ZTTF9MUFVBUlQ9eQpDT05GSUdfU0VSSUFMX0ZTTF9MUFVBUlRfQ09OU09MRT15
CiMgQ09ORklHX1NFUklBTF9TVF9BU0MgaXMgbm90IHNldAojIENPTkZJR19UVFlfUFJJTlRLIGlz
IG5vdCBzZXQKIyBDT05GSUdfSFZDX0RDQyBpcyBub3Qgc2V0CiMgQ09ORklHX0lQTUlfSEFORExF
UiBpcyBub3Qgc2V0CkNPTkZJR19IV19SQU5ET009eQojIENPTkZJR19IV19SQU5ET01fVElNRVJJ
T01FTSBpcyBub3Qgc2V0CiMgQ09ORklHX0hXX1JBTkRPTV9BVE1FTCBpcyBub3Qgc2V0CkNPTkZJ
R19IV19SQU5ET01fTVhDX1JOR0E9eQojIENPTkZJR19IV19SQU5ET01fRVhZTk9TIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUjM5NjQgaXMgbm90IHNldAojIENPTkZJR19SQVdfRFJJVkVSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVENHX1RQTSBpcyBub3Qgc2V0CkNPTkZJR19JMkM9eQpDT05GSUdfSTJDX0JP
QVJESU5GTz15CiMgQ09ORklHX0kyQ19DT01QQVQgaXMgbm90IHNldApDT05GSUdfSTJDX0NIQVJE
RVY9eQojIENPTkZJR19JMkNfTVVYIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0hFTFBFUl9BVVRP
IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NNQlVTIGlzIG5vdCBzZXQKCiMKIyBJMkMgQWxnb3Jp
dGhtcwojCkNPTkZJR19JMkNfQUxHT0JJVD15CkNPTkZJR19JMkNfQUxHT1BDRj1tCkNPTkZJR19J
MkNfQUxHT1BDQT1tCgojCiMgSTJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CiMKCiMKIyBJMkMgc3lz
dGVtIGJ1cyBkcml2ZXJzIChtb3N0bHkgZW1iZWRkZWQgLyBzeXN0ZW0tb24tY2hpcCkKIwojIENP
TkZJR19JMkNfQ0JVU19HUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFU0lHTldBUkVfUExB
VEZPUk0gaXMgbm90IHNldAojIENPTkZJR19JMkNfR1BJTyBpcyBub3Qgc2V0CkNPTkZJR19JMkNf
SU1YPXkKIyBDT05GSUdfSTJDX09DT1JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19QQ0FfUExB
VEZPUk0gaXMgbm90IHNldAojIENPTkZJR19JMkNfUFhBX1BDSSBpcyBub3Qgc2V0CiMgQ09ORklH
X0kyQ19TSU1URUMgaXMgbm90IHNldAojIENPTkZJR19JMkNfWElMSU5YIGlzIG5vdCBzZXQKCiMK
IyBFeHRlcm5hbCBJMkMvU01CdXMgYWRhcHRlciBkcml2ZXJzCiMKIyBDT05GSUdfSTJDX0RJT0xB
Tl9VMkMgaXMgbm90IHNldAojIENPTkZJR19JMkNfUEFSUE9SVF9MSUdIVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0kyQ19UQU9TX0VWTSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19USU5ZX1VTQiBpcyBu
b3Qgc2V0CgojCiMgT3RoZXIgSTJDL1NNQnVzIGJ1cyBkcml2ZXJzCiMKIyBDT05GSUdfSTJDX1NU
VUIgaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0kyQ19ERUJVR19BTEdPIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0JVUyBpcyBub3Qg
c2V0CkNPTkZJR19TUEk9eQojIENPTkZJR19TUElfREVCVUcgaXMgbm90IHNldApDT05GSUdfU1BJ
X01BU1RFUj15CgojCiMgU1BJIE1hc3RlciBDb250cm9sbGVyIERyaXZlcnMKIwojIENPTkZJR19T
UElfQUxURVJBIGlzIG5vdCBzZXQKQ09ORklHX1NQSV9CSVRCQU5HPXkKIyBDT05GSUdfU1BJX0dQ
SU8gaXMgbm90IHNldApDT05GSUdfU1BJX0lNWD15CiMgQ09ORklHX1NQSV9GU0xfU1BJIGlzIG5v
dCBzZXQKIyBDT05GSUdfU1BJX0ZTTF9EU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX09DX1RJ
TlkgaXMgbm90IHNldAojIENPTkZJR19TUElfUFhBMlhYX1BDSSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NQSV9TQzE4SVM2MDIgaXMgbm90IHNldAojIENPTkZJR19TUElfWENPTU0gaXMgbm90IHNldAoj
IENPTkZJR19TUElfWElMSU5YIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX0RFU0lHTldBUkUgaXMg
bm90IHNldAoKIwojIFNQSSBQcm90b2NvbCBNYXN0ZXJzCiMKIyBDT05GSUdfU1BJX1NQSURFViBp
cyBub3Qgc2V0CiMgQ09ORklHX1NQSV9UTEU2MlgwIGlzIG5vdCBzZXQKIyBDT05GSUdfSFNJIGlz
IG5vdCBzZXQKCiMKIyBQUFMgc3VwcG9ydAojCkNPTkZJR19QUFM9eQojIENPTkZJR19QUFNfREVC
VUcgaXMgbm90IHNldAoKIwojIFBQUyBjbGllbnRzIHN1cHBvcnQKIwojIENPTkZJR19QUFNfQ0xJ
RU5UX0tUSU1FUiBpcyBub3Qgc2V0CiMgQ09ORklHX1BQU19DTElFTlRfTERJU0MgaXMgbm90IHNl
dAojIENPTkZJR19QUFNfQ0xJRU5UX0dQSU8gaXMgbm90IHNldAoKIwojIFBQUyBnZW5lcmF0b3Jz
IHN1cHBvcnQKIwoKIwojIFBUUCBjbG9jayBzdXBwb3J0CiMKQ09ORklHX1BUUF8xNTg4X0NMT0NL
PXkKCiMKIyBFbmFibGUgUEhZTElCIGFuZCBORVRXT1JLX1BIWV9USU1FU1RBTVBJTkcgdG8gc2Vl
IHRoZSBhZGRpdGlvbmFsIGNsb2Nrcy4KIwpDT05GSUdfUElOQ1RSTD15CgojCiMgUGluIGNvbnRy
b2xsZXJzCiMKQ09ORklHX1BJTk1VWD15CkNPTkZJR19QSU5DT05GPXkKIyBDT05GSUdfREVCVUdf
UElOQ1RSTCBpcyBub3Qgc2V0CkNPTkZJR19QSU5DVFJMX0lNWD15CiMgQ09ORklHX1BJTkNUUkxf
SU1YMzUgaXMgbm90IHNldApDT05GSUdfUElOQ1RSTF9JTVg1MT15CkNPTkZJR19QSU5DVFJMX0lN
WDUzPXkKQ09ORklHX1BJTkNUUkxfSU1YNlE9eQpDT05GSUdfUElOQ1RSTF9JTVg2U0w9eQpDT05G
SUdfUElOQ1RSTF9WRjYxMD15CiMgQ09ORklHX1BJTkNUUkxfU0lOR0xFIGlzIG5vdCBzZXQKQ09O
RklHX0FSQ0hfSEFWRV9DVVNUT01fR1BJT19IPXkKQ09ORklHX0FSQ0hfUkVRVUlSRV9HUElPTElC
PXkKQ09ORklHX0dQSU9fREVWUkVTPXkKQ09ORklHX0dQSU9MSUI9eQpDT05GSUdfT0ZfR1BJTz15
CiMgQ09ORklHX0RFQlVHX0dQSU8gaXMgbm90IHNldApDT05GSUdfR1BJT19TWVNGUz15CkNPTkZJ
R19HUElPX0dFTkVSSUM9eQojIENPTkZJR19HUElPX0RBOTA1MiBpcyBub3Qgc2V0CgojCiMgTWVt
b3J5IG1hcHBlZCBHUElPIGRyaXZlcnM6CiMKIyBDT05GSUdfR1BJT19HRU5FUklDX1BMQVRGT1JN
IGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19FTSBpcyBub3Qgc2V0CkNPTkZJR19HUElPX01YQz15
CiMgQ09ORklHX0dQSU9fUkNBUiBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fVFM1NTAwIGlzIG5v
dCBzZXQKIyBDT05GSUdfR1BJT19HUkdQSU8gaXMgbm90IHNldAoKIwojIEkyQyBHUElPIGV4cGFu
ZGVyczoKIwojIENPTkZJR19HUElPX01BWDczMDAgaXMgbm90IHNldAojIENPTkZJR19HUElPX01B
WDczMlggaXMgbm90IHNldApDT05GSUdfR1BJT19NQzlTMDhEWjYwPXkKIyBDT05GSUdfR1BJT19Q
Q0Y4NTdYIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19TWDE1MFggaXMgbm90IHNldAojIENPTkZJ
R19HUElPX0FEUDU1ODggaXMgbm90IHNldAojIENPTkZJR19HUElPX0FETlAgaXMgbm90IHNldAoK
IwojIFBDSSBHUElPIGV4cGFuZGVyczoKIwoKIwojIFNQSSBHUElPIGV4cGFuZGVyczoKIwojIENP
TkZJR19HUElPX01BWDczMDEgaXMgbm90IHNldAojIENPTkZJR19HUElPX01DUDIzUzA4IGlzIG5v
dCBzZXQKIyBDT05GSUdfR1BJT19NQzMzODgwIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT183NFgx
NjQgaXMgbm90IHNldAoKIwojIEFDOTcgR1BJTyBleHBhbmRlcnM6CiMKCiMKIyBMUEMgR1BJTyBl
eHBhbmRlcnM6CiMKCiMKIyBNT0RVTGJ1cyBHUElPIGV4cGFuZGVyczoKIwoKIwojIFVTQiBHUElP
IGV4cGFuZGVyczoKIwojIENPTkZJR19XMSBpcyBub3Qgc2V0CiMgQ09ORklHX1BPV0VSX1NVUFBM
WSBpcyBub3Qgc2V0CiMgQ09ORklHX1BPV0VSX0FWUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hXTU9O
IGlzIG5vdCBzZXQKIyBDT05GSUdfVEhFUk1BTCBpcyBub3Qgc2V0CkNPTkZJR19XQVRDSERPRz15
CiMgQ09ORklHX1dBVENIRE9HX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19XQVRDSERPR19OT1dB
WU9VVCBpcyBub3Qgc2V0CgojCiMgV2F0Y2hkb2cgRGV2aWNlIERyaXZlcnMKIwojIENPTkZJR19T
T0ZUX1dBVENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfREE5MDUyX1dBVENIRE9HIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFdfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19NQVg2M1hYX1dBVENI
RE9HIGlzIG5vdCBzZXQKQ09ORklHX0lNWDJfV0RUPXkKIyBDT05GSUdfTUVOX0EyMV9XRFQgaXMg
bm90IHNldAoKIwojIFVTQi1iYXNlZCBXYXRjaGRvZyBDYXJkcwojCiMgQ09ORklHX1VTQlBDV0FU
Q0hET0cgaXMgbm90IHNldApDT05GSUdfU1NCX1BPU1NJQkxFPXkKCiMKIyBTb25pY3MgU2lsaWNv
biBCYWNrcGxhbmUKIwojIENPTkZJR19TU0IgaXMgbm90IHNldApDT05GSUdfQkNNQV9QT1NTSUJM
RT15CgojCiMgQnJvYWRjb20gc3BlY2lmaWMgQU1CQQojCiMgQ09ORklHX0JDTUEgaXMgbm90IHNl
dAoKIwojIE11bHRpZnVuY3Rpb24gZGV2aWNlIGRyaXZlcnMKIwpDT05GSUdfTUZEX0NPUkU9eQoj
IENPTkZJR19NRkRfQVMzNzExIGlzIG5vdCBzZXQKIyBDT05GSUdfUE1JQ19BRFA1NTIwIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUZEX0FBVDI4NzBfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9D
Uk9TX0VDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0FTSUMzIGlzIG5vdCBzZXQKIyBDT05GSUdf
UE1JQ19EQTkwM1ggaXMgbm90IHNldApDT05GSUdfUE1JQ19EQTkwNTI9eQojIENPTkZJR19NRkRf
REE5MDUyX1NQSSBpcyBub3Qgc2V0CkNPTkZJR19NRkRfREE5MDUyX0kyQz15CiMgQ09ORklHX01G
RF9EQTkwNTUgaXMgbm90IHNldAojIENPTkZJR19NRkRfREE5MDYzIGlzIG5vdCBzZXQKQ09ORklH
X01GRF9NQzEzNzgzPXkKQ09ORklHX01GRF9NQzEzWFhYPXkKQ09ORklHX01GRF9NQzEzWFhYX1NQ
ST15CkNPTkZJR19NRkRfTUMxM1hYWF9JMkM9eQojIENPTkZJR19IVENfRUdQSU8gaXMgbm90IHNl
dAojIENPTkZJR19IVENfUEFTSUMzIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRDX0kyQ1BMRCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01GRF9LRU1QTEQgaXMgbm90IHNldAojIENPTkZJR19NRkRfODhQTTgw
MCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF84OFBNODA1IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZE
Xzg4UE04NjBYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01BWDc3Njg2IGlzIG5vdCBzZXQKIyBD
T05GSUdfTUZEX01BWDc3NjkzIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01BWDg5MDcgaXMgbm90
IHNldAojIENPTkZJR19NRkRfTUFYODkyNSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg4OTk3
IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01BWDg5OTggaXMgbm90IHNldAojIENPTkZJR19FWlhf
UENBUCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9WSVBFUkJPQVJEIGlzIG5vdCBzZXQKIyBDT05G
SUdfTUZEX1JFVFUgaXMgbm90IHNldAojIENPTkZJR19NRkRfUENGNTA2MzMgaXMgbm90IHNldAoj
IENPTkZJR19VQ0IxNDAwX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19NRkRfUkM1VDU4MyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01GRF9TRUNfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9TSTQ3
NlhfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9TTTUwMSBpcyBub3Qgc2V0CiMgQ09ORklH
X01GRF9TTVNDIGlzIG5vdCBzZXQKIyBDT05GSUdfQUJYNTAwX0NPUkUgaXMgbm90IHNldAojIENP
TkZJR19NRkRfU1RNUEUgaXMgbm90IHNldApDT05GSUdfTUZEX1NZU0NPTj15CiMgQ09ORklHX01G
RF9USV9BTTMzNVhfVFNDQURDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0xQODc4OCBpcyBub3Qg
c2V0CiMgQ09ORklHX01GRF9QQUxNQVMgaXMgbm90IHNldAojIENPTkZJR19UUFM2MTA1WCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RQUzY1MDEwIGlzIG5vdCBzZXQKIyBDT05GSUdfVFBTNjUwN1ggaXMg
bm90IHNldAojIENPTkZJR19NRkRfVFBTNjUwOTAgaXMgbm90IHNldAojIENPTkZJR19NRkRfVFBT
NjUyMTcgaXMgbm90IHNldAojIENPTkZJR19NRkRfVFBTNjU4NlggaXMgbm90IHNldAojIENPTkZJ
R19NRkRfVFBTNjU5MTAgaXMgbm90IHNldAojIENPTkZJR19NRkRfVFBTNjU5MTIgaXMgbm90IHNl
dAojIENPTkZJR19NRkRfVFBTNjU5MTJfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RQUzY1
OTEyX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9UUFM4MDAzMSBpcyBub3Qgc2V0CiMgQ09O
RklHX1RXTDQwMzBfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RXTDYwNDBfQ09SRSBpcyBub3Qg
c2V0CiMgQ09ORklHX01GRF9XTDEyNzNfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9MTTM1
MzMgaXMgbm90IHNldAojIENPTkZJR19NRkRfVEMzNTg5WCBpcyBub3Qgc2V0CiMgQ09ORklHX01G
RF9UTUlPIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1Q3TDY2WEIgaXMgbm90IHNldAojIENPTkZJ
R19NRkRfVEM2Mzg3WEIgaXMgbm90IHNldAojIENPTkZJR19NRkRfVEM2MzkzWEIgaXMgbm90IHNl
dAojIENPTkZJR19NRkRfQVJJWk9OQV9JMkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfQVJJWk9O
QV9TUEkgaXMgbm90IHNldAojIENPTkZJR19NRkRfV004NDAwIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUZEX1dNODMxWF9JMkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfV004MzFYX1NQSSBpcyBub3Qg
c2V0CiMgQ09ORklHX01GRF9XTTgzNTBfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODk5
NCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZFWFBSRVNTX0NPTkZJRyBpcyBub3Qgc2V0CkNPTkZJR19S
RUdVTEFUT1I9eQojIENPTkZJR19SRUdVTEFUT1JfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19S
RUdVTEFUT1JfRFVNTVkgaXMgbm90IHNldApDT05GSUdfUkVHVUxBVE9SX0ZJWEVEX1ZPTFRBR0U9
eQojIENPTkZJR19SRUdVTEFUT1JfVklSVFVBTF9DT05TVU1FUiBpcyBub3Qgc2V0CiMgQ09ORklH
X1JFR1VMQVRPUl9VU0VSU1BBQ0VfQ09OU1VNRVIgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFU
T1JfQUQ1Mzk4IGlzIG5vdCBzZXQKQ09ORklHX1JFR1VMQVRPUl9BTkFUT1A9eQpDT05GSUdfUkVH
VUxBVE9SX0RBOTA1Mj15CiMgQ09ORklHX1JFR1VMQVRPUl9EQTkyMTAgaXMgbm90IHNldAojIENP
TkZJR19SRUdVTEFUT1JfRkFONTM1NTUgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfR1BJ
TyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9JU0w2MjcxQSBpcyBub3Qgc2V0CiMgQ09O
RklHX1JFR1VMQVRPUl9MUDM5NzEgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTFAzOTcy
IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX0xQODcyWCBpcyBub3Qgc2V0CiMgQ09ORklH
X1JFR1VMQVRPUl9MUDg3NTUgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTUFYMTU4NiBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg4NjQ5IGlzIG5vdCBzZXQKIyBDT05GSUdf
UkVHVUxBVE9SX01BWDg2NjAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTUFYODk1MiBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg4OTczIGlzIG5vdCBzZXQKQ09ORklHX1JF
R1VMQVRPUl9NQzEzWFhYX0NPUkU9eQpDT05GSUdfUkVHVUxBVE9SX01DMTM3ODM9eQpDT05GSUdf
UkVHVUxBVE9SX01DMTM4OTI9eQojIENPTkZJR19SRUdVTEFUT1JfUEZVWkUxMDAgaXMgbm90IHNl
dAojIENPTkZJR19SRUdVTEFUT1JfVFBTNTE2MzIgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFU
T1JfVFBTNjIzNjAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFBTNjUwMjMgaXMgbm90
IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFBTNjUwN1ggaXMgbm90IHNldAojIENPTkZJR19SRUdV
TEFUT1JfVFBTNjUyNFggaXMgbm90IHNldApDT05GSUdfTUVESUFfU1VQUE9SVD15CgojCiMgTXVs
dGltZWRpYSBjb3JlIHN1cHBvcnQKIwpDT05GSUdfTUVESUFfQ0FNRVJBX1NVUFBPUlQ9eQojIENP
TkZJR19NRURJQV9BTkFMT0dfVFZfU1VQUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX01FRElBX0RJ
R0lUQUxfVFZfU1VQUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX01FRElBX1JBRElPX1NVUFBPUlQg
aXMgbm90IHNldAojIENPTkZJR19NRURJQV9SQ19TVVBQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUVESUFfQ09OVFJPTExFUiBpcyBub3Qgc2V0CkNPTkZJR19WSURFT19ERVY9eQpDT05GSUdfVklE
RU9fVjRMMj15CiMgQ09ORklHX1ZJREVPX0FEVl9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJ
REVPX0ZJWEVEX01JTk9SX1JBTkdFUyBpcyBub3Qgc2V0CkNPTkZJR19WNEwyX01FTTJNRU1fREVW
PXkKQ09ORklHX1ZJREVPQlVGX0dFTj15CkNPTkZJR19WSURFT0JVRjJfQ09SRT15CkNPTkZJR19W
SURFT0JVRjJfTUVNT1BTPXkKQ09ORklHX1ZJREVPQlVGMl9ETUFfQ09OVElHPXkKIyBDT05GSUdf
VklERU9fVjRMMl9JTlRfREVWSUNFIGlzIG5vdCBzZXQKIyBDT05GSUdfVFRQQ0lfRUVQUk9NIGlz
IG5vdCBzZXQKCiMKIyBNZWRpYSBkcml2ZXJzCiMKIyBDT05GSUdfTUVESUFfVVNCX1NVUFBPUlQg
aXMgbm90IHNldApDT05GSUdfVjRMX1BMQVRGT1JNX0RSSVZFUlM9eQojIENPTkZJR19WSURFT19U
SU1CRVJEQUxFIGlzIG5vdCBzZXQKQ09ORklHX1NPQ19DQU1FUkE9eQojIENPTkZJR19TT0NfQ0FN
RVJBX1BMQVRGT1JNIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX01YMz15CiMgQ09ORklHX1ZJREVP
X1JDQVJfVklOIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fU0hfTU9CSUxFX0NTSTIgaXMgbm90
IHNldAojIENPTkZJR19WSURFT19TSF9NT0JJTEVfQ0VVIGlzIG5vdCBzZXQKQ09ORklHX1Y0TF9N
RU0yTUVNX0RSSVZFUlM9eQpDT05GSUdfVklERU9fQ09EQT15CiMgQ09ORklHX1ZJREVPX01FTTJN
RU1fREVJTlRFUkxBQ0UgaXMgbm90IHNldAojIENPTkZJR19WSURFT19TSF9WRVUgaXMgbm90IHNl
dAojIENPTkZJR19WNExfVEVTVF9EUklWRVJTIGlzIG5vdCBzZXQKCiMKIyBTdXBwb3J0ZWQgTU1D
L1NESU8gYWRhcHRlcnMKIwojIENPTkZJR19DWVBSRVNTX0ZJUk1XQVJFIGlzIG5vdCBzZXQKCiMK
IyBNZWRpYSBhbmNpbGxhcnkgZHJpdmVycyAodHVuZXJzLCBzZW5zb3JzLCBpMmMsIGZyb250ZW5k
cykKIwpDT05GSUdfTUVESUFfU1VCRFJWX0FVVE9TRUxFQ1Q9eQoKIwojIEF1ZGlvIGRlY29kZXJz
LCBwcm9jZXNzb3JzIGFuZCBtaXhlcnMKIwoKIwojIFJEUyBkZWNvZGVycwojCgojCiMgVmlkZW8g
ZGVjb2RlcnMKIwoKIwojIFZpZGVvIGFuZCBhdWRpbyBkZWNvZGVycwojCgojCiMgVmlkZW8gZW5j
b2RlcnMKIwoKIwojIENhbWVyYSBzZW5zb3IgZGV2aWNlcwojCgojCiMgRmxhc2ggZGV2aWNlcwoj
CgojCiMgVmlkZW8gaW1wcm92ZW1lbnQgY2hpcHMKIwoKIwojIE1pc2NlbGFuZW91cyBoZWxwZXIg
Y2hpcHMKIwoKIwojIFNlbnNvcnMgdXNlZCBvbiBzb2NfY2FtZXJhIGRyaXZlcgojCgojCiMgc29j
X2NhbWVyYSBzZW5zb3IgZHJpdmVycwojCiMgQ09ORklHX1NPQ19DQU1FUkFfSU1YMDc0IGlzIG5v
dCBzZXQKIyBDT05GSUdfU09DX0NBTUVSQV9NVDlNMDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfU09D
X0NBTUVSQV9NVDlNMTExIGlzIG5vdCBzZXQKIyBDT05GSUdfU09DX0NBTUVSQV9NVDlUMDMxIGlz
IG5vdCBzZXQKIyBDT05GSUdfU09DX0NBTUVSQV9NVDlUMTEyIGlzIG5vdCBzZXQKIyBDT05GSUdf
U09DX0NBTUVSQV9NVDlWMDIyIGlzIG5vdCBzZXQKQ09ORklHX1NPQ19DQU1FUkFfT1YyNjQwPXkK
IyBDT05GSUdfU09DX0NBTUVSQV9PVjU2NDIgaXMgbm90IHNldAojIENPTkZJR19TT0NfQ0FNRVJB
X09WNjY1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NPQ19DQU1FUkFfT1Y3NzJYIGlzIG5vdCBzZXQK
IyBDT05GSUdfU09DX0NBTUVSQV9PVjk2NDAgaXMgbm90IHNldAojIENPTkZJR19TT0NfQ0FNRVJB
X09WOTc0MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NPQ19DQU1FUkFfUko1NE4xIGlzIG5vdCBzZXQK
IyBDT05GSUdfU09DX0NBTUVSQV9UVzk5MTAgaXMgbm90IHNldAoKIwojIFRvb2xzIHRvIGRldmVs
b3AgbmV3IGZyb250ZW5kcwojCiMgQ09ORklHX0RWQl9EVU1NWV9GRSBpcyBub3Qgc2V0CgojCiMg
R3JhcGhpY3Mgc3VwcG9ydAojCkNPTkZJR19EUk09eQpDT05GSUdfRFJNX0tNU19IRUxQRVI9eQoj
IENPTkZJR19EUk1fTE9BRF9FRElEX0ZJUk1XQVJFIGlzIG5vdCBzZXQKQ09ORklHX0RSTV9HRU1f
Q01BX0hFTFBFUj15CkNPTkZJR19EUk1fS01TX0NNQV9IRUxQRVI9eQoKIwojIEkyQyBlbmNvZGVy
IG9yIGhlbHBlciBjaGlwcwojCiMgQ09ORklHX0RSTV9JMkNfQ0g3MDA2IGlzIG5vdCBzZXQKIyBD
T05GSUdfRFJNX0kyQ19TSUwxNjQgaXMgbm90IHNldAojIENPTkZJR19EUk1fSTJDX05YUF9UREE5
OThYIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0VYWU5PUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RS
TV9VREwgaXMgbm90IHNldAojIENPTkZJR19EUk1fUkNBUl9EVSBpcyBub3Qgc2V0CiMgQ09ORklH
X0RSTV9TSE1PQklMRSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9USUxDREMgaXMgbm90IHNldAoj
IENPTkZJR19URUdSQV9IT1NUMVggaXMgbm90IHNldAojIENPTkZJR19WR0FTVEFURSBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZJREVPX09VVFBVVF9DT05UUk9MIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVP
TU9ERV9IRUxQRVJTPXkKQ09ORklHX0hETUk9eQpDT05GSUdfRkI9eQojIENPTkZJR19GSVJNV0FS
RV9FRElEIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfRERDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
Qk9PVF9WRVNBX1NVUFBPUlQgaXMgbm90IHNldApDT05GSUdfRkJfQ0ZCX0ZJTExSRUNUPXkKQ09O
RklHX0ZCX0NGQl9DT1BZQVJFQT15CkNPTkZJR19GQl9DRkJfSU1BR0VCTElUPXkKIyBDT05GSUdf
RkJfQ0ZCX1JFVl9QSVhFTFNfSU5fQllURSBpcyBub3Qgc2V0CkNPTkZJR19GQl9TWVNfRklMTFJF
Q1Q9eQpDT05GSUdfRkJfU1lTX0NPUFlBUkVBPXkKQ09ORklHX0ZCX1NZU19JTUFHRUJMSVQ9eQoj
IENPTkZJR19GQl9GT1JFSUdOX0VORElBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1NZU19GT1BT
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1ZHQUxJQiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX01B
Q01PREVTIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQkFDS0xJR0hUIGlzIG5vdCBzZXQKIyBDT05G
SUdfRkJfTU9ERV9IRUxQRVJTIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVElMRUJMSVRUSU5HIGlz
IG5vdCBzZXQKCiMKIyBGcmFtZSBidWZmZXIgaGFyZHdhcmUgZHJpdmVycwojCiMgQ09ORklHX0ZC
X0lNWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1VWRVNBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
UzFEMTNYWFggaXMgbm90IHNldAojIENPTkZJR19GQl9UTUlPIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfU01TQ1VGWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1VETCBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0dPTERGSVNIIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVklSVFVBTCBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX01FVFJPTk9NRSBpcyBub3Qgc2V0CkNPTkZJR19GQl9NWDM9eQojIENPTkZJR19G
Ql9CUk9BRFNIRUVUIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVVPX0sxOTBYIGlzIG5vdCBzZXQK
IyBDT05GSUdfRkJfU0lNUExFIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhZTk9TX1ZJREVPIGlzIG5v
dCBzZXQKQ09ORklHX0JBQ0tMSUdIVF9MQ0RfU1VQUE9SVD15CkNPTkZJR19MQ0RfQ0xBU1NfREVW
SUNFPXkKQ09ORklHX0xDRF9MNEYwMDI0MlQwMz15CiMgQ09ORklHX0xDRF9MTVMyODNHRjA1IGlz
IG5vdCBzZXQKIyBDT05GSUdfTENEX0xUVjM1MFFWIGlzIG5vdCBzZXQKIyBDT05GSUdfTENEX0lM
STkyMlggaXMgbm90IHNldAojIENPTkZJR19MQ0RfSUxJOTMyMCBpcyBub3Qgc2V0CiMgQ09ORklH
X0xDRF9URE8yNE0gaXMgbm90IHNldAojIENPTkZJR19MQ0RfVkdHMjQzMkE0IGlzIG5vdCBzZXQK
Q09ORklHX0xDRF9QTEFURk9STT15CiMgQ09ORklHX0xDRF9TNkU2M00wIGlzIG5vdCBzZXQKIyBD
T05GSUdfTENEX0xEOTA0MCBpcyBub3Qgc2V0CiMgQ09ORklHX0xDRF9BTVMzNjlGRzA2IGlzIG5v
dCBzZXQKIyBDT05GSUdfTENEX0xNUzUwMUtGMDMgaXMgbm90IHNldAojIENPTkZJR19MQ0RfSFg4
MzU3IGlzIG5vdCBzZXQKQ09ORklHX0JBQ0tMSUdIVF9DTEFTU19ERVZJQ0U9eQpDT05GSUdfQkFD
S0xJR0hUX0dFTkVSSUM9eQpDT05GSUdfQkFDS0xJR0hUX1BXTT15CiMgQ09ORklHX0JBQ0tMSUdI
VF9EQTkwNTIgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfQURQODg2MCBpcyBub3Qgc2V0
CiMgQ09ORklHX0JBQ0tMSUdIVF9BRFA4ODcwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hU
X0xNMzYzMCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9MTTM2MzkgaXMgbm90IHNldAoj
IENPTkZJR19CQUNLTElHSFRfTFA4NTVYIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX0dQ
SU8gaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfTFY1MjA3TFAgaXMgbm90IHNldAojIENP
TkZJR19CQUNLTElHSFRfQkQ2MTA3IGlzIG5vdCBzZXQKCiMKIyBDb25zb2xlIGRpc3BsYXkgZHJp
dmVyIHN1cHBvcnQKIwpDT05GSUdfRFVNTVlfQ09OU09MRT15CkNPTkZJR19GUkFNRUJVRkZFUl9D
T05TT0xFPXkKQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEVfREVURUNUX1BSSU1BUlk9eQojIENP
TkZJR19GUkFNRUJVRkZFUl9DT05TT0xFX1JPVEFUSU9OIGlzIG5vdCBzZXQKQ09ORklHX0xPR089
eQpDT05GSUdfTE9HT19MSU5VWF9NT05PPXkKQ09ORklHX0xPR09fTElOVVhfVkdBMTY9eQpDT05G
SUdfTE9HT19MSU5VWF9DTFVUMjI0PXkKIyBDT05GSUdfRkJfU1NEMTMwNyBpcyBub3Qgc2V0CkNP
TkZJR19TT1VORD15CiMgQ09ORklHX1NPVU5EX09TU19DT1JFIGlzIG5vdCBzZXQKQ09ORklHX1NO
RD15CkNPTkZJR19TTkRfVElNRVI9eQpDT05GSUdfU05EX1BDTT15CkNPTkZJR19TTkRfRE1BRU5H
SU5FX1BDTT15CkNPTkZJR19TTkRfQ09NUFJFU1NfT0ZGTE9BRD15CkNPTkZJR19TTkRfSkFDSz15
CiMgQ09ORklHX1NORF9TRVFVRU5DRVIgaXMgbm90IHNldAojIENPTkZJR19TTkRfTUlYRVJfT1NT
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1BDTV9PU1MgaXMgbm90IHNldAojIENPTkZJR19TTkRf
SFJUSU1FUiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9EWU5BTUlDX01JTk9SUyBpcyBub3Qgc2V0
CkNPTkZJR19TTkRfU1VQUE9SVF9PTERfQVBJPXkKQ09ORklHX1NORF9WRVJCT1NFX1BST0NGUz15
CiMgQ09ORklHX1NORF9WRVJCT1NFX1BSSU5USyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9ERUJV
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9SQVdNSURJX1NFUSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9PUEwzX0xJQl9TRVEgaXMgbm90IHNldAojIENPTkZJR19TTkRfT1BMNF9MSUJfU0VRIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX1NCQVdFX1NFUSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9F
TVUxMEsxX1NFUSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfRFJJVkVSUz15CiMgQ09ORklHX1NORF9E
VU1NWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BTE9PUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9NVFBBViBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TRVJJQUxfVTE2NTUwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX01QVTQwMSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfQVJNPXkKQ09ORklHX1NO
RF9TUEk9eQpDT05GSUdfU05EX1VTQj15CiMgQ09ORklHX1NORF9VU0JfQVVESU8gaXMgbm90IHNl
dAojIENPTkZJR19TTkRfVVNCX1VBMTAxIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1VTQl9DQUlB
USBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0JfNkZJUkUgaXMgbm90IHNldAojIENPTkZJR19T
TkRfVVNCX0hJRkFDRSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfU09DPXkKQ09ORklHX1NORF9TT0Nf
QUM5N19CVVM9eQpDT05GSUdfU05EX1NPQ19HRU5FUklDX0RNQUVOR0lORV9QQ009eQojIENPTkZJ
R19TTkRfQVRNRUxfU09DIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0RFU0lHTldBUkVfSTJTIGlz
IG5vdCBzZXQKQ09ORklHX1NORF9TT0NfRlNMX1NTST15CkNPTkZJR19TTkRfSU1YX1NPQz15CkNP
TkZJR19TTkRfU09DX0lNWF9TU0k9eQpDT05GSUdfU05EX1NPQ19JTVhfUENNX0ZJUT15CkNPTkZJ
R19TTkRfU09DX0lNWF9QQ01fRE1BPXkKQ09ORklHX1NORF9TT0NfSU1YX0FVRE1VWD15CkNPTkZJ
R19TTkRfU09DX1BIWUNPUkVfQUM5Nz15CkNPTkZJR19TTkRfU09DX0VVS1JFQV9UTFYzMjA9eQpD
T05GSUdfU05EX1NPQ19JTVhfV004OTYyPXkKQ09ORklHX1NORF9TT0NfSU1YX1NHVEw1MDAwPXkK
IyBDT05GSUdfU05EX1NPQ19JTVhfU1BESUYgaXMgbm90IHNldApDT05GSUdfU05EX1NPQ19JTVhf
TUMxMzc4Mz15CkNPTkZJR19TTkRfU09DX0kyQ19BTkRfU1BJPXkKQ09ORklHX1NORF9TT0NfU0dU
TDUwMDA9eQpDT05GSUdfU05EX1NPQ19UTFYzMjBBSUMyMz15CkNPTkZJR19TTkRfU09DX1dNODk2
Mj15CkNPTkZJR19TTkRfU09DX1dNOTcxMj15CkNPTkZJR19TTkRfU09DX01DMTM3ODM9eQojIENP
TkZJR19TTkRfU0lNUExFX0NBUkQgaXMgbm90IHNldAojIENPTkZJR19TT1VORF9QUklNRSBpcyBu
b3Qgc2V0CkNPTkZJR19BQzk3X0JVUz15CgojCiMgSElEIHN1cHBvcnQKIwpDT05GSUdfSElEPXkK
IyBDT05GSUdfSElEUkFXIGlzIG5vdCBzZXQKIyBDT05GSUdfVUhJRCBpcyBub3Qgc2V0CkNPTkZJ
R19ISURfR0VORVJJQz15CgojCiMgU3BlY2lhbCBISUQgZHJpdmVycwojCiMgQ09ORklHX0hJRF9B
NFRFQ0ggaXMgbm90IHNldAojIENPTkZJR19ISURfQUNSVVggaXMgbm90IHNldAojIENPTkZJR19I
SURfQVBQTEUgaXMgbm90IHNldAojIENPTkZJR19ISURfQVBQTEVJUiBpcyBub3Qgc2V0CiMgQ09O
RklHX0hJRF9BVVJFQUwgaXMgbm90IHNldAojIENPTkZJR19ISURfQkVMS0lOIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX0NIRVJSWSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9DSElDT05ZIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX1BST0RJS0VZUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9DWVBS
RVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0RSQUdPTlJJU0UgaXMgbm90IHNldAojIENPTkZJ
R19ISURfRU1TX0ZGIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0VMRUNPTSBpcyBub3Qgc2V0CiMg
Q09ORklHX0hJRF9FTE8gaXMgbm90IHNldAojIENPTkZJR19ISURfRVpLRVkgaXMgbm90IHNldAoj
IENPTkZJR19ISURfSE9MVEVLIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0hVSU9OIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSElEX0tFWVRPVUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0tZRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hJRF9VQ0xPR0lDIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1dBTFRP
UCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9HWVJBVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJ
RF9JQ0FERSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9UV0lOSEFOIGlzIG5vdCBzZXQKIyBDT05G
SUdfSElEX0tFTlNJTkdUT04gaXMgbm90IHNldAojIENPTkZJR19ISURfTENQT1dFUiBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9MRU5PVk9fVFBLQkQgaXMgbm90IHNldAojIENPTkZJR19ISURfTE9H
SVRFQ0ggaXMgbm90IHNldAojIENPTkZJR19ISURfTUFHSUNNT1VTRSBpcyBub3Qgc2V0CiMgQ09O
RklHX0hJRF9NSUNST1NPRlQgaXMgbm90IHNldAojIENPTkZJR19ISURfTU9OVEVSRVkgaXMgbm90
IHNldAojIENPTkZJR19ISURfTVVMVElUT1VDSCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9OVFJJ
RyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9PUlRFSyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9Q
QU5USEVSTE9SRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9QRVRBTFlOWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0hJRF9QSUNPTENEIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1BSSU1BWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9ST0NDQVQgaXMgbm90IHNldAojIENPTkZJR19ISURfU0FJVEVLIGlz
IG5vdCBzZXQKIyBDT05GSUdfSElEX1NBTVNVTkcgaXMgbm90IHNldAojIENPTkZJR19ISURfU09O
WSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TUEVFRExJTksgaXMgbm90IHNldAojIENPTkZJR19I
SURfU1RFRUxTRVJJRVMgaXMgbm90IHNldAojIENPTkZJR19ISURfU1VOUExVUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0hJRF9HUkVFTkFTSUEgaXMgbm90IHNldAojIENPTkZJR19ISURfU01BUlRKT1lQ
TFVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1RJVk8gaXMgbm90IHNldAojIENPTkZJR19ISURf
VE9QU0VFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9USElOR00gaXMgbm90IHNldAojIENPTkZJ
R19ISURfVEhSVVNUTUFTVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1dBQ09NIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSElEX1dJSU1PVEUgaXMgbm90IHNldAojIENPTkZJR19ISURfWElOTU8gaXMg
bm90IHNldAojIENPTkZJR19ISURfWkVST1BMVVMgaXMgbm90IHNldAojIENPTkZJR19ISURfWllE
QUNST04gaXMgbm90IHNldAojIENPTkZJR19ISURfU0VOU09SX0hVQiBpcyBub3Qgc2V0CgojCiMg
VVNCIEhJRCBzdXBwb3J0CiMKQ09ORklHX1VTQl9ISUQ9eQojIENPTkZJR19ISURfUElEIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0hJRERFViBpcyBub3Qgc2V0CgojCiMgSTJDIEhJRCBzdXBwb3J0
CiMKIyBDT05GSUdfSTJDX0hJRCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfT0hDSV9MSVRUTEVfRU5E
SUFOPXkKQ09ORklHX1VTQl9TVVBQT1JUPXkKQ09ORklHX1VTQl9DT01NT049eQpDT05GSUdfVVNC
X0FSQ0hfSEFTX0hDRD15CkNPTkZJR19VU0I9eQojIENPTkZJR19VU0JfREVCVUcgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfQU5OT1VOQ0VfTkVXX0RFVklDRVMgaXMgbm90IHNldAoKIwojIE1pc2Nl
bGxhbmVvdXMgVVNCIG9wdGlvbnMKIwpDT05GSUdfVVNCX0RFRkFVTFRfUEVSU0lTVD15CiMgQ09O
RklHX1VTQl9EWU5BTUlDX01JTk9SUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9PVEcgaXMgbm90
IHNldAojIENPTkZJR19VU0JfT1RHX1dISVRFTElTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9P
VEdfQkxBQ0tMSVNUX0hVQiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NT04gaXMgbm90IHNldAoj
IENPTkZJR19VU0JfV1VTQl9DQkFGIGlzIG5vdCBzZXQKCiMKIyBVU0IgSG9zdCBDb250cm9sbGVy
IERyaXZlcnMKIwojIENPTkZJR19VU0JfQzY3WDAwX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9YSENJX0hDRCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfRUhDSV9IQ0Q9eQpDT05GSUdfVVNCX0VI
Q0lfUk9PVF9IVUJfVFQ9eQpDT05GSUdfVVNCX0VIQ0lfVFRfTkVXU0NIRUQ9eQpDT05GSUdfVVNC
X0VIQ0lfTVhDPXkKIyBDT05GSUdfVVNCX0VIQ0lfSENEX1BMQVRGT1JNIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX09YVTIxMEhQX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxMTZYX0hD
RCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxNzYwX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9JU1AxMzYyX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9GVVNCSDIwMF9IQ0QgaXMg
bm90IHNldAojIENPTkZJR19VU0JfRk9URzIxMF9IQ0QgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
T0hDSV9IQ0QgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0w4MTFfSENEIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1I4QTY2NTk3X0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JTVgyMV9IQ0Qg
aXMgbm90IHNldAojIENPTkZJR19VU0JfSENEX1RFU1RfTU9ERSBpcyBub3Qgc2V0CgojCiMgVVNC
IERldmljZSBDbGFzcyBkcml2ZXJzCiMKIyBDT05GSUdfVVNCX0FDTSBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9QUklOVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1dETSBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9UTUMgaXMgbm90IHNldAoKIwojIE5PVEU6IFVTQl9TVE9SQUdFIGRlcGVuZHMg
b24gU0NTSSBidXQgQkxLX0RFVl9TRCBtYXkKIwoKIwojIGFsc28gYmUgbmVlZGVkOyBzZWUgVVNC
X1NUT1JBR0UgSGVscCBmb3IgbW9yZSBpbmZvCiMKQ09ORklHX1VTQl9TVE9SQUdFPXkKIyBDT05G
SUdfVVNCX1NUT1JBR0VfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9SRUFM
VEVLIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfREFUQUZBQiBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9TVE9SQUdFX0ZSRUVDT00gaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFH
RV9JU0QyMDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9VU0JBVCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9TVE9SQUdFX1NERFIwOSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9S
QUdFX1NERFI1NSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0pVTVBTSE9UIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfQUxBVURBIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1NUT1JBR0VfT05FVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9LQVJNQSBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0NZUFJFU1NfQVRBQ0IgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfU1RPUkFHRV9FTkVfVUI2MjUwIGlzIG5vdCBzZXQKCiMKIyBVU0IgSW1hZ2lu
ZyBkZXZpY2VzCiMKIyBDT05GSUdfVVNCX01EQzgwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9N
SUNST1RFSyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9EV0MzIGlzIG5vdCBzZXQKQ09ORklHX1VT
Ql9DSElQSURFQT15CkNPTkZJR19VU0JfQ0hJUElERUFfSE9TVD15CiMgQ09ORklHX1VTQl9DSElQ
SURFQV9ERUJVRyBpcyBub3Qgc2V0CgojCiMgVVNCIHBvcnQgZHJpdmVycwojCiMgQ09ORklHX1VT
Ql9TRVJJQUwgaXMgbm90IHNldAoKIwojIFVTQiBNaXNjZWxsYW5lb3VzIGRyaXZlcnMKIwojIENP
TkZJR19VU0JfRU1JNjIgaXMgbm90IHNldAojIENPTkZJR19VU0JfRU1JMjYgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfQURVVFVYIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFVlNFRyBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9SSU81MDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfTEVHT1RPV0VS
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUQg
aXMgbm90IHNldAojIENPTkZJR19VU0JfQ1lQUkVTU19DWTdDNjMgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfQ1lUSEVSTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JRE1PVVNFIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX0ZURElfRUxBTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9BUFBMRURJU1BM
QVkgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0lTVVNCVkdBIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0xEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1RSQU5DRVZJQlJBVE9SIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX0lPV0FSUklPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9URVNUIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0VIU0VUX1RFU1RfRklYVFVSRSBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9JU0lHSFRGVyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9ZVVJFWCBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9FWlVTQl9GWDIgaXMgbm90IHNldAojIENPTkZJR19VU0JfSFNJQ19VU0IzNTAz
IGlzIG5vdCBzZXQKCiMKIyBVU0IgUGh5c2ljYWwgTGF5ZXIgZHJpdmVycwojCkNPTkZJR19VU0Jf
UEhZPXkKQ09ORklHX05PUF9VU0JfWENFSVY9eQojIENPTkZJR19BTTMzNVhfUEhZX1VTQiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NBTVNVTkdfVVNCMlBIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBTVNV
TkdfVVNCM1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HUElPX1ZCVVMgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfSVNQMTMwMSBpcyBub3Qgc2V0CkNPTkZJR19VU0JfTVhTX1BIWT15CiMgQ09O
RklHX1VTQl9SQ0FSX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9VTFBJIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX0dBREdFVCBpcyBub3Qgc2V0CkNPTkZJR19NTUM9eQojIENPTkZJR19NTUNf
REVCVUcgaXMgbm90IHNldAojIENPTkZJR19NTUNfVU5TQUZFX1JFU1VNRSBpcyBub3Qgc2V0CiMg
Q09ORklHX01NQ19DTEtHQVRFIGlzIG5vdCBzZXQKCiMKIyBNTUMvU0QvU0RJTyBDYXJkIERyaXZl
cnMKIwpDT05GSUdfTU1DX0JMT0NLPXkKQ09ORklHX01NQ19CTE9DS19NSU5PUlM9OApDT05GSUdf
TU1DX0JMT0NLX0JPVU5DRT15CiMgQ09ORklHX1NESU9fVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklH
X01NQ19URVNUIGlzIG5vdCBzZXQKCiMKIyBNTUMvU0QvU0RJTyBIb3N0IENvbnRyb2xsZXIgRHJp
dmVycwojCkNPTkZJR19NTUNfU0RIQ0k9eQpDT05GSUdfTU1DX1NESENJX0lPX0FDQ0VTU09SUz15
CkNPTkZJR19NTUNfU0RIQ0lfUExURk09eQpDT05GSUdfTU1DX1NESENJX0VTREhDX0lNWD15CiMg
Q09ORklHX01NQ19TREhDSV9QWEFWMyBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19TREhDSV9QWEFW
MiBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19NWEMgaXMgbm90IHNldAojIENPTkZJR19NTUNfU1BJ
IGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DX0RXIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DX1ZVQjMw
MCBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19VU0hDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVNU1RJ
Q0sgaXMgbm90IHNldApDT05GSUdfTEVEU19HUElPX1JFR0lTVEVSPXkKQ09ORklHX05FV19MRURT
PXkKQ09ORklHX0xFRFNfQ0xBU1M9eQoKIwojIExFRCBkcml2ZXJzCiMKIyBDT05GSUdfTEVEU19M
TTM1MzAgaXMgbm90IHNldAojIENPTkZJR19MRURTX0xNMzY0MiBpcyBub3Qgc2V0CiMgQ09ORklH
X0xFRFNfUENBOTUzMiBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfR1BJTyBpcyBub3Qgc2V0CiMg
Q09ORklHX0xFRFNfTFAzOTQ0IGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19MUDU1MjEgaXMgbm90
IHNldAojIENPTkZJR19MRURTX0xQNTUyMyBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfTFA1NTYy
IGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19MUDg1MDEgaXMgbm90IHNldAojIENPTkZJR19MRURT
X1BDQTk1NVggaXMgbm90IHNldAojIENPTkZJR19MRURTX1BDQTk2M1ggaXMgbm90IHNldAojIENP
TkZJR19MRURTX0RBOTA1MiBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfREFDMTI0UzA4NSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0xFRFNfUFdNIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19SRUdVTEFU
T1IgaXMgbm90IHNldAojIENPTkZJR19MRURTX0JEMjgwMiBpcyBub3Qgc2V0CiMgQ09ORklHX0xF
RFNfTFQzNTkzIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19NQzEzNzgzIGlzIG5vdCBzZXQKIyBD
T05GSUdfTEVEU19UQ0E2NTA3IGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19MTTM1NXggaXMgbm90
IHNldAojIENPTkZJR19MRURTX09UMjAwIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19CTElOS00g
aXMgbm90IHNldAoKIwojIExFRCBUcmlnZ2VycwojCiMgQ09ORklHX0xFRFNfVFJJR0dFUlMgaXMg
bm90IHNldAojIENPTkZJR19BQ0NFU1NJQklMSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfRURBQyBp
cyBub3Qgc2V0CkNPTkZJR19SVENfTElCPXkKQ09ORklHX1JUQ19DTEFTUz15CkNPTkZJR19SVENf
SENUT1NZUz15CkNPTkZJR19SVENfU1lTVE9IQz15CkNPTkZJR19SVENfSENUT1NZU19ERVZJQ0U9
InJ0YzAiCiMgQ09ORklHX1JUQ19ERUJVRyBpcyBub3Qgc2V0CgojCiMgUlRDIGludGVyZmFjZXMK
IwpDT05GSUdfUlRDX0lOVEZfU1lTRlM9eQpDT05GSUdfUlRDX0lOVEZfUFJPQz15CkNPTkZJR19S
VENfSU5URl9ERVY9eQpDT05GSUdfUlRDX0lOVEZfREVWX1VJRV9FTVVMPXkKIyBDT05GSUdfUlRD
X0RSVl9URVNUIGlzIG5vdCBzZXQKCiMKIyBJMkMgUlRDIGRyaXZlcnMKIwojIENPTkZJR19SVENf
RFJWX0RTMTMwNyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxMzc0IGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRDX0RSVl9EUzE2NzIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMzIz
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYNjkwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X1JUQ19EUlZfUlM1QzM3MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfSVNMMTIwOCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfSVNMMTIwMjIgaXMgbm90IHNldAojIENPTkZJR19SVENf
RFJWX1gxMjA1IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9QQ0YyMTI3IGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRDX0RSVl9QQ0Y4NTIzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9QQ0Y4
NTYzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9QQ0Y4NTgzIGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRDX0RSVl9NNDFUODAgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0JRMzJLIGlzIG5v
dCBzZXQKIyBDT05GSUdfUlRDX0RSVl9TMzUzOTBBIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9GTTMxMzAgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JYODU4MSBpcyBub3Qgc2V0CiMg
Q09ORklHX1JUQ19EUlZfUlg4MDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9FTTMwMjcg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JWMzAyOUMyIGlzIG5vdCBzZXQKCiMKIyBTUEkg
UlRDIGRyaXZlcnMKIwojIENPTkZJR19SVENfRFJWX000MVQ5MyBpcyBub3Qgc2V0CiMgQ09ORklH
X1JUQ19EUlZfTTQxVDk0IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzEzMDUgaXMgbm90
IHNldAojIENPTkZJR19SVENfRFJWX0RTMTM5MCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZf
TUFYNjkwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUjk3MDEgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX1JTNUMzNDggaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMzIzNCBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGMjEyMyBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
Q19EUlZfUlg0NTgxIGlzIG5vdCBzZXQKCiMKIyBQbGF0Zm9ybSBSVEMgZHJpdmVycwojCiMgQ09O
RklHX1JUQ19EUlZfQ01PUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxMjg2IGlzIG5v
dCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE1MTEgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJW
X0RTMTU1MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxNzQyIGlzIG5vdCBzZXQKIyBD
T05GSUdfUlRDX0RSVl9EQTkwNTIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1NUSzE3VEE4
IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NNDhUODYgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX000OFQzNSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDU5IGlzIG5vdCBz
ZXQKIyBDT05GSUdfUlRDX0RSVl9NU002MjQyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9C
UTQ4MDIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JQNUMwMSBpcyBub3Qgc2V0CiMgQ09O
RklHX1JUQ19EUlZfVjMwMjAgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMjQwNCBpcyBu
b3Qgc2V0CgojCiMgb24tQ1BVIFJUQyBkcml2ZXJzCiMKIyBDT05GSUdfUlRDX0RSVl9JTVhESSBp
cyBub3Qgc2V0CkNPTkZJR19SVENfRFJWX01DMTNYWFg9eQpDT05GSUdfUlRDX0RSVl9NWEM9eQpD
T05GSUdfUlRDX0RSVl9TTlZTPXkKIyBDT05GSUdfUlRDX0RSVl9NT1hBUlQgaXMgbm90IHNldAoK
IwojIEhJRCBTZW5zb3IgUlRDIGRyaXZlcnMKIwojIENPTkZJR19SVENfRFJWX0hJRF9TRU5TT1Jf
VElNRSBpcyBub3Qgc2V0CkNPTkZJR19ETUFERVZJQ0VTPXkKIyBDT05GSUdfRE1BREVWSUNFU19E
RUJVRyBpcyBub3Qgc2V0CgojCiMgRE1BIERldmljZXMKIwojIENPTkZJR19EV19ETUFDX0NPUkUg
aXMgbm90IHNldAojIENPTkZJR19EV19ETUFDIGlzIG5vdCBzZXQKQ09ORklHX01YM19JUFU9eQpD
T05GSUdfTVgzX0lQVV9JUlFTPTQKIyBDT05GSUdfVElNQl9ETUEgaXMgbm90IHNldApDT05GSUdf
SU1YX1NETUE9eQojIENPTkZJR19JTVhfRE1BIGlzIG5vdCBzZXQKQ09ORklHX01YU19ETUE9eQpD
T05GSUdfRE1BX0VOR0lORT15CkNPTkZJR19ETUFfT0Y9eQoKIwojIERNQSBDbGllbnRzCiMKIyBD
T05GSUdfTkVUX0RNQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FTWU5DX1RYX0RNQSBpcyBub3Qgc2V0
CiMgQ09ORklHX0RNQVRFU1QgaXMgbm90IHNldAojIENPTkZJR19BVVhESVNQTEFZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVUlPIGlzIG5vdCBzZXQKIyBDT05GSUdfVklSVF9EUklWRVJTIGlzIG5vdCBz
ZXQKCiMKIyBWaXJ0aW8gZHJpdmVycwojCiMgQ09ORklHX1ZJUlRJT19NTUlPIGlzIG5vdCBzZXQK
CiMKIyBNaWNyb3NvZnQgSHlwZXItViBndWVzdCBzdXBwb3J0CiMKQ09ORklHX1NUQUdJTkc9eQoj
IENPTkZJR19VU0JJUF9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfVzM1VU5EIGlzIG5vdCBzZXQK
IyBDT05GSUdfUFJJU00yX1VTQiBpcyBub3Qgc2V0CiMgQ09ORklHX0VDSE8gaXMgbm90IHNldAoj
IENPTkZJR19DT01FREkgaXMgbm90IHNldAojIENPTkZJR19SVExMSUIgaXMgbm90IHNldAojIENP
TkZJR19SODcxMlUgaXMgbm90IHNldAojIENPTkZJR19SODE4OEVVIGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRTNTEzOSBpcyBub3Qgc2V0CiMgQ09ORklHX1RSQU5aUE9SVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0xJTkU2X1VTQiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZUNjY1NiBpcyBub3Qgc2V0CiMgQ09O
RklHX1pTTUFMTE9DIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0VORVNUT1JBR0UgaXMgbm90IHNl
dAojIENPTkZJR19CQ01fV0lNQVggaXMgbm90IHNldAojIENPTkZJR19GVDEwMDAgaXMgbm90IHNl
dAoKIwojIFNwZWFrdXAgY29uc29sZSBzcGVlY2gKIwojIENPTkZJR19TUEVBS1VQIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQ0xFQVJQQURfVE0xMjE3IGlzIG5vdCBzZXQKIyBDT05G
SUdfVE9VQ0hTQ1JFRU5fU1lOQVBUSUNTX0kyQ19STUk0IGlzIG5vdCBzZXQKIyBDT05GSUdfU1RB
R0lOR19NRURJQSBpcyBub3Qgc2V0CgojCiMgQW5kcm9pZAojCiMgQ09ORklHX0FORFJPSUQgaXMg
bm90IHNldAojIENPTkZJR19VU0JfV1BBTl9IQ0QgaXMgbm90IHNldAojIENPTkZJR19XSU1BWF9H
RE03MlhYIGlzIG5vdCBzZXQKIyBDT05GSUdfTFRFX0dETTcyNFggaXMgbm90IHNldAojIENPTkZJ
R19DRUQxNDAxIGlzIG5vdCBzZXQKQ09ORklHX0RSTV9JTVg9eQpDT05GSUdfRFJNX0lNWF9GQl9I
RUxQRVI9eQpDT05GSUdfRFJNX0lNWF9QQVJBTExFTF9ESVNQTEFZPXkKQ09ORklHX0RSTV9JTVhf
VFZFPXkKQ09ORklHX0RSTV9JTVhfTERCPXkKQ09ORklHX0RSTV9JTVhfSVBVVjNfQ09SRT15CkNP
TkZJR19EUk1fSU1YX0lQVVYzPXkKIyBDT05GSUdfREdSUCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9EV0MyIGlzIG5vdCBzZXQKIyBDT05GSUdfTFVTVFJFX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdf
WElMTFlCVVMgaXMgbm90IHNldAojIENPTkZJR19ER0FQIGlzIG5vdCBzZXQKQ09ORklHX0NMS0RF
Vl9MT09LVVA9eQpDT05GSUdfSEFWRV9DTEtfUFJFUEFSRT15CkNPTkZJR19DT01NT05fQ0xLPXkK
CiMKIyBDb21tb24gQ2xvY2sgRnJhbWV3b3JrCiMKQ09ORklHX0NPTU1PTl9DTEtfREVCVUc9eQoj
IENPTkZJR19DT01NT05fQ0xLX1NJNTM1MSBpcyBub3Qgc2V0CgojCiMgSGFyZHdhcmUgU3Bpbmxv
Y2sgZHJpdmVycwojCkNPTkZJR19DTEtTUkNfT0Y9eQpDT05GSUdfQ0xLU1JDX01NSU89eQpDT05G
SUdfVkZfUElUX1RJTUVSPXkKIyBDT05GSUdfTUFJTEJPWCBpcyBub3Qgc2V0CiMgQ09ORklHX0lP
TU1VX1NVUFBPUlQgaXMgbm90IHNldAoKIwojIFJlbW90ZXByb2MgZHJpdmVycwojCiMgQ09ORklH
X1NURV9NT0RFTV9SUFJPQyBpcyBub3Qgc2V0CgojCiMgUnBtc2cgZHJpdmVycwojCiMgQ09ORklH
X1BNX0RFVkZSRVEgaXMgbm90IHNldAojIENPTkZJR19FWFRDT04gaXMgbm90IHNldAojIENPTkZJ
R19NRU1PUlkgaXMgbm90IHNldAojIENPTkZJR19JSU8gaXMgbm90IHNldApDT05GSUdfUFdNPXkK
Q09ORklHX1BXTV9TWVNGUz15CkNPTkZJR19QV01fSU1YPXkKIyBDT05GSUdfUFdNX1BDQTk2ODUg
aXMgbm90IHNldApDT05GSUdfSVJRQ0hJUD15CkNPTkZJR19BUk1fR0lDPXkKIyBDT05GSUdfSVBB
Q0tfQlVTIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfSEFTX1JFU0VUX0NPTlRST0xMRVI9eQpDT05G
SUdfUkVTRVRfQ09OVFJPTExFUj15CiMgQ09ORklHX0ZNQyBpcyBub3Qgc2V0CgojCiMgRmlsZSBz
eXN0ZW1zCiMKQ09ORklHX0RDQUNIRV9XT1JEX0FDQ0VTUz15CkNPTkZJR19FWFQyX0ZTPXkKQ09O
RklHX0VYVDJfRlNfWEFUVFI9eQpDT05GSUdfRVhUMl9GU19QT1NJWF9BQ0w9eQpDT05GSUdfRVhU
Ml9GU19TRUNVUklUWT15CiMgQ09ORklHX0VYVDJfRlNfWElQIGlzIG5vdCBzZXQKQ09ORklHX0VY
VDNfRlM9eQpDT05GSUdfRVhUM19ERUZBVUxUU19UT19PUkRFUkVEPXkKQ09ORklHX0VYVDNfRlNf
WEFUVFI9eQpDT05GSUdfRVhUM19GU19QT1NJWF9BQ0w9eQpDT05GSUdfRVhUM19GU19TRUNVUklU
WT15CkNPTkZJR19FWFQ0X0ZTPXkKQ09ORklHX0VYVDRfRlNfUE9TSVhfQUNMPXkKQ09ORklHX0VY
VDRfRlNfU0VDVVJJVFk9eQojIENPTkZJR19FWFQ0X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0pC
RD15CiMgQ09ORklHX0pCRF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19KQkQyPXkKIyBDT05GSUdf
SkJEMl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19GU19NQkNBQ0hFPXkKIyBDT05GSUdfUkVJU0VS
RlNfRlMgaXMgbm90IHNldAojIENPTkZJR19KRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19YRlNf
RlMgaXMgbm90IHNldAojIENPTkZJR19HRlMyX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfT0NGUzJf
RlMgaXMgbm90IHNldAojIENPTkZJR19CVFJGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX05JTEZT
Ml9GUyBpcyBub3Qgc2V0CkNPTkZJR19GU19QT1NJWF9BQ0w9eQpDT05GSUdfRklMRV9MT0NLSU5H
PXkKQ09ORklHX0ZTTk9USUZZPXkKQ09ORklHX0ROT1RJRlk9eQpDT05GSUdfSU5PVElGWV9VU0VS
PXkKIyBDT05GSUdfRkFOT1RJRlkgaXMgbm90IHNldApDT05GSUdfUVVPVEE9eQpDT05GSUdfUVVP
VEFfTkVUTElOS19JTlRFUkZBQ0U9eQojIENPTkZJR19QUklOVF9RVU9UQV9XQVJOSU5HIGlzIG5v
dCBzZXQKIyBDT05GSUdfUVVPVEFfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19RRk1UX1YxIGlz
IG5vdCBzZXQKIyBDT05GSUdfUUZNVF9WMiBpcyBub3Qgc2V0CkNPTkZJR19RVU9UQUNUTD15CkNP
TkZJR19BVVRPRlM0X0ZTPXkKQ09ORklHX0ZVU0VfRlM9eQojIENPTkZJR19DVVNFIGlzIG5vdCBz
ZXQKCiMKIyBDYWNoZXMKIwojIENPTkZJR19GU0NBQ0hFIGlzIG5vdCBzZXQKCiMKIyBDRC1ST00v
RFZEIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0lTTzk2NjBfRlM9bQpDT05GSUdfSk9MSUVUPXkKQ09O
RklHX1pJU09GUz15CkNPTkZJR19VREZfRlM9bQpDT05GSUdfVURGX05MUz15CgojCiMgRE9TL0ZB
VC9OVCBGaWxlc3lzdGVtcwojCkNPTkZJR19GQVRfRlM9eQpDT05GSUdfTVNET1NfRlM9bQpDT05G
SUdfVkZBVF9GUz15CkNPTkZJR19GQVRfREVGQVVMVF9DT0RFUEFHRT00MzcKQ09ORklHX0ZBVF9E
RUZBVUxUX0lPQ0hBUlNFVD0iaXNvODg1OS0xIgojIENPTkZJR19OVEZTX0ZTIGlzIG5vdCBzZXQK
CiMKIyBQc2V1ZG8gZmlsZXN5c3RlbXMKIwpDT05GSUdfUFJPQ19GUz15CkNPTkZJR19QUk9DX1NZ
U0NUTD15CkNPTkZJR19QUk9DX1BBR0VfTU9OSVRPUj15CkNPTkZJR19TWVNGUz15CkNPTkZJR19U
TVBGUz15CiMgQ09ORklHX1RNUEZTX1BPU0lYX0FDTCBpcyBub3Qgc2V0CiMgQ09ORklHX1RNUEZT
X1hBVFRSIGlzIG5vdCBzZXQKIyBDT05GSUdfSFVHRVRMQl9QQUdFIGlzIG5vdCBzZXQKQ09ORklH
X0NPTkZJR0ZTX0ZTPW0KQ09ORklHX01JU0NfRklMRVNZU1RFTVM9eQojIENPTkZJR19BREZTX0ZT
IGlzIG5vdCBzZXQKIyBDT05GSUdfQUZGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0VDUllQVF9G
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0hGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hGU1BMVVNf
RlMgaXMgbm90IHNldAojIENPTkZJR19CRUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQkZTX0ZT
IGlzIG5vdCBzZXQKIyBDT05GSUdfRUZTX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0pGRlMyX0ZTPXkK
Q09ORklHX0pGRlMyX0ZTX0RFQlVHPTAKQ09ORklHX0pGRlMyX0ZTX1dSSVRFQlVGRkVSPXkKIyBD
T05GSUdfSkZGUzJfRlNfV0JVRl9WRVJJRlkgaXMgbm90IHNldAojIENPTkZJR19KRkZTMl9TVU1N
QVJZIGlzIG5vdCBzZXQKIyBDT05GSUdfSkZGUzJfRlNfWEFUVFIgaXMgbm90IHNldAojIENPTkZJ
R19KRkZTMl9DT01QUkVTU0lPTl9PUFRJT05TIGlzIG5vdCBzZXQKQ09ORklHX0pGRlMyX1pMSUI9
eQojIENPTkZJR19KRkZTMl9MWk8gaXMgbm90IHNldApDT05GSUdfSkZGUzJfUlRJTUU9eQojIENP
TkZJR19KRkZTMl9SVUJJTiBpcyBub3Qgc2V0CkNPTkZJR19VQklGU19GUz15CiMgQ09ORklHX1VC
SUZTX0ZTX0FEVkFOQ0VEX0NPTVBSIGlzIG5vdCBzZXQKQ09ORklHX1VCSUZTX0ZTX0xaTz15CkNP
TkZJR19VQklGU19GU19aTElCPXkKIyBDT05GSUdfTE9HRlMgaXMgbm90IHNldAojIENPTkZJR19D
UkFNRlMgaXMgbm90IHNldAojIENPTkZJR19TUVVBU0hGUyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZY
RlNfRlMgaXMgbm90IHNldAojIENPTkZJR19NSU5JWF9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX09N
RlNfRlMgaXMgbm90IHNldAojIENPTkZJR19IUEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfUU5Y
NEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfUU5YNkZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdf
Uk9NRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19QU1RPUkUgaXMgbm90IHNldAojIENPTkZJR19T
WVNWX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRjJG
U19GUyBpcyBub3Qgc2V0CkNPTkZJR19ORVRXT1JLX0ZJTEVTWVNURU1TPXkKQ09ORklHX05GU19G
Uz15CkNPTkZJR19ORlNfVjI9eQpDT05GSUdfTkZTX1YzPXkKQ09ORklHX05GU19WM19BQ0w9eQpD
T05GSUdfTkZTX1Y0PXkKIyBDT05GSUdfTkZTX1NXQVAgaXMgbm90IHNldAojIENPTkZJR19ORlNf
VjRfMSBpcyBub3Qgc2V0CkNPTkZJR19ST09UX05GUz15CiMgQ09ORklHX05GU19VU0VfTEVHQUNZ
X0ROUyBpcyBub3Qgc2V0CkNPTkZJR19ORlNfVVNFX0tFUk5FTF9ETlM9eQojIENPTkZJR19ORlNE
IGlzIG5vdCBzZXQKQ09ORklHX0xPQ0tEPXkKQ09ORklHX0xPQ0tEX1Y0PXkKQ09ORklHX05GU19B
Q0xfU1VQUE9SVD15CkNPTkZJR19ORlNfQ09NTU9OPXkKQ09ORklHX1NVTlJQQz15CkNPTkZJR19T
VU5SUENfR1NTPXkKIyBDT05GSUdfU1VOUlBDX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0VQ
SF9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NJRlMgaXMgbm90IHNldAojIENPTkZJR19OQ1BfRlMg
aXMgbm90IHNldAojIENPTkZJR19DT0RBX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUZTX0ZTIGlz
IG5vdCBzZXQKQ09ORklHX05MUz15CkNPTkZJR19OTFNfREVGQVVMVD0iY3A0MzciCkNPTkZJR19O
TFNfQ09ERVBBR0VfNDM3PXkKIyBDT05GSUdfTkxTX0NPREVQQUdFXzczNyBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV83NzUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
ODUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1MiBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV84NTUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODU3
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MCBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19DT0RFUEFHRV84NjEgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYyIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MyBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19DT0RFUEFHRV84NjQgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY1IGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19D
T0RFUEFHRV84NjkgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTM2IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzk1MCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RF
UEFHRV85MzIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTQ5IGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX0NPREVQQUdFXzg3NCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5
XzggaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfMTI1MCBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV8xMjUxIGlzIG5vdCBzZXQKQ09ORklHX05MU19BU0NJST15CkNPTkZJ
R19OTFNfSVNPODg1OV8xPXkKIyBDT05GSUdfTkxTX0lTTzg4NTlfMiBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19JU084ODU5XzMgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV80IGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfNSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084
ODU5XzYgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV83IGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0lTTzg4NTlfOSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzEzIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTQgaXMgbm90IHNldApDT05GSUdfTkxTX0lTTzg4
NTlfMTU9bQojIENPTkZJR19OTFNfS09JOF9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0tPSThf
VSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfUk9NQU4gaXMgbm90IHNldAojIENPTkZJR19O
TFNfTUFDX0NFTFRJQyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfQ0VOVEVVUk8gaXMgbm90
IHNldAojIENPTkZJR19OTFNfTUFDX0NST0FUSUFOIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX01B
Q19DWVJJTExJQyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfR0FFTElDIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX01BQ19HUkVFSyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfSUNFTEFO
RCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfSU5VSVQgaXMgbm90IHNldAojIENPTkZJR19O
TFNfTUFDX1JPTUFOSUFOIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX01BQ19UVVJLSVNIIGlzIG5v
dCBzZXQKQ09ORklHX05MU19VVEY4PXkKIyBDT05GSUdfRExNIGlzIG5vdCBzZXQKCiMKIyBLZXJu
ZWwgaGFja2luZwojCgojCiMgcHJpbnRrIGFuZCBkbWVzZyBvcHRpb25zCiMKIyBDT05GSUdfUFJJ
TlRLX1RJTUUgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9NRVNTQUdFX0xPR0xFVkVMPTQKIyBD
T05GSUdfQk9PVF9QUklOVEtfREVMQVkgaXMgbm90IHNldAojIENPTkZJR19EWU5BTUlDX0RFQlVH
IGlzIG5vdCBzZXQKCiMKIyBDb21waWxlLXRpbWUgY2hlY2tzIGFuZCBjb21waWxlciBvcHRpb25z
CiMKIyBDT05GSUdfREVCVUdfSU5GTyBpcyBub3Qgc2V0CkNPTkZJR19FTkFCTEVfV0FSTl9ERVBS
RUNBVEVEPXkKQ09ORklHX0VOQUJMRV9NVVNUX0NIRUNLPXkKQ09ORklHX0ZSQU1FX1dBUk49MTAy
NAojIENPTkZJR19TVFJJUF9BU01fU1lNUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFQURBQkxFX0FT
TSBpcyBub3Qgc2V0CiMgQ09ORklHX1VOVVNFRF9TWU1CT0xTIGlzIG5vdCBzZXQKQ09ORklHX0RF
QlVHX0ZTPXkKIyBDT05GSUdfSEVBREVSU19DSEVDSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X1NFQ1RJT05fTUlTTUFUQ0ggaXMgbm90IHNldApDT05GSUdfRlJBTUVfUE9JTlRFUj15CiMgQ09O
RklHX0RFQlVHX0ZPUkNFX1dFQUtfUEVSX0NQVSBpcyBub3Qgc2V0CkNPTkZJR19NQUdJQ19TWVNS
UT15CkNPTkZJR19ERUJVR19LRVJORUw9eQoKIwojIE1lbW9yeSBEZWJ1Z2dpbmcKIwojIENPTkZJ
R19ERUJVR19QQUdFQUxMT0MgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19PQkpFQ1RTIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0xVQl9TVEFUUyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0RFQlVHX0tN
RU1MRUFLPXkKIyBDT05GSUdfREVCVUdfS01FTUxFQUsgaXMgbm90IHNldAojIENPTkZJR19ERUJV
R19TVEFDS19VU0FHRSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1ZNIGlzIG5vdCBzZXQKIyBD
T05GSUdfREVCVUdfTUVNT1JZX0lOSVQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19QRVJfQ1BV
X01BUFMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TSElSUSBpcyBub3Qgc2V0CgojCiMgRGVi
dWcgTG9ja3VwcyBhbmQgSGFuZ3MKIwojIENPTkZJR19MT0NLVVBfREVURUNUT1IgaXMgbm90IHNl
dAojIENPTkZJR19ERVRFQ1RfSFVOR19UQVNLIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFOSUNfT05f
T09QUyBpcyBub3Qgc2V0CkNPTkZJR19QQU5JQ19PTl9PT1BTX1ZBTFVFPTAKIyBDT05GSUdfU0NI
RURfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19TQ0hFRFNUQVRTIGlzIG5vdCBzZXQKIyBDT05G
SUdfVElNRVJfU1RBVFMgaXMgbm90IHNldAoKIwojIExvY2sgRGVidWdnaW5nIChzcGlubG9ja3Ms
IG11dGV4ZXMsIGV0Yy4uLikKIwojIENPTkZJR19ERUJVR19SVF9NVVRFWEVTIGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRfTVVURVhfVEVTVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU1BJTkxP
Q0sgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19NVVRFWEVTIGlzIG5vdCBzZXQKIyBDT05GSUdf
REVCVUdfV1dfTVVURVhfU0xPV1BBVEggaXMgbm90IHNldAojIENPTkZJR19ERUJVR19MT0NLX0FM
TE9DIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPVkVfTE9DS0lORyBpcyBub3Qgc2V0CiMgQ09ORklH
X0xPQ0tfU1RBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0FUT01JQ19TTEVFUCBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFQlVHX0xPQ0tJTkdfQVBJX1NFTEZURVNUUyBpcyBub3Qgc2V0CiMgQ09O
RklHX0RFQlVHX0tPQkpFQ1QgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19LT0JKRUNUX1JFTEVB
U0UgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19CVUdWRVJCT1NFIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVCVUdfV1JJVEVDT1VOVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0xJU1QgaXMgbm90
IHNldAojIENPTkZJR19ERUJVR19TRyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX05PVElGSUVS
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0NSRURFTlRJQUxTIGlzIG5vdCBzZXQKCiMKIyBS
Q1UgRGVidWdnaW5nCiMKIyBDT05GSUdfU1BBUlNFX1JDVV9QT0lOVEVSIGlzIG5vdCBzZXQKIyBD
T05GSUdfUkNVX1RPUlRVUkVfVEVTVCBpcyBub3Qgc2V0CkNPTkZJR19SQ1VfQ1BVX1NUQUxMX1RJ
TUVPVVQ9MjEKIyBDT05GSUdfUkNVX0NQVV9TVEFMTF9JTkZPIGlzIG5vdCBzZXQKIyBDT05GSUdf
UkNVX1RSQUNFIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfQkxPQ0tfRVhUX0RFVlQgaXMgbm90
IHNldAojIENPTkZJR19OT1RJRklFUl9FUlJPUl9JTkpFQ1RJT04gaXMgbm90IHNldAojIENPTkZJ
R19GQVVMVF9JTkpFQ1RJT04gaXMgbm90IHNldApDT05GSUdfSEFWRV9GVU5DVElPTl9UUkFDRVI9
eQpDT05GSUdfSEFWRV9GVU5DVElPTl9HUkFQSF9UUkFDRVI9eQpDT05GSUdfSEFWRV9EWU5BTUlD
X0ZUUkFDRT15CkNPTkZJR19IQVZFX0ZUUkFDRV9NQ09VTlRfUkVDT1JEPXkKQ09ORklHX0hBVkVf
U1lTQ0FMTF9UUkFDRVBPSU5UUz15CkNPTkZJR19IQVZFX0NfUkVDT1JETUNPVU5UPXkKQ09ORklH
X1RSQUNJTkdfU1VQUE9SVD15CiMgQ09ORklHX0ZUUkFDRSBpcyBub3Qgc2V0CgojCiMgUnVudGlt
ZSBUZXN0aW5nCiMKIyBDT05GSUdfTEtEVE0gaXMgbm90IHNldAojIENPTkZJR19URVNUX0xJU1Rf
U09SVCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tUUkFDRV9TRUxGX1RFU1QgaXMgbm90IHNldAoj
IENPTkZJR19SQlRSRUVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVSVkFMX1RSRUVfVEVT
VCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUT01JQzY0X1NFTEZURVNUIGlzIG5vdCBzZXQKIyBDT05G
SUdfVEVTVF9TVFJJTkdfSEVMUEVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfS1NUUlRPWCBp
cyBub3Qgc2V0CiMgQ09ORklHX0RNQV9BUElfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19TQU1Q
TEVTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LR0RCPXkKIyBDT05GSUdfS0dEQiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NUUklDVF9ERVZNRU0gaXMgbm90IHNldAojIENPTkZJR19BUk1fVU5X
SU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfVVNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RF
QlVHX0xMIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX0lNWF9VQVJUX1BPUlQ9MQpDT05GSUdfREVC
VUdfTExfSU5DTFVERT0ibWFjaC9kZWJ1Zy1tYWNyby5TIgojIENPTkZJR19ERUJVR19VQVJUX1BM
MDFYIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfVUFSVF84MjUwIGlzIG5vdCBzZXQKQ09ORklH
X1VOQ09NUFJFU1NfSU5DTFVERT0iZGVidWcvdW5jb21wcmVzcy5oIgojIENPTkZJR19QSURfSU5f
Q09OVEVYVElEUiBpcyBub3Qgc2V0CgojCiMgU2VjdXJpdHkgb3B0aW9ucwojCkNPTkZJR19LRVlT
PXkKIyBDT05GSUdfRU5DUllQVEVEX0tFWVMgaXMgbm90IHNldAojIENPTkZJR19LRVlTX0RFQlVH
X1BST0NfS0VZUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZX0RNRVNHX1JFU1RSSUNUIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VDVVJJVFkgaXMgbm90IHNldApDT05GSUdfU0VDVVJJVFlGUz15
CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZX0RBQz15CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZPSIi
CkNPTkZJR19DUllQVE89eQoKIwojIENyeXB0byBjb3JlIG9yIGhlbHBlcgojCkNPTkZJR19DUllQ
VE9fQUxHQVBJPXkKQ09ORklHX0NSWVBUT19BTEdBUEkyPXkKQ09ORklHX0NSWVBUT19CTEtDSVBI
RVI9eQpDT05GSUdfQ1JZUFRPX0JMS0NJUEhFUjI9eQpDT05GSUdfQ1JZUFRPX0hBU0g9eQpDT05G
SUdfQ1JZUFRPX0hBU0gyPXkKQ09ORklHX0NSWVBUT19STkcyPXkKIyBDT05GSUdfQ1JZUFRPX01B
TkFHRVIgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fTUFOQUdFUjIgaXMgbm90IHNldAojIENP
TkZJR19DUllQVE9fVVNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19HRjEyOE1VTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19OVUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1BD
UllQVCBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fV09SS1FVRVVFPXkKIyBDT05GSUdfQ1JZUFRP
X0NSWVBURCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19BVVRIRU5DIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX1RFU1QgaXMgbm90IHNldAoKIwojIEF1dGhlbnRpY2F0ZWQgRW5jcnlwdGlv
biB3aXRoIEFzc29jaWF0ZWQgRGF0YQojCiMgQ09ORklHX0NSWVBUT19DQ00gaXMgbm90IHNldAoj
IENPTkZJR19DUllQVE9fR0NNIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NFUUlWIGlzIG5v
dCBzZXQKCiMKIyBCbG9jayBtb2RlcwojCiMgQ09ORklHX0NSWVBUT19DQkMgaXMgbm90IHNldAoj
IENPTkZJR19DUllQVE9fQ1RSIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NUUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19FQ0IgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fTFJXIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1BDQkMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
WFRTIGlzIG5vdCBzZXQKCiMKIyBIYXNoIG1vZGVzCiMKIyBDT05GSUdfQ1JZUFRPX0NNQUMgaXMg
bm90IHNldAojIENPTkZJR19DUllQVE9fSE1BQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19Y
Q0JDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1ZNQUMgaXMgbm90IHNldAoKIwojIERpZ2Vz
dAojCkNPTkZJR19DUllQVE9fQ1JDMzJDPXkKIyBDT05GSUdfQ1JZUFRPX0NSQzMyIGlzIG5vdCBz
ZXQKQ09ORklHX0NSWVBUT19DUkNUMTBESUY9eQojIENPTkZJR19DUllQVE9fR0hBU0ggaXMgbm90
IHNldAojIENPTkZJR19DUllQVE9fTUQ0IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX01ENSBp
cyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19NSUNIQUVMX01JQyBpcyBub3Qgc2V0CiMgQ09ORklH
X0NSWVBUT19STUQxMjggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fUk1EMTYwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1JZUFRPX1JNRDI1NiBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19STUQz
MjAgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU0hBMSBpcyBub3Qgc2V0CiMgQ09ORklHX0NS
WVBUT19TSEExX0FSTSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TSEEyNTYgaXMgbm90IHNl
dAojIENPTkZJR19DUllQVE9fU0hBNTEyIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1RHUjE5
MiBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19XUDUxMiBpcyBub3Qgc2V0CgojCiMgQ2lwaGVy
cwojCkNPTkZJR19DUllQVE9fQUVTPXkKIyBDT05GSUdfQ1JZUFRPX0FFU19BUk0gaXMgbm90IHNl
dAojIENPTkZJR19DUllQVE9fQU5VQklTIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19BUkM0PXkK
IyBDT05GSUdfQ1JZUFRPX0JMT1dGSVNIIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NBTUVM
TElBIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NBU1Q1IGlzIG5vdCBzZXQKIyBDT05GSUdf
Q1JZUFRPX0NBU1Q2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0RFUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0NSWVBUT19GQ1JZUFQgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fS0hBWkFEIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NBTFNBMjAgaXMgbm90IHNldAojIENPTkZJR19DUllQ
VE9fU0VFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TRVJQRU5UIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX1RFQSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19UV09GSVNIIGlzIG5v
dCBzZXQKCiMKIyBDb21wcmVzc2lvbgojCkNPTkZJR19DUllQVE9fREVGTEFURT15CiMgQ09ORklH
X0NSWVBUT19aTElCIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19MWk89eQojIENPTkZJR19DUllQ
VE9fTFo0IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0xaNEhDIGlzIG5vdCBzZXQKCiMKIyBS
YW5kb20gTnVtYmVyIEdlbmVyYXRpb24KIwojIENPTkZJR19DUllQVE9fQU5TSV9DUFJORyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19VU0VSX0FQSV9IQVNIIGlzIG5vdCBzZXQKIyBDT05GSUdf
Q1JZUFRPX1VTRVJfQVBJX1NLQ0lQSEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0hXIGlz
IG5vdCBzZXQKIyBDT05GSUdfQVNZTU1FVFJJQ19LRVlfVFlQRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0JJTkFSWV9QUklOVEYgaXMgbm90IHNldAoKIwojIExpYnJhcnkgcm91dGluZXMKIwpDT05GSUdf
QklUUkVWRVJTRT15CkNPTkZJR19SQVRJT05BTD15CkNPTkZJR19HRU5FUklDX1NUUk5DUFlfRlJP
TV9VU0VSPXkKQ09ORklHX0dFTkVSSUNfU1RSTkxFTl9VU0VSPXkKQ09ORklHX0dFTkVSSUNfTkVU
X1VUSUxTPXkKQ09ORklHX0dFTkVSSUNfUENJX0lPTUFQPXkKQ09ORklHX0dFTkVSSUNfSU89eQpD
T05GSUdfU1RNUF9ERVZJQ0U9eQpDT05GSUdfQ1JDX0NDSVRUPW0KQ09ORklHX0NSQzE2PXkKQ09O
RklHX0NSQ19UMTBESUY9eQpDT05GSUdfQ1JDX0lUVV9UPW0KQ09ORklHX0NSQzMyPXkKIyBDT05G
SUdfQ1JDMzJfU0VMRlRFU1QgaXMgbm90IHNldApDT05GSUdfQ1JDMzJfU0xJQ0VCWTg9eQojIENP
TkZJR19DUkMzMl9TTElDRUJZNCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSQzMyX1NBUldBVEUgaXMg
bm90IHNldAojIENPTkZJR19DUkMzMl9CSVQgaXMgbm90IHNldApDT05GSUdfQ1JDNz1tCkNPTkZJ
R19MSUJDUkMzMkM9bQojIENPTkZJR19DUkM4IGlzIG5vdCBzZXQKQ09ORklHX1pMSUJfSU5GTEFU
RT15CkNPTkZJR19aTElCX0RFRkxBVEU9eQpDT05GSUdfTFpPX0NPTVBSRVNTPXkKQ09ORklHX0xa
T19ERUNPTVBSRVNTPXkKIyBDT05GSUdfWFpfREVDIGlzIG5vdCBzZXQKIyBDT05GSUdfWFpfREVD
X0JDSiBpcyBub3Qgc2V0CkNPTkZJR19ERUNPTVBSRVNTX0daSVA9eQpDT05GSUdfR0VORVJJQ19B
TExPQ0FUT1I9eQpDT05GSUdfSEFTX0lPTUVNPXkKQ09ORklHX0hBU19JT1BPUlQ9eQpDT05GSUdf
SEFTX0RNQT15CkNPTkZJR19DUFVfUk1BUD15CkNPTkZJR19EUUw9eQpDT05GSUdfTkxBVFRSPXkK
Q09ORklHX0dFTkVSSUNfQVRPTUlDNjQ9eQpDT05GSUdfQVJDSF9IQVNfQVRPTUlDNjRfREVDX0lG
X1BPU0lUSVZFPXkKQ09ORklHX0FWRVJBR0U9eQojIENPTkZJR19DT1JESUMgaXMgbm90IHNldAoj
IENPTkZJR19ERFIgaXMgbm90IHNldApDT05GSUdfT0lEX1JFR0lTVFJZPXkKQ09ORklHX0ZPTlRf
U1VQUE9SVD15CkNPTkZJR19GT05UUz15CkNPTkZJR19GT05UXzh4OD15CkNPTkZJR19GT05UXzh4
MTY9eQojIENPTkZJR19GT05UXzZ4MTEgaXMgbm90IHNldAojIENPTkZJR19GT05UXzd4MTQgaXMg
bm90IHNldAojIENPTkZJR19GT05UX1BFQVJMXzh4OCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZPTlRf
QUNPUk5fOHg4IGlzIG5vdCBzZXQKIyBDT05GSUdfRk9OVF9NSU5JXzR4NiBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZPTlRfU1VOOHgxNiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZPTlRfU1VOMTJ4MjIgaXMg
bm90IHNldAojIENPTkZJR19GT05UXzEweDE4IGlzIG5vdCBzZXQKIyBDT05GSUdfVklSVFVBTEla
QVRJT04gaXMgbm90IHNldAo=
--001a11c305a40e212104ea7fe0a0--
