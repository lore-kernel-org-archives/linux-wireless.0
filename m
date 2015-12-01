Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33285 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbLAG0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 01:26:39 -0500
Received: by wmec201 with SMTP id c201so189482572wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2015 22:26:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20151201T071931-353@post.gmane.org>
References: <loom.20151201T071931-353@post.gmane.org>
Date: Tue, 1 Dec 2015 07:26:37 +0100
Message-ID: <CALhHN=o4xAhy9oz0Q7sy-Ubji-nBf6pdJ7OSj8xLU0mn86n1qQ@mail.gmail.com> (sfid-20151201_072643_239436_2625388C)
Subject: Re: ath10k: device has crashed during init - qca6174 chipset
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Bartlomiej Grzeskowiak <bartlomiej.grzeskowiak@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 December 2015 at 07:20, Bartlomiej Grzeskowiak
<bartlomiej.grzeskowiak@gmail.com> wrote:
> Hi,
>
> I am trying to use ath10k driver from the latest backports-4.4-rc.2-1 with
> kernel 3.10.65 and qca6174 based wlan module. Could you give me some hints
> about possible problem.
> ath10k_core.ko module loaded with skip_otp=y and debug_mask=0xffffffff.
>
> I get following error message:
> [ 5301.614749] ath10k_pci 0000:01:00.0: wmi unified ready event not
> received
> [ 5301.614749] ath10k_pci 0000:01:00.0: device has crashed during init
Seems Bartosz already fix this in this patch:
[PATCH] ath10k: fix QCA61X4 boot up

BR
Janusz

> [ 5301.644767] ath10k_pci 0000:01:00.0: device has crashed during init
> [ 5301.651025] ath10k_pci 0000:01:00.0: failed to wait for target init: -70
> [ 5301.661134] ath10k_pci 0000:01:00.0: could not init core (-110)
> [ 5301.667310] ath10k_pci 0000:01:00.0: could not probe fw (-110)
>
> Some other important debug messages (I can also provide the whole log if
> needed):
> ath10k_pci 0000:01:00.0: found fw version WLAN.RM.2.0-00180-QCARMSWPZ-1
> [...]
> ath10k_pci 0000:01:00.0: boot get otp board id result 0x00000001 board_id 0
> chip_id 0
> ath10k_pci 0000:01:00.0: boot using board name
> 'bus=pci,vendor=168c,device=003e,subsystem-vendor=0000,subsystem-
> device=0000'
> [...]
> ath10k_pci 0000:01:00.0: Target ready! transmit resources: 2 size:1792
> [...]
> ath10k_pci 0000:01:00.0: HTC Service HTT Data connect response: status:
> 0x0, assigned ep: 0x1
> [...]
> ath10k_pci 0000:01:00.0: HTC Service WMI connect response: status: 0x0,
> assigned ep: 0x2
> [...]
> ath10k_pci 0000:01:00.0: wmi event service ready min_tx_power 0x0000003f
> max_tx_power 0x0000003f ht_cap 0x0000085b vht_cap 0x339011b2 sw_ver0
> 0x01000000 sw_ver1 0x0000008f fw_build 0x200700b4 phy_capab 0x00000003
> num_rf_chains 0x00000002 eeprom_rd 0x00000000 num_mem_reqs 0x00000000
> ath10k_pci 0000:01:00.0: firmware WLAN.RM.2.0-00180-QCARMSWPZ-1 booted
> [...]
> ath10k_pci 0000:01:00.0: ath10k_htc_notify_tx_completion: ep 2 skb 8cc3b6c0
> ath10k_pci 0000:01:00.0: pci ps timer refcount 0 awake 1
> ath10k_pci 0000:01:00.0: pci ps sleep reg refcount 0 awake 1
> ath10k_pci 0000:01:00.0: wmi unified ready event not received
> ath10k_pci 0000:01:00.0: boot hif stop
> [...]
> ath10k_pci 0000:01:00.0: boot init ce src ring id 0 entries 16 base_addr
> 8e053000
> ath10k_pci 0000:01:00.0: boot ce dest ring id 1 entries 512 base_addr
> 8e054000
> ath10k_pci 0000:01:00.0: boot ce dest ring id 2 entries 128 base_addr
> 8e056000
> ath10k_pci 0000:01:00.0: boot init ce src ring id 3 entries 32 base_addr
> 8e057000
> ath10k_pci 0000:01:00.0: boot init ce src ring id 4 entries 4096 base_addr
> 8e060000
> ath10k_pci 0000:01:00.0: boot ce dest ring id 5 entries 512 base_addr
> 8e058000
> ath10k_pci 0000:01:00.0: boot init ce src ring id 7 entries 2 base_addr
> 8e05a000
> ath10k_pci 0000:01:00.0: boot ce dest ring id 7 entries 2 base_addr
> 8e05b000
> ath10k_pci 0000:01:00.0: boot waiting target to initialise
> ath10k_pci 0000:01:00.0: boot target indicator 0
> ath10k_pci 0000:01:00.0: boot target indicator 1
> ath10k_pci 0000:01:00.0: device has crashed during init
> ath10k_pci 0000:01:00.0: failed to wait for target init: -70
> ath10k_pci 0000:01:00.0: could not init core (-110)
> ath10k_pci 0000:01:00.0: boot hif power down
> ath10k_pci 0000:01:00.0: could not probe fw (-110)
> ath10k_pci 0000:01:00.0: pci ps timer refcount 0 awake 1
> ath10k_pci 0000:01:00.0: pci ps sleep reg refcount 0 awake 1
>
> Thank you
> Bartek
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
