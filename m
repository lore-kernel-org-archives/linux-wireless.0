Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35226 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab1HNSbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 14:31:23 -0400
Received: by eyx24 with SMTP id 24so2738345eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 11:31:19 -0700 (PDT)
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
	arend@broadcom.com, frankyl@broadcom.com, kanyan@broadcom.com
Subject: BCM4325 support in brcm80211 or newer versions of bcm4329 driver
Date: Sun, 14 Aug 2011 20:31:09 +0200
Message-ID: <1514181.3grperja2F@flatron> (sfid-20110814_203158_278646_21BF3B71)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm looking into running current Linux kernel on a platform equipped with the 
BCM4325 full mac combo chip, but unfortunately the shipped DHD driver (v. 
4.217.*) is outdated and designed for stock 2.6.29 kernel with much hardcoding 
done to glue everything together.

I did some reasearch and it led me to a newer version of the DHD driver, 
designed for BCM4329 (v. 4.218), which after some modifications (BCD protocol 
version 2, some event IDs, etc.) started to work on my hardware, with one 
exception: waiting for RxCtrl after sending an "iscanresults" request times 
out. I'm attaching driver debug output at the bottom of this message.

A bit more details about my hardware: a Samsung S3C6410-based board connected 
to a BCM4325 chip using 4-bit SDIO interface, without dedicated IRQ pin (using 
SDIO IRQ feature), so undefining of OOB_INTR_ONLY and HW_OOB and defining of 
SDIO_ISR_THREAD was needed.

Do you have any suggestions?

Best regards,
Tomasz Figa

<4>[ 4155.362137] wifi_set_power = 1
<4>[ 4155.362292] spica_wlan_set_power = 1
<4>[ 4155.514470] wifi_set_carddetect = 1
<4>[ 4155.514637] spica_wlan_set_carddetect = 1
<4>[ 4155.531995] 
<4>[ 4155.532026] Dongle Host Driver, version 4.218.248.23
<4>[ 4155.532063] Compiled in drivers/net/wireless/bcm4329 on Aug 14 2011 at 
19:18:42
<4>[ 4155.797738] mmc1: queuing unknown CIS tuple 0x80 (51 bytes)
<4>[ 4155.802713] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
<4>[ 4155.804581] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
<4>[ 4155.808828] mmc1: queuing unknown CIS tuple 0x80 (8 bytes)
<4>[ 4155.813066] mmc1: queuing unknown CIS tuple 0x80 (6 bytes)
<4>[ 4155.823661] mmc1: queuing unknown CIS tuple 0x02 (1 bytes)
<6>[ 4155.855412] mmc1: new SDIO card at address 0001
<4>[ 4155.897125] dhdsdio_probe: Enter
<4>[ 4155.897296] dhdsdio_probe: venid 0x14e4 devid 0x0000
<4>[ 4155.897457] dhdsdio_probe: allow device id 0, will check chip internals
<4>[ 4155.898213] F1 signature read @0x18000000=0x5264325
<4>[ 4156.009345] Function 0 CIS:
<4>[ 4156.009483]     20 04 d0 02 92 04 21 02 0c 00 22 04 00 01 00 5a 
<4>[ 4156.009902]     80 33 fe 21 02 0c 00 22 2a 01 00 00 00 c5 02 fd 
<4>[ 4156.010306]     00 00 00 00 00 40 00 00 80 ff 00 00 00 00 00 00 
<4>[ 4156.010706]     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.011107]     00 00 00 ff ff 80 07 19 00 26 37 82 86 b6 80 02 
<4>[ 4156.011511]     02 10 80 08 03 08 14 e6 fa b5 fe 3e 00 00 80 06 
<4>[ 4156.011914]     81 00 88 1c 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.012313]     00 00 00 00 02 01 ff ff 
<4>[ 4156.087723] Function 1 CIS:
<4>[ 4156.087860]     21 02 0c 00 22 2a 01 00 00 00 c5 02 fd 00 00 00 
<4>[ 4156.088280]     00 00 40 00 00 80 ff 00 00 00 00 00 00 00 00 00 
<4>[ 4156.088683]     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.089082]     ff 
<4>[ 4156.176491] Function 2 CIS:
<4>[ 4156.176628]     21 02 0c 00 22 2a 01 00 00 00 c5 02 fd 00 00 00 
<4>[ 4156.177049]     00 00 40 00 00 80 ff 00 00 00 00 00 00 00 00 00 
<4>[ 4156.177452]     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.177853]     ff 
<4>[ 4156.183180] DHD: dongle ram size is set to 393216(orig 393216)
<4>[ 4156.183706] dhd_attach: Enter
<4>[ 4156.183963] dhd_add_if: idx 0, handle->c92a9800
<4>[ 4156.184136] success alloc section 0
<4>[ 4156.185212] dhdsdio_probe_malloc: Enter
<4>[ 4156.185384] success alloc section 1
<4>[ 4156.185546] success alloc section 2
<4>[ 4156.185775] dhdsdio_probe_init: Enter
<4>[ 4156.186285] dhdsdio_probe_init: Initial value for sd_divisor is 2
<4>[ 4156.186508] dhdsdio_probe_init: Initial value for sd_mode is 2
<4>[ 4156.186704] dhdsdio_probe_init: Initial value for sd_blocksize is 512
<4>[ 4156.186907] dhdsdio_probe_init: bus module (through bcmsdh API) does not 
support chaining
<4>[ 4156.187148] dhdsdio_probe: disable SDIO interrupts (not interested yet)
<4>[ 4156.188322] dhdsdio_probe: registered SDIO interrupt function ok
<4>[ 4156.188535] dhdsdio_probe: completed!!
<4>[ 4156.188671] dhd_bus_start: 
<4>[ 4156.188796] dhdsdio_clkctl: Enter
<4>[ 4156.188920] dhdsdio_htclk: Enter
<4>[ 4156.189254] CLKCTL: turned ON
<4>[ 4156.189400] dhdsdio_clkctl: 1 -> 3
<4>[ 4156.191048] dhdsdio_membytes: write 4 bytes at offset 0x00007ffc in 
window 0x00058000
<4>[ 4156.191724] dhdsdio_download_code_file: download firmware 
/system/etc/rtecdc.bin
<4>[ 4156.192406] dhdsdio_membytes: write 2048 bytes at offset 0x00000000 in 
window 0x00000000
<4>[ 4156.193548] dhdsdio_membytes: write 2048 bytes at offset 0x00000800 in 
window 0x00000000
<4>[ 4156.194878] dhdsdio_membytes: write 2048 bytes at offset 0x00001000 in 
window 0x00000000
<4>[ 4156.196052] dhdsdio_membytes: write 2048 bytes at offset 0x00001800 in 
window 0x00000000
<4>[ 4156.197215] dhdsdio_membytes: write 2048 bytes at offset 0x00002000 in 
window 0x00000000
<4>[ 4156.198379] dhdsdio_membytes: write 2048 bytes at offset 0x00002800 in 
window 0x00000000
<4>[ 4156.199544] dhdsdio_membytes: write 2048 bytes at offset 0x00003000 in 
window 0x00000000
<4>[ 4156.200735] dhdsdio_membytes: write 2048 bytes at offset 0x00003800 in 
window 0x00000000
<4>[ 4156.201872] dhdsdio_membytes: write 2048 bytes at offset 0x00004000 in 
window 0x00000000
<4>[ 4156.203005] dhdsdio_membytes: write 2048 bytes at offset 0x00004800 in 
window 0x00000000
<4>[ 4156.204223] dhdsdio_membytes: write 2048 bytes at offset 0x00005000 in 
window 0x00000000
<4>[ 4156.214575] dhdsdio_membytes: write 2048 bytes at offset 0x00005800 in 
window 0x00000000
<4>[ 4156.215794] dhdsdio_membytes: write 2048 bytes at offset 0x00006000 in 
window 0x00000000
<4>[ 4156.218300] dhdsdio_membytes: write 2048 bytes at offset 0x00006800 in 
window 0x00000000
<4>[ 4156.219509] dhdsdio_membytes: write 2048 bytes at offset 0x00007000 in 
window 0x00000000
<4>[ 4156.225120] dhdsdio_membytes: write 2048 bytes at offset 0x00007800 in 
window 0x00000000
<4>[ 4156.226394] dhdsdio_membytes: write 2048 bytes at offset 0x00000000 in 
window 0x00008000
<4>[ 4156.227551] dhdsdio_membytes: write 2048 bytes at offset 0x00000800 in 
window 0x00008000
<4>[ 4156.234642] dhdsdio_membytes: write 2048 bytes at offset 0x00001000 in 
window 0x00008000
<4>[ 4156.235885] dhdsdio_membytes: write 2048 bytes at offset 0x00001800 in 
window 0x00008000
<4>[ 4156.237123] dhdsdio_membytes: write 2048 bytes at offset 0x00002000 in 
window 0x00008000
<4>[ 4156.238291] dhdsdio_membytes: write 2048 bytes at offset 0x00002800 in 
window 0x00008000
<4>[ 4156.245051] dhdsdio_membytes: write 2048 bytes at offset 0x00003000 in 
window 0x00008000
<4>[ 4156.246308] dhdsdio_membytes: write 2048 bytes at offset 0x00003800 in 
window 0x00008000
<4>[ 4156.247553] dhdsdio_membytes: write 2048 bytes at offset 0x00004000 in 
window 0x00008000
<4>[ 4156.248749] dhdsdio_membytes: write 2048 bytes at offset 0x00004800 in 
window 0x00008000
<4>[ 4156.252665] dhdsdio_membytes: write 2048 bytes at offset 0x00005000 in 
window 0x00008000
<4>[ 4156.259589] dhdsdio_membytes: write 2048 bytes at offset 0x00005800 in 
window 0x00008000
<4>[ 4156.265539] dhdsdio_membytes: write 2048 bytes at offset 0x00006000 in 
window 0x00008000
<4>[ 4156.271255] dhdsdio_membytes: write 2048 bytes at offset 0x00006800 in 
window 0x00008000
<4>[ 4156.276960] dhdsdio_membytes: write 2048 bytes at offset 0x00007000 in 
window 0x00008000
<4>[ 4156.283186] dhdsdio_membytes: write 2048 bytes at offset 0x00007800 in 
window 0x00008000
<4>[ 4156.287728] dhdsdio_membytes: write 2048 bytes at offset 0x00000000 in 
window 0x00010000
<4>[ 4156.289429] dhdsdio_membytes: write 2048 bytes at offset 0x00000800 in 
window 0x00010000
<4>[ 4156.290640] dhdsdio_membytes: write 2048 bytes at offset 0x00001000 in 
window 0x00010000
<4>[ 4156.291828] dhdsdio_membytes: write 2048 bytes at offset 0x00001800 in 
window 0x00010000
<4>[ 4156.293018] dhdsdio_membytes: write 2048 bytes at offset 0x00002000 in 
window 0x00010000
<4>[ 4156.294213] dhdsdio_membytes: write 2048 bytes at offset 0x00002800 in 
window 0x00010000
<4>[ 4156.295616] dhdsdio_membytes: write 2048 bytes at offset 0x00003000 in 
window 0x00010000
<4>[ 4156.296755] dhdsdio_membytes: write 2048 bytes at offset 0x00003800 in 
window 0x00010000
<4>[ 4156.297880] dhdsdio_membytes: write 2048 bytes at offset 0x00004000 in 
window 0x00010000
<4>[ 4156.299078] dhdsdio_membytes: write 2048 bytes at offset 0x00004800 in 
window 0x00010000
<4>[ 4156.300212] dhdsdio_membytes: write 2048 bytes at offset 0x00005000 in 
window 0x00010000
<4>[ 4156.301375] dhdsdio_membytes: write 2048 bytes at offset 0x00005800 in 
window 0x00010000
<4>[ 4156.302532] dhdsdio_membytes: write 2048 bytes at offset 0x00006000 in 
window 0x00010000
<4>[ 4156.303698] dhdsdio_membytes: write 2048 bytes at offset 0x00006800 in 
window 0x00010000
<4>[ 4156.305036] dhdsdio_membytes: write 2048 bytes at offset 0x00007000 in 
window 0x00010000
<4>[ 4156.306174] dhdsdio_membytes: write 2048 bytes at offset 0x00007800 in 
window 0x00010000
<4>[ 4156.307378] dhdsdio_membytes: write 2048 bytes at offset 0x00000000 in 
window 0x00018000
<4>[ 4156.308508] dhdsdio_membytes: write 2048 bytes at offset 0x00000800 in 
window 0x00018000
<4>[ 4156.309731] dhdsdio_membytes: write 2048 bytes at offset 0x00001000 in 
window 0x00018000
<4>[ 4156.310920] dhdsdio_membytes: write 2048 bytes at offset 0x00001800 in 
window 0x00018000
<4>[ 4156.312099] dhdsdio_membytes: write 2048 bytes at offset 0x00002000 in 
window 0x00018000
<4>[ 4156.313272] dhdsdio_membytes: write 2048 bytes at offset 0x00002800 in 
window 0x00018000
<4>[ 4156.314530] dhdsdio_membytes: write 2048 bytes at offset 0x00003000 in 
window 0x00018000
<4>[ 4156.315742] dhdsdio_membytes: write 2048 bytes at offset 0x00003800 in 
window 0x00018000
<4>[ 4156.316867] dhdsdio_membytes: write 2048 bytes at offset 0x00004000 in 
window 0x00018000
<4>[ 4156.318030] dhdsdio_membytes: write 2048 bytes at offset 0x00004800 in 
window 0x00018000
<4>[ 4156.319286] dhdsdio_membytes: write 2048 bytes at offset 0x00005000 in 
window 0x00018000
<4>[ 4156.320520] dhdsdio_membytes: write 2048 bytes at offset 0x00005800 in 
window 0x00018000
<4>[ 4156.321679] dhdsdio_membytes: write 2048 bytes at offset 0x00006000 in 
window 0x00018000
<4>[ 4156.322867] dhdsdio_membytes: write 2048 bytes at offset 0x00006800 in 
window 0x00018000
<4>[ 4156.324027] dhdsdio_membytes: write 2048 bytes at offset 0x00007000 in 
window 0x00018000
<4>[ 4156.325350] dhdsdio_membytes: write 2048 bytes at offset 0x00007800 in 
window 0x00018000
<4>[ 4156.326557] dhdsdio_membytes: write 2048 bytes at offset 0x00000000 in 
window 0x00020000
<4>[ 4156.327695] dhdsdio_membytes: write 2048 bytes at offset 0x00000800 in 
window 0x00020000
<4>[ 4156.328922] dhdsdio_membytes: write 2048 bytes at offset 0x00001000 in 
window 0x00020000
<4>[ 4156.334757] dhdsdio_membytes: write 2048 bytes at offset 0x00001800 in 
window 0x00020000
<4>[ 4156.341761] dhdsdio_membytes: write 2048 bytes at offset 0x00002000 in 
window 0x00020000
<4>[ 4156.343051] dhdsdio_membytes: write 2048 bytes at offset 0x00002800 in 
window 0x00020000
<4>[ 4156.344447] dhdsdio_membytes: write 2048 bytes at offset 0x00003000 in 
window 0x00020000
<4>[ 4156.345697] dhdsdio_membytes: write 2048 bytes at offset 0x00003800 in 
window 0x00020000
<4>[ 4156.355155] dhdsdio_membytes: write 2048 bytes at offset 0x00004000 in 
window 0x00020000
<4>[ 4156.356444] dhdsdio_membytes: write 2048 bytes at offset 0x00004800 in 
window 0x00020000
<4>[ 4156.357767] dhdsdio_membytes: write 2048 bytes at offset 0x00005000 in 
window 0x00020000
<4>[ 4156.365084] dhdsdio_membytes: write 2048 bytes at offset 0x00005800 in 
window 0x00020000
<4>[ 4156.366284] dhdsdio_membytes: write 2048 bytes at offset 0x00006000 in 
window 0x00020000
<4>[ 4156.367458] dhdsdio_membytes: write 2048 bytes at offset 0x00006800 in 
window 0x00020000
<4>[ 4156.368668] dhdsdio_membytes: write 2048 bytes at offset 0x00007000 in 
window 0x00020000
<4>[ 4156.374539] dhdsdio_membytes: write 2048 bytes at offset 0x00007800 in 
window 0x00020000
<4>[ 4156.377132] dhdsdio_membytes: write 2048 bytes at offset 0x00000000 in 
window 0x00028000
<4>[ 4156.379732] dhdsdio_membytes: write 2048 bytes at offset 0x00000800 in 
window 0x00028000
<4>[ 4156.382371] dhdsdio_membytes: write 2048 bytes at offset 0x00001000 in 
window 0x00028000
<4>[ 4156.388553] dhdsdio_membytes: write 2048 bytes at offset 0x00001800 in 
window 0x00028000
<4>[ 4156.394177] dhdsdio_membytes: write 2048 bytes at offset 0x00002000 in 
window 0x00028000
<4>[ 4156.400299] dhdsdio_membytes: write 2048 bytes at offset 0x00002800 in 
window 0x00028000
<4>[ 4156.406060] dhdsdio_membytes: write 2048 bytes at offset 0x00003000 in 
window 0x00028000
<4>[ 4156.411582] dhdsdio_membytes: write 2048 bytes at offset 0x00003800 in 
window 0x00028000
<4>[ 4156.416122] dhdsdio_membytes: write 2048 bytes at offset 0x00004000 in 
window 0x00028000
<4>[ 4156.419581] dhdsdio_membytes: write 2048 bytes at offset 0x00004800 in 
window 0x00028000
<4>[ 4156.421266] dhdsdio_membytes: write 2048 bytes at offset 0x00005000 in 
window 0x00028000
<4>[ 4156.422451] dhdsdio_membytes: write 2048 bytes at offset 0x00005800 in 
window 0x00028000
<4>[ 4156.423650] dhdsdio_membytes: write 2048 bytes at offset 0x00006000 in 
window 0x00028000
<4>[ 4156.425117] dhdsdio_membytes: write 2048 bytes at offset 0x00006800 in 
window 0x00028000
<4>[ 4156.426250] dhdsdio_membytes: write 2048 bytes at offset 0x00007000 in 
window 0x00028000
<4>[ 4156.427381] dhdsdio_membytes: write 2048 bytes at offset 0x00007800 in 
window 0x00028000
<4>[ 4156.428507] dhdsdio_membytes: write 2048 bytes at offset 0x00000000 in 
window 0x00030000
<4>[ 4156.429656] dhdsdio_membytes: write 2048 bytes at offset 0x00000800 in 
window 0x00030000
<4>[ 4156.430848] dhdsdio_membytes: write 2048 bytes at offset 0x00001000 in 
window 0x00030000
<4>[ 4156.432013] dhdsdio_membytes: write 2048 bytes at offset 0x00001800 in 
window 0x00030000
<4>[ 4156.433142] dhdsdio_membytes: write 2048 bytes at offset 0x00002000 in 
window 0x00030000
<4>[ 4156.434453] dhdsdio_membytes: write 2048 bytes at offset 0x00002800 in 
window 0x00030000
<4>[ 4156.435608] dhdsdio_membytes: write 2048 bytes at offset 0x00003000 in 
window 0x00030000
<4>[ 4156.436774] dhdsdio_membytes: write 2048 bytes at offset 0x00003800 in 
window 0x00030000
<4>[ 4156.437971] dhdsdio_membytes: write 2048 bytes at offset 0x00004000 in 
window 0x00030000
<4>[ 4156.439136] dhdsdio_membytes: write 2048 bytes at offset 0x00004800 in 
window 0x00030000
<4>[ 4156.440298] dhdsdio_membytes: write 2048 bytes at offset 0x00005000 in 
window 0x00030000
<4>[ 4156.441459] dhdsdio_membytes: write 2048 bytes at offset 0x00005800 in 
window 0x00030000
<4>[ 4156.442593] dhdsdio_membytes: write 2048 bytes at offset 0x00006000 in 
window 0x00030000
<4>[ 4156.443800] dhdsdio_membytes: write 2048 bytes at offset 0x00006800 in 
window 0x00030000
<4>[ 4156.445026] dhdsdio_membytes: write 2048 bytes at offset 0x00007000 in 
window 0x00030000
<4>[ 4156.446225] dhdsdio_membytes: write 2048 bytes at offset 0x00007800 in 
window 0x00030000
<4>[ 4156.447433] dhdsdio_membytes: write 2048 bytes at offset 0x00000000 in 
window 0x00038000
<4>[ 4156.448588] dhdsdio_membytes: write 2048 bytes at offset 0x00000800 in 
window 0x00038000
<4>[ 4156.449811] dhdsdio_membytes: write 2048 bytes at offset 0x00001000 in 
window 0x00038000
<4>[ 4156.450981] dhdsdio_membytes: write 2048 bytes at offset 0x00001800 in 
window 0x00038000
<4>[ 4156.452176] dhdsdio_membytes: write 2048 bytes at offset 0x00002000 in 
window 0x00038000
<4>[ 4156.453363] dhdsdio_membytes: write 2048 bytes at offset 0x00002800 in 
window 0x00038000
<4>[ 4156.454672] dhdsdio_membytes: write 2048 bytes at offset 0x00003000 in 
window 0x00038000
<4>[ 4156.455872] dhdsdio_membytes: write 2048 bytes at offset 0x00003800 in 
window 0x00038000
<4>[ 4156.457045] dhdsdio_membytes: write 2048 bytes at offset 0x00004000 in 
window 0x00038000
<4>[ 4156.458279] dhdsdio_membytes: write 2048 bytes at offset 0x00004800 in 
window 0x00038000
<4>[ 4156.459485] dhdsdio_membytes: write 2048 bytes at offset 0x00005000 in 
window 0x00038000
<4>[ 4156.464472] dhdsdio_membytes: write 2048 bytes at offset 0x00005800 in 
window 0x00038000
<4>[ 4156.475316] dhdsdio_membytes: write 2048 bytes at offset 0x00006000 in 
window 0x00038000
<4>[ 4156.476521] dhdsdio_membytes: write 2048 bytes at offset 0x00006800 in 
window 0x00038000
<4>[ 4156.477752] dhdsdio_membytes: write 2048 bytes at offset 0x00007000 in 
window 0x00038000
<4>[ 4156.484896] dhdsdio_membytes: write 2048 bytes at offset 0x00007800 in 
window 0x00038000
<4>[ 4156.486149] dhdsdio_membytes: write 2048 bytes at offset 0x00000000 in 
window 0x00040000
<4>[ 4156.487386] dhdsdio_membytes: write 2048 bytes at offset 0x00000800 in 
window 0x00040000
<4>[ 4156.494564] dhdsdio_membytes: write 2048 bytes at offset 0x00001000 in 
window 0x00040000
<4>[ 4156.495807] dhdsdio_membytes: write 2048 bytes at offset 0x00001800 in 
window 0x00040000
<4>[ 4156.497002] dhdsdio_membytes: write 2048 bytes at offset 0x00002000 in 
window 0x00040000
<4>[ 4156.498201] dhdsdio_membytes: write 2048 bytes at offset 0x00002800 in 
window 0x00040000
<4>[ 4156.503622] dhdsdio_membytes: write 2048 bytes at offset 0x00003000 in 
window 0x00040000
<4>[ 4156.506384] dhdsdio_membytes: write 2048 bytes at offset 0x00003800 in 
window 0x00040000
<4>[ 4156.509075] dhdsdio_membytes: write 2048 bytes at offset 0x00004000 in 
window 0x00040000
<4>[ 4156.512418] dhdsdio_membytes: write 2048 bytes at offset 0x00004800 in 
window 0x00040000
<4>[ 4156.517881] dhdsdio_membytes: write 2048 bytes at offset 0x00005000 in 
window 0x00040000
<4>[ 4156.523353] dhdsdio_membytes: write 2048 bytes at offset 0x00005800 in 
window 0x00040000
<4>[ 4156.528876] dhdsdio_membytes: write 2048 bytes at offset 0x00006000 in 
window 0x00040000
<4>[ 4156.534965] dhdsdio_membytes: write 1472 bytes at offset 0x00006800 in 
window 0x00040000
<4>[ 4156.538573] dhdsdio_downloadvars: Enter
<4>[ 4156.542879] dhdsdio_membytes: write 304 bytes at offset 0x00007ecc in 
window 0x00058000
<4>[ 4156.546787] Compare NVRAM dl & ul; varsize=304
<4>[ 4156.547676] dhdsdio_membytes: read 304 bytes at offset 0x00007ecc in 
window 0x00058000
<4>[ 4156.549168] dhdsdio_write_vars: Download, Upload and compare of NVRAM 
succeeded.
<4>[ 4156.549445] Physical memory size: 393216, usable memory size: 393216
<4>[ 4156.549635] Vars are at 392908, orig varsize is 304
<4>[ 4156.549795] New varsize is 304, length token=0xffb3004c
<4>[ 4156.550216] dhdsdio_membytes: write 4 bytes at offset 0x00007ffc in 
window 0x00058000
<4>[ 4156.551836] dhdsdio_clkctl: Enter
<4>[ 4156.551987] dhdsdio_htclk: Enter
<4>[ 4156.552202] CLKCTL: turned OFF
<4>[ 4156.552350] dhdsdio_clkctl: 3 -> 1
<4>[ 4156.552495] dhd_bus_init: Enter
<4>[ 4156.552616] dhdsdio_clkctl: Enter
<4>[ 4156.552735] dhdsdio_htclk: Enter
<4>[ 4156.574459] CLKCTL: turned ON
<4>[ 4156.574689] dhdsdio_clkctl: 1 -> 3
<4>[ 4156.624478] dhd_bus_init: enable 0x06, ready 0x06 (waited 8191us)
<4>[ 4156.624985] dhdsdio_isr: Enter
<4>[ 4156.625132] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.625290] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.625443] dhdsdio_dpc: Enter
<4>[ 4156.625732] dhd_bus_init: enable SDIO device interrupts
<4>[ 4156.626071] dhd_watchdog_thread:
<4>[ 4156.626213] dhd_bus_watchdog: Enter
<4>[ 4156.626342] dhdsdio_clkctl: Enter
<4>[ 4156.626465] dhdsdio_htclk: Enter
<4>[ 4156.626680] CLKCTL: turned OFF
<4>[ 4156.626812] dhdsdio_sdclk: Enter
<4>[ 4156.626941] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.627071] dhd_watchdog_thread:
<4>[ 4156.627189] dhd_bus_watchdog: Enter
<4>[ 4156.627344] dhdsdio_clkctl: Enter
<4>[ 4156.627471] dhdsdio_sdclk: Enter
<4>[ 4156.627592] dhdsdio_htclk: Enter
<4>[ 4156.627919] CLKCTL: turned ON
<4>[ 4156.628068] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.628443] dhdsdio_hostmail: Enter
<4>[ 4156.628823] Dongle ready, protocol version 4
<4>[ 4156.628976] Dongle reports CHIPACTIVE
<4>[ 4156.629108] dhdsdio_readframes: Enter
<4>[ 4156.629377] RxHdr:
<4>[ 4156.629555]   0000: 0c 00 f3 ff 00 01 00 0c 00 0c 00 00 
<4>[ 4156.629764] Rx Data:
<4>[ 4156.629935]   0000: 0c 00 f3 ff 00 01 00 0c 00 0c 00 00 
<4>[ 4156.630253] RxHdr:
<4>[ 4156.630431]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.630603] dhdsdio_readframes: processed 1 frames
<4>[ 4156.630952] dhdsdio_isr: Enter
<4>[ 4156.631094] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.631250] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.631413] dhdsdio_dpc: Enter
<4>[ 4156.631529] dhdsdio_clkctl: Enter
<4>[ 4156.631904] dhdsdio_hostmail: Enter
<4>[ 4156.632323] Dongle ready, protocol version 4
<4>[ 4156.632500] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 0
<4>[ 4156.632762] dhd_prot_init: Enter
<4>[ 4156.632899] dhdcdc_query_ioctl: Enter
<4>[ 4156.633040] dhdcdc_query_ioctl: cmd 262 len 128
<4>[ 4156.633188] dhdcdc_msg: Enter
<4>[ 4156.633311] dhd_bus_txctl: Enter
<4>[ 4156.633435] dhdsdio_clkctl: Enter
<4>[ 4156.633560] Tx Frame:
<4>[ 4156.633745]   0000: a8 00 57 ff ff 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.634007]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 80 00 00 00 
<4>[ 4156.634482]   0032: 00 00 01 00 00 00 00 00 63 75 72 5f 65 74 68 65 
<4>[ 4156.634773]   0048: 72 61 64 64 72 00 00 00 6c ef 25 bf 67 bd 03 ca 
<4>[ 4156.635043]   0064: 00 00 00 00 60 a7 76 c0 01 00 00 00 60 a7 76 c0 
<4>[ 4156.635308]   0080: 80 98 2f c6 01 00 00 00 60 a7 76 c0 00 00 00 00 
<4>[ 4156.635577]   0096: a8 40 26 c2 48 ce 77 c0 80 bc c2 c3 9c bd 03 ca 
<4>[ 4156.635844]   0112: 6c 55 19 c0 03 00 00 00 60 a7 76 c0 80 98 2f c6 
<4>[ 4156.636109]   0128: 13 01 00 80 ac bd 03 ca a4 55 19 c0 02 00 00 00 
<4>[ 4156.636373]   0144: 00 a0 03 ca 00 40 26 c2 10 d8 26 bf 00 00 00 00 
<4>[ 4156.636637]   0160: a8 40 26 c2 48 ce 77 c0 00 00 00 00 00 00 00 00 
<4>[ 4156.636895]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.644614] dhd_watchdog_thread:
<4>[ 4156.644801] dhd_bus_watchdog: Enter
<4>[ 4156.644940] dhdsdio_clkctl: Enter
<4>[ 4156.645064] dhdsdio_htclk: Enter
<4>[ 4156.645281] CLKCTL: turned OFF
<4>[ 4156.645414] dhdsdio_sdclk: Enter
<4>[ 4156.645543] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.645791] dhdsdio_isr: Enter
<4>[ 4156.645928] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.646084] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.646236] dhdsdio_dpc: Enter
<4>[ 4156.646351] dhdsdio_clkctl: Enter
<4>[ 4156.646470] dhdsdio_sdclk: Enter
<4>[ 4156.646587] dhdsdio_htclk: Enter
<4>[ 4156.646863] CLKCTL: turned ON
<4>[ 4156.647006] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.647373] dhdsdio_readframes: Enter
<4>[ 4156.647662] RxHdr:
<4>[ 4156.647843]   0000: 9c 00 63 ff 01 00 00 0c 00 0c 00 00 
<4>[ 4156.648013] dhdsdio_read_control: Enter
<4>[ 4156.648372] RxCtrl:
<4>[ 4156.648573]   0000: 9c 00 63 ff 01 00 00 0c 00 0c 00 00 06 01 00 00 
<4>[ 4156.648842]   0016: 80 00 00 00 00 00 01 00 00 00 00 00 00 26 37 82 
<4>[ 4156.649112]   0032: 86 b6 68 65 72 61 64 64 72 00 00 00 6c ef 25 bf 
<4>[ 4156.649378]   0048: 67 bd 03 ca 00 00 00 00 60 a7 76 c0 01 00 00 00 
<4>[ 4156.649644]   0064: 60 a7 76 c0 80 98 2f c6 01 00 00 00 60 a7 76 c0 
<4>[ 4156.649910]   0080: 00 00 00 00 a8 40 26 c2 48 ce 77 c0 80 bc c2 c3 
<4>[ 4156.650175]   0096: 9c bd 03 ca 6c 55 19 c0 03 00 00 00 60 a7 76 c0 
<4>[ 4156.650442]   0112: 80 98 2f c6 13 01 00 80 ac bd 03 ca a4 55 19 c0 
<4>[ 4156.650706]   0128: 02 00 00 00 00 a0 03 ca 00 40 26 c2 10 d8 26 bf 
<4>[ 4156.650951]   0144: 00 00 00 00 a8 40 26 c2 48 ce 77 c0 
<4>[ 4156.651253] RxHdr:
<4>[ 4156.651429]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.651600] dhdsdio_readframes: processed 1 frames
<4>[ 4156.651763] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.652028] dhdcdc_cmplt: Enter
<4>[ 4156.652161] dhd_bus_rxctl: Enter
<4>[ 4156.652298] dhd_bus_rxctl: resumed on rxctl frame, got 144 expected 144
<4>[ 4156.652493] wifi_get_mac_addr
<4>[ 4156.652642] dhdcdc_set_ioctl: Enter
<4>[ 4156.652774] dhdcdc_set_ioctl: cmd 263 len 256
<4>[ 4156.652913] dhdcdc_msg: Enter
<4>[ 4156.653033] dhd_bus_txctl: Enter
<4>[ 4156.653155] dhdsdio_clkctl: Enter
<4>[ 4156.653280] Tx Frame:
<4>[ 4156.653462]   0000: 28 01 d7 fe 00 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.653724]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 00 01 00 00 
<4>[ 4156.653987]   0032: 02 00 02 00 00 00 00 00 61 73 73 6f 63 5f 6c 69 
<4>[ 4156.654439]   0048: 73 74 65 6e 00 0a 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.654722]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.654985]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.655246]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.655507]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.655766]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.656026]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.656284]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.656542]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.656800]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.657058]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.657317]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.657575]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.657833]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.658091]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.658349]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.658607]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.670746] dhdsdio_isr: Enter
<4>[ 4156.670904] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.671064] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.671220] dhdsdio_dpc: Enter
<4>[ 4156.671416] dhd_watchdog_thread:
<4>[ 4156.671554] dhd_bus_watchdog: Enter
<4>[ 4156.671683] dhdsdio_clkctl: Enter
<4>[ 4156.671802] dhdsdio_htclk: Enter
<4>[ 4156.672027] CLKCTL: turned OFF
<4>[ 4156.672161] dhdsdio_sdclk: Enter
<4>[ 4156.672292] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.672452] dhdsdio_clkctl: Enter
<4>[ 4156.672580] dhdsdio_sdclk: Enter
<4>[ 4156.672699] dhdsdio_htclk: Enter
<4>[ 4156.673030] CLKCTL: turned ON
<4>[ 4156.673180] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.673552] dhdsdio_readframes: Enter
<4>[ 4156.673843] RxHdr:
<4>[ 4156.674026]   0000: 1c 01 e3 fe 02 00 00 0c 00 0d 00 00 
<4>[ 4156.674196] dhdsdio_read_control: Enter
<4>[ 4156.674934] RxCtrl:
<4>[ 4156.675211]   0000: 1c 01 e3 fe 02 00 00 0c 00 0d 00 00 07 01 00 00 
<4>[ 4156.675493]   0016: 00 01 00 00 00 00 02 00 00 00 00 00 61 73 73 6f 
<4>[ 4156.675762]   0032: 63 5f 6c 69 73 74 65 6e 00 0a 00 00 00 00 00 00 
<4>[ 4156.676022]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.676282]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.676541]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.676801]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.677059]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.677317]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.677576]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.677835]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.678094]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.678352]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.678611]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.678869]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.679127]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.679385]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.679625]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.679936] RxHdr:
<4>[ 4156.680112]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.680285] dhdsdio_readframes: processed 1 frames
<4>[ 4156.680447] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.680677] dhd_watchdog_thread:
<4>[ 4156.680804] dhd_bus_watchdog: Enter
<4>[ 4156.680930] dhdsdio_clkctl: Enter
<4>[ 4156.681048] dhdsdio_htclk: Enter
<4>[ 4156.681267] CLKCTL: turned OFF
<4>[ 4156.681399] dhdsdio_sdclk: Enter
<4>[ 4156.681529] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.681936] dhdcdc_cmplt: Enter
<4>[ 4156.682082] dhd_bus_rxctl: Enter
<4>[ 4156.682227] dhd_bus_rxctl: resumed on rxctl frame, got 272 expected 272
<4>[ 4156.682436] dhdcdc_query_ioctl: Enter
<4>[ 4156.682571] dhdcdc_query_ioctl: cmd 262 len 128
<4>[ 4156.682717] dhdcdc_msg: Enter
<4>[ 4156.682839] dhd_bus_txctl: Enter
<4>[ 4156.682960] dhdsdio_clkctl: Enter
<4>[ 4156.683079] dhdsdio_sdclk: Enter
<4>[ 4156.683195] dhdsdio_htclk: Enter
<4>[ 4156.689196] dhdsdio_isr: Enter
<4>[ 4156.689353] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.689513] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.689668] dhdsdio_dpc: Enter
<4>[ 4156.690888] CLKCTL: turned ON
<4>[ 4156.691642] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.691794] Tx Frame:
<4>[ 4156.691984]   0000: a8 00 57 ff 01 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.692247]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 80 00 00 00 
<4>[ 4156.692508]   0032: 00 00 03 00 00 00 00 00 76 65 72 00 00 00 00 00 
<4>[ 4156.692767]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.693026]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.693284]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.693543]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.693802]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.694061]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.705127]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.705425]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.705692]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.710936] dhdsdio_clkctl: Enter
<4>[ 4156.711357] Dongle reports CHIPACTIVE
<4>[ 4156.711515] dhdsdio_readframes: Enter
<4>[ 4156.711791] RxHdr:
<4>[ 4156.711972]   0000: 9c 00 63 ff 03 00 00 0c 00 0e 00 00 
<4>[ 4156.712141] dhdsdio_read_control: Enter
<4>[ 4156.712500] RxCtrl:
<4>[ 4156.712700]   0000: 9c 00 63 ff 03 00 00 0c 00 0e 00 00 06 01 00 00 
<4>[ 4156.712971]   0016: 80 00 00 00 00 00 03 00 00 00 00 00 77 6c 30 3a 
<4>[ 4156.713241]   0032: 20 4e 6f 76 20 20 35 20 32 30 31 30 20 30 36 3a 
<4>[ 4156.713510]   0048: 34 33 3a 33 36 20 76 65 72 73 69 6f 6e 20 34 2e 
<4>[ 4156.713776]   0064: 32 31 37 2e 39 35 2e 30 0a 00 00 00 00 00 00 00 
<4>[ 4156.714035]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.714409]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.714688]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.714953]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.715195]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.715510] RxHdr:
<4>[ 4156.715685]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.715857] dhdsdio_readframes: processed 1 frames
<4>[ 4156.716018] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.716246] dhd_watchdog_thread:
<4>[ 4156.716376] dhd_bus_watchdog: Enter
<4>[ 4156.716501] dhdsdio_clkctl: Enter
<4>[ 4156.716621] dhdsdio_htclk: Enter
<4>[ 4156.716836] CLKCTL: turned OFF
<4>[ 4156.716969] dhdsdio_sdclk: Enter
<4>[ 4156.717100] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.717228] dhd_watchdog_thread:
<4>[ 4156.717347] dhd_bus_watchdog: Enter
<4>[ 4156.717696] dhdcdc_cmplt: Enter
<4>[ 4156.717839] dhd_bus_rxctl: Enter
<4>[ 4156.717982] dhd_bus_rxctl: resumed on rxctl frame, got 144 expected 144
<4>[ 4156.718193] Firmware version = wl0: Nov  5 2010 06:43:36 version 
4.217.95.0
<4>[ 4156.718390] dhdcdc_set_ioctl: Enter
<4>[ 4156.718519] dhdcdc_set_ioctl: cmd 86 len 4
<4>[ 4156.718653] dhdcdc_msg: Enter
<4>[ 4156.718771] dhd_bus_txctl: Enter
<4>[ 4156.718896] dhdsdio_clkctl: Enter
<4>[ 4156.719015] dhdsdio_sdclk: Enter
<4>[ 4156.719131] dhdsdio_htclk: Enter
<4>[ 4156.724772] dhdsdio_isr: Enter
<4>[ 4156.724930] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.725088] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.725243] dhdsdio_dpc: Enter
<4>[ 4156.727075] CLKCTL: turned ON
<4>[ 4156.727462] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.727612] Tx Frame:
<4>[ 4156.727801]   0000: 2c 00 d3 ff 02 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.728063]   0016: 00 00 00 00 00 00 00 00 56 00 00 00 04 00 00 00 
<4>[ 4156.728327]   0032: 02 00 04 00 00 00 00 00 02 00 00 00 20 4e 6f 76 
<4>[ 4156.728595]   0048: 20 20 35 20 32 30 31 30 20 30 36 3a 34 33 3a 33 
<4>[ 4156.729955] dhdsdio_clkctl: Enter
<4>[ 4156.730374] Dongle reports CHIPACTIVE
<4>[ 4156.730536] dhdsdio_readframes: Enter
<4>[ 4156.730814] RxHdr:
<4>[ 4156.730996]   0000: 20 00 df ff 04 00 00 0c 00 0f 00 00 
<4>[ 4156.731165] dhdsdio_read_control: Enter
<4>[ 4156.731298] RxCtrl:
<4>[ 4156.731477]   0000: 20 00 df ff 04 00 00 0c 00 0f 00 00 56 00 00 00 
<4>[ 4156.731740]   0016: 04 00 00 00 00 00 04 00 00 00 00 00 02 00 00 00 
<4>[ 4156.732067] RxHdr:
<4>[ 4156.732240]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.732411] dhdsdio_readframes: processed 1 frames
<4>[ 4156.732574] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.732838] dhdcdc_cmplt: Enter
<4>[ 4156.732972] dhd_bus_rxctl: Enter
<4>[ 4156.733110] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4156.733323] dhdcdc_set_ioctl: Enter
<4>[ 4156.733454] dhdcdc_set_ioctl: cmd 263 len 256
<4>[ 4156.733595] dhdcdc_msg: Enter
<4>[ 4156.733714] dhd_bus_txctl: Enter
<4>[ 4156.733834] dhdsdio_clkctl: Enter
<4>[ 4156.733959] Tx Frame:
<4>[ 4156.734140]   0000: 28 01 d7 fe 03 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.734715]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 00 01 00 00 
<4>[ 4156.735009]   0032: 02 00 05 00 00 00 00 00 62 75 73 3a 74 78 67 6c 
<4>[ 4156.735279]   0048: 6f 6d 61 6c 69 67 6e 00 20 00 00 00 00 00 00 00 
<4>[ 4156.735542]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.735803]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.736063]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.736322]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.736582]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.736842]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.737101]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.737360]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.737618]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.737877]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.738135]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.738393]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.738651]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.738909]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.739168]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.739426]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.740271] dhdsdio_isr: Enter
<4>[ 4156.740419] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.740578] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.740731] dhdsdio_dpc: Enter
<4>[ 4156.740914] dhd_watchdog_thread:
<4>[ 4156.741045] dhd_bus_watchdog: Enter
<4>[ 4156.741171] dhdsdio_clkctl: Enter
<4>[ 4156.741290] dhdsdio_htclk: Enter
<4>[ 4156.741511] CLKCTL: turned OFF
<4>[ 4156.741648] dhdsdio_sdclk: Enter
<4>[ 4156.741782] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.741944] dhdsdio_clkctl: Enter
<4>[ 4156.742075] dhdsdio_sdclk: Enter
<4>[ 4156.742196] dhdsdio_htclk: Enter
<4>[ 4156.742514] CLKCTL: turned ON
<4>[ 4156.742661] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.743028] dhdsdio_readframes: Enter
<4>[ 4156.743312] RxHdr:
<4>[ 4156.743494]   0000: 1c 01 e3 fe 05 00 00 0c 00 10 00 00 
<4>[ 4156.743661] dhdsdio_read_control: Enter
<4>[ 4156.744401] RxCtrl:
<4>[ 4156.744616]   0000: 1c 01 e3 fe 05 00 00 0c 00 10 00 00 07 01 00 00 
<4>[ 4156.744889]   0016: 00 01 00 00 00 00 05 00 00 00 00 00 62 75 73 3a 
<4>[ 4156.745158]   0032: 74 78 67 6c 6f 6d 61 6c 69 67 6e 00 20 00 00 00 
<4>[ 4156.745420]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.745682]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.745942]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.746200]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.746459]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.746718]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.746977]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.747237]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.747496]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.747755]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.748016]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.748275]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.748535]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.748794]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.749035]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.749350] RxHdr:
<4>[ 4156.749525]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.749698] dhdsdio_readframes: processed 1 frames
<4>[ 4156.749860] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.750087] dhd_watchdog_thread:
<4>[ 4156.750218] dhd_bus_watchdog: Enter
<4>[ 4156.750345] dhdsdio_clkctl: Enter
<4>[ 4156.750464] dhdsdio_htclk: Enter
<4>[ 4156.750682] CLKCTL: turned OFF
<4>[ 4156.750815] dhdsdio_sdclk: Enter
<4>[ 4156.750945] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.751211] dhdcdc_cmplt: Enter
<4>[ 4156.751347] dhd_bus_rxctl: Enter
<4>[ 4156.751491] dhd_bus_rxctl: resumed on rxctl frame, got 272 expected 272
<4>[ 4156.751710] dhdcdc_set_ioctl: Enter
<4>[ 4156.751842] dhdcdc_set_ioctl: cmd 263 len 256
<4>[ 4156.751984] dhdcdc_msg: Enter
<4>[ 4156.752106] dhd_bus_txctl: Enter
<4>[ 4156.752228] dhdsdio_clkctl: Enter
<4>[ 4156.752348] dhdsdio_sdclk: Enter
<4>[ 4156.752464] dhdsdio_htclk: Enter
<4>[ 4156.755578] dhdsdio_isr: Enter
<4>[ 4156.755731] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.755889] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.756044] dhdsdio_dpc: Enter
<4>[ 4156.764488] CLKCTL: turned ON
<4>[ 4156.764646] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.764776] Tx Frame:
<4>[ 4156.764961]   0000: 28 01 d7 fe 04 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.765223]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 00 01 00 00 
<4>[ 4156.765489]   0032: 02 00 06 00 00 00 00 00 62 75 73 3a 74 78 67 6c 
<4>[ 4156.765749]   0048: 6f 6d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.766007]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.766266]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.766525]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.766783]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.767041]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.767300]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.767558]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.767817]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.768075]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.768334]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.768593]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.768851]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.769109]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.769368]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.773329]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.773628]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.774749] dhdsdio_clkctl: Enter
<4>[ 4156.775153] Dongle reports CHIPACTIVE
<4>[ 4156.775310] dhdsdio_readframes: Enter
<4>[ 4156.775587] RxHdr:
<4>[ 4156.775767]   0000: 1c 01 e3 fe 06 00 00 0c 00 11 00 00 
<4>[ 4156.775939] dhdsdio_read_control: Enter
<4>[ 4156.776497] RxCtrl:
<4>[ 4156.776707]   0000: 1c 01 e3 fe 06 00 00 0c 00 11 00 00 07 01 00 00 
<4>[ 4156.776979]   0016: 00 01 00 00 00 00 06 00 00 00 00 00 62 75 73 3a 
<4>[ 4156.777244]   0032: 74 78 67 6c 6f 6d 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.777503]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.777763]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.778022]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.778279]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.778538]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.778796]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.779055]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.779314]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.779575]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.779835]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.780093]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.780351]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.780610]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.780869]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.781109]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.781419] RxHdr:
<4>[ 4156.781596]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.781766] dhdsdio_readframes: processed 1 frames
<4>[ 4156.781994] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.782234] dhd_watchdog_thread:
<4>[ 4156.782367] dhd_bus_watchdog: Enter
<4>[ 4156.782495] dhdsdio_clkctl: Enter
<4>[ 4156.782616] dhdsdio_htclk: Enter
<4>[ 4156.782834] CLKCTL: turned OFF
<4>[ 4156.782972] dhdsdio_sdclk: Enter
<4>[ 4156.783104] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.783514] dhdcdc_cmplt: Enter
<4>[ 4156.783660] dhd_bus_rxctl: Enter
<4>[ 4156.783804] dhd_bus_rxctl: resumed on rxctl frame, got 272 expected 272
<4>[ 4156.784023] dhdcdc_set_ioctl: Enter
<4>[ 4156.784155] dhdcdc_set_ioctl: cmd 263 len 256
<4>[ 4156.791090] dhdcdc_msg: Enter
<4>[ 4156.791256] dhd_bus_txctl: Enter
<4>[ 4156.791388] dhdsdio_clkctl: Enter
<4>[ 4156.791509] dhdsdio_sdclk: Enter
<4>[ 4156.791627] dhdsdio_htclk: Enter
<4>[ 4156.794742] dhdsdio_isr: Enter
<4>[ 4156.794901] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.795057] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.795212] dhdsdio_dpc: Enter
<4>[ 4156.804572] CLKCTL: turned ON
<4>[ 4156.804742] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.804872] Tx Frame:
<4>[ 4156.805056]   0000: 28 01 d7 fe 05 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.805319]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 00 01 00 00 
<4>[ 4156.805584]   0032: 02 00 07 00 00 00 00 00 62 63 6e 5f 74 69 6d 65 
<4>[ 4156.805846]   0048: 6f 75 74 00 04 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.806105]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.806365]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.806624]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.806883]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.807141]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.807400]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.807659]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.807918]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.808177]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.808436]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.808695]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.808954]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.809213]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.809472]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.809730]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.809988]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.815002] dhdsdio_clkctl: Enter
<4>[ 4156.815414] Dongle reports CHIPACTIVE
<4>[ 4156.815573] dhdsdio_readframes: Enter
<4>[ 4156.815849] RxHdr:
<4>[ 4156.816030]   0000: 1c 01 e3 fe 07 00 00 0c 00 12 00 00 
<4>[ 4156.816198] dhdsdio_read_control: Enter
<4>[ 4156.816761] RxCtrl:
<4>[ 4156.816967]   0000: 1c 01 e3 fe 07 00 00 0c 00 12 00 00 07 01 00 00 
<4>[ 4156.817238]   0016: 00 01 00 00 00 00 07 00 00 00 00 00 62 63 6e 5f 
<4>[ 4156.817505]   0032: 74 69 6d 65 6f 75 74 00 04 00 00 00 00 00 00 00 
<4>[ 4156.817766]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.818026]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.818284]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.818545]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.818804]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.819064]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.819323]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.819582]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.819841]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.820100]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.820359]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.820618]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.820877]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.821135]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.821375]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.821681] RxHdr:
<4>[ 4156.821862]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.822033] dhdsdio_readframes: processed 1 frames
<4>[ 4156.822196] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.822422] dhd_watchdog_thread:
<4>[ 4156.822553] dhd_bus_watchdog: Enter
<4>[ 4156.822679] dhdsdio_clkctl: Enter
<4>[ 4156.822800] dhdsdio_htclk: Enter
<4>[ 4156.823020] CLKCTL: turned OFF
<4>[ 4156.823156] dhdsdio_sdclk: Enter
<4>[ 4156.823288] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.823508] dhdcdc_cmplt: Enter
<4>[ 4156.823641] dhd_bus_rxctl: Enter
<4>[ 4156.823783] dhd_bus_rxctl: resumed on rxctl frame, got 272 expected 272
<4>[ 4156.824001] dhdcdc_set_ioctl: Enter
<4>[ 4156.824132] dhdcdc_set_ioctl: cmd 263 len 256
<4>[ 4156.824381] dhdcdc_msg: Enter
<4>[ 4156.824522] dhd_bus_txctl: Enter
<4>[ 4156.824648] dhdsdio_clkctl: Enter
<4>[ 4156.824769] dhdsdio_sdclk: Enter
<4>[ 4156.824885] dhdsdio_htclk: Enter
<4>[ 4156.828089] dhdsdio_isr: Enter
<4>[ 4156.828242] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.828396] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.828549] dhdsdio_dpc: Enter
<4>[ 4156.828834] CLKCTL: turned ON
<4>[ 4156.828981] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.829110] Tx Frame:
<4>[ 4156.829293]   0000: 28 01 d7 fe 06 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.829555]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 00 01 00 00 
<4>[ 4156.829819]   0032: 02 00 08 00 00 00 00 00 72 6f 61 6d 5f 6f 66 66 
<4>[ 4156.830078]   0048: 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.830338]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.830596]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.830855]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.831113]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.831372]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.831631]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.831890]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.832148]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.832407]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.832667]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.832926]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.833185]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.833445]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.833704]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.833962]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.834221]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.845832] dhdsdio_clkctl: Enter
<4>[ 4156.846240] Dongle reports CHIPACTIVE
<4>[ 4156.846398] dhdsdio_readframes: Enter
<4>[ 4156.846675] RxHdr:
<4>[ 4156.846856]   0000: 1c 01 e3 fe 08 00 00 0c 00 13 00 00 
<4>[ 4156.847025] dhdsdio_read_control: Enter
<4>[ 4156.847574] RxCtrl:
<4>[ 4156.847781]   0000: 1c 01 e3 fe 08 00 00 0c 00 13 00 00 07 01 00 00 
<4>[ 4156.848051]   0016: 00 01 00 00 00 00 08 00 00 00 00 00 72 6f 61 6d 
<4>[ 4156.848317]   0032: 5f 6f 66 66 00 01 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.848578]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.848840]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.849100]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.849360]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.849619]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.849877]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.850136]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.850396]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.850654]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.850913]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.851172]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.851431]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.851691]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.851950]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.852191]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.852499] RxHdr:
<4>[ 4156.852675]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.852848] dhdsdio_readframes: processed 1 frames
<4>[ 4156.853011] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.853237] dhd_watchdog_thread:
<4>[ 4156.853367] dhd_bus_watchdog: Enter
<4>[ 4156.853492] dhdsdio_clkctl: Enter
<4>[ 4156.853611] dhdsdio_htclk: Enter
<4>[ 4156.853827] CLKCTL: turned OFF
<4>[ 4156.853964] dhdsdio_sdclk: Enter
<4>[ 4156.854093] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.854415] dhdcdc_cmplt: Enter
<4>[ 4156.854561] dhd_bus_rxctl: Enter
<4>[ 4156.854705] dhd_bus_rxctl: resumed on rxctl frame, got 272 expected 272
<4>[ 4156.854899] dhdcdc_set_ioctl: Enter
<4>[ 4156.855032] dhdcdc_set_ioctl: cmd 2 len 4
<4>[ 4156.855167] dhdcdc_msg: Enter
<4>[ 4156.855287] dhd_bus_txctl: Enter
<4>[ 4156.855407] dhdsdio_clkctl: Enter
<4>[ 4156.855525] dhdsdio_sdclk: Enter
<4>[ 4156.855641] dhdsdio_htclk: Enter
<4>[ 4156.858800] dhdsdio_isr: Enter
<4>[ 4156.858959] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.859119] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.859273] dhdsdio_dpc: Enter
<4>[ 4156.864557] CLKCTL: turned ON
<4>[ 4156.864728] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.864859] Tx Frame:
<4>[ 4156.865042]   0000: 2c 00 d3 ff 07 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.865302]   0016: 00 00 00 00 00 00 00 00 02 00 00 00 04 00 00 00 
<4>[ 4156.865564]   0032: 02 00 09 00 00 00 00 00 00 00 00 00 5f 6f 66 66 
<4>[ 4156.865823]   0048: 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.866230] dhdsdio_clkctl: Enter
<4>[ 4156.866615] Dongle reports CHIPACTIVE
<4>[ 4156.866784] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 0
<4>[ 4156.867048] dhdcdc_cmplt: Enter
<4>[ 4156.867180] dhd_bus_rxctl: Enter
<4>[ 4156.874397] dhd_watchdog_thread:
<4>[ 4156.874558] dhd_bus_watchdog: Enter
<4>[ 4156.874689] dhdsdio_clkctl: Enter
<4>[ 4156.874809] dhdsdio_htclk: Enter
<4>[ 4156.875034] CLKCTL: turned OFF
<4>[ 4156.875168] dhdsdio_sdclk: Enter
<4>[ 4156.875299] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.933355] dhdsdio_isr: Enter
<4>[ 4156.933511] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.933670] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.933835] dhdsdio_dpc: Enter
<4>[ 4156.933955] dhdsdio_clkctl: Enter
<4>[ 4156.934078] dhdsdio_sdclk: Enter
<4>[ 4156.934196] dhdsdio_htclk: Enter
<4>[ 4156.934593] CLKCTL: turned ON
<4>[ 4156.934746] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.935123] dhdsdio_readframes: Enter
<4>[ 4156.935412] RxHdr:
<4>[ 4156.935593]   0000: 20 00 df ff 09 00 00 0c 00 14 00 00 
<4>[ 4156.935763] dhdsdio_read_control: Enter
<4>[ 4156.935897] RxCtrl:
<4>[ 4156.936075]   0000: 20 00 df ff 09 00 00 0c 00 14 00 00 02 00 00 00 
<4>[ 4156.936337]   0016: 04 00 00 00 00 00 09 00 00 00 00 00 00 00 00 00 
<4>[ 4156.936689] RxHdr:
<4>[ 4156.936865]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.937037] dhdsdio_readframes: processed 1 frames
<4>[ 4156.937199] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.937504] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4156.937736] dhdcdc_query_ioctl: Enter
<4>[ 4156.937876] dhdcdc_query_ioctl: cmd 262 len 256
<4>[ 4156.938024] dhdcdc_msg: Enter
<4>[ 4156.938147] dhd_bus_txctl: Enter
<4>[ 4156.938269] dhdsdio_clkctl: Enter
<4>[ 4156.938394] Tx Frame:
<4>[ 4156.938578]   0000: 28 01 d7 fe 08 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.938839]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 00 01 00 00 
<4>[ 4156.939103]   0032: 00 00 0a 00 00 00 00 00 65 76 65 6e 74 5f 6d 73 
<4>[ 4156.939367]   0048: 67 73 00 08 a0 75 c0 00 00 00 00 a8 40 26 c2 00 
<4>[ 4156.939626]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.939885]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.940143]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.940403]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.940662]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.940921]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.941179]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.941437]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.941696]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.941954]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.942212]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.942470]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.942728]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.942988]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.943245]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.943503]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.974962] dhdsdio_isr: Enter
<4>[ 4156.975121] dhdsdio_isr: disable SDIO interrupts
<4>[ 4156.975281] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4156.975436] dhdsdio_dpc: Enter
<4>[ 4156.975772] dhd_watchdog_thread:
<4>[ 4156.975916] dhd_bus_watchdog: Enter
<4>[ 4156.976045] dhdsdio_clkctl: Enter
<4>[ 4156.976165] dhdsdio_htclk: Enter
<4>[ 4156.976395] CLKCTL: turned OFF
<4>[ 4156.976531] dhdsdio_sdclk: Enter
<4>[ 4156.976663] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.976825] dhdsdio_clkctl: Enter
<4>[ 4156.976955] dhdsdio_sdclk: Enter
<4>[ 4156.977075] dhdsdio_htclk: Enter
<4>[ 4156.977403] CLKCTL: turned ON
<4>[ 4156.977553] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.977933] dhdsdio_readframes: Enter
<4>[ 4156.978225] RxHdr:
<4>[ 4156.978405]   0000: 1c 01 e3 fe 0a 00 00 0c 00 15 00 00 
<4>[ 4156.978574] dhdsdio_read_control: Enter
<4>[ 4156.979129] RxCtrl:
<4>[ 4156.979336]   0000: 1c 01 e3 fe 0a 00 00 0c 00 15 00 00 06 01 00 00 
<4>[ 4156.979602]   0016: 00 01 00 00 00 00 0a 00 00 00 00 00 00 00 00 00 
<4>[ 4156.979866]   0032: 00 00 40 00 00 00 00 08 a0 75 c0 00 00 00 00 a8 
<4>[ 4156.980128]   0048: 40 26 c2 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.980388]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.980647]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.980906]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.981164]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.981424]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.981683]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.981942]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.982202]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.982460]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.982719]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.982978]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.983237]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.983496]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.983805]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.984132] RxHdr:
<4>[ 4156.984472]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4156.984664] dhdsdio_readframes: processed 1 frames
<4>[ 4156.984832] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4156.985057] dhd_watchdog_thread:
<4>[ 4156.985186] dhd_bus_watchdog: Enter
<4>[ 4156.985315] dhdsdio_clkctl: Enter
<4>[ 4156.985435] dhdsdio_htclk: Enter
<4>[ 4156.985655] CLKCTL: turned OFF
<4>[ 4156.985790] dhdsdio_sdclk: Enter
<4>[ 4156.985922] dhdsdio_clkctl: 3 -> 0
<4>[ 4156.987108] dhdcdc_cmplt: Enter
<4>[ 4156.987874] dhd_bus_rxctl: Enter
<4>[ 4156.988053] dhd_bus_rxctl: resumed on rxctl frame, got 272 expected 272
<4>[ 4156.988283] dhdcdc_set_ioctl: Enter
<4>[ 4156.988417] dhdcdc_set_ioctl: cmd 263 len 256
<4>[ 4156.988558] dhdcdc_msg: Enter
<4>[ 4156.988679] dhd_bus_txctl: Enter
<4>[ 4156.988802] dhdsdio_clkctl: Enter
<4>[ 4156.988922] dhdsdio_sdclk: Enter
<4>[ 4156.989038] dhdsdio_htclk: Enter
<4>[ 4156.998614] CLKCTL: turned ON
<4>[ 4156.998784] dhdsdio_clkctl: 0 -> 3
<4>[ 4156.998917] Tx Frame:
<4>[ 4156.999103]   0000: 28 01 d7 fe 09 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4156.999366]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 00 01 00 00 
<4>[ 4156.999631]   0032: 02 00 0b 00 00 00 00 00 65 76 65 6e 74 5f 6d 73 
<4>[ 4156.999896]   0048: 67 73 00 4b 1f b7 04 10 40 40 00 00 00 00 08 a0 
<4>[ 4157.000157]   0064: 75 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.000415]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.000673]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.000931]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.001190]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.001447]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.001705]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.001962]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.002220]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.002478]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.002735]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.002992]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.003251]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.003509]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.003767]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.004024]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.084711] dhd_watchdog_thread:
<4>[ 4157.084901] dhd_bus_watchdog: Enter
<4>[ 4157.085039] dhdsdio_clkctl: Enter
<4>[ 4157.085159] dhdsdio_htclk: Enter
<4>[ 4157.085374] CLKCTL: turned OFF
<4>[ 4157.085508] dhdsdio_sdclk: Enter
<4>[ 4157.085638] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.085885] dhdsdio_isr: Enter
<4>[ 4157.086022] dhdsdio_isr: disable SDIO interrupts
<4>[ 4157.086178] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4157.086394] dhdsdio_dpc: Enter
<4>[ 4157.086525] dhdsdio_clkctl: Enter
<4>[ 4157.086648] dhdsdio_sdclk: Enter
<4>[ 4157.086767] dhdsdio_htclk: Enter
<4>[ 4157.087110] CLKCTL: turned ON
<4>[ 4157.087261] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.087631] dhdsdio_readframes: Enter
<4>[ 4157.087919] RxHdr:
<4>[ 4157.088099]   0000: 1c 01 e3 fe 0b 00 00 0c 00 16 00 00 
<4>[ 4157.088266] dhdsdio_read_control: Enter
<4>[ 4157.088874] RxCtrl:
<4>[ 4157.089076]   0000: 1c 01 e3 fe 0b 00 00 0c 00 16 00 00 07 01 00 00 
<4>[ 4157.089346]   0016: 00 01 00 00 00 00 0b 00 00 00 00 00 65 76 65 6e 
<4>[ 4157.089613]   0032: 74 5f 6d 73 67 73 00 4b 1f b7 04 10 40 40 00 00 
<4>[ 4157.089874]   0048: 00 00 08 a0 75 c0 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.090133]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.090391]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.090648]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.090906]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.091164]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.091423]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.091681]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.091940]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.092198]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.092456]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.092714]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.092972]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.093231]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.093470]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.093773] RxHdr:
<4>[ 4157.093949]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.094121] dhdsdio_readframes: processed 1 frames
<4>[ 4157.094463] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4157.094702] dhd_watchdog_thread:
<4>[ 4157.094833] dhd_bus_watchdog: Enter
<4>[ 4157.094961] dhdsdio_clkctl: Enter
<4>[ 4157.095081] dhdsdio_htclk: Enter
<4>[ 4157.095300] CLKCTL: turned OFF
<4>[ 4157.095433] dhdsdio_sdclk: Enter
<4>[ 4157.095563] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.096705] dhdcdc_cmplt: Enter
<4>[ 4157.097084] dhd_bus_rxctl: Enter
<4>[ 4157.097254] dhd_bus_rxctl: resumed on rxctl frame, got 272 expected 272
<4>[ 4157.097449] dhdcdc_set_ioctl: Enter
<4>[ 4157.097579] dhdcdc_set_ioctl: cmd 185 len 4
<4>[ 4157.097713] dhdcdc_msg: Enter
<4>[ 4157.097833] dhd_bus_txctl: Enter
<4>[ 4157.097954] dhdsdio_clkctl: Enter
<4>[ 4157.098074] dhdsdio_sdclk: Enter
<4>[ 4157.098189] dhdsdio_htclk: Enter
<4>[ 4157.105601] CLKCTL: turned ON
<4>[ 4157.105773] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.105906] Tx Frame:
<4>[ 4157.106092]   0000: 2c 00 d3 ff 0a 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4157.106356]   0016: 00 00 00 00 00 00 00 00 b9 00 00 00 04 00 00 00 
<4>[ 4157.106619]   0032: 02 00 0c 00 00 00 00 00 28 00 00 00 74 5f 6d 73 
<4>[ 4157.106884]   0048: 67 73 00 4b 1f b7 04 10 40 40 00 00 00 00 08 a0 
<4>[ 4157.110565] dhdsdio_isr: Enter
<4>[ 4157.110722] dhdsdio_isr: disable SDIO interrupts
<4>[ 4157.110882] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4157.111037] dhdsdio_dpc: Enter
<4>[ 4157.111230] dhdsdio_clkctl: Enter
<4>[ 4157.111632] dhdsdio_readframes: Enter
<4>[ 4157.111925] RxHdr:
<4>[ 4157.112107]   0000: 20 00 df ff 0c 00 00 0c 00 17 00 00 
<4>[ 4157.112273] dhdsdio_read_control: Enter
<4>[ 4157.112405] RxCtrl:
<4>[ 4157.112584]   0000: 20 00 df ff 0c 00 00 0c 00 17 00 00 b9 00 00 00 
<4>[ 4157.112846]   0016: 04 00 00 00 00 00 0c 00 00 00 00 00 28 00 00 00 
<4>[ 4157.113174] RxHdr:
<4>[ 4157.113351]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.113525] dhdsdio_readframes: processed 1 frames
<4>[ 4157.113687] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4157.113948] dhdcdc_cmplt: Enter
<4>[ 4157.114082] dhd_bus_rxctl: Enter
<4>[ 4157.114224] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4157.114579] dhd_watchdog_thread:
<4>[ 4157.114721] dhd_bus_watchdog: Enter
<4>[ 4157.114851] dhdsdio_clkctl: Enter
<4>[ 4157.114971] dhdsdio_htclk: Enter
<4>[ 4157.115190] CLKCTL: turned OFF
<4>[ 4157.115324] dhdsdio_sdclk: Enter
<4>[ 4157.115455] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.115755] dhdcdc_set_ioctl: Enter
<4>[ 4157.115914] dhdcdc_set_ioctl: cmd 187 len 4
<4>[ 4157.116055] dhdcdc_msg: Enter
<4>[ 4157.116178] dhd_bus_txctl: Enter
<4>[ 4157.116302] dhdsdio_clkctl: Enter
<4>[ 4157.116423] dhdsdio_sdclk: Enter
<4>[ 4157.116539] dhdsdio_htclk: Enter
<4>[ 4157.122927] CLKCTL: turned ON
<4>[ 4157.123096] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.123228] Tx Frame:
<4>[ 4157.123412]   0000: 2c 00 d3 ff 0b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4157.123676]   0016: 00 00 00 00 00 00 00 00 bb 00 00 00 04 00 00 00 
<4>[ 4157.123940]   0032: 02 00 0d 00 00 00 00 00 28 00 00 00 74 5f 6d 73 
<4>[ 4157.124205]   0048: 67 73 00 4b 1f b7 04 10 40 40 00 00 00 00 08 a0 
<4>[ 4157.134625] dhd_watchdog_thread:
<4>[ 4157.134785] dhd_bus_watchdog: Enter
<4>[ 4157.134920] dhdsdio_clkctl: Enter
<4>[ 4157.135043] dhdsdio_htclk: Enter
<4>[ 4157.135261] CLKCTL: turned OFF
<4>[ 4157.135396] dhdsdio_sdclk: Enter
<4>[ 4157.135528] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.135777] dhdsdio_isr: Enter
<4>[ 4157.135912] dhdsdio_isr: disable SDIO interrupts
<4>[ 4157.136067] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4157.136222] dhdsdio_dpc: Enter
<4>[ 4157.136338] dhdsdio_clkctl: Enter
<4>[ 4157.136457] dhdsdio_sdclk: Enter
<4>[ 4157.136574] dhdsdio_htclk: Enter
<4>[ 4157.136851] CLKCTL: turned ON
<4>[ 4157.136997] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.137365] dhdsdio_readframes: Enter
<4>[ 4157.137655] RxHdr:
<4>[ 4157.137838]   0000: 20 00 df ff 0d 00 00 0c 00 18 00 00 
<4>[ 4157.138007] dhdsdio_read_control: Enter
<4>[ 4157.138140] RxCtrl:
<4>[ 4157.138318]   0000: 20 00 df ff 0d 00 00 0c 00 18 00 00 bb 00 00 00 
<4>[ 4157.138581]   0016: 04 00 00 00 00 00 0d 00 00 00 00 00 28 00 00 00 
<4>[ 4157.138907] RxHdr:
<4>[ 4157.139079]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.139252] dhdsdio_readframes: processed 1 frames
<4>[ 4157.139415] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4157.139681] dhdcdc_cmplt: Enter
<4>[ 4157.139814] dhd_bus_rxctl: Enter
<4>[ 4157.139952] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4157.140145] dhdcdc_set_ioctl: Enter
<4>[ 4157.140277] dhdcdc_set_ioctl: cmd 263 len 32
<4>[ 4157.140414] dhdcdc_msg: Enter
<4>[ 4157.140534] dhd_bus_txctl: Enter
<4>[ 4157.140656] dhdsdio_clkctl: Enter
<4>[ 4157.140781] Tx Frame:
<4>[ 4157.140963]   0000: 48 00 b7 ff 0c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4157.141225]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 20 00 00 00 
<4>[ 4157.141489]   0032: 02 00 0e 00 00 00 00 00 61 72 70 5f 6f 6c 00 0b 
<4>[ 4157.141747]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.142005]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.142263]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.142691] dhdcdc_cmplt: Enter
<4>[ 4157.142979] dhdsdio_isr: Enter
<4>[ 4157.143118] dhdsdio_isr: disable SDIO interrupts
<4>[ 4157.143273] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4157.143434] dhdsdio_dpc: Enter
<4>[ 4157.143554] dhdsdio_clkctl: Enter
<4>[ 4157.143925] dhdsdio_readframes: Enter
<4>[ 4157.144211] RxHdr:
<4>[ 4157.144554]   0000: 3c 00 c3 ff 0e 00 00 0c 00 19 00 00 
<4>[ 4157.144741] dhdsdio_read_control: Enter
<4>[ 4157.144874] RxCtrl:
<4>[ 4157.145053]   0000: 3c 00 c3 ff 0e 00 00 0c 00 19 00 00 07 01 00 00 
<4>[ 4157.145319]   0016: 20 00 00 00 00 00 0e 00 00 00 00 00 61 72 70 5f 
<4>[ 4157.145581]   0032: 6f 6c 00 0b 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.145821]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.146139] RxHdr:
<4>[ 4157.146317]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.146490] dhdsdio_readframes: processed 1 frames
<4>[ 4157.146654] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4157.146881] dhd_watchdog_thread:
<4>[ 4157.147011] dhd_bus_watchdog: Enter
<4>[ 4157.147139] dhdsdio_clkctl: Enter
<4>[ 4157.147260] dhdsdio_htclk: Enter
<4>[ 4157.147475] CLKCTL: turned OFF
<4>[ 4157.147607] dhdsdio_sdclk: Enter
<4>[ 4157.147740] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.147957] dhd_bus_rxctl: Enter
<4>[ 4157.148112] dhd_bus_rxctl: resumed on rxctl frame, got 48 expected 48
<4>[ 4157.148310] dhd_arp_offload_set: successfully set ARP offload mode to 
0xb
<4>[ 4157.148512] dhdcdc_set_ioctl: Enter
<4>[ 4157.148643] dhdcdc_set_ioctl: cmd 263 len 32
<4>[ 4157.148781] dhdcdc_msg: Enter
<4>[ 4157.148901] dhd_bus_txctl: Enter
<4>[ 4157.149023] dhdsdio_clkctl: Enter
<4>[ 4157.149143] dhdsdio_sdclk: Enter
<4>[ 4157.149259] dhdsdio_htclk: Enter
<4>[ 4157.155393] CLKCTL: turned ON
<4>[ 4157.155564] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.155697] Tx Frame:
<4>[ 4157.155880]   0000: 48 00 b7 ff 0d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4157.156144]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 20 00 00 00 
<4>[ 4157.156409]   0032: 02 00 0f 00 00 00 00 00 61 72 70 6f 65 00 01 00 
<4>[ 4157.156668]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.156927]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.157186]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.170591] dhd_watchdog_thread:
<4>[ 4157.170753] dhd_bus_watchdog: Enter
<4>[ 4157.170888] dhdsdio_clkctl: Enter
<4>[ 4157.171011] dhdsdio_htclk: Enter
<4>[ 4157.171233] CLKCTL: turned OFF
<4>[ 4157.171368] dhdsdio_sdclk: Enter
<4>[ 4157.171497] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.171752] dhdsdio_isr: Enter
<4>[ 4157.171888] dhdsdio_isr: disable SDIO interrupts
<4>[ 4157.172045] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4157.172199] dhdsdio_dpc: Enter
<4>[ 4157.172315] dhdsdio_clkctl: Enter
<4>[ 4157.172435] dhdsdio_sdclk: Enter
<4>[ 4157.172550] dhdsdio_htclk: Enter
<4>[ 4157.172878] CLKCTL: turned ON
<4>[ 4157.173027] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.173444] dhdsdio_readframes: Enter
<4>[ 4157.173738] RxHdr:
<4>[ 4157.173918]   0000: 3c 00 c3 ff 0f 00 00 0c 00 1a 00 00 
<4>[ 4157.174089] dhdsdio_read_control: Enter
<4>[ 4157.174394] RxCtrl:
<4>[ 4157.174600]   0000: 3c 00 c3 ff 0f 00 00 0c 00 1a 00 00 07 01 00 00 
<4>[ 4157.174870]   0016: 20 00 00 00 00 00 0f 00 00 00 00 00 61 72 70 6f 
<4>[ 4157.175133]   0032: 65 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.175376]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.175693] RxHdr:
<4>[ 4157.175871]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.176041] dhdsdio_readframes: processed 1 frames
<4>[ 4157.176205] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4157.176430] dhd_watchdog_thread:
<4>[ 4157.176559] dhd_bus_watchdog: Enter
<4>[ 4157.176685] dhdsdio_clkctl: Enter
<4>[ 4157.176804] dhdsdio_htclk: Enter
<4>[ 4157.177020] CLKCTL: turned OFF
<4>[ 4157.177155] dhdsdio_sdclk: Enter
<4>[ 4157.177284] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.184437] dhdcdc_cmplt: Enter
<4>[ 4157.184592] dhd_bus_rxctl: Enter
<4>[ 4157.184739] dhd_bus_rxctl: resumed on rxctl frame, got 48 expected 48
<4>[ 4157.184934] dhd_arp_offload_enable: successfully enabed ARP offload to 1
<4>[ 4157.185180] dhdcdc_set_ioctl: Enter
<4>[ 4157.185320] dhdcdc_set_ioctl: cmd 263 len 37
<4>[ 4157.185459] dhdcdc_msg: Enter
<4>[ 4157.185580] dhd_bus_txctl: Enter
<4>[ 4157.185704] dhdsdio_clkctl: Enter
<4>[ 4157.185825] dhdsdio_sdclk: Enter
<4>[ 4157.185942] dhdsdio_htclk: Enter
<4>[ 4157.194566] CLKCTL: turned ON
<4>[ 4157.194736] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.194867] Tx Frame:
<4>[ 4157.195048]   0000: 4d 00 b2 ff 0e 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4157.195312]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 25 00 00 00 
<4>[ 4157.195577]   0032: 02 00 10 00 00 00 00 00 70 6b 74 5f 66 69 6c 74 
<4>[ 4157.195840]   0048: 65 72 5f 61 64 64 00 64 00 00 00 00 00 00 00 00 
<4>[ 4157.196177]   0064: 00 00 00 00 00 00 00 01 00 00 00 01 00 00 00 00 
<4>[ 4157.196453]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.204623] dhd_watchdog_thread:
<4>[ 4157.204813] dhd_bus_watchdog: Enter
<4>[ 4157.204952] dhdsdio_clkctl: Enter
<4>[ 4157.205076] dhdsdio_htclk: Enter
<4>[ 4157.205291] CLKCTL: turned OFF
<4>[ 4157.205425] dhdsdio_sdclk: Enter
<4>[ 4157.205554] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.205805] dhdsdio_isr: Enter
<4>[ 4157.205942] dhdsdio_isr: disable SDIO interrupts
<4>[ 4157.206098] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4157.206251] dhdsdio_dpc: Enter
<4>[ 4157.206368] dhdsdio_clkctl: Enter
<4>[ 4157.206489] dhdsdio_sdclk: Enter
<4>[ 4157.206605] dhdsdio_htclk: Enter
<4>[ 4157.206926] CLKCTL: turned ON
<4>[ 4157.207074] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.207452] dhdsdio_readframes: Enter
<4>[ 4157.207739] RxHdr:
<4>[ 4157.207920]   0000: 41 00 be ff 10 00 00 0c 00 1b 00 00 
<4>[ 4157.208089] dhdsdio_read_control: Enter
<4>[ 4157.208366] RxCtrl:
<4>[ 4157.208567]   0000: 41 00 be ff 10 00 00 0c 00 1b 00 00 07 01 00 00 
<4>[ 4157.208836]   0016: 25 00 00 00 00 00 10 00 00 00 00 00 70 6b 74 5f 
<4>[ 4157.209104]   0032: 66 69 6c 74 65 72 5f 61 64 64 00 64 00 00 00 00 
<4>[ 4157.209366]   0048: 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 01 
<4>[ 4157.209554]   0064: 00 
<4>[ 4157.209799] RxHdr:
<4>[ 4157.209974]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.210147] dhdsdio_readframes: processed 1 frames
<4>[ 4157.210311] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4157.210577] dhdcdc_cmplt: Enter
<4>[ 4157.210711] dhd_bus_rxctl: Enter
<4>[ 4157.210849] dhd_bus_rxctl: resumed on rxctl frame, got 53 expected 53
<4>[ 4157.211043] dhd_pktfilter_offload_set: successfully added pktfilter 100 
0 0 0 0x01 0x00
<4>[ 4157.211305] dhdcdc_set_ioctl: Enter
<4>[ 4157.211439] dhdcdc_set_ioctl: cmd 263 len 26
<4>[ 4157.211577] dhdcdc_msg: Enter
<4>[ 4157.211696] dhd_bus_txctl: Enter
<4>[ 4157.211816] dhdsdio_clkctl: Enter
<4>[ 4157.211939] Tx Frame:
<4>[ 4157.212121]   0000: 42 00 bd ff 0f 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4157.212383]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 1a 00 00 00 
<4>[ 4157.212648]   0032: 02 00 11 00 00 00 00 00 70 6b 74 5f 66 69 6c 74 
<4>[ 4157.212913]   0048: 65 72 5f 65 6e 61 62 6c 65 00 64 00 00 00 00 00 
<4>[ 4157.213174]   0064: 00 00 00 00 00 00 00 01 00 00 00 01 00 00 00 00 
<4>[ 4157.213434]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.224534] dhd_watchdog_thread:
<4>[ 4157.224725] dhd_bus_watchdog: Enter
<4>[ 4157.224867] dhdsdio_clkctl: Enter
<4>[ 4157.224992] dhdsdio_htclk: Enter
<4>[ 4157.225208] CLKCTL: turned OFF
<4>[ 4157.225343] dhdsdio_sdclk: Enter
<4>[ 4157.225475] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.225726] dhdsdio_isr: Enter
<4>[ 4157.225863] dhdsdio_isr: disable SDIO interrupts
<4>[ 4157.226019] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4157.226173] dhdsdio_dpc: Enter
<4>[ 4157.226286] dhdsdio_clkctl: Enter
<4>[ 4157.226405] dhdsdio_sdclk: Enter
<4>[ 4157.226520] dhdsdio_htclk: Enter
<4>[ 4157.226797] CLKCTL: turned ON
<4>[ 4157.226941] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.227308] dhdsdio_readframes: Enter
<4>[ 4157.227597] RxHdr:
<4>[ 4157.227776]   0000: 36 00 c9 ff 11 00 00 0c 00 1c 00 00 
<4>[ 4157.227944] dhdsdio_read_control: Enter
<4>[ 4157.228075] RxCtrl:
<4>[ 4157.228253]   0000: 36 00 c9 ff 11 00 00 0c 00 1c 00 00 07 01 00 00 
<4>[ 4157.228517]   0016: 1a 00 00 00 00 00 11 00 00 00 00 00 70 6b 74 5f 
<4>[ 4157.228784]   0032: 66 69 6c 74 65 72 5f 65 6e 61 62 6c 65 00 64 00 
<4>[ 4157.228996]   0048: 00 00 00 00 00 00 
<4>[ 4157.229265] RxHdr:
<4>[ 4157.229442]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.229611] dhdsdio_readframes: processed 1 frames
<4>[ 4157.229774] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4157.230041] dhdcdc_cmplt: Enter
<4>[ 4157.230174] dhd_bus_rxctl: Enter
<4>[ 4157.230312] dhd_bus_rxctl: resumed on rxctl frame, got 42 expected 42
<4>[ 4157.230507] dhd_pktfilter_offload_enable: successfully added pktfilter 
100 0 0 0 0x01 0x00
<4>[ 4157.230763] dhdcdc_set_ioctl: Enter
<4>[ 4157.230895] dhdcdc_set_ioctl: cmd 263 len 128
<4>[ 4157.231035] dhdcdc_msg: Enter
<4>[ 4157.231153] dhd_bus_txctl: Enter
<4>[ 4157.231275] dhdsdio_clkctl: Enter
<4>[ 4157.231400] Tx Frame:
<4>[ 4157.231583]   0000: a8 00 57 ff 10 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4157.231845]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 80 00 00 00 
<4>[ 4157.232109]   0032: 02 00 12 00 00 00 00 00 70 6b 74 5f 66 69 6c 74 
<4>[ 4157.232373]   0048: 65 72 5f 6d 6f 64 65 00 01 00 00 00 00 00 00 00 
<4>[ 4157.232632]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.232890]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.233149]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.233407]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.233666]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.233925]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.234183]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.244479]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.245045] dhd_watchdog_thread:
<4>[ 4157.245223] dhd_bus_watchdog: Enter
<4>[ 4157.245360] dhdsdio_clkctl: Enter
<4>[ 4157.245483] dhdsdio_htclk: Enter
<4>[ 4157.245695] CLKCTL: turned OFF
<4>[ 4157.245831] dhdsdio_sdclk: Enter
<4>[ 4157.245963] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.246210] dhdsdio_isr: Enter
<4>[ 4157.246344] dhdsdio_isr: disable SDIO interrupts
<4>[ 4157.246499] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4157.246652] dhdsdio_dpc: Enter
<4>[ 4157.246768] dhdsdio_clkctl: Enter
<4>[ 4157.246889] dhdsdio_sdclk: Enter
<4>[ 4157.247007] dhdsdio_htclk: Enter
<4>[ 4157.247330] CLKCTL: turned ON
<4>[ 4157.247480] dhdsdio_clkctl: 0 -> 3
<4>[ 4157.247855] dhdsdio_readframes: Enter
<4>[ 4157.248142] RxHdr:
<4>[ 4157.248325]   0000: 9c 00 63 ff 12 00 00 0c 00 1d 00 00 
<4>[ 4157.248495] dhdsdio_read_control: Enter
<4>[ 4157.248900] RxCtrl:
<4>[ 4157.249105]   0000: 9c 00 63 ff 12 00 00 0c 00 1d 00 00 07 01 00 00 
<4>[ 4157.249372]   0016: 80 00 00 00 00 00 12 00 00 00 00 00 70 6b 74 5f 
<4>[ 4157.249641]   0032: 66 69 6c 74 65 72 5f 6d 6f 64 65 00 01 00 00 00 
<4>[ 4157.249902]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.250161]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.250421]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.250682]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.250942]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.251202]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.251441]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.251748] RxHdr:
<4>[ 4157.251923]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4157.252094] dhdsdio_readframes: processed 1 frames
<4>[ 4157.252254] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4157.252516] dhdcdc_cmplt: Enter
<4>[ 4157.252648] dhd_bus_rxctl: Enter
<4>[ 4157.252788] dhd_bus_rxctl: resumed on rxctl frame, got 144 expected 144
<4>[ 4157.253000] dhd_net_attach: ifidx 0
<4>[ 4157.254419] dhd_watchdog_thread:
<4>[ 4157.254572] dhd_bus_watchdog: Enter
<4>[ 4157.254704] dhdsdio_clkctl: Enter
<4>[ 4157.254825] dhdsdio_htclk: Enter
<4>[ 4157.255044] CLKCTL: turned OFF
<4>[ 4157.255179] dhdsdio_sdclk: Enter
<4>[ 4157.255310] dhdsdio_clkctl: 3 -> 0
<4>[ 4157.285761] dhd_get_stats: Enter
<4>[ 4157.286049] eth0: Broadcom Dongle Host Driver mac=00:26:37:82:86:b6
<4>[ 4159.357854] Enter wl_control_wl_start 
<4>[ 4159.358027] Exited wl_control_wl_start 
<4>[ 4159.358172] dhd_open: ifidx 0
<4>[ 4159.358292] dhd_prot_ioctl: Enter
<4>[ 4159.358412] dhdcdc_query_ioctl: Enter
<4>[ 4159.358545] dhdcdc_query_ioctl: cmd 262 len 32
<4>[ 4159.358687] dhdcdc_msg: Enter
<4>[ 4159.358810] dhd_bus_txctl: Enter
<4>[ 4159.358934] dhdsdio_clkctl: Enter
<4>[ 4159.359055] dhdsdio_sdclk: Enter
<4>[ 4159.359172] dhdsdio_htclk: Enter
<4>[ 4159.362281] dhdsdio_isr: Enter
<4>[ 4159.362428] dhdsdio_isr: disable SDIO interrupts
<4>[ 4159.362584] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4159.362738] dhdsdio_dpc: Enter
<4>[ 4159.364548] CLKCTL: turned ON
<4>[ 4159.364705] dhdsdio_clkctl: 0 -> 3
<4>[ 4159.364835] Tx Frame:
<4>[ 4159.365016]   0000: 48 00 b7 ff 11 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4159.365281]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 20 00 00 00 
<4>[ 4159.365544]   0032: 00 00 13 00 00 00 00 00 74 6f 65 5f 6f 6c 00 c9 
<4>[ 4159.365808]   0048: 00 40 26 c2 10 d8 26 bf 14 89 00 00 00 00 00 00 
<4>[ 4159.366072]   0064: a0 23 83 c0 0c 9b 22 c6 00 00 00 00 00 00 00 00 
<4>[ 4159.366330]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4159.366852] dhdsdio_clkctl: Enter
<4>[ 4159.367241] Dongle reports CHIPACTIVE
<4>[ 4159.367399] dhdsdio_readframes: Enter
<4>[ 4159.367673] RxHdr:
<4>[ 4159.367853]   0000: 3c 00 c3 ff 13 00 00 0c 00 1e 00 00 
<4>[ 4159.368022] dhdsdio_read_control: Enter
<4>[ 4159.368156] RxCtrl:
<4>[ 4159.368336]   0000: 3c 00 c3 ff 13 00 00 0c 00 1e 00 00 06 01 00 00 
<4>[ 4159.368602]   0016: 00 00 00 00 01 00 13 00 e9 ff ff ff 74 6f 65 5f 
<4>[ 4159.368868]   0032: 6f 6c 00 c9 00 40 26 c2 10 d8 26 bf 14 89 00 00 
<4>[ 4159.369113]   0048: 00 00 00 00 a0 23 83 c0 0c 9b 22 c6 
<4>[ 4159.369417] RxHdr:
<4>[ 4159.369589]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4159.369760] dhdsdio_readframes: processed 1 frames
<4>[ 4159.369922] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4159.370184] dhdcdc_cmplt: Enter
<4>[ 4159.370318] dhd_bus_rxctl: Enter
<4>[ 4159.370459] dhd_bus_rxctl: resumed on rxctl frame, got 48 expected 48
<4>[ 4159.370656] eth0: could not get toe_ol: ret=-23
<4>[ 4159.370807] dhd_set_multicast_list: Enter
<4>[ 4159.371014] _dhd_sysioc_thread: interface 0
<4>[ 4159.371183] dhd_prot_ioctl: Enter
<4>[ 4159.371310] dhdcdc_set_ioctl: Enter
<4>[ 4159.371441] dhdcdc_set_ioctl: cmd 263 len 21
<4>[ 4159.371580] dhdcdc_msg: Enter
<4>[ 4159.371692] dhd_bus_txctl: Enter
<4>[ 4159.371813] dhdsdio_clkctl: Enter
<4>[ 4159.371938] Tx Frame:
<4>[ 4159.372122]   0000: 3d 00 c2 ff 12 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4159.372385]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 15 00 00 00 
<4>[ 4159.372651]   0032: 02 00 14 00 00 00 00 00 6d 63 61 73 74 5f 6c 69 
<4>[ 4159.372916]   0048: 73 74 00 01 00 00 00 33 33 00 00 00 01 00 00 00 
<4>[ 4159.373258] dhdcdc_cmplt: Enter
<4>[ 4159.373541] dhdsdio_isr: Enter
<4>[ 4159.373680] dhdsdio_isr: disable SDIO interrupts
<4>[ 4159.373835] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4159.373988] dhdsdio_dpc: Enter
<4>[ 4159.374103] dhdsdio_clkctl: Enter
<4>[ 4159.374643] dhdsdio_readframes: Enter
<4>[ 4159.374940] RxHdr:
<4>[ 4159.375122]   0000: 31 00 ce ff 14 00 00 0c 00 1f 00 00 
<4>[ 4159.375293] dhdsdio_read_control: Enter
<4>[ 4159.375426] RxCtrl:
<4>[ 4159.375603]   0000: 31 00 ce ff 14 00 00 0c 00 1f 00 00 07 01 00 00 
<4>[ 4159.375865]   0016: 15 00 00 00 00 00 14 00 00 00 00 00 6d 63 61 73 
<4>[ 4159.376130]   0032: 74 5f 6c 69 73 74 00 01 00 00 00 33 33 00 00 00 
<4>[ 4159.376319]   0048: 01 
<4>[ 4159.376568] RxHdr:
<4>[ 4159.376743]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4159.376916] dhdsdio_readframes: processed 1 frames
<4>[ 4159.377077] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4159.377303] dhd_watchdog_thread:
<4>[ 4159.377434] dhd_bus_watchdog: Enter
<4>[ 4159.377559] dhdsdio_clkctl: Enter
<4>[ 4159.377678] dhdsdio_htclk: Enter
<4>[ 4159.377892] CLKCTL: turned OFF
<4>[ 4159.378024] dhdsdio_sdclk: Enter
<4>[ 4159.378155] dhdsdio_clkctl: 3 -> 0
<4>[ 4159.381913] dhd_bus_rxctl: Enter
<4>[ 4159.382097] dhd_bus_rxctl: resumed on rxctl frame, got 37 expected 37
<4>[ 4159.382313] dhd_prot_ioctl: Enter
<4>[ 4159.382439] dhdcdc_set_ioctl: Enter
<4>[ 4159.382571] dhdcdc_set_ioctl: cmd 263 len 13
<4>[ 4159.382710] dhdcdc_msg: Enter
<4>[ 4159.382821] dhd_bus_txctl: Enter
<4>[ 4159.382942] dhdsdio_clkctl: Enter
<4>[ 4159.383061] dhdsdio_sdclk: Enter
<4>[ 4159.383178] dhdsdio_htclk: Enter
<4>[ 4159.383575] dhd_set_multicast_list: Enter
<4>[ 4159.383784] dhd_get_stats: Enter
<4>[ 4159.384033] dhd_set_multicast_list: Enter
<4>[ 4159.385102] dhd_set_multicast_list: Enter
<4>[ 4159.386405] dhdsdio_isr: Enter
<4>[ 4159.386558] dhdsdio_isr: disable SDIO interrupts
<4>[ 4159.386716] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4159.386872] dhdsdio_dpc: Enter
<4>[ 4159.387155] CLKCTL: turned ON
<4>[ 4159.387302] dhdsdio_clkctl: 0 -> 3
<4>[ 4159.387432] Tx Frame:
<4>[ 4159.387617]   0000: 35 00 ca ff 13 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4159.387879]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 0d 00 00 00 
<4>[ 4159.388143]   0032: 02 00 15 00 00 00 00 00 61 6c 6c 6d 75 6c 74 69 
<4>[ 4159.388404]   0048: 00 00 00 00 00 00 00 33 33 00 00 00 01 00 00 00 
<4>[ 4159.394612] dhdsdio_clkctl: Enter
<4>[ 4159.395033] Dongle reports CHIPACTIVE
<4>[ 4159.395194] dhdsdio_readframes: Enter
<4>[ 4159.395470] RxHdr:
<4>[ 4159.395653]   0000: 29 00 d6 ff 15 00 00 0c 00 20 00 00 
<4>[ 4159.395820] dhdsdio_read_control: Enter
<4>[ 4159.395952] RxCtrl:
<4>[ 4159.396132]   0000: 29 00 d6 ff 15 00 00 0c 00 20 00 00 07 01 00 00 
<4>[ 4159.396397]   0016: 0d 00 00 00 00 00 15 00 00 00 00 00 61 6c 6c 6d 
<4>[ 4159.396625]   0032: 75 6c 74 69 00 00 00 00 00 
<4>[ 4159.396913] RxHdr:
<4>[ 4159.397086]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4159.397257] dhdsdio_readframes: processed 1 frames
<4>[ 4159.397418] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4159.397646] dhd_watchdog_thread:
<4>[ 4159.397774] dhd_bus_watchdog: Enter
<4>[ 4159.397902] dhdsdio_clkctl: Enter
<4>[ 4159.398023] dhdsdio_htclk: Enter
<4>[ 4159.398237] CLKCTL: turned OFF
<4>[ 4159.398372] dhdsdio_sdclk: Enter
<4>[ 4159.398503] dhdsdio_clkctl: 3 -> 0
<4>[ 4159.398711] dhdcdc_cmplt: Enter
<4>[ 4159.398845] dhd_bus_rxctl: Enter
<4>[ 4159.398986] dhd_bus_rxctl: resumed on rxctl frame, got 29 expected 29
<4>[ 4159.399183] dhd_prot_ioctl: Enter
<4>[ 4159.399303] dhdcdc_set_ioctl: Enter
<4>[ 4159.399433] dhdcdc_set_ioctl: cmd 10 len 4
<4>[ 4159.399567] dhdcdc_msg: Enter
<4>[ 4159.399678] dhd_bus_txctl: Enter
<4>[ 4159.399798] dhdsdio_clkctl: Enter
<4>[ 4159.399916] dhdsdio_sdclk: Enter
<4>[ 4159.400039] dhdsdio_htclk: Enter
<4>[ 4159.403250] dhdsdio_isr: Enter
<4>[ 4159.403405] dhdsdio_isr: disable SDIO interrupts
<4>[ 4159.403564] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4159.403719] dhdsdio_dpc: Enter
<4>[ 4159.404006] CLKCTL: turned ON
<4>[ 4159.404155] dhdsdio_clkctl: 0 -> 3
<4>[ 4159.404576] dhd_start_xmit: Enter
<4>[ 4159.404734] dhd_prot_hdrpush: Enter
<4>[ 4159.404866] dhd_bus_txdata: Enter
<4>[ 4159.404991] dhd_bus_txdata: deferring pktq len 0
<4>[ 4159.405239] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4159.405413] dhdsdio_dpc: Enter
<4>[ 4159.405610] Tx Frame:
<4>[ 4159.405803]   0000: 2c 00 d3 ff 14 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4159.406067]   0016: 00 00 00 00 00 00 00 00 0a 00 00 00 04 00 00 00 
<4>[ 4159.406331]   0032: 02 00 16 00 00 00 00 00 00 00 00 00 75 6c 74 69 
<4>[ 4159.406593]   0048: 00 00 00 00 00 00 00 33 33 00 00 00 01 00 00 00 
<4>[ 4159.407002] dhdsdio_clkctl: Enter
<4>[ 4159.407398] Dongle reports CHIPACTIVE
<4>[ 4159.407555] dhdsdio_readframes: Enter
<4>[ 4159.407829] RxHdr:
<4>[ 4159.408010]   0000: 20 00 df ff 16 00 00 0c 00 21 00 00 
<4>[ 4159.408179] dhdsdio_read_control: Enter
<4>[ 4159.408311] RxCtrl:
<4>[ 4159.408490]   0000: 20 00 df ff 16 00 00 0c 00 21 00 00 0a 00 00 00 
<4>[ 4159.408752]   0016: 04 00 00 00 00 00 16 00 00 00 00 00 00 00 00 00 
<4>[ 4159.409075] RxHdr:
<4>[ 4159.409250]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4159.409423] dhdsdio_readframes: processed 1 frames
<4>[ 4159.409586] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4159.409773] dhdsdio_sendfromq: Enter
<4>[ 4159.409903] dhdsdio_txpkt: Enter
<4>[ 4159.410023] Tx Frame:
<4>[ 4159.410206]   0000: 6c 00 93 ff 15 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4159.410471]   0016: 00 00 33 33 00 00 00 16 00 26 37 82 86 b6 86 dd 
<4>[ 4159.410732]   0032: 60 00 00 00 00 24 00 01 00 00 00 00 00 00 00 00 
<4>[ 4159.410994]   0048: 00 00 00 00 00 00 00 00 ff 02 00 00 00 00 00 00 
<4>[ 4159.411254]   0064: 00 00 00 00 00 00 00 16 3a 00 05 02 00 00 01 00 
<4>[ 4159.411516]   0080: 8f 00 e8 51 00 00 00 01 04 00 00 00 ff 02 00 00 
<4>[ 4159.411758]   0096: 00 00 00 00 00 00 00 01 ff 82 86 b6 
<4>[ 4159.412210] dhdsdio_clkctl: Enter
<4>[ 4159.412414] dhd_watchdog_thread:
<4>[ 4159.412550] dhd_bus_watchdog: Enter
<4>[ 4159.412680] dhdsdio_clkctl: Enter
<4>[ 4159.412799] dhdsdio_htclk: Enter
<4>[ 4159.413019] CLKCTL: turned OFF
<4>[ 4159.413153] dhdsdio_sdclk: Enter
<4>[ 4159.413283] dhdsdio_clkctl: 3 -> 0
<4>[ 4159.413441] dhd_prot_hdrpull: Enter
<4>[ 4159.413658] dhdcdc_cmplt: Enter
<4>[ 4159.413791] dhd_bus_rxctl: Enter
<4>[ 4159.413930] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4159.414153] _dhd_sysioc_thread: interface 0
<4>[ 4159.414426] dhd_prot_ioctl: Enter
<4>[ 4159.414569] dhdcdc_set_ioctl: Enter
<4>[ 4159.414708] dhdcdc_set_ioctl: cmd 263 len 33
<4>[ 4159.414849] dhdcdc_msg: Enter
<4>[ 4159.414961] dhd_bus_txctl: Enter
<4>[ 4159.415080] dhdsdio_clkctl: Enter
<4>[ 4159.415199] dhdsdio_sdclk: Enter
<4>[ 4159.415316] dhdsdio_htclk: Enter
<4>[ 4159.418532] dhdsdio_isr: Enter
<4>[ 4159.418689] dhdsdio_isr: disable SDIO interrupts
<4>[ 4159.418848] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4159.419001] dhdsdio_dpc: Enter
<4>[ 4159.419287] CLKCTL: turned ON
<4>[ 4159.419436] dhdsdio_clkctl: 0 -> 3
<4>[ 4159.419566] Tx Frame:
<4>[ 4159.419751]   0000: 49 00 b6 ff 16 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4159.420014]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 21 00 00 00 
<4>[ 4159.420280]   0032: 02 00 17 00 00 00 00 00 6d 63 61 73 74 5f 6c 69 
<4>[ 4159.420545]   0048: 73 74 00 03 00 00 00 33 33 00 00 00 01 01 00 5e 
<4>[ 4159.420808]   0064: 00 00 01 33 33 ff 82 86 b6 00 00 00 00 00 00 00 
<4>[ 4159.421067]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4159.424899] dhdsdio_clkctl: Enter
<4>[ 4159.425322] Dongle reports CHIPACTIVE
<4>[ 4159.425485] dhdsdio_readframes: Enter
<4>[ 4159.425757] RxHdr:
<4>[ 4159.425937]   0000: 3d 00 c2 ff 17 00 00 0c 00 23 00 00 
<4>[ 4159.426106] dhdsdio_read_control: Enter
<4>[ 4159.426239] RxCtrl:
<4>[ 4159.426418]   0000: 3d 00 c2 ff 17 00 00 0c 00 23 00 00 07 01 00 00 
<4>[ 4159.426682]   0016: 21 00 00 00 00 00 17 00 00 00 00 00 6d 63 61 73 
<4>[ 4159.426947]   0032: 74 5f 6c 69 73 74 00 03 00 00 00 33 33 00 00 00 
<4>[ 4159.427198]   0048: 01 01 00 5e 00 00 01 33 33 ff 82 86 b6 
<4>[ 4159.427506] RxHdr:
<4>[ 4159.427680]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4159.427852] dhdsdio_readframes: processed 1 frames
<4>[ 4159.428016] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4159.428243] dhd_watchdog_thread:
<4>[ 4159.428373] dhd_bus_watchdog: Enter
<4>[ 4159.428500] dhdsdio_clkctl: Enter
<4>[ 4159.428620] dhdsdio_htclk: Enter
<4>[ 4159.428835] CLKCTL: turned OFF
<4>[ 4159.428970] dhdsdio_sdclk: Enter
<4>[ 4159.429099] dhdsdio_clkctl: 3 -> 0
<4>[ 4159.429307] dhdcdc_cmplt: Enter
<4>[ 4159.429436] dhd_bus_rxctl: Enter
<4>[ 4159.429575] dhd_bus_rxctl: resumed on rxctl frame, got 49 expected 49
<4>[ 4159.429782] dhd_prot_ioctl: Enter
<4>[ 4159.429905] dhdcdc_set_ioctl: Enter
<4>[ 4159.430035] dhdcdc_set_ioctl: cmd 263 len 13
<4>[ 4159.430172] dhdcdc_msg: Enter
<4>[ 4159.430284] dhd_bus_txctl: Enter
<4>[ 4159.430403] dhdsdio_clkctl: Enter
<4>[ 4159.430521] dhdsdio_sdclk: Enter
<4>[ 4159.430637] dhdsdio_htclk: Enter
<4>[ 4159.433853] dhdsdio_isr: Enter
<4>[ 4159.434011] dhdsdio_isr: disable SDIO interrupts
<4>[ 4159.434170] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4159.434443] dhdsdio_dpc: Enter
<4>[ 4159.434779] CLKCTL: turned ON
<4>[ 4159.434933] dhdsdio_clkctl: 0 -> 3
<4>[ 4159.435064] Tx Frame:
<4>[ 4159.435249]   0000: 35 00 ca ff 17 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4159.435512]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 0d 00 00 00 
<4>[ 4159.435779]   0032: 02 00 18 00 00 00 00 00 61 6c 6c 6d 75 6c 74 69 
<4>[ 4159.436041]   0048: 00 00 00 00 00 00 00 33 33 00 00 00 01 01 00 5e 
<4>[ 4159.436443] dhdsdio_clkctl: Enter
<4>[ 4159.436824] Dongle reports CHIPACTIVE
<4>[ 4159.436980] dhdsdio_readframes: Enter
<4>[ 4159.437252] RxHdr:
<4>[ 4159.437432]   0000: 29 00 d6 ff 18 00 00 0c 00 24 00 00 
<4>[ 4159.437600] dhdsdio_read_control: Enter
<4>[ 4159.437734] RxCtrl:
<4>[ 4159.437914]   0000: 29 00 d6 ff 18 00 00 0c 00 24 00 00 07 01 00 00 
<4>[ 4159.438180]   0016: 0d 00 00 00 00 00 18 00 00 00 00 00 61 6c 6c 6d 
<4>[ 4159.438410]   0032: 75 6c 74 69 00 00 00 00 00 
<4>[ 4159.438696] RxHdr:
<4>[ 4159.438871]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4159.439041] dhdsdio_readframes: processed 1 frames
<4>[ 4159.439204] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4159.439455] dhdcdc_cmplt: Enter
<4>[ 4159.439586] dhd_bus_rxctl: Enter
<4>[ 4159.439725] dhd_bus_rxctl: resumed on rxctl frame, got 29 expected 29
<4>[ 4159.439923] dhd_prot_ioctl: Enter
<4>[ 4159.440045] dhdcdc_set_ioctl: Enter
<4>[ 4159.440174] dhdcdc_set_ioctl: cmd 10 len 4
<4>[ 4159.440308] dhdcdc_msg: Enter
<4>[ 4159.440420] dhd_bus_txctl: Enter
<4>[ 4159.440540] dhdsdio_clkctl: Enter
<4>[ 4159.440664] Tx Frame:
<4>[ 4159.440846]   0000: 2c 00 d3 ff 18 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4159.441107]   0016: 00 00 00 00 00 00 00 00 0a 00 00 00 04 00 00 00 
<4>[ 4159.441371]   0032: 02 00 19 00 00 00 00 00 00 00 00 00 75 6c 74 69 
<4>[ 4159.441632]   0048: 00 00 00 00 00 00 00 33 33 00 00 00 01 01 00 5e 
<4>[ 4159.444551] dhdsdio_isr: Enter
<4>[ 4159.444707] dhdsdio_isr: disable SDIO interrupts
<4>[ 4159.444869] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4159.445023] dhdsdio_dpc: Enter
<4>[ 4159.445213] dhd_watchdog_thread:
<4>[ 4159.445348] dhd_bus_watchdog: Enter
<4>[ 4159.445475] dhdsdio_clkctl: Enter
<4>[ 4159.445596] dhdsdio_htclk: Enter
<4>[ 4159.445821] CLKCTL: turned OFF
<4>[ 4159.445960] dhdsdio_sdclk: Enter
<4>[ 4159.446093] dhdsdio_clkctl: 3 -> 0
<4>[ 4159.446254] dhdsdio_clkctl: Enter
<4>[ 4159.446384] dhdsdio_sdclk: Enter
<4>[ 4159.446504] dhdsdio_htclk: Enter
<4>[ 4159.446790] CLKCTL: turned ON
<4>[ 4159.446933] dhdsdio_clkctl: 0 -> 3
<4>[ 4159.447299] dhdsdio_readframes: Enter
<4>[ 4159.447588] RxHdr:
<4>[ 4159.447769]   0000: 20 00 df ff 19 00 00 0c 00 25 00 00 
<4>[ 4159.447937] dhdsdio_read_control: Enter
<4>[ 4159.448071] RxCtrl:
<4>[ 4159.448247]   0000: 20 00 df ff 19 00 00 0c 00 25 00 00 0a 00 00 00 
<4>[ 4159.448509]   0016: 04 00 00 00 00 00 19 00 00 00 00 00 00 00 00 00 
<4>[ 4159.448833] RxHdr:
<4>[ 4159.449010]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4159.449182] dhdsdio_readframes: processed 1 frames
<4>[ 4159.449345] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4159.449598] dhdcdc_cmplt: Enter
<4>[ 4159.449730] dhd_bus_rxctl: Enter
<4>[ 4159.449873] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4159.450093] _dhd_sysioc_thread: interface 0
<4>[ 4159.450260] _dhd_sysioc_thread: interface 0
<4>[ 4159.454403] dhd_watchdog_thread:
<4>[ 4159.454564] dhd_bus_watchdog: Enter
<4>[ 4159.454700] dhdsdio_clkctl: Enter
<4>[ 4159.454823] dhdsdio_htclk: Enter
<4>[ 4159.455048] CLKCTL: turned OFF
<4>[ 4159.455183] dhdsdio_sdclk: Enter
<4>[ 4159.455314] dhdsdio_clkctl: 3 -> 0
<4>[ 4160.004566] dhd_start_xmit: Enter
<4>[ 4160.004749] dhd_prot_hdrpush: Enter
<4>[ 4160.004887] dhd_bus_txdata: Enter
<4>[ 4160.005016] dhd_bus_txdata: deferring pktq len 0
<4>[ 4160.005264] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4160.005433] dhdsdio_dpc: Enter
<4>[ 4160.005553] dhdsdio_clkctl: Enter
<4>[ 4160.005674] dhdsdio_sdclk: Enter
<4>[ 4160.005790] dhdsdio_htclk: Enter
<4>[ 4160.006259] CLKCTL: set PENDING
<4>[ 4160.006413] dhdsdio_clkctl: 0 -> 2
<4>[ 4160.006547] dhdsdio_dpc: rescheduled due to CLK_PENDING awaiting 			
I_CHIPACTIVE interruptCalling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4160.006882] dhdsdio_dpc: Enter
<4>[ 4160.007197] DPC: PENDING, devctl 0x04 clkctl 0x10
<4>[ 4160.007368] dhdsdio_dpc: rescheduled due to CLK_PENDING awaiting 			
I_CHIPACTIVE interruptCalling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4160.007702] dhdsdio_dpc: Enter
<4>[ 4160.008008] DPC: PENDING, devctl 0x04 clkctl 0x10
<4>[ 4160.008180] dhdsdio_dpc: rescheduled due to CLK_PENDING awaiting 			
I_CHIPACTIVE interruptCalling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4160.008517] dhdsdio_dpc: Enter
<4>[ 4160.008838] DPC: PENDING, devctl 0x04 clkctl 0x50
<4>[ 4160.009008] dhdsdio_dpc: rescheduled due to CLK_PENDING awaiting 			
I_CHIPACTIVE interruptCalling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4160.009343] dhdsdio_dpc: Enter
<4>[ 4160.009653] DPC: PENDING, devctl 0x04 clkctl 0xd0
<4>[ 4160.009997] dhdsdio_clkctl: Enter
<4>[ 4160.010148] dhdsdio_sendfromq: Enter
<4>[ 4160.010284] dhdsdio_txpkt: Enter
<4>[ 4160.010408] Tx Frame:
<4>[ 4160.010591]   0000: 60 00 9f ff 19 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4160.010859]   0016: 00 00 33 33 ff 82 86 b6 00 26 37 82 86 b6 86 dd 
<4>[ 4160.011120]   0032: 60 00 00 00 00 18 3a ff 00 00 00 00 00 00 00 00 
<4>[ 4160.011379]   0048: 00 00 00 00 00 00 00 00 ff 02 00 00 00 00 00 00 
<4>[ 4160.011642]   0064: 00 00 00 01 ff 82 86 b6 87 00 35 90 00 00 00 00 
<4>[ 4160.011905]   0080: fe 80 00 00 00 00 00 00 02 26 37 ff fe 82 86 b6 
<4>[ 4160.012303] dhd_prot_hdrpull: Enter
<4>[ 4160.012696] dhdsdio_isr: Enter
<4>[ 4160.012839] dhdsdio_isr: disable SDIO interrupts
<4>[ 4160.012992] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4160.013152] dhdsdio_dpc: Enter
<4>[ 4160.013271] dhdsdio_clkctl: Enter
<4>[ 4160.013639] Dongle reports CHIPACTIVE
<4>[ 4160.013805] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 0
<4>[ 4160.014425] dhd_watchdog_thread:
<4>[ 4160.014579] dhd_bus_watchdog: Enter
<4>[ 4160.014710] dhdsdio_clkctl: Enter
<4>[ 4160.014830] dhdsdio_htclk: Enter
<4>[ 4160.015051] CLKCTL: turned OFF
<4>[ 4160.015186] dhdsdio_sdclk: Enter
<4>[ 4160.015313] dhdsdio_clkctl: 3 -> 0
<4>[ 4160.385608] eth0: SIOCSIWPMKSA
<4>[ 4160.385760] wl_iw_set_pmksa - IW_PMKSA_FLUSH
<4>[ 4160.385917] PRINTING pmkid LIST - No of elements 0, ret = 0
<4>[ 4160.386077] 
<4>[ 4160.386298] 
<4>[ 4160.386319] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:bf26e82c, len:371 ,
<4>[ 4160.386631] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4160.386801] dhd_prot_ioctl: Enter
<4>[ 4160.386925] dhdcdc_query_ioctl: Enter
<4>[ 4160.387062] dhdcdc_query_ioctl: cmd 263 len 371
<4>[ 4160.387208] dhdcdc_msg: Enter
<4>[ 4160.387322] dhd_bus_txctl: Enter
<4>[ 4160.387441] dhdsdio_clkctl: Enter
<4>[ 4160.387560] dhdsdio_sdclk: Enter
<4>[ 4160.387677] dhdsdio_htclk: Enter
<4>[ 4160.390782] dhdsdio_isr: Enter
<4>[ 4160.390929] dhdsdio_isr: disable SDIO interrupts
<4>[ 4160.391085] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4160.391238] dhdsdio_dpc: Enter
<4>[ 4160.394519] CLKCTL: turned ON
<4>[ 4160.394677] dhdsdio_clkctl: 0 -> 3
<4>[ 4160.394805] Tx Frame:
<4>[ 4160.394990]   0000: 9b 01 64 fe 1a 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4160.395255]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 73 01 00 00 
<4>[ 4160.395521]   0032: 00 00 1a 00 00 00 00 00 70 6d 6b 69 64 5f 69 6e 
<4>[ 4160.395782]   0048: 66 6f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.396042]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.396301]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.396560]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.396819]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.397079]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.397337]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.397596]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.397855]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.398114]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.398372]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.398631]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.398889]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.399148]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.399407]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.399665]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.399923]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.400182]   0320: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.400441]   0336: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.400700]   0352: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.400958]   0368: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.401217]   0384: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.401475]   0400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.402604] dhdsdio_clkctl: Enter
<4>[ 4160.402996] Dongle reports CHIPACTIVE
<4>[ 4160.403153] dhdsdio_readframes: Enter
<4>[ 4160.403426] RxHdr:
<4>[ 4160.403606]   0000: 8f 01 70 fe 1a 00 00 0c 00 27 00 00 
<4>[ 4160.403776] dhdsdio_read_control: Enter
<4>[ 4160.404655] RxCtrl:
<4>[ 4160.404871]   0000: 8f 01 70 fe 1a 00 00 0c 00 27 00 00 07 01 00 00 
<4>[ 4160.405142]   0016: 73 01 00 00 00 00 1a 00 00 00 00 00 70 6d 6b 69 
<4>[ 4160.405409]   0032: 64 5f 69 6e 66 6f 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.405669]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.405930]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.406189]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.406448]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.406706]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.406967]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.407226]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.407486]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.407746]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.408006]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.408320]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.408590]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.408852]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.409114]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.409373]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.409632]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.409890]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.410149]   0320: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.410407]   0336: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.410665]   0352: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.410925]   0368: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.411179]   0384: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.411510] RxHdr:
<4>[ 4160.411686]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.411857] dhdsdio_readframes: processed 1 frames
<4>[ 4160.412020] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4160.412247] dhd_watchdog_thread:
<4>[ 4160.412376] dhd_bus_watchdog: Enter
<4>[ 4160.412505] dhdsdio_clkctl: Enter
<4>[ 4160.412626] dhdsdio_htclk: Enter
<4>[ 4160.412840] CLKCTL: turned OFF
<4>[ 4160.412974] dhdsdio_sdclk: Enter
<4>[ 4160.413105] dhdsdio_clkctl: 3 -> 0
<4>[ 4160.417047] dhdcdc_cmplt: Enter
<4>[ 4160.417204] dhd_bus_rxctl: Enter
<4>[ 4160.417353] dhd_bus_rxctl: resumed on rxctl frame, got 387 expected 387
<4>[ 4160.417644] eth0: SIOCSIWMODE
<4>[ 4160.417813] 
<4>[ 4160.417835] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x14, 
buf:c2297ddc, len:4 ,
<4>[ 4160.418145] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4160.418308] dhd_prot_ioctl: Enter
<4>[ 4160.418431] dhdcdc_query_ioctl: Enter
<4>[ 4160.418565] dhdcdc_query_ioctl: cmd 20 len 4
<4>[ 4160.418704] dhdcdc_msg: Enter
<4>[ 4160.418815] dhd_bus_txctl: Enter
<4>[ 4160.418936] dhdsdio_clkctl: Enter
<4>[ 4160.419054] dhdsdio_sdclk: Enter
<4>[ 4160.419170] dhdsdio_htclk: Enter
<4>[ 4160.424564] dhdsdio_isr: Enter
<4>[ 4160.424724] dhdsdio_isr: disable SDIO interrupts
<4>[ 4160.424885] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4160.425039] dhdsdio_dpc: Enter
<4>[ 4160.425327] CLKCTL: turned ON
<4>[ 4160.425478] dhdsdio_clkctl: 0 -> 3
<4>[ 4160.425606] Tx Frame:
<4>[ 4160.425791]   0000: 2c 00 d3 ff 1b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4160.426055]   0016: 00 00 00 00 00 00 00 00 14 00 00 00 04 00 00 00 
<4>[ 4160.426318]   0032: 00 00 1b 00 00 00 00 00 01 00 00 00 64 5f 69 6e 
<4>[ 4160.426577]   0048: 66 6f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.434525] dhdsdio_clkctl: Enter
<4>[ 4160.434949] Dongle reports CHIPACTIVE
<4>[ 4160.435110] dhdsdio_readframes: Enter
<4>[ 4160.435389] RxHdr:
<4>[ 4160.435573]   0000: 20 00 df ff 1b 00 00 0c 00 28 00 00 
<4>[ 4160.435745] dhdsdio_read_control: Enter
<4>[ 4160.435877] RxCtrl:
<4>[ 4160.436055]   0000: 20 00 df ff 1b 00 00 0c 00 28 00 00 14 00 00 00 
<4>[ 4160.436318]   0016: 04 00 00 00 00 00 1b 00 00 00 00 00 01 00 00 00 
<4>[ 4160.436640] RxHdr:
<4>[ 4160.436814]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.436984] dhdsdio_readframes: processed 1 frames
<4>[ 4160.437146] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4160.437374] dhd_watchdog_thread:
<4>[ 4160.437505] dhd_bus_watchdog: Enter
<4>[ 4160.437631] dhdsdio_clkctl: Enter
<4>[ 4160.437750] dhdsdio_htclk: Enter
<4>[ 4160.437963] CLKCTL: turned OFF
<4>[ 4160.438096] dhdsdio_sdclk: Enter
<4>[ 4160.438226] dhdsdio_clkctl: 3 -> 0
<4>[ 4160.438431] dhdcdc_cmplt: Enter
<4>[ 4160.438561] dhd_bus_rxctl: Enter
<4>[ 4160.438702] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4160.438956] 
<4>[ 4160.438977] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x76, 
buf:c2297dd8, len:4 ,
<4>[ 4160.439291] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4160.439457] dhd_prot_ioctl: Enter
<4>[ 4160.439579] dhdcdc_query_ioctl: Enter
<4>[ 4160.439716] dhdcdc_query_ioctl: cmd 118 len 4
<4>[ 4160.439857] dhdcdc_msg: Enter
<4>[ 4160.439969] dhd_bus_txctl: Enter
<4>[ 4160.440088] dhdsdio_clkctl: Enter
<4>[ 4160.440206] dhdsdio_sdclk: Enter
<4>[ 4160.440321] dhdsdio_htclk: Enter
<4>[ 4160.443467] dhdsdio_isr: Enter
<4>[ 4160.443626] dhdsdio_isr: disable SDIO interrupts
<4>[ 4160.443784] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4160.443937] dhdsdio_dpc: Enter
<4>[ 4160.444564] CLKCTL: turned ON
<4>[ 4160.444731] dhdsdio_clkctl: 0 -> 3
<4>[ 4160.444860] Tx Frame:
<4>[ 4160.445044]   0000: 2c 00 d3 ff 1c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4160.445306]   0016: 00 00 00 00 00 00 00 00 76 00 00 00 04 00 00 00 
<4>[ 4160.445569]   0032: 00 00 1c 00 00 00 00 00 00 00 00 00 64 5f 69 6e 
<4>[ 4160.445830]   0048: 66 6f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.446235] dhdsdio_clkctl: Enter
<4>[ 4160.446620] Dongle reports CHIPACTIVE
<4>[ 4160.446777] dhdsdio_readframes: Enter
<4>[ 4160.447047] RxHdr:
<4>[ 4160.447228]   0000: 20 00 df ff 1c 00 00 0c 00 29 00 00 
<4>[ 4160.447398] dhdsdio_read_control: Enter
<4>[ 4160.447531] RxCtrl:
<4>[ 4160.447710]   0000: 20 00 df ff 1c 00 00 0c 00 29 00 00 76 00 00 00 
<4>[ 4160.447974]   0016: 04 00 00 00 00 00 1c 00 00 00 00 00 00 00 00 00 
<4>[ 4160.448300] RxHdr:
<4>[ 4160.448476]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.448648] dhdsdio_readframes: processed 1 frames
<4>[ 4160.448811] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4160.449063] dhdcdc_cmplt: Enter
<4>[ 4160.449193] dhd_bus_rxctl: Enter
<4>[ 4160.449331] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4160.449672] eth0: SIOCSIWCOMMIT
<4>[ 4160.449852] 
<4>[ 4160.449874] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:c2297d98, len:36 ,
<4>[ 4160.450184] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4160.450348] dhd_prot_ioctl: Enter
<4>[ 4160.450473] dhdcdc_query_ioctl: Enter
<4>[ 4160.450607] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4160.450748] dhdcdc_msg: Enter
<4>[ 4160.450858] dhd_bus_txctl: Enter
<4>[ 4160.450979] dhdsdio_clkctl: Enter
<4>[ 4160.451102] Tx Frame:
<4>[ 4160.451284]   0000: 4c 00 b3 ff 1d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4160.451546]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4160.451807]   0032: 00 00 1d 00 00 00 00 00 0b 00 00 00 00 60 29 c2 
<4>[ 4160.452071]   0048: 13 01 00 60 20 27 02 ca 00 00 00 00 00 60 29 c2 
<4>[ 4160.452336]   0064: 08 a0 75 c0 8d ff ff ff dc 7e 29 c2 00 00 00 00 
<4>[ 4160.452595]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.464858] dhdsdio_isr: Enter
<4>[ 4160.465016] dhdsdio_isr: disable SDIO interrupts
<4>[ 4160.465174] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4160.465329] dhdsdio_dpc: Enter
<4>[ 4160.465523] dhd_watchdog_thread:
<4>[ 4160.465656] dhd_bus_watchdog: Enter
<4>[ 4160.465784] dhdsdio_clkctl: Enter
<4>[ 4160.465906] dhdsdio_htclk: Enter
<4>[ 4160.466132] CLKCTL: turned OFF
<4>[ 4160.466269] dhdsdio_sdclk: Enter
<4>[ 4160.466399] dhdsdio_clkctl: 3 -> 0
<4>[ 4160.466560] dhdsdio_clkctl: Enter
<4>[ 4160.466689] dhdsdio_sdclk: Enter
<4>[ 4160.466810] dhdsdio_htclk: Enter
<4>[ 4160.467093] CLKCTL: turned ON
<4>[ 4160.467238] dhdsdio_clkctl: 0 -> 3
<4>[ 4160.467603] dhdsdio_readframes: Enter
<4>[ 4160.467887] RxHdr:
<4>[ 4160.468067]   0000: 40 00 bf ff 1d 00 00 0c 00 2a 00 00 
<4>[ 4160.468237] dhdsdio_read_control: Enter
<4>[ 4160.468370] RxCtrl:
<4>[ 4160.468547]   0000: 40 00 bf ff 1d 00 00 0c 00 2a 00 00 19 00 00 00 
<4>[ 4160.468808]   0016: 24 00 00 00 00 00 1d 00 00 00 00 00 00 00 00 00 
<4>[ 4160.469067]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.469326]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.469651] RxHdr:
<4>[ 4160.469830]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.470002] dhdsdio_readframes: processed 1 frames
<4>[ 4160.470165] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4160.470417] dhdcdc_cmplt: Enter
<4>[ 4160.470550] dhd_bus_rxctl: Enter
<4>[ 4160.470689] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4160.471152] eth0: SIOCGIWRANGE
<4>[ 4160.471343] 
<4>[ 4160.471364] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xd9, 
buf:c3c36800, len:900 ,
<4>[ 4160.471678] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4160.471849] dhd_prot_ioctl: Enter
<4>[ 4160.471972] dhdcdc_query_ioctl: Enter
<4>[ 4160.472108] dhdcdc_query_ioctl: cmd 217 len 900
<4>[ 4160.472259] dhdcdc_msg: Enter
<4>[ 4160.472372] dhd_bus_txctl: Enter
<4>[ 4160.472494] dhdsdio_clkctl: Enter
<4>[ 4160.472619] Tx Frame:
<4>[ 4160.472801]   0000: ac 03 53 fc 1e 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4160.473064]   0016: 00 00 00 00 00 00 00 00 d9 00 00 00 84 03 00 00 
<4>[ 4160.473324]   0032: 00 00 1e 00 00 00 00 00 e0 00 00 00 00 00 00 00 
<4>[ 4160.473587]   0048: 00 00 00 00 40 85 1c ca f4 cd 60 c0 00 00 00 00 
<4>[ 4160.473851]   0064: 01 00 00 00 1c 68 c3 c3 1c 68 c3 c3 00 00 00 00 
<4>[ 4160.474117]   0080: 01 00 00 00 2c 68 c3 c3 2c 68 c3 c3 00 fc 1f c6 
<4>[ 4160.474582]   0096: 2c fc 1f c6 00 00 00 00 70 74 73 30 00 00 00 00 
<4>[ 4160.474867]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.475130]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.475391]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.475650]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.475910]   0176: 84 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.476172]   0192: 00 00 00 00 ff 0f 00 00 00 64 c3 c3 00 00 00 00 
<4>[ 4160.476438]   0208: 00 02 00 00 ac 68 c3 c3 ac 68 c3 c3 60 8e 39 c0 
<4>[ 4160.476696]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.476961]   0240: 00 00 00 00 cc 68 c3 c3 cc 68 c3 c3 d4 68 c3 c3 
<4>[ 4160.477227]   0256: d4 68 c3 c3 00 00 00 00 e0 68 c3 c3 e0 68 c3 c3 
<4>[ 4160.477491]   0272: 04 0a 39 c0 00 00 00 00 30 3c da c9 f4 68 c3 c3 
<4>[ 4160.477755]   0288: f4 68 c3 c3 00 00 00 00 10 00 01 00 d4 e3 05 00 
<4>[ 4160.478016]   0304: 00 00 00 00 18 24 ee 14 00 00 00 00 00 00 00 00 
<4>[ 4160.478274]   0320: 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.478533]   0336: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.478791]   0352: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.479050]   0368: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.479308]   0384: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.479567]   0400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.479826]   0416: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.480085]   0432: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.480344]   0448: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.480603]   0464: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.480862]   0480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.481121]   0496: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.481380]   0512: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.481638]   0528: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.481896]   0544: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.482155]   0560: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.482414]   0576: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.482673]   0592: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.482932]   0608: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.483192]   0624: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.483451]   0640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.483709]   0656: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.483968]   0672: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.505477]   0688: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.505784]   0704: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.506053]   0720: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.506315]   0736: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.506574]   0752: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.506834]   0768: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.507092]   0784: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.507350]   0800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.507609]   0816: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.507867]   0832: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.508126]   0848: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.508385]   0864: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.508645]   0880: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 
<4>[ 4160.508910]   0896: 58 6b c3 c3 58 6b c3 c3 01 00 00 00 64 6b c3 c3 
<4>[ 4160.509176]   0912: 64 6b c3 c3 01 00 00 00 70 6b c3 c3 70 6b c3 c3 
<4>[ 4160.509440]   0928: 01 00 00 00 7c 6b c3 c3 7c 6b c3 c3 00 00 00 00 
<4>[ 4160.509699]   0944: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.509958]   0960: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.510217]   0976: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.510476]   0992: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.510735]   1008: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4160.531987] dhd_watchdog_thread:
<4>[ 4160.532149] dhd_bus_watchdog: Enter
<4>[ 4160.532280] dhdsdio_clkctl: Enter
<4>[ 4160.532402] dhdsdio_htclk: Enter
<4>[ 4160.532625] CLKCTL: turned OFF
<4>[ 4160.532759] dhdsdio_sdclk: Enter
<4>[ 4160.532888] dhdsdio_clkctl: 3 -> 0
<4>[ 4160.533182] dhdcdc_cmplt: Enter
<4>[ 4160.533322] dhd_bus_rxctl: Enter
<4>[ 4161.004566] dhd_start_xmit: Enter
<4>[ 4161.004737] dhd_prot_hdrpush: Enter
<4>[ 4161.004873] dhd_bus_txdata: Enter
<4>[ 4161.005002] dhd_bus_txdata: deferring pktq len 0
<4>[ 4161.005257] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4161.005425] dhdsdio_dpc: Enter
<4>[ 4161.005543] dhdsdio_clkctl: Enter
<4>[ 4161.005664] dhdsdio_sdclk: Enter
<4>[ 4161.005782] dhdsdio_htclk: Enter
<4>[ 4161.006071] CLKCTL: turned ON
<4>[ 4161.006215] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.006348] dhdsdio_sendfromq: Enter
<4>[ 4161.006480] dhdsdio_txpkt: Enter
<4>[ 4161.006600] Tx Frame:
<4>[ 4161.006782]   0000: 58 00 a7 ff 1f 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4161.007047]   0016: 00 00 33 33 00 00 00 02 00 26 37 82 86 b6 86 dd 
<4>[ 4161.007309]   0032: 60 00 00 00 00 10 3a ff fe 80 00 00 00 00 00 00 
<4>[ 4161.007571]   0048: 02 26 37 ff fe 82 86 b6 ff 02 00 00 00 00 00 00 
<4>[ 4161.007832]   0064: 00 00 00 00 00 00 00 02 85 00 fe 70 00 00 00 00 
<4>[ 4161.008055]   0080: 01 01 00 26 37 82 86 b6 
<4>[ 4161.008461] dhd_prot_hdrpull: Enter
<4>[ 4161.008779] dhdsdio_isr: Enter
<4>[ 4161.008917] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.009073] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.009223] dhdsdio_dpc: Enter
<4>[ 4161.009337] dhdsdio_clkctl: Enter
<4>[ 4161.009705] dhdsdio_readframes: Enter
<4>[ 4161.009990] RxHdr:
<4>[ 4161.010170]   0000: a0 03 5f fc 1e 00 00 0c 00 2b 00 00 
<4>[ 4161.010339] dhdsdio_read_control: Enter
<4>[ 4161.010720] RxCtrl:
<4>[ 4161.010927]   0000: a0 03 5f fc 1e 00 00 0c 00 2b 00 00 d9 00 00 00 
<4>[ 4161.011196]   0016: 84 03 00 00 00 00 1e 00 00 00 00 00 0d 00 00 00 
<4>[ 4161.011457]   0032: 01 00 00 00 02 00 00 00 03 00 00 00 04 00 00 00 
<4>[ 4161.011717]   0048: 05 00 00 00 06 00 00 00 07 00 00 00 08 00 00 00 
<4>[ 4161.011977]   0064: 09 00 00 00 0a 00 00 00 0b 00 00 00 0c 00 00 00 
<4>[ 4161.012240]   0080: 0d 00 00 00 2c fc 1f c6 00 00 00 00 70 74 73 30 
<4>[ 4161.012497]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.012755]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.013012]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.013270]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.013528]   0160: 00 00 00 00 84 00 04 00 00 00 00 00 00 00 00 00 
<4>[ 4161.013789]   0176: 00 00 00 00 00 00 00 00 ff 0f 00 00 00 64 c3 c3 
<4>[ 4161.014052]   0192: 00 00 00 00 00 02 00 00 ac 68 c3 c3 ac 68 c3 c3 
<4>[ 4161.014484]   0208: 60 8e 39 c0 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.014767]   0224: 00 00 00 00 00 00 00 00 cc 68 c3 c3 cc 68 c3 c3 
<4>[ 4161.015037]   0240: d4 68 c3 c3 d4 68 c3 c3 00 00 00 00 e0 68 c3 c3 
<4>[ 4161.015304]   0256: e0 68 c3 c3 04 0a 39 c0 00 00 00 00 30 3c da c9 
<4>[ 4161.015570]   0272: f4 68 c3 c3 f4 68 c3 c3 00 00 00 00 10 00 01 00 
<4>[ 4161.015832]   0288: d4 e3 05 00 00 00 00 00 18 24 ee 14 00 00 00 00 
<4>[ 4161.016091]   0304: 00 00 00 00 00 00 00 80 00 00 00 00 00 00 00 00 
<4>[ 4161.016349]   0320: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.016607]   0336: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.016865]   0352: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.017123]   0368: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.017381]   0384: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.017639]   0400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.017897]   0416: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.018155]   0432: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.018412]   0448: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.018671]   0464: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.018929]   0480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.019186]   0496: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.019444]   0512: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.019701]   0528: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.019958]   0544: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.020216]   0560: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.020473]   0576: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.020732]   0592: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.020989]   0608: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.021247]   0624: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.021503]   0640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.021761]   0656: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.022019]   0672: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.022276]   0688: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.022534]   0704: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.022791]   0720: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.023048]   0736: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.023362]   0752: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.023630]   0768: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.023892]   0784: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.024150]   0800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.024509]   0816: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.024784]   0832: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.025045]   0848: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.025303]   0864: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.025569]   0880: 01 00 00 00 58 6b c3 c3 58 6b c3 c3 01 00 00 00 
<4>[ 4161.025834]   0896: 64 6b c3 c3 64 6b c3 c3 01 00 00 00 70 6b c3 c3 
<4>[ 4161.026100]   0912: 70 6b c3 c3 01 00 00 00 7c 6b c3 c3 7c 6b c3 c3 
<4>[ 4161.026453] RxHdr:
<4>[ 4161.026632]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.026804] dhdsdio_readframes: processed 1 frames
<4>[ 4161.026966] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.027193] dhd_watchdog_thread:
<4>[ 4161.027324] dhd_bus_watchdog: Enter
<4>[ 4161.027450] dhdsdio_clkctl: Enter
<4>[ 4161.027569] dhdsdio_htclk: Enter
<4>[ 4161.027780] CLKCTL: turned OFF
<4>[ 4161.027913] dhdsdio_sdclk: Enter
<4>[ 4161.028044] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.028402] dhd_bus_rxctl: resumed on rxctl frame, got 916 expected 916
<4>[ 4161.028710] 
<4>[ 4161.028731] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x72, 
buf:c2297db0, len:20 ,
<4>[ 4161.029050] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.029217] dhd_prot_ioctl: Enter
<4>[ 4161.029340] dhdcdc_query_ioctl: Enter
<4>[ 4161.029474] dhdcdc_query_ioctl: cmd 114 len 20
<4>[ 4161.029615] dhdcdc_msg: Enter
<4>[ 4161.029725] dhd_bus_txctl: Enter
<4>[ 4161.029843] dhdsdio_clkctl: Enter
<4>[ 4161.029960] dhdsdio_sdclk: Enter
<4>[ 4161.030075] dhdsdio_htclk: Enter
<4>[ 4161.033270] dhdsdio_isr: Enter
<4>[ 4161.033425] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.033584] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.033737] dhdsdio_dpc: Enter
<4>[ 4161.034602] CLKCTL: turned ON
<4>[ 4161.034768] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.034898] Tx Frame:
<4>[ 4161.035081]   0000: 3c 00 c3 ff 20 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.035343]   0016: 00 00 00 00 00 00 00 00 72 00 00 00 14 00 00 00 
<4>[ 4161.035606]   0032: 00 00 1f 00 00 00 00 00 8f 11 73 54 40 a0 75 c0 
<4>[ 4161.035869]   0048: 02 00 00 00 00 d2 18 c0 20 86 8c c0 05 00 00 00 
<4>[ 4161.036273] dhdsdio_clkctl: Enter
<4>[ 4161.036663] Dongle reports CHIPACTIVE
<4>[ 4161.036817] dhdsdio_readframes: Enter
<4>[ 4161.037089] RxHdr:
<4>[ 4161.037267]   0000: 30 00 cf ff 1f 00 00 0c 00 2d 00 00 
<4>[ 4161.037436] dhdsdio_read_control: Enter
<4>[ 4161.037565] RxCtrl:
<4>[ 4161.037744]   0000: 30 00 cf ff 1f 00 00 0c 00 2d 00 00 72 00 00 00 
<4>[ 4161.038005]   0016: 14 00 00 00 00 00 1f 00 00 00 00 00 0c 00 00 00 
<4>[ 4161.038272]   0032: 82 84 8b 0c 12 96 18 24 30 48 60 6c 20 86 8c c0 
<4>[ 4161.038593] RxHdr:
<4>[ 4161.038767]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.038936] dhdsdio_readframes: processed 1 frames
<4>[ 4161.039098] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.039350] dhdcdc_cmplt: Enter
<4>[ 4161.039481] dhd_bus_rxctl: Enter
<4>[ 4161.039619] dhd_bus_rxctl: resumed on rxctl frame, got 36 expected 36
<4>[ 4161.039903] 
<4>[ 4161.039924] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c2c, len:6 ,
<4>[ 4161.040238] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.040401] dhd_prot_ioctl: Enter
<4>[ 4161.040525] dhdcdc_query_ioctl: Enter
<4>[ 4161.040658] dhdcdc_query_ioctl: cmd 262 len 6
<4>[ 4161.040797] dhdcdc_msg: Enter
<4>[ 4161.040907] dhd_bus_txctl: Enter
<4>[ 4161.041026] dhdsdio_clkctl: Enter
<4>[ 4161.041148] Tx Frame:
<4>[ 4161.041329]   0000: 2e 00 d1 ff 21 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.041589]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 06 00 00 00 
<4>[ 4161.041850]   0032: 00 00 20 00 00 00 00 00 6e 6d 6f 64 65 00 8b 0c 
<4>[ 4161.042115]   0048: 12 96 18 24 30 48 60 6c 20 86 8c c0 05 00 00 00 
<4>[ 4161.044585] dhdsdio_isr: Enter
<4>[ 4161.044743] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.044901] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.045054] dhdsdio_dpc: Enter
<4>[ 4161.051117] dhd_watchdog_thread:
<4>[ 4161.051276] dhd_bus_watchdog: Enter
<4>[ 4161.051408] dhdsdio_clkctl: Enter
<4>[ 4161.051528] dhdsdio_htclk: Enter
<4>[ 4161.051763] CLKCTL: turned OFF
<4>[ 4161.051900] dhdsdio_sdclk: Enter
<4>[ 4161.052030] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.052190] dhdsdio_clkctl: Enter
<4>[ 4161.052317] dhdsdio_sdclk: Enter
<4>[ 4161.052435] dhdsdio_htclk: Enter
<4>[ 4161.052760] CLKCTL: turned ON
<4>[ 4161.052908] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.053281] dhdsdio_readframes: Enter
<4>[ 4161.053571] RxHdr:
<4>[ 4161.053751]   0000: 22 00 dd ff 20 00 00 0c 00 2e 00 00 
<4>[ 4161.053919] dhdsdio_read_control: Enter
<4>[ 4161.054051] RxCtrl:
<4>[ 4161.054412]   0000: 22 00 dd ff 20 00 00 0c 00 2e 00 00 06 01 00 00 
<4>[ 4161.054701]   0016: 00 00 00 00 01 00 20 00 e9 ff ff ff 6e 6d 6f 64 
<4>[ 4161.054900]   0032: 65 00 
<4>[ 4161.055163] RxHdr:
<4>[ 4161.055340]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.055510] dhdsdio_readframes: processed 1 frames
<4>[ 4161.055671] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.055895] dhd_watchdog_thread:
<4>[ 4161.056022] dhd_bus_watchdog: Enter
<4>[ 4161.056149] dhdsdio_clkctl: Enter
<4>[ 4161.056267] dhdsdio_htclk: Enter
<4>[ 4161.056477] CLKCTL: turned OFF
<4>[ 4161.056612] dhdsdio_sdclk: Enter
<4>[ 4161.056741] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.056985] dhdcdc_cmplt: Enter
<4>[ 4161.057120] dhd_bus_rxctl: Enter
<4>[ 4161.057258] dhd_bus_rxctl: resumed on rxctl frame, got 22 expected 22
<4>[ 4161.057513] 
<4>[ 4161.057534] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x27, 
buf:c2297da8, len:4 ,
<4>[ 4161.057845] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.058010] dhd_prot_ioctl: Enter
<4>[ 4161.058132] dhdcdc_query_ioctl: Enter
<4>[ 4161.058266] dhdcdc_query_ioctl: cmd 39 len 4
<4>[ 4161.058404] dhdcdc_msg: Enter
<4>[ 4161.058513] dhd_bus_txctl: Enter
<4>[ 4161.058632] dhdsdio_clkctl: Enter
<4>[ 4161.058748] dhdsdio_sdclk: Enter
<4>[ 4161.058862] dhdsdio_htclk: Enter
<4>[ 4161.062067] dhdsdio_isr: Enter
<4>[ 4161.062223] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.062379] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.062532] dhdsdio_dpc: Enter
<4>[ 4161.062813] CLKCTL: turned ON
<4>[ 4161.062962] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.063089] Tx Frame:
<4>[ 4161.063273]   0000: 2c 00 d3 ff 22 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.063536]   0016: 00 00 00 00 00 00 00 00 27 00 00 00 04 00 00 00 
<4>[ 4161.063799]   0032: 00 00 21 00 00 00 00 00 bc 7c e9 a3 65 00 8b 0c 
<4>[ 4161.064064]   0048: 12 96 18 24 30 48 60 6c 20 86 8c c0 05 00 00 00 
<4>[ 4161.064660] dhdsdio_clkctl: Enter
<4>[ 4161.065058] Dongle reports CHIPACTIVE
<4>[ 4161.065216] dhdsdio_readframes: Enter
<4>[ 4161.065492] RxHdr:
<4>[ 4161.065673]   0000: 20 00 df ff 21 00 00 0c 00 2f 00 00 
<4>[ 4161.065842] dhdsdio_read_control: Enter
<4>[ 4161.065974] RxCtrl:
<4>[ 4161.066150]   0000: 20 00 df ff 21 00 00 0c 00 2f 00 00 27 00 00 00 
<4>[ 4161.066411]   0016: 04 00 00 00 00 00 21 00 00 00 00 00 05 00 00 00 
<4>[ 4161.066732] RxHdr:
<4>[ 4161.066905]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.067075] dhdsdio_readframes: processed 1 frames
<4>[ 4161.067235] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.067462] dhd_watchdog_thread:
<4>[ 4161.067589] dhd_bus_watchdog: Enter
<4>[ 4161.067714] dhdsdio_clkctl: Enter
<4>[ 4161.067832] dhdsdio_htclk: Enter
<4>[ 4161.068047] CLKCTL: turned OFF
<4>[ 4161.068179] dhdsdio_sdclk: Enter
<4>[ 4161.068307] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.068512] dhdcdc_cmplt: Enter
<4>[ 4161.068642] dhd_bus_rxctl: Enter
<4>[ 4161.068778] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4161.069034] 
<4>[ 4161.069055] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x27, 
buf:c2297dac, len:4 ,
<4>[ 4161.069362] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.069526] dhd_prot_ioctl: Enter
<4>[ 4161.069647] dhdcdc_query_ioctl: Enter
<4>[ 4161.069780] dhdcdc_query_ioctl: cmd 39 len 4
<4>[ 4161.069917] dhdcdc_msg: Enter
<4>[ 4161.070028] dhd_bus_txctl: Enter
<4>[ 4161.070146] dhdsdio_clkctl: Enter
<4>[ 4161.070262] dhdsdio_sdclk: Enter
<4>[ 4161.070376] dhdsdio_htclk: Enter
<4>[ 4161.073572] dhdsdio_isr: Enter
<4>[ 4161.073729] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.073884] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.074036] dhdsdio_dpc: Enter
<4>[ 4161.074424] CLKCTL: turned ON
<4>[ 4161.074647] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.074784] Tx Frame:
<4>[ 4161.074969]   0000: 2c 00 d3 ff 23 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.075230]   0016: 00 00 00 00 00 00 00 00 27 00 00 00 04 00 00 00 
<4>[ 4161.075491]   0032: 00 00 22 00 00 00 00 00 0c 00 00 00 65 00 8b 0c 
<4>[ 4161.075755]   0048: 12 96 18 24 30 48 60 6c 20 86 8c c0 05 00 00 00 
<4>[ 4161.076365] dhdsdio_clkctl: Enter
<4>[ 4161.076822] Dongle reports CHIPACTIVE
<4>[ 4161.076980] dhdsdio_readframes: Enter
<4>[ 4161.077264] RxHdr:
<4>[ 4161.077445]   0000: 20 00 df ff 22 00 00 0c 00 30 00 00 
<4>[ 4161.077615] dhdsdio_read_control: Enter
<4>[ 4161.077746] RxCtrl:
<4>[ 4161.077924]   0000: 20 00 df ff 22 00 00 0c 00 30 00 00 27 00 00 00 
<4>[ 4161.078185]   0016: 04 00 00 00 00 00 22 00 00 00 00 00 05 00 00 00 
<4>[ 4161.078509] RxHdr:
<4>[ 4161.078683]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.078855] dhdsdio_readframes: processed 1 frames
<4>[ 4161.079017] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.079269] dhdcdc_cmplt: Enter
<4>[ 4161.079396] dhd_bus_rxctl: Enter
<4>[ 4161.079533] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4161.079836] eth0: SIOCGIWMODE
<4>[ 4161.080008] 
<4>[ 4161.080028] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x13, 
buf:c2297ddc, len:4 ,
<4>[ 4161.080335] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.080500] dhd_prot_ioctl: Enter
<4>[ 4161.080624] dhdcdc_query_ioctl: Enter
<4>[ 4161.080758] dhdcdc_query_ioctl: cmd 19 len 4
<4>[ 4161.080895] dhdcdc_msg: Enter
<4>[ 4161.081005] dhd_bus_txctl: Enter
<4>[ 4161.081124] dhdsdio_clkctl: Enter
<4>[ 4161.081245] Tx Frame:
<4>[ 4161.081425]   0000: 2c 00 d3 ff 24 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.081686]   0016: 00 00 00 00 00 00 00 00 13 00 00 00 04 00 00 00 
<4>[ 4161.081946]   0032: 00 00 23 00 00 00 00 00 00 00 00 00 65 00 8b 0c 
<4>[ 4161.082211]   0048: 12 96 18 24 30 48 60 6c 20 86 8c c0 05 00 00 00 
<4>[ 4161.094556] dhdsdio_isr: Enter
<4>[ 4161.094712] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.094871] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.095024] dhdsdio_dpc: Enter
<4>[ 4161.095213] dhd_watchdog_thread:
<4>[ 4161.095347] dhd_bus_watchdog: Enter
<4>[ 4161.095473] dhdsdio_clkctl: Enter
<4>[ 4161.095593] dhdsdio_htclk: Enter
<4>[ 4161.095819] CLKCTL: turned OFF
<4>[ 4161.095954] dhdsdio_sdclk: Enter
<4>[ 4161.096083] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.096243] dhdsdio_clkctl: Enter
<4>[ 4161.096372] dhdsdio_sdclk: Enter
<4>[ 4161.096491] dhdsdio_htclk: Enter
<4>[ 4161.096814] CLKCTL: turned ON
<4>[ 4161.096962] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.097332] dhdsdio_readframes: Enter
<4>[ 4161.097619] RxHdr:
<4>[ 4161.097796]   0000: 20 00 df ff 23 00 00 0c 00 31 00 00 
<4>[ 4161.097963] dhdsdio_read_control: Enter
<4>[ 4161.098094] RxCtrl:
<4>[ 4161.098270]   0000: 20 00 df ff 23 00 00 0c 00 31 00 00 13 00 00 00 
<4>[ 4161.098530]   0016: 04 00 00 00 00 00 23 00 00 00 00 00 01 00 00 00 
<4>[ 4161.098851] RxHdr:
<4>[ 4161.099021]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.099190] dhdsdio_readframes: processed 1 frames
<4>[ 4161.099352] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.099604] dhdcdc_cmplt: Enter
<4>[ 4161.099735] dhd_bus_rxctl: Enter
<4>[ 4161.099874] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4161.100127] 
<4>[ 4161.100150] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x75, 
buf:c2297dd8, len:4 ,
<4>[ 4161.100461] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.100625] dhd_prot_ioctl: Enter
<4>[ 4161.100749] dhdcdc_query_ioctl: Enter
<4>[ 4161.100883] dhdcdc_query_ioctl: cmd 117 len 4
<4>[ 4161.101024] dhdcdc_msg: Enter
<4>[ 4161.101134] dhd_bus_txctl: Enter
<4>[ 4161.101252] dhdsdio_clkctl: Enter
<4>[ 4161.101375] Tx Frame:
<4>[ 4161.101557]   0000: 2c 00 d3 ff 25 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.101818]   0016: 00 00 00 00 00 00 00 00 75 00 00 00 04 00 00 00 
<4>[ 4161.102080]   0032: 00 00 24 00 00 00 00 00 00 00 00 00 65 00 8b 0c 
<4>[ 4161.102345]   0048: 12 96 18 24 30 48 60 6c 20 86 8c c0 05 00 00 00 
<4>[ 4161.102843] dhdsdio_isr: Enter
<4>[ 4161.102987] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.103142] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.103293] dhdsdio_dpc: Enter
<4>[ 4161.103475] dhdsdio_clkctl: Enter
<4>[ 4161.103863] dhdsdio_readframes: Enter
<4>[ 4161.104150] RxHdr:
<4>[ 4161.104499]   0000: 20 00 df ff 24 00 00 0c 00 32 00 00 
<4>[ 4161.104686] dhdsdio_read_control: Enter
<4>[ 4161.104822] RxCtrl:
<4>[ 4161.105003]   0000: 20 00 df ff 24 00 00 0c 00 32 00 00 75 00 00 00 
<4>[ 4161.105264]   0016: 04 00 00 00 00 00 24 00 00 00 00 00 00 00 00 00 
<4>[ 4161.105602] RxHdr:
<4>[ 4161.105780]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.105950] dhdsdio_readframes: processed 1 frames
<4>[ 4161.106111] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.106339] dhd_watchdog_thread:
<4>[ 4161.106468] dhd_bus_watchdog: Enter
<4>[ 4161.106595] dhdsdio_clkctl: Enter
<4>[ 4161.106716] dhdsdio_htclk: Enter
<4>[ 4161.106934] CLKCTL: turned OFF
<4>[ 4161.107068] dhdsdio_sdclk: Enter
<4>[ 4161.107199] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.107404] dhdcdc_cmplt: Enter
<4>[ 4161.107535] dhd_bus_rxctl: Enter
<4>[ 4161.107671] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4161.107943] eth0: SIOCSIWAP
<4>[ 4161.108111] 
<4>[ 4161.108133] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x34, 
buf:c2297d8c, len:12 ,
<4>[ 4161.108443] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.108607] dhd_prot_ioctl: Enter
<4>[ 4161.108730] dhdcdc_query_ioctl: Enter
<4>[ 4161.108866] dhdcdc_query_ioctl: cmd 52 len 12
<4>[ 4161.109007] dhdcdc_msg: Enter
<4>[ 4161.109116] dhd_bus_txctl: Enter
<4>[ 4161.109234] dhdsdio_clkctl: Enter
<4>[ 4161.109351] dhdsdio_sdclk: Enter
<4>[ 4161.109465] dhdsdio_htclk: Enter
<4>[ 4161.112578] dhdsdio_isr: Enter
<4>[ 4161.112729] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.112885] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.113040] dhdsdio_dpc: Enter
<4>[ 4161.114515] CLKCTL: turned ON
<4>[ 4161.114676] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.114806] Tx Frame:
<4>[ 4161.114990]   0000: 34 00 cb ff 26 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.115252]   0016: 00 00 00 00 00 00 00 00 34 00 00 00 0c 00 00 00 
<4>[ 4161.115512]   0032: 00 00 25 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.115777]   0048: 00 00 00 00 30 48 60 6c 20 86 8c c0 05 00 00 00 
<4>[ 4161.116181] dhdsdio_clkctl: Enter
<4>[ 4161.116572] Dongle reports CHIPACTIVE
<4>[ 4161.116729] dhdsdio_readframes: Enter
<4>[ 4161.117002] RxHdr:
<4>[ 4161.117180]   0000: 28 00 d7 ff 25 00 00 0c 00 33 00 00 
<4>[ 4161.117350] dhdsdio_read_control: Enter
<4>[ 4161.117483] RxCtrl:
<4>[ 4161.117663]   0000: 28 00 d7 ff 25 00 00 0c 00 33 00 00 34 00 00 00 
<4>[ 4161.117926]   0016: 0c 00 00 00 00 00 25 00 00 00 00 00 00 00 00 00 
<4>[ 4161.118147]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4161.118424] RxHdr:
<4>[ 4161.118598]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.118769] dhdsdio_readframes: processed 1 frames
<4>[ 4161.118932] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.119182] dhdcdc_cmplt: Enter
<4>[ 4161.119314] dhd_bus_rxctl: Enter
<4>[ 4161.119453] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4161.120394] dhd_get_stats: Enter
<4>[ 4161.121047] eth0: SIOCSIWAUTH
<4>[ 4161.121208] eth0: SIOCSIWAUTH, paramid = 0x7, paramval = 0x1
<4>[ 4161.121505] eth0: SIOCSIWENCODEEXT
<4>[ 4161.121698] 
<4>[ 4161.121720] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4161.122031] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.122195] dhd_prot_ioctl: Enter
<4>[ 4161.122316] dhdcdc_query_ioctl: Enter
<4>[ 4161.122451] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4161.122594] dhdcdc_msg: Enter
<4>[ 4161.122706] dhd_bus_txctl: Enter
<4>[ 4161.122827] dhdsdio_clkctl: Enter
<4>[ 4161.122951] Tx Frame:
<4>[ 4161.123133]   0000: cc 00 33 ff 27 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.123394]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4161.123655]   0032: 00 00 26 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.123913]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.124172]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.139435]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.139734]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.140001]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.140263]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.140524]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.140785]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.141044]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.141302]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.141568]   0208: 00 02 00 00 ac 68 c3 c3 ac 68 c3 c3 60 8e 39 c0 
<4>[ 4161.153458] dhdsdio_isr: Enter
<4>[ 4161.153614] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.153773] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.153926] dhdsdio_dpc: Enter
<4>[ 4161.154121] dhd_watchdog_thread:
<4>[ 4161.154358] dhd_bus_watchdog: Enter
<4>[ 4161.154504] dhdsdio_clkctl: Enter
<4>[ 4161.154628] dhdsdio_htclk: Enter
<4>[ 4161.154859] CLKCTL: turned OFF
<4>[ 4161.154995] dhdsdio_sdclk: Enter
<4>[ 4161.155126] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.155289] dhdsdio_clkctl: Enter
<4>[ 4161.155420] dhdsdio_sdclk: Enter
<4>[ 4161.155539] dhdsdio_htclk: Enter
<4>[ 4161.155872] CLKCTL: turned ON
<4>[ 4161.156022] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.156402] dhdsdio_readframes: Enter
<4>[ 4161.156692] RxHdr:
<4>[ 4161.156873]   0000: c0 00 3f ff 26 00 00 0c 00 34 00 00 
<4>[ 4161.157043] dhdsdio_read_control: Enter
<4>[ 4161.157400] RxCtrl:
<4>[ 4161.157603]   0000: c0 00 3f ff 26 00 00 0c 00 34 00 00 2d 00 00 00 
<4>[ 4161.157871]   0016: a4 00 00 00 00 00 26 00 00 00 00 00 00 00 00 00 
<4>[ 4161.158133]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.158395]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.158654]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.158913]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.159171]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.159431]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.159690]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.159949]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.160208]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.160468]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.160793] RxHdr:
<4>[ 4161.160968]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.161140] dhdsdio_readframes: processed 1 frames
<4>[ 4161.161304] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.161561] dhdcdc_cmplt: Enter
<4>[ 4161.161692] dhd_bus_rxctl: Enter
<4>[ 4161.161832] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4161.162158] eth0: SIOCSIWENCODEEXT
<4>[ 4161.162343] 
<4>[ 4161.162364] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4161.162677] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.162841] dhd_prot_ioctl: Enter
<4>[ 4161.162965] dhdcdc_query_ioctl: Enter
<4>[ 4161.163099] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4161.163242] dhdcdc_msg: Enter
<4>[ 4161.163353] dhd_bus_txctl: Enter
<4>[ 4161.163473] dhdsdio_clkctl: Enter
<4>[ 4161.163597] Tx Frame:
<4>[ 4161.163780]   0000: cc 00 33 ff 28 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.164042]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4161.175256]   0032: 00 00 27 00 00 00 00 00 01 00 00 00 00 00 00 00 
<4>[ 4161.175555]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.175823]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.176085]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.176422]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.176696]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.176959]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.177220]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.177479]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.177738]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.177996]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.178262]   0208: 00 02 00 00 ac 68 c3 c3 ac 68 c3 c3 60 8e 39 c0 
<4>[ 4161.193265] dhdsdio_isr: Enter
<4>[ 4161.193422] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.193583] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.193737] dhdsdio_dpc: Enter
<4>[ 4161.194749] dhd_watchdog_thread:
<4>[ 4161.194957] dhd_bus_watchdog: Enter
<4>[ 4161.195097] dhdsdio_clkctl: Enter
<4>[ 4161.195221] dhdsdio_htclk: Enter
<4>[ 4161.195453] CLKCTL: turned OFF
<4>[ 4161.195589] dhdsdio_sdclk: Enter
<4>[ 4161.195719] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.195880] dhdsdio_clkctl: Enter
<4>[ 4161.196009] dhdsdio_sdclk: Enter
<4>[ 4161.196128] dhdsdio_htclk: Enter
<4>[ 4161.196462] CLKCTL: turned ON
<4>[ 4161.196613] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.196985] dhdsdio_readframes: Enter
<4>[ 4161.197275] RxHdr:
<4>[ 4161.197456]   0000: c0 00 3f ff 27 00 00 0c 00 35 00 00 
<4>[ 4161.197626] dhdsdio_read_control: Enter
<4>[ 4161.197987] RxCtrl:
<4>[ 4161.198188]   0000: c0 00 3f ff 27 00 00 0c 00 35 00 00 2d 00 00 00 
<4>[ 4161.198456]   0016: a4 00 00 00 00 00 27 00 00 00 00 00 01 00 00 00 
<4>[ 4161.198720]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.198979]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.199239]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.199498]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.199757]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.200016]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.200275]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.200534]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.200793]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.201053]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.201379] RxHdr:
<4>[ 4161.201554]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.201724] dhdsdio_readframes: processed 1 frames
<4>[ 4161.201885] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.202407] dhdcdc_cmplt: Enter
<4>[ 4161.202557] dhd_bus_rxctl: Enter
<4>[ 4161.202706] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4161.203030] eth0: SIOCSIWENCODEEXT
<4>[ 4161.203216] 
<4>[ 4161.203238] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4161.203551] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.203716] dhd_prot_ioctl: Enter
<4>[ 4161.203840] dhdcdc_query_ioctl: Enter
<4>[ 4161.203976] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4161.204120] dhdcdc_msg: Enter
<4>[ 4161.204400] dhd_watchdog_thread:
<4>[ 4161.204544] dhd_bus_watchdog: Enter
<4>[ 4161.204674] dhdsdio_clkctl: Enter
<4>[ 4161.204796] dhdsdio_htclk: Enter
<4>[ 4161.205015] CLKCTL: turned OFF
<4>[ 4161.205149] dhdsdio_sdclk: Enter
<4>[ 4161.205281] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.212621] dhd_bus_txctl: Enter
<4>[ 4161.212783] dhdsdio_clkctl: Enter
<4>[ 4161.212910] dhdsdio_sdclk: Enter
<4>[ 4161.213027] dhdsdio_htclk: Enter
<4>[ 4161.216735] dhdsdio_isr: Enter
<4>[ 4161.216891] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.217047] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.217200] dhdsdio_dpc: Enter
<4>[ 4161.217347] CLKCTL: turned ON
<4>[ 4161.217482] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.217606] Tx Frame:
<4>[ 4161.217787]   0000: cc 00 33 ff 29 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.218050]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4161.218309]   0032: 00 00 28 00 00 00 00 00 02 00 00 00 00 00 00 00 
<4>[ 4161.218568]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.218827]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.219086]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.219345]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.219603]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.219862]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.220121]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.220379]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.220638]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.220897]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.221163]   0208: 00 02 00 00 ac 68 c3 c3 ac 68 c3 c3 60 8e 39 c0 
<4>[ 4161.239191] dhdsdio_clkctl: Enter
<4>[ 4161.239606] Dongle reports CHIPACTIVE
<4>[ 4161.239768] dhdsdio_readframes: Enter
<4>[ 4161.240043] RxHdr:
<4>[ 4161.240224]   0000: c0 00 3f ff 28 00 00 0c 00 36 00 00 
<4>[ 4161.240394] dhdsdio_read_control: Enter
<4>[ 4161.240749] RxCtrl:
<4>[ 4161.240950]   0000: c0 00 3f ff 28 00 00 0c 00 36 00 00 2d 00 00 00 
<4>[ 4161.241217]   0016: a4 00 00 00 00 00 28 00 00 00 00 00 02 00 00 00 
<4>[ 4161.241478]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.241738]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.241999]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.242258]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.242516]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.242775]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.243034]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.243293]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.243551]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.243811]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.244137] RxHdr:
<4>[ 4161.244421]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.244609] dhdsdio_readframes: processed 1 frames
<4>[ 4161.244776] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.245008] dhd_watchdog_thread:
<4>[ 4161.245140] dhd_bus_watchdog: Enter
<4>[ 4161.245267] dhdsdio_clkctl: Enter
<4>[ 4161.245387] dhdsdio_htclk: Enter
<4>[ 4161.245608] CLKCTL: turned OFF
<4>[ 4161.245742] dhdsdio_sdclk: Enter
<4>[ 4161.245873] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.246002] dhd_watchdog_thread:
<4>[ 4161.246122] dhd_bus_watchdog: Enter
<4>[ 4161.246476] dhdcdc_cmplt: Enter
<4>[ 4161.246618] dhd_bus_rxctl: Enter
<4>[ 4161.246763] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4161.247088] eth0: SIOCSIWENCODEEXT
<4>[ 4161.247272] 
<4>[ 4161.247293] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4161.247607] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.247773] dhd_prot_ioctl: Enter
<4>[ 4161.247896] dhdcdc_query_ioctl: Enter
<4>[ 4161.248033] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4161.248174] dhdcdc_msg: Enter
<4>[ 4161.248286] dhd_bus_txctl: Enter
<4>[ 4161.248405] dhdsdio_clkctl: Enter
<4>[ 4161.248523] dhdsdio_sdclk: Enter
<4>[ 4161.248638] dhdsdio_htclk: Enter
<4>[ 4161.258103] dhdsdio_isr: Enter
<4>[ 4161.258261] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.258416] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.258569] dhdsdio_dpc: Enter
<4>[ 4161.259381] CLKCTL: turned ON
<4>[ 4161.259544] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.259674] Tx Frame:
<4>[ 4161.259855]   0000: cc 00 33 ff 2a 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.260118]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4161.260379]   0032: 00 00 29 00 00 00 00 00 03 00 00 00 00 00 00 00 
<4>[ 4161.260639]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.260898]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.261157]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.261415]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.261674]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.261932]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.262191]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.262449]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.262709]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.262968]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.263234]   0208: 00 02 00 00 ac 68 c3 c3 ac 68 c3 c3 60 8e 39 c0 
<4>[ 4161.274102] dhdsdio_clkctl: Enter
<4>[ 4161.274626] Dongle reports CHIPACTIVE
<4>[ 4161.274790] dhdsdio_readframes: Enter
<4>[ 4161.275073] RxHdr:
<4>[ 4161.275252]   0000: c0 00 3f ff 29 00 00 0c 00 37 00 00 
<4>[ 4161.275423] dhdsdio_read_control: Enter
<4>[ 4161.275941] RxCtrl:
<4>[ 4161.276151]   0000: c0 00 3f ff 29 00 00 0c 00 37 00 00 2d 00 00 00 
<4>[ 4161.276419]   0016: a4 00 00 00 00 00 29 00 00 00 00 00 03 00 00 00 
<4>[ 4161.276679]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.276938]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.277199]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.277459]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.277719]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.277979]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.278238]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.278496]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.278823]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.279099]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.279439] RxHdr:
<4>[ 4161.279616]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.279787] dhdsdio_readframes: processed 1 frames
<4>[ 4161.279950] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.280179] dhd_watchdog_thread:
<4>[ 4161.280308] dhd_bus_watchdog: Enter
<4>[ 4161.280433] dhdsdio_clkctl: Enter
<4>[ 4161.280554] dhdsdio_htclk: Enter
<4>[ 4161.280771] CLKCTL: turned OFF
<4>[ 4161.280904] dhdsdio_sdclk: Enter
<4>[ 4161.281035] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.281437] dhdcdc_cmplt: Enter
<4>[ 4161.281581] dhd_bus_rxctl: Enter
<4>[ 4161.281724] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4161.282026] eth0: SIOCSIWAUTH
<4>[ 4161.282168] eth0: SIOCSIWAUTH, paramid = 0x4, paramval = 0x0
<4>[ 4161.282474] 
<4>[ 4161.282495] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:bf26e82c, len:25 ,
<4>[ 4161.282807] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.282973] dhd_prot_ioctl: Enter
<4>[ 4161.283098] dhdcdc_query_ioctl: Enter
<4>[ 4161.283233] dhdcdc_query_ioctl: cmd 263 len 25
<4>[ 4161.283375] dhdcdc_msg: Enter
<4>[ 4161.283486] dhd_bus_txctl: Enter
<4>[ 4161.283605] dhdsdio_clkctl: Enter
<4>[ 4161.283724] dhdsdio_sdclk: Enter
<4>[ 4161.283840] dhdsdio_htclk: Enter
<4>[ 4161.286942] dhdsdio_isr: Enter
<4>[ 4161.287093] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.287248] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.287399] dhdsdio_dpc: Enter
<4>[ 4161.294514] CLKCTL: turned ON
<4>[ 4161.294672] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.294800] Tx Frame:
<4>[ 4161.294984]   0000: 41 00 be ff 2b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.295247]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 19 00 00 00 
<4>[ 4161.295513]   0032: 00 00 2a 00 00 00 00 00 74 6b 69 70 5f 63 6f 75 
<4>[ 4161.295777]   0048: 6e 74 65 72 6d 65 61 73 75 72 65 73 00 00 00 00 
<4>[ 4161.296036]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.296296]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.296815] dhdsdio_clkctl: Enter
<4>[ 4161.297203] Dongle reports CHIPACTIVE
<4>[ 4161.297361] dhdsdio_readframes: Enter
<4>[ 4161.297637] RxHdr:
<4>[ 4161.297820]   0000: 35 00 ca ff 2a 00 00 0c 00 38 00 00 
<4>[ 4161.297988] dhdsdio_read_control: Enter
<4>[ 4161.298119] RxCtrl:
<4>[ 4161.298297]   0000: 35 00 ca ff 2a 00 00 0c 00 38 00 00 07 01 00 00 
<4>[ 4161.298562]   0016: 00 00 00 00 01 00 2a 00 e9 ff ff ff 74 6b 69 70 
<4>[ 4161.298831]   0032: 5f 63 6f 75 6e 74 65 72 6d 65 61 73 75 72 65 73 
<4>[ 4161.299038]   0048: 00 00 00 00 00 
<4>[ 4161.299305] RxHdr:
<4>[ 4161.299482]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.299653] dhdsdio_readframes: processed 1 frames
<4>[ 4161.299815] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.300069] dhdcdc_cmplt: Enter
<4>[ 4161.300200] dhd_bus_rxctl: Enter
<4>[ 4161.300336] dhd_bus_rxctl: resumed on rxctl frame, got 41 expected 41
<4>[ 4161.300560] wl_iw_set_wpaauth: tkip_countermeasures failed -95
<4>[ 4161.300788] eth0: SIOCSIWAUTH
<4>[ 4161.300922] eth0: SIOCSIWAUTH, paramid = 0x5, paramval = 0x1
<4>[ 4161.301222] 
<4>[ 4161.301244] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:bf26e82c, len:18 ,
<4>[ 4161.301555] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.301724] dhd_prot_ioctl: Enter
<4>[ 4161.301848] dhdcdc_query_ioctl: Enter
<4>[ 4161.301983] dhdcdc_query_ioctl: cmd 263 len 18
<4>[ 4161.302124] dhdcdc_msg: Enter
<4>[ 4161.302234] dhd_bus_txctl: Enter
<4>[ 4161.302353] dhdsdio_clkctl: Enter
<4>[ 4161.302479] Tx Frame:
<4>[ 4161.302661]   0000: 3a 00 c5 ff 2c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.302923]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 12 00 00 00 
<4>[ 4161.303186]   0032: 00 00 2b 00 00 00 00 00 77 73 65 63 5f 72 65 73 
<4>[ 4161.303450]   0048: 74 72 69 63 74 00 01 00 00 00 65 73 00 00 00 00 
<4>[ 4161.303793] dhdcdc_cmplt: Enter
<4>[ 4161.304078] dhdsdio_isr: Enter
<4>[ 4161.304213] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.304510] dhd_watchdog_thread:
<4>[ 4161.304651] dhd_bus_watchdog: Enter
<4>[ 4161.304779] dhdsdio_clkctl: Enter
<4>[ 4161.304898] dhdsdio_htclk: Enter
<4>[ 4161.305116] CLKCTL: turned OFF
<4>[ 4161.305252] dhdsdio_sdclk: Enter
<4>[ 4161.305382] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.305544] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.305705] dhdsdio_dpc: Enter
<4>[ 4161.305822] dhdsdio_clkctl: Enter
<4>[ 4161.305942] dhdsdio_sdclk: Enter
<4>[ 4161.306059] dhdsdio_htclk: Enter
<4>[ 4161.306387] CLKCTL: turned ON
<4>[ 4161.306537] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.306911] dhdsdio_readframes: Enter
<4>[ 4161.307197] RxHdr:
<4>[ 4161.307380]   0000: 2e 00 d1 ff 2b 00 00 0c 00 39 00 00 
<4>[ 4161.307548] dhdsdio_read_control: Enter
<4>[ 4161.307680] RxCtrl:
<4>[ 4161.307860]   0000: 2e 00 d1 ff 2b 00 00 0c 00 39 00 00 07 01 00 00 
<4>[ 4161.308125]   0016: 12 00 00 00 00 00 2b 00 00 00 00 00 77 73 65 63 
<4>[ 4161.308382]   0032: 5f 72 65 73 74 72 69 63 74 00 01 00 00 00 
<4>[ 4161.308697] RxHdr:
<4>[ 4161.308871]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.309043] dhdsdio_readframes: processed 1 frames
<4>[ 4161.309207] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.309458] dhd_bus_rxctl: Enter
<4>[ 4161.309608] dhd_bus_rxctl: resumed on rxctl frame, got 34 expected 34
<4>[ 4161.309892] eth0: SIOCSIWPMKSA
<4>[ 4161.310021] wl_iw_set_pmksa - IW_PMKSA_FLUSH
<4>[ 4161.310170] PRINTING pmkid LIST - No of elements 0, ret = 0
<4>[ 4161.310328] 
<4>[ 4161.310545] 
<4>[ 4161.310567] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:bf26e82c, len:371 ,
<4>[ 4161.310878] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.311048] dhd_prot_ioctl: Enter
<4>[ 4161.311171] dhdcdc_query_ioctl: Enter
<4>[ 4161.311308] dhdcdc_query_ioctl: cmd 263 len 371
<4>[ 4161.311453] dhdcdc_msg: Enter
<4>[ 4161.311566] dhd_bus_txctl: Enter
<4>[ 4161.311686] dhdsdio_clkctl: Enter
<4>[ 4161.311810] Tx Frame:
<4>[ 4161.311993]   0000: 9b 01 64 fe 2d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.312255]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 73 01 00 00 
<4>[ 4161.312520]   0032: 00 00 2c 00 00 00 00 00 70 6d 6b 69 64 5f 69 6e 
<4>[ 4161.312781]   0048: 66 6f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.313040]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.313298]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.313556]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.313815]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.317939]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.318239]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.318505]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.318767]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.319027]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.319286]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.319545]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.319803]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.320063]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.320320]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.320579]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.320838]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.321096]   0320: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.321354]   0336: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.321613]   0352: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.321871]   0368: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.322129]   0384: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.322387]   0400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.335043] dhd_watchdog_thread:
<4>[ 4161.335233] dhd_bus_watchdog: Enter
<4>[ 4161.335372] dhdsdio_clkctl: Enter
<4>[ 4161.335493] dhdsdio_htclk: Enter
<4>[ 4161.335709] CLKCTL: turned OFF
<4>[ 4161.335844] dhdsdio_sdclk: Enter
<4>[ 4161.335975] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.336260] dhdsdio_isr: Enter
<4>[ 4161.336399] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.336555] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.336710] dhdsdio_dpc: Enter
<4>[ 4161.336826] dhdsdio_clkctl: Enter
<4>[ 4161.336947] dhdsdio_sdclk: Enter
<4>[ 4161.337064] dhdsdio_htclk: Enter
<4>[ 4161.337344] CLKCTL: turned ON
<4>[ 4161.337490] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.337857] dhdsdio_readframes: Enter
<4>[ 4161.338144] RxHdr:
<4>[ 4161.338324]   0000: 8f 01 70 fe 2c 00 00 0c 00 3a 00 00 
<4>[ 4161.338494] dhdsdio_read_control: Enter
<4>[ 4161.339225] RxCtrl:
<4>[ 4161.339433]   0000: 8f 01 70 fe 2c 00 00 0c 00 3a 00 00 07 01 00 00 
<4>[ 4161.339701]   0016: 73 01 00 00 00 00 2c 00 00 00 00 00 70 6d 6b 69 
<4>[ 4161.339967]   0032: 64 5f 69 6e 66 6f 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.340227]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.340487]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.340746]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.341005]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.341263]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.341522]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.341782]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.342040]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.342300]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.342558]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.342817]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.343076]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.343335]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.343594]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.343852]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.344111]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.344547]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.344829]   0320: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.345094]   0336: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.345355]   0352: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.345616]   0368: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.345871]   0384: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.346205] RxHdr:
<4>[ 4161.346381]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.346553] dhdsdio_readframes: processed 1 frames
<4>[ 4161.346715] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.346942] dhd_watchdog_thread:
<4>[ 4161.347073] dhd_bus_watchdog: Enter
<4>[ 4161.347201] dhdsdio_clkctl: Enter
<4>[ 4161.347321] dhdsdio_htclk: Enter
<4>[ 4161.347539] CLKCTL: turned OFF
<4>[ 4161.347674] dhdsdio_sdclk: Enter
<4>[ 4161.347804] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.348029] dhdcdc_cmplt: Enter
<4>[ 4161.348162] dhd_bus_rxctl: Enter
<4>[ 4161.348303] dhd_bus_rxctl: resumed on rxctl frame, got 387 expected 387
<4>[ 4161.658656] eth0 wl_iw_iscan_get_scan buflen_from_user 8192:
<4>[ 4161.658860] eth0: SIOCGIWSCAN GET broadcast results
<4>[ 4161.659029] wl_iw_iscan_get_scan return to WE 0 bytes APs=0
<4>[ 4161.662255] eth0: SIOCSIWPRIV request CSCAN S, info->cmd:8b0c, info-
>flags:0
<4>[ 4161.662309]  dwrq->length:20
<4>[ 4161.662624] ### wl_iw_set_cscan: info->cmd:8b0c, info->flags:0, 
u.data=0xbebee974, u.len=20
<4>[ 4161.662907] BROADCAST SCAN  left=8
<4>[ 4161.663038] nssid=1 left_parse=8 67
<4>[ 4161.663176] End channel=1 left_parse=6 80
<4>[ 4161.663327] wl_iw_combined_scan_set nssid=1 nchan=1
<4>[ 4161.663512] 
<4>[ 4161.663533] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297b48, len:28 ,
<4>[ 4161.663838] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.664004] dhd_prot_ioctl: Enter
<4>[ 4161.664127] dhdcdc_query_ioctl: Enter
<4>[ 4161.664448] dhdcdc_query_ioctl: cmd 262 len 28
<4>[ 4161.664612] dhdcdc_msg: Enter
<4>[ 4161.664730] dhd_bus_txctl: Enter
<4>[ 4161.664852] dhdsdio_clkctl: Enter
<4>[ 4161.664970] dhdsdio_sdclk: Enter
<4>[ 4161.665086] dhdsdio_htclk: Enter
<4>[ 4161.668205] dhdsdio_isr: Enter
<4>[ 4161.668352] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.668509] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.668662] dhdsdio_dpc: Enter
<4>[ 4161.677989] CLKCTL: turned ON
<4>[ 4161.678157] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.678286] Tx Frame:
<4>[ 4161.678471]   0000: 44 00 bb ff 2e 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.678736]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 1c 00 00 00 
<4>[ 4161.679002]   0032: 00 00 2d 00 00 00 00 00 65 76 65 6e 74 5f 6d 73 
<4>[ 4161.679263]   0048: 67 73 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.679523]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.679783]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.687259] dhdsdio_clkctl: Enter
<4>[ 4161.687671] Dongle reports CHIPACTIVE
<4>[ 4161.687830] dhdsdio_readframes: Enter
<4>[ 4161.688104] RxHdr:
<4>[ 4161.688283]   0000: 38 00 c7 ff 2d 00 00 0c 00 3b 00 00 
<4>[ 4161.688451] dhdsdio_read_control: Enter
<4>[ 4161.688584] RxCtrl:
<4>[ 4161.688761]   0000: 38 00 c7 ff 2d 00 00 0c 00 3b 00 00 06 01 00 00 
<4>[ 4161.689024]   0016: 1c 00 00 00 00 00 2d 00 00 00 00 00 4b 1f b7 04 
<4>[ 4161.689285]   0032: 10 40 40 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.689506]   0048: 00 00 00 00 00 00 00 00 
<4>[ 4161.689787] RxHdr:
<4>[ 4161.689961]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.690130] dhdsdio_readframes: processed 1 frames
<4>[ 4161.690290] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.690517] dhd_watchdog_thread:
<4>[ 4161.690648] dhd_bus_watchdog: Enter
<4>[ 4161.690774] dhdsdio_clkctl: Enter
<4>[ 4161.690895] dhdsdio_htclk: Enter
<4>[ 4161.691107] CLKCTL: turned OFF
<4>[ 4161.691238] dhdsdio_sdclk: Enter
<4>[ 4161.691367] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.691575] dhdcdc_cmplt: Enter
<4>[ 4161.691707] dhd_bus_rxctl: Enter
<4>[ 4161.691845] dhd_bus_rxctl: resumed on rxctl frame, got 44 expected 44
<4>[ 4161.692087] 
<4>[ 4161.692109] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297b48, len:27 ,
<4>[ 4161.692422] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.692588] dhd_prot_ioctl: Enter
<4>[ 4161.692713] dhdcdc_query_ioctl: Enter
<4>[ 4161.692848] dhdcdc_query_ioctl: cmd 263 len 27
<4>[ 4161.692990] dhdcdc_msg: Enter
<4>[ 4161.693100] dhd_bus_txctl: Enter
<4>[ 4161.693220] dhdsdio_clkctl: Enter
<4>[ 4161.693338] dhdsdio_sdclk: Enter
<4>[ 4161.693452] dhdsdio_htclk: Enter
<4>[ 4161.696630] dhdsdio_isr: Enter
<4>[ 4161.696789] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.696950] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.697105] dhdsdio_dpc: Enter
<4>[ 4161.704581] CLKCTL: turned ON
<4>[ 4161.704749] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.704879] Tx Frame:
<4>[ 4161.705065]   0000: 43 00 bc ff 2f 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.705330]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 1b 00 00 00 
<4>[ 4161.705595]   0032: 00 00 2e 00 00 00 00 00 65 76 65 6e 74 5f 6d 73 
<4>[ 4161.705859]   0048: 67 73 00 4b 1f b7 04 10 40 40 00 00 00 00 00 00 
<4>[ 4161.706119]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.706379]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.706903] dhdsdio_clkctl: Enter
<4>[ 4161.707293] Dongle reports CHIPACTIVE
<4>[ 4161.707451] dhdsdio_readframes: Enter
<4>[ 4161.707725] RxHdr:
<4>[ 4161.707904]   0000: 37 00 c8 ff 2e 00 00 0c 00 3c 00 00 
<4>[ 4161.708075] dhdsdio_read_control: Enter
<4>[ 4161.708207] RxCtrl:
<4>[ 4161.708387]   0000: 37 00 c8 ff 2e 00 00 0c 00 3c 00 00 07 01 00 00 
<4>[ 4161.708651]   0016: 1b 00 00 00 00 00 2e 00 00 00 00 00 65 76 65 6e 
<4>[ 4161.708918]   0032: 74 5f 6d 73 67 73 00 4b 1f b7 04 10 40 40 00 00 
<4>[ 4161.709135]   0048: 00 00 00 00 00 00 00 
<4>[ 4161.709415] RxHdr:
<4>[ 4161.709591]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.709764] dhdsdio_readframes: processed 1 frames
<4>[ 4161.709927] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.710179] dhdcdc_cmplt: Enter
<4>[ 4161.710308] dhd_bus_rxctl: Enter
<4>[ 4161.710448] dhd_bus_rxctl: resumed on rxctl frame, got 43 expected 43
<4>[ 4161.710836] 
<4>[ 4161.710857] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2264854, len:154 ,
<4>[ 4161.711169] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.711338] dhd_prot_ioctl: Enter
<4>[ 4161.711463] dhdcdc_query_ioctl: Enter
<4>[ 4161.711601] dhdcdc_query_ioctl: cmd 263 len 154
<4>[ 4161.711747] dhdcdc_msg: Enter
<4>[ 4161.711857] dhd_bus_txctl: Enter
<4>[ 4161.711978] dhdsdio_clkctl: Enter
<4>[ 4161.712102] Tx Frame:
<4>[ 4161.712283]   0000: c2 00 3d ff 30 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.712546]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 9a 00 00 00 
<4>[ 4161.712810]   0032: 00 00 2f 00 00 00 00 00 69 73 63 61 6e 00 01 00 
<4>[ 4161.713071]   0048: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.713331]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.713593]   0080: 00 00 00 00 00 00 00 00 00 00 ff ff ff ff ff ff 
<4>[ 4161.713858]   0096: 02 00 ff ff ff ff ff ff ff ff 82 00 00 00 82 00 
<4>[ 4161.714118]   0112: 00 00 01 00 01 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.724701]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.725746]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.726041]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.726309]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.726570]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.726831]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.727428] dhd_watchdog_thread:
<4>[ 4161.727575] dhd_bus_watchdog: Enter
<4>[ 4161.727705] dhdsdio_clkctl: Enter
<4>[ 4161.727826] dhdsdio_htclk: Enter
<4>[ 4161.728038] CLKCTL: turned OFF
<4>[ 4161.728172] dhdsdio_sdclk: Enter
<4>[ 4161.728303] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.728468] dhdcdc_cmplt: Enter
<4>[ 4161.728592] dhd_bus_rxctl: Enter
<4>[ 4161.828356] dhdsdio_isr: Enter
<4>[ 4161.828514] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.828672] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.828826] dhdsdio_dpc: Enter
<4>[ 4161.828943] dhdsdio_clkctl: Enter
<4>[ 4161.829065] dhdsdio_sdclk: Enter
<4>[ 4161.829181] dhdsdio_htclk: Enter
<4>[ 4161.829459] CLKCTL: turned ON
<4>[ 4161.829607] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.829978] dhdsdio_readframes: Enter
<4>[ 4161.830265] RxHdr:
<4>[ 4161.830445]   0000: b6 00 49 ff 2f 00 00 0c 00 3d 00 00 
<4>[ 4161.830614] dhdsdio_read_control: Enter
<4>[ 4161.831025] RxCtrl:
<4>[ 4161.831232]   0000: b6 00 49 ff 2f 00 00 0c 00 3d 00 00 07 01 00 00 
<4>[ 4161.831501]   0016: 9a 00 00 00 00 00 2f 00 00 00 00 00 69 73 63 61 
<4>[ 4161.831764]   0032: 6e 00 01 00 00 00 01 00 00 00 00 00 00 00 00 00 
<4>[ 4161.832023]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.832284]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff ff 
<4>[ 4161.832551]   0080: ff ff ff ff 02 00 ff ff ff ff ff ff ff ff 82 00 
<4>[ 4161.832813]   0096: 00 00 82 00 00 00 01 00 00 2b 00 00 00 00 00 00 
<4>[ 4161.833071]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.833330]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.833588]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.833847]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.834059]   0176: 00 00 00 00 00 00 
<4>[ 4161.834516] RxHdr:
<4>[ 4161.834701]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.834877] dhdsdio_readframes: processed 1 frames
<4>[ 4161.835039] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.835264] dhd_watchdog_thread:
<4>[ 4161.835393] dhd_bus_watchdog: Enter
<4>[ 4161.835520] dhdsdio_clkctl: Enter
<4>[ 4161.835639] dhdsdio_htclk: Enter
<4>[ 4161.835855] CLKCTL: turned OFF
<4>[ 4161.835989] dhdsdio_sdclk: Enter
<4>[ 4161.836119] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.836377] dhd_bus_rxctl: resumed on rxctl frame, got 170 expected 170
<4>[ 4161.842309] eth0: SIOCSIWPRIV request MACADDR, info->cmd:8b0c, info-
>flags:0
<4>[ 4161.842363]  dwrq->length:4096
<4>[ 4161.842668] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297cbc, len:128 ,
<4>[ 4161.842963] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.843128] dhd_prot_ioctl: Enter
<4>[ 4161.843251] dhdcdc_query_ioctl: Enter
<4>[ 4161.843386] dhdcdc_query_ioctl: cmd 262 len 128
<4>[ 4161.843530] dhdcdc_msg: Enter
<4>[ 4161.843641] dhd_bus_txctl: Enter
<4>[ 4161.843762] dhdsdio_clkctl: Enter
<4>[ 4161.843880] dhdsdio_sdclk: Enter
<4>[ 4161.843996] dhdsdio_htclk: Enter
<4>[ 4161.848091] CLKCTL: turned ON
<4>[ 4161.848258] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.848389] Tx Frame:
<4>[ 4161.848572]   0000: a8 00 57 ff 31 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.848835]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 80 00 00 00 
<4>[ 4161.849101]   0032: 00 00 30 00 00 00 00 00 63 75 72 5f 65 74 68 65 
<4>[ 4161.849366]   0048: 72 61 64 64 72 00 00 00 00 00 00 00 ff ff ff ff 
<4>[ 4161.849628]   0064: 00 00 00 00 04 00 00 00 07 00 00 00 5b 20 34 31 
<4>[ 4161.849893]   0080: d8 43 26 c2 00 60 29 c2 00 00 00 00 50 5f 7b c0 
<4>[ 4161.850157]   0096: 20 cb 76 c0 00 00 00 00 93 00 00 60 d8 43 26 c2 
<4>[ 4161.850426]   0112: 98 1c 1d c0 d0 7e 29 c2 70 7e 29 c2 5c ee 24 c6 
<4>[ 4161.850691]   0128: 17 d6 11 85 91 4f e6 00 c9 03 00 00 08 a0 75 c0 
<4>[ 4161.850957]   0144: 00 60 29 c2 00 40 26 c2 13 00 00 a0 00 60 29 c2 
<4>[ 4161.851218]   0160: 00 60 06 c9 00 98 2a c9 00 00 00 00 00 00 00 00 
<4>[ 4161.851476]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.854709] dhd_watchdog_thread:
<4>[ 4161.854898] dhd_bus_watchdog: Enter
<4>[ 4161.855037] dhdsdio_clkctl: Enter
<4>[ 4161.855162] dhdsdio_htclk: Enter
<4>[ 4161.855376] CLKCTL: turned OFF
<4>[ 4161.855512] dhdsdio_sdclk: Enter
<4>[ 4161.855642] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.855895] dhdsdio_isr: Enter
<4>[ 4161.856031] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.856184] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.856336] dhdsdio_dpc: Enter
<4>[ 4161.856452] dhdsdio_clkctl: Enter
<4>[ 4161.856571] dhdsdio_sdclk: Enter
<4>[ 4161.856687] dhdsdio_htclk: Enter
<4>[ 4161.857011] CLKCTL: turned ON
<4>[ 4161.857160] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.857528] dhdsdio_readframes: Enter
<4>[ 4161.857817] RxHdr:
<4>[ 4161.857997]   0000: 9c 00 63 ff 30 00 00 0c 00 3e 00 00 
<4>[ 4161.858167] dhdsdio_read_control: Enter
<4>[ 4161.858528] RxCtrl:
<4>[ 4161.858730]   0000: 9c 00 63 ff 30 00 00 0c 00 3e 00 00 06 01 00 00 
<4>[ 4161.858999]   0016: 80 00 00 00 00 00 30 00 00 00 00 00 00 26 37 82 
<4>[ 4161.859267]   0032: 86 b6 68 65 72 61 64 64 72 00 00 00 00 00 00 00 
<4>[ 4161.859528]   0048: ff ff ff ff 00 00 00 00 04 00 00 00 07 00 00 00 
<4>[ 4161.859794]   0064: 5b 20 34 31 d8 43 26 c2 00 60 29 c2 00 00 00 00 
<4>[ 4161.860058]   0080: 50 5f 7b c0 20 cb 76 c0 00 00 00 00 93 00 00 60 
<4>[ 4161.860326]   0096: d8 43 26 c2 98 1c 1d c0 d0 7e 29 c2 70 7e 29 c2 
<4>[ 4161.860591]   0112: 5c ee 24 c6 17 d6 11 85 91 4f e6 00 c9 03 00 00 
<4>[ 4161.860857]   0128: 08 a0 75 c0 00 60 29 c2 00 40 26 c2 13 00 00 a0 
<4>[ 4161.861102]   0144: 00 60 29 c2 00 60 06 c9 00 98 2a c9 
<4>[ 4161.861401] RxHdr:
<4>[ 4161.861579]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.861751] dhdsdio_readframes: processed 1 frames
<4>[ 4161.861913] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.862168] dhdcdc_cmplt: Enter
<4>[ 4161.862299] dhd_bus_rxctl: Enter
<4>[ 4161.862440] dhd_bus_rxctl: resumed on rxctl frame, got 144 expected 144
<4>[ 4161.864417] dhd_watchdog_thread:
<4>[ 4161.864580] dhd_bus_watchdog: Enter
<4>[ 4161.864715] dhdsdio_clkctl: Enter
<4>[ 4161.864838] dhdsdio_htclk: Enter
<4>[ 4161.865064] CLKCTL: turned OFF
<4>[ 4161.865200] dhdsdio_sdclk: Enter
<4>[ 4161.865333] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.893841] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4161.893894]  dwrq->length:4096
<4>[ 4161.894199] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4161.894708] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.894896] dhd_prot_ioctl: Enter
<4>[ 4161.895095] dhdcdc_query_ioctl: Enter
<4>[ 4161.895250] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4161.895395] dhdcdc_msg: Enter
<4>[ 4161.895509] dhd_bus_txctl: Enter
<4>[ 4161.895631] dhdsdio_clkctl: Enter
<4>[ 4161.895749] dhdsdio_sdclk: Enter
<4>[ 4161.895865] dhdsdio_htclk: Enter
<4>[ 4161.896383] CLKCTL: turned ON
<4>[ 4161.896543] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.896670] Tx Frame:
<4>[ 4161.896853]   0000: 34 00 cb ff 32 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.897116]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4161.897378]   0032: 00 00 31 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.897640]   0048: 00 00 00 00 72 00 00 00 00 00 00 00 ff ff ff ff 
<4>[ 4161.904581] dhdsdio_isr: Enter
<4>[ 4161.904738] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.904897] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.905053] dhdsdio_dpc: Enter
<4>[ 4161.905242] dhd_watchdog_thread:
<4>[ 4161.905375] dhd_bus_watchdog: Enter
<4>[ 4161.905504] dhdsdio_clkctl: Enter
<4>[ 4161.905624] dhdsdio_htclk: Enter
<4>[ 4161.905849] CLKCTL: turned OFF
<4>[ 4161.905983] dhdsdio_sdclk: Enter
<4>[ 4161.906114] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.906274] dhdsdio_clkctl: Enter
<4>[ 4161.906403] dhdsdio_sdclk: Enter
<4>[ 4161.906524] dhdsdio_htclk: Enter
<4>[ 4161.906804] CLKCTL: turned ON
<4>[ 4161.906946] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.907310] dhdsdio_readframes: Enter
<4>[ 4161.907598] RxHdr:
<4>[ 4161.907779]   0000: 28 00 d7 ff 31 00 00 0c 00 3f 00 00 
<4>[ 4161.907948] dhdsdio_read_control: Enter
<4>[ 4161.908080] RxCtrl:
<4>[ 4161.908258]   0000: 28 00 d7 ff 31 00 00 0c 00 3f 00 00 7f 00 00 00 
<4>[ 4161.908519]   0016: 0c 00 00 00 00 00 31 00 00 00 00 00 00 00 00 00 
<4>[ 4161.908741]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4161.909020] RxHdr:
<4>[ 4161.909195]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.909366] dhdsdio_readframes: processed 1 frames
<4>[ 4161.909529] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.909780] dhdcdc_cmplt: Enter
<4>[ 4161.909913] dhd_bus_rxctl: Enter
<4>[ 4161.910052] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4161.910290] 
<4>[ 4161.910311] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4161.910621] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.910788] dhd_prot_ioctl: Enter
<4>[ 4161.910912] dhdcdc_query_ioctl: Enter
<4>[ 4161.911046] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4161.911186] dhdcdc_msg: Enter
<4>[ 4161.911296] dhd_bus_txctl: Enter
<4>[ 4161.911415] dhdsdio_clkctl: Enter
<4>[ 4161.911537] Tx Frame:
<4>[ 4161.911718]   0000: 4c 00 b3 ff 33 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.911979]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4161.912238]   0032: 00 00 32 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.912497]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.912758]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 5b 20 34 31 
<4>[ 4161.913023]   0080: d8 43 26 c2 00 60 29 c2 00 00 00 00 50 5f 7b c0 
<4>[ 4161.913633] dhdsdio_isr: Enter
<4>[ 4161.913780] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.913935] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.914088] dhdsdio_dpc: Enter
<4>[ 4161.914437] dhdsdio_clkctl: Enter
<4>[ 4161.914846] dhdsdio_readframes: Enter
<4>[ 4161.915136] RxHdr:
<4>[ 4161.915319]   0000: 40 00 bf ff 32 00 00 0c 00 40 00 00 
<4>[ 4161.915489] dhdsdio_read_control: Enter
<4>[ 4161.915621] RxCtrl:
<4>[ 4161.915798]   0000: 40 00 bf ff 32 00 00 0c 00 40 00 00 19 00 00 00 
<4>[ 4161.916062]   0016: 24 00 00 00 00 00 32 00 00 00 00 00 00 00 00 00 
<4>[ 4161.916325]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.916585]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.916912] RxHdr:
<4>[ 4161.917089]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.917259] dhdsdio_readframes: processed 1 frames
<4>[ 4161.917422] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.917649] dhd_watchdog_thread:
<4>[ 4161.917777] dhd_bus_watchdog: Enter
<4>[ 4161.917903] dhdsdio_clkctl: Enter
<4>[ 4161.918024] dhdsdio_htclk: Enter
<4>[ 4161.918237] CLKCTL: turned OFF
<4>[ 4161.918370] dhdsdio_sdclk: Enter
<4>[ 4161.918502] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.918712] dhdcdc_cmplt: Enter
<4>[ 4161.918844] dhd_bus_rxctl: Enter
<4>[ 4161.918982] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4161.919200] wl_iw_get_rssi ssid_len:0, rssi:0
<4>[ 4161.920230] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4161.920285]  dwrq->length:4096
<4>[ 4161.920613] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4161.920903] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4161.921068] dhd_prot_ioctl: Enter
<4>[ 4161.921194] dhdcdc_query_ioctl: Enter
<4>[ 4161.921329] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4161.921467] dhdcdc_msg: Enter
<4>[ 4161.921578] dhd_bus_txctl: Enter
<4>[ 4161.921699] dhdsdio_clkctl: Enter
<4>[ 4161.921819] dhdsdio_sdclk: Enter
<4>[ 4161.921935] dhdsdio_htclk: Enter
<4>[ 4161.925963] CLKCTL: turned ON
<4>[ 4161.926859] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.927015] Tx Frame:
<4>[ 4161.927205]   0000: 2c 00 d3 ff 34 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4161.927468]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4161.927730]   0032: 00 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.927990]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.937707] dhdsdio_isr: Enter
<4>[ 4161.937863] dhdsdio_isr: disable SDIO interrupts
<4>[ 4161.938022] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4161.938177] dhdsdio_dpc: Enter
<4>[ 4161.938507] dhd_watchdog_thread:
<4>[ 4161.938652] dhd_bus_watchdog: Enter
<4>[ 4161.938781] dhdsdio_clkctl: Enter
<4>[ 4161.938903] dhdsdio_htclk: Enter
<4>[ 4161.939134] CLKCTL: turned OFF
<4>[ 4161.939271] dhdsdio_sdclk: Enter
<4>[ 4161.939401] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.939564] dhdsdio_clkctl: Enter
<4>[ 4161.939693] dhdsdio_sdclk: Enter
<4>[ 4161.939811] dhdsdio_htclk: Enter
<4>[ 4161.940092] CLKCTL: turned ON
<4>[ 4161.940239] dhdsdio_clkctl: 0 -> 3
<4>[ 4161.940610] dhdsdio_readframes: Enter
<4>[ 4161.940895] RxHdr:
<4>[ 4161.941076]   0000: 20 00 df ff 33 00 00 0c 00 41 00 00 
<4>[ 4161.941243] dhdsdio_read_control: Enter
<4>[ 4161.941377] RxCtrl:
<4>[ 4161.941554]   0000: 20 00 df ff 33 00 00 0c 00 41 00 00 0c 00 00 00 
<4>[ 4161.941818]   0016: 04 00 00 00 00 00 33 00 00 00 00 00 6c 00 00 00 
<4>[ 4161.942144] RxHdr:
<4>[ 4161.942319]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4161.942489] dhdsdio_readframes: processed 1 frames
<4>[ 4161.942650] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4161.943049] dhdcdc_cmplt: Enter
<4>[ 4161.943193] dhd_bus_rxctl: Enter
<4>[ 4161.943333] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4161.944404] dhd_watchdog_thread:
<4>[ 4161.944564] dhd_bus_watchdog: Enter
<4>[ 4161.944698] dhdsdio_clkctl: Enter
<4>[ 4161.944818] dhdsdio_htclk: Enter
<4>[ 4161.945042] CLKCTL: turned OFF
<4>[ 4161.945178] dhdsdio_sdclk: Enter
<4>[ 4161.945311] dhdsdio_clkctl: 3 -> 0
<4>[ 4161.974202] eth0: SIOCSIWPRIV request RXFILTER-ADD 0, info->cmd:8b0c, 
info->flags:0
<4>[ 4161.974258]  dwrq->length:4096eth0: SIOCSIWPRIV request RXFILTER-ADD 1, 
info->cmd:8b0c, info->flags:0
<4>[ 4161.979521]  dwrq->length:4096eth0: SIOCSIWPRIV request RXFILTER-ADD 3, 
info->cmd:8b0c, info->flags:0
<4>[ 4161.984914]  dwrq->length:4096eth0: SIOCSIWPRIV request RXFILTER-START, 
info->cmd:8b0c, info->flags:0
<4>[ 4161.989182]  dwrq->length:4096eth0: SIOCSIWPRIV request BTCOEXSCAN-STOP, 
info->cmd:8b0c, info->flags:0
<4>[ 4161.994965]  dwrq->length:4096Unknown PRIVATE command: BTCOEXSCAN-STOP: 
ignored
<4>[ 4162.208043] eth0: SIOCSIWPRIV request SCAN-ACTIVE, info->cmd:8b0c, info-
>flags:0
<4>[ 4162.208098]  dwrq->length:4096eth0: active scan setting suppressed
<4>[ 4162.212517] eth0: SIOCSIWPRIV request SCAN-PASSIVE, info->cmd:8b0c, 
info->flags:0
<4>[ 4162.212573]  dwrq->length:4096eth0: passive scan setting suppressed
<4>[ 4162.376642] dhdsdio_isr: Enter
<4>[ 4162.376802] dhdsdio_isr: disable SDIO interrupts
<4>[ 4162.376960] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4162.377125] dhdsdio_dpc: Enter
<4>[ 4162.377246] dhdsdio_clkctl: Enter
<4>[ 4162.377367] dhdsdio_sdclk: Enter
<4>[ 4162.377484] dhdsdio_htclk: Enter
<4>[ 4162.377772] CLKCTL: turned ON
<4>[ 4162.377919] dhdsdio_clkctl: 0 -> 3
<4>[ 4162.378291] dhdsdio_readframes: Enter
<4>[ 4162.378575] RxHdr:
<4>[ 4162.378756]   0000: 5c 00 a3 ff 34 01 00 0e 00 41 00 00 
<4>[ 4162.379074] Rx Data:
<4>[ 4162.379278]   0000: 5c 00 a3 ff 34 01 00 0e 00 41 00 00 00 00 20 00 
<4>[ 4162.379551]   0016: 00 00 00 26 37 82 86 b6 02 26 37 82 86 b6 88 6c 
<4>[ 4162.379817]   0032: 80 01 00 68 00 00 10 18 00 01 00 02 00 00 00 00 
<4>[ 4162.380077]   0048: 00 1a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.380342]   0064: 00 00 32 08 0c 12 18 24 77 6c 30 00 00 00 00 00 
<4>[ 4162.380582]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.380742] dhd_prot_hdrpull: Enter
<4>[ 4162.380867] dhd_rx_frame: Enter
<4>[ 4162.381004] dhd_ifname2idx: return idx 0 for "wl0"
<4>[ 4162.381168] wl_host_event: MAC event 26, flags 0, status 0
<4>[ 4162.381375] EVENT: SCAN_COMPLETE, event ID = 26
<4>[ 4162.381519] MACEVENT: SCAN_COMPLETE
<4>[ 4162.381658] wl_iw_event: dev=eth0 event=26 
<4>[ 4162.382016] RxHdr:
<4>[ 4162.382200]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.382373] dhdsdio_readframes: processed 1 frames
<4>[ 4162.382537] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4162.383061] 
<4>[ 4162.383084] dev_wlc_ioctl, PID:9ed: send Local IOCTL -> dhd: cmd:0x106, 
buf:c9064004, len:2048 ,
<4>[ 4162.383412] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4162.383592] dhd_prot_ioctl: Enter
<4>[ 4162.383720] dhdcdc_query_ioctl: Enter
<4>[ 4162.383858] dhdcdc_query_ioctl: cmd 262 len 2048
<4>[ 4162.384019] dhdcdc_msg: Enter
<4>[ 4162.384134] dhd_bus_txctl: Enter
<4>[ 4162.384420] dhd_watchdog_thread:
<4>[ 4162.384566] dhd_bus_watchdog: Enter
<4>[ 4162.384694] dhdsdio_clkctl: Enter
<4>[ 4162.384815] dhdsdio_htclk: Enter
<4>[ 4162.385037] CLKCTL: turned OFF
<4>[ 4162.385170] dhdsdio_sdclk: Enter
<4>[ 4162.385301] dhdsdio_clkctl: 3 -> 0
<4>[ 4162.385491] dhdsdio_clkctl: Enter
<4>[ 4162.385623] dhdsdio_sdclk: Enter
<4>[ 4162.385743] dhdsdio_htclk: Enter
<4>[ 4162.386027] CLKCTL: turned ON
<4>[ 4162.386176] dhdsdio_clkctl: 0 -> 3
<4>[ 4162.386306] Tx Frame:
<4>[ 4162.386491]   0000: 06 06 f9 f9 35 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4162.386756]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 00 08 00 00 
<4>[ 4162.387023]   0032: 00 00 34 00 00 00 00 00 69 73 63 61 6e 72 65 73 
<4>[ 4162.387286]   0048: 75 6c 74 73 00 00 00 00 00 00 08 00 00 00 00 00 
<4>[ 4162.387546]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.387807]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.388067]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.388327]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.388587]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.388845]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.389104]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.389365]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.389624]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.389883]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.390144]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.390403]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.390662]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.390921]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.391181]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.391440]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.391699]   0320: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.391958]   0336: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.392217]   0352: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.392476]   0368: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.392735]   0384: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.392994]   0400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.393253]   0416: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.393512]   0432: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.393771]   0448: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.394031]   0464: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.413301]   0480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.414445]   0496: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.414741]   0512: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.415009]   0528: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.415273]   0544: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.415534]   0560: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.415793]   0576: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.416053]   0592: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.416312]   0608: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.416571]   0624: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.416830]   0640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.417089]   0656: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.417348]   0672: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.417607]   0688: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.417866]   0704: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.418125]   0720: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.418385]   0736: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.418644]   0752: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.418903]   0768: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.419162]   0784: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.419421]   0800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.419680]   0816: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.419939]   0832: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.420199]   0848: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.420458]   0864: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.420717]   0880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.420976]   0896: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.421236]   0912: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.421495]   0928: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.421754]   0944: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.422014]   0960: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.422273]   0976: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.422532]   0992: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.422791]   1008: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.423050]   1024: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.423309]   1040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.423569]   1056: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.423829]   1072: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.424090]   1088: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.452668]   1104: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.452969]   1120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.453238]   1136: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.453501]   1152: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.453762]   1168: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.454022]   1184: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.461995]   1200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.462295]   1216: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.462563]   1232: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.462827]   1248: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.463086]   1264: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.463345]   1280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.463606]   1296: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.463866]   1312: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.464125]   1328: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.483408]   1344: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.485318]   1360: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.485615]   1376: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.485883]   1392: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.486147]   1408: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.486408]   1424: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.486668]   1440: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.486927]   1456: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.487187]   1472: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.487446]   1488: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.487705]   1504: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.487964]   1520: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.488224]   1536: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.488483]   1552: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.488742]   1568: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.489000]   1584: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.489259]   1600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.489518]   1616: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.489778]   1632: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.490037]   1648: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.490296]   1664: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.490555]   1680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.490814]   1696: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.491074]   1712: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.491333]   1728: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.491593]   1744: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.491853]   1760: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.492111]   1776: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.492370]   1792: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.492630]   1808: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.492889]   1824: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.493148]   1840: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.493408]   1856: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.493667]   1872: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.493928]   1888: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.494188]   1904: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.504599]   1920: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.504899]   1936: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.505167]   1952: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.505430]   1968: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.505693]   1984: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.505953]   2000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.506214]   2016: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.506473]   2032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4162.507019] dhd_watchdog_thread:
<4>[ 4162.507173] dhd_bus_watchdog: Enter
<4>[ 4162.507306] dhdsdio_clkctl: Enter
<4>[ 4162.507427] dhdsdio_htclk: Enter
<4>[ 4162.507641] CLKCTL: turned OFF
<4>[ 4162.507777] dhdsdio_sdclk: Enter
<4>[ 4162.507908] dhdsdio_clkctl: 3 -> 0
<4>[ 4162.508074] dhdcdc_cmplt: Enter
<4>[ 4162.508200] dhd_bus_rxctl: Enter
<4>[ 4165.014449] dhd_start_xmit: Enter
<4>[ 4165.014620] dhd_prot_hdrpush: Enter
<4>[ 4165.014753] dhd_bus_txdata: Enter
<4>[ 4165.014880] dhd_bus_txdata: deferring pktq len 0
<4>[ 4165.015103] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4165.015270] dhdsdio_dpc: Enter
<4>[ 4165.015389] dhdsdio_clkctl: Enter
<4>[ 4165.015510] dhdsdio_sdclk: Enter
<4>[ 4165.015627] dhdsdio_htclk: Enter
<4>[ 4165.015922] CLKCTL: turned ON
<4>[ 4165.016069] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.016205] dhdsdio_sendfromq: Enter
<4>[ 4165.016340] dhdsdio_txpkt: Enter
<4>[ 4165.016464] Tx Frame:
<4>[ 4165.016647]   0000: 58 00 a7 ff 36 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4165.016972]   0016: 00 00 33 33 00 00 00 02 00 26 37 82 86 b6 86 dd 
<4>[ 4165.017247]   0032: 60 00 00 00 00 10 3a ff fe 80 00 00 00 00 00 00 
<4>[ 4165.017514]   0048: 02 26 37 ff fe 82 86 b6 ff 02 00 00 00 00 00 00 
<4>[ 4165.017773]   0064: 00 00 00 00 00 00 00 02 85 00 fe 70 00 00 00 00 
<4>[ 4165.017998]   0080: 01 01 00 26 37 82 86 b6 
<4>[ 4165.018369] dhd_prot_hdrpull: Enter
<4>[ 4165.018668] dhdsdio_isr: Enter
<4>[ 4165.018805] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.018960] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.019113] dhdsdio_dpc: Enter
<4>[ 4165.019231] dhdsdio_clkctl: Enter
<4>[ 4165.019603] dhdsdio_readframes: Enter
<4>[ 4165.019892] RxHdr:
<4>[ 4165.020071]   0000: 1c 08 e3 f7 35 00 00 0c 00 42 00 00 
<4>[ 4165.020239] dhdsdio_read_control: Enter
<4>[ 4165.020719] RxCtrl:
<4>[ 4165.020928]   0000: 1c 08 e3 f7 35 00 00 0c 00 42 00 00 06 01 00 00 
<4>[ 4165.021198]   0016: 00 08 00 00 00 00 34 00 00 00 00 00 00 00 00 00 
<4>[ 4165.021463]   0032: bc 07 00 00 6c 00 00 00 07 00 00 00 6c 00 00 00 
<4>[ 4165.021727]   0048: c4 00 00 00 00 1d 7e bd 45 a2 64 00 11 04 05 74 
<4>[ 4165.021989]   0064: 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.022247]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.022512]   0096: 0c 00 00 00 82 84 8b 96 24 30 48 6c 0c 12 18 60 
<4>[ 4165.022773]   0112: 00 00 00 00 02 2b 00 00 00 00 d8 ff a4 00 00 00 
<4>[ 4165.023032]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 
<4>[ 4165.023290]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.023553]   0160: 7c 00 00 00 45 00 00 00 00 05 74 6f 6d 33 71 01 
<4>[ 4165.023818]   0176: 08 82 84 8b 96 24 30 48 6c 03 01 02 2a 01 00 2f 
<4>[ 4165.024082]   0192: 01 00 32 04 0c 12 18 60 dd 09 00 10 18 02 00 13 
<4>[ 4165.024525]   0208: 00 00 00 dd 18 00 50 f2 01 01 00 00 50 f2 02 01 
<4>[ 4165.024811]   0224: 00 00 50 f2 02 01 00 00 50 f2 02 00 00 00 00 00 
<4>[ 4165.025080]   0240: 6c 00 00 00 cc 00 00 00 00 24 b2 86 f0 7c 64 00 
<4>[ 4165.025348]   0256: 01 04 0d 68 65 72 6f 6c 64 6f 77 21 21 21 21 21 
<4>[ 4165.025608]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.025872]   0288: 00 00 00 00 0c 00 00 00 82 84 8b 96 24 30 48 6c 
<4>[ 4165.026135]   0304: 0c 12 18 60 00 00 00 00 01 2b 00 00 00 00 bf ff 
<4>[ 4165.026394]   0320: a4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.026651]   0336: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.026912]   0352: 00 00 00 00 7c 00 00 00 4d 00 00 00 00 0d 68 65 
<4>[ 4165.027178]   0368: 72 6f 6c 64 6f 77 21 21 21 21 21 01 08 82 84 8b 
<4>[ 4165.027442]   0384: 96 24 30 48 6c 03 01 01 2a 01 00 2f 01 00 32 04 
<4>[ 4165.027705]   0400: 0c 12 18 60 dd 09 00 10 18 02 00 f0 00 00 00 dd 
<4>[ 4165.027969]   0416: 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 
<4>[ 4165.028230]   0432: 00 42 43 5e 00 62 32 2f 00 00 00 00 6c 00 00 00 
<4>[ 4165.028494]   0448: a4 00 00 00 00 1a 70 a2 7c 84 64 00 11 04 08 4f 
<4>[ 4165.028757]   0464: 72 73 6f 6e 44 6f 6d 00 00 00 00 00 00 00 00 00 
<4>[ 4165.029015]   0480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.029280]   0496: 0c 00 00 00 82 84 8b 96 0c 12 18 24 30 48 60 6c 
<4>[ 4165.029542]   0512: 00 00 00 00 06 2b 00 00 00 00 af ff a4 00 00 00 
<4>[ 4165.029801]   0528: 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 
<4>[ 4165.030060]   0544: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.030322]   0560: 7c 00 00 00 28 00 00 00 00 08 4f 72 73 6f 6e 44 
<4>[ 4165.030586]   0576: 6f 6d 01 04 82 84 8b 96 03 01 06 04 06 00 02 00 
<4>[ 4165.030850]   0592: 00 00 00 2a 01 00 32 08 0c 12 18 24 30 48 60 6c 
<4>[ 4165.031113]   0608: 6c 00 00 00 d8 01 00 00 68 7f 74 7d a4 3c 64 00 
<4>[ 4165.031375]   0624: 31 05 07 6c 69 6e 6b 73 79 73 00 00 00 00 00 00 
<4>[ 4165.031634]   0640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.031896]   0656: 00 00 00 00 0c 00 00 00 82 84 8b 96 0c 12 18 24 
<4>[ 4165.032158]   0672: 30 48 60 6c 00 00 00 00 06 2b 00 00 00 00 a5 ff 
<4>[ 4165.032417]   0688: a4 01 00 00 00 00 00 00 06 00 00 00 00 00 00 00 
<4>[ 4165.032676]   0704: 04 00 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.032937]   0720: 00 00 00 00 7c 00 00 00 5a 01 00 00 00 07 6c 69 
<4>[ 4165.033202]   0736: 6e 6b 73 79 73 01 08 82 84 8b 96 0c 12 18 24 03 
<4>[ 4165.033464]   0752: 01 06 20 01 00 30 18 01 00 00 0f ac 02 02 00 00 
<4>[ 4165.033726]   0768: 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 01 00 dd 
<4>[ 4165.033988]   0784: 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
<4>[ 4165.034345]   0800: 02 00 50 f2 04 01 00 00 50 f2 02 2a 01 00 32 04 
<4>[ 4165.034626]   0816: 30 48 60 6c dd 18 00 50 f2 02 01 01 02 00 03 a4 
<4>[ 4165.034892]   0832: 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 2d 1a 
<4>[ 4165.035154]   0848: 4c 10 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.035415]   0864: 00 00 00 00 00 00 00 00 00 00 3d 16 06 00 19 00 
<4>[ 4165.035672]   0880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.035934]   0896: 00 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 
<4>[ 4165.036197]   0912: 03 7f 04 01 00 20 00 00 00 07 06 47 42 20 01 0d 
<4>[ 4165.036461]   0928: 14 dd 93 00 50 f2 04 10 4a 00 01 10 10 44 00 01 
<4>[ 4165.036723]   0944: 02 10 41 00 01 00 10 3b 00 01 03 10 47 00 10 00 
<4>[ 4165.036986]   0960: 00 00 00 00 00 00 01 10 00 68 7f 74 7d a4 3c 10 
<4>[ 4165.037252]   0976: 21 00 13 4c 69 6e 6b 73 79 73 20 43 6f 72 70 6f 
<4>[ 4165.037517]   0992: 72 61 74 69 6f 6e 10 23 00 07 57 52 54 31 32 30 
<4>[ 4165.037782]   1008: 4e 10 24 00 07 76 31 2e 30 2e 30 31 10 42 00 0c 
<4>[ 4165.038048]   1024: 4a 55 54 30 30 4b 34 42 35 35 36 33 10 54 00 08 
<4>[ 4165.038312]   1040: 00 06 00 50 f2 04 00 01 10 11 00 14 57 69 72 65 
<4>[ 4165.038578]   1056: 6c 65 73 73 20 52 6f 75 74 65 72 28 57 46 41 29 
<4>[ 4165.038839]   1072: 10 08 00 02 00 84 00 00 6c 00 00 00 60 01 00 00 
<4>[ 4165.039104]   1088: e0 91 f5 7d b5 f6 64 00 11 04 07 4e 45 54 47 45 
<4>[ 4165.039364]   1104: 41 52 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.039622]   1120: 00 00 00 00 00 00 00 00 00 00 00 00 0c 00 00 00 
<4>[ 4165.039885]   1136: 82 84 0b 16 24 30 48 6c 0c 12 18 60 00 00 00 00 
<4>[ 4165.040146]   1152: 0b 2b 00 00 00 00 b3 ff a4 00 00 00 00 00 00 00 
<4>[ 4165.040404]   1168: 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 
<4>[ 4165.040663]   1184: 00 00 00 00 00 00 00 00 00 00 00 00 7c 00 00 00 
<4>[ 4165.040926]   1200: e2 00 00 00 00 07 4e 45 54 47 45 41 52 01 08 82 
<4>[ 4165.041191]   1216: 84 0b 16 24 30 48 6c 03 01 0b 2a 01 02 2f 01 02 
<4>[ 4165.041456]   1232: 32 04 0c 12 18 60 dd 7f 00 50 f2 04 10 4a 00 01 
<4>[ 4165.041719]   1248: 10 10 44 00 01 02 10 41 00 01 00 10 3b 00 01 03 
<4>[ 4165.041985]   1264: 10 47 00 10 a5 15 32 26 2b 0c 87 4d 71 1b 25 c1 
<4>[ 4165.042251]   1280: b3 2e 9a 6b 10 21 00 0d 4e 45 54 47 45 41 52 2c 
<4>[ 4165.042517]   1296: 20 49 6e 63 2e 10 23 00 09 57 4e 52 31 30 30 30 
<4>[ 4165.042782]   1312: 76 33 10 24 00 09 57 4e 52 31 30 30 30 76 33 10 
<4>[ 4165.043048]   1328: 42 00 05 38 33 32 35 38 10 54 00 08 00 06 00 50 
<4>[ 4165.043313]   1344: f2 04 00 01 10 11 00 09 57 4e 52 31 30 30 30 76 
<4>[ 4165.043578]   1360: 33 10 08 00 02 00 84 dd 09 00 10 18 02 00 f0 05 
<4>[ 4165.043842]   1376: 00 00 dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 
<4>[ 4165.044105]   1392: 00 50 f2 02 01 00 00 50 f2 02 0c 00 dd 18 00 50 
<4>[ 4165.044458]   1408: f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 
<4>[ 4165.044738]   1424: 5e 00 62 32 2f 00 00 00 6c 00 00 00 7c 01 00 00 
<4>[ 4165.045007]   1440: 00 26 5a b3 95 c8 64 00 31 0c 06 6f 6d 2d 6e 65 
<4>[ 4165.045267]   1456: 74 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.045526]   1472: 00 00 00 00 00 00 00 00 00 00 00 00 0c 00 00 00 
<4>[ 4165.045791]   1488: 82 84 8b 96 12 24 48 6c 0c 18 30 60 00 00 00 00 
<4>[ 4165.046052]   1504: 0b 2b 00 00 00 00 ab ff a4 00 00 00 00 00 00 00 
<4>[ 4165.046310]   1520: 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 
<4>[ 4165.046569]   1536: 00 00 00 00 00 00 00 00 00 00 00 00 7c 00 00 00 
<4>[ 4165.046833]   1552: fd 00 00 00 00 06 6f 6d 2d 6e 65 74 01 08 82 84 
<4>[ 4165.047098]   1568: 8b 96 12 24 48 6c 03 01 0b 2a 01 00 32 04 0c 18 
<4>[ 4165.047362]   1584: 30 60 dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 
<4>[ 4165.047626]   1600: 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 30 18 
<4>[ 4165.047888]   1616: 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 
<4>[ 4165.048152]   1632: 01 00 00 0f ac 02 00 00 dd 18 00 50 f2 02 01 01 
<4>[ 4165.048414]   1648: 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 
<4>[ 4165.048678]   1664: 2f 00 dd 07 00 0c 43 07 00 00 00 07 06 47 42 20 
<4>[ 4165.048941]   1680: 01 0d 10 dd 05 00 50 f2 05 00 dd 75 00 50 f2 04 
<4>[ 4165.049205]   1696: 10 4a 00 01 10 10 44 00 01 02 10 41 00 01 00 10 
<4>[ 4165.049470]   1712: 3b 00 01 03 10 47 00 10 ab 38 72 1d 52 f9 7b 7a 
<4>[ 4165.049736]   1728: 8e a6 00 26 5a b3 95 c8 10 21 00 06 44 2d 4c 69 
<4>[ 4165.050001]   1744: 6e 6b 10 23 00 07 44 49 52 2d 33 30 30 10 24 00 
<4>[ 4165.050267]   1760: 07 44 49 52 2d 33 30 30 10 42 00 08 30 30 30 30 
<4>[ 4165.050530]   1776: 30 30 30 30 10 54 00 08 00 06 00 50 f2 04 00 01 
<4>[ 4165.050796]   1792: 10 11 00 07 44 49 52 2d 33 30 30 10 08 00 02 00 
<4>[ 4165.051057]   1808: 86 00 00 00 6c 00 00 00 c8 00 00 00 00 16 b6 ac 
<4>[ 4165.051322]   1824: f4 d4 64 00 11 04 0d 6b 6f 6c 2d 6c 69 6e 6b 73 
<4>[ 4165.051582]   1840: 79 73 20 47 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.051842]   1856: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 96 
<4>[ 4165.052105]   1872: 24 30 48 6c 0c 12 18 60 00 00 00 00 0b 2b 00 00 
<4>[ 4165.052366]   1888: 00 00 a6 ff a4 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.052624]   1904: 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.052884]   1920: 00 00 00 00 00 00 00 00 7c 00 00 00 4a 00 00 00 
<4>[ 4165.053150]   1936: 00 0d 6b 6f 6c 2d 6c 69 6e 6b 73 79 73 20 47 01 
<4>[ 4165.053415]   1952: 08 82 84 8b 96 24 30 48 6c 03 01 0b 2a 01 04 2f 
<4>[ 4165.053677]   1968: 01 04 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 
<4>[ 4165.053940]   1984: 00 0f ac 02 01 00 00 0f ac 02 00 00 32 04 0c 12 
<4>[ 4165.054201]   2000: 18 60 dd 06 00 10 18 02 00 14 00 00 00 00 00 00 
<4>[ 4165.054542]   2016: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.054816]   2032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.055078]   2048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.055321]   2064: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.055660] RxHdr:
<4>[ 4165.055837]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.056008] dhdsdio_readframes: processed 1 frames
<4>[ 4165.056170] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.056399] dhd_watchdog_thread:
<4>[ 4165.056528] dhd_bus_watchdog: Enter
<4>[ 4165.056654] dhdsdio_clkctl: Enter
<4>[ 4165.056771] dhdsdio_htclk: Enter
<4>[ 4165.056986] CLKCTL: turned OFF
<4>[ 4165.057120] dhdsdio_sdclk: Enter
<4>[ 4165.057247] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.057488] dhd_bus_rxctl: resumed on rxctl frame, got 2064 expected 
2064
<4>[ 4165.057761] results->count = 7
<4>[ 4165.057884] results->buflen = 1980
<4>[ 4165.058007] iscanresults complete
<4>[ 4165.058178] Send Event ISCAN complete
<4>[ 4165.058708] eth0 wl_iw_iscan_get_scan buflen_from_user 8192:
<4>[ 4165.058902] eth0: SIOCGIWSCAN GET broadcast results
<4>[ 4165.059272] wl_iw_iscan_get_scan return to WE 1870 bytes APs=7
<4>[ 4165.061746] eth0: SIOCSIWMODE
<4>[ 4165.061941] 
<4>[ 4165.061962] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x14, 
buf:c2297ddc, len:4 ,
<4>[ 4165.062274] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.062439] dhd_prot_ioctl: Enter
<4>[ 4165.062563] dhdcdc_query_ioctl: Enter
<4>[ 4165.062696] dhdcdc_query_ioctl: cmd 20 len 4
<4>[ 4165.062834] dhdcdc_msg: Enter
<4>[ 4165.062944] dhd_bus_txctl: Enter
<4>[ 4165.063066] dhdsdio_clkctl: Enter
<4>[ 4165.063184] dhdsdio_sdclk: Enter
<4>[ 4165.063299] dhdsdio_htclk: Enter
<4>[ 4165.066532] dhdsdio_isr: Enter
<4>[ 4165.066689] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.066847] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.067001] dhdsdio_dpc: Enter
<4>[ 4165.067288] CLKCTL: turned ON
<4>[ 4165.067440] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.067567] Tx Frame:
<4>[ 4165.067751]   0000: 2c 00 d3 ff 37 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.068013]   0016: 00 00 00 00 00 00 00 00 14 00 00 00 04 00 00 00 
<4>[ 4165.068276]   0032: 00 00 35 00 00 00 00 00 01 00 00 00 bc 07 00 00 
<4>[ 4165.068537]   0048: 6c 00 00 00 07 00 00 00 6c 00 00 00 c4 00 00 00 
<4>[ 4165.074527] dhdsdio_clkctl: Enter
<4>[ 4165.074992] Dongle reports CHIPACTIVE
<4>[ 4165.075151] dhdsdio_readframes: Enter
<4>[ 4165.075426] RxHdr:
<4>[ 4165.075671]   0000: 20 00 df ff 36 00 00 0c 00 44 00 00 
<4>[ 4165.075850] dhdsdio_read_control: Enter
<4>[ 4165.075985] RxCtrl:
<4>[ 4165.076166]   0000: 20 00 df ff 36 00 00 0c 00 44 00 00 14 00 00 00 
<4>[ 4165.076426]   0016: 04 00 00 00 00 00 35 00 00 00 00 00 01 00 00 00 
<4>[ 4165.076757] RxHdr:
<4>[ 4165.076933]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.077102] dhdsdio_readframes: processed 1 frames
<4>[ 4165.077264] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.077492] dhd_watchdog_thread:
<4>[ 4165.077621] dhd_bus_watchdog: Enter
<4>[ 4165.077747] dhdsdio_clkctl: Enter
<4>[ 4165.077866] dhdsdio_htclk: Enter
<4>[ 4165.078081] CLKCTL: turned OFF
<4>[ 4165.078214] dhdsdio_sdclk: Enter
<4>[ 4165.078344] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.078740] dhdcdc_cmplt: Enter
<4>[ 4165.078887] dhd_bus_rxctl: Enter
<4>[ 4165.079027] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4165.079280] 
<4>[ 4165.079300] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x76, 
buf:c2297dd8, len:4 ,
<4>[ 4165.079611] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.079776] dhd_prot_ioctl: Enter
<4>[ 4165.079900] dhdcdc_query_ioctl: Enter
<4>[ 4165.080036] dhdcdc_query_ioctl: cmd 118 len 4
<4>[ 4165.080175] dhdcdc_msg: Enter
<4>[ 4165.080285] dhd_bus_txctl: Enter
<4>[ 4165.080403] dhdsdio_clkctl: Enter
<4>[ 4165.080521] dhdsdio_sdclk: Enter
<4>[ 4165.080634] dhdsdio_htclk: Enter
<4>[ 4165.083855] dhdsdio_isr: Enter
<4>[ 4165.084009] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.084167] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.084437] dhdsdio_dpc: Enter
<4>[ 4165.084782] CLKCTL: turned ON
<4>[ 4165.084934] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.085061] Tx Frame:
<4>[ 4165.085242]   0000: 2c 00 d3 ff 38 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.085504]   0016: 00 00 00 00 00 00 00 00 76 00 00 00 04 00 00 00 
<4>[ 4165.085764]   0032: 00 00 36 00 00 00 00 00 00 00 00 00 bc 07 00 00 
<4>[ 4165.086025]   0048: 6c 00 00 00 07 00 00 00 6c 00 00 00 c4 00 00 00 
<4>[ 4165.094535] dhdsdio_clkctl: Enter
<4>[ 4165.094957] Dongle reports CHIPACTIVE
<4>[ 4165.095114] dhdsdio_readframes: Enter
<4>[ 4165.095387] RxHdr:
<4>[ 4165.095568]   0000: 20 00 df ff 37 00 00 0c 00 45 00 00 
<4>[ 4165.095736] dhdsdio_read_control: Enter
<4>[ 4165.095867] RxCtrl:
<4>[ 4165.096046]   0000: 20 00 df ff 37 00 00 0c 00 45 00 00 76 00 00 00 
<4>[ 4165.096307]   0016: 04 00 00 00 00 00 36 00 00 00 00 00 00 00 00 00 
<4>[ 4165.096633] RxHdr:
<4>[ 4165.096808]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.096985] dhdsdio_readframes: processed 1 frames
<4>[ 4165.097147] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.097375] dhd_watchdog_thread:
<4>[ 4165.097503] dhd_bus_watchdog: Enter
<4>[ 4165.097628] dhdsdio_clkctl: Enter
<4>[ 4165.097747] dhdsdio_htclk: Enter
<4>[ 4165.097959] CLKCTL: turned OFF
<4>[ 4165.098094] dhdsdio_sdclk: Enter
<4>[ 4165.098223] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.098433] dhdcdc_cmplt: Enter
<4>[ 4165.098562] dhd_bus_rxctl: Enter
<4>[ 4165.098699] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4165.099040] eth0: SIOCSIWCOMMIT
<4>[ 4165.099217] 
<4>[ 4165.099237] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:c2297d98, len:36 ,
<4>[ 4165.099547] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.099711] dhd_prot_ioctl: Enter
<4>[ 4165.099836] dhdcdc_query_ioctl: Enter
<4>[ 4165.099971] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4165.100110] dhdcdc_msg: Enter
<4>[ 4165.100222] dhd_bus_txctl: Enter
<4>[ 4165.100340] dhdsdio_clkctl: Enter
<4>[ 4165.100459] dhdsdio_sdclk: Enter
<4>[ 4165.100574] dhdsdio_htclk: Enter
<4>[ 4165.103725] dhdsdio_isr: Enter
<4>[ 4165.103883] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.104042] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.104197] dhdsdio_dpc: Enter
<4>[ 4165.104632] CLKCTL: turned ON
<4>[ 4165.104792] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.104920] Tx Frame:
<4>[ 4165.105105]   0000: 4c 00 b3 ff 39 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.105369]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4165.105632]   0032: 00 00 37 00 00 00 00 00 0b 00 00 00 00 60 29 c2 
<4>[ 4165.105897]   0048: 13 01 00 60 20 27 02 ca 00 00 00 00 00 60 29 c2 
<4>[ 4165.106164]   0064: 08 a0 75 c0 8d ff ff ff dc 7e 29 c2 6f 6d 33 71 
<4>[ 4165.106423]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.106978] dhdsdio_clkctl: Enter
<4>[ 4165.107369] Dongle reports CHIPACTIVE
<4>[ 4165.107525] dhdsdio_readframes: Enter
<4>[ 4165.107799] RxHdr:
<4>[ 4165.107979]   0000: 40 00 bf ff 38 00 00 0c 00 46 00 00 
<4>[ 4165.108149] dhdsdio_read_control: Enter
<4>[ 4165.108280] RxCtrl:
<4>[ 4165.108458]   0000: 40 00 bf ff 38 00 00 0c 00 46 00 00 19 00 00 00 
<4>[ 4165.108721]   0016: 24 00 00 00 00 00 37 00 00 00 00 00 00 00 00 00 
<4>[ 4165.108981]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.109239]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.109564] RxHdr:
<4>[ 4165.109737]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.109908] dhdsdio_readframes: processed 1 frames
<4>[ 4165.110069] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.110321] dhdcdc_cmplt: Enter
<4>[ 4165.110451] dhd_bus_rxctl: Enter
<4>[ 4165.110588] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4165.110988] eth0: SIOCSIWAUTH
<4>[ 4165.111141] eth0: SIOCSIWAUTH, paramid = 0x6, paramval = 0x1
<4>[ 4165.111314] Setting the D11auth 1
<4>[ 4165.111497] 
<4>[ 4165.111519] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:9 ,
<4>[ 4165.111826] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.111992] dhd_prot_ioctl: Enter
<4>[ 4165.112115] dhdcdc_query_ioctl: Enter
<4>[ 4165.112250] dhdcdc_query_ioctl: cmd 263 len 9
<4>[ 4165.112390] dhdcdc_msg: Enter
<4>[ 4165.112500] dhd_bus_txctl: Enter
<4>[ 4165.112620] dhdsdio_clkctl: Enter
<4>[ 4165.112743] Tx Frame:
<4>[ 4165.112927]   0000: 31 00 ce ff 3a 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.113189]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 09 00 00 00 
<4>[ 4165.113451]   0032: 00 00 38 00 00 00 00 00 61 75 74 68 00 00 00 00 
<4>[ 4165.113710]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.124523] dhdsdio_isr: Enter
<4>[ 4165.124679] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.124837] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.124990] dhdsdio_dpc: Enter
<4>[ 4165.125181] dhd_watchdog_thread:
<4>[ 4165.125314] dhd_bus_watchdog: Enter
<4>[ 4165.125445] dhdsdio_clkctl: Enter
<4>[ 4165.125567] dhdsdio_htclk: Enter
<4>[ 4165.125792] CLKCTL: turned OFF
<4>[ 4165.125930] dhdsdio_sdclk: Enter
<4>[ 4165.126060] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.126222] dhdsdio_clkctl: Enter
<4>[ 4165.126349] dhdsdio_sdclk: Enter
<4>[ 4165.126467] dhdsdio_htclk: Enter
<4>[ 4165.126791] CLKCTL: turned ON
<4>[ 4165.126937] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.127311] dhdsdio_readframes: Enter
<4>[ 4165.127599] RxHdr:
<4>[ 4165.127781]   0000: 25 00 da ff 39 00 00 0c 00 47 00 00 
<4>[ 4165.127950] dhdsdio_read_control: Enter
<4>[ 4165.128081] RxCtrl:
<4>[ 4165.128266]   0000: 25 00 da ff 39 00 00 0c 00 47 00 00 07 01 00 00 
<4>[ 4165.128531]   0016: 09 00 00 00 00 00 38 00 00 00 00 00 61 75 74 68 
<4>[ 4165.128740]   0032: 00 00 00 00 00 
<4>[ 4165.129005] RxHdr:
<4>[ 4165.129181]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.129352] dhdsdio_readframes: processed 1 frames
<4>[ 4165.129513] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.129765] dhdcdc_cmplt: Enter
<4>[ 4165.129896] dhd_bus_rxctl: Enter
<4>[ 4165.130033] dhd_bus_rxctl: resumed on rxctl frame, got 25 expected 25
<4>[ 4165.130539] eth0: SIOCSIWAUTH
<4>[ 4165.130691] eth0: SIOCSIWAUTH, paramid = 0x5, paramval = 0x1
<4>[ 4165.130999] 
<4>[ 4165.131020] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:bf26e82c, len:18 ,
<4>[ 4165.131332] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.131498] dhd_prot_ioctl: Enter
<4>[ 4165.131623] dhdcdc_query_ioctl: Enter
<4>[ 4165.131759] dhdcdc_query_ioctl: cmd 263 len 18
<4>[ 4165.131901] dhdcdc_msg: Enter
<4>[ 4165.132013] dhd_bus_txctl: Enter
<4>[ 4165.132130] dhdsdio_clkctl: Enter
<4>[ 4165.132253] Tx Frame:
<4>[ 4165.132434]   0000: 3a 00 c5 ff 3b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.132696]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 12 00 00 00 
<4>[ 4165.132960]   0032: 00 00 39 00 00 00 00 00 77 73 65 63 5f 72 65 73 
<4>[ 4165.133222]   0048: 74 72 69 63 74 00 01 00 00 00 00 00 00 00 00 00 
<4>[ 4165.133570] dhdcdc_cmplt: Enter
<4>[ 4165.133852] dhdsdio_isr: Enter
<4>[ 4165.133995] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.134151] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.134445] dhd_watchdog_thread:
<4>[ 4165.134587] dhd_bus_watchdog: Enter
<4>[ 4165.134714] dhdsdio_clkctl: Enter
<4>[ 4165.134834] dhdsdio_htclk: Enter
<4>[ 4165.135051] CLKCTL: turned OFF
<4>[ 4165.135184] dhdsdio_sdclk: Enter
<4>[ 4165.135315] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.135476] dhdsdio_dpc: Enter
<4>[ 4165.135599] dhdsdio_clkctl: Enter
<4>[ 4165.135721] dhdsdio_sdclk: Enter
<4>[ 4165.135839] dhdsdio_htclk: Enter
<4>[ 4165.136165] CLKCTL: turned ON
<4>[ 4165.136316] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.136685] dhdsdio_readframes: Enter
<4>[ 4165.136975] RxHdr:
<4>[ 4165.137155]   0000: 2e 00 d1 ff 3a 00 00 0c 00 48 00 00 
<4>[ 4165.137322] dhdsdio_read_control: Enter
<4>[ 4165.137455] RxCtrl:
<4>[ 4165.137633]   0000: 2e 00 d1 ff 3a 00 00 0c 00 48 00 00 07 01 00 00 
<4>[ 4165.137896]   0016: 12 00 00 00 00 00 39 00 00 00 00 00 77 73 65 63 
<4>[ 4165.138151]   0032: 5f 72 65 73 74 72 69 63 74 00 01 00 00 00 
<4>[ 4165.138464] RxHdr:
<4>[ 4165.138637]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.138808] dhdsdio_readframes: processed 1 frames
<4>[ 4165.138968] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.139217] dhd_bus_rxctl: Enter
<4>[ 4165.139368] dhd_bus_rxctl: resumed on rxctl frame, got 34 expected 34
<4>[ 4165.140101] eth0: SIOCSIWGENIE
<4>[ 4165.140391] 
<4>[ 4165.140413] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:bf26e82c, len:30 ,
<4>[ 4165.140730] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.140899] dhd_prot_ioctl: Enter
<4>[ 4165.141024] dhdcdc_query_ioctl: Enter
<4>[ 4165.141159] dhdcdc_query_ioctl: cmd 263 len 30
<4>[ 4165.141300] dhdcdc_msg: Enter
<4>[ 4165.141412] dhd_bus_txctl: Enter
<4>[ 4165.141532] dhdsdio_clkctl: Enter
<4>[ 4165.141654] Tx Frame:
<4>[ 4165.141838]   0000: 46 00 b9 ff 3c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.142101]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 1e 00 00 00 
<4>[ 4165.142365]   0032: 00 00 3a 00 00 00 00 00 77 70 61 69 65 00 dd 16 
<4>[ 4165.142629]   0048: 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 
<4>[ 4165.142893]   0064: 01 00 00 50 f2 02 00 00 00 00 00 00 6f 6d 33 71 
<4>[ 4165.143152]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.147824] dhd_watchdog_thread:
<4>[ 4165.148054] dhd_bus_watchdog: Enter
<4>[ 4165.148196] dhdsdio_clkctl: Enter
<4>[ 4165.148320] dhdsdio_htclk: Enter
<4>[ 4165.148539] CLKCTL: turned OFF
<4>[ 4165.148674] dhdsdio_sdclk: Enter
<4>[ 4165.148805] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.149057] dhdsdio_isr: Enter
<4>[ 4165.149193] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.149347] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.149501] dhdsdio_dpc: Enter
<4>[ 4165.149617] dhdsdio_clkctl: Enter
<4>[ 4165.149737] dhdsdio_sdclk: Enter
<4>[ 4165.149852] dhdsdio_htclk: Enter
<4>[ 4165.150180] CLKCTL: turned ON
<4>[ 4165.150330] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.150704] dhdsdio_readframes: Enter
<4>[ 4165.150992] RxHdr:
<4>[ 4165.151172]   0000: 3a 00 c5 ff 3b 00 00 0c 00 49 00 00 
<4>[ 4165.151341] dhdsdio_read_control: Enter
<4>[ 4165.151475] RxCtrl:
<4>[ 4165.151654]   0000: 3a 00 c5 ff 3b 00 00 0c 00 49 00 00 07 01 00 00 
<4>[ 4165.151919]   0016: 1e 00 00 00 00 00 3a 00 00 00 00 00 77 70 61 69 
<4>[ 4165.152184]   0032: 65 00 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 
<4>[ 4165.152418]   0048: 00 50 f2 02 01 00 00 50 f2 02 
<4>[ 4165.152711] RxHdr:
<4>[ 4165.152885]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.153055] dhdsdio_readframes: processed 1 frames
<4>[ 4165.153217] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.154128] dhdcdc_cmplt: Enter
<4>[ 4165.154440] dhd_watchdog_thread:
<4>[ 4165.154590] dhd_bus_watchdog: Enter
<4>[ 4165.154719] dhdsdio_clkctl: Enter
<4>[ 4165.154841] dhdsdio_htclk: Enter
<4>[ 4165.155065] CLKCTL: turned OFF
<4>[ 4165.155201] dhdsdio_sdclk: Enter
<4>[ 4165.155330] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.155493] dhd_bus_rxctl: Enter
<4>[ 4165.155639] dhd_bus_rxctl: resumed on rxctl frame, got 46 expected 46
<4>[ 4165.155914] eth0: SIOCSIWAUTH
<4>[ 4165.156057] eth0: SIOCSIWAUTH, paramid = 0x0, paramval = 0x2
<4>[ 4165.156240] wl_iw_set_wpaauth: 5265: setting wpa_auth to 0x6
<4>[ 4165.156470] 
<4>[ 4165.156491] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:13 ,
<4>[ 4165.156800] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.156964] dhd_prot_ioctl: Enter
<4>[ 4165.157088] dhdcdc_query_ioctl: Enter
<4>[ 4165.157225] dhdcdc_query_ioctl: cmd 263 len 13
<4>[ 4165.157367] dhdcdc_msg: Enter
<4>[ 4165.157479] dhd_bus_txctl: Enter
<4>[ 4165.157598] dhdsdio_clkctl: Enter
<4>[ 4165.157716] dhdsdio_sdclk: Enter
<4>[ 4165.157831] dhdsdio_htclk: Enter
<4>[ 4165.165826] dhdsdio_isr: Enter
<4>[ 4165.165983] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.166141] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.166293] dhdsdio_dpc: Enter
<4>[ 4165.167791] CLKCTL: turned ON
<4>[ 4165.167961] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.168091] Tx Frame:
<4>[ 4165.168274]   0000: 35 00 ca ff 3d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.168536]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 0d 00 00 00 
<4>[ 4165.168802]   0032: 00 00 3b 00 00 00 00 00 77 70 61 5f 61 75 74 68 
<4>[ 4165.169065]   0048: 00 06 00 00 00 00 00 50 f2 02 01 00 00 50 f2 02 
<4>[ 4165.174952] dhdsdio_clkctl: Enter
<4>[ 4165.175375] Dongle reports CHIPACTIVE
<4>[ 4165.175535] dhdsdio_readframes: Enter
<4>[ 4165.175813] RxHdr:
<4>[ 4165.175991]   0000: 29 00 d6 ff 3c 00 00 0c 00 4a 00 00 
<4>[ 4165.176161] dhdsdio_read_control: Enter
<4>[ 4165.176294] RxCtrl:
<4>[ 4165.176475]   0000: 29 00 d6 ff 3c 00 00 0c 00 4a 00 00 07 01 00 00 
<4>[ 4165.176741]   0016: 0d 00 00 00 00 00 3b 00 00 00 00 00 77 70 61 5f 
<4>[ 4165.176972]   0032: 61 75 74 68 00 06 00 00 00 
<4>[ 4165.177260] RxHdr:
<4>[ 4165.177434]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.177605] dhdsdio_readframes: processed 1 frames
<4>[ 4165.177766] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.177994] dhd_watchdog_thread:
<4>[ 4165.178126] dhd_bus_watchdog: Enter
<4>[ 4165.178254] dhdsdio_clkctl: Enter
<4>[ 4165.178376] dhdsdio_htclk: Enter
<4>[ 4165.178590] CLKCTL: turned OFF
<4>[ 4165.178785] dhdsdio_sdclk: Enter
<4>[ 4165.178926] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.180107] dhdcdc_cmplt: Enter
<4>[ 4165.180930] dhd_bus_rxctl: Enter
<4>[ 4165.181104] dhd_bus_rxctl: resumed on rxctl frame, got 29 expected 29
<4>[ 4165.181384] eth0: SIOCSIWAUTH
<4>[ 4165.181524] eth0: SIOCSIWAUTH, paramid = 0x1, paramval = 0x4
<4>[ 4165.181759] 
<4>[ 4165.181781] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:20 ,
<4>[ 4165.182092] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.182257] dhd_prot_ioctl: Enter
<4>[ 4165.182380] dhdcdc_query_ioctl: Enter
<4>[ 4165.182515] dhdcdc_query_ioctl: cmd 263 len 20
<4>[ 4165.182657] dhdcdc_msg: Enter
<4>[ 4165.182770] dhd_bus_txctl: Enter
<4>[ 4165.182889] dhdsdio_clkctl: Enter
<4>[ 4165.183006] dhdsdio_sdclk: Enter
<4>[ 4165.183122] dhdsdio_htclk: Enter
<4>[ 4165.192820] dhdsdio_isr: Enter
<4>[ 4165.192978] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.193136] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.193290] dhdsdio_dpc: Enter
<4>[ 4165.193809] CLKCTL: turned ON
<4>[ 4165.193967] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.194098] Tx Frame:
<4>[ 4165.196656]   0000: 3c 00 c3 ff 3e 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.196954]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 14 00 00 00 
<4>[ 4165.197226]   0032: 00 00 3c 00 00 00 00 00 69 73 5f 57 50 53 5f 65 
<4>[ 4165.197494]   0048: 6e 72 6f 6c 6c 65 65 00 00 00 00 00 00 50 f2 02 
<4>[ 4165.202284] dhdsdio_clkctl: Enter
<4>[ 4165.202708] Dongle reports CHIPACTIVE
<4>[ 4165.202869] dhdsdio_readframes: Enter
<4>[ 4165.203148] RxHdr:
<4>[ 4165.203325]   0000: 30 00 cf ff 3d 00 00 0c 00 4b 00 00 
<4>[ 4165.203492] dhdsdio_read_control: Enter
<4>[ 4165.203623] RxCtrl:
<4>[ 4165.203801]   0000: 30 00 cf ff 3d 00 00 0c 00 4b 00 00 07 01 00 00 
<4>[ 4165.204065]   0016: 14 00 00 00 00 00 3c 00 00 00 00 00 69 73 5f 57 
<4>[ 4165.204447]   0032: 50 53 5f 65 6e 72 6f 6c 6c 65 65 00 00 00 00 00 
<4>[ 4165.204798] RxHdr:
<4>[ 4165.204977]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.205147] dhdsdio_readframes: processed 1 frames
<4>[ 4165.205309] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.205539] dhd_watchdog_thread:
<4>[ 4165.205672] dhd_bus_watchdog: Enter
<4>[ 4165.205799] dhdsdio_clkctl: Enter
<4>[ 4165.205919] dhdsdio_htclk: Enter
<4>[ 4165.206134] CLKCTL: turned OFF
<4>[ 4165.206266] dhdsdio_sdclk: Enter
<4>[ 4165.206396] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.206524] dhd_watchdog_thread:
<4>[ 4165.206643] dhd_bus_watchdog: Enter
<4>[ 4165.207634] dhdcdc_cmplt: Enter
<4>[ 4165.208483] dhd_bus_rxctl: Enter
<4>[ 4165.208658] dhd_bus_rxctl: resumed on rxctl frame, got 36 expected 36
<4>[ 4165.208949] 
<4>[ 4165.208971] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:9 ,
<4>[ 4165.209287] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.209454] dhd_prot_ioctl: Enter
<4>[ 4165.209579] dhdcdc_query_ioctl: Enter
<4>[ 4165.209715] dhdcdc_query_ioctl: cmd 263 len 9
<4>[ 4165.209855] dhdcdc_msg: Enter
<4>[ 4165.209965] dhd_bus_txctl: Enter
<4>[ 4165.210086] dhdsdio_clkctl: Enter
<4>[ 4165.210205] dhdsdio_sdclk: Enter
<4>[ 4165.210321] dhdsdio_htclk: Enter
<4>[ 4165.218308] dhdsdio_isr: Enter
<4>[ 4165.218467] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.218625] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.218778] dhdsdio_dpc: Enter
<4>[ 4165.220284] CLKCTL: turned ON
<4>[ 4165.220454] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.220588] Tx Frame:
<4>[ 4165.220773]   0000: 31 00 ce ff 3f 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.221037]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 09 00 00 00 
<4>[ 4165.221301]   0032: 00 00 3d 00 00 00 00 00 77 73 65 63 00 02 00 00 
<4>[ 4165.221566]   0048: 00 72 6f 6c 6c 65 65 00 00 00 00 00 00 50 f2 02 
<4>[ 4165.228200] dhdsdio_clkctl: Enter
<4>[ 4165.228662] Dongle reports CHIPACTIVE
<4>[ 4165.228826] dhdsdio_readframes: Enter
<4>[ 4165.229103] RxHdr:
<4>[ 4165.229285]   0000: 25 00 da ff 3e 00 00 0c 00 4c 00 00 
<4>[ 4165.229456] dhdsdio_read_control: Enter
<4>[ 4165.229590] RxCtrl:
<4>[ 4165.229769]   0000: 25 00 da ff 3e 00 00 0c 00 4c 00 00 07 01 00 00 
<4>[ 4165.230032]   0016: 09 00 00 00 00 00 3d 00 00 00 00 00 77 73 65 63 
<4>[ 4165.230239]   0032: 00 02 00 00 00 
<4>[ 4165.230504] RxHdr:
<4>[ 4165.230680]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.230852] dhdsdio_readframes: processed 1 frames
<4>[ 4165.231015] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.231244] dhd_watchdog_thread:
<4>[ 4165.231376] dhd_bus_watchdog: Enter
<4>[ 4165.231502] dhdsdio_clkctl: Enter
<4>[ 4165.231622] dhdsdio_htclk: Enter
<4>[ 4165.231835] CLKCTL: turned OFF
<4>[ 4165.231966] dhdsdio_sdclk: Enter
<4>[ 4165.232095] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.232580] dhdcdc_cmplt: Enter
<4>[ 4165.232729] dhd_bus_rxctl: Enter
<4>[ 4165.232874] dhd_bus_rxctl: resumed on rxctl frame, got 25 expected 25
<4>[ 4165.233151] eth0: SIOCSIWAUTH
<4>[ 4165.233291] eth0: SIOCSIWAUTH, paramid = 0x2, paramval = 0x4
<4>[ 4165.233526] 
<4>[ 4165.233547] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:20 ,
<4>[ 4165.233856] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.234022] dhd_prot_ioctl: Enter
<4>[ 4165.234146] dhdcdc_query_ioctl: Enter
<4>[ 4165.234403] dhdcdc_query_ioctl: cmd 263 len 20
<4>[ 4165.234560] dhdcdc_msg: Enter
<4>[ 4165.234677] dhd_bus_txctl: Enter
<4>[ 4165.234798] dhdsdio_clkctl: Enter
<4>[ 4165.234917] dhdsdio_sdclk: Enter
<4>[ 4165.235033] dhdsdio_htclk: Enter
<4>[ 4165.245425] dhdsdio_isr: Enter
<4>[ 4165.245582] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.245739] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.245891] dhdsdio_dpc: Enter
<4>[ 4165.247051] CLKCTL: turned ON
<4>[ 4165.247901] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.248052] Tx Frame:
<4>[ 4165.248240]   0000: 3c 00 c3 ff 40 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.248504]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 14 00 00 00 
<4>[ 4165.248771]   0032: 00 00 3e 00 00 00 00 00 69 73 5f 57 50 53 5f 65 
<4>[ 4165.249036]   0048: 6e 72 6f 6c 6c 65 65 00 00 00 00 00 00 50 f2 02 
<4>[ 4165.254863] dhdsdio_clkctl: Enter
<4>[ 4165.255290] Dongle reports CHIPACTIVE
<4>[ 4165.255449] dhdsdio_readframes: Enter
<4>[ 4165.255724] RxHdr:
<4>[ 4165.255903]   0000: 30 00 cf ff 3f 00 00 0c 00 4d 00 00 
<4>[ 4165.256070] dhdsdio_read_control: Enter
<4>[ 4165.256202] RxCtrl:
<4>[ 4165.256383]   0000: 30 00 cf ff 3f 00 00 0c 00 4d 00 00 07 01 00 00 
<4>[ 4165.256647]   0016: 14 00 00 00 00 00 3e 00 00 00 00 00 69 73 5f 57 
<4>[ 4165.256913]   0032: 50 53 5f 65 6e 72 6f 6c 6c 65 65 00 00 00 00 00 
<4>[ 4165.257236] RxHdr:
<4>[ 4165.257409]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.257577] dhdsdio_readframes: processed 1 frames
<4>[ 4165.257737] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.257964] dhd_watchdog_thread:
<4>[ 4165.258094] dhd_bus_watchdog: Enter
<4>[ 4165.258221] dhdsdio_clkctl: Enter
<4>[ 4165.258341] dhdsdio_htclk: Enter
<4>[ 4165.258556] CLKCTL: turned OFF
<4>[ 4165.258690] dhdsdio_sdclk: Enter
<4>[ 4165.258820] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.259780] dhdcdc_cmplt: Enter
<4>[ 4165.260622] dhd_bus_rxctl: Enter
<4>[ 4165.260796] dhd_bus_rxctl: resumed on rxctl frame, got 36 expected 36
<4>[ 4165.261086] 
<4>[ 4165.261108] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:9 ,
<4>[ 4165.261423] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.261591] dhd_prot_ioctl: Enter
<4>[ 4165.261716] dhdcdc_query_ioctl: Enter
<4>[ 4165.261850] dhdcdc_query_ioctl: cmd 263 len 9
<4>[ 4165.261991] dhdcdc_msg: Enter
<4>[ 4165.262104] dhd_bus_txctl: Enter
<4>[ 4165.262225] dhdsdio_clkctl: Enter
<4>[ 4165.262346] dhdsdio_sdclk: Enter
<4>[ 4165.262462] dhdsdio_htclk: Enter
<4>[ 4165.270463] dhdsdio_isr: Enter
<4>[ 4165.270618] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.270775] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.270930] dhdsdio_dpc: Enter
<4>[ 4165.272280] CLKCTL: turned ON
<4>[ 4165.272446] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.272578] Tx Frame:
<4>[ 4165.272765]   0000: 31 00 ce ff 41 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.273030]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 09 00 00 00 
<4>[ 4165.273293]   0032: 00 00 3f 00 00 00 00 00 77 73 65 63 00 02 00 00 
<4>[ 4165.273556]   0048: 00 72 6f 6c 6c 65 65 00 00 00 00 00 00 50 f2 02 
<4>[ 4165.280392] dhdsdio_clkctl: Enter
<4>[ 4165.280816] Dongle reports CHIPACTIVE
<4>[ 4165.280974] dhdsdio_readframes: Enter
<4>[ 4165.281249] RxHdr:
<4>[ 4165.281430]   0000: 25 00 da ff 40 00 00 0c 00 4e 00 00 
<4>[ 4165.281600] dhdsdio_read_control: Enter
<4>[ 4165.281733] RxCtrl:
<4>[ 4165.281911]   0000: 25 00 da ff 40 00 00 0c 00 4e 00 00 07 01 00 00 
<4>[ 4165.282176]   0016: 09 00 00 00 00 00 3f 00 00 00 00 00 77 73 65 63 
<4>[ 4165.282384]   0032: 00 02 00 00 00 
<4>[ 4165.282652] RxHdr:
<4>[ 4165.282827]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.282999] dhdsdio_readframes: processed 1 frames
<4>[ 4165.283164] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.283393] dhd_watchdog_thread:
<4>[ 4165.283521] dhd_bus_watchdog: Enter
<4>[ 4165.283650] dhdsdio_clkctl: Enter
<4>[ 4165.283770] dhdsdio_htclk: Enter
<4>[ 4165.283986] CLKCTL: turned OFF
<4>[ 4165.284121] dhdsdio_sdclk: Enter
<4>[ 4165.284359] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.284504] dhd_watchdog_thread:
<4>[ 4165.284626] dhd_bus_watchdog: Enter
<4>[ 4165.285132] dhdcdc_cmplt: Enter
<4>[ 4165.285282] dhd_bus_rxctl: Enter
<4>[ 4165.285427] dhd_bus_rxctl: resumed on rxctl frame, got 25 expected 25
<4>[ 4165.285703] eth0: SIOCSIWAUTH
<4>[ 4165.285843] eth0: SIOCSIWAUTH, paramid = 0x3, paramval = 0x2
<4>[ 4165.286079] 
<4>[ 4165.286101] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297cac, len:9 ,
<4>[ 4165.286410] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.286575] dhd_prot_ioctl: Enter
<4>[ 4165.286698] dhdcdc_query_ioctl: Enter
<4>[ 4165.286834] dhdcdc_query_ioctl: cmd 262 len 9
<4>[ 4165.286974] dhdcdc_msg: Enter
<4>[ 4165.287086] dhd_bus_txctl: Enter
<4>[ 4165.287206] dhdsdio_clkctl: Enter
<4>[ 4165.287325] dhdsdio_sdclk: Enter
<4>[ 4165.287440] dhdsdio_htclk: Enter
<4>[ 4165.297273] dhdsdio_isr: Enter
<4>[ 4165.297433] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.297592] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.297747] dhdsdio_dpc: Enter
<4>[ 4165.298558] CLKCTL: turned ON
<4>[ 4165.298723] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.298853] Tx Frame:
<4>[ 4165.299036]   0000: 31 00 ce ff 42 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.299298]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 09 00 00 00 
<4>[ 4165.299563]   0032: 00 00 40 00 00 00 00 00 77 70 61 5f 61 75 74 68 
<4>[ 4165.299828]   0048: 00 72 6f 6c 6c 65 65 00 00 00 00 00 00 50 f2 02 
<4>[ 4165.306466] dhdsdio_clkctl: Enter
<4>[ 4165.306894] Dongle reports CHIPACTIVE
<4>[ 4165.307056] dhdsdio_readframes: Enter
<4>[ 4165.307332] RxHdr:
<4>[ 4165.307513]   0000: 25 00 da ff 41 00 00 0c 00 4f 00 00 
<4>[ 4165.307682] dhdsdio_read_control: Enter
<4>[ 4165.307816] RxCtrl:
<4>[ 4165.307995]   0000: 25 00 da ff 41 00 00 0c 00 4f 00 00 06 01 00 00 
<4>[ 4165.308258]   0016: 09 00 00 00 00 00 40 00 00 00 00 00 06 00 00 00 
<4>[ 4165.308467]   0032: 61 75 74 68 00 
<4>[ 4165.308733] RxHdr:
<4>[ 4165.308909]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.309078] dhdsdio_readframes: processed 1 frames
<4>[ 4165.309240] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.309470] dhd_watchdog_thread:
<4>[ 4165.309601] dhd_bus_watchdog: Enter
<4>[ 4165.309728] dhdsdio_clkctl: Enter
<4>[ 4165.309848] dhdsdio_htclk: Enter
<4>[ 4165.310064] CLKCTL: turned OFF
<4>[ 4165.310196] dhdsdio_sdclk: Enter
<4>[ 4165.310326] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.310675] dhdcdc_cmplt: Enter
<4>[ 4165.310818] dhd_bus_rxctl: Enter
<4>[ 4165.310960] dhd_bus_rxctl: resumed on rxctl frame, got 25 expected 25
<4>[ 4165.311193] wl_iw_set_wpaauth: 5334: setting wpa_auth to 4
<4>[ 4165.311425] 
<4>[ 4165.311446] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:13 ,
<4>[ 4165.311758] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.311923] dhd_prot_ioctl: Enter
<4>[ 4165.312047] dhdcdc_query_ioctl: Enter
<4>[ 4165.312182] dhdcdc_query_ioctl: cmd 263 len 13
<4>[ 4165.312324] dhdcdc_msg: Enter
<4>[ 4165.312434] dhd_bus_txctl: Enter
<4>[ 4165.312552] dhdsdio_clkctl: Enter
<4>[ 4165.312671] dhdsdio_sdclk: Enter
<4>[ 4165.312788] dhdsdio_htclk: Enter
<4>[ 4165.323935] dhdsdio_isr: Enter
<4>[ 4165.324093] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.324368] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.324543] dhdsdio_dpc: Enter
<4>[ 4165.324902] CLKCTL: turned ON
<4>[ 4165.325057] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.325186] Tx Frame:
<4>[ 4165.325372]   0000: 35 00 ca ff 43 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.325634]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 0d 00 00 00 
<4>[ 4165.325901]   0032: 00 00 41 00 00 00 00 00 77 70 61 5f 61 75 74 68 
<4>[ 4165.326165]   0048: 00 04 00 00 00 65 65 00 00 00 00 00 00 50 f2 02 
<4>[ 4165.328521] dhdsdio_clkctl: Enter
<4>[ 4165.328945] Dongle reports CHIPACTIVE
<4>[ 4165.329105] dhdsdio_readframes: Enter
<4>[ 4165.329383] RxHdr:
<4>[ 4165.329562]   0000: 29 00 d6 ff 42 00 00 0c 00 50 00 00 
<4>[ 4165.329731] dhdsdio_read_control: Enter
<4>[ 4165.329864] RxCtrl:
<4>[ 4165.330041]   0000: 29 00 d6 ff 42 00 00 0c 00 50 00 00 07 01 00 00 
<4>[ 4165.330305]   0016: 0d 00 00 00 00 00 41 00 00 00 00 00 77 70 61 5f 
<4>[ 4165.330534]   0032: 61 75 74 68 00 04 00 00 00 
<4>[ 4165.330819] RxHdr:
<4>[ 4165.330992]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.331163] dhdsdio_readframes: processed 1 frames
<4>[ 4165.331328] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.331580] dhdcdc_cmplt: Enter
<4>[ 4165.331712] dhd_bus_rxctl: Enter
<4>[ 4165.331852] dhd_bus_rxctl: resumed on rxctl frame, got 29 expected 29
<4>[ 4165.332125] eth0: SIOCSIWAUTH
<4>[ 4165.332264] eth0: SIOCSIWAUTH, paramid = 0xa, paramval = 0x1
<4>[ 4165.332497] 
<4>[ 4165.332519] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297cac, len:5 ,
<4>[ 4165.332827] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.332991] dhd_prot_ioctl: Enter
<4>[ 4165.333116] dhdcdc_query_ioctl: Enter
<4>[ 4165.333252] dhdcdc_query_ioctl: cmd 262 len 5
<4>[ 4165.333391] dhdcdc_msg: Enter
<4>[ 4165.333502] dhd_bus_txctl: Enter
<4>[ 4165.333620] dhdsdio_clkctl: Enter
<4>[ 4165.333743] Tx Frame:
<4>[ 4165.333925]   0000: 2d 00 d2 ff 44 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.334187]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 05 00 00 00 
<4>[ 4165.336446]   0032: 00 00 42 00 00 00 00 00 77 73 65 63 00 75 74 68 
<4>[ 4165.336748]   0048: 00 04 00 00 00 65 65 00 00 00 00 00 00 50 f2 02 
<4>[ 4165.337135] dhd_watchdog_thread:
<4>[ 4165.337312] dhd_bus_watchdog: Enter
<4>[ 4165.337448] dhdsdio_clkctl: Enter
<4>[ 4165.337573] dhdsdio_htclk: Enter
<4>[ 4165.337786] CLKCTL: turned OFF
<4>[ 4165.337919] dhdsdio_sdclk: Enter
<4>[ 4165.338048] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.338299] dhdsdio_isr: Enter
<4>[ 4165.338436] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.338588] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.338740] dhdsdio_dpc: Enter
<4>[ 4165.338857] dhdsdio_clkctl: Enter
<4>[ 4165.338976] dhdsdio_sdclk: Enter
<4>[ 4165.339093] dhdsdio_htclk: Enter
<4>[ 4165.339366] CLKCTL: turned ON
<4>[ 4165.339507] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.339871] dhdsdio_readframes: Enter
<4>[ 4165.340156] RxHdr:
<4>[ 4165.340337]   0000: 21 00 de ff 43 00 00 0c 00 51 00 00 
<4>[ 4165.340505] dhdsdio_read_control: Enter
<4>[ 4165.340637] RxCtrl:
<4>[ 4165.340816]   0000: 21 00 de ff 43 00 00 0c 00 51 00 00 06 01 00 00 
<4>[ 4165.341079]   0016: 05 00 00 00 00 00 42 00 00 00 00 00 02 00 00 00 
<4>[ 4165.341268]   0032: 00 
<4>[ 4165.341509] RxHdr:
<4>[ 4165.341684]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.341856] dhdsdio_readframes: processed 1 frames
<4>[ 4165.342017] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.342270] dhdcdc_cmplt: Enter
<4>[ 4165.342403] dhd_bus_rxctl: Enter
<4>[ 4165.342541] dhd_bus_rxctl: resumed on rxctl frame, got 21 expected 21
<4>[ 4165.342825] 
<4>[ 4165.342847] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:20 ,
<4>[ 4165.343162] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.343329] dhd_prot_ioctl: Enter
<4>[ 4165.343453] dhdcdc_query_ioctl: Enter
<4>[ 4165.343588] dhdcdc_query_ioctl: cmd 263 len 20
<4>[ 4165.343730] dhdcdc_msg: Enter
<4>[ 4165.343840] dhd_bus_txctl: Enter
<4>[ 4165.343960] dhdsdio_clkctl: Enter
<4>[ 4165.344082] Tx Frame:
<4>[ 4165.344570]   0000: 3c 00 c3 ff 45 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.344862]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 14 00 00 00 
<4>[ 4165.345134]   0032: 00 00 43 00 00 00 00 00 69 73 5f 57 50 53 5f 65 
<4>[ 4165.345402]   0048: 6e 72 6f 6c 6c 65 65 00 00 00 00 00 00 50 f2 02 
<4>[ 4165.345775] dhd_watchdog_thread:
<4>[ 4165.345948] dhd_bus_watchdog: Enter
<4>[ 4165.346086] dhdsdio_clkctl: Enter
<4>[ 4165.346209] dhdsdio_htclk: Enter
<4>[ 4165.346421] CLKCTL: turned OFF
<4>[ 4165.346553] dhdsdio_sdclk: Enter
<4>[ 4165.346683] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.346932] dhdsdio_isr: Enter
<4>[ 4165.347066] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.347220] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.347373] dhdsdio_dpc: Enter
<4>[ 4165.347489] dhdsdio_clkctl: Enter
<4>[ 4165.347610] dhdsdio_sdclk: Enter
<4>[ 4165.347726] dhdsdio_htclk: Enter
<4>[ 4165.348002] CLKCTL: turned ON
<4>[ 4165.348144] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.348515] dhdsdio_readframes: Enter
<4>[ 4165.348804] RxHdr:
<4>[ 4165.348984]   0000: 30 00 cf ff 44 00 00 0c 00 52 00 00 
<4>[ 4165.349153] dhdsdio_read_control: Enter
<4>[ 4165.349286] RxCtrl:
<4>[ 4165.349465]   0000: 30 00 cf ff 44 00 00 0c 00 52 00 00 07 01 00 00 
<4>[ 4165.349728]   0016: 14 00 00 00 00 00 43 00 00 00 00 00 69 73 5f 57 
<4>[ 4165.349993]   0032: 50 53 5f 65 6e 72 6f 6c 6c 65 65 00 00 00 00 00 
<4>[ 4165.350318] RxHdr:
<4>[ 4165.350492]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.350663] dhdsdio_readframes: processed 1 frames
<4>[ 4165.350823] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.351075] dhdcdc_cmplt: Enter
<4>[ 4165.351204] dhd_bus_rxctl: Enter
<4>[ 4165.351342] dhd_bus_rxctl: resumed on rxctl frame, got 36 expected 36
<4>[ 4165.351616] eth0: SIOCSIWAUTH
<4>[ 4165.351755] eth0: SIOCSIWAUTH, paramid = 0x8, paramval = 0x0
<4>[ 4165.352058] 
<4>[ 4165.352079] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:bf26e82c, len:25 ,
<4>[ 4165.352387] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.352553] dhd_prot_ioctl: Enter
<4>[ 4165.352676] dhdcdc_query_ioctl: Enter
<4>[ 4165.352812] dhdcdc_query_ioctl: cmd 263 len 25
<4>[ 4165.352954] dhdcdc_msg: Enter
<4>[ 4165.353065] dhd_bus_txctl: Enter
<4>[ 4165.353184] dhdsdio_clkctl: Enter
<4>[ 4165.353307] Tx Frame:
<4>[ 4165.353488]   0000: 41 00 be ff 46 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.353750]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 19 00 00 00 
<4>[ 4165.354015]   0032: 00 00 44 00 00 00 00 00 72 78 5f 75 6e 65 6e 63 
<4>[ 4165.354524]   0048: 72 79 70 74 65 64 5f 65 61 70 6f 6c 00 00 00 00 
<4>[ 4165.354813]   0064: 00 00 00 50 f2 02 00 00 00 00 00 00 6f 6d 33 71 
<4>[ 4165.355080]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.355571] dhd_watchdog_thread:
<4>[ 4165.355747] dhd_bus_watchdog: Enter
<4>[ 4165.355882] dhdsdio_clkctl: Enter
<4>[ 4165.356005] dhdsdio_htclk: Enter
<4>[ 4165.356217] CLKCTL: turned OFF
<4>[ 4165.356349] dhdsdio_sdclk: Enter
<4>[ 4165.356478] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.356729] dhdsdio_isr: Enter
<4>[ 4165.356867] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.357020] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.357172] dhdsdio_dpc: Enter
<4>[ 4165.357287] dhdsdio_clkctl: Enter
<4>[ 4165.357406] dhdsdio_sdclk: Enter
<4>[ 4165.357522] dhdsdio_htclk: Enter
<4>[ 4165.357799] CLKCTL: turned ON
<4>[ 4165.357942] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.358301] dhdsdio_readframes: Enter
<4>[ 4165.358590] RxHdr:
<4>[ 4165.358769]   0000: 35 00 ca ff 45 00 00 0c 00 53 00 00 
<4>[ 4165.358939] dhdsdio_read_control: Enter
<4>[ 4165.359071] RxCtrl:
<4>[ 4165.359251]   0000: 35 00 ca ff 45 00 00 0c 00 53 00 00 07 01 00 00 
<4>[ 4165.359517]   0016: 00 00 00 00 01 00 44 00 e9 ff ff ff 72 78 5f 75 
<4>[ 4165.359786]   0032: 6e 65 6e 63 72 79 70 74 65 64 5f 65 61 70 6f 6c 
<4>[ 4165.359995]   0048: 00 00 00 00 00 
<4>[ 4165.360260] RxHdr:
<4>[ 4165.360435]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.360607] dhdsdio_readframes: processed 1 frames
<4>[ 4165.360770] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.361022] dhdcdc_cmplt: Enter
<4>[ 4165.361155] dhd_bus_rxctl: Enter
<4>[ 4165.361294] dhd_bus_rxctl: resumed on rxctl frame, got 41 expected 41
<4>[ 4165.361518] wl_iw_set_wpaauth: rx_unencrypted_eapol -95
<4>[ 4165.361740] wl_iw_set_freq eth0: SIOCSIWFREQ
<4>[ 4165.361936] 
<4>[ 4165.361959] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x1e, 
buf:c2297ddc, len:4 ,
<4>[ 4165.362268] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.362436] dhd_prot_ioctl: Enter
<4>[ 4165.362560] dhdcdc_query_ioctl: Enter
<4>[ 4165.362698] dhdcdc_query_ioctl: cmd 30 len 4
<4>[ 4165.362836] dhdcdc_msg: Enter
<4>[ 4165.362947] dhd_bus_txctl: Enter
<4>[ 4165.363065] dhdsdio_clkctl: Enter
<4>[ 4165.363188] Tx Frame:
<4>[ 4165.363372]   0000: 2c 00 d3 ff 47 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.363633]   0016: 00 00 00 00 00 00 00 00 1e 00 00 00 04 00 00 00 
<4>[ 4165.363896]   0032: 00 00 45 00 00 00 00 00 02 00 00 00 6e 65 6e 63 
<4>[ 4165.364163]   0048: 72 79 70 74 65 64 5f 65 61 70 6f 6c 00 00 00 00 
<4>[ 4165.364724] dhd_watchdog_thread:
<4>[ 4165.364878] dhd_bus_watchdog: Enter
<4>[ 4165.365010] dhdsdio_clkctl: Enter
<4>[ 4165.365131] dhdsdio_htclk: Enter
<4>[ 4165.365341] CLKCTL: turned OFF
<4>[ 4165.365476] dhdsdio_sdclk: Enter
<4>[ 4165.365604] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.365769] dhdcdc_cmplt: Enter
<4>[ 4165.365895] dhd_bus_rxctl: Enter
<4>[ 4165.466564] dhdsdio_isr: Enter
<4>[ 4165.466720] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.466879] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.467033] dhdsdio_dpc: Enter
<4>[ 4165.467150] dhdsdio_clkctl: Enter
<4>[ 4165.467270] dhdsdio_sdclk: Enter
<4>[ 4165.467387] dhdsdio_htclk: Enter
<4>[ 4165.467673] CLKCTL: turned ON
<4>[ 4165.467821] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.468191] dhdsdio_readframes: Enter
<4>[ 4165.468481] RxHdr:
<4>[ 4165.468663]   0000: 20 00 df ff 46 00 00 0c 00 54 00 00 
<4>[ 4165.468832] dhdsdio_read_control: Enter
<4>[ 4165.468964] RxCtrl:
<4>[ 4165.469143]   0000: 20 00 df ff 46 00 00 0c 00 54 00 00 1e 00 00 00 
<4>[ 4165.469407]   0016: 04 00 00 00 00 00 45 00 00 00 00 00 02 00 00 00 
<4>[ 4165.469755] RxHdr:
<4>[ 4165.469932]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.470105] dhdsdio_readframes: processed 1 frames
<4>[ 4165.470267] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.470539] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4165.470807] eth0: SIOCSIWCOMMIT
<4>[ 4165.470981] 
<4>[ 4165.471003] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:c2297d98, len:36 ,
<4>[ 4165.471311] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.471475] dhd_prot_ioctl: Enter
<4>[ 4165.471599] dhdcdc_query_ioctl: Enter
<4>[ 4165.471736] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4165.471877] dhdcdc_msg: Enter
<4>[ 4165.471987] dhd_bus_txctl: Enter
<4>[ 4165.472107] dhdsdio_clkctl: Enter
<4>[ 4165.472231] Tx Frame:
<4>[ 4165.472414]   0000: 4c 00 b3 ff 48 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.472676]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4165.472939]   0032: 00 00 46 00 00 00 00 00 0b 00 00 00 00 60 29 c2 
<4>[ 4165.473204]   0048: 13 01 00 60 20 27 02 ca 00 00 00 00 08 26 1b c0 
<4>[ 4165.473471]   0064: 00 50 1d c9 68 e4 5b c0 13 01 00 60 6f 6d 33 71 
<4>[ 4165.473730]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.477026] dhdsdio_isr: Enter
<4>[ 4165.477184] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.477342] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.477497] dhdsdio_dpc: Enter
<4>[ 4165.477689] dhd_watchdog_thread:
<4>[ 4165.477823] dhd_bus_watchdog: Enter
<4>[ 4165.477951] dhdsdio_clkctl: Enter
<4>[ 4165.478071] dhdsdio_htclk: Enter
<4>[ 4165.478296] CLKCTL: turned OFF
<4>[ 4165.478432] dhdsdio_sdclk: Enter
<4>[ 4165.478562] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.478720] dhdsdio_clkctl: Enter
<4>[ 4165.478851] dhdsdio_sdclk: Enter
<4>[ 4165.478970] dhdsdio_htclk: Enter
<4>[ 4165.479254] CLKCTL: turned ON
<4>[ 4165.479399] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.479769] dhdsdio_readframes: Enter
<4>[ 4165.480057] RxHdr:
<4>[ 4165.480235]   0000: 40 00 bf ff 47 00 00 0c 00 55 00 00 
<4>[ 4165.480404] dhdsdio_read_control: Enter
<4>[ 4165.480535] RxCtrl:
<4>[ 4165.480713]   0000: 40 00 bf ff 47 00 00 0c 00 55 00 00 19 00 00 00 
<4>[ 4165.480974]   0016: 24 00 00 00 00 00 46 00 00 00 00 00 00 00 00 00 
<4>[ 4165.481233]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.481492]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.481818] RxHdr:
<4>[ 4165.481992]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.482163] dhdsdio_readframes: processed 1 frames
<4>[ 4165.482325] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.482709] dhdcdc_cmplt: Enter
<4>[ 4165.482852] dhd_bus_rxctl: Enter
<4>[ 4165.482994] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4165.484397] dhd_watchdog_thread:
<4>[ 4165.484554] dhd_bus_watchdog: Enter
<4>[ 4165.484746] dhdsdio_clkctl: Enter
<4>[ 4165.484879] dhdsdio_htclk: Enter
<4>[ 4165.485100] CLKCTL: turned OFF
<4>[ 4165.485237] dhdsdio_sdclk: Enter
<4>[ 4165.485367] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.487082] eth0: SIOCSIWESSID
<4>[ 4165.487256] wl_iw_ch_to_chanspec  join_params->params.chanspec_list[0]= 
2B02
<4>[ 4165.487501] 
<4>[ 4165.487522] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x1a, 
buf:c2297da0, len:52 ,
<4>[ 4165.487832] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.488000] dhd_prot_ioctl: Enter
<4>[ 4165.488124] dhdcdc_query_ioctl: Enter
<4>[ 4165.488262] dhdcdc_query_ioctl: cmd 26 len 52
<4>[ 4165.488402] dhdcdc_msg: Enter
<4>[ 4165.488512] dhd_bus_txctl: Enter
<4>[ 4165.488633] dhdsdio_clkctl: Enter
<4>[ 4165.488754] dhdsdio_sdclk: Enter
<4>[ 4165.488871] dhdsdio_htclk: Enter
<4>[ 4165.497254] CLKCTL: turned ON
<4>[ 4165.498157] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.498308] Tx Frame:
<4>[ 4165.498501]   0000: 5c 00 a3 ff 49 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.498765]   0016: 00 00 00 00 00 00 00 00 1a 00 00 00 34 00 00 00 
<4>[ 4165.499029]   0032: 00 00 47 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4165.499290]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.499551]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff 
<4>[ 4165.499812]   0080: ff ff 00 00 01 00 00 00 02 2b 00 00 00 00 00 00 
<4>[ 4165.508926] dhd_watchdog_thread:
<4>[ 4165.509121] dhd_bus_watchdog: Enter
<4>[ 4165.509261] dhdsdio_clkctl: Enter
<4>[ 4165.509385] dhdsdio_htclk: Enter
<4>[ 4165.509604] CLKCTL: turned OFF
<4>[ 4165.509739] dhdsdio_sdclk: Enter
<4>[ 4165.509867] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.510115] dhdsdio_isr: Enter
<4>[ 4165.510253] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.510410] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.510564] dhdsdio_dpc: Enter
<4>[ 4165.510681] dhdsdio_clkctl: Enter
<4>[ 4165.510801] dhdsdio_sdclk: Enter
<4>[ 4165.510917] dhdsdio_htclk: Enter
<4>[ 4165.511248] CLKCTL: turned ON
<4>[ 4165.511396] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.511768] dhdsdio_readframes: Enter
<4>[ 4165.512058] RxHdr:
<4>[ 4165.512236]   0000: 50 00 af ff 48 00 00 0c 00 56 00 00 
<4>[ 4165.512405] dhdsdio_read_control: Enter
<4>[ 4165.512680] RxCtrl:
<4>[ 4165.512881]   0000: 50 00 af ff 48 00 00 0c 00 56 00 00 1a 00 00 00 
<4>[ 4165.513148]   0016: 34 00 00 00 00 00 47 00 00 00 00 00 05 00 00 00 
<4>[ 4165.513413]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.513673]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.513937]   0064: ff ff ff ff ff ff 00 00 01 00 00 00 02 2b 00 00 
<4>[ 4165.514405] RxHdr:
<4>[ 4165.514589]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.514763] dhdsdio_readframes: processed 1 frames
<4>[ 4165.514927] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.515153] dhd_watchdog_thread:
<4>[ 4165.515282] dhd_bus_watchdog: Enter
<4>[ 4165.515407] dhdsdio_clkctl: Enter
<4>[ 4165.515529] dhdsdio_htclk: Enter
<4>[ 4165.515747] CLKCTL: turned OFF
<4>[ 4165.515880] dhdsdio_sdclk: Enter
<4>[ 4165.516010] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.516351] dhdcdc_cmplt: Enter
<4>[ 4165.516494] dhd_bus_rxctl: Enter
<4>[ 4165.516641] dhd_bus_rxctl: resumed on rxctl frame, got 68 expected 68
<4>[ 4165.516873] wl_iw_set_essid: join SSID=tom3q ch=2
<4>[ 4165.520138] eth0: SIOCSIWAP
<4>[ 4165.520298] wl_iw_set_wap  target_channel=2
<4>[ 4165.520451] wl_iw_ch_to_chanspec  join_params->params.chanspec_list[0]= 
2B02
<4>[ 4165.520688] 
<4>[ 4165.520710] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x1a, 
buf:c2297d98, len:52 ,
<4>[ 4165.521017] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.521185] dhd_prot_ioctl: Enter
<4>[ 4165.521311] dhdcdc_query_ioctl: Enter
<4>[ 4165.521446] dhdcdc_query_ioctl: cmd 26 len 52
<4>[ 4165.521586] dhdcdc_msg: Enter
<4>[ 4165.521696] dhd_bus_txctl: Enter
<4>[ 4165.521817] dhdsdio_clkctl: Enter
<4>[ 4165.521936] dhdsdio_sdclk: Enter
<4>[ 4165.522052] dhdsdio_htclk: Enter
<4>[ 4165.531269] CLKCTL: turned ON
<4>[ 4165.531438] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.531568] Tx Frame:
<4>[ 4165.531753]   0000: 5c 00 a3 ff 4a 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.532016]   0016: 00 00 00 00 00 00 00 00 1a 00 00 00 34 00 00 00 
<4>[ 4165.532279]   0032: 00 00 48 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4165.532540]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.532800]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 1d 7e bd 
<4>[ 4165.533061]   0080: 45 a2 00 00 01 00 00 00 02 2b 00 00 00 00 00 00 
<4>[ 4165.542287] dhd_watchdog_thread:
<4>[ 4165.542483] dhd_bus_watchdog: Enter
<4>[ 4165.542622] dhdsdio_clkctl: Enter
<4>[ 4165.542748] dhdsdio_htclk: Enter
<4>[ 4165.542969] CLKCTL: turned OFF
<4>[ 4165.543103] dhdsdio_sdclk: Enter
<4>[ 4165.543234] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.543481] dhdsdio_isr: Enter
<4>[ 4165.543618] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.543773] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.543923] dhdsdio_dpc: Enter
<4>[ 4165.544039] dhdsdio_clkctl: Enter
<4>[ 4165.544158] dhdsdio_sdclk: Enter
<4>[ 4165.544379] dhdsdio_htclk: Enter
<4>[ 4165.544685] CLKCTL: turned ON
<4>[ 4165.544832] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.545206] dhdsdio_readframes: Enter
<4>[ 4165.545493] RxHdr:
<4>[ 4165.545674]   0000: 50 00 af ff 49 00 00 0c 00 57 00 00 
<4>[ 4165.545844] dhdsdio_read_control: Enter
<4>[ 4165.546117] RxCtrl:
<4>[ 4165.546317]   0000: 50 00 af ff 49 00 00 0c 00 57 00 00 1a 00 00 00 
<4>[ 4165.546583]   0016: 34 00 00 00 00 00 48 00 00 00 00 00 05 00 00 00 
<4>[ 4165.546848]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.547108]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.547372]   0064: 00 1d 7e bd 45 a2 00 00 01 00 00 00 02 2b 00 00 
<4>[ 4165.547693] RxHdr:
<4>[ 4165.547873]   0000: 5c 00 a3 ff 4a 01 00 0e 00 57 00 00 
<4>[ 4165.548198] Rx Data:
<4>[ 4165.548402]   0000: 5c 00 a3 ff 4a 01 00 0e 00 57 00 00 00 00 20 00 
<4>[ 4165.548674]   0016: 00 00 00 26 37 82 86 b6 02 26 37 82 86 b6 88 6c 
<4>[ 4165.548939]   0032: 80 01 00 68 00 00 10 18 00 01 00 02 00 00 00 00 
<4>[ 4165.549200]   0048: 00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.549462]   0064: 00 00 00 00 00 00 00 00 77 6c 30 00 00 00 00 00 
<4>[ 4165.549701]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.549860] dhd_prot_hdrpull: Enter
<4>[ 4165.549983] dhd_rx_frame: Enter
<4>[ 4165.550120] dhd_ifname2idx: return idx 0 for "wl0"
<4>[ 4165.550286] wl_host_event: MAC event 0, flags 0, status 4
<4>[ 4165.550488] EVENT: SET_SSID, event ID = 0
<4>[ 4165.550629] MACEVENT: SET_SSID, unexpected status 4
<4>[ 4165.550796] wl_iw_event: dev=eth0 event=0 
<4>[ 4165.550933] Unknown Event 0: ignoring
<4>[ 4165.551254] RxHdr:
<4>[ 4165.551433]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.551606] dhdsdio_readframes: processed 2 frames
<4>[ 4165.551768] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 2
<4>[ 4165.552176] dhdcdc_cmplt: Enter
<4>[ 4165.552322] dhd_bus_rxctl: Enter
<4>[ 4165.552465] dhd_bus_rxctl: resumed on rxctl frame, got 68 expected 68
<4>[ 4165.552724] wl_iw_set_wap: join SSID=tom3q BSSID=00:1d:7e:bd:45:a2 ch=2
<4>[ 4165.554405] dhd_watchdog_thread:
<4>[ 4165.554566] dhd_bus_watchdog: Enter
<4>[ 4165.554700] dhdsdio_clkctl: Enter
<4>[ 4165.554822] dhdsdio_htclk: Enter
<4>[ 4165.555049] CLKCTL: turned OFF
<4>[ 4165.555185] dhdsdio_sdclk: Enter
<4>[ 4165.555315] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.555600] dhdsdio_isr: Enter
<4>[ 4165.555741] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.555896] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.556059] dhdsdio_dpc: Enter
<4>[ 4165.556175] dhdsdio_clkctl: Enter
<4>[ 4165.556295] dhdsdio_sdclk: Enter
<4>[ 4165.556413] dhdsdio_htclk: Enter
<4>[ 4165.556692] CLKCTL: turned ON
<4>[ 4165.556836] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.557253] dhdsdio_readframes: Enter
<4>[ 4165.557552] RxHdr:
<4>[ 4165.557734]   0000: 5c 00 a3 ff 4b 01 00 0e 00 57 00 00 
<4>[ 4165.558054] Rx Data:
<4>[ 4165.558258]   0000: 5c 00 a3 ff 4b 01 00 0e 00 57 00 00 00 00 20 00 
<4>[ 4165.558531]   0016: 00 00 00 26 37 82 86 b6 02 26 37 82 86 b6 88 6c 
<4>[ 4165.558796]   0032: 80 01 00 68 00 00 10 18 00 01 00 02 00 00 00 00 
<4>[ 4165.559056]   0048: 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.559321]   0064: 00 00 00 1d 7e bd 45 a2 77 6c 30 00 00 00 00 00 
<4>[ 4165.559561]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.559721] dhd_prot_hdrpull: Enter
<4>[ 4165.559844] dhd_rx_frame: Enter
<4>[ 4165.559981] dhd_ifname2idx: return idx 0 for "wl0"
<4>[ 4165.560146] wl_host_event: MAC event 3, flags 0, status 0
<4>[ 4165.560352] EVENT: AUTH, event ID = 3
<4>[ 4165.560488] MACEVENT: AUTH, MAC 00:1d:7e:bd:45:a2, Open System, SUCCESS
<4>[ 4165.560689] wl_iw_event: dev=eth0 event=3 
<4>[ 4165.560825] Unknown Event 3: ignoring
<4>[ 4165.561149] RxHdr:
<4>[ 4165.561333]   0000: 76 00 89 ff 4c 01 00 0e 00 57 00 00 
<4>[ 4165.561653] Rx Data:
<4>[ 4165.561857]   0000: 76 00 89 ff 4c 01 00 0e 00 57 00 00 00 00 20 00 
<4>[ 4165.562131]   0016: 00 00 00 26 37 82 86 b6 02 26 37 82 86 b6 88 6c 
<4>[ 4165.562396]   0032: 80 01 00 82 00 00 10 18 00 01 00 02 00 01 00 00 
<4>[ 4165.562656]   0048: 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.562920]   0064: 00 1a 00 1d 7e bd 45 a2 77 6c 30 00 00 00 00 00 
<4>[ 4165.563181]   0080: 00 00 00 00 00 00 00 00 00 00 dd 18 00 50 f2 01 
<4>[ 4165.563445]   0096: 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 
<4>[ 4165.563658]   0112: f2 02 00 00 00 00 
<4>[ 4165.563784] dhd_prot_hdrpull: Enter
<4>[ 4165.563911] dhd_rx_frame: Enter
<4>[ 4165.564047] dhd_ifname2idx: return idx 0 for "wl0"
<4>[ 4165.564213] wl_host_event: MAC event 16, flags 1, status 0
<4>[ 4165.564527] dhd_watchdog_thread:
<4>[ 4165.564668] dhd_bus_watchdog: Enter
<4>[ 4165.564795] dhdsdio_clkctl: Enter
<4>[ 4165.564916] dhdsdio_htclk: Enter
<4>[ 4165.565136] CLKCTL: turned OFF
<4>[ 4165.565272] dhdsdio_sdclk: Enter
<4>[ 4165.565402] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.565617] EVENT: LINK, event ID = 16
<4>[ 4165.565758] MACEVENT: LINK UP
<4>[ 4165.565871]  data (26) :  0xdd  0x18  0x00  0x50  0xf2  0x01  0x01  0x00  
0x00  0x50  0xf2  0x02  0x01  0x00  0x00  0x50  0xf2  0x02  0x01  0x00  0x00  
0x50  0xf2  0x02  0x00  0x00 
<4>[ 4165.566724] wl_iw_event: dev=eth0 event=16 
<4>[ 4165.566859] STA_LINK_UP
<4>[ 4165.566954] Link UP
<4>[ 4165.567300] RxHdr:
<4>[ 4165.567490]   0000: 83 00 7c ff 4d 02 00 0e 00 57 00 00 
<4>[ 4165.567893] Rx Data:
<4>[ 4165.568097]   0000: 83 00 7c ff 4d 02 00 0e 00 57 00 00 00 00 20 00 
<4>[ 4165.568370]   0016: 00 00 00 26 37 82 86 b6 00 1d 7e bd 45 a2 88 8e 
<4>[ 4165.568635]   0032: 01 03 00 5f fe 00 89 00 20 00 00 00 00 00 00 00 
<4>[ 4165.568904]   0048: 5e db f9 5c 57 eb e4 65 76 3a 09 94 7c 5c c6 12 
<4>[ 4165.569172]   0064: 44 ed 12 db d1 ff a7 a4 e1 31 5a 27 fa 74 ee 88 
<4>[ 4165.569433]   0080: 67 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.569694]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.569954]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.570153]   0128: 00 00 00 
<4>[ 4165.570264] dhd_prot_hdrpull: Enter
<4>[ 4165.570389] dhd_rx_frame: Enter
<4>[ 4165.570693] RxHdr:
<4>[ 4165.570872]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.571045] dhdsdio_readframes: processed 3 frames
<4>[ 4165.571207] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 3
<4>[ 4165.571549] dhdsdio_isr: Enter
<4>[ 4165.571690] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.571844] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.572002] dhdsdio_dpc: Enter
<4>[ 4165.572120] dhdsdio_clkctl: Enter
<4>[ 4165.572240] dhdsdio_sdclk: Enter
<4>[ 4165.572358] dhdsdio_htclk: Enter
<4>[ 4165.572692] CLKCTL: turned ON
<4>[ 4165.572843] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.573218] dhdsdio_readframes: Enter
<4>[ 4165.573509] RxHdr:
<4>[ 4165.573689]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.573861] dhdsdio_readframes: processed 0 frames
<4>[ 4165.574021] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 0
<4>[ 4165.574371] dhd_watchdog_thread:
<4>[ 4165.574515] dhd_bus_watchdog: Enter
<4>[ 4165.574645] dhdsdio_clkctl: Enter
<4>[ 4165.574766] dhdsdio_htclk: Enter
<4>[ 4165.574984] CLKCTL: turned OFF
<4>[ 4165.575117] dhdsdio_sdclk: Enter
<4>[ 4165.575247] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.595319] eth0: SIOCGIWAP
<4>[ 4165.595512] 
<4>[ 4165.595535] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x17, 
buf:c2297ede, len:6 ,
<4>[ 4165.595848] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.596018] dhd_prot_ioctl: Enter
<4>[ 4165.596144] dhdcdc_query_ioctl: Enter
<4>[ 4165.596279] dhdcdc_query_ioctl: cmd 23 len 6
<4>[ 4165.596418] dhdcdc_msg: Enter
<4>[ 4165.596533] dhd_bus_txctl: Enter
<4>[ 4165.596657] dhdsdio_clkctl: Enter
<4>[ 4165.596776] dhdsdio_sdclk: Enter
<4>[ 4165.596892] dhdsdio_htclk: Enter
<4>[ 4165.604713] CLKCTL: turned ON
<4>[ 4165.604885] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.605015] Tx Frame:
<4>[ 4165.605200]   0000: 2e 00 d1 ff 4b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.605463]   0016: 00 00 00 00 00 00 00 00 17 00 00 00 06 00 00 00 
<4>[ 4165.605723]   0032: 00 00 49 00 00 00 00 00 00 00 00 00 00 00 6d 33 
<4>[ 4165.605982]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.612492] dhdsdio_isr: Enter
<4>[ 4165.612649] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.612809] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.612962] dhdsdio_dpc: Enter
<4>[ 4165.613292] dhdsdio_clkctl: Enter
<4>[ 4165.613707] dhdsdio_readframes: Enter
<4>[ 4165.614004] RxHdr:
<4>[ 4165.614189]   0000: 22 00 dd ff 4e 00 00 0c 00 58 00 00 
<4>[ 4165.614526] dhdsdio_read_control: Enter
<4>[ 4165.614680] RxCtrl:
<4>[ 4165.614864]   0000: 22 00 dd ff 4e 00 00 0c 00 58 00 00 17 00 00 00 
<4>[ 4165.615131]   0016: 06 00 00 00 00 00 49 00 00 00 00 00 00 1d 7e bd 
<4>[ 4165.615327]   0032: 45 a2 
<4>[ 4165.615589] RxHdr:
<4>[ 4165.615766]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.615936] dhdsdio_readframes: processed 1 frames
<4>[ 4165.616097] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.616324] dhd_watchdog_thread:
<4>[ 4165.616455] dhd_bus_watchdog: Enter
<4>[ 4165.616583] dhdsdio_clkctl: Enter
<4>[ 4165.616704] dhdsdio_htclk: Enter
<4>[ 4165.616920] CLKCTL: turned OFF
<4>[ 4165.617053] dhdsdio_sdclk: Enter
<4>[ 4165.617182] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.617682] dhdcdc_cmplt: Enter
<4>[ 4165.617831] dhd_bus_rxctl: Enter
<4>[ 4165.617975] dhd_bus_rxctl: resumed on rxctl frame, got 22 expected 22
<4>[ 4165.623666] eth0: SIOCGIWESSID
<4>[ 4165.623865] 
<4>[ 4165.623887] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:c2297da8, len:36 ,
<4>[ 4165.624204] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.624492] dhd_prot_ioctl: Enter
<4>[ 4165.624637] dhdcdc_query_ioctl: Enter
<4>[ 4165.624776] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4165.624917] dhdcdc_msg: Enter
<4>[ 4165.625029] dhd_bus_txctl: Enter
<4>[ 4165.625151] dhdsdio_clkctl: Enter
<4>[ 4165.625270] dhdsdio_sdclk: Enter
<4>[ 4165.625386] dhdsdio_htclk: Enter
<4>[ 4165.638136] CLKCTL: turned ON
<4>[ 4165.638306] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.638439] Tx Frame:
<4>[ 4165.638626]   0000: 4c 00 b3 ff 4c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.638889]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4165.639150]   0032: 00 00 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.639414]   0048: 00 00 00 00 00 60 29 c2 f0 7d 29 c2 22 00 00 00 
<4>[ 4165.639678]   0064: 00 00 00 00 63 00 00 00 ff ff ff ff 00 1d 7e bd 
<4>[ 4165.639938]   0080: 45 a2 00 00 01 00 00 00 02 2b 00 00 00 00 00 00 
<4>[ 4165.643834] dhdsdio_isr: Enter
<4>[ 4165.643991] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.644152] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.644469] dhdsdio_dpc: Enter
<4>[ 4165.644674] dhd_watchdog_thread:
<4>[ 4165.644809] dhd_bus_watchdog: Enter
<4>[ 4165.644937] dhdsdio_clkctl: Enter
<4>[ 4165.645056] dhdsdio_htclk: Enter
<4>[ 4165.645283] CLKCTL: turned OFF
<4>[ 4165.645421] dhdsdio_sdclk: Enter
<4>[ 4165.645552] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.645714] dhdsdio_clkctl: Enter
<4>[ 4165.645846] dhdsdio_sdclk: Enter
<4>[ 4165.645966] dhdsdio_htclk: Enter
<4>[ 4165.646291] CLKCTL: turned ON
<4>[ 4165.646440] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.646813] dhdsdio_readframes: Enter
<4>[ 4165.647102] RxHdr:
<4>[ 4165.647283]   0000: 40 00 bf ff 4f 00 00 0c 00 59 00 00 
<4>[ 4165.647451] dhdsdio_read_control: Enter
<4>[ 4165.647583] RxCtrl:
<4>[ 4165.647760]   0000: 40 00 bf ff 4f 00 00 0c 00 59 00 00 19 00 00 00 
<4>[ 4165.648022]   0016: 24 00 00 00 00 00 4a 00 00 00 00 00 05 00 00 00 
<4>[ 4165.648285]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.648544]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.648872] RxHdr:
<4>[ 4165.649050]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.649219] dhdsdio_readframes: processed 1 frames
<4>[ 4165.649379] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.649633] dhdcdc_cmplt: Enter
<4>[ 4165.649766] dhd_bus_rxctl: Enter
<4>[ 4165.649905] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4165.650182] eth0: SIOCGIWAP
<4>[ 4165.650343] 
<4>[ 4165.650366] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x17, 
buf:c2297ede, len:6 ,
<4>[ 4165.650672] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.650835] dhd_prot_ioctl: Enter
<4>[ 4165.650959] dhdcdc_query_ioctl: Enter
<4>[ 4165.651094] dhdcdc_query_ioctl: cmd 23 len 6
<4>[ 4165.651231] dhdcdc_msg: Enter
<4>[ 4165.651341] dhd_bus_txctl: Enter
<4>[ 4165.651460] dhdsdio_clkctl: Enter
<4>[ 4165.651583] Tx Frame:
<4>[ 4165.651766]   0000: 2e 00 d1 ff 4d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.652028]   0016: 00 00 00 00 00 00 00 00 17 00 00 00 06 00 00 00 
<4>[ 4165.652289]   0032: 00 00 4b 00 00 00 00 00 00 00 00 00 00 00 6d 33 
<4>[ 4165.652548]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.665108] dhd_watchdog_thread:
<4>[ 4165.665269] dhd_bus_watchdog: Enter
<4>[ 4165.665402] dhdsdio_clkctl: Enter
<4>[ 4165.665523] dhdsdio_htclk: Enter
<4>[ 4165.665745] CLKCTL: turned OFF
<4>[ 4165.665882] dhdsdio_sdclk: Enter
<4>[ 4165.666012] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.666303] dhdcdc_cmplt: Enter
<4>[ 4165.666442] dhd_bus_rxctl: Enter
<4>[ 4165.688552] dhdsdio_isr: Enter
<4>[ 4165.688711] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.688871] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.689024] dhdsdio_dpc: Enter
<4>[ 4165.689141] dhdsdio_clkctl: Enter
<4>[ 4165.689262] dhdsdio_sdclk: Enter
<4>[ 4165.689379] dhdsdio_htclk: Enter
<4>[ 4165.689715] CLKCTL: turned ON
<4>[ 4165.689868] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.690243] dhdsdio_readframes: Enter
<4>[ 4165.690536] RxHdr:
<4>[ 4165.690715]   0000: 22 00 dd ff 50 00 00 0c 00 5a 00 00 
<4>[ 4165.690884] dhdsdio_read_control: Enter
<4>[ 4165.691015] RxCtrl:
<4>[ 4165.691194]   0000: 22 00 dd ff 50 00 00 0c 00 5a 00 00 17 00 00 00 
<4>[ 4165.691457]   0016: 06 00 00 00 00 00 4b 00 00 00 00 00 00 1d 7e bd 
<4>[ 4165.691652]   0032: 45 a2 
<4>[ 4165.691920] RxHdr:
<4>[ 4165.692101]   0000: 5c 00 a3 ff 51 01 07 0e 00 5a 00 00 
<4>[ 4165.692420] Rx Data:
<4>[ 4165.692626]   0000: 5c 00 a3 ff 51 01 07 0e 00 5a 00 00 00 00 20 00 
<4>[ 4165.692899]   0016: 00 00 00 26 37 82 86 b6 02 26 37 82 86 b6 88 6c 
<4>[ 4165.693166]   0032: 80 01 00 68 00 00 10 18 00 01 00 02 00 00 00 00 
<4>[ 4165.693427]   0048: 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.693692]   0064: 00 00 00 1d 7e bd 45 a2 77 6c 30 00 00 00 00 00 
<4>[ 4165.693933]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.694093] dhd_prot_hdrpull: Enter
<4>[ 4165.694218] dhd_rx_frame: Enter
<4>[ 4165.694478] dhd_watchdog_thread:
<4>[ 4165.694618] dhd_bus_watchdog: Enter
<4>[ 4165.694748] dhdsdio_clkctl: Enter
<4>[ 4165.694868] dhdsdio_htclk: Enter
<4>[ 4165.695089] CLKCTL: turned OFF
<4>[ 4165.695226] dhdsdio_sdclk: Enter
<4>[ 4165.695355] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.695542] dhd_ifname2idx: return idx 0 for "wl0"
<4>[ 4165.695718] wl_host_event: MAC event 1, flags 0, status 0
<4>[ 4165.695925] EVENT: JOIN, event ID = 1
<4>[ 4165.696058] MACEVENT: JOIN, MAC 00:1d:7e:bd:45:a2
<4>[ 4165.696221] wl_iw_event: dev=eth0 event=1 
<4>[ 4165.696357] STA connect received 1
<4>[ 4165.696861] Rx Data:
<4>[ 4165.697076]   0000: 63 00 9c ff 52 01 00 0e 00 5a 00 00 00 00 20 00 
<4>[ 4165.697348]   0016: 00 00 00 26 37 82 86 b6 02 26 37 82 86 b6 88 6c 
<4>[ 4165.697612]   0032: 80 01 00 6f 00 00 10 18 00 01 00 02 00 00 00 00 
<4>[ 4165.697872]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.698137]   0064: 00 07 00 1d 7e bd 45 a2 77 6c 30 00 00 00 00 00 
<4>[ 4165.698398]   0080: 00 00 00 00 00 00 00 00 00 00 00 05 74 6f 6d 33 
<4>[ 4165.698595]   0096: 71 00 00 
<4>[ 4165.698708] dhd_prot_hdrpull: Enter
<4>[ 4165.698834] dhd_rx_frame: Enter
<4>[ 4165.698969] dhd_ifname2idx: return idx 0 for "wl0"
<4>[ 4165.699132] wl_host_event: MAC event 0, flags 0, status 0
<4>[ 4165.699336] EVENT: SET_SSID, event ID = 0
<4>[ 4165.699474] MACEVENT: SET_SSID, MAC 00:1d:7e:bd:45:a2
<4>[ 4165.699628]  data (7) :  0x00  0x05  0x74  0x6f  0x6d  0x33  0x71 
<4>[ 4165.699942] wl_iw_event: dev=eth0 event=0 
<4>[ 4165.700079] Unknown Event 0: ignoring
<4>[ 4165.700225] Connection status: Conn Success 00 00
<4>[ 4165.700597] RxHdr:
<4>[ 4165.700778]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.700951] dhdsdio_readframes: processed 3 frames
<4>[ 4165.701113] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 3
<4>[ 4165.701389] dhd_bus_rxctl: resumed on rxctl frame, got 22 expected 22
<4>[ 4165.743275] dhd_start_xmit: Enter
<4>[ 4165.743458] dhd_prot_hdrpush: Enter
<4>[ 4165.743596] dhd_bus_txdata: Enter
<4>[ 4165.743724] dhd_bus_txdata: deferring pktq len 0
<4>[ 4165.743939] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4165.744106] dhdsdio_dpc: Enter
<4>[ 4165.744349] dhdsdio_clkctl: Enter
<4>[ 4165.744493] dhdsdio_sdclk: Enter
<4>[ 4165.744617] dhdsdio_htclk: Enter
<4>[ 4165.744909] CLKCTL: turned ON
<4>[ 4165.745057] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.745193] dhdsdio_sendfromq: Enter
<4>[ 4165.745328] dhdsdio_txpkt: Enter
<4>[ 4165.745450] Tx Frame:
<4>[ 4165.745636]   0000: 9b 00 64 ff 4e 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4165.745903]   0016: 00 00 00 1d 7e bd 45 a2 00 26 37 82 86 b6 88 8e 
<4>[ 4165.746166]   0032: 01 03 00 77 fe 01 09 00 20 00 00 00 00 00 00 00 
<4>[ 4165.746433]   0048: 5e e8 3b 0a 8c fc f5 a6 64 45 82 f1 35 7b 05 1e 
<4>[ 4165.746702]   0064: 24 d9 7d 47 5d 3f c9 52 29 13 fa 1d 34 77 5c 7a 
<4>[ 4165.746962]   0080: f4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.747221]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.747488]   0112: 00 d4 0a 6f 02 3f e8 85 6f a5 16 1c 5c 3f 30 c6 
<4>[ 4165.747752]   0128: d8 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 
<4>[ 4165.747990]   0144: 00 00 50 f2 02 01 00 00 50 f2 02 
<4>[ 4165.748500] dhd_prot_hdrpull: Enter
<4>[ 4165.753927] eth0: SIOCSIWPRIV request SCAN-PASSIVE, info->cmd:8b0c, 
info->flags:0
<4>[ 4165.753982]  dwrq->length:4096dhd_watchdog_thread:
<4>[ 4165.754530] dhd_bus_watchdog: Enter
<4>[ 4165.754669] dhdsdio_clkctl: Enter
<4>[ 4165.754793] dhdsdio_htclk: Enter
<4>[ 4165.755017] CLKCTL: turned OFF
<4>[ 4165.755154] dhdsdio_sdclk: Enter
<4>[ 4165.755285] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.755498] eth0: passive scan setting suppressed
<4>[ 4165.759713] dhdsdio_isr: Enter
<4>[ 4165.759871] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.760030] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.760196] dhdsdio_dpc: Enter
<4>[ 4165.760317] dhdsdio_clkctl: Enter
<4>[ 4165.760438] dhdsdio_sdclk: Enter
<4>[ 4165.760557] dhdsdio_htclk: Enter
<4>[ 4165.760844] CLKCTL: turned ON
<4>[ 4165.760990] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.761359] dhdsdio_readframes: Enter
<4>[ 4165.761647] RxHdr:
<4>[ 4165.761826]   0000: 9d 00 62 ff 53 02 00 0e 00 5b 00 00 
<4>[ 4165.762277] Rx Data:
<4>[ 4165.762486]   0000: 9d 00 62 ff 53 02 00 0e 00 5b 00 00 00 00 20 00 
<4>[ 4165.762757]   0016: 00 00 00 26 37 82 86 b6 00 1d 7e bd 45 a2 88 8e 
<4>[ 4165.763021]   0032: 01 03 00 79 fe 01 c9 00 20 00 00 00 00 00 00 00 
<4>[ 4165.763292]   0048: 5f db f9 5c 57 eb e4 65 76 3a 09 94 7c 5c c6 12 
<4>[ 4165.763561]   0064: 44 ed 12 db d1 ff a7 a4 e1 31 5a 27 fa 74 ee 88 
<4>[ 4165.763820]   0080: 67 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.764080]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.764521]   0112: 00 dc d7 59 f4 7d 4b 46 3a 5a 54 a2 d5 6f df 15 
<4>[ 4165.764807]   0128: 26 00 1a dd 18 00 50 f2 01 01 00 00 50 f2 02 01 
<4>[ 4165.765058]   0144: 00 00 50 f2 02 01 00 00 50 f2 02 00 00 
<4>[ 4165.765224] dhd_prot_hdrpull: Enter
<4>[ 4165.765381] dhd_watchdog_thread:
<4>[ 4165.765509] dhd_bus_watchdog: Enter
<4>[ 4165.765635] dhdsdio_clkctl: Enter
<4>[ 4165.765755] dhdsdio_htclk: Enter
<4>[ 4165.765972] CLKCTL: turned OFF
<4>[ 4165.766107] dhdsdio_sdclk: Enter
<4>[ 4165.766235] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.766392] dhd_rx_frame: Enter
<4>[ 4165.766711] RxHdr:
<4>[ 4165.766893]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.767064] dhdsdio_readframes: processed 1 frames
<4>[ 4165.767227] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.780726] dhd_start_xmit: Enter
<4>[ 4165.780909] dhd_prot_hdrpush: Enter
<4>[ 4165.781044] dhd_bus_txdata: Enter
<4>[ 4165.781173] dhd_bus_txdata: deferring pktq len 0
<4>[ 4165.781389] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4165.781556] dhdsdio_dpc: Enter
<4>[ 4165.781675] dhdsdio_clkctl: Enter
<4>[ 4165.781797] dhdsdio_sdclk: Enter
<4>[ 4165.781915] dhdsdio_htclk: Enter
<4>[ 4165.782209] CLKCTL: turned ON
<4>[ 4165.782358] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.782491] dhdsdio_sendfromq: Enter
<4>[ 4165.782624] dhdsdio_txpkt: Enter
<4>[ 4165.782746] Tx Frame:
<4>[ 4165.782929]   0000: 83 00 7c ff 4f 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4165.783197]   0016: 00 00 00 1d 7e bd 45 a2 00 26 37 82 86 b6 88 8e 
<4>[ 4165.783461]   0032: 01 03 00 5f fe 01 09 00 20 00 00 00 00 00 00 00 
<4>[ 4165.783721]   0048: 5f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.783980]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.784385]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.784668]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.784940]   0112: 00 4c 45 bc d3 8b ad ec fb 44 dd 71 7f f8 fa 23 
<4>[ 4165.785140]   0128: 3f 00 00 
<4>[ 4165.785542] dhd_prot_hdrpull: Enter
<4>[ 4165.785754] dhd_watchdog_thread:
<4>[ 4165.785891] dhd_bus_watchdog: Enter
<4>[ 4165.786018] dhdsdio_clkctl: Enter
<4>[ 4165.786137] dhdsdio_htclk: Enter
<4>[ 4165.786404] CLKCTL: turned OFF
<4>[ 4165.786546] dhdsdio_sdclk: Enter
<4>[ 4165.786678] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.794545] eth0: SIOCSIWENCODEEXT
<4>[ 4165.794714] Setting the key index 0
<4>[ 4165.794837] key is a Primary Key
<4>[ 4165.795000] 
<4>[ 4165.795021] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4165.795335] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4165.795503] dhd_prot_ioctl: Enter
<4>[ 4165.795626] dhdcdc_query_ioctl: Enter
<4>[ 4165.795761] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4165.795903] dhdcdc_msg: Enter
<4>[ 4165.796015] dhd_bus_txctl: Enter
<4>[ 4165.796134] dhdsdio_clkctl: Enter
<4>[ 4165.796254] dhdsdio_sdclk: Enter
<4>[ 4165.796371] dhdsdio_htclk: Enter
<4>[ 4165.804546] CLKCTL: turned ON
<4>[ 4165.804715] dhdsdio_clkctl: 0 -> 3
<4>[ 4165.804845] Tx Frame:
<4>[ 4165.805029]   0000: cc 00 33 ff 50 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4165.805291]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4165.805552]   0032: 00 00 4c 00 00 00 00 00 00 00 00 00 20 00 00 00 
<4>[ 4165.805819]   0048: 6e 8a ad b0 5e b9 a5 d1 61 6e 0c 4b 1a 2e 00 02 
<4>[ 4165.806087]   0064: d8 7a 6b a2 0e 2e 5a c9 1e b2 a3 4a 44 73 6c d6 
<4>[ 4165.806346]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.806605]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.806863]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.807123]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.807383]   0144: 00 00 00 00 00 00 00 00 02 00 00 00 02 00 00 00 
<4>[ 4165.807643]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 
<4>[ 4165.807902]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.808164]   0192: 00 00 00 00 00 1d 7e bd 45 a2 00 00 01 00 32 04 
<4>[ 4165.808428]   0208: 0c 12 18 60 dd 09 00 10 18 02 00 13 00 00 00 dd 
<4>[ 4165.809051] dhdcdc_cmplt: Enter
<4>[ 4165.809196] dhd_bus_rxctl: Enter
<4>[ 4165.809466] dhdsdio_isr: Enter
<4>[ 4165.809601] dhdsdio_isr: disable SDIO interrupts
<4>[ 4165.809757] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4165.809911] dhdsdio_dpc: Enter
<4>[ 4165.810028] dhdsdio_clkctl: Enter
<4>[ 4165.810397] dhdsdio_readframes: Enter
<4>[ 4165.810683] RxHdr:
<4>[ 4165.810865]   0000: c0 00 3f ff 54 00 00 0c 00 5d 00 00 
<4>[ 4165.811033] dhdsdio_read_control: Enter
<4>[ 4165.811388] RxCtrl:
<4>[ 4165.811591]   0000: c0 00 3f ff 54 00 00 0c 00 5d 00 00 2d 00 00 00 
<4>[ 4165.811860]   0016: a4 00 00 00 00 00 4c 00 00 00 00 00 00 00 00 00 
<4>[ 4165.812130]   0032: 20 00 00 00 6e 8a ad b0 5e b9 a5 d1 61 6e 0c 4b 
<4>[ 4165.812398]   0048: 1a 2e 00 02 d8 7a 6b a2 0e 2e 5a c9 1e b2 a3 4a 
<4>[ 4165.812661]   0064: 44 73 6c d6 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.812920]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.813179]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.813437]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.813696]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00 
<4>[ 4165.813956]   0144: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.814216]   0160: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.814657]   0176: 00 00 00 00 00 00 00 00 00 1d 7e bd 45 a2 00 00 
<4>[ 4165.815015] RxHdr:
<4>[ 4165.815195]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4165.815367] dhdsdio_readframes: processed 1 frames
<4>[ 4165.815528] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4165.815755] dhd_watchdog_thread:
<4>[ 4165.815884] dhd_bus_watchdog: Enter
<4>[ 4165.816010] dhdsdio_clkctl: Enter
<4>[ 4165.816129] dhdsdio_htclk: Enter
<4>[ 4165.816342] CLKCTL: turned OFF
<4>[ 4165.816475] dhdsdio_sdclk: Enter
<4>[ 4165.816604] dhdsdio_clkctl: 3 -> 0
<4>[ 4165.816848] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4166.000139] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.000190]  dwrq->length:4096
<4>[ 4166.000495] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4166.000788] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.000953] dhd_prot_ioctl: Enter
<4>[ 4166.001079] dhdcdc_query_ioctl: Enter
<4>[ 4166.001215] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4166.001355] dhdcdc_msg: Enter
<4>[ 4166.001467] dhd_bus_txctl: Enter
<4>[ 4166.001588] dhdsdio_clkctl: Enter
<4>[ 4166.001706] dhdsdio_sdclk: Enter
<4>[ 4166.001821] dhdsdio_htclk: Enter
<4>[ 4166.002126] CLKCTL: turned ON
<4>[ 4166.002273] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.002398] Tx Frame:
<4>[ 4166.002580]   0000: 34 00 cb ff 51 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.002840]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4166.003099]   0032: 00 00 4d 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.003363]   0048: 00 00 00 00 5e b9 a5 d1 61 6e 0c 4b 1a 2e 00 02 
<4>[ 4166.007126] dhdsdio_isr: Enter
<4>[ 4166.007284] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.007442] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.007598] dhdsdio_dpc: Enter
<4>[ 4166.007919] dhd_watchdog_thread:
<4>[ 4166.008061] dhd_bus_watchdog: Enter
<4>[ 4166.008189] dhdsdio_clkctl: Enter
<4>[ 4166.008310] dhdsdio_htclk: Enter
<4>[ 4166.008539] CLKCTL: turned OFF
<4>[ 4166.008674] dhdsdio_sdclk: Enter
<4>[ 4166.008806] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.008968] dhdsdio_clkctl: Enter
<4>[ 4166.009094] dhdsdio_sdclk: Enter
<4>[ 4166.009211] dhdsdio_htclk: Enter
<4>[ 4166.009494] CLKCTL: turned ON
<4>[ 4166.009637] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.010002] dhdsdio_readframes: Enter
<4>[ 4166.010286] RxHdr:
<4>[ 4166.010464]   0000: 28 00 d7 ff 55 00 00 0c 00 5e 00 00 
<4>[ 4166.010633] dhdsdio_read_control: Enter
<4>[ 4166.010765] RxCtrl:
<4>[ 4166.010942]   0000: 28 00 d7 ff 55 00 00 0c 00 5e 00 00 7f 00 00 00 
<4>[ 4166.011206]   0016: 0c 00 00 00 00 00 4d 00 00 00 00 00 d8 ff ff ff 
<4>[ 4166.011427]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4166.011707] RxHdr:
<4>[ 4166.011881]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.012051] dhdsdio_readframes: processed 1 frames
<4>[ 4166.012211] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.012585] dhdcdc_cmplt: Enter
<4>[ 4166.012725] dhd_bus_rxctl: Enter
<4>[ 4166.012868] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4166.013102] 
<4>[ 4166.013123] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4166.013431] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.013595] dhd_prot_ioctl: Enter
<4>[ 4166.013717] dhdcdc_query_ioctl: Enter
<4>[ 4166.013851] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4166.013990] dhdcdc_msg: Enter
<4>[ 4166.014099] dhd_bus_txctl: Enter
<4>[ 4166.014216] dhdsdio_clkctl: Enter
<4>[ 4166.022234] Tx Frame:
<4>[ 4166.022459]   0000: 4c 00 b3 ff 52 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.022728]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4166.022990]   0032: 00 00 4e 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.023247]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.023509]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 44 73 6c d6 
<4>[ 4166.023766]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.031952] dhdsdio_isr: Enter
<4>[ 4166.032109] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.032267] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.032421] dhdsdio_dpc: Enter
<4>[ 4166.032738] dhd_watchdog_thread:
<4>[ 4166.032879] dhd_bus_watchdog: Enter
<4>[ 4166.033008] dhdsdio_clkctl: Enter
<4>[ 4166.033129] dhdsdio_htclk: Enter
<4>[ 4166.033360] CLKCTL: turned OFF
<4>[ 4166.033494] dhdsdio_sdclk: Enter
<4>[ 4166.033624] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.033755] dhd_watchdog_thread:
<4>[ 4166.033873] dhd_bus_watchdog: Enter
<4>[ 4166.034030] dhdsdio_clkctl: Enter
<4>[ 4166.034156] dhdsdio_sdclk: Enter
<4>[ 4166.034379] dhdsdio_htclk: Enter
<4>[ 4166.034733] CLKCTL: turned ON
<4>[ 4166.034880] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.035252] dhdsdio_readframes: Enter
<4>[ 4166.035540] RxHdr:
<4>[ 4166.035719]   0000: 40 00 bf ff 56 00 00 0c 00 5f 00 00 
<4>[ 4166.035887] dhdsdio_read_control: Enter
<4>[ 4166.036019] RxCtrl:
<4>[ 4166.036197]   0000: 40 00 bf ff 56 00 00 0c 00 5f 00 00 19 00 00 00 
<4>[ 4166.036459]   0016: 24 00 00 00 00 00 4e 00 00 00 00 00 05 00 00 00 
<4>[ 4166.036720]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.036979]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.037304] RxHdr:
<4>[ 4166.037475]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.037643] dhdsdio_readframes: processed 1 frames
<4>[ 4166.037804] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.038197] dhdcdc_cmplt: Enter
<4>[ 4166.038335] dhd_bus_rxctl: Enter
<4>[ 4166.038477] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4166.038696] wl_iw_get_rssi ssid_len:5, rssi:-40
<4>[ 4166.043345] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.043397]  dwrq->length:4096
<4>[ 4166.043726] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4166.044017] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.044183] dhd_prot_ioctl: Enter
<4>[ 4166.044474] dhd_watchdog_thread:
<4>[ 4166.044617] dhd_bus_watchdog: Enter
<4>[ 4166.044745] dhdsdio_clkctl: Enter
<4>[ 4166.044864] dhdsdio_htclk: Enter
<4>[ 4166.045085] CLKCTL: turned OFF
<4>[ 4166.045219] dhdsdio_sdclk: Enter
<4>[ 4166.045349] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.050871] dhdcdc_query_ioctl: Enter
<4>[ 4166.051047] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4166.051193] dhdcdc_msg: Enter
<4>[ 4166.051308] dhd_bus_txctl: Enter
<4>[ 4166.051429] dhdsdio_clkctl: Enter
<4>[ 4166.051549] dhdsdio_sdclk: Enter
<4>[ 4166.051664] dhdsdio_htclk: Enter
<4>[ 4166.058829] CLKCTL: turned ON
<4>[ 4166.058998] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.059127] Tx Frame:
<4>[ 4166.059308]   0000: 2c 00 d3 ff 53 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.059570]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4166.059835]   0032: 00 00 4f 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4166.060093]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.062443] dhdsdio_isr: Enter
<4>[ 4166.062598] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.062757] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.062912] dhdsdio_dpc: Enter
<4>[ 4166.063100] dhdsdio_clkctl: Enter
<4>[ 4166.063497] dhdsdio_readframes: Enter
<4>[ 4166.063787] RxHdr:
<4>[ 4166.063967]   0000: 20 00 df ff 57 00 00 0c 00 60 00 00 
<4>[ 4166.064134] dhdsdio_read_control: Enter
<4>[ 4166.064432] RxCtrl:
<4>[ 4166.064633]   0000: 20 00 df ff 57 00 00 0c 00 60 00 00 0c 00 00 00 
<4>[ 4166.064902]   0016: 04 00 00 00 00 00 4f 00 00 00 00 00 6c 00 00 00 
<4>[ 4166.065240] RxHdr:
<4>[ 4166.065417]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.065588] dhdsdio_readframes: processed 1 frames
<4>[ 4166.065751] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.065975] dhd_watchdog_thread:
<4>[ 4166.066103] dhd_bus_watchdog: Enter
<4>[ 4166.066228] dhdsdio_clkctl: Enter
<4>[ 4166.066347] dhdsdio_htclk: Enter
<4>[ 4166.066559] CLKCTL: turned OFF
<4>[ 4166.066692] dhdsdio_sdclk: Enter
<4>[ 4166.066820] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.067024] dhdcdc_cmplt: Enter
<4>[ 4166.067153] dhd_bus_rxctl: Enter
<4>[ 4166.067291] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4166.094404] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.094455]  dwrq->length:4096
<4>[ 4166.094759] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4166.095053] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.095219] dhd_prot_ioctl: Enter
<4>[ 4166.095343] dhdcdc_query_ioctl: Enter
<4>[ 4166.095477] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4166.095617] dhdcdc_msg: Enter
<4>[ 4166.095728] dhd_bus_txctl: Enter
<4>[ 4166.095848] dhdsdio_clkctl: Enter
<4>[ 4166.095966] dhdsdio_sdclk: Enter
<4>[ 4166.096081] dhdsdio_htclk: Enter
<4>[ 4166.103732] CLKCTL: turned ON
<4>[ 4166.103899] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.104029] Tx Frame:
<4>[ 4166.104215]   0000: 34 00 cb ff 54 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.108781]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4166.109081]   0032: 00 00 50 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.109349]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.113814] dhdsdio_isr: Enter
<4>[ 4166.113969] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.114127] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.114384] dhdsdio_dpc: Enter
<4>[ 4166.114725] dhd_watchdog_thread:
<4>[ 4166.114868] dhd_bus_watchdog: Enter
<4>[ 4166.114997] dhdsdio_clkctl: Enter
<4>[ 4166.115118] dhdsdio_htclk: Enter
<4>[ 4166.115353] CLKCTL: turned OFF
<4>[ 4166.115491] dhdsdio_sdclk: Enter
<4>[ 4166.115621] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.115780] dhdsdio_clkctl: Enter
<4>[ 4166.115910] dhdsdio_sdclk: Enter
<4>[ 4166.116030] dhdsdio_htclk: Enter
<4>[ 4166.116312] CLKCTL: turned ON
<4>[ 4166.116454] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.116829] dhdsdio_readframes: Enter
<4>[ 4166.117115] RxHdr:
<4>[ 4166.117297]   0000: 28 00 d7 ff 58 00 00 0c 00 61 00 00 
<4>[ 4166.117467] dhdsdio_read_control: Enter
<4>[ 4166.117600] RxCtrl:
<4>[ 4166.117778]   0000: 28 00 d7 ff 58 00 00 0c 00 61 00 00 7f 00 00 00 
<4>[ 4166.118043]   0016: 0c 00 00 00 00 00 50 00 00 00 00 00 d8 ff ff ff 
<4>[ 4166.118264]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4166.118544] RxHdr:
<4>[ 4166.118721]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.118894] dhdsdio_readframes: processed 1 frames
<4>[ 4166.119056] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.119310] dhdcdc_cmplt: Enter
<4>[ 4166.119442] dhd_bus_rxctl: Enter
<4>[ 4166.119581] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4166.119815] 
<4>[ 4166.119836] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4166.120146] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.120311] dhd_prot_ioctl: Enter
<4>[ 4166.120435] dhdcdc_query_ioctl: Enter
<4>[ 4166.120568] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4166.120709] dhdcdc_msg: Enter
<4>[ 4166.120820] dhd_bus_txctl: Enter
<4>[ 4166.120939] dhdsdio_clkctl: Enter
<4>[ 4166.121063] Tx Frame:
<4>[ 4166.121245]   0000: 4c 00 b3 ff 55 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.121506]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4166.121768]   0032: 00 00 51 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4166.122028]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.122288]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 44 73 6c d6 
<4>[ 4166.122547]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.137487] dhdsdio_isr: Enter
<4>[ 4166.137644] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.137801] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.137955] dhdsdio_dpc: Enter
<4>[ 4166.138270] dhd_watchdog_thread:
<4>[ 4166.138414] dhd_bus_watchdog: Enter
<4>[ 4166.138546] dhdsdio_clkctl: Enter
<4>[ 4166.138669] dhdsdio_htclk: Enter
<4>[ 4166.138899] CLKCTL: turned OFF
<4>[ 4166.139035] dhdsdio_sdclk: Enter
<4>[ 4166.139164] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.139328] dhdsdio_clkctl: Enter
<4>[ 4166.139458] dhdsdio_sdclk: Enter
<4>[ 4166.139577] dhdsdio_htclk: Enter
<4>[ 4166.139909] CLKCTL: turned ON
<4>[ 4166.140059] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.140436] dhdsdio_readframes: Enter
<4>[ 4166.140722] RxHdr:
<4>[ 4166.140900]   0000: 40 00 bf ff 59 00 00 0c 00 62 00 00 
<4>[ 4166.141070] dhdsdio_read_control: Enter
<4>[ 4166.141202] RxCtrl:
<4>[ 4166.141381]   0000: 40 00 bf ff 59 00 00 0c 00 62 00 00 19 00 00 00 
<4>[ 4166.141644]   0016: 24 00 00 00 00 00 51 00 00 00 00 00 05 00 00 00 
<4>[ 4166.141909]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.142168]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.142493] RxHdr:
<4>[ 4166.142669]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.142840] dhdsdio_readframes: processed 1 frames
<4>[ 4166.143002] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.143399] dhdcdc_cmplt: Enter
<4>[ 4166.143540] dhd_bus_rxctl: Enter
<4>[ 4166.143682] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4166.143903] wl_iw_get_rssi ssid_len:5, rssi:-40
<4>[ 4166.144395] dhd_watchdog_thread:
<4>[ 4166.144546] dhd_bus_watchdog: Enter
<4>[ 4166.144676] dhdsdio_clkctl: Enter
<4>[ 4166.144795] dhdsdio_htclk: Enter
<4>[ 4166.145017] CLKCTL: turned OFF
<4>[ 4166.145151] dhdsdio_sdclk: Enter
<4>[ 4166.145281] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.152338] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.152393]  dwrq->length:4096
<4>[ 4166.152724] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4166.153015] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.153180] dhd_prot_ioctl: Enter
<4>[ 4166.153305] dhdcdc_query_ioctl: Enter
<4>[ 4166.153439] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4166.153578] dhdcdc_msg: Enter
<4>[ 4166.153690] dhd_bus_txctl: Enter
<4>[ 4166.153811] dhdsdio_clkctl: Enter
<4>[ 4166.153930] dhdsdio_sdclk: Enter
<4>[ 4166.154047] dhdsdio_htclk: Enter
<4>[ 4166.161809] CLKCTL: turned ON
<4>[ 4166.161979] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.162113] Tx Frame:
<4>[ 4166.162299]   0000: 2c 00 d3 ff 56 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.162560]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4166.162826]   0032: 00 00 52 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4166.163085]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.169903] dhdsdio_isr: Enter
<4>[ 4166.170060] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.170217] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.170371] dhdsdio_dpc: Enter
<4>[ 4166.170966] dhd_watchdog_thread:
<4>[ 4166.171120] dhd_bus_watchdog: Enter
<4>[ 4166.171252] dhdsdio_clkctl: Enter
<4>[ 4166.171374] dhdsdio_htclk: Enter
<4>[ 4166.171612] CLKCTL: turned OFF
<4>[ 4166.171748] dhdsdio_sdclk: Enter
<4>[ 4166.171878] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.172040] dhdsdio_clkctl: Enter
<4>[ 4166.172171] dhdsdio_sdclk: Enter
<4>[ 4166.172289] dhdsdio_htclk: Enter
<4>[ 4166.172576] CLKCTL: turned ON
<4>[ 4166.172722] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.173092] dhdsdio_readframes: Enter
<4>[ 4166.173378] RxHdr:
<4>[ 4166.173558]   0000: 20 00 df ff 5a 00 00 0c 00 63 00 00 
<4>[ 4166.173728] dhdsdio_read_control: Enter
<4>[ 4166.173860] RxCtrl:
<4>[ 4166.174039]   0000: 20 00 df ff 5a 00 00 0c 00 63 00 00 0c 00 00 00 
<4>[ 4166.174476]   0016: 04 00 00 00 00 00 52 00 00 00 00 00 6c 00 00 00 
<4>[ 4166.174832] RxHdr:
<4>[ 4166.175013]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.175184] dhdsdio_readframes: processed 1 frames
<4>[ 4166.175347] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.175575] dhd_watchdog_thread:
<4>[ 4166.175706] dhd_bus_watchdog: Enter
<4>[ 4166.175833] dhdsdio_clkctl: Enter
<4>[ 4166.175951] dhdsdio_htclk: Enter
<4>[ 4166.176166] CLKCTL: turned OFF
<4>[ 4166.176298] dhdsdio_sdclk: Enter
<4>[ 4166.176425] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.176788] dhdcdc_cmplt: Enter
<4>[ 4166.176929] dhd_bus_rxctl: Enter
<4>[ 4166.177068] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4166.218657] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.218710]  dwrq->length:4096
<4>[ 4166.219016] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4166.219310] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.219477] dhd_prot_ioctl: Enter
<4>[ 4166.219600] dhdcdc_query_ioctl: Enter
<4>[ 4166.219736] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4166.219878] dhdcdc_msg: Enter
<4>[ 4166.219990] dhd_bus_txctl: Enter
<4>[ 4166.220110] dhdsdio_clkctl: Enter
<4>[ 4166.220228] dhdsdio_sdclk: Enter
<4>[ 4166.220345] dhdsdio_htclk: Enter
<4>[ 4166.221619] CLKCTL: turned ON
<4>[ 4166.222015] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.222162] Tx Frame:
<4>[ 4166.222351]   0000: 34 00 cb ff 57 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.222615]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4166.222876]   0032: 00 00 53 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.223136]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.224210] dhdsdio_isr: Enter
<4>[ 4166.224529] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.224706] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.224863] dhdsdio_dpc: Enter
<4>[ 4166.225048] dhd_watchdog_thread:
<4>[ 4166.225181] dhd_bus_watchdog: Enter
<4>[ 4166.225308] dhdsdio_clkctl: Enter
<4>[ 4166.225427] dhdsdio_htclk: Enter
<4>[ 4166.225657] CLKCTL: turned OFF
<4>[ 4166.225791] dhdsdio_sdclk: Enter
<4>[ 4166.225919] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.226081] dhdsdio_clkctl: Enter
<4>[ 4166.226211] dhdsdio_sdclk: Enter
<4>[ 4166.226332] dhdsdio_htclk: Enter
<4>[ 4166.226616] CLKCTL: turned ON
<4>[ 4166.226762] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.227130] dhdsdio_readframes: Enter
<4>[ 4166.227419] RxHdr:
<4>[ 4166.227602]   0000: 28 00 d7 ff 5b 00 00 0c 00 64 00 00 
<4>[ 4166.227772] dhdsdio_read_control: Enter
<4>[ 4166.227905] RxCtrl:
<4>[ 4166.228085]   0000: 28 00 d7 ff 5b 00 00 0c 00 64 00 00 7f 00 00 00 
<4>[ 4166.228350]   0016: 0c 00 00 00 00 00 53 00 00 00 00 00 d8 ff ff ff 
<4>[ 4166.228573]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4166.228856] RxHdr:
<4>[ 4166.229029]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.229201] dhdsdio_readframes: processed 1 frames
<4>[ 4166.229362] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.229618] dhdcdc_cmplt: Enter
<4>[ 4166.229749] dhd_bus_rxctl: Enter
<4>[ 4166.229889] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4166.230126] 
<4>[ 4166.230147] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4166.230455] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.230620] dhd_prot_ioctl: Enter
<4>[ 4166.230745] dhdcdc_query_ioctl: Enter
<4>[ 4166.230879] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4166.231020] dhdcdc_msg: Enter
<4>[ 4166.231131] dhd_bus_txctl: Enter
<4>[ 4166.231251] dhdsdio_clkctl: Enter
<4>[ 4166.231373] Tx Frame:
<4>[ 4166.231555]   0000: 4c 00 b3 ff 58 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.231818]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4166.232081]   0032: 00 00 54 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4166.232340]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.232601]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 44 73 6c d6 
<4>[ 4166.232860]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.243205] dhdsdio_isr: Enter
<4>[ 4166.243364] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.243523] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.243677] dhdsdio_dpc: Enter
<4>[ 4166.243999] dhd_watchdog_thread:
<4>[ 4166.244147] dhd_bus_watchdog: Enter
<4>[ 4166.244396] dhdsdio_clkctl: Enter
<4>[ 4166.244541] dhdsdio_htclk: Enter
<4>[ 4166.244775] CLKCTL: turned OFF
<4>[ 4166.244911] dhdsdio_sdclk: Enter
<4>[ 4166.245041] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.245349] dhdsdio_clkctl: Enter
<4>[ 4166.245491] dhdsdio_sdclk: Enter
<4>[ 4166.245613] dhdsdio_htclk: Enter
<4>[ 4166.245905] CLKCTL: turned ON
<4>[ 4166.246052] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.246421] dhdsdio_readframes: Enter
<4>[ 4166.246709] RxHdr:
<4>[ 4166.246891]   0000: 40 00 bf ff 5c 00 00 0c 00 65 00 00 
<4>[ 4166.247063] dhdsdio_read_control: Enter
<4>[ 4166.247197] RxCtrl:
<4>[ 4166.247375]   0000: 40 00 bf ff 5c 00 00 0c 00 65 00 00 19 00 00 00 
<4>[ 4166.247636]   0016: 24 00 00 00 00 00 54 00 00 00 00 00 05 00 00 00 
<4>[ 4166.247900]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.248159]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.248487] RxHdr:
<4>[ 4166.248664]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.248834] dhdsdio_readframes: processed 1 frames
<4>[ 4166.248996] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.249250] dhdcdc_cmplt: Enter
<4>[ 4166.249379] dhd_bus_rxctl: Enter
<4>[ 4166.249516] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4166.249736] wl_iw_get_rssi ssid_len:5, rssi:-40
<4>[ 4166.251580] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.251636]  dwrq->length:4096
<4>[ 4166.251964] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4166.252255] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.252423] dhd_prot_ioctl: Enter
<4>[ 4166.252549] dhdcdc_query_ioctl: Enter
<4>[ 4166.252685] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4166.252824] dhdcdc_msg: Enter
<4>[ 4166.252936] dhd_bus_txctl: Enter
<4>[ 4166.253058] dhdsdio_clkctl: Enter
<4>[ 4166.253183] Tx Frame:
<4>[ 4166.253365]   0000: 2c 00 d3 ff 59 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.253626]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4166.253890]   0032: 00 00 55 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4166.254150]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.254755] dhd_watchdog_thread:
<4>[ 4166.254936] dhd_bus_watchdog: Enter
<4>[ 4166.255071] dhdsdio_clkctl: Enter
<4>[ 4166.255196] dhdsdio_htclk: Enter
<4>[ 4166.255410] CLKCTL: turned OFF
<4>[ 4166.255548] dhdsdio_sdclk: Enter
<4>[ 4166.255678] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.255928] dhdsdio_isr: Enter
<4>[ 4166.256065] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.256221] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.256375] dhdsdio_dpc: Enter
<4>[ 4166.256490] dhdsdio_clkctl: Enter
<4>[ 4166.256610] dhdsdio_sdclk: Enter
<4>[ 4166.256727] dhdsdio_htclk: Enter
<4>[ 4166.256999] CLKCTL: turned ON
<4>[ 4166.257143] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.257510] dhdsdio_readframes: Enter
<4>[ 4166.257796] RxHdr:
<4>[ 4166.257979]   0000: 20 00 df ff 5d 00 00 0c 00 66 00 00 
<4>[ 4166.258147] dhdsdio_read_control: Enter
<4>[ 4166.258281] RxCtrl:
<4>[ 4166.258459]   0000: 20 00 df ff 5d 00 00 0c 00 66 00 00 0c 00 00 00 
<4>[ 4166.258722]   0016: 04 00 00 00 00 00 55 00 00 00 00 00 6c 00 00 00 
<4>[ 4166.259045] RxHdr:
<4>[ 4166.259225]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.259397] dhdsdio_readframes: processed 1 frames
<4>[ 4166.259560] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.259814] dhdcdc_cmplt: Enter
<4>[ 4166.259946] dhd_bus_rxctl: Enter
<4>[ 4166.260085] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4166.264414] dhd_watchdog_thread:
<4>[ 4166.264578] dhd_bus_watchdog: Enter
<4>[ 4166.264712] dhdsdio_clkctl: Enter
<4>[ 4166.264834] dhdsdio_htclk: Enter
<4>[ 4166.265060] CLKCTL: turned OFF
<4>[ 4166.265195] dhdsdio_sdclk: Enter
<4>[ 4166.265326] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.281842] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.281895]  dwrq->length:4096
<4>[ 4166.282199] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4166.282494] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.282663] dhd_prot_ioctl: Enter
<4>[ 4166.282786] dhdcdc_query_ioctl: Enter
<4>[ 4166.282921] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4166.283063] dhdcdc_msg: Enter
<4>[ 4166.283175] dhd_bus_txctl: Enter
<4>[ 4166.283297] dhdsdio_clkctl: Enter
<4>[ 4166.283417] dhdsdio_sdclk: Enter
<4>[ 4166.283533] dhdsdio_htclk: Enter
<4>[ 4166.283838] CLKCTL: turned ON
<4>[ 4166.283988] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.284116] Tx Frame:
<4>[ 4166.284517]   0000: 34 00 cb ff 5a 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.288645]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4166.288944]   0032: 00 00 56 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.289209]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.294568] dhdsdio_isr: Enter
<4>[ 4166.294726] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.294885] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.295038] dhdsdio_dpc: Enter
<4>[ 4166.295229] dhd_watchdog_thread:
<4>[ 4166.295363] dhd_bus_watchdog: Enter
<4>[ 4166.295491] dhdsdio_clkctl: Enter
<4>[ 4166.295611] dhdsdio_htclk: Enter
<4>[ 4166.295836] CLKCTL: turned OFF
<4>[ 4166.295973] dhdsdio_sdclk: Enter
<4>[ 4166.296102] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.296266] dhdsdio_clkctl: Enter
<4>[ 4166.296395] dhdsdio_sdclk: Enter
<4>[ 4166.296514] dhdsdio_htclk: Enter
<4>[ 4166.296856] CLKCTL: turned ON
<4>[ 4166.297009] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.297385] dhdsdio_readframes: Enter
<4>[ 4166.297674] RxHdr:
<4>[ 4166.297853]   0000: 28 00 d7 ff 5e 00 00 0c 00 67 00 00 
<4>[ 4166.298024] dhdsdio_read_control: Enter
<4>[ 4166.298157] RxCtrl:
<4>[ 4166.298335]   0000: 28 00 d7 ff 5e 00 00 0c 00 67 00 00 7f 00 00 00 
<4>[ 4166.298599]   0016: 0c 00 00 00 00 00 56 00 00 00 00 00 d8 ff ff ff 
<4>[ 4166.298821]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4166.299103] RxHdr:
<4>[ 4166.299278]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.299448] dhdsdio_readframes: processed 1 frames
<4>[ 4166.299609] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.300051] dhdcdc_cmplt: Enter
<4>[ 4166.300197] dhd_bus_rxctl: Enter
<4>[ 4166.300340] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4166.300578] 
<4>[ 4166.300600] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4166.300911] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.301075] dhd_prot_ioctl: Enter
<4>[ 4166.301199] dhdcdc_query_ioctl: Enter
<4>[ 4166.301334] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4166.301475] dhdcdc_msg: Enter
<4>[ 4166.301585] dhd_bus_txctl: Enter
<4>[ 4166.301704] dhdsdio_clkctl: Enter
<4>[ 4166.301828] Tx Frame:
<4>[ 4166.302012]   0000: 4c 00 b3 ff 5b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.302273]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4166.302536]   0032: 00 00 57 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4166.302796]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.303059]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 44 73 6c d6 
<4>[ 4166.303318]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.314756] dhdsdio_isr: Enter
<4>[ 4166.314916] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.315076] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.315229] dhdsdio_dpc: Enter
<4>[ 4166.315421] dhd_watchdog_thread:
<4>[ 4166.315556] dhd_bus_watchdog: Enter
<4>[ 4166.315685] dhdsdio_clkctl: Enter
<4>[ 4166.315807] dhdsdio_htclk: Enter
<4>[ 4166.316033] CLKCTL: turned OFF
<4>[ 4166.316170] dhdsdio_sdclk: Enter
<4>[ 4166.316300] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.316462] dhdsdio_clkctl: Enter
<4>[ 4166.316591] dhdsdio_sdclk: Enter
<4>[ 4166.316710] dhdsdio_htclk: Enter
<4>[ 4166.316990] CLKCTL: turned ON
<4>[ 4166.317135] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.317501] dhdsdio_readframes: Enter
<4>[ 4166.317789] RxHdr:
<4>[ 4166.317973]   0000: 40 00 bf ff 5f 00 00 0c 00 68 00 00 
<4>[ 4166.318140] dhdsdio_read_control: Enter
<4>[ 4166.318272] RxCtrl:
<4>[ 4166.318450]   0000: 40 00 bf ff 5f 00 00 0c 00 68 00 00 19 00 00 00 
<4>[ 4166.318712]   0016: 24 00 00 00 00 00 57 00 00 00 00 00 05 00 00 00 
<4>[ 4166.318974]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.319234]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.319559] RxHdr:
<4>[ 4166.319734]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.319902] dhdsdio_readframes: processed 1 frames
<4>[ 4166.320064] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.320316] dhdcdc_cmplt: Enter
<4>[ 4166.320446] dhd_bus_rxctl: Enter
<4>[ 4166.320585] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4166.320805] wl_iw_get_rssi ssid_len:5, rssi:-40
<4>[ 4166.321898] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.321951]  dwrq->length:4096
<4>[ 4166.322277] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4166.322569] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.322734] dhd_prot_ioctl: Enter
<4>[ 4166.322858] dhdcdc_query_ioctl: Enter
<4>[ 4166.322993] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4166.323133] dhdcdc_msg: Enter
<4>[ 4166.323244] dhd_bus_txctl: Enter
<4>[ 4166.323365] dhdsdio_clkctl: Enter
<4>[ 4166.323487] Tx Frame:
<4>[ 4166.323669]   0000: 2c 00 d3 ff 5c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.323930]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4166.324194]   0032: 00 00 58 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4166.324681]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.325097] dhd_watchdog_thread:
<4>[ 4166.325243] dhd_bus_watchdog: Enter
<4>[ 4166.325374] dhdsdio_clkctl: Enter
<4>[ 4166.325494] dhdsdio_htclk: Enter
<4>[ 4166.325707] CLKCTL: turned OFF
<4>[ 4166.325842] dhdsdio_sdclk: Enter
<4>[ 4166.325970] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.326216] dhdsdio_isr: Enter
<4>[ 4166.326353] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.326508] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.326661] dhdsdio_dpc: Enter
<4>[ 4166.326776] dhdsdio_clkctl: Enter
<4>[ 4166.326893] dhdsdio_sdclk: Enter
<4>[ 4166.327009] dhdsdio_htclk: Enter
<4>[ 4166.327327] CLKCTL: turned ON
<4>[ 4166.327476] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.327845] dhdsdio_readframes: Enter
<4>[ 4166.328132] RxHdr:
<4>[ 4166.328313]   0000: 20 00 df ff 60 00 00 0c 00 69 00 00 
<4>[ 4166.328481] dhdsdio_read_control: Enter
<4>[ 4166.328613] RxCtrl:
<4>[ 4166.328793]   0000: 20 00 df ff 60 00 00 0c 00 69 00 00 0c 00 00 00 
<4>[ 4166.329058]   0016: 04 00 00 00 00 00 58 00 00 00 00 00 6c 00 00 00 
<4>[ 4166.329382] RxHdr:
<4>[ 4166.329558]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.329730] dhdsdio_readframes: processed 1 frames
<4>[ 4166.329893] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.330144] dhdcdc_cmplt: Enter
<4>[ 4166.330275] dhd_bus_rxctl: Enter
<4>[ 4166.330412] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4166.334398] dhd_watchdog_thread:
<4>[ 4166.334561] dhd_bus_watchdog: Enter
<4>[ 4166.334696] dhdsdio_clkctl: Enter
<4>[ 4166.334816] dhdsdio_htclk: Enter
<4>[ 4166.335042] CLKCTL: turned OFF
<4>[ 4166.335178] dhdsdio_sdclk: Enter
<4>[ 4166.335308] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.358096] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.358149]  dwrq->length:4096
<4>[ 4166.358454] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4166.358748] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.358915] dhd_prot_ioctl: Enter
<4>[ 4166.359040] dhdcdc_query_ioctl: Enter
<4>[ 4166.359176] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4166.359319] dhdcdc_msg: Enter
<4>[ 4166.359430] dhd_bus_txctl: Enter
<4>[ 4166.359551] dhdsdio_clkctl: Enter
<4>[ 4166.359671] dhdsdio_sdclk: Enter
<4>[ 4166.359788] dhdsdio_htclk: Enter
<4>[ 4166.360243] CLKCTL: turned ON
<4>[ 4166.360401] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.360529] Tx Frame:
<4>[ 4166.360712]   0000: 34 00 cb ff 5d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.360974]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4166.361236]   0032: 00 00 59 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.361493]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.361987] dhdsdio_isr: Enter
<4>[ 4166.362132] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.362288] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.362440] dhdsdio_dpc: Enter
<4>[ 4166.362625] dhdsdio_clkctl: Enter
<4>[ 4166.363014] dhdsdio_readframes: Enter
<4>[ 4166.363304] RxHdr:
<4>[ 4166.363486]   0000: 28 00 d7 ff 61 00 00 0c 00 6a 00 00 
<4>[ 4166.363655] dhdsdio_read_control: Enter
<4>[ 4166.363787] RxCtrl:
<4>[ 4166.363965]   0000: 28 00 d7 ff 61 00 00 0c 00 6a 00 00 7f 00 00 00 
<4>[ 4166.364403]   0016: 0c 00 00 00 00 00 59 00 00 00 00 00 d8 ff ff ff 
<4>[ 4166.364650]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4166.364943] RxHdr:
<4>[ 4166.365123]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.365295] dhdsdio_readframes: processed 1 frames
<4>[ 4166.365456] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.365681] dhd_watchdog_thread:
<4>[ 4166.365807] dhd_bus_watchdog: Enter
<4>[ 4166.365933] dhdsdio_clkctl: Enter
<4>[ 4166.366052] dhdsdio_htclk: Enter
<4>[ 4166.366268] CLKCTL: turned OFF
<4>[ 4166.366402] dhdsdio_sdclk: Enter
<4>[ 4166.366531] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.366737] dhdcdc_cmplt: Enter
<4>[ 4166.366867] dhd_bus_rxctl: Enter
<4>[ 4166.367006] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4166.367241] 
<4>[ 4166.367263] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4166.367573] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.367740] dhd_prot_ioctl: Enter
<4>[ 4166.367863] dhdcdc_query_ioctl: Enter
<4>[ 4166.367997] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4166.368137] dhdcdc_msg: Enter
<4>[ 4166.368248] dhd_bus_txctl: Enter
<4>[ 4166.368368] dhdsdio_clkctl: Enter
<4>[ 4166.368487] dhdsdio_sdclk: Enter
<4>[ 4166.368603] dhdsdio_htclk: Enter
<4>[ 4166.374472] CLKCTL: turned ON
<4>[ 4166.374636] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.374768] Tx Frame:
<4>[ 4166.374954]   0000: 4c 00 b3 ff 5e 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.375218]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4166.375480]   0032: 00 00 5a 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4166.375739]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.376000]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 44 73 6c d6 
<4>[ 4166.376259]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.376674] dhdcdc_cmplt: Enter
<4>[ 4166.376959] dhdsdio_isr: Enter
<4>[ 4166.377097] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.377253] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.377404] dhdsdio_dpc: Enter
<4>[ 4166.377520] dhdsdio_clkctl: Enter
<4>[ 4166.377893] dhdsdio_readframes: Enter
<4>[ 4166.378184] RxHdr:
<4>[ 4166.378365]   0000: 40 00 bf ff 62 00 00 0c 00 6b 00 00 
<4>[ 4166.378536] dhdsdio_read_control: Enter
<4>[ 4166.378668] RxCtrl:
<4>[ 4166.378850]   0000: 40 00 bf ff 62 00 00 0c 00 6b 00 00 19 00 00 00 
<4>[ 4166.379113]   0016: 24 00 00 00 00 00 5a 00 00 00 00 00 05 00 00 00 
<4>[ 4166.379376]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.379634]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.379956] RxHdr:
<4>[ 4166.380131]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.380302] dhdsdio_readframes: processed 1 frames
<4>[ 4166.380464] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.380716] dhd_bus_rxctl: Enter
<4>[ 4166.380863] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4166.381085] wl_iw_get_rssi ssid_len:5, rssi:-40
<4>[ 4166.382177] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.382230]  dwrq->length:4096
<4>[ 4166.382558] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4166.382847] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.383016] dhd_prot_ioctl: Enter
<4>[ 4166.383141] dhdcdc_query_ioctl: Enter
<4>[ 4166.383275] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4166.383413] dhdcdc_msg: Enter
<4>[ 4166.383525] dhd_bus_txctl: Enter
<4>[ 4166.383644] dhdsdio_clkctl: Enter
<4>[ 4166.383767] Tx Frame:
<4>[ 4166.383949]   0000: 2c 00 d3 ff 5f 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.384211]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4166.391744]   0032: 00 00 5b 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4166.392046]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.392458] dhd_watchdog_thread:
<4>[ 4166.392606] dhd_bus_watchdog: Enter
<4>[ 4166.392737] dhdsdio_clkctl: Enter
<4>[ 4166.392861] dhdsdio_htclk: Enter
<4>[ 4166.393077] CLKCTL: turned OFF
<4>[ 4166.393214] dhdsdio_sdclk: Enter
<4>[ 4166.393346] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.393597] dhdsdio_isr: Enter
<4>[ 4166.393734] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.393889] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.394045] dhdsdio_dpc: Enter
<4>[ 4166.394162] dhdsdio_clkctl: Enter
<4>[ 4166.394386] dhdsdio_sdclk: Enter
<4>[ 4166.394525] dhdsdio_htclk: Enter
<4>[ 4166.394814] CLKCTL: turned ON
<4>[ 4166.394962] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.395334] dhdsdio_readframes: Enter
<4>[ 4166.395626] RxHdr:
<4>[ 4166.395811]   0000: 20 00 df ff 63 00 00 0c 00 6c 00 00 
<4>[ 4166.395978] dhdsdio_read_control: Enter
<4>[ 4166.396111] RxCtrl:
<4>[ 4166.396289]   0000: 20 00 df ff 63 00 00 0c 00 6c 00 00 0c 00 00 00 
<4>[ 4166.396551]   0016: 04 00 00 00 00 00 5b 00 00 00 00 00 6c 00 00 00 
<4>[ 4166.396874] RxHdr:
<4>[ 4166.397050]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.397222] dhdsdio_readframes: processed 1 frames
<4>[ 4166.397385] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.397640] dhdcdc_cmplt: Enter
<4>[ 4166.397773] dhd_bus_rxctl: Enter
<4>[ 4166.397912] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4166.404393] dhd_watchdog_thread:
<4>[ 4166.404552] dhd_bus_watchdog: Enter
<4>[ 4166.404684] dhdsdio_clkctl: Enter
<4>[ 4166.404806] dhdsdio_htclk: Enter
<4>[ 4166.405033] CLKCTL: turned OFF
<4>[ 4166.405171] dhdsdio_sdclk: Enter
<4>[ 4166.405304] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.454072] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.454124]  dwrq->length:4096
<4>[ 4166.454540] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4166.454851] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.455021] dhd_prot_ioctl: Enter
<4>[ 4166.455148] dhdcdc_query_ioctl: Enter
<4>[ 4166.455285] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4166.455427] dhdcdc_msg: Enter
<4>[ 4166.455539] dhd_bus_txctl: Enter
<4>[ 4166.455661] dhdsdio_clkctl: Enter
<4>[ 4166.455782] dhdsdio_sdclk: Enter
<4>[ 4166.455897] dhdsdio_htclk: Enter
<4>[ 4166.456196] CLKCTL: turned ON
<4>[ 4166.456345] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.456472] Tx Frame:
<4>[ 4166.456655]   0000: 34 00 cb ff 60 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.456918]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4166.457178]   0032: 00 00 5c 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.457437]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.462101] dhdsdio_isr: Enter
<4>[ 4166.462258] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.462419] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.462574] dhdsdio_dpc: Enter
<4>[ 4166.462767] dhdsdio_clkctl: Enter
<4>[ 4166.463167] dhdsdio_readframes: Enter
<4>[ 4166.463462] RxHdr:
<4>[ 4166.463644]   0000: 28 00 d7 ff 64 00 00 0c 00 6d 00 00 
<4>[ 4166.463817] dhdsdio_read_control: Enter
<4>[ 4166.463951] RxCtrl:
<4>[ 4166.464131]   0000: 28 00 d7 ff 64 00 00 0c 00 6d 00 00 7f 00 00 00 
<4>[ 4166.464568]   0016: 0c 00 00 00 00 00 5c 00 00 00 00 00 d8 ff ff ff 
<4>[ 4166.464814]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4166.465109] RxHdr:
<4>[ 4166.465286]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.465460] dhdsdio_readframes: processed 1 frames
<4>[ 4166.465625] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.465850] dhd_watchdog_thread:
<4>[ 4166.465983] dhd_bus_watchdog: Enter
<4>[ 4166.466110] dhdsdio_clkctl: Enter
<4>[ 4166.466230] dhdsdio_htclk: Enter
<4>[ 4166.466446] CLKCTL: turned OFF
<4>[ 4166.466582] dhdsdio_sdclk: Enter
<4>[ 4166.466710] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.467054] dhdcdc_cmplt: Enter
<4>[ 4166.467196] dhd_bus_rxctl: Enter
<4>[ 4166.467337] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4166.467572] 
<4>[ 4166.467593] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4166.467903] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.468066] dhd_prot_ioctl: Enter
<4>[ 4166.468189] dhdcdc_query_ioctl: Enter
<4>[ 4166.468323] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4166.468463] dhdcdc_msg: Enter
<4>[ 4166.468574] dhd_bus_txctl: Enter
<4>[ 4166.468693] dhdsdio_clkctl: Enter
<4>[ 4166.468812] dhdsdio_sdclk: Enter
<4>[ 4166.468927] dhdsdio_htclk: Enter
<4>[ 4166.478019] CLKCTL: turned ON
<4>[ 4166.478189] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.478320] Tx Frame:
<4>[ 4166.478505]   0000: 4c 00 b3 ff 61 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.478769]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4166.479033]   0032: 00 00 5d 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4166.479293]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.479555]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 44 73 6c d6 
<4>[ 4166.479814]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.489331] dhdsdio_isr: Enter
<4>[ 4166.489488] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.489645] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.489803] dhdsdio_dpc: Enter
<4>[ 4166.490134] dhd_watchdog_thread:
<4>[ 4166.490280] dhd_bus_watchdog: Enter
<4>[ 4166.490411] dhdsdio_clkctl: Enter
<4>[ 4166.490532] dhdsdio_htclk: Enter
<4>[ 4166.490764] CLKCTL: turned OFF
<4>[ 4166.490900] dhdsdio_sdclk: Enter
<4>[ 4166.491032] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.491195] dhdsdio_clkctl: Enter
<4>[ 4166.491326] dhdsdio_sdclk: Enter
<4>[ 4166.491444] dhdsdio_htclk: Enter
<4>[ 4166.491773] CLKCTL: turned ON
<4>[ 4166.491923] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.492299] dhdsdio_readframes: Enter
<4>[ 4166.492591] RxHdr:
<4>[ 4166.492772]   0000: 40 00 bf ff 65 00 00 0c 00 6e 00 00 
<4>[ 4166.492940] dhdsdio_read_control: Enter
<4>[ 4166.493070] RxCtrl:
<4>[ 4166.493249]   0000: 40 00 bf ff 65 00 00 0c 00 6e 00 00 19 00 00 00 
<4>[ 4166.493511]   0016: 24 00 00 00 00 00 5d 00 00 00 00 00 05 00 00 00 
<4>[ 4166.493774]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.494034]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.494530] RxHdr:
<4>[ 4166.494717]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.494891] dhdsdio_readframes: processed 1 frames
<4>[ 4166.495053] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.495281] dhd_watchdog_thread:
<4>[ 4166.495411] dhd_bus_watchdog: Enter
<4>[ 4166.495537] dhdsdio_clkctl: Enter
<4>[ 4166.495656] dhdsdio_htclk: Enter
<4>[ 4166.495874] CLKCTL: turned OFF
<4>[ 4166.496008] dhdsdio_sdclk: Enter
<4>[ 4166.496138] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.496477] dhdcdc_cmplt: Enter
<4>[ 4166.496621] dhd_bus_rxctl: Enter
<4>[ 4166.496767] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4166.496991] wl_iw_get_rssi ssid_len:5, rssi:-40
<4>[ 4166.501705] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.501759]  dwrq->length:4096
<4>[ 4166.502090] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4166.502381] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.502550] dhd_prot_ioctl: Enter
<4>[ 4166.502676] dhdcdc_query_ioctl: Enter
<4>[ 4166.502811] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4166.502950] dhdcdc_msg: Enter
<4>[ 4166.503142] dhd_bus_txctl: Enter
<4>[ 4166.503280] dhdsdio_clkctl: Enter
<4>[ 4166.503405] dhdsdio_sdclk: Enter
<4>[ 4166.503523] dhdsdio_htclk: Enter
<4>[ 4166.514720] CLKCTL: turned ON
<4>[ 4166.514890] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.515020] Tx Frame:
<4>[ 4166.515204]   0000: 2c 00 d3 ff 62 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.515465]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4166.515730]   0032: 00 00 5e 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4166.515989]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.517069] dhdsdio_isr: Enter
<4>[ 4166.517223] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.517384] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.517538] dhdsdio_dpc: Enter
<4>[ 4166.517726] dhdsdio_clkctl: Enter
<4>[ 4166.518125] dhdsdio_readframes: Enter
<4>[ 4166.518420] RxHdr:
<4>[ 4166.518602]   0000: 20 00 df ff 66 00 00 0c 00 6f 00 00 
<4>[ 4166.518772] dhdsdio_read_control: Enter
<4>[ 4166.518904] RxCtrl:
<4>[ 4166.519082]   0000: 20 00 df ff 66 00 00 0c 00 6f 00 00 0c 00 00 00 
<4>[ 4166.519344]   0016: 04 00 00 00 00 00 5e 00 00 00 00 00 6c 00 00 00 
<4>[ 4166.519668] RxHdr:
<4>[ 4166.519843]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.520016] dhdsdio_readframes: processed 1 frames
<4>[ 4166.520178] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.520432] dhdcdc_cmplt: Enter
<4>[ 4166.520560] dhd_bus_rxctl: Enter
<4>[ 4166.520695] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4166.524394] dhd_watchdog_thread:
<4>[ 4166.524556] dhd_bus_watchdog: Enter
<4>[ 4166.524691] dhdsdio_clkctl: Enter
<4>[ 4166.524813] dhdsdio_htclk: Enter
<4>[ 4166.525041] CLKCTL: turned OFF
<4>[ 4166.525177] dhdsdio_sdclk: Enter
<4>[ 4166.525307] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.545044] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.545096]  dwrq->length:4096
<4>[ 4166.545402] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4166.545696] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.545861] dhd_prot_ioctl: Enter
<4>[ 4166.545985] dhdcdc_query_ioctl: Enter
<4>[ 4166.546119] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4166.546261] dhdcdc_msg: Enter
<4>[ 4166.546372] dhd_bus_txctl: Enter
<4>[ 4166.546493] dhdsdio_clkctl: Enter
<4>[ 4166.546614] dhdsdio_sdclk: Enter
<4>[ 4166.546728] dhdsdio_htclk: Enter
<4>[ 4166.556721] CLKCTL: turned ON
<4>[ 4166.556890] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.557021] Tx Frame:
<4>[ 4166.557205]   0000: 34 00 cb ff 63 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.557468]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4166.557729]   0032: 00 00 5f 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.557990]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.565180] dhdsdio_isr: Enter
<4>[ 4166.565338] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.565497] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.565651] dhdsdio_dpc: Enter
<4>[ 4166.565981] dhd_watchdog_thread:
<4>[ 4166.566126] dhd_bus_watchdog: Enter
<4>[ 4166.566255] dhdsdio_clkctl: Enter
<4>[ 4166.566377] dhdsdio_htclk: Enter
<4>[ 4166.566607] CLKCTL: turned OFF
<4>[ 4166.566745] dhdsdio_sdclk: Enter
<4>[ 4166.566877] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.567038] dhdsdio_clkctl: Enter
<4>[ 4166.567168] dhdsdio_sdclk: Enter
<4>[ 4166.567287] dhdsdio_htclk: Enter
<4>[ 4166.567564] CLKCTL: turned ON
<4>[ 4166.567708] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.568077] dhdsdio_readframes: Enter
<4>[ 4166.568364] RxHdr:
<4>[ 4166.568542]   0000: 28 00 d7 ff 67 00 00 0c 00 70 00 00 
<4>[ 4166.568710] dhdsdio_read_control: Enter
<4>[ 4166.568841] RxCtrl:
<4>[ 4166.569019]   0000: 28 00 d7 ff 67 00 00 0c 00 70 00 00 7f 00 00 00 
<4>[ 4166.569285]   0016: 0c 00 00 00 00 00 5f 00 00 00 00 00 d7 ff ff ff 
<4>[ 4166.569508]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4166.569792] RxHdr:
<4>[ 4166.569968]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.570140] dhdsdio_readframes: processed 1 frames
<4>[ 4166.570303] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.570557] dhdcdc_cmplt: Enter
<4>[ 4166.570688] dhd_bus_rxctl: Enter
<4>[ 4166.570826] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4166.571060] 
<4>[ 4166.571081] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4166.571390] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.571555] dhd_prot_ioctl: Enter
<4>[ 4166.571680] dhdcdc_query_ioctl: Enter
<4>[ 4166.571813] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4166.571953] dhdcdc_msg: Enter
<4>[ 4166.572062] dhd_bus_txctl: Enter
<4>[ 4166.572181] dhdsdio_clkctl: Enter
<4>[ 4166.572304] Tx Frame:
<4>[ 4166.572488]   0000: 4c 00 b3 ff 64 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.572750]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4166.573014]   0032: 00 00 60 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4166.573273]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.573533]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 44 73 6c d6 
<4>[ 4166.573792]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.588248] dhdsdio_isr: Enter
<4>[ 4166.588404] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.588564] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.588720] dhdsdio_dpc: Enter
<4>[ 4166.589555] dhd_watchdog_thread:
<4>[ 4166.589760] dhd_bus_watchdog: Enter
<4>[ 4166.589899] dhdsdio_clkctl: Enter
<4>[ 4166.590023] dhdsdio_htclk: Enter
<4>[ 4166.590253] CLKCTL: turned OFF
<4>[ 4166.590390] dhdsdio_sdclk: Enter
<4>[ 4166.590522] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.590685] dhdsdio_clkctl: Enter
<4>[ 4166.590816] dhdsdio_sdclk: Enter
<4>[ 4166.590937] dhdsdio_htclk: Enter
<4>[ 4166.591270] CLKCTL: turned ON
<4>[ 4166.591418] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.591793] dhdsdio_readframes: Enter
<4>[ 4166.592084] RxHdr:
<4>[ 4166.592266]   0000: 40 00 bf ff 68 00 00 0c 00 71 00 00 
<4>[ 4166.592435] dhdsdio_read_control: Enter
<4>[ 4166.592566] RxCtrl:
<4>[ 4166.592744]   0000: 40 00 bf ff 68 00 00 0c 00 71 00 00 19 00 00 00 
<4>[ 4166.593008]   0016: 24 00 00 00 00 00 60 00 00 00 00 00 05 00 00 00 
<4>[ 4166.593271]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.593532]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.593856] RxHdr:
<4>[ 4166.594027]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.594198] dhdsdio_readframes: processed 1 frames
<4>[ 4166.594534] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.594772] dhd_watchdog_thread:
<4>[ 4166.594904] dhd_bus_watchdog: Enter
<4>[ 4166.595032] dhdsdio_clkctl: Enter
<4>[ 4166.595153] dhdsdio_htclk: Enter
<4>[ 4166.595373] CLKCTL: turned OFF
<4>[ 4166.595507] dhdsdio_sdclk: Enter
<4>[ 4166.595637] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.596121] dhdcdc_cmplt: Enter
<4>[ 4166.596270] dhd_bus_rxctl: Enter
<4>[ 4166.596415] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4166.596635] wl_iw_get_rssi ssid_len:5, rssi:-41
<4>[ 4166.600641] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.600696]  dwrq->length:4096
<4>[ 4166.601025] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4166.601316] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.601483] dhd_prot_ioctl: Enter
<4>[ 4166.601606] dhdcdc_query_ioctl: Enter
<4>[ 4166.601741] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4166.601879] dhdcdc_msg: Enter
<4>[ 4166.601991] dhd_bus_txctl: Enter
<4>[ 4166.602111] dhdsdio_clkctl: Enter
<4>[ 4166.602230] dhdsdio_sdclk: Enter
<4>[ 4166.602346] dhdsdio_htclk: Enter
<4>[ 4166.612498] CLKCTL: turned ON
<4>[ 4166.612667] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.612798] Tx Frame:
<4>[ 4166.612983]   0000: 2c 00 d3 ff 65 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.613246]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4166.613509]   0032: 00 00 61 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4166.613769]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.620423] dhdsdio_isr: Enter
<4>[ 4166.620583] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.620742] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.620896] dhdsdio_dpc: Enter
<4>[ 4166.621501] dhd_watchdog_thread:
<4>[ 4166.621654] dhd_bus_watchdog: Enter
<4>[ 4166.621783] dhdsdio_clkctl: Enter
<4>[ 4166.621905] dhdsdio_htclk: Enter
<4>[ 4166.622138] CLKCTL: turned OFF
<4>[ 4166.622278] dhdsdio_sdclk: Enter
<4>[ 4166.622408] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.622570] dhdsdio_clkctl: Enter
<4>[ 4166.622699] dhdsdio_sdclk: Enter
<4>[ 4166.622819] dhdsdio_htclk: Enter
<4>[ 4166.623099] CLKCTL: turned ON
<4>[ 4166.623243] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.623613] dhdsdio_readframes: Enter
<4>[ 4166.623903] RxHdr:
<4>[ 4166.624082]   0000: 20 00 df ff 69 00 00 0c 00 72 00 00 
<4>[ 4166.624418] dhdsdio_read_control: Enter
<4>[ 4166.624572] RxCtrl:
<4>[ 4166.624757]   0000: 20 00 df ff 69 00 00 0c 00 72 00 00 0c 00 00 00 
<4>[ 4166.625021]   0016: 04 00 00 00 00 00 61 00 00 00 00 00 6c 00 00 00 
<4>[ 4166.625361] RxHdr:
<4>[ 4166.625538]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.625709] dhdsdio_readframes: processed 1 frames
<4>[ 4166.625869] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.626094] dhd_watchdog_thread:
<4>[ 4166.626223] dhd_bus_watchdog: Enter
<4>[ 4166.626348] dhdsdio_clkctl: Enter
<4>[ 4166.626467] dhdsdio_htclk: Enter
<4>[ 4166.626684] CLKCTL: turned OFF
<4>[ 4166.626818] dhdsdio_sdclk: Enter
<4>[ 4166.626947] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.627152] dhdcdc_cmplt: Enter
<4>[ 4166.627282] dhd_bus_rxctl: Enter
<4>[ 4166.627421] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4166.661116] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.661168]  dwrq->length:4096
<4>[ 4166.661470] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4166.674415] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.674614] dhd_prot_ioctl: Enter
<4>[ 4166.674745] dhdcdc_query_ioctl: Enter
<4>[ 4166.674882] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4166.675025] dhdcdc_msg: Enter
<4>[ 4166.675137] dhd_bus_txctl: Enter
<4>[ 4166.675258] dhdsdio_clkctl: Enter
<4>[ 4166.675376] dhdsdio_sdclk: Enter
<4>[ 4166.675493] dhdsdio_htclk: Enter
<4>[ 4166.677903] CLKCTL: turned ON
<4>[ 4166.678072] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.678204] Tx Frame:
<4>[ 4166.678388]   0000: 34 00 cb ff 66 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.678651]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4166.678911]   0032: 00 00 62 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.679170]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.686047] dhdsdio_isr: Enter
<4>[ 4166.686205] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.686362] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.686516] dhdsdio_dpc: Enter
<4>[ 4166.686707] dhd_watchdog_thread:
<4>[ 4166.686842] dhd_bus_watchdog: Enter
<4>[ 4166.686969] dhdsdio_clkctl: Enter
<4>[ 4166.687087] dhdsdio_htclk: Enter
<4>[ 4166.687314] CLKCTL: turned OFF
<4>[ 4166.687451] dhdsdio_sdclk: Enter
<4>[ 4166.687580] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.687741] dhdsdio_clkctl: Enter
<4>[ 4166.687870] dhdsdio_sdclk: Enter
<4>[ 4166.687990] dhdsdio_htclk: Enter
<4>[ 4166.688324] CLKCTL: turned ON
<4>[ 4166.688472] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.688891] dhdsdio_readframes: Enter
<4>[ 4166.689191] RxHdr:
<4>[ 4166.689371]   0000: 28 00 d7 ff 6a 00 00 0c 00 73 00 00 
<4>[ 4166.689540] dhdsdio_read_control: Enter
<4>[ 4166.689673] RxCtrl:
<4>[ 4166.689854]   0000: 28 00 d7 ff 6a 00 00 0c 00 73 00 00 7f 00 00 00 
<4>[ 4166.690116]   0016: 0c 00 00 00 00 00 62 00 00 00 00 00 d7 ff ff ff 
<4>[ 4166.690338]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4166.690618] RxHdr:
<4>[ 4166.690791]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.690961] dhdsdio_readframes: processed 1 frames
<4>[ 4166.691124] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.691504] dhdcdc_cmplt: Enter
<4>[ 4166.691645] dhd_bus_rxctl: Enter
<4>[ 4166.691788] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4166.692025] 
<4>[ 4166.692046] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4166.692357] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.692521] dhd_prot_ioctl: Enter
<4>[ 4166.692645] dhdcdc_query_ioctl: Enter
<4>[ 4166.692780] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4166.692921] dhdcdc_msg: Enter
<4>[ 4166.693031] dhd_bus_txctl: Enter
<4>[ 4166.693151] dhdsdio_clkctl: Enter
<4>[ 4166.693275] Tx Frame:
<4>[ 4166.693457]   0000: 4c 00 b3 ff 67 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.693718]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4166.693981]   0032: 00 00 63 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4166.701373]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.701679]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 44 73 6c d6 
<4>[ 4166.701947]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.718069] dhdsdio_isr: Enter
<4>[ 4166.718226] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.718385] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.718538] dhdsdio_dpc: Enter
<4>[ 4166.718733] dhd_watchdog_thread:
<4>[ 4166.718867] dhd_bus_watchdog: Enter
<4>[ 4166.718997] dhdsdio_clkctl: Enter
<4>[ 4166.719116] dhdsdio_htclk: Enter
<4>[ 4166.719342] CLKCTL: turned OFF
<4>[ 4166.719480] dhdsdio_sdclk: Enter
<4>[ 4166.719611] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.719771] dhdsdio_clkctl: Enter
<4>[ 4166.719902] dhdsdio_sdclk: Enter
<4>[ 4166.720023] dhdsdio_htclk: Enter
<4>[ 4166.720356] CLKCTL: turned ON
<4>[ 4166.720507] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.720882] dhdsdio_readframes: Enter
<4>[ 4166.721173] RxHdr:
<4>[ 4166.721356]   0000: 40 00 bf ff 6b 00 00 0c 00 74 00 00 
<4>[ 4166.721527] dhdsdio_read_control: Enter
<4>[ 4166.721659] RxCtrl:
<4>[ 4166.721838]   0000: 40 00 bf ff 6b 00 00 0c 00 74 00 00 19 00 00 00 
<4>[ 4166.722101]   0016: 24 00 00 00 00 00 63 00 00 00 00 00 05 00 00 00 
<4>[ 4166.722363]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.722621]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.722948] RxHdr:
<4>[ 4166.723123]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.723291] dhdsdio_readframes: processed 1 frames
<4>[ 4166.723452] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.723706] dhdcdc_cmplt: Enter
<4>[ 4166.723836] dhd_bus_rxctl: Enter
<4>[ 4166.723972] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4166.724191] wl_iw_get_rssi ssid_len:5, rssi:-41
<4>[ 4166.724504] dhd_watchdog_thread:
<4>[ 4166.724648] dhd_bus_watchdog: Enter
<4>[ 4166.724776] dhdsdio_clkctl: Enter
<4>[ 4166.724896] dhdsdio_htclk: Enter
<4>[ 4166.725113] CLKCTL: turned OFF
<4>[ 4166.725251] dhdsdio_sdclk: Enter
<4>[ 4166.725380] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.726672] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4166.726727]  dwrq->length:4096
<4>[ 4166.727057] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4166.727346] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.727513] dhd_prot_ioctl: Enter
<4>[ 4166.727638] dhdcdc_query_ioctl: Enter
<4>[ 4166.727773] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4166.727910] dhdcdc_msg: Enter
<4>[ 4166.728022] dhd_bus_txctl: Enter
<4>[ 4166.728143] dhdsdio_clkctl: Enter
<4>[ 4166.728261] dhdsdio_sdclk: Enter
<4>[ 4166.728376] dhdsdio_htclk: Enter
<4>[ 4166.728731] CLKCTL: turned ON
<4>[ 4166.728884] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.729013] Tx Frame:
<4>[ 4166.729195]   0000: 2c 00 d3 ff 68 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.729457]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4166.729721]   0032: 00 00 64 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4166.729981]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.730314] dhdcdc_cmplt: Enter
<4>[ 4166.730596] dhdsdio_isr: Enter
<4>[ 4166.730736] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.730893] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.731046] dhdsdio_dpc: Enter
<4>[ 4166.731161] dhdsdio_clkctl: Enter
<4>[ 4166.731535] dhdsdio_readframes: Enter
<4>[ 4166.731826] RxHdr:
<4>[ 4166.732008]   0000: 20 00 df ff 6c 00 00 0c 00 75 00 00 
<4>[ 4166.732179] dhdsdio_read_control: Enter
<4>[ 4166.732312] RxCtrl:
<4>[ 4166.732490]   0000: 20 00 df ff 6c 00 00 0c 00 75 00 00 0c 00 00 00 
<4>[ 4166.732752]   0016: 04 00 00 00 00 00 64 00 00 00 00 00 6c 00 00 00 
<4>[ 4166.733076] RxHdr:
<4>[ 4166.733251]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.733424] dhdsdio_readframes: processed 1 frames
<4>[ 4166.733586] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.733837] dhd_bus_rxctl: Enter
<4>[ 4166.733986] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4166.734394] dhd_watchdog_thread:
<4>[ 4166.734542] dhd_bus_watchdog: Enter
<4>[ 4166.734672] dhdsdio_clkctl: Enter
<4>[ 4166.734794] dhdsdio_htclk: Enter
<4>[ 4166.735015] CLKCTL: turned OFF
<4>[ 4166.735148] dhdsdio_sdclk: Enter
<4>[ 4166.735279] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.799170] dhdsdio_isr: Enter
<4>[ 4166.799328] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.799487] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.799655] dhdsdio_dpc: Enter
<4>[ 4166.799775] dhdsdio_clkctl: Enter
<4>[ 4166.799897] dhdsdio_sdclk: Enter
<4>[ 4166.800015] dhdsdio_htclk: Enter
<4>[ 4166.800350] CLKCTL: turned ON
<4>[ 4166.800500] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.800873] dhdsdio_readframes: Enter
<4>[ 4166.801160] RxHdr:
<4>[ 4166.801338]   0000: a3 00 5c ff 6d 02 00 0e 00 75 00 00 
<4>[ 4166.801739] Rx Data:
<4>[ 4166.801945]   0000: a3 00 5c ff 6d 02 00 0e 00 75 00 00 00 00 20 00 
<4>[ 4166.802218]   0016: 00 00 00 26 37 82 86 b6 00 1d 7e bd 45 a2 88 8e 
<4>[ 4166.802484]   0032: 01 03 00 7f fe 03 a1 00 20 00 00 00 00 00 00 00 
<4>[ 4166.802754]   0048: 61 db f9 5c 57 eb e4 65 76 3a 09 94 7c 5c c6 12 
<4>[ 4166.803023]   0064: 44 ed 12 db d1 ff a7 a4 e1 31 5a 27 fa 74 ee 88 
<4>[ 4166.803291]   0080: 48 ed 12 db d1 ff a7 a4 e1 31 5a 27 fa 74 ee 88 
<4>[ 4166.803550]   0096: 68 97 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.803817]   0112: 00 4a 0e 40 0e 18 ec 8c 3c c0 13 77 b7 f7 c8 e0 
<4>[ 4166.804084]   0128: 67 00 20 ab 3f 9d 13 c1 85 89 76 c7 85 55 da 80 
<4>[ 4166.804529]   0144: 4f 8e 18 c2 6a 9e d1 36 f8 54 b8 f0 91 13 d9 db 
<4>[ 4166.804753]   0160: bc 89 f0 
<4>[ 4166.804871] dhd_prot_hdrpull: Enter
<4>[ 4166.805032] dhd_watchdog_thread:
<4>[ 4166.805158] dhd_bus_watchdog: Enter
<4>[ 4166.805283] dhdsdio_clkctl: Enter
<4>[ 4166.805402] dhdsdio_htclk: Enter
<4>[ 4166.805620] CLKCTL: turned OFF
<4>[ 4166.805754] dhdsdio_sdclk: Enter
<4>[ 4166.805884] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.806043] dhd_rx_frame: Enter
<4>[ 4166.806381] RxHdr:
<4>[ 4166.806563]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.806735] dhdsdio_readframes: processed 1 frames
<4>[ 4166.806898] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.808005] eth0: SIOCSIWENCODEEXT
<4>[ 4166.808167] Setting the key index 2
<4>[ 4166.808342] 
<4>[ 4166.808363] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4166.808678] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.808846] dhd_prot_ioctl: Enter
<4>[ 4166.808970] dhdcdc_query_ioctl: Enter
<4>[ 4166.809106] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4166.809250] dhdcdc_msg: Enter
<4>[ 4166.809362] dhd_bus_txctl: Enter
<4>[ 4166.809483] dhdsdio_clkctl: Enter
<4>[ 4166.809602] dhdsdio_sdclk: Enter
<4>[ 4166.809718] dhdsdio_htclk: Enter
<4>[ 4166.813228] CLKCTL: turned ON
<4>[ 4166.813398] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.813528] Tx Frame:
<4>[ 4166.813714]   0000: cc 00 33 ff 69 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.813978]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4166.834476]   0032: 00 00 65 00 00 00 00 00 02 00 00 00 20 00 00 00 
<4>[ 4166.834788]   0048: 96 ca 0b 18 c0 f8 02 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4166.835064]   0064: fb a2 0d 18 98 5b 7d 48 43 21 b8 33 9d ee a9 48 
<4>[ 4166.835325]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.835585]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.835844]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.836104]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.836363]   0144: 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 
<4>[ 4166.836622]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 
<4>[ 4166.836881]   0176: 00 00 00 00 00 00 00 00 97 00 00 00 00 00 00 00 
<4>[ 4166.837142]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 32 04 
<4>[ 4166.837405]   0208: 0c 12 18 60 dd 09 00 10 18 02 00 13 00 00 00 dd 
<4>[ 4166.844765] dhd_watchdog_thread:
<4>[ 4166.844926] dhd_bus_watchdog: Enter
<4>[ 4166.845094] dhdsdio_clkctl: Enter
<4>[ 4166.845223] dhdsdio_htclk: Enter
<4>[ 4166.845439] CLKCTL: turned OFF
<4>[ 4166.845575] dhdsdio_sdclk: Enter
<4>[ 4166.845709] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.845960] dhdsdio_isr: Enter
<4>[ 4166.846099] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.846255] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.846410] dhdsdio_dpc: Enter
<4>[ 4166.846526] dhdsdio_clkctl: Enter
<4>[ 4166.846646] dhdsdio_sdclk: Enter
<4>[ 4166.846763] dhdsdio_htclk: Enter
<4>[ 4166.847043] CLKCTL: turned ON
<4>[ 4166.847187] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.847557] dhdsdio_readframes: Enter
<4>[ 4166.847848] RxHdr:
<4>[ 4166.848030]   0000: c0 00 3f ff 6e 00 00 0c 00 76 00 00 
<4>[ 4166.848200] dhdsdio_read_control: Enter
<4>[ 4166.848563] RxCtrl:
<4>[ 4166.848767]   0000: c0 00 3f ff 6e 00 00 0c 00 76 00 00 2d 00 00 00 
<4>[ 4166.849034]   0016: a4 00 00 00 00 00 65 00 00 00 00 00 02 00 00 00 
<4>[ 4166.849301]   0032: 20 00 00 00 96 ca 0b 18 c0 f8 02 6e 37 5e c3 a1 
<4>[ 4166.849570]   0048: a3 26 93 13 fb a2 0d 18 98 5b 7d 48 43 21 b8 33 
<4>[ 4166.849832]   0064: 9d ee a9 48 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.850092]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.850351]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.850610]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.850869]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00 
<4>[ 4166.851127]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.851387]   0160: 01 00 00 00 00 00 00 00 00 00 00 00 97 00 00 00 
<4>[ 4166.851645]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.851969] RxHdr:
<4>[ 4166.852143]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.852312] dhdsdio_readframes: processed 1 frames
<4>[ 4166.852473] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.852728] dhdcdc_cmplt: Enter
<4>[ 4166.852864] dhd_bus_rxctl: Enter
<4>[ 4166.853005] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4166.853448] dhd_start_xmit: Enter
<4>[ 4166.853614] dhd_prot_hdrpush: Enter
<4>[ 4166.853749] dhd_bus_txdata: Enter
<4>[ 4166.853876] dhd_bus_txdata: deferring pktq len 0
<4>[ 4166.854088] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4166.854382] dhdsdio_dpc: Enter
<4>[ 4166.854522] dhdsdio_clkctl: Enter
<4>[ 4166.854661] dhdsdio_sendfromq: Enter
<4>[ 4166.854795] dhdsdio_txpkt: Enter
<4>[ 4166.854920] Tx Frame:
<4>[ 4166.855106]   0000: 83 00 7c ff 6a 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4166.855374]   0016: 00 00 00 1d 7e bd 45 a2 00 26 37 82 86 b6 88 8e 
<4>[ 4166.855638]   0032: 01 03 00 5f fe 03 21 00 20 00 00 00 00 00 00 00 
<4>[ 4166.855898]   0048: 61 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.856158]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.856416]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.856675]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.856943]   0112: 00 0d 85 6b 5b 4e af 61 e0 88 83 56 eb 5d b2 77 
<4>[ 4166.857141]   0128: 02 00 00 
<4>[ 4166.857588] dhd_prot_hdrpull: Enter
<4>[ 4166.857798] dhd_watchdog_thread:
<4>[ 4166.857934] dhd_bus_watchdog: Enter
<4>[ 4166.858063] dhdsdio_clkctl: Enter
<4>[ 4166.858183] dhdsdio_htclk: Enter
<4>[ 4166.858394] CLKCTL: turned OFF
<4>[ 4166.858531] dhdsdio_sdclk: Enter
<4>[ 4166.858663] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.871238] dhd_get_stats: Enter
<4>[ 4166.928665] eth0: SIOCSIWPRIV request BTCOEXMODE 1, info->cmd:8b0c, 
info->flags:0
<4>[ 4166.928680]  dwrq->length:4096wl_iw_set_priv:got Framwrork cmd: 
'BTCOEXMODE'
<4>[ 4166.928818] wl_iw_set_btcoex_dhcp: DHCP session start, cmd:BTCOEXMODE 1
<4>[ 4166.928886] 
<4>[ 4166.928892] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c44, len:15 ,
<4>[ 4166.928960] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.929006] dhd_prot_ioctl: Enter
<4>[ 4166.929039] dhdcdc_query_ioctl: Enter
<4>[ 4166.929068] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4166.929100] dhdcdc_msg: Enter
<4>[ 4166.929124] dhd_bus_txctl: Enter
<4>[ 4166.929152] dhdsdio_clkctl: Enter
<4>[ 4166.929177] dhdsdio_sdclk: Enter
<4>[ 4166.929202] dhdsdio_htclk: Enter
<4>[ 4166.929393] CLKCTL: turned ON
<4>[ 4166.929454] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.929489] Tx Frame:
<4>[ 4166.929528]   0000: 37 00 c8 ff 6b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.929578]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4166.929626]   0032: 00 00 66 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4166.929674]   0048: 6d 73 00 42 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4166.929811] dhdcdc_cmplt: Enter
<4>[ 4166.929861] dhd_bus_rxctl: Enter
<4>[ 4166.930028] dhdsdio_isr: Enter
<4>[ 4166.930079] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.930118] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.930153] dhdsdio_dpc: Enter
<4>[ 4166.930179] dhdsdio_clkctl: Enter
<4>[ 4166.930390] dhdsdio_readframes: Enter
<4>[ 4166.930560] RxHdr:
<4>[ 4166.930622]   0000: 2b 00 d4 ff 6f 00 00 0c 00 78 00 00 
<4>[ 4166.930663] dhdsdio_read_control: Enter
<4>[ 4166.930696] RxCtrl:
<4>[ 4166.930735]   0000: 2b 00 d4 ff 6f 00 00 0c 00 78 00 00 06 01 00 00 
<4>[ 4166.930786]   0016: 0f 00 00 00 00 00 66 00 00 00 00 00 88 13 00 00 
<4>[ 4166.930831]   0032: 70 61 72 61 6d 73 00 42 00 00 00 
<4>[ 4166.930972] RxHdr:
<4>[ 4166.931029]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.931071] dhdsdio_readframes: processed 1 frames
<4>[ 4166.931107] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.931194] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4166.931287] 
<4>[ 4166.931292] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c44, len:15 ,
<4>[ 4166.931363] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.931409] dhd_prot_ioctl: Enter
<4>[ 4166.931440] dhdcdc_query_ioctl: Enter
<4>[ 4166.931469] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4166.931500] dhdcdc_msg: Enter
<4>[ 4166.931522] dhd_bus_txctl: Enter
<4>[ 4166.931547] dhdsdio_clkctl: Enter
<4>[ 4166.931576] Tx Frame:
<4>[ 4166.931614]   0000: 37 00 c8 ff 6c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.931662]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4166.931711]   0032: 00 00 67 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4166.931760]   0048: 6d 73 00 29 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4166.931903] dhdcdc_cmplt: Enter
<4>[ 4166.931950] dhd_bus_rxctl: Enter
<4>[ 4166.932114] dhdsdio_isr: Enter
<4>[ 4166.932165] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.932206] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.932239] dhdsdio_dpc: Enter
<4>[ 4166.932266] dhdsdio_clkctl: Enter
<4>[ 4166.932476] dhdsdio_readframes: Enter
<4>[ 4166.932642] RxHdr:
<4>[ 4166.932704]   0000: 2b 00 d4 ff 70 00 00 0c 00 79 00 00 
<4>[ 4166.932745] dhdsdio_read_control: Enter
<4>[ 4166.932776] RxCtrl:
<4>[ 4166.932813]   0000: 2b 00 d4 ff 70 00 00 0c 00 79 00 00 06 01 00 00 
<4>[ 4166.932861]   0016: 0f 00 00 00 00 00 67 00 00 00 00 00 33 00 00 00 
<4>[ 4166.932906]   0032: 70 61 72 61 6d 73 00 29 00 00 00 
<4>[ 4166.933047] RxHdr:
<4>[ 4166.933105]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.933147] dhdsdio_readframes: processed 1 frames
<4>[ 4166.933183] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.933274] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4166.933364] 
<4>[ 4166.933370] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c44, len:15 ,
<4>[ 4166.933445] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.933492] dhd_prot_ioctl: Enter
<4>[ 4166.933524] dhdcdc_query_ioctl: Enter
<4>[ 4166.933552] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4166.933582] dhdcdc_msg: Enter
<4>[ 4166.933605] dhd_bus_txctl: Enter
<4>[ 4166.933630] dhdsdio_clkctl: Enter
<4>[ 4166.933660] Tx Frame:
<4>[ 4166.933698]   0000: 37 00 c8 ff 6d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.933746]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4166.933794]   0032: 00 00 68 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4166.933842]   0048: 6d 73 00 44 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4166.934072] dhdcdc_cmplt: Enter
<4>[ 4166.934322] dhd_watchdog_thread:
<4>[ 4166.934383] dhd_bus_watchdog: Enter
<4>[ 4166.934420] dhdsdio_clkctl: Enter
<4>[ 4166.934449] dhdsdio_htclk: Enter
<4>[ 4166.934590] CLKCTL: turned OFF
<4>[ 4166.934639] dhdsdio_sdclk: Enter
<4>[ 4166.934676] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.934723] dhdsdio_isr: Enter
<4>[ 4166.934760] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.934797] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.934828] dhdsdio_dpc: Enter
<4>[ 4166.934855] dhdsdio_clkctl: Enter
<4>[ 4166.934882] dhdsdio_sdclk: Enter
<4>[ 4166.934907] dhdsdio_htclk: Enter
<4>[ 4166.935087] CLKCTL: turned ON
<4>[ 4166.935145] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.935356] dhdsdio_readframes: Enter
<4>[ 4166.935497] RxHdr:
<4>[ 4166.935557]   0000: 2b 00 d4 ff 71 00 00 0c 00 7a 00 00 
<4>[ 4166.935598] dhdsdio_read_control: Enter
<4>[ 4166.935630] RxCtrl:
<4>[ 4166.935666]   0000: 2b 00 d4 ff 71 00 00 0c 00 7a 00 00 06 01 00 00 
<4>[ 4166.935716]   0016: 0f 00 00 00 00 00 68 00 00 00 00 00 90 01 00 00 
<4>[ 4166.935762]   0032: 70 61 72 61 6d 73 00 44 00 00 00 
<4>[ 4166.935913] RxHdr:
<4>[ 4166.935973]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.936013] dhdsdio_readframes: processed 1 frames
<4>[ 4166.936050] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.938301] dhd_bus_rxctl: Enter
<4>[ 4166.938420] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4166.938492] save regs {66,41,68} ->: 0x1388 0x33 0x190
<4>[ 4166.938552] 
<4>[ 4166.938557] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4166.939064] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.939141] dhd_prot_ioctl: Enter
<4>[ 4166.939182] dhdcdc_query_ioctl: Enter
<4>[ 4166.939215] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4166.939247] dhdcdc_msg: Enter
<4>[ 4166.939271] dhd_bus_txctl: Enter
<4>[ 4166.939301] dhdsdio_clkctl: Enter
<4>[ 4166.939331] Tx Frame:
<4>[ 4166.939370]   0000: 37 00 c8 ff 6e 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.939419]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4166.939468]   0032: 00 00 69 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4166.939516]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4166.941827] dhdsdio_isr: Enter
<4>[ 4166.941894] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.941937] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.941974] dhdsdio_dpc: Enter
<4>[ 4166.942046] dhdsdio_clkctl: Enter
<4>[ 4166.942283] dhdsdio_readframes: Enter
<4>[ 4166.942434] RxHdr:
<4>[ 4166.942494]   0000: 2b 00 d4 ff 72 00 00 0c 00 7b 00 00 
<4>[ 4166.942536] dhdsdio_read_control: Enter
<4>[ 4166.942569] RxCtrl:
<4>[ 4166.942608]   0000: 2b 00 d4 ff 72 00 00 0c 00 7b 00 00 06 01 00 00 
<4>[ 4166.942659]   0016: 0f 00 00 00 00 00 69 00 00 00 00 00 00 00 00 00 
<4>[ 4166.942705]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4166.942829] RxHdr:
<4>[ 4166.942884]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.942925] dhdsdio_readframes: processed 1 frames
<4>[ 4166.942961] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.943045] dhdcdc_cmplt: Enter
<4>[ 4166.943086] dhd_bus_rxctl: Enter
<4>[ 4166.943124] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4166.943182] btcoex_is_sco_active, sample[0], btc params: 27:0
<4>[ 4166.944332] dhd_watchdog_thread:
<4>[ 4166.944402] dhd_bus_watchdog: Enter
<4>[ 4166.944439] dhdsdio_clkctl: Enter
<4>[ 4166.944467] dhdsdio_htclk: Enter
<4>[ 4166.944566] CLKCTL: turned OFF
<4>[ 4166.944616] dhdsdio_sdclk: Enter
<4>[ 4166.944651] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.959203] 
<4>[ 4166.959213] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4166.959317] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.959370] dhd_prot_ioctl: Enter
<4>[ 4166.959404] dhdcdc_query_ioctl: Enter
<4>[ 4166.959435] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4166.959466] dhdcdc_msg: Enter
<4>[ 4166.959491] dhd_bus_txctl: Enter
<4>[ 4166.959519] dhdsdio_clkctl: Enter
<4>[ 4166.959546] dhdsdio_sdclk: Enter
<4>[ 4166.959571] dhdsdio_htclk: Enter
<4>[ 4166.961510] CLKCTL: turned ON
<4>[ 4166.961586] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.961623] Tx Frame:
<4>[ 4166.961665]   0000: 37 00 c8 ff 6f 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.961714]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4166.961763]   0032: 00 00 6a 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4166.961811]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4166.963052] dhdsdio_isr: Enter
<4>[ 4166.963119] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.963160] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.963196] dhdsdio_dpc: Enter
<4>[ 4166.963266] dhdsdio_clkctl: Enter
<4>[ 4166.963492] dhdsdio_readframes: Enter
<4>[ 4166.963662] RxHdr:
<4>[ 4166.963726]   0000: 2b 00 d4 ff 73 00 00 0c 00 7c 00 00 
<4>[ 4166.963769] dhdsdio_read_control: Enter
<4>[ 4166.963800] RxCtrl:
<4>[ 4166.963836]   0000: 2b 00 d4 ff 73 00 00 0c 00 7c 00 00 06 01 00 00 
<4>[ 4166.963885]   0016: 0f 00 00 00 00 00 6a 00 00 00 00 00 00 00 00 00 
<4>[ 4166.963930]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4166.964057] RxHdr:
<4>[ 4166.964112]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.964152] dhdsdio_readframes: processed 1 frames
<4>[ 4166.964189] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.964348] dhd_watchdog_thread:
<4>[ 4166.964402] dhd_bus_watchdog: Enter
<4>[ 4166.964436] dhdsdio_clkctl: Enter
<4>[ 4166.964464] dhdsdio_htclk: Enter
<4>[ 4166.964580] CLKCTL: turned OFF
<4>[ 4166.964626] dhdsdio_sdclk: Enter
<4>[ 4166.964661] dhdsdio_clkctl: 3 -> 0
<4>[ 4166.964739] dhdcdc_cmplt: Enter
<4>[ 4166.964780] dhd_bus_rxctl: Enter
<4>[ 4166.964817] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4166.964878] btcoex_is_sco_active, sample[1], btc params: 27:0
<4>[ 4166.984356] 
<4>[ 4166.984365] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4166.984467] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4166.984518] dhd_prot_ioctl: Enter
<4>[ 4166.984552] dhdcdc_query_ioctl: Enter
<4>[ 4166.984583] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4166.984615] dhdcdc_msg: Enter
<4>[ 4166.984640] dhd_bus_txctl: Enter
<4>[ 4166.984668] dhdsdio_clkctl: Enter
<4>[ 4166.984695] dhdsdio_sdclk: Enter
<4>[ 4166.984718] dhdsdio_htclk: Enter
<4>[ 4166.984894] CLKCTL: turned ON
<4>[ 4166.984954] dhdsdio_clkctl: 0 -> 3
<4>[ 4166.984988] Tx Frame:
<4>[ 4166.985026]   0000: 37 00 c8 ff 70 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4166.985075]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4166.985124]   0032: 00 00 6b 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4166.985172]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4166.985308] dhdcdc_cmplt: Enter
<4>[ 4166.985357] dhd_bus_rxctl: Enter
<4>[ 4166.985522] dhdsdio_isr: Enter
<4>[ 4166.985575] dhdsdio_isr: disable SDIO interrupts
<4>[ 4166.985614] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4166.985650] dhdsdio_dpc: Enter
<4>[ 4166.985678] dhdsdio_clkctl: Enter
<4>[ 4166.985886] dhdsdio_readframes: Enter
<4>[ 4166.986031] RxHdr:
<4>[ 4166.986093]   0000: 2b 00 d4 ff 74 00 00 0c 00 7d 00 00 
<4>[ 4166.986136] dhdsdio_read_control: Enter
<4>[ 4166.986168] RxCtrl:
<4>[ 4166.986206]   0000: 2b 00 d4 ff 74 00 00 0c 00 7d 00 00 06 01 00 00 
<4>[ 4166.986255]   0016: 0f 00 00 00 00 00 6b 00 00 00 00 00 00 00 00 00 
<4>[ 4166.986299]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4166.986460] RxHdr:
<4>[ 4166.986519]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4166.986558] dhdsdio_readframes: processed 1 frames
<4>[ 4166.986593] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4166.986681] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4166.986753] btcoex_is_sco_active, sample[2], btc params: 27:0
<4>[ 4166.994346] dhd_watchdog_thread:
<4>[ 4166.994414] dhd_bus_watchdog: Enter
<4>[ 4166.994452] dhdsdio_clkctl: Enter
<4>[ 4166.994480] dhdsdio_htclk: Enter
<4>[ 4166.994583] CLKCTL: turned OFF
<4>[ 4166.994630] dhdsdio_sdclk: Enter
<4>[ 4166.994666] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.004426] 
<4>[ 4167.004434] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4167.004536] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.004585] dhd_prot_ioctl: Enter
<4>[ 4167.004616] dhdcdc_query_ioctl: Enter
<4>[ 4167.004645] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4167.004676] dhdcdc_msg: Enter
<4>[ 4167.004700] dhd_bus_txctl: Enter
<4>[ 4167.004727] dhdsdio_clkctl: Enter
<4>[ 4167.004753] dhdsdio_sdclk: Enter
<4>[ 4167.004777] dhdsdio_htclk: Enter
<4>[ 4167.004955] CLKCTL: turned ON
<4>[ 4167.005013] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.005046] Tx Frame:
<4>[ 4167.005087]   0000: 37 00 c8 ff 71 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.005137]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4167.005184]   0032: 00 00 6c 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4167.005230]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.005365] dhdcdc_cmplt: Enter
<4>[ 4167.005411] dhd_bus_rxctl: Enter
<4>[ 4167.005581] dhdsdio_isr: Enter
<4>[ 4167.005632] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.005673] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.005708] dhdsdio_dpc: Enter
<4>[ 4167.005735] dhdsdio_clkctl: Enter
<4>[ 4167.005943] dhdsdio_readframes: Enter
<4>[ 4167.006105] RxHdr:
<4>[ 4167.006163]   0000: 2b 00 d4 ff 75 00 00 0c 00 7e 00 00 
<4>[ 4167.006202] dhdsdio_read_control: Enter
<4>[ 4167.006234] RxCtrl:
<4>[ 4167.006272]   0000: 2b 00 d4 ff 75 00 00 0c 00 7e 00 00 06 01 00 00 
<4>[ 4167.006323]   0016: 0f 00 00 00 00 00 6c 00 00 00 00 00 00 00 00 00 
<4>[ 4167.006367]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4167.006500] RxHdr:
<4>[ 4167.006552]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.006591] dhdsdio_readframes: processed 1 frames
<4>[ 4167.006628] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.006719] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4167.006790] btcoex_is_sco_active, sample[3], btc params: 27:0
<4>[ 4167.014344] dhd_watchdog_thread:
<4>[ 4167.014413] dhd_bus_watchdog: Enter
<4>[ 4167.014453] dhdsdio_clkctl: Enter
<4>[ 4167.014482] dhdsdio_htclk: Enter
<4>[ 4167.014583] CLKCTL: turned OFF
<4>[ 4167.014630] dhdsdio_sdclk: Enter
<4>[ 4167.014667] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.024374] 
<4>[ 4167.024383] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4167.024487] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.024536] dhd_prot_ioctl: Enter
<4>[ 4167.024568] dhdcdc_query_ioctl: Enter
<4>[ 4167.024599] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4167.024629] dhdcdc_msg: Enter
<4>[ 4167.024654] dhd_bus_txctl: Enter
<4>[ 4167.024680] dhdsdio_clkctl: Enter
<4>[ 4167.024707] dhdsdio_sdclk: Enter
<4>[ 4167.024730] dhdsdio_htclk: Enter
<4>[ 4167.024906] CLKCTL: turned ON
<4>[ 4167.024965] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.024999] Tx Frame:
<4>[ 4167.025040]   0000: 37 00 c8 ff 72 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.025136]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4167.025201]   0032: 00 00 6d 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4167.025253]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.025635] dhdsdio_isr: Enter
<4>[ 4167.025694] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.025736] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.025773] dhdsdio_dpc: Enter
<4>[ 4167.025844] dhdsdio_clkctl: Enter
<4>[ 4167.026068] dhdsdio_readframes: Enter
<4>[ 4167.026238] RxHdr:
<4>[ 4167.026298]   0000: 2b 00 d4 ff 76 00 00 0c 00 7f 00 00 
<4>[ 4167.026337] dhdsdio_read_control: Enter
<4>[ 4167.026370] RxCtrl:
<4>[ 4167.026406]   0000: 2b 00 d4 ff 76 00 00 0c 00 7f 00 00 06 01 00 00 
<4>[ 4167.026454]   0016: 0f 00 00 00 00 00 6d 00 00 00 00 00 00 00 00 00 
<4>[ 4167.026497]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4167.026622] RxHdr:
<4>[ 4167.026682]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.026719] dhdsdio_readframes: processed 1 frames
<4>[ 4167.026753] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.026832] dhdcdc_cmplt: Enter
<4>[ 4167.026871] dhd_bus_rxctl: Enter
<4>[ 4167.026907] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4167.026966] btcoex_is_sco_active, sample[4], btc params: 27:0
<4>[ 4167.034338] dhd_watchdog_thread:
<4>[ 4167.034405] dhd_bus_watchdog: Enter
<4>[ 4167.034440] dhdsdio_clkctl: Enter
<4>[ 4167.034468] dhdsdio_htclk: Enter
<4>[ 4167.034568] CLKCTL: turned OFF
<4>[ 4167.034618] dhdsdio_sdclk: Enter
<4>[ 4167.034653] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.044407] 
<4>[ 4167.044415] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4167.044519] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.044570] dhd_prot_ioctl: Enter
<4>[ 4167.044602] dhdcdc_query_ioctl: Enter
<4>[ 4167.044631] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4167.044661] dhdcdc_msg: Enter
<4>[ 4167.044686] dhd_bus_txctl: Enter
<4>[ 4167.044715] dhdsdio_clkctl: Enter
<4>[ 4167.044740] dhdsdio_sdclk: Enter
<4>[ 4167.044764] dhdsdio_htclk: Enter
<4>[ 4167.044949] CLKCTL: turned ON
<4>[ 4167.045005] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.045037] Tx Frame:
<4>[ 4167.045077]   0000: 37 00 c8 ff 73 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.045126]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4167.045173]   0032: 00 00 6e 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4167.045222]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.045358] dhdcdc_cmplt: Enter
<4>[ 4167.045404] dhd_bus_rxctl: Enter
<4>[ 4167.045577] dhdsdio_isr: Enter
<4>[ 4167.045628] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.045666] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.045702] dhdsdio_dpc: Enter
<4>[ 4167.045729] dhdsdio_clkctl: Enter
<4>[ 4167.045939] dhdsdio_readframes: Enter
<4>[ 4167.046081] RxHdr:
<4>[ 4167.046139]   0000: 2b 00 d4 ff 77 00 00 0c 00 80 00 00 
<4>[ 4167.046179] dhdsdio_read_control: Enter
<4>[ 4167.046212] RxCtrl:
<4>[ 4167.046248]   0000: 2b 00 d4 ff 77 00 00 0c 00 80 00 00 06 01 00 00 
<4>[ 4167.046296]   0016: 0f 00 00 00 00 00 6e 00 00 00 00 00 00 00 00 00 
<4>[ 4167.046340]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4167.046503] RxHdr:
<4>[ 4167.046559]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.046598] dhdsdio_readframes: processed 1 frames
<4>[ 4167.046634] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.046721] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4167.046793] btcoex_is_sco_active, sample[5], btc params: 27:0
<4>[ 4167.054345] dhd_watchdog_thread:
<4>[ 4167.054413] dhd_bus_watchdog: Enter
<4>[ 4167.054449] dhdsdio_clkctl: Enter
<4>[ 4167.054479] dhdsdio_htclk: Enter
<4>[ 4167.054583] CLKCTL: turned OFF
<4>[ 4167.054628] dhdsdio_sdclk: Enter
<4>[ 4167.054665] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.064410] 
<4>[ 4167.064419] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4167.064520] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.064569] dhd_prot_ioctl: Enter
<4>[ 4167.064600] dhdcdc_query_ioctl: Enter
<4>[ 4167.064630] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4167.064659] dhdcdc_msg: Enter
<4>[ 4167.064684] dhd_bus_txctl: Enter
<4>[ 4167.064712] dhdsdio_clkctl: Enter
<4>[ 4167.064739] dhdsdio_sdclk: Enter
<4>[ 4167.064765] dhdsdio_htclk: Enter
<4>[ 4167.067808] dhdsdio_isr: Enter
<4>[ 4167.067875] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.067917] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.067953] dhdsdio_dpc: Enter
<4>[ 4167.074426] CLKCTL: turned ON
<4>[ 4167.074503] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.074541] Tx Frame:
<4>[ 4167.074583]   0000: 37 00 c8 ff 74 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.074634]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4167.074682]   0032: 00 00 6f 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4167.074730]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.074903] dhdsdio_clkctl: Enter
<4>[ 4167.075135] Dongle reports CHIPACTIVE
<4>[ 4167.075191] dhdsdio_readframes: Enter
<4>[ 4167.075321] RxHdr:
<4>[ 4167.075380]   0000: 2b 00 d4 ff 78 00 00 0c 00 81 00 00 
<4>[ 4167.075422] dhdsdio_read_control: Enter
<4>[ 4167.075452] RxCtrl:
<4>[ 4167.075489]   0000: 2b 00 d4 ff 78 00 00 0c 00 81 00 00 06 01 00 00 
<4>[ 4167.075536]   0016: 0f 00 00 00 00 00 6f 00 00 00 00 00 00 00 00 00 
<4>[ 4167.075579]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4167.075703] RxHdr:
<4>[ 4167.075760]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.075802] dhdsdio_readframes: processed 1 frames
<4>[ 4167.075838] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.075920] dhdcdc_cmplt: Enter
<4>[ 4167.075960] dhd_bus_rxctl: Enter
<4>[ 4167.075995] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4167.076053] btcoex_is_sco_active, sample[6], btc params: 27:0
<4>[ 4167.084349] dhd_watchdog_thread:
<4>[ 4167.084419] dhd_bus_watchdog: Enter
<4>[ 4167.084456] dhdsdio_clkctl: Enter
<4>[ 4167.084485] dhdsdio_htclk: Enter
<4>[ 4167.084589] CLKCTL: turned OFF
<4>[ 4167.084638] dhdsdio_sdclk: Enter
<4>[ 4167.084673] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.094366] 
<4>[ 4167.094374] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4167.094477] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.094528] dhd_prot_ioctl: Enter
<4>[ 4167.094562] dhdcdc_query_ioctl: Enter
<4>[ 4167.094592] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4167.094623] dhdcdc_msg: Enter
<4>[ 4167.094649] dhd_bus_txctl: Enter
<4>[ 4167.094678] dhdsdio_clkctl: Enter
<4>[ 4167.094705] dhdsdio_sdclk: Enter
<4>[ 4167.094730] dhdsdio_htclk: Enter
<4>[ 4167.097716] dhdsdio_isr: Enter
<4>[ 4167.097782] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.097823] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.097859] dhdsdio_dpc: Enter
<4>[ 4167.104414] CLKCTL: turned ON
<4>[ 4167.104491] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.104527] Tx Frame:
<4>[ 4167.104567]   0000: 37 00 c8 ff 75 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.104618]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4167.104670]   0032: 00 00 70 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4167.104719]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.104897] dhdsdio_clkctl: Enter
<4>[ 4167.105125] Dongle reports CHIPACTIVE
<4>[ 4167.105182] dhdsdio_readframes: Enter
<4>[ 4167.105335] RxHdr:
<4>[ 4167.105394]   0000: 2b 00 d4 ff 79 00 00 0c 00 82 00 00 
<4>[ 4167.105437] dhdsdio_read_control: Enter
<4>[ 4167.105468] RxCtrl:
<4>[ 4167.105506]   0000: 2b 00 d4 ff 79 00 00 0c 00 82 00 00 06 01 00 00 
<4>[ 4167.105554]   0016: 0f 00 00 00 00 00 70 00 00 00 00 00 00 00 00 00 
<4>[ 4167.105600]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4167.105725] RxHdr:
<4>[ 4167.105781]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.105821] dhdsdio_readframes: processed 1 frames
<4>[ 4167.105858] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.105942] dhdcdc_cmplt: Enter
<4>[ 4167.105983] dhd_bus_rxctl: Enter
<4>[ 4167.106019] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4167.106079] btcoex_is_sco_active, sample[7], btc params: 27:0
<4>[ 4167.114348] dhd_watchdog_thread:
<4>[ 4167.114419] dhd_bus_watchdog: Enter
<4>[ 4167.114457] dhdsdio_clkctl: Enter
<4>[ 4167.114488] dhdsdio_htclk: Enter
<4>[ 4167.114591] CLKCTL: turned OFF
<4>[ 4167.114638] dhdsdio_sdclk: Enter
<4>[ 4167.114677] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.124364] 
<4>[ 4167.124374] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4167.124475] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.124528] dhd_prot_ioctl: Enter
<4>[ 4167.124561] dhdcdc_query_ioctl: Enter
<4>[ 4167.124592] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4167.124625] dhdcdc_msg: Enter
<4>[ 4167.124651] dhd_bus_txctl: Enter
<4>[ 4167.124680] dhdsdio_clkctl: Enter
<4>[ 4167.124707] dhdsdio_sdclk: Enter
<4>[ 4167.124732] dhdsdio_htclk: Enter
<4>[ 4167.127724] dhdsdio_isr: Enter
<4>[ 4167.127794] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.127839] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.127877] dhdsdio_dpc: Enter
<4>[ 4167.134422] CLKCTL: turned ON
<4>[ 4167.134498] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.134535] Tx Frame:
<4>[ 4167.134576]   0000: 37 00 c8 ff 76 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.134625]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4167.134673]   0032: 00 00 71 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4167.134721]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.134901] dhdsdio_clkctl: Enter
<4>[ 4167.135128] Dongle reports CHIPACTIVE
<4>[ 4167.135186] dhdsdio_readframes: Enter
<4>[ 4167.135316] RxHdr:
<4>[ 4167.135375]   0000: 2b 00 d4 ff 7a 00 00 0c 00 83 00 00 
<4>[ 4167.135417] dhdsdio_read_control: Enter
<4>[ 4167.135451] RxCtrl:
<4>[ 4167.135489]   0000: 2b 00 d4 ff 7a 00 00 0c 00 83 00 00 06 01 00 00 
<4>[ 4167.135538]   0016: 0f 00 00 00 00 00 71 00 00 00 00 00 00 00 00 00 
<4>[ 4167.135584]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4167.135709] RxHdr:
<4>[ 4167.135768]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.135806] dhdsdio_readframes: processed 1 frames
<4>[ 4167.135844] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.135924] dhdcdc_cmplt: Enter
<4>[ 4167.135965] dhd_bus_rxctl: Enter
<4>[ 4167.136001] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4167.136060] btcoex_is_sco_active, sample[8], btc params: 27:0
<4>[ 4167.144346] dhd_watchdog_thread:
<4>[ 4167.144416] dhd_bus_watchdog: Enter
<4>[ 4167.144453] dhdsdio_clkctl: Enter
<4>[ 4167.144484] dhdsdio_htclk: Enter
<4>[ 4167.144587] CLKCTL: turned OFF
<4>[ 4167.144636] dhdsdio_sdclk: Enter
<4>[ 4167.144672] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.154350] 
<4>[ 4167.154359] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4167.154461] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.154513] dhd_prot_ioctl: Enter
<4>[ 4167.154547] dhdcdc_query_ioctl: Enter
<4>[ 4167.154578] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4167.154610] dhdcdc_msg: Enter
<4>[ 4167.154635] dhd_bus_txctl: Enter
<4>[ 4167.154663] dhdsdio_clkctl: Enter
<4>[ 4167.154690] dhdsdio_sdclk: Enter
<4>[ 4167.154716] dhdsdio_htclk: Enter
<4>[ 4167.157726] dhdsdio_isr: Enter
<4>[ 4167.157794] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.157835] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.157873] dhdsdio_dpc: Enter
<4>[ 4167.164496] CLKCTL: turned ON
<4>[ 4167.164574] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.164611] Tx Frame:
<4>[ 4167.164653]   0000: 37 00 c8 ff 77 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.164702]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4167.164753]   0032: 00 00 72 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4167.164801]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.164979] dhdsdio_clkctl: Enter
<4>[ 4167.165205] Dongle reports CHIPACTIVE
<4>[ 4167.165261] dhdsdio_readframes: Enter
<4>[ 4167.165390] RxHdr:
<4>[ 4167.165450]   0000: 2b 00 d4 ff 7b 00 00 0c 00 84 00 00 
<4>[ 4167.165488] dhdsdio_read_control: Enter
<4>[ 4167.165519] RxCtrl:
<4>[ 4167.165555]   0000: 2b 00 d4 ff 7b 00 00 0c 00 84 00 00 06 01 00 00 
<4>[ 4167.165604]   0016: 0f 00 00 00 00 00 72 00 00 00 00 00 00 00 00 00 
<4>[ 4167.165649]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4167.165775] RxHdr:
<4>[ 4167.165834]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.165875] dhdsdio_readframes: processed 1 frames
<4>[ 4167.165912] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.165995] dhdcdc_cmplt: Enter
<4>[ 4167.166035] dhd_bus_rxctl: Enter
<4>[ 4167.166070] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4167.166129] btcoex_is_sco_active, sample[9], btc params: 27:0
<4>[ 4167.174345] dhd_watchdog_thread:
<4>[ 4167.174413] dhd_bus_watchdog: Enter
<4>[ 4167.174451] dhdsdio_clkctl: Enter
<4>[ 4167.174482] dhdsdio_htclk: Enter
<4>[ 4167.174587] CLKCTL: turned OFF
<4>[ 4167.174636] dhdsdio_sdclk: Enter
<4>[ 4167.174672] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.184411] 
<4>[ 4167.184421] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4167.184525] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.184578] dhd_prot_ioctl: Enter
<4>[ 4167.184609] dhdcdc_query_ioctl: Enter
<4>[ 4167.184640] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4167.184670] dhdcdc_msg: Enter
<4>[ 4167.184695] dhd_bus_txctl: Enter
<4>[ 4167.184722] dhdsdio_clkctl: Enter
<4>[ 4167.184749] dhdsdio_sdclk: Enter
<4>[ 4167.184774] dhdsdio_htclk: Enter
<4>[ 4167.186426] dhdsdio_isr: Enter
<4>[ 4167.186490] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.186532] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.186568] dhdsdio_dpc: Enter
<4>[ 4167.194445] CLKCTL: turned ON
<4>[ 4167.194524] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.194561] Tx Frame:
<4>[ 4167.194604]   0000: 37 00 c8 ff 78 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.194655]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4167.194704]   0032: 00 00 73 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4167.194753]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.194933] dhdsdio_clkctl: Enter
<4>[ 4167.195158] Dongle reports CHIPACTIVE
<4>[ 4167.195215] dhdsdio_readframes: Enter
<4>[ 4167.195343] RxHdr:
<4>[ 4167.195398]   0000: 2b 00 d4 ff 7c 00 00 0c 00 85 00 00 
<4>[ 4167.195439] dhdsdio_read_control: Enter
<4>[ 4167.195471] RxCtrl:
<4>[ 4167.195510]   0000: 2b 00 d4 ff 7c 00 00 0c 00 85 00 00 06 01 00 00 
<4>[ 4167.195558]   0016: 0f 00 00 00 00 00 73 00 00 00 00 00 00 00 00 00 
<4>[ 4167.195602]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4167.195749] RxHdr:
<4>[ 4167.195810]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.195849] dhdsdio_readframes: processed 1 frames
<4>[ 4167.195885] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.195966] dhdcdc_cmplt: Enter
<4>[ 4167.196006] dhd_bus_rxctl: Enter
<4>[ 4167.196043] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4167.196105] btcoex_is_sco_active, sample[10], btc params: 27:0
<4>[ 4167.204338] dhd_watchdog_thread:
<4>[ 4167.204407] dhd_bus_watchdog: Enter
<4>[ 4167.204448] dhdsdio_clkctl: Enter
<4>[ 4167.204478] dhdsdio_htclk: Enter
<4>[ 4167.204578] CLKCTL: turned OFF
<4>[ 4167.204626] dhdsdio_sdclk: Enter
<4>[ 4167.204662] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.215868] 
<4>[ 4167.215877] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297c24, len:15 ,
<4>[ 4167.215982] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.216032] dhd_prot_ioctl: Enter
<4>[ 4167.216065] dhdcdc_query_ioctl: Enter
<4>[ 4167.216096] dhdcdc_query_ioctl: cmd 262 len 15
<4>[ 4167.216127] dhdcdc_msg: Enter
<4>[ 4167.216152] dhd_bus_txctl: Enter
<4>[ 4167.216181] dhdsdio_clkctl: Enter
<4>[ 4167.216207] dhdsdio_sdclk: Enter
<4>[ 4167.216231] dhdsdio_htclk: Enter
<4>[ 4167.219248] dhdsdio_isr: Enter
<4>[ 4167.219320] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.219365] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.219403] dhdsdio_dpc: Enter
<4>[ 4167.224460] CLKCTL: turned ON
<4>[ 4167.224542] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.224584] Tx Frame:
<4>[ 4167.224626]   0000: 37 00 c8 ff 79 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.224677]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 0f 00 00 00 
<4>[ 4167.224726]   0032: 00 00 74 00 00 00 00 00 62 74 63 5f 70 61 72 61 
<4>[ 4167.224775]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.224957] dhdsdio_clkctl: Enter
<4>[ 4167.225188] Dongle reports CHIPACTIVE
<4>[ 4167.225247] dhdsdio_readframes: Enter
<4>[ 4167.225378] RxHdr:
<4>[ 4167.225439]   0000: 2b 00 d4 ff 7d 00 00 0c 00 86 00 00 
<4>[ 4167.225482] dhdsdio_read_control: Enter
<4>[ 4167.225514] RxCtrl:
<4>[ 4167.225552]   0000: 2b 00 d4 ff 7d 00 00 0c 00 86 00 00 06 01 00 00 
<4>[ 4167.225602]   0016: 0f 00 00 00 00 00 74 00 00 00 00 00 00 00 00 00 
<4>[ 4167.225648]   0032: 70 61 72 61 6d 73 00 1b 00 00 00 
<4>[ 4167.225776] RxHdr:
<4>[ 4167.225831]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.225871] dhdsdio_readframes: processed 1 frames
<4>[ 4167.225905] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.226157] dhdcdc_cmplt: Enter
<4>[ 4167.226220] dhd_bus_rxctl: Enter
<4>[ 4167.226261] dhd_bus_rxctl: resumed on rxctl frame, got 31 expected 31
<4>[ 4167.226322] btcoex_is_sco_active, sample[11], btc params: 27:0
<4>[ 4167.234353] dhd_watchdog_thread:
<4>[ 4167.234423] dhd_bus_watchdog: Enter
<4>[ 4167.234460] dhdsdio_clkctl: Enter
<4>[ 4167.234490] dhdsdio_htclk: Enter
<4>[ 4167.234613] CLKCTL: turned OFF
<4>[ 4167.234666] dhdsdio_sdclk: Enter
<4>[ 4167.234700] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.245019] eth0: SIOCSIWPRIV request GETPOWER, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.245034]  dwrq->length:4096
<4>[ 4167.245142] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x55, 
buf:c2297d88, len:4 ,
<4>[ 4167.245216] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.245264] dhd_prot_ioctl: Enter
<4>[ 4167.245293] dhdcdc_query_ioctl: Enter
<4>[ 4167.245323] dhdcdc_query_ioctl: cmd 85 len 4
<4>[ 4167.245352] dhdcdc_msg: Enter
<4>[ 4167.245378] dhd_bus_txctl: Enter
<4>[ 4167.245407] dhdsdio_clkctl: Enter
<4>[ 4167.245433] dhdsdio_sdclk: Enter
<4>[ 4167.245457] dhdsdio_htclk: Enter
<4>[ 4167.248468] dhdsdio_isr: Enter
<4>[ 4167.248535] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.248575] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.248610] dhdsdio_dpc: Enter
<4>[ 4167.254419] CLKCTL: turned ON
<4>[ 4167.254496] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.254535] Tx Frame:
<4>[ 4167.254577]   0000: 2c 00 d3 ff 7a 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.254628]   0016: 00 00 00 00 00 00 00 00 55 00 00 00 04 00 00 00 
<4>[ 4167.254678]   0032: 00 00 75 00 00 00 00 00 02 00 00 00 70 61 72 61 
<4>[ 4167.254727]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.254908] dhdsdio_clkctl: Enter
<4>[ 4167.255134] Dongle reports CHIPACTIVE
<4>[ 4167.255190] dhdsdio_readframes: Enter
<4>[ 4167.255338] RxHdr:
<4>[ 4167.255398]   0000: 20 00 df ff 7e 00 00 0c 00 87 00 00 
<4>[ 4167.255439] dhdsdio_read_control: Enter
<4>[ 4167.255471] RxCtrl:
<4>[ 4167.255509]   0000: 20 00 df ff 7e 00 00 0c 00 87 00 00 55 00 00 00 
<4>[ 4167.255559]   0016: 04 00 00 00 00 00 75 00 00 00 00 00 02 00 00 00 
<4>[ 4167.255687] RxHdr:
<4>[ 4167.255742]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.255783] dhdsdio_readframes: processed 1 frames
<4>[ 4167.255820] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.255903] dhdcdc_cmplt: Enter
<4>[ 4167.255944] dhd_bus_rxctl: Enter
<4>[ 4167.255980] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4167.256038] wl_iw_get_power_mode: Powermode = 2
<4>[ 4167.256789] eth0: SIOCSIWPRIV request POWERMODE 1, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.256804]  dwrq->length:4096wl_iw_set_power_mode: DHCP session 
cmd:POWERMODE 1
<4>[ 4167.256951] 
<4>[ 4167.256958] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x55, 
buf:bf26c5b0, len:4 ,
<4>[ 4167.257027] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.257076] dhd_prot_ioctl: Enter
<4>[ 4167.257109] dhdcdc_query_ioctl: Enter
<4>[ 4167.257138] dhdcdc_query_ioctl: cmd 85 len 4
<4>[ 4167.257167] dhdcdc_msg: Enter
<4>[ 4167.257192] dhd_bus_txctl: Enter
<4>[ 4167.257220] dhdsdio_clkctl: Enter
<4>[ 4167.257251] Tx Frame:
<4>[ 4167.257289]   0000: 2c 00 d3 ff 7b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.257339]   0016: 00 00 00 00 00 00 00 00 55 00 00 00 04 00 00 00 
<4>[ 4167.257387]   0032: 00 00 76 00 00 00 00 00 02 00 00 00 70 61 72 61 
<4>[ 4167.257434]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.257677] dhdsdio_isr: Enter
<4>[ 4167.257733] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.257777] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.257812] dhdsdio_dpc: Enter
<4>[ 4167.257876] dhdsdio_clkctl: Enter
<4>[ 4167.258100] dhdsdio_readframes: Enter
<4>[ 4167.258269] RxHdr:
<4>[ 4167.258327]   0000: 20 00 df ff 7f 00 00 0c 00 88 00 00 
<4>[ 4167.258368] dhdsdio_read_control: Enter
<4>[ 4167.258400] RxCtrl:
<4>[ 4167.258437]   0000: 20 00 df ff 7f 00 00 0c 00 88 00 00 55 00 00 00 
<4>[ 4167.258486]   0016: 04 00 00 00 00 00 76 00 00 00 00 00 02 00 00 00 
<4>[ 4167.258617] RxHdr:
<4>[ 4167.258673]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.258713] dhdsdio_readframes: processed 1 frames
<4>[ 4167.258751] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.258834] dhdcdc_cmplt: Enter
<4>[ 4167.258875] dhd_bus_rxctl: Enter
<4>[ 4167.258915] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4167.258980] 
<4>[ 4167.258985] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x56, 
buf:c2297d84, len:4 ,
<4>[ 4167.259053] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.259095] dhd_prot_ioctl: Enter
<4>[ 4167.259126] dhdcdc_query_ioctl: Enter
<4>[ 4167.259154] dhdcdc_query_ioctl: cmd 86 len 4
<4>[ 4167.259182] dhdcdc_msg: Enter
<4>[ 4167.259204] dhd_bus_txctl: Enter
<4>[ 4167.259229] dhdsdio_clkctl: Enter
<4>[ 4167.259259] Tx Frame:
<4>[ 4167.259296]   0000: 2c 00 d3 ff 7c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.259344]   0016: 00 00 00 00 00 00 00 00 56 00 00 00 04 00 00 00 
<4>[ 4167.259393]   0032: 00 00 77 00 00 00 00 00 00 00 00 00 70 61 72 61 
<4>[ 4167.259440]   0048: 6d 73 00 1b 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.259581] dhdcdc_cmplt: Enter
<4>[ 4167.259630] dhd_bus_rxctl: Enter
<4>[ 4167.259946] dhdsdio_isr: Enter
<4>[ 4167.260004] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.260045] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.260082] dhdsdio_dpc: Enter
<4>[ 4167.260110] dhdsdio_clkctl: Enter
<4>[ 4167.260332] dhdsdio_readframes: Enter
<4>[ 4167.260478] RxHdr:
<4>[ 4167.260540]   0000: 20 00 df ff 80 00 00 0c 00 89 00 00 
<4>[ 4167.260585] dhdsdio_read_control: Enter
<4>[ 4167.260617] RxCtrl:
<4>[ 4167.260655]   0000: 20 00 df ff 80 00 00 0c 00 89 00 00 56 00 00 00 
<4>[ 4167.260705]   0016: 04 00 00 00 00 00 77 00 00 00 00 00 00 00 00 00 
<4>[ 4167.260846] RxHdr:
<4>[ 4167.260902]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.260942] dhdsdio_readframes: processed 1 frames
<4>[ 4167.260978] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.261087] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4167.261166] wl_iw_set_power_mode: DHCP start, pm:2 changed to pm:0
<4>[ 4167.264359] dhd_watchdog_thread:
<4>[ 4167.264428] dhd_bus_watchdog: Enter
<4>[ 4167.264466] dhdsdio_clkctl: Enter
<4>[ 4167.264494] dhdsdio_htclk: Enter
<4>[ 4167.264595] CLKCTL: turned OFF
<4>[ 4167.264639] dhdsdio_sdclk: Enter
<4>[ 4167.264674] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.272251] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.272265]  dwrq->length:4096
<4>[ 4167.272367] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4167.272440] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.272487] dhd_prot_ioctl: Enter
<4>[ 4167.272518] dhdcdc_query_ioctl: Enter
<4>[ 4167.272549] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4167.272580] dhdcdc_msg: Enter
<4>[ 4167.272605] dhd_bus_txctl: Enter
<4>[ 4167.272633] dhdsdio_clkctl: Enter
<4>[ 4167.272661] dhdsdio_sdclk: Enter
<4>[ 4167.272685] dhdsdio_htclk: Enter
<4>[ 4167.285783] CLKCTL: turned ON
<4>[ 4167.285861] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.285901] Tx Frame:
<4>[ 4167.285945]   0000: 34 00 cb ff 7d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.285995]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4167.286043]   0032: 00 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.286091]   0048: 00 00 00 00 00 00 00 6e 37 5e c3 a1 a3 26 93 13 
<4>[ 4167.287990] dhdsdio_isr: Enter
<4>[ 4167.288056] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.288098] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.288135] dhdsdio_dpc: Enter
<4>[ 4167.288287] dhdsdio_clkctl: Enter
<4>[ 4167.288534] dhdsdio_readframes: Enter
<4>[ 4167.288686] RxHdr:
<4>[ 4167.288747]   0000: 28 00 d7 ff 81 00 00 0c 00 8a 00 00 
<4>[ 4167.288789] dhdsdio_read_control: Enter
<4>[ 4167.288819] RxCtrl:
<4>[ 4167.288857]   0000: 28 00 d7 ff 81 00 00 0c 00 8a 00 00 7f 00 00 00 
<4>[ 4167.288907]   0016: 0c 00 00 00 00 00 78 00 00 00 00 00 d7 ff ff ff 
<4>[ 4167.288949]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4167.289071] RxHdr:
<4>[ 4167.289127]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.289168] dhdsdio_readframes: processed 1 frames
<4>[ 4167.289205] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.289295] dhdcdc_cmplt: Enter
<4>[ 4167.289335] dhd_bus_rxctl: Enter
<4>[ 4167.289374] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4167.289439] 
<4>[ 4167.289445] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4167.289514] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.289556] dhd_prot_ioctl: Enter
<4>[ 4167.289590] dhdcdc_query_ioctl: Enter
<4>[ 4167.289618] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4167.289647] dhdcdc_msg: Enter
<4>[ 4167.289671] dhd_bus_txctl: Enter
<4>[ 4167.289698] dhdsdio_clkctl: Enter
<4>[ 4167.289727] Tx Frame:
<4>[ 4167.289767]   0000: 4c 00 b3 ff 7e 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.289816]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4167.289864]   0032: 00 00 79 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4167.289911]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.289959]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 9d ee a9 48 
<4>[ 4167.290005]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.293848] dhdsdio_isr: Enter
<4>[ 4167.293915] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.293957] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.293992] dhdsdio_dpc: Enter
<4>[ 4167.294142] dhdsdio_clkctl: Enter
<4>[ 4167.294494] dhdsdio_readframes: Enter
<4>[ 4167.294650] RxHdr:
<4>[ 4167.294712]   0000: 40 00 bf ff 82 00 00 0c 00 8b 00 00 
<4>[ 4167.294753] dhdsdio_read_control: Enter
<4>[ 4167.294785] RxCtrl:
<4>[ 4167.294824]   0000: 40 00 bf ff 82 00 00 0c 00 8b 00 00 19 00 00 00 
<4>[ 4167.294875]   0016: 24 00 00 00 00 00 79 00 00 00 00 00 05 00 00 00 
<4>[ 4167.294925]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.294971]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.295100] RxHdr:
<4>[ 4167.295154]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.295194] dhdsdio_readframes: processed 1 frames
<4>[ 4167.295231] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.295297] dhd_watchdog_thread:
<4>[ 4167.295333] dhd_bus_watchdog: Enter
<4>[ 4167.295365] dhdsdio_clkctl: Enter
<4>[ 4167.295391] dhdsdio_htclk: Enter
<4>[ 4167.295498] CLKCTL: turned OFF
<4>[ 4167.295545] dhdsdio_sdclk: Enter
<4>[ 4167.295582] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.296050] dhdcdc_cmplt: Enter
<4>[ 4167.296111] dhd_bus_rxctl: Enter
<4>[ 4167.296156] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4167.296989] wl_iw_get_rssi ssid_len:5, rssi:-41
<4>[ 4167.315046] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.315061]  dwrq->length:4096
<4>[ 4167.315170] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4167.315239] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.315286] dhd_prot_ioctl: Enter
<4>[ 4167.315318] dhdcdc_query_ioctl: Enter
<4>[ 4167.315347] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4167.315377] dhdcdc_msg: Enter
<4>[ 4167.315402] dhd_bus_txctl: Enter
<4>[ 4167.315430] dhdsdio_clkctl: Enter
<4>[ 4167.315457] dhdsdio_sdclk: Enter
<4>[ 4167.315481] dhdsdio_htclk: Enter
<4>[ 4167.317058] CLKCTL: turned ON
<4>[ 4167.317136] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.317175] Tx Frame:
<4>[ 4167.317220]   0000: 2c 00 d3 ff 7f 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.317271]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4167.317319]   0032: 00 00 7a 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4167.317365]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.319664] dhdsdio_isr: Enter
<4>[ 4167.319731] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.319773] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.319808] dhdsdio_dpc: Enter
<4>[ 4167.319883] dhdsdio_clkctl: Enter
<4>[ 4167.320116] dhdsdio_readframes: Enter
<4>[ 4167.320267] RxHdr:
<4>[ 4167.320326]   0000: 20 00 df ff 83 00 00 0c 00 8c 00 00 
<4>[ 4167.320367] dhdsdio_read_control: Enter
<4>[ 4167.320399] RxCtrl:
<4>[ 4167.320436]   0000: 20 00 df ff 83 00 00 0c 00 8c 00 00 0c 00 00 00 
<4>[ 4167.320487]   0016: 04 00 00 00 00 00 7a 00 00 00 00 00 6c 00 00 00 
<4>[ 4167.320646] RxHdr:
<4>[ 4167.320704]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.320747] dhdsdio_readframes: processed 1 frames
<4>[ 4167.320785] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.320953] dhdcdc_cmplt: Enter
<4>[ 4167.321007] dhd_bus_rxctl: Enter
<4>[ 4167.321048] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4167.324345] dhd_watchdog_thread:
<4>[ 4167.324415] dhd_bus_watchdog: Enter
<4>[ 4167.324452] dhdsdio_clkctl: Enter
<4>[ 4167.324482] dhdsdio_htclk: Enter
<4>[ 4167.324586] CLKCTL: turned OFF
<4>[ 4167.324634] dhdsdio_sdclk: Enter
<4>[ 4167.324667] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.335051] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.335065]  dwrq->length:4096
<4>[ 4167.335168] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4167.335241] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.335287] dhd_prot_ioctl: Enter
<4>[ 4167.335319] dhdcdc_query_ioctl: Enter
<4>[ 4167.335347] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4167.335376] dhdcdc_msg: Enter
<4>[ 4167.335400] dhd_bus_txctl: Enter
<4>[ 4167.335428] dhdsdio_clkctl: Enter
<4>[ 4167.335455] dhdsdio_sdclk: Enter
<4>[ 4167.335480] dhdsdio_htclk: Enter
<4>[ 4167.338963] CLKCTL: turned ON
<4>[ 4167.339444] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.339501] Tx Frame:
<4>[ 4167.339551]   0000: 34 00 cb ff 80 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.339605]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4167.339654]   0032: 00 00 7b 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.339701]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.341543] dhdsdio_isr: Enter
<4>[ 4167.341613] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.341661] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.341700] dhdsdio_dpc: Enter
<4>[ 4167.341777] dhdsdio_clkctl: Enter
<4>[ 4167.342013] dhdsdio_readframes: Enter
<4>[ 4167.342159] RxHdr:
<4>[ 4167.342219]   0000: 28 00 d7 ff 84 00 00 0c 00 8d 00 00 
<4>[ 4167.342259] dhdsdio_read_control: Enter
<4>[ 4167.342291] RxCtrl:
<4>[ 4167.342329]   0000: 28 00 d7 ff 84 00 00 0c 00 8d 00 00 7f 00 00 00 
<4>[ 4167.342378]   0016: 0c 00 00 00 00 00 7b 00 00 00 00 00 d7 ff ff ff 
<4>[ 4167.342419]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4167.342540] RxHdr:
<4>[ 4167.342595]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.342634] dhdsdio_readframes: processed 1 frames
<4>[ 4167.342669] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.342753] dhdcdc_cmplt: Enter
<4>[ 4167.342795] dhd_bus_rxctl: Enter
<4>[ 4167.342832] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4167.342896] 
<4>[ 4167.342901] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4167.342971] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.343016] dhd_prot_ioctl: Enter
<4>[ 4167.343047] dhdcdc_query_ioctl: Enter
<4>[ 4167.343077] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4167.343108] dhdcdc_msg: Enter
<4>[ 4167.343132] dhd_bus_txctl: Enter
<4>[ 4167.343158] dhdsdio_clkctl: Enter
<4>[ 4167.343187] Tx Frame:
<4>[ 4167.343227]   0000: 4c 00 b3 ff 81 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.343276]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4167.343323]   0032: 00 00 7c 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4167.343370]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.343416]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 9d ee a9 48 
<4>[ 4167.343463]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.347441] dhdsdio_isr: Enter
<4>[ 4167.347509] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.347551] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.347588] dhdsdio_dpc: Enter
<4>[ 4167.347749] dhd_watchdog_thread:
<4>[ 4167.347801] dhd_bus_watchdog: Enter
<4>[ 4167.347835] dhdsdio_clkctl: Enter
<4>[ 4167.347864] dhdsdio_htclk: Enter
<4>[ 4167.347970] CLKCTL: turned OFF
<4>[ 4167.348017] dhdsdio_sdclk: Enter
<4>[ 4167.348052] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.348106] dhdsdio_clkctl: Enter
<4>[ 4167.348145] dhdsdio_sdclk: Enter
<4>[ 4167.348177] dhdsdio_htclk: Enter
<4>[ 4167.348354] CLKCTL: turned ON
<4>[ 4167.348414] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.348649] dhdsdio_readframes: Enter
<4>[ 4167.348822] RxHdr:
<4>[ 4167.348884]   0000: 40 00 bf ff 85 00 00 0c 00 8e 00 00 
<4>[ 4167.348926] dhdsdio_read_control: Enter
<4>[ 4167.348959] RxCtrl:
<4>[ 4167.348997]   0000: 40 00 bf ff 85 00 00 0c 00 8e 00 00 19 00 00 00 
<4>[ 4167.349046]   0016: 24 00 00 00 00 00 7c 00 00 00 00 00 05 00 00 00 
<4>[ 4167.349095]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.349142]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.349274] RxHdr:
<4>[ 4167.349328]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.349368] dhdsdio_readframes: processed 1 frames
<4>[ 4167.349404] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.349568] dhdcdc_cmplt: Enter
<4>[ 4167.349620] dhd_bus_rxctl: Enter
<4>[ 4167.349660] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4167.349719] wl_iw_get_rssi ssid_len:5, rssi:-41
<4>[ 4167.352420] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.352435]  dwrq->length:4096
<4>[ 4167.352546] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4167.352619] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.352667] dhd_prot_ioctl: Enter
<4>[ 4167.352700] dhdcdc_query_ioctl: Enter
<4>[ 4167.352731] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4167.352759] dhdcdc_msg: Enter
<4>[ 4167.352783] dhd_bus_txctl: Enter
<4>[ 4167.352810] dhdsdio_clkctl: Enter
<4>[ 4167.352841] Tx Frame:
<4>[ 4167.352879]   0000: 2c 00 d3 ff 82 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.352927]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4167.352975]   0032: 00 00 7d 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4167.353021]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.358709] dhdsdio_isr: Enter
<4>[ 4167.358777] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.358816] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.358853] dhdsdio_dpc: Enter
<4>[ 4167.358927] dhd_watchdog_thread:
<4>[ 4167.358971] dhd_bus_watchdog: Enter
<4>[ 4167.359004] dhdsdio_clkctl: Enter
<4>[ 4167.359031] dhdsdio_htclk: Enter
<4>[ 4167.359132] CLKCTL: turned OFF
<4>[ 4167.359179] dhdsdio_sdclk: Enter
<4>[ 4167.359215] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.359270] dhdsdio_clkctl: Enter
<4>[ 4167.359307] dhdsdio_sdclk: Enter
<4>[ 4167.359334] dhdsdio_htclk: Enter
<4>[ 4167.359509] CLKCTL: turned ON
<4>[ 4167.359568] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.359778] dhdsdio_readframes: Enter
<4>[ 4167.359944] RxHdr:
<4>[ 4167.360010]   0000: 20 00 df ff 86 00 00 0c 00 8f 00 00 
<4>[ 4167.360054] dhdsdio_read_control: Enter
<4>[ 4167.360085] RxCtrl:
<4>[ 4167.360123]   0000: 20 00 df ff 86 00 00 0c 00 8f 00 00 0c 00 00 00 
<4>[ 4167.360173]   0016: 04 00 00 00 00 00 7d 00 00 00 00 00 6c 00 00 00 
<4>[ 4167.360304] RxHdr:
<4>[ 4167.360362]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.360401] dhdsdio_readframes: processed 1 frames
<4>[ 4167.360436] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.360996] dhdcdc_cmplt: Enter
<4>[ 4167.361208] dhd_bus_rxctl: Enter
<4>[ 4167.361272] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4167.364342] dhd_watchdog_thread:
<4>[ 4167.364412] dhd_bus_watchdog: Enter
<4>[ 4167.364448] dhdsdio_clkctl: Enter
<4>[ 4167.364478] dhdsdio_htclk: Enter
<4>[ 4167.364581] CLKCTL: turned OFF
<4>[ 4167.364627] dhdsdio_sdclk: Enter
<4>[ 4167.364662] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.376921] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.376935]  dwrq->length:4096
<4>[ 4167.377038] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4167.377113] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.377160] dhd_prot_ioctl: Enter
<4>[ 4167.377192] dhdcdc_query_ioctl: Enter
<4>[ 4167.377223] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4167.377254] dhdcdc_msg: Enter
<4>[ 4167.377279] dhd_bus_txctl: Enter
<4>[ 4167.377309] dhdsdio_clkctl: Enter
<4>[ 4167.377338] dhdsdio_sdclk: Enter
<4>[ 4167.377363] dhdsdio_htclk: Enter
<4>[ 4167.377548] CLKCTL: turned ON
<4>[ 4167.377607] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.377642] Tx Frame:
<4>[ 4167.377682]   0000: 34 00 cb ff 83 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.377732]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4167.377780]   0032: 00 00 7e 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.377827]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.377964] dhdcdc_cmplt: Enter
<4>[ 4167.378124] dhdsdio_isr: Enter
<4>[ 4167.378178] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.378219] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.378254] dhdsdio_dpc: Enter
<4>[ 4167.378282] dhdsdio_clkctl: Enter
<4>[ 4167.378491] dhdsdio_readframes: Enter
<4>[ 4167.378634] RxHdr:
<4>[ 4167.378698]   0000: 28 00 d7 ff 87 00 00 0c 00 90 00 00 
<4>[ 4167.378738] dhdsdio_read_control: Enter
<4>[ 4167.378769] RxCtrl:
<4>[ 4167.378807]   0000: 28 00 d7 ff 87 00 00 0c 00 90 00 00 7f 00 00 00 
<4>[ 4167.378858]   0016: 0c 00 00 00 00 00 7e 00 00 00 00 00 d7 ff ff ff 
<4>[ 4167.378899]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4167.379021] RxHdr:
<4>[ 4167.379074]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.379113] dhdsdio_readframes: processed 1 frames
<4>[ 4167.379148] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.379230] dhd_bus_rxctl: Enter
<4>[ 4167.379280] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4167.379345] 
<4>[ 4167.379351] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4167.379419] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.379470] dhd_prot_ioctl: Enter
<4>[ 4167.379504] dhdcdc_query_ioctl: Enter
<4>[ 4167.379534] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4167.379563] dhdcdc_msg: Enter
<4>[ 4167.379586] dhd_bus_txctl: Enter
<4>[ 4167.379613] dhdsdio_clkctl: Enter
<4>[ 4167.379642] Tx Frame:
<4>[ 4167.379679]   0000: 4c 00 b3 ff 84 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.379729]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4167.379777]   0032: 00 00 7f 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4167.379825]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.379873]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 9d ee a9 48 
<4>[ 4167.379920]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.380245] dhdsdio_isr: Enter
<4>[ 4167.380301] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.380341] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.380377] dhdsdio_dpc: Enter
<4>[ 4167.380445] dhdsdio_clkctl: Enter
<4>[ 4167.380665] dhdsdio_readframes: Enter
<4>[ 4167.380830] RxHdr:
<4>[ 4167.380895]   0000: 40 00 bf ff 88 00 00 0c 00 91 00 00 
<4>[ 4167.380938] dhdsdio_read_control: Enter
<4>[ 4167.380971] RxCtrl:
<4>[ 4167.381008]   0000: 40 00 bf ff 88 00 00 0c 00 91 00 00 19 00 00 00 
<4>[ 4167.381059]   0016: 24 00 00 00 00 00 7f 00 00 00 00 00 05 00 00 00 
<4>[ 4167.381108]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.381156]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.381313] RxHdr:
<4>[ 4167.381374]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.381416] dhdsdio_readframes: processed 1 frames
<4>[ 4167.381450] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.381531] dhdcdc_cmplt: Enter
<4>[ 4167.381572] dhd_bus_rxctl: Enter
<4>[ 4167.381607] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4167.381663] wl_iw_get_rssi ssid_len:5, rssi:-41
<4>[ 4167.382558] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.382572]  dwrq->length:4096
<4>[ 4167.382680] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4167.382754] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.382800] dhd_prot_ioctl: Enter
<4>[ 4167.382832] dhdcdc_query_ioctl: Enter
<4>[ 4167.382863] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4167.382892] dhdcdc_msg: Enter
<4>[ 4167.382917] dhd_bus_txctl: Enter
<4>[ 4167.382945] dhdsdio_clkctl: Enter
<4>[ 4167.382976] Tx Frame:
<4>[ 4167.383014]   0000: 2c 00 d3 ff 85 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.383063]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4167.383112]   0032: 00 00 80 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4167.383159]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.383505] dhdsdio_isr: Enter
<4>[ 4167.383566] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.383608] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.383645] dhdsdio_dpc: Enter
<4>[ 4167.383715] dhdsdio_clkctl: Enter
<4>[ 4167.383942] dhdsdio_readframes: Enter
<4>[ 4167.384115] RxHdr:
<4>[ 4167.384180]   0000: 20 00 df ff 89 00 00 0c 00 92 00 00 
<4>[ 4167.384341] dhdsdio_read_control: Enter
<4>[ 4167.384396] RxCtrl:
<4>[ 4167.384442]   0000: 20 00 df ff 89 00 00 0c 00 92 00 00 0c 00 00 00 
<4>[ 4167.384494]   0016: 04 00 00 00 00 00 80 00 00 00 00 00 6c 00 00 00 
<4>[ 4167.384636] RxHdr:
<4>[ 4167.384694]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.384732] dhdsdio_readframes: processed 1 frames
<4>[ 4167.384768] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.384833] dhd_watchdog_thread:
<4>[ 4167.384872] dhd_bus_watchdog: Enter
<4>[ 4167.384904] dhdsdio_clkctl: Enter
<4>[ 4167.384934] dhdsdio_htclk: Enter
<4>[ 4167.385028] CLKCTL: turned OFF
<4>[ 4167.385073] dhdsdio_sdclk: Enter
<4>[ 4167.385108] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.385213] dhdcdc_cmplt: Enter
<4>[ 4167.385259] dhd_bus_rxctl: Enter
<4>[ 4167.385298] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4167.403336] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.403351]  dwrq->length:4096
<4>[ 4167.403453] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4167.403527] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.405874] dhd_prot_ioctl: Enter
<4>[ 4167.405943] dhdcdc_query_ioctl: Enter
<4>[ 4167.405982] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4167.406014] dhdcdc_msg: Enter
<4>[ 4167.406043] dhd_bus_txctl: Enter
<4>[ 4167.406073] dhdsdio_clkctl: Enter
<4>[ 4167.406100] dhdsdio_sdclk: Enter
<4>[ 4167.406125] dhdsdio_htclk: Enter
<4>[ 4167.406460] CLKCTL: turned ON
<4>[ 4167.406528] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.406564] Tx Frame:
<4>[ 4167.406606]   0000: 34 00 cb ff 86 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.406657]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4167.406706]   0032: 00 00 81 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.406753]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.406898] dhdcdc_cmplt: Enter
<4>[ 4167.407057] dhdsdio_isr: Enter
<4>[ 4167.407109] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.407149] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.407184] dhdsdio_dpc: Enter
<4>[ 4167.407213] dhdsdio_clkctl: Enter
<4>[ 4167.407421] dhdsdio_readframes: Enter
<4>[ 4167.407566] RxHdr:
<4>[ 4167.407625]   0000: 28 00 d7 ff 8a 00 00 0c 00 93 00 00 
<4>[ 4167.407667] dhdsdio_read_control: Enter
<4>[ 4167.407699] RxCtrl:
<4>[ 4167.407737]   0000: 28 00 d7 ff 8a 00 00 0c 00 93 00 00 7f 00 00 00 
<4>[ 4167.407786]   0016: 0c 00 00 00 00 00 81 00 00 00 00 00 d7 ff ff ff 
<4>[ 4167.407828]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4167.407950] RxHdr:
<4>[ 4167.408008]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.408048] dhdsdio_readframes: processed 1 frames
<4>[ 4167.408087] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.408169] dhd_bus_rxctl: Enter
<4>[ 4167.408213] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4167.408280] 
<4>[ 4167.408285] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4167.408354] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.408406] dhd_prot_ioctl: Enter
<4>[ 4167.408443] dhdcdc_query_ioctl: Enter
<4>[ 4167.408476] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4167.408506] dhdcdc_msg: Enter
<4>[ 4167.408530] dhd_bus_txctl: Enter
<4>[ 4167.408558] dhdsdio_clkctl: Enter
<4>[ 4167.408589] Tx Frame:
<4>[ 4167.408625]   0000: 4c 00 b3 ff 87 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.408674]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4167.408722]   0032: 00 00 82 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4167.408769]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.408816]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 9d ee a9 48 
<4>[ 4167.408862]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.409185] dhdsdio_isr: Enter
<4>[ 4167.409244] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.409283] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.409317] dhdsdio_dpc: Enter
<4>[ 4167.409385] dhdsdio_clkctl: Enter
<4>[ 4167.409607] dhdsdio_readframes: Enter
<4>[ 4167.409751] RxHdr:
<4>[ 4167.409808]   0000: 40 00 bf ff 8b 00 00 0c 00 94 00 00 
<4>[ 4167.409849] dhdsdio_read_control: Enter
<4>[ 4167.409880] RxCtrl:
<4>[ 4167.409917]   0000: 40 00 bf ff 8b 00 00 0c 00 94 00 00 19 00 00 00 
<4>[ 4167.409966]   0016: 24 00 00 00 00 00 82 00 00 00 00 00 05 00 00 00 
<4>[ 4167.410015]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.410062]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.410190] RxHdr:
<4>[ 4167.410246]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.410287] dhdsdio_readframes: processed 1 frames
<4>[ 4167.410324] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.410407] dhdcdc_cmplt: Enter
<4>[ 4167.410444] dhd_bus_rxctl: Enter
<4>[ 4167.410477] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4167.410535] wl_iw_get_rssi ssid_len:5, rssi:-41
<4>[ 4167.411209] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.411223]  dwrq->length:4096
<4>[ 4167.411330] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4167.411400] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.411447] dhd_prot_ioctl: Enter
<4>[ 4167.411479] dhdcdc_query_ioctl: Enter
<4>[ 4167.411508] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4167.411537] dhdcdc_msg: Enter
<4>[ 4167.411561] dhd_bus_txctl: Enter
<4>[ 4167.411591] dhdsdio_clkctl: Enter
<4>[ 4167.411623] Tx Frame:
<4>[ 4167.411663]   0000: 2c 00 d3 ff 88 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.411712]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4167.411762]   0032: 00 00 83 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4167.411810]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.424457] dhdsdio_isr: Enter
<4>[ 4167.424525] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.424568] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.424604] dhdsdio_dpc: Enter
<4>[ 4167.424680] dhd_watchdog_thread:
<4>[ 4167.424723] dhd_bus_watchdog: Enter
<4>[ 4167.424753] dhdsdio_clkctl: Enter
<4>[ 4167.424780] dhdsdio_htclk: Enter
<4>[ 4167.424882] CLKCTL: turned OFF
<4>[ 4167.424928] dhdsdio_sdclk: Enter
<4>[ 4167.424962] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.425015] dhdsdio_clkctl: Enter
<4>[ 4167.425053] dhdsdio_sdclk: Enter
<4>[ 4167.425078] dhdsdio_htclk: Enter
<4>[ 4167.425247] CLKCTL: turned ON
<4>[ 4167.425306] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.425517] dhdsdio_readframes: Enter
<4>[ 4167.425682] RxHdr:
<4>[ 4167.425744]   0000: 20 00 df ff 8c 00 00 0c 00 95 00 00 
<4>[ 4167.425785] dhdsdio_read_control: Enter
<4>[ 4167.425816] RxCtrl:
<4>[ 4167.425852]   0000: 20 00 df ff 8c 00 00 0c 00 95 00 00 0c 00 00 00 
<4>[ 4167.425902]   0016: 04 00 00 00 00 00 83 00 00 00 00 00 6c 00 00 00 
<4>[ 4167.426033] RxHdr:
<4>[ 4167.426090]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.426130] dhdsdio_readframes: processed 1 frames
<4>[ 4167.426166] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.426249] dhdcdc_cmplt: Enter
<4>[ 4167.426290] dhd_bus_rxctl: Enter
<4>[ 4167.426326] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4167.434355] dhd_watchdog_thread:
<4>[ 4167.434423] dhd_bus_watchdog: Enter
<4>[ 4167.434461] dhdsdio_clkctl: Enter
<4>[ 4167.434490] dhdsdio_htclk: Enter
<4>[ 4167.434594] CLKCTL: turned OFF
<4>[ 4167.434642] dhdsdio_sdclk: Enter
<4>[ 4167.434679] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.565028] dhd_start_xmit: Enter
<4>[ 4167.565113] dhd_prot_hdrpush: Enter
<4>[ 4167.565154] dhd_bus_txdata: Enter
<4>[ 4167.565187] dhd_bus_txdata: deferring pktq len 0
<4>[ 4167.565268] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4167.565317] dhdsdio_dpc: Enter
<4>[ 4167.565348] dhdsdio_clkctl: Enter
<4>[ 4167.565376] dhdsdio_sdclk: Enter
<4>[ 4167.565400] dhdsdio_htclk: Enter
<4>[ 4167.565569] CLKCTL: turned ON
<4>[ 4167.565627] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.565664] dhdsdio_sendfromq: Enter
<4>[ 4167.565700] dhdsdio_txpkt: Enter
<4>[ 4167.565730] Tx Frame:
<4>[ 4167.565773]   0000: 6a 01 95 fe 89 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4167.565823]   0016: 00 00 ff ff ff ff ff ff 00 26 37 82 86 b6 08 00 
<4>[ 4167.565872]   0032: 45 10 01 4a 00 00 40 00 40 11 39 94 00 00 00 00 
<4>[ 4167.565921]   0048: ff ff ff ff 00 44 00 43 01 36 9c ca 01 01 06 00 
<4>[ 4167.565969]   0064: c1 7d 2b 1e 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566017]   0080: 00 00 00 00 00 00 00 00 00 26 37 82 86 b6 00 00 
<4>[ 4167.566063]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566110]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566156]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566203]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566250]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566297]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566344]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566391]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566438]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566485]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566532]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566579]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.566627]   0288: 00 00 00 00 00 00 00 00 63 82 53 63 35 01 01 39 
<4>[ 4167.566675]   0304: 02 05 dc 3c 0d 64 68 63 70 63 64 20 34 2e 30 2e 
<4>[ 4167.566723]   0320: 31 35 0c 18 61 6e 64 72 6f 69 64 2d 65 32 30 33 
<4>[ 4167.566771]   0336: 38 63 33 65 33 63 33 39 64 36 63 62 37 0b 01 79 
<4>[ 4167.566814]   0352: 21 03 06 0f 1c 33 3a 3b 77 ff 
<4>[ 4167.567205] dhd_prot_hdrpull: Enter
<4>[ 4167.571448] dhdsdio_isr: Enter
<4>[ 4167.571516] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.571558] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.571600] dhdsdio_dpc: Enter
<4>[ 4167.571631] dhdsdio_clkctl: Enter
<4>[ 4167.571859] dhdsdio_readframes: Enter
<4>[ 4167.572035] RxHdr:
<4>[ 4167.572097]   0000: 68 01 97 fe 8d 02 00 0e 00 96 00 00 
<4>[ 4167.572477] Rx Data:
<4>[ 4167.572549]   0000: 68 01 97 fe 8d 02 00 0e 00 96 00 00 00 00 20 00 
<4>[ 4167.572609]   0016: 00 00 00 26 37 82 86 b6 00 1d 7e bd 45 a0 08 00 
<4>[ 4167.572664]   0032: 45 00 01 48 5c 34 00 00 40 11 99 a0 c0 a8 01 01 
<4>[ 4167.572715]   0048: c0 a8 01 7f 00 43 00 44 01 34 4a 62 02 01 06 00 
<4>[ 4167.572765]   0064: c1 7d 2b 1e 00 00 00 00 00 00 00 00 c0 a8 01 7f 
<4>[ 4167.572813]   0080: c0 a8 01 01 00 00 00 00 00 26 37 82 86 b6 00 00 
<4>[ 4167.572861]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.572909]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.572956]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573003]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573050]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573096]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573142]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573189]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573236]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573283]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573331]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573378]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.573425]   0288: 00 00 00 00 00 00 00 00 63 82 53 63 35 01 02 36 
<4>[ 4167.573474]   0304: 04 c0 a8 01 01 33 04 00 01 51 80 3a 04 00 00 a8 
<4>[ 4167.573521]   0320: c0 3b 04 00 01 27 50 01 04 ff ff ff 00 1c 04 c0 
<4>[ 4167.573569]   0336: a8 01 ff 06 04 c0 a8 01 01 0f 05 54 4f 4d 45 51 
<4>[ 4167.573610]   0352: 03 04 c0 a8 01 01 ff 00 
<4>[ 4167.573637] dhd_prot_hdrpull: Enter
<4>[ 4167.573665] dhd_rx_frame: Enter
<4>[ 4167.573934] RxHdr:
<4>[ 4167.574003]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.574046] dhdsdio_readframes: processed 1 frames
<4>[ 4167.574086] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.574332] dhd_watchdog_thread:
<4>[ 4167.574393] dhd_bus_watchdog: Enter
<4>[ 4167.574429] dhdsdio_clkctl: Enter
<4>[ 4167.574458] dhdsdio_htclk: Enter
<4>[ 4167.574557] CLKCTL: turned OFF
<4>[ 4167.574602] dhdsdio_sdclk: Enter
<4>[ 4167.574636] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.575250] dhd_start_xmit: Enter
<4>[ 4167.575330] dhd_prot_hdrpush: Enter
<4>[ 4167.575368] dhd_bus_txdata: Enter
<4>[ 4167.575401] dhd_bus_txdata: deferring pktq len 0
<4>[ 4167.575484] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4167.575533] dhdsdio_dpc: Enter
<4>[ 4167.575565] dhdsdio_clkctl: Enter
<4>[ 4167.575594] dhdsdio_sdclk: Enter
<4>[ 4167.575619] dhdsdio_htclk: Enter
<4>[ 4167.575786] CLKCTL: turned ON
<4>[ 4167.575845] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.575882] dhdsdio_sendfromq: Enter
<4>[ 4167.575917] dhdsdio_txpkt: Enter
<4>[ 4167.575947] Tx Frame:
<4>[ 4167.575987]   0000: 76 01 89 fe 8a 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4167.576037]   0016: 00 00 ff ff ff ff ff ff 00 26 37 82 86 b6 08 00 
<4>[ 4167.576085]   0032: 45 10 01 56 00 00 40 00 40 11 39 88 00 00 00 00 
<4>[ 4167.576132]   0048: ff ff ff ff 00 44 00 43 01 42 c0 c6 01 01 06 00 
<4>[ 4167.576179]   0064: c1 7d 2b 1e 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576226]   0080: 00 00 00 00 00 00 00 00 00 26 37 82 86 b6 00 00 
<4>[ 4167.576273]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576319]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576366]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576411]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576459]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576506]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576553]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576601]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576648]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576693]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576741]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576786]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.576835]   0288: 00 00 00 00 00 00 00 00 63 82 53 63 35 01 03 32 
<4>[ 4167.576883]   0304: 04 c0 a8 01 7f 36 04 c0 a8 01 01 39 02 05 dc 3c 
<4>[ 4167.576932]   0320: 0d 64 68 63 70 63 64 20 34 2e 30 2e 31 35 0c 18 
<4>[ 4167.576981]   0336: 61 6e 64 72 6f 69 64 2d 65 32 30 33 38 63 33 65 
<4>[ 4167.577029]   0352: 33 63 33 39 64 36 63 62 37 0b 01 79 21 03 06 0f 
<4>[ 4167.577070]   0368: 1c 33 3a 3b 77 ff 
<4>[ 4167.577446] dhd_prot_hdrpull: Enter
<4>[ 4167.581781] dhdsdio_isr: Enter
<4>[ 4167.581848] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.581890] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.581933] dhdsdio_dpc: Enter
<4>[ 4167.581967] dhdsdio_clkctl: Enter
<4>[ 4167.582189] dhdsdio_readframes: Enter
<4>[ 4167.582335] RxHdr:
<4>[ 4167.582394]   0000: 68 01 97 fe 8e 02 00 0e 00 97 00 00 
<4>[ 4167.582770] Rx Data:
<4>[ 4167.582841]   0000: 68 01 97 fe 8e 02 00 0e 00 97 00 00 00 00 20 00 
<4>[ 4167.582897]   0016: 00 00 00 26 37 82 86 b6 00 1d 7e bd 45 a0 08 00 
<4>[ 4167.582949]   0032: 45 00 01 48 5c 35 00 00 40 11 99 9f c0 a8 01 01 
<4>[ 4167.582999]   0048: c0 a8 01 7f 00 43 00 44 01 34 47 62 02 01 06 00 
<4>[ 4167.583049]   0064: c1 7d 2b 1e 00 00 00 00 00 00 00 00 c0 a8 01 7f 
<4>[ 4167.583097]   0080: c0 a8 01 01 00 00 00 00 00 26 37 82 86 b6 00 00 
<4>[ 4167.583144]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583190]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583237]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583284]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583330]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583377]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583424]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583470]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583517]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583563]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583610]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583657]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.583704]   0288: 00 00 00 00 00 00 00 00 63 82 53 63 35 01 05 36 
<4>[ 4167.583751]   0304: 04 c0 a8 01 01 33 04 00 01 51 80 3a 04 00 00 a8 
<4>[ 4167.583800]   0320: c0 3b 04 00 01 27 50 01 04 ff ff ff 00 1c 04 c0 
<4>[ 4167.583847]   0336: a8 01 ff 06 04 c0 a8 01 01 0f 05 54 4f 4d 45 51 
<4>[ 4167.583888]   0352: 03 04 c0 a8 01 01 ff 00 
<4>[ 4167.583916] dhd_prot_hdrpull: Enter
<4>[ 4167.583945] dhd_rx_frame: Enter
<4>[ 4167.584212] RxHdr:
<4>[ 4167.584396]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.584454] dhdsdio_readframes: processed 1 frames
<4>[ 4167.584494] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.584560] dhd_watchdog_thread:
<4>[ 4167.584597] dhd_bus_watchdog: Enter
<4>[ 4167.584628] dhdsdio_clkctl: Enter
<4>[ 4167.584656] dhdsdio_htclk: Enter
<4>[ 4167.584754] CLKCTL: turned OFF
<4>[ 4167.584800] dhdsdio_sdclk: Enter
<4>[ 4167.584836] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.585736] dhd_device_event: [eth0] Up IP: 0x7f01a8c0
<4>[ 4167.585810] dhdcdc_set_ioctl: Enter
<4>[ 4167.585850] dhdcdc_set_ioctl: cmd 263 len 17
<4>[ 4167.585882] dhdcdc_msg: Enter
<4>[ 4167.585914] dhd_bus_txctl: Enter
<4>[ 4167.585945] dhdsdio_clkctl: Enter
<4>[ 4167.585974] dhdsdio_sdclk: Enter
<4>[ 4167.586001] dhdsdio_htclk: Enter
<4>[ 4167.586262] CLKCTL: turned ON
<4>[ 4167.586326] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.586361] Tx Frame:
<4>[ 4167.586400]   0000: 39 00 c6 ff 8b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.586448]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 11 00 00 00 
<4>[ 4167.586497]   0032: 02 00 84 00 00 00 00 00 61 72 70 5f 68 6f 73 74 
<4>[ 4167.586545]   0048: 69 70 5f 63 6c 65 61 72 00 00 00 00 00 00 00 00 
<4>[ 4167.586696] dhdcdc_cmplt: Enter
<4>[ 4167.586747] dhd_bus_rxctl: Enter
<4>[ 4167.586944] dhdsdio_isr: Enter
<4>[ 4167.586997] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.587034] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.587076] dhdsdio_dpc: Enter
<4>[ 4167.587106] dhdsdio_clkctl: Enter
<4>[ 4167.587324] dhdsdio_readframes: Enter
<4>[ 4167.587497] RxHdr:
<4>[ 4167.587561]   0000: 2d 00 d2 ff 8f 00 00 0c 00 98 00 00 
<4>[ 4167.587602] dhdsdio_read_control: Enter
<4>[ 4167.587634] RxCtrl:
<4>[ 4167.587675]   0000: 2d 00 d2 ff 8f 00 00 0c 00 98 00 00 07 01 00 00 
<4>[ 4167.587726]   0016: 11 00 00 00 00 00 84 00 00 00 00 00 61 72 70 5f 
<4>[ 4167.587772]   0032: 68 6f 73 74 69 70 5f 63 6c 65 61 72 00 
<4>[ 4167.587911] RxHdr:
<4>[ 4167.587967]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.588009] dhdsdio_readframes: processed 1 frames
<4>[ 4167.588045] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.588146] dhd_bus_rxctl: resumed on rxctl frame, got 33 expected 33
<4>[ 4167.588208] dhdcdc_set_ioctl: Enter
<4>[ 4167.588240] dhdcdc_set_ioctl: cmd 263 len 16
<4>[ 4167.588270] dhdcdc_msg: Enter
<4>[ 4167.588301] dhd_bus_txctl: Enter
<4>[ 4167.588330] dhdsdio_clkctl: Enter
<4>[ 4167.588361] Tx Frame:
<4>[ 4167.588402]   0000: 38 00 c7 ff 8c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.588451]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 10 00 00 00 
<4>[ 4167.588500]   0032: 02 00 85 00 00 00 00 00 61 72 70 5f 74 61 62 6c 
<4>[ 4167.588548]   0048: 65 5f 63 6c 65 61 72 00 00 00 00 00 00 00 00 00 
<4>[ 4167.589468] dhdsdio_isr: Enter
<4>[ 4167.589535] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.589579] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.589617] dhdsdio_dpc: Enter
<4>[ 4167.589949] dhdsdio_clkctl: Enter
<4>[ 4167.590215] dhdsdio_readframes: Enter
<4>[ 4167.590393] RxHdr:
<4>[ 4167.590455]   0000: 2c 00 d3 ff 90 00 00 0c 00 99 00 00 
<4>[ 4167.590496] dhdsdio_read_control: Enter
<4>[ 4167.590528] RxCtrl:
<4>[ 4167.590565]   0000: 2c 00 d3 ff 90 00 00 0c 00 99 00 00 07 01 00 00 
<4>[ 4167.590615]   0016: 10 00 00 00 00 00 85 00 00 00 00 00 61 72 70 5f 
<4>[ 4167.590659]   0032: 74 61 62 6c 65 5f 63 6c 65 61 72 00 
<4>[ 4167.590788] RxHdr:
<4>[ 4167.590844]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.590886] dhdsdio_readframes: processed 1 frames
<4>[ 4167.590922] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.591099] dhdcdc_cmplt: Enter
<4>[ 4167.591151] dhd_bus_rxctl: Enter
<4>[ 4167.591192] dhd_bus_rxctl: resumed on rxctl frame, got 32 expected 32
<4>[ 4167.594336] dhd_watchdog_thread:
<4>[ 4167.594408] dhd_bus_watchdog: Enter
<4>[ 4167.594446] dhdsdio_clkctl: Enter
<4>[ 4167.594476] dhdsdio_htclk: Enter
<4>[ 4167.594578] CLKCTL: turned OFF
<4>[ 4167.594626] dhdsdio_sdclk: Enter
<4>[ 4167.594660] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.922808] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.922823]  dwrq->length:4096
<4>[ 4167.922926] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4167.923502] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.923574] dhd_prot_ioctl: Enter
<4>[ 4167.923614] dhdcdc_query_ioctl: Enter
<4>[ 4167.923648] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4167.923679] dhdcdc_msg: Enter
<4>[ 4167.923705] dhd_bus_txctl: Enter
<4>[ 4167.923735] dhdsdio_clkctl: Enter
<4>[ 4167.923761] dhdsdio_sdclk: Enter
<4>[ 4167.923788] dhdsdio_htclk: Enter
<4>[ 4167.923977] CLKCTL: turned ON
<4>[ 4167.924036] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.924072] Tx Frame:
<4>[ 4167.924114]   0000: 34 00 cb ff 8d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.924163]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4167.924211]   0032: 00 00 86 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.924423]   0048: 00 00 00 00 65 61 72 00 00 00 00 00 00 00 00 00 
<4>[ 4167.924706] dhdsdio_isr: Enter
<4>[ 4167.924764] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.924805] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.924840] dhdsdio_dpc: Enter
<4>[ 4167.924908] dhd_watchdog_thread:
<4>[ 4167.924953] dhd_bus_watchdog: Enter
<4>[ 4167.924984] dhdsdio_clkctl: Enter
<4>[ 4167.925012] dhdsdio_htclk: Enter
<4>[ 4167.925110] CLKCTL: turned OFF
<4>[ 4167.925159] dhdsdio_sdclk: Enter
<4>[ 4167.925192] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.925244] dhdsdio_clkctl: Enter
<4>[ 4167.925280] dhdsdio_sdclk: Enter
<4>[ 4167.925309] dhdsdio_htclk: Enter
<4>[ 4167.925460] CLKCTL: turned ON
<4>[ 4167.925516] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.925725] dhdsdio_readframes: Enter
<4>[ 4167.925872] RxHdr:
<4>[ 4167.925933]   0000: 28 00 d7 ff 91 00 00 0c 00 9a 00 00 
<4>[ 4167.925974] dhdsdio_read_control: Enter
<4>[ 4167.926005] RxCtrl:
<4>[ 4167.926041]   0000: 28 00 d7 ff 91 00 00 0c 00 9a 00 00 7f 00 00 00 
<4>[ 4167.926092]   0016: 0c 00 00 00 00 00 86 00 00 00 00 00 d8 ff ff ff 
<4>[ 4167.926134]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4167.926283] RxHdr:
<4>[ 4167.926342]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.926381] dhdsdio_readframes: processed 1 frames
<4>[ 4167.926416] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.926498] dhdcdc_cmplt: Enter
<4>[ 4167.926536] dhd_bus_rxctl: Enter
<4>[ 4167.926572] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4167.926636] 
<4>[ 4167.926642] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4167.926712] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.926756] dhd_prot_ioctl: Enter
<4>[ 4167.926786] dhdcdc_query_ioctl: Enter
<4>[ 4167.926818] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4167.926849] dhdcdc_msg: Enter
<4>[ 4167.926873] dhd_bus_txctl: Enter
<4>[ 4167.926899] dhdsdio_clkctl: Enter
<4>[ 4167.926928] Tx Frame:
<4>[ 4167.926966]   0000: 4c 00 b3 ff 8e 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.927015]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4167.927064]   0032: 00 00 87 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4167.927112]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.927160]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 9d ee a9 48 
<4>[ 4167.927207]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.927534] dhdsdio_isr: Enter
<4>[ 4167.927592] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.927634] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.927668] dhdsdio_dpc: Enter
<4>[ 4167.927734] dhdsdio_clkctl: Enter
<4>[ 4167.927978] dhdsdio_readframes: Enter
<4>[ 4167.928143] RxHdr:
<4>[ 4167.928205]   0000: 40 00 bf ff 92 00 00 0c 00 9b 00 00 
<4>[ 4167.928247] dhdsdio_read_control: Enter
<4>[ 4167.928277] RxCtrl:
<4>[ 4167.928313]   0000: 40 00 bf ff 92 00 00 0c 00 9b 00 00 19 00 00 00 
<4>[ 4167.928361]   0016: 24 00 00 00 00 00 87 00 00 00 00 00 05 00 00 00 
<4>[ 4167.928409]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.928456]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.928589] RxHdr:
<4>[ 4167.928643]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.928684] dhdsdio_readframes: processed 1 frames
<4>[ 4167.928721] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.928805] dhdcdc_cmplt: Enter
<4>[ 4167.928845] dhd_bus_rxctl: Enter
<4>[ 4167.928885] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4167.928944] wl_iw_get_rssi ssid_len:5, rssi:-40
<4>[ 4167.934366] dhd_watchdog_thread:
<4>[ 4167.934433] dhd_bus_watchdog: Enter
<4>[ 4167.934469] dhdsdio_clkctl: Enter
<4>[ 4167.934497] dhdsdio_htclk: Enter
<4>[ 4167.934602] CLKCTL: turned OFF
<4>[ 4167.934650] dhdsdio_sdclk: Enter
<4>[ 4167.934686] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.935317] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.935333]  dwrq->length:4096
<4>[ 4167.935441] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4167.935510] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.935558] dhd_prot_ioctl: Enter
<4>[ 4167.935592] dhdcdc_query_ioctl: Enter
<4>[ 4167.935622] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4167.935652] dhdcdc_msg: Enter
<4>[ 4167.935676] dhd_bus_txctl: Enter
<4>[ 4167.935703] dhdsdio_clkctl: Enter
<4>[ 4167.935729] dhdsdio_sdclk: Enter
<4>[ 4167.935755] dhdsdio_htclk: Enter
<4>[ 4167.936007] CLKCTL: turned ON
<4>[ 4167.936073] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.936111] Tx Frame:
<4>[ 4167.936153]   0000: 2c 00 d3 ff 8f 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.936204]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4167.936254]   0032: 00 00 88 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4167.936303]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.936444] dhdcdc_cmplt: Enter
<4>[ 4167.936492] dhd_bus_rxctl: Enter
<4>[ 4167.936635] dhdsdio_isr: Enter
<4>[ 4167.936684] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.936723] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.936759] dhdsdio_dpc: Enter
<4>[ 4167.936787] dhdsdio_clkctl: Enter
<4>[ 4167.936993] dhdsdio_readframes: Enter
<4>[ 4167.937159] RxHdr:
<4>[ 4167.937221]   0000: 20 00 df ff 93 00 00 0c 00 9c 00 00 
<4>[ 4167.937263] dhdsdio_read_control: Enter
<4>[ 4167.937294] RxCtrl:
<4>[ 4167.937333]   0000: 20 00 df ff 93 00 00 0c 00 9c 00 00 0c 00 00 00 
<4>[ 4167.937383]   0016: 04 00 00 00 00 00 88 00 00 00 00 00 6c 00 00 00 
<4>[ 4167.937541] RxHdr:
<4>[ 4167.937597]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.937637] dhdsdio_readframes: processed 1 frames
<4>[ 4167.937673] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.937763] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4167.944358] dhd_watchdog_thread:
<4>[ 4167.944429] dhd_bus_watchdog: Enter
<4>[ 4167.944469] dhdsdio_clkctl: Enter
<4>[ 4167.944499] dhdsdio_htclk: Enter
<4>[ 4167.944621] CLKCTL: turned OFF
<4>[ 4167.944673] dhdsdio_sdclk: Enter
<4>[ 4167.944713] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.945436] eth0: SIOCSIWPRIV request SCAN-ACTIVE, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.945452]  dwrq->length:4096eth0: active scan setting suppressed
<4>[ 4167.954943] eth0: SIOCSIWPRIV request CSCAN S, info->cmd:8b0c, info-
>flags:0
<4>[ 4167.954958]  dwrq->length:20
<4>[ 4167.955070] ### wl_iw_set_cscan: info->cmd:8b0c, info->flags:0, 
u.data=0xbebee974, u.len=20
<4>[ 4167.955139] BROADCAST SCAN  left=8
<4>[ 4167.955168] nssid=1 left_parse=8 67
<4>[ 4167.955199] End channel=1 left_parse=6 80
<4>[ 4167.955235] wl_iw_combined_scan_set nssid=1 nchan=1
<4>[ 4167.955278] 
<4>[ 4167.955282] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297b48, len:28 ,
<4>[ 4167.955345] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.955390] dhd_prot_ioctl: Enter
<4>[ 4167.955422] dhdcdc_query_ioctl: Enter
<4>[ 4167.955453] dhdcdc_query_ioctl: cmd 262 len 28
<4>[ 4167.955483] dhdcdc_msg: Enter
<4>[ 4167.955508] dhd_bus_txctl: Enter
<4>[ 4167.955536] dhdsdio_clkctl: Enter
<4>[ 4167.955563] dhdsdio_sdclk: Enter
<4>[ 4167.955588] dhdsdio_htclk: Enter
<4>[ 4167.964367] CLKCTL: turned ON
<4>[ 4167.964445] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.964483] Tx Frame:
<4>[ 4167.964526]   0000: 44 00 bb ff 90 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.964579]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 1c 00 00 00 
<4>[ 4167.964629]   0032: 00 00 89 00 00 00 00 00 65 76 65 6e 74 5f 6d 73 
<4>[ 4167.964678]   0048: 67 73 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.964726]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 9d ee a9 48 
<4>[ 4167.964775]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.965228] dhdsdio_isr: Enter
<4>[ 4167.965290] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.965333] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.965372] dhdsdio_dpc: Enter
<4>[ 4167.965443] dhdsdio_clkctl: Enter
<4>[ 4167.965669] dhdsdio_readframes: Enter
<4>[ 4167.965841] RxHdr:
<4>[ 4167.965905]   0000: 38 00 c7 ff 94 00 00 0c 00 9d 00 00 
<4>[ 4167.965947] dhdsdio_read_control: Enter
<4>[ 4167.965978] RxCtrl:
<4>[ 4167.966016]   0000: 38 00 c7 ff 94 00 00 0c 00 9d 00 00 06 01 00 00 
<4>[ 4167.966065]   0016: 1c 00 00 00 00 00 89 00 00 00 00 00 4b 1f b7 04 
<4>[ 4167.966113]   0032: 10 40 40 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.966153]   0048: 00 00 00 00 00 00 00 00 
<4>[ 4167.966277] RxHdr:
<4>[ 4167.966332]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.966371] dhdsdio_readframes: processed 1 frames
<4>[ 4167.966406] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.966488] dhdcdc_cmplt: Enter
<4>[ 4167.966526] dhd_bus_rxctl: Enter
<4>[ 4167.966561] dhd_bus_rxctl: resumed on rxctl frame, got 44 expected 44
<4>[ 4167.966627] 
<4>[ 4167.966633] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297b48, len:27 ,
<4>[ 4167.966701] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.966748] dhd_prot_ioctl: Enter
<4>[ 4167.966779] dhdcdc_query_ioctl: Enter
<4>[ 4167.966807] dhdcdc_query_ioctl: cmd 263 len 27
<4>[ 4167.966837] dhdcdc_msg: Enter
<4>[ 4167.966860] dhd_bus_txctl: Enter
<4>[ 4167.966888] dhdsdio_clkctl: Enter
<4>[ 4167.966919] Tx Frame:
<4>[ 4167.966958]   0000: 43 00 bc ff 91 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.967007]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 1b 00 00 00 
<4>[ 4167.967055]   0032: 00 00 8a 00 00 00 00 00 65 76 65 6e 74 5f 6d 73 
<4>[ 4167.967103]   0048: 67 73 00 4b 1f b7 04 10 40 40 00 00 00 00 00 00 
<4>[ 4167.967150]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 9d ee a9 48 
<4>[ 4167.967198]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.967640] dhdsdio_isr: Enter
<4>[ 4167.967701] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.967743] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.967779] dhdsdio_dpc: Enter
<4>[ 4167.967846] dhdsdio_clkctl: Enter
<4>[ 4167.968064] dhdsdio_readframes: Enter
<4>[ 4167.968230] RxHdr:
<4>[ 4167.968294]   0000: 37 00 c8 ff 95 00 00 0c 00 9e 00 00 
<4>[ 4167.968337] dhdsdio_read_control: Enter
<4>[ 4167.968369] RxCtrl:
<4>[ 4167.968407]   0000: 37 00 c8 ff 95 00 00 0c 00 9e 00 00 07 01 00 00 
<4>[ 4167.968455]   0016: 1b 00 00 00 00 00 8a 00 00 00 00 00 65 76 65 6e 
<4>[ 4167.968505]   0032: 74 5f 6d 73 67 73 00 4b 1f b7 04 10 40 40 00 00 
<4>[ 4167.968544]   0048: 00 00 00 00 00 00 00 
<4>[ 4167.968668] RxHdr:
<4>[ 4167.968722]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.968760] dhdsdio_readframes: processed 1 frames
<4>[ 4167.968796] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.968881] dhdcdc_cmplt: Enter
<4>[ 4167.968918] dhd_bus_rxctl: Enter
<4>[ 4167.968954] dhd_bus_rxctl: resumed on rxctl frame, got 43 expected 43
<4>[ 4167.969095] 
<4>[ 4167.969100] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2264854, len:154 ,
<4>[ 4167.969171] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4167.969217] dhd_prot_ioctl: Enter
<4>[ 4167.969248] dhdcdc_query_ioctl: Enter
<4>[ 4167.969277] dhdcdc_query_ioctl: cmd 263 len 154
<4>[ 4167.969307] dhdcdc_msg: Enter
<4>[ 4167.969331] dhd_bus_txctl: Enter
<4>[ 4167.969359] dhdsdio_clkctl: Enter
<4>[ 4167.969390] Tx Frame:
<4>[ 4167.969429]   0000: c2 00 3d ff 92 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4167.969478]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 9a 00 00 00 
<4>[ 4167.969526]   0032: 00 00 8b 00 00 00 00 00 69 73 63 61 6e 00 01 00 
<4>[ 4167.969574]   0048: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.969622]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.969671]   0080: 00 00 00 00 00 00 00 00 00 00 ff ff ff ff ff ff 
<4>[ 4167.969720]   0096: 02 00 ff ff ff ff ff ff ff ff 82 00 00 00 82 00 
<4>[ 4167.969767]   0112: 00 00 01 00 01 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.969815]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.969862]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.969909]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.969955]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.970002]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 32 04 
<4>[ 4167.970050]   0208: 0c 12 18 60 dd 09 00 10 18 02 00 13 00 00 00 dd 
<4>[ 4167.974935] dhd_watchdog_thread:
<4>[ 4167.975002] dhd_bus_watchdog: Enter
<4>[ 4167.975038] dhdsdio_clkctl: Enter
<4>[ 4167.975067] dhdsdio_htclk: Enter
<4>[ 4167.975173] CLKCTL: turned OFF
<4>[ 4167.975219] dhdsdio_sdclk: Enter
<4>[ 4167.975257] dhdsdio_clkctl: 3 -> 0
<4>[ 4167.975314] dhdcdc_cmplt: Enter
<4>[ 4167.975351] dhd_bus_rxctl: Enter
<4>[ 4167.975490] dhdsdio_isr: Enter
<4>[ 4167.975540] dhdsdio_isr: disable SDIO interrupts
<4>[ 4167.975577] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4167.975612] dhdsdio_dpc: Enter
<4>[ 4167.975640] dhdsdio_clkctl: Enter
<4>[ 4167.975668] dhdsdio_sdclk: Enter
<4>[ 4167.975693] dhdsdio_htclk: Enter
<4>[ 4167.975862] CLKCTL: turned ON
<4>[ 4167.975917] dhdsdio_clkctl: 0 -> 3
<4>[ 4167.976120] dhdsdio_readframes: Enter
<4>[ 4167.976264] RxHdr:
<4>[ 4167.976323]   0000: b6 00 49 ff 96 00 00 0c 00 9f 00 00 
<4>[ 4167.976365] dhdsdio_read_control: Enter
<4>[ 4167.976558] RxCtrl:
<4>[ 4167.976626]   0000: b6 00 49 ff 96 00 00 0c 00 9f 00 00 07 01 00 00 
<4>[ 4167.976682]   0016: 9a 00 00 00 00 00 8b 00 00 00 00 00 69 73 63 61 
<4>[ 4167.976733]   0032: 6e 00 01 00 00 00 01 00 00 00 00 00 00 00 00 00 
<4>[ 4167.976781]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.976830]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff ff 
<4>[ 4167.976877]   0080: ff ff ff ff 02 00 ff ff ff ff ff ff ff ff 82 00 
<4>[ 4167.976925]   0096: 00 00 82 00 00 00 01 00 00 2b 00 00 00 00 00 00 
<4>[ 4167.976972]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.977019]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.977066]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.977113]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.977152]   0176: 00 00 00 00 00 00 
<4>[ 4167.977275] RxHdr:
<4>[ 4167.977328]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4167.977368] dhdsdio_readframes: processed 1 frames
<4>[ 4167.977404] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4167.977497] dhd_bus_rxctl: resumed on rxctl frame, got 170 expected 170
<4>[ 4167.977765] eth0: SIOCSIWPRIV request SCAN-PASSIVE, info->cmd:8b0c, 
info->flags:0
<4>[ 4167.977779]  dwrq->length:4096eth0: passive scan setting suppressed
<4>[ 4167.984351] dhd_watchdog_thread:
<4>[ 4167.984420] dhd_bus_watchdog: Enter
<4>[ 4167.984458] dhdsdio_clkctl: Enter
<4>[ 4167.984487] dhdsdio_htclk: Enter
<4>[ 4167.984588] CLKCTL: turned OFF
<4>[ 4167.984635] dhdsdio_sdclk: Enter
<4>[ 4167.984671] dhdsdio_clkctl: 3 -> 0
<4>[ 4169.024365] dhd_start_xmit: Enter
<4>[ 4169.024446] dhd_prot_hdrpush: Enter
<4>[ 4169.024487] dhd_bus_txdata: Enter
<4>[ 4169.024520] dhd_bus_txdata: deferring pktq len 0
<4>[ 4169.024613] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4169.024662] dhdsdio_dpc: Enter
<4>[ 4169.024694] dhdsdio_clkctl: Enter
<4>[ 4169.024723] dhdsdio_sdclk: Enter
<4>[ 4169.024750] dhdsdio_htclk: Enter
<4>[ 4169.024908] CLKCTL: turned ON
<4>[ 4169.024966] dhdsdio_clkctl: 0 -> 3
<4>[ 4169.025004] dhdsdio_sendfromq: Enter
<4>[ 4169.025037] dhdsdio_txpkt: Enter
<4>[ 4169.025068] Tx Frame:
<4>[ 4169.025108]   0000: 58 00 a7 ff 93 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4169.025156]   0016: 00 00 33 33 00 00 00 02 00 26 37 82 86 b6 86 dd 
<4>[ 4169.025204]   0032: 60 00 00 00 00 10 3a ff fe 80 00 00 00 00 00 00 
<4>[ 4169.025252]   0048: 02 26 37 ff fe 82 86 b6 ff 02 00 00 00 00 00 00 
<4>[ 4169.025299]   0064: 00 00 00 00 00 00 00 02 85 00 fe 70 00 00 00 00 
<4>[ 4169.025340]   0080: 01 01 00 26 37 82 86 b6 
<4>[ 4169.025520] dhd_prot_hdrpull: Enter
<4>[ 4169.034318] dhd_watchdog_thread:
<4>[ 4169.034372] dhd_bus_watchdog: Enter
<4>[ 4169.034406] dhdsdio_clkctl: Enter
<4>[ 4169.034434] dhdsdio_htclk: Enter
<4>[ 4169.034530] CLKCTL: turned OFF
<4>[ 4169.034573] dhdsdio_sdclk: Enter
<4>[ 4169.034607] dhdsdio_clkctl: 3 -> 0
<4>[ 4169.204379] dhd_start_xmit: Enter
<4>[ 4169.204463] dhd_prot_hdrpush: Enter
<4>[ 4169.204504] dhd_bus_txdata: Enter
<4>[ 4169.204534] dhd_bus_txdata: deferring pktq len 0
<4>[ 4169.204623] Calling dhdsdio_dpc() from dhd_bus_dpc
<4>[ 4169.204675] dhdsdio_dpc: Enter
<4>[ 4169.204707] dhdsdio_clkctl: Enter
<4>[ 4169.204736] dhdsdio_sdclk: Enter
<4>[ 4169.204763] dhdsdio_htclk: Enter
<4>[ 4169.204927] CLKCTL: turned ON
<4>[ 4169.204981] dhdsdio_clkctl: 0 -> 3
<4>[ 4169.205017] dhdsdio_sendfromq: Enter
<4>[ 4169.205049] dhdsdio_txpkt: Enter
<4>[ 4169.205078] Tx Frame:
<4>[ 4169.205118]   0000: 6c 00 93 ff 94 02 00 0e 00 00 00 00 00 00 20 00 
<4>[ 4169.205168]   0016: 00 00 33 33 00 00 00 16 00 26 37 82 86 b6 86 dd 
<4>[ 4169.205216]   0032: 60 00 00 00 00 24 00 01 fe 80 00 00 00 00 00 00 
<4>[ 4169.205263]   0048: 02 26 37 ff fe 82 86 b6 ff 02 00 00 00 00 00 00 
<4>[ 4169.205312]   0064: 00 00 00 00 00 00 00 16 3a 00 05 02 00 00 01 00 
<4>[ 4169.205359]   0080: 8f 00 2a 72 00 00 00 01 04 00 00 00 ff 02 00 00 
<4>[ 4169.205404]   0096: 00 00 00 00 00 00 00 01 ff 82 86 b6 
<4>[ 4169.205610] dhd_prot_hdrpull: Enter
<4>[ 4169.214317] dhd_watchdog_thread:
<4>[ 4169.214376] dhd_bus_watchdog: Enter
<4>[ 4169.214410] dhdsdio_clkctl: Enter
<4>[ 4169.214437] dhdsdio_htclk: Enter
<4>[ 4169.214535] CLKCTL: turned OFF
<4>[ 4169.214579] dhdsdio_sdclk: Enter
<4>[ 4169.214615] dhdsdio_clkctl: 3 -> 0
<4>[ 4169.267040] eth0: SIOCSIWPRIV request POWERMODE 0, info->cmd:8b0c, info-
>flags:0
<4>[ 4169.267054]  dwrq->length:4096wl_iw_set_power_mode: DHCP session 
cmd:POWERMODE 0
<4>[ 4169.267207] 
<4>[ 4169.267213] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x56, 
buf:bf26c5b0, len:4 ,
<4>[ 4169.267283] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4169.267332] dhd_prot_ioctl: Enter
<4>[ 4169.267366] dhdcdc_query_ioctl: Enter
<4>[ 4169.267396] dhdcdc_query_ioctl: cmd 86 len 4
<4>[ 4169.267425] dhdcdc_msg: Enter
<4>[ 4169.267450] dhd_bus_txctl: Enter
<4>[ 4169.267479] dhdsdio_clkctl: Enter
<4>[ 4169.267505] dhdsdio_sdclk: Enter
<4>[ 4169.267530] dhdsdio_htclk: Enter
<4>[ 4169.267777] CLKCTL: turned ON
<4>[ 4169.267844] dhdsdio_clkctl: 0 -> 3
<4>[ 4169.267879] Tx Frame:
<4>[ 4169.267920]   0000: 2c 00 d3 ff 95 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4169.267969]   0016: 00 00 00 00 00 00 00 00 56 00 00 00 04 00 00 00 
<4>[ 4169.268017]   0032: 00 00 8c 00 00 00 00 00 02 00 00 00 6e 00 01 00 
<4>[ 4169.268065]   0048: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.268206] dhdcdc_cmplt: Enter
<4>[ 4169.268255] dhd_bus_rxctl: Enter
<4>[ 4169.268435] dhdsdio_isr: Enter
<4>[ 4169.268488] dhdsdio_isr: disable SDIO interrupts
<4>[ 4169.268525] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4169.268558] dhdsdio_dpc: Enter
<4>[ 4169.268585] dhdsdio_clkctl: Enter
<4>[ 4169.268792] dhdsdio_readframes: Enter
<4>[ 4169.268957] RxHdr:
<4>[ 4169.269018]   0000: 20 00 df ff 97 00 00 0c 00 a2 00 00 
<4>[ 4169.269060] dhdsdio_read_control: Enter
<4>[ 4169.269093] RxCtrl:
<4>[ 4169.269130]   0000: 20 00 df ff 97 00 00 0c 00 a2 00 00 56 00 00 00 
<4>[ 4169.269178]   0016: 04 00 00 00 00 00 8c 00 00 00 00 00 02 00 00 00 
<4>[ 4169.269318] RxHdr:
<4>[ 4169.269375]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.269416] dhdsdio_readframes: processed 1 frames
<4>[ 4169.269453] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4169.269544] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4169.270261] eth0: SIOCSIWPRIV request BTCOEXMODE 2, info->cmd:8b0c, 
info->flags:0
<4>[ 4169.270276]  dwrq->length:4096wl_iw_set_priv:got Framwrork cmd: 
'BTCOEXMODE'
<4>[ 4169.270406] wl_iw_set_btcoex_dhcp disable BT DHCP Timer
<4>[ 4169.274346] dhd_watchdog_thread:
<4>[ 4169.274414] dhd_bus_watchdog: Enter
<4>[ 4169.274452] dhdsdio_clkctl: Enter
<4>[ 4169.274480] dhdsdio_htclk: Enter
<4>[ 4169.274583] CLKCTL: turned OFF
<4>[ 4169.274628] dhdsdio_sdclk: Enter
<4>[ 4169.274663] dhdsdio_clkctl: 3 -> 0
<4>[ 4169.292322] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4169.292336]  dwrq->length:4096
<4>[ 4169.292436] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4169.292508] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4169.292556] dhd_prot_ioctl: Enter
<4>[ 4169.292588] dhdcdc_query_ioctl: Enter
<4>[ 4169.292619] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4169.292649] dhdcdc_msg: Enter
<4>[ 4169.292673] dhd_bus_txctl: Enter
<4>[ 4169.292702] dhdsdio_clkctl: Enter
<4>[ 4169.292728] dhdsdio_sdclk: Enter
<4>[ 4169.292753] dhdsdio_htclk: Enter
<4>[ 4169.292937] CLKCTL: turned ON
<4>[ 4169.292998] dhdsdio_clkctl: 0 -> 3
<4>[ 4169.293033] Tx Frame:
<4>[ 4169.293074]   0000: 34 00 cb ff 96 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4169.293125]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4169.293174]   0032: 00 00 8d 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.293220]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.293360] dhdcdc_cmplt: Enter
<4>[ 4169.293515] dhdsdio_isr: Enter
<4>[ 4169.293568] dhdsdio_isr: disable SDIO interrupts
<4>[ 4169.293606] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4169.293642] dhdsdio_dpc: Enter
<4>[ 4169.293670] dhdsdio_clkctl: Enter
<4>[ 4169.293881] dhdsdio_readframes: Enter
<4>[ 4169.294051] RxHdr:
<4>[ 4169.294111]   0000: 28 00 d7 ff 98 00 00 0c 00 a3 00 00 
<4>[ 4169.294152] dhdsdio_read_control: Enter
<4>[ 4169.294183] RxCtrl:
<4>[ 4169.294343]   0000: 28 00 d7 ff 98 00 00 0c 00 a3 00 00 7f 00 00 00 
<4>[ 4169.294419]   0016: 0c 00 00 00 00 00 8d 00 00 00 00 00 d7 ff ff ff 
<4>[ 4169.294466]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4169.294599] RxHdr:
<4>[ 4169.294664]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.294705] dhdsdio_readframes: processed 1 frames
<4>[ 4169.294742] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4169.294814] dhd_watchdog_thread:
<4>[ 4169.294854] dhd_bus_watchdog: Enter
<4>[ 4169.294886] dhdsdio_clkctl: Enter
<4>[ 4169.294913] dhdsdio_htclk: Enter
<4>[ 4169.295009] CLKCTL: turned OFF
<4>[ 4169.295055] dhdsdio_sdclk: Enter
<4>[ 4169.295088] dhdsdio_clkctl: 3 -> 0
<4>[ 4169.295185] dhd_bus_rxctl: Enter
<4>[ 4169.295236] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4169.295305] 
<4>[ 4169.295311] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4169.295379] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4169.295423] dhd_prot_ioctl: Enter
<4>[ 4169.295455] dhdcdc_query_ioctl: Enter
<4>[ 4169.295482] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4169.295511] dhdcdc_msg: Enter
<4>[ 4169.295534] dhd_bus_txctl: Enter
<4>[ 4169.295561] dhdsdio_clkctl: Enter
<4>[ 4169.295585] dhdsdio_sdclk: Enter
<4>[ 4169.295609] dhdsdio_htclk: Enter
<4>[ 4169.303672] CLKCTL: turned ON
<4>[ 4169.303748] dhdsdio_clkctl: 0 -> 3
<4>[ 4169.303788] Tx Frame:
<4>[ 4169.303832]   0000: 4c 00 b3 ff 97 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4169.303884]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4169.303932]   0032: 00 00 8e 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4169.303979]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.304027]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.304074]   0080: 00 00 00 00 00 00 00 00 00 00 ff ff ff ff ff ff 
<4>[ 4169.304478] dhdsdio_isr: Enter
<4>[ 4169.304538] dhdsdio_isr: disable SDIO interrupts
<4>[ 4169.304579] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4169.304616] dhdsdio_dpc: Enter
<4>[ 4169.304687] dhd_watchdog_thread:
<4>[ 4169.304728] dhd_bus_watchdog: Enter
<4>[ 4169.304756] dhdsdio_clkctl: Enter
<4>[ 4169.304783] dhdsdio_htclk: Enter
<4>[ 4169.304897] CLKCTL: turned OFF
<4>[ 4169.304945] dhdsdio_sdclk: Enter
<4>[ 4169.304983] dhdsdio_clkctl: 3 -> 0
<4>[ 4169.305035] dhdsdio_clkctl: Enter
<4>[ 4169.305073] dhdsdio_sdclk: Enter
<4>[ 4169.305098] dhdsdio_htclk: Enter
<4>[ 4169.305272] CLKCTL: turned ON
<4>[ 4169.305327] dhdsdio_clkctl: 0 -> 3
<4>[ 4169.305537] dhdsdio_readframes: Enter
<4>[ 4169.305680] RxHdr:
<4>[ 4169.305740]   0000: 40 00 bf ff 99 00 00 0c 00 a4 00 00 
<4>[ 4169.305781] dhdsdio_read_control: Enter
<4>[ 4169.305813] RxCtrl:
<4>[ 4169.305849]   0000: 40 00 bf ff 99 00 00 0c 00 a4 00 00 19 00 00 00 
<4>[ 4169.305897]   0016: 24 00 00 00 00 00 8e 00 00 00 00 00 05 00 00 00 
<4>[ 4169.305946]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.305994]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.306149] RxHdr:
<4>[ 4169.306206]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.306248] dhdsdio_readframes: processed 1 frames
<4>[ 4169.306284] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4169.306366] dhdcdc_cmplt: Enter
<4>[ 4169.306408] dhd_bus_rxctl: Enter
<4>[ 4169.306445] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4169.306504] wl_iw_get_rssi ssid_len:5, rssi:-41
<4>[ 4169.314355] dhd_watchdog_thread:
<4>[ 4169.314425] dhd_bus_watchdog: Enter
<4>[ 4169.314463] dhdsdio_clkctl: Enter
<4>[ 4169.314493] dhdsdio_htclk: Enter
<4>[ 4169.314599] CLKCTL: turned OFF
<4>[ 4169.314648] dhdsdio_sdclk: Enter
<4>[ 4169.314685] dhdsdio_clkctl: 3 -> 0
<4>[ 4169.318954] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4169.318969]  dwrq->length:4096
<4>[ 4169.319077] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4169.319149] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4169.319197] dhd_prot_ioctl: Enter
<4>[ 4169.319229] dhdcdc_query_ioctl: Enter
<4>[ 4169.319257] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4169.319288] dhdcdc_msg: Enter
<4>[ 4169.319312] dhd_bus_txctl: Enter
<4>[ 4169.319339] dhdsdio_clkctl: Enter
<4>[ 4169.319364] dhdsdio_sdclk: Enter
<4>[ 4169.319389] dhdsdio_htclk: Enter
<4>[ 4169.319644] CLKCTL: turned ON
<4>[ 4169.319709] dhdsdio_clkctl: 0 -> 3
<4>[ 4169.319746] Tx Frame:
<4>[ 4169.319788]   0000: 2c 00 d3 ff 98 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4169.319841]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4169.319892]   0032: 00 00 8f 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4169.319940]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.320082] dhdcdc_cmplt: Enter
<4>[ 4169.320131] dhd_bus_rxctl: Enter
<4>[ 4169.321327] dhdsdio_isr: Enter
<4>[ 4169.321394] dhdsdio_isr: disable SDIO interrupts
<4>[ 4169.321437] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4169.321474] dhdsdio_dpc: Enter
<4>[ 4169.321501] dhdsdio_clkctl: Enter
<4>[ 4169.321715] dhdsdio_readframes: Enter
<4>[ 4169.321861] RxHdr:
<4>[ 4169.321922]   0000: 20 00 df ff 9a 00 00 0c 00 a5 00 00 
<4>[ 4169.321964] dhdsdio_read_control: Enter
<4>[ 4169.321997] RxCtrl:
<4>[ 4169.322035]   0000: 20 00 df ff 9a 00 00 0c 00 a5 00 00 0c 00 00 00 
<4>[ 4169.322083]   0016: 04 00 00 00 00 00 8f 00 00 00 00 00 6c 00 00 00 
<4>[ 4169.322225] RxHdr:
<4>[ 4169.322280]   0000: 5c 00 a3 ff 9b 01 00 0e 00 a5 00 00 
<4>[ 4169.322447] Rx Data:
<4>[ 4169.322513]   0000: 5c 00 a3 ff 9b 01 00 0e 00 a5 00 00 00 00 20 00 
<4>[ 4169.322568]   0016: 00 00 00 26 37 82 86 b6 02 26 37 82 86 b6 88 6c 
<4>[ 4169.322619]   0032: 80 01 00 68 00 00 10 18 00 01 00 02 00 00 00 00 
<4>[ 4169.322667]   0048: 00 1a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.322716]   0064: 00 00 48 01 2c 00 00 1d 77 6c 30 00 00 00 00 00 
<4>[ 4169.322759]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.322790] dhd_prot_hdrpull: Enter
<4>[ 4169.322819] dhd_rx_frame: Enter
<4>[ 4169.322856] dhd_ifname2idx: return idx 0 for "wl0"
<4>[ 4169.322893] wl_host_event: MAC event 26, flags 0, status 0
<4>[ 4169.322941] EVENT: SCAN_COMPLETE, event ID = 26
<4>[ 4169.322972] MACEVENT: SCAN_COMPLETE
<4>[ 4169.323006] wl_iw_event: dev=eth0 event=26 
<4>[ 4169.323182] RxHdr:
<4>[ 4169.323246]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.323289] dhdsdio_readframes: processed 2 frames
<4>[ 4169.323327] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 2
<4>[ 4169.323456] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4169.324338] dhd_watchdog_thread:
<4>[ 4169.324407] dhd_bus_watchdog: Enter
<4>[ 4169.324444] dhdsdio_clkctl: Enter
<4>[ 4169.324474] dhdsdio_htclk: Enter
<4>[ 4169.324577] CLKCTL: turned OFF
<4>[ 4169.324624] dhdsdio_sdclk: Enter
<4>[ 4169.324659] dhdsdio_clkctl: 3 -> 0
<4>[ 4169.327272] 
<4>[ 4169.327281] dev_wlc_ioctl, PID:9ed: send Local IOCTL -> dhd: cmd:0x106, 
buf:c9064004, len:2048 ,
<4>[ 4169.327384] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4169.327442] dhd_prot_ioctl: Enter
<4>[ 4169.327477] dhdcdc_query_ioctl: Enter
<4>[ 4169.327508] dhdcdc_query_ioctl: cmd 262 len 2048
<4>[ 4169.327551] dhdcdc_msg: Enter
<4>[ 4169.327579] dhd_bus_txctl: Enter
<4>[ 4169.327608] dhdsdio_clkctl: Enter
<4>[ 4169.327634] dhdsdio_sdclk: Enter
<4>[ 4169.327660] dhdsdio_htclk: Enter
<4>[ 4169.328198] CLKCTL: turned ON
<4>[ 4169.328271] dhdsdio_clkctl: 0 -> 3
<4>[ 4169.328309] Tx Frame:
<4>[ 4169.328350]   0000: 06 06 f9 f9 99 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4169.328401]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 00 08 00 00 
<4>[ 4169.328451]   0032: 00 00 90 00 00 00 00 00 69 73 63 61 6e 72 65 73 
<4>[ 4169.328499]   0048: 75 6c 74 73 00 00 00 00 00 00 08 00 00 00 00 00 
<4>[ 4169.328547]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.328595]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.328641]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.328689]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.328736]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.328783]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.328831]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.328877]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.328924]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.328971]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329018]   0224: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329066]   0240: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329114]   0256: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329162]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329209]   0288: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329256]   0304: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329303]   0320: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329350]   0336: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329396]   0352: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329443]   0368: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329489]   0384: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329535]   0400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329582]   0416: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329628]   0432: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329675]   0448: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329722]   0464: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329769]   0480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329816]   0496: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329862]   0512: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329909]   0528: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.329956]   0544: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330002]   0560: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330048]   0576: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330095]   0592: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330142]   0608: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330191]   0624: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330238]   0640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330284]   0656: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330331]   0672: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330378]   0688: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330425]   0704: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330471]   0720: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330519]   0736: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330565]   0752: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330612]   0768: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330659]   0784: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330706]   0800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330755]   0816: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330803]   0832: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330852]   0848: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330900]   0864: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330946]   0880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.330992]   0896: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331040]   0912: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331087]   0928: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331133]   0944: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331180]   0960: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331227]   0976: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331273]   0992: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331319]   1008: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331366]   1024: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331413]   1040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331460]   1056: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331507]   1072: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331554]   1088: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331601]   1104: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331648]   1120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331695]   1136: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331741]   1152: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331788]   1168: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331835]   1184: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331881]   1200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331928]   1216: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.331975]   1232: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332022]   1248: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332068]   1264: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332116]   1280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332162]   1296: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332210]   1312: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332257]   1328: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332304]   1344: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332351]   1360: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332398]   1376: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332444]   1392: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332491]   1408: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332537]   1424: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332584]   1440: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332631]   1456: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332677]   1472: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332725]   1488: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332772]   1504: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332819]   1520: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332866]   1536: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332913]   1552: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.332959]   1568: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333005]   1584: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333052]   1600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333098]   1616: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333145]   1632: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333191]   1648: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333238]   1664: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333285]   1680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333333]   1696: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333382]   1712: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333430]   1728: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333479]   1744: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333526]   1760: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333573]   1776: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333620]   1792: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333668]   1808: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333714]   1824: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333761]   1840: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333808]   1856: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333856]   1872: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333902]   1888: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333949]   1904: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.333996]   1920: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.334043]   1936: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.334090]   1952: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.334136]   1968: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.334184]   1984: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.359593]   2000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.359679]   2016: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.359737]   2032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4169.360467] dhd_watchdog_thread:
<4>[ 4169.360554] dhd_bus_watchdog: Enter
<4>[ 4169.360598] dhdsdio_clkctl: Enter
<4>[ 4169.360630] dhdsdio_htclk: Enter
<4>[ 4169.360753] CLKCTL: turned OFF
<4>[ 4169.360803] dhdsdio_sdclk: Enter
<4>[ 4169.360838] dhdsdio_clkctl: 3 -> 0
<4>[ 4169.361257] dhdcdc_cmplt: Enter
<4>[ 4169.361321] dhd_bus_rxctl: Enter
<7>[ 4170.024296] eth0: no IPv6 routers present
<4>[ 4172.354402] dhd_bus_rxctl: resumed on timeout
<4>[ 4172.354518] dhdsdio_checkdied: Enter
<4>[ 4172.354874] dhdsdio_membytes: read 4 bytes at offset 0x00007ffc in 
window 0x00058000
<4>[ 4172.355244] dhdsdio_isr: Enter
<4>[ 4172.355331] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.355419] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.355502] dhdsdio_dpc: Enter
<4>[ 4172.355901] sdpcm_shared address 0x00035BAC
<4>[ 4172.356283] dhdsdio_membytes: read 28 bytes at offset 0x00005bac in 
window 0x00030000
<4>[ 4172.356901] dhdsdio_clkctl: Enter
<4>[ 4172.356988] dhdsdio_sdclk: Enter
<4>[ 4172.357056] dhdsdio_htclk: Enter
<4>[ 4172.357292] CLKCTL: turned ON
<4>[ 4172.357383] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.357666] dhdsdio_readframes: Enter
<4>[ 4172.357866] RxHdr:
<4>[ 4172.357974]   0000: 1c 08 e3 f7 9c 00 00 0c 00 a6 00 00 
<4>[ 4172.358066] dhdsdio_read_control: Enter
<4>[ 4172.358251] dhd_ioctl_entry: Event HANG send up
<4>[ 4172.358438] RxCtrl:
<4>[ 4172.358554]   0000: 1c 08 e3 f7 9c 00 00 0c 00 a6 00 00 06 01 00 00 
<4>[ 4172.358694]   0016: 00 08 00 00 00 00 90 00 00 00 00 00 00 00 00 00 
<4>[ 4172.358832]   0032: bc 07 00 00 6c 00 00 00 07 00 00 00 6c 00 00 00 
<4>[ 4172.358970]   0048: c4 00 00 00 00 1d 7e bd 45 a2 64 00 11 04 05 74 
<4>[ 4172.359104]   0064: 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.359234]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.359369]   0096: 0c 00 00 00 82 84 8b 96 24 30 48 6c 0c 12 18 60 
<4>[ 4172.359502]   0112: 00 00 00 00 02 2b 00 00 00 00 d8 ff a4 00 00 00 
<4>[ 4172.359633]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 
<4>[ 4172.359763]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.359897]   0160: 7c 00 00 00 45 00 00 00 00 05 74 6f 6d 33 71 01 
<4>[ 4172.360033]   0176: 08 82 84 8b 96 24 30 48 6c 03 01 02 2a 01 00 2f 
<4>[ 4172.360167]   0192: 01 00 32 04 0c 12 18 60 dd 09 00 10 18 02 01 f1 
<4>[ 4172.360300]   0208: 00 00 00 dd 18 00 50 f2 01 01 00 00 50 f2 02 01 
<4>[ 4172.360433]   0224: 00 00 50 f2 02 01 00 00 50 f2 02 00 00 00 00 00 
<4>[ 4172.360567]   0240: 6c 00 00 00 cc 00 00 00 00 24 b2 86 f0 7c 64 00 
<4>[ 4172.360702]   0256: 01 04 0d 68 65 72 6f 6c 64 6f 77 21 21 21 21 21 
<4>[ 4172.360833]   0272: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.360967]   0288: 00 00 00 00 0c 00 00 00 82 84 8b 96 24 30 48 6c 
<4>[ 4172.361101]   0304: 0c 12 18 60 00 00 00 00 01 2b 00 00 00 00 bf ff 
<4>[ 4172.361234]   0320: a4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.361365]   0336: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.361498]   0352: 00 00 00 00 7c 00 00 00 4d 00 00 00 00 0d 68 65 
<4>[ 4172.361633]   0368: 72 6f 6c 64 6f 77 21 21 21 21 21 01 08 82 84 8b 
<4>[ 4172.361767]   0384: 96 24 30 48 6c 03 01 01 2a 01 00 2f 01 00 32 04 
<4>[ 4172.361901]   0400: 0c 12 18 60 dd 09 00 10 18 02 00 f0 00 00 00 dd 
<4>[ 4172.362035]   0416: 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 
<4>[ 4172.362168]   0432: 00 42 43 5e 00 62 32 2f 00 00 00 00 6c 00 00 00 
<4>[ 4172.362302]   0448: a4 00 00 00 00 1a 70 a2 7c 84 64 00 11 04 08 4f 
<4>[ 4172.362435]   0464: 72 73 6f 6e 44 6f 6d 00 00 00 00 00 00 00 00 00 
<4>[ 4172.362566]   0480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.362702]   0496: 0c 00 00 00 82 84 8b 96 0c 12 18 24 30 48 60 6c 
<4>[ 4172.362835]   0512: 00 00 00 00 06 2b 00 00 00 00 b0 ff a4 00 00 00 
<4>[ 4172.362967]   0528: 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 
<4>[ 4172.363099]   0544: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.363233]   0560: 7c 00 00 00 28 00 00 00 00 08 4f 72 73 6f 6e 44 
<4>[ 4172.363367]   0576: 6f 6d 01 04 82 84 8b 96 03 01 06 04 06 00 02 00 
<4>[ 4172.363501]   0592: 00 00 00 2a 01 00 32 08 0c 12 18 24 30 48 60 6c 
<4>[ 4172.363635]   0608: 6c 00 00 00 d8 01 00 00 68 7f 74 7d a4 3c 64 00 
<4>[ 4172.363768]   0624: 31 05 07 6c 69 6e 6b 73 79 73 00 00 00 00 00 00 
<4>[ 4172.363899]   0640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.364032]   0656: 00 00 00 00 0c 00 00 00 82 84 8b 96 0c 12 18 24 
<4>[ 4172.364165]   0672: 30 48 60 6c 00 00 00 00 06 2b 00 00 00 00 a5 ff 
<4>[ 4172.364443]   0688: a4 01 00 00 00 00 00 00 06 00 00 00 00 00 00 00 
<4>[ 4172.364596]   0704: 04 00 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.364735]   0720: 00 00 00 00 7c 00 00 00 5a 01 00 00 00 07 6c 69 
<4>[ 4172.364873]   0736: 6e 6b 73 79 73 01 08 82 84 8b 96 0c 12 18 24 03 
<4>[ 4172.365008]   0752: 01 06 20 01 00 30 18 01 00 00 0f ac 02 02 00 00 
<4>[ 4172.365142]   0768: 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 01 00 dd 
<4>[ 4172.365276]   0784: 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 
<4>[ 4172.365410]   0800: 02 00 50 f2 04 01 00 00 50 f2 02 2a 01 00 32 04 
<4>[ 4172.365543]   0816: 30 48 60 6c dd 18 00 50 f2 02 01 01 02 00 03 a4 
<4>[ 4172.365677]   0832: 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 2d 1a 
<4>[ 4172.365809]   0848: 4c 10 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.365941]   0864: 00 00 00 00 00 00 00 00 00 00 3d 16 06 00 19 00 
<4>[ 4172.366072]   0880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.366205]   0896: 00 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 
<4>[ 4172.366338]   0912: 03 7f 04 01 00 20 00 00 00 07 06 47 42 20 01 0d 
<4>[ 4172.366473]   0928: 14 dd 93 00 50 f2 04 10 4a 00 01 10 10 44 00 01 
<4>[ 4172.366607]   0944: 02 10 41 00 01 00 10 3b 00 01 03 10 47 00 10 00 
<4>[ 4172.366741]   0960: 00 00 00 00 00 00 01 10 00 68 7f 74 7d a4 3c 10 
<4>[ 4172.366876]   0976: 21 00 13 4c 69 6e 6b 73 79 73 20 43 6f 72 70 6f 
<4>[ 4172.367012]   0992: 72 61 74 69 6f 6e 10 23 00 07 57 52 54 31 32 30 
<4>[ 4172.367146]   1008: 4e 10 24 00 07 76 31 2e 30 2e 30 31 10 42 00 0c 
<4>[ 4172.367282]   1024: 4a 55 54 30 30 4b 34 42 35 35 36 33 10 54 00 08 
<4>[ 4172.367416]   1040: 00 06 00 50 f2 04 00 01 10 11 00 14 57 69 72 65 
<4>[ 4172.367552]   1056: 6c 65 73 73 20 52 6f 75 74 65 72 28 57 46 41 29 
<4>[ 4172.367685]   1072: 10 08 00 02 00 84 00 00 6c 00 00 00 7c 01 00 00 
<4>[ 4172.367820]   1088: 00 26 5a b3 95 c8 64 00 31 0c 06 6f 6d 2d 6e 65 
<4>[ 4172.367951]   1104: 74 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.368083]   1120: 00 00 00 00 00 00 00 00 00 00 00 00 0c 00 00 00 
<4>[ 4172.368218]   1136: 82 84 8b 96 12 24 48 6c 0c 18 30 60 00 00 00 00 
<4>[ 4172.368352]   1152: 0b 2b 00 00 00 00 ab ff a4 00 00 00 00 00 00 00 
<4>[ 4172.368484]   1168: 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 
<4>[ 4172.368618]   1184: 00 00 00 00 00 00 00 00 00 00 00 00 7c 00 00 00 
<4>[ 4172.368753]   1200: fd 00 00 00 00 06 6f 6d 2d 6e 65 74 01 08 82 84 
<4>[ 4172.368889]   1216: 8b 96 12 24 48 6c 03 01 0b 2a 01 00 32 04 0c 18 
<4>[ 4172.369023]   1232: 30 60 dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 
<4>[ 4172.369159]   1248: 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 30 18 
<4>[ 4172.369292]   1264: 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 
<4>[ 4172.369426]   1280: 01 00 00 0f ac 02 00 00 dd 18 00 50 f2 02 01 01 
<4>[ 4172.369560]   1296: 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 
<4>[ 4172.369693]   1312: 2f 00 dd 07 00 0c 43 07 00 00 00 07 06 47 42 20 
<4>[ 4172.369828]   1328: 01 0d 10 dd 05 00 50 f2 05 00 dd 75 00 50 f2 04 
<4>[ 4172.369963]   1344: 10 4a 00 01 10 10 44 00 01 02 10 41 00 01 00 10 
<4>[ 4172.370098]   1360: 3b 00 01 03 10 47 00 10 ab 38 72 1d 52 f9 7b 7a 
<4>[ 4172.370233]   1376: 8e a6 00 26 5a b3 95 c8 10 21 00 06 44 2d 4c 69 
<4>[ 4172.370369]   1392: 6e 6b 10 23 00 07 44 49 52 2d 33 30 30 10 24 00 
<4>[ 4172.370504]   1408: 07 44 49 52 2d 33 30 30 10 42 00 08 30 30 30 30 
<4>[ 4172.370639]   1424: 30 30 30 30 10 54 00 08 00 06 00 50 f2 04 00 01 
<4>[ 4172.370774]   1440: 10 11 00 07 44 49 52 2d 33 30 30 10 08 00 02 00 
<4>[ 4172.370908]   1456: 86 00 00 00 6c 00 00 00 60 01 00 00 e0 91 f5 7d 
<4>[ 4172.371043]   1472: b5 f6 64 00 11 04 07 4e 45 54 47 45 41 52 00 00 
<4>[ 4172.371175]   1488: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.371307]   1504: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 0b 16 
<4>[ 4172.371441]   1520: 24 30 48 6c 0c 12 18 60 00 00 00 00 0b 2b 00 00 
<4>[ 4172.371573]   1536: 00 00 b3 ff a4 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.371705]   1552: 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.371837]   1568: 00 00 00 00 00 00 00 00 7c 00 00 00 e2 00 00 00 
<4>[ 4172.371972]   1584: 00 07 4e 45 54 47 45 41 52 01 08 82 84 0b 16 24 
<4>[ 4172.372107]   1600: 30 48 6c 03 01 0b 2a 01 02 2f 01 02 32 04 0c 12 
<4>[ 4172.372241]   1616: 18 60 dd 7f 00 50 f2 04 10 4a 00 01 10 10 44 00 
<4>[ 4172.372375]   1632: 01 02 10 41 00 01 00 10 3b 00 01 03 10 47 00 10 
<4>[ 4172.372511]   1648: a5 15 32 26 2b 0c 87 4d 71 1b 25 c1 b3 2e 9a 6b 
<4>[ 4172.372645]   1664: 10 21 00 0d 4e 45 54 47 45 41 52 2c 20 49 6e 63 
<4>[ 4172.372780]   1680: 2e 10 23 00 09 57 4e 52 31 30 30 30 76 33 10 24 
<4>[ 4172.372915]   1696: 00 09 57 4e 52 31 30 30 30 76 33 10 42 00 05 38 
<4>[ 4172.373049]   1712: 33 32 35 38 10 54 00 08 00 06 00 50 f2 04 00 01 
<4>[ 4172.373184]   1728: 10 11 00 09 57 4e 52 31 30 30 30 76 33 10 08 00 
<4>[ 4172.373317]   1744: 02 00 84 dd 09 00 10 18 02 00 f0 05 00 00 dd 18 
<4>[ 4172.373451]   1760: 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 
<4>[ 4172.373585]   1776: 01 00 00 50 f2 02 0c 00 dd 18 00 50 f2 02 01 01 
<4>[ 4172.373718]   1792: 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 
<4>[ 4172.373852]   1808: 2f 00 00 00 6c 00 00 00 c8 00 00 00 00 16 b6 ac 
<4>[ 4172.373987]   1824: f4 d4 64 00 11 04 0d 6b 6f 6c 2d 6c 69 6e 6b 73 
<4>[ 4172.374120]   1840: 79 73 20 47 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.374330]   1856: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 96 
<4>[ 4172.374481]   1872: 24 30 48 6c 0c 12 18 60 00 00 00 00 0b 2b 00 00 
<4>[ 4172.374617]   1888: 00 00 a7 ff a4 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.374750]   1904: 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.374883]   1920: 00 00 00 00 00 00 00 00 7c 00 00 00 4a 00 00 00 
<4>[ 4172.375018]   1936: 00 0d 6b 6f 6c 2d 6c 69 6e 6b 73 79 73 20 47 01 
<4>[ 4172.375153]   1952: 08 82 84 8b 96 24 30 48 6c 03 01 0b 2a 01 04 2f 
<4>[ 4172.375288]   1968: 01 04 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 
<4>[ 4172.375421]   1984: 00 0f ac 02 01 00 00 0f ac 02 00 00 32 04 0c 12 
<4>[ 4172.375554]   2000: 18 60 dd 06 00 10 18 02 00 14 00 00 00 00 00 00 
<4>[ 4172.375685]   2016: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.375816]   2032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.375949]   2048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.376072]   2064: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.376284] RxHdr:
<4>[ 4172.376389]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.376482] dhdsdio_readframes: processed 1 frames
<4>[ 4172.376568] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.376702] dhd_watchdog_thread:
<4>[ 4172.376775] dhd_bus_watchdog: Enter
<4>[ 4172.376845] dhdsdio_clkctl: Enter
<4>[ 4172.376910] dhdsdio_htclk: Enter
<4>[ 4172.377051] CLKCTL: turned OFF
<4>[ 4172.377130] dhdsdio_sdclk: Enter
<4>[ 4172.377202] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.377436] Send IWEVCUSTOM Event as HANG
<4>[ 4172.377567] wl_iw_iscan_get returns error -22
<4>[ 4172.386084] iscanresults can't alloc memory: skip
<4>[ 4172.397921] eth0: SIOCSIWPRIV request RSSI, info->cmd:8b0c, info-
>flags:0
<4>[ 4172.397949]  dwrq->length:4096
<4>[ 4172.398130] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x7f, 
buf:c2297d3c, len:12 ,
<4>[ 4172.398291] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.398384] dhd_prot_ioctl: Enter
<4>[ 4172.398453] dhdcdc_query_ioctl: Enter
<4>[ 4172.398525] dhdcdc_query_ioctl: cmd 127 len 12
<4>[ 4172.398599] dhdcdc_msg: Enter
<4>[ 4172.398658] dhd_bus_txctl: Enter
<4>[ 4172.398723] dhdsdio_clkctl: Enter
<4>[ 4172.398786] dhdsdio_sdclk: Enter
<4>[ 4172.398847] dhdsdio_htclk: Enter
<4>[ 4172.401894] dhdsdio_isr: Enter
<4>[ 4172.401994] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.402083] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.402166] dhdsdio_dpc: Enter
<4>[ 4172.404501] CLKCTL: turned ON
<4>[ 4172.404609] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.404683] Tx Frame:
<4>[ 4172.404781]   0000: 34 00 cb ff 9a 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.404914]   0016: 00 00 00 00 00 00 00 00 7f 00 00 00 0c 00 00 00 
<4>[ 4172.405045]   0032: 00 00 91 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.405176]   0048: 00 00 00 00 00 00 00 00 00 00 08 00 00 00 00 00 
<4>[ 4172.405443] dhdsdio_clkctl: Enter
<4>[ 4172.405722] Dongle reports CHIPACTIVE
<4>[ 4172.405817] dhdsdio_readframes: Enter
<4>[ 4172.405997] RxHdr:
<4>[ 4172.406101]   0000: 28 00 d7 ff 9d 00 00 0c 00 a7 00 00 
<4>[ 4172.406191] dhdsdio_read_control: Enter
<4>[ 4172.406262] RxCtrl:
<4>[ 4172.406353]   0000: 28 00 d7 ff 9d 00 00 0c 00 a7 00 00 7f 00 00 00 
<4>[ 4172.406488]   0016: 0c 00 00 00 00 00 91 00 00 00 00 00 d8 ff ff ff 
<4>[ 4172.406601]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4172.406781] RxHdr:
<4>[ 4172.406884]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.406976] dhdsdio_readframes: processed 1 frames
<4>[ 4172.407062] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.407212] dhdcdc_cmplt: Enter
<4>[ 4172.407288] dhd_bus_rxctl: Enter
<4>[ 4172.407364] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4172.407495] 
<4>[ 4172.407507] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x19, 
buf:bf26f30c, len:36 ,
<4>[ 4172.407672] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.407764] dhd_prot_ioctl: Enter
<4>[ 4172.407830] dhdcdc_query_ioctl: Enter
<4>[ 4172.407901] dhdcdc_query_ioctl: cmd 25 len 36
<4>[ 4172.407975] dhdcdc_msg: Enter
<4>[ 4172.408033] dhd_bus_txctl: Enter
<4>[ 4172.408096] dhdsdio_clkctl: Enter
<4>[ 4172.408162] Tx Frame:
<4>[ 4172.408258]   0000: 4c 00 b3 ff 9b 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.408391]   0016: 00 00 00 00 00 00 00 00 19 00 00 00 24 00 00 00 
<4>[ 4172.408524]   0032: 00 00 92 00 00 00 00 00 05 00 00 00 74 6f 6d 33 
<4>[ 4172.408723]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.408872]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.409008]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.414603] dhdsdio_isr: Enter
<4>[ 4172.414704] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.414792] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.414877] dhdsdio_dpc: Enter
<4>[ 4172.414988] dhd_watchdog_thread:
<4>[ 4172.415065] dhd_bus_watchdog: Enter
<4>[ 4172.415136] dhdsdio_clkctl: Enter
<4>[ 4172.415201] dhdsdio_htclk: Enter
<4>[ 4172.415347] CLKCTL: turned OFF
<4>[ 4172.415428] dhdsdio_sdclk: Enter
<4>[ 4172.415500] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.415596] dhdsdio_clkctl: Enter
<4>[ 4172.415669] dhdsdio_sdclk: Enter
<4>[ 4172.415734] dhdsdio_htclk: Enter
<4>[ 4172.415952] CLKCTL: turned ON
<4>[ 4172.416043] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.416329] dhdsdio_readframes: Enter
<4>[ 4172.416557] RxHdr:
<4>[ 4172.416665]   0000: 40 00 bf ff 9e 00 00 0c 00 a8 00 00 
<4>[ 4172.416757] dhdsdio_read_control: Enter
<4>[ 4172.416829] RxCtrl:
<4>[ 4172.416923]   0000: 40 00 bf ff 9e 00 00 0c 00 a8 00 00 19 00 00 00 
<4>[ 4172.417057]   0016: 24 00 00 00 00 00 92 00 00 00 00 00 05 00 00 00 
<4>[ 4172.417191]   0032: 74 6f 6d 33 71 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.417323]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.417530] RxHdr:
<4>[ 4172.417636]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.417728] dhdsdio_readframes: processed 1 frames
<4>[ 4172.417812] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.417963] dhdcdc_cmplt: Enter
<4>[ 4172.418041] dhd_bus_rxctl: Enter
<4>[ 4172.418117] dhd_bus_rxctl: resumed on rxctl frame, got 52 expected 52
<4>[ 4172.418238] wl_iw_get_rssi ssid_len:5, rssi:-40
<4>[ 4172.419063] eth0: SIOCSIWPRIV request LINKSPEED, info->cmd:8b0c, info-
>flags:0
<4>[ 4172.419094]  dwrq->length:4096
<4>[ 4172.419289] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc, 
buf:bf26f0c0, len:4 ,
<4>[ 4172.419447] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.419540] dhd_prot_ioctl: Enter
<4>[ 4172.419607] dhdcdc_query_ioctl: Enter
<4>[ 4172.419680] dhdcdc_query_ioctl: cmd 12 len 4
<4>[ 4172.419752] dhdcdc_msg: Enter
<4>[ 4172.419812] dhd_bus_txctl: Enter
<4>[ 4172.419876] dhdsdio_clkctl: Enter
<4>[ 4172.419944] Tx Frame:
<4>[ 4172.420039]   0000: 2c 00 d3 ff 9c 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.420171]   0016: 00 00 00 00 00 00 00 00 0c 00 00 00 04 00 00 00 
<4>[ 4172.420305]   0032: 00 00 93 00 00 00 00 00 80 f9 37 03 74 6f 6d 33 
<4>[ 4172.420436]   0048: 71 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.424427] dhdsdio_isr: Enter
<4>[ 4172.424527] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.424616] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.424700] dhdsdio_dpc: Enter
<4>[ 4172.424821] dhd_watchdog_thread:
<4>[ 4172.424901] dhd_bus_watchdog: Enter
<4>[ 4172.424971] dhdsdio_clkctl: Enter
<4>[ 4172.425036] dhdsdio_htclk: Enter
<4>[ 4172.425184] CLKCTL: turned OFF
<4>[ 4172.425265] dhdsdio_sdclk: Enter
<4>[ 4172.425336] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.425432] dhdsdio_clkctl: Enter
<4>[ 4172.425507] dhdsdio_sdclk: Enter
<4>[ 4172.425571] dhdsdio_htclk: Enter
<4>[ 4172.425789] CLKCTL: turned ON
<4>[ 4172.425878] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.426135] dhdsdio_readframes: Enter
<4>[ 4172.426330] RxHdr:
<4>[ 4172.426437]   0000: 20 00 df ff 9f 00 00 0c 00 a9 00 00 
<4>[ 4172.426527] dhdsdio_read_control: Enter
<4>[ 4172.426597] RxCtrl:
<4>[ 4172.426690]   0000: 20 00 df ff 9f 00 00 0c 00 a9 00 00 0c 00 00 00 
<4>[ 4172.426824]   0016: 04 00 00 00 00 00 93 00 00 00 00 00 6c 00 00 00 
<4>[ 4172.427029] RxHdr:
<4>[ 4172.427133]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.427226] dhdsdio_readframes: processed 1 frames
<4>[ 4172.427311] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.427461] dhdcdc_cmplt: Enter
<4>[ 4172.427537] dhd_bus_rxctl: Enter
<4>[ 4172.427615] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4172.434375] dhd_watchdog_thread:
<4>[ 4172.434478] dhd_bus_watchdog: Enter
<4>[ 4172.434554] dhdsdio_clkctl: Enter
<4>[ 4172.434621] dhdsdio_htclk: Enter
<4>[ 4172.434771] CLKCTL: turned OFF
<4>[ 4172.434855] dhdsdio_sdclk: Enter
<4>[ 4172.434927] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.489622] eth0: SIOCSIWMLME DISASSOC/DEAUTH
<4>[ 4172.489769] 
<4>[ 4172.489782] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0xc9, 
buf:c2297dd4, len:12 ,
<4>[ 4172.489949] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.490041] dhd_prot_ioctl: Enter
<4>[ 4172.490109] dhdcdc_query_ioctl: Enter
<4>[ 4172.490180] dhdcdc_query_ioctl: cmd 201 len 12
<4>[ 4172.490254] dhdcdc_msg: Enter
<4>[ 4172.490313] dhd_bus_txctl: Enter
<4>[ 4172.490378] dhdsdio_clkctl: Enter
<4>[ 4172.490441] dhdsdio_sdclk: Enter
<4>[ 4172.490502] dhdsdio_htclk: Enter
<4>[ 4172.493574] dhdsdio_isr: Enter
<4>[ 4172.493675] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.493763] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.493847] dhdsdio_dpc: Enter
<4>[ 4172.495602] CLKCTL: turned ON
<4>[ 4172.495714] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.495787] Tx Frame:
<4>[ 4172.495884]   0000: 34 00 cb ff 9d 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.496708]   0016: 00 00 00 00 00 00 00 00 c9 00 00 00 0c 00 00 00 
<4>[ 4172.496876]   0032: 00 00 94 00 00 00 00 00 03 00 00 00 00 1d 7e bd 
<4>[ 4172.497018]   0048: 45 a2 30 c6 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.504454] dhdsdio_clkctl: Enter
<4>[ 4172.504787] Dongle reports CHIPACTIVE
<4>[ 4172.504887] dhdsdio_readframes: Enter
<4>[ 4172.505075] RxHdr:
<4>[ 4172.505182]   0000: 28 00 d7 ff a0 00 00 0c 00 aa 00 00 
<4>[ 4172.505273] dhdsdio_read_control: Enter
<4>[ 4172.505347] RxCtrl:
<4>[ 4172.505441]   0000: 28 00 d7 ff a0 00 00 0c 00 aa 00 00 c9 00 00 00 
<4>[ 4172.505575]   0016: 0c 00 00 00 00 00 94 00 00 00 00 00 03 00 00 00 
<4>[ 4172.505691]   0032: 00 1d 7e bd 45 a2 30 c6 
<4>[ 4172.505875] RxHdr:
<4>[ 4172.505979]   0000: 5c 00 a3 ff a1 01 06 0e 00 aa 00 00 
<4>[ 4172.506187] Rx Data:
<4>[ 4172.506305]   0000: 5c 00 a3 ff a1 01 06 0e 00 aa 00 00 00 00 20 00 
<4>[ 4172.506450]   0016: 00 00 00 26 37 82 86 b6 02 26 37 82 86 b6 88 6c 
<4>[ 4172.506589]   0032: 80 01 00 68 00 00 10 18 00 01 00 02 00 00 00 00 
<4>[ 4172.506723]   0048: 00 0b 00 00 00 00 00 00 00 08 00 00 00 00 00 00 
<4>[ 4172.506859]   0064: 00 00 00 1d 7e bd 45 a2 77 6c 30 00 00 00 00 00 
<4>[ 4172.506981]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.507063] dhd_prot_hdrpull: Enter
<4>[ 4172.507159] dhd_watchdog_thread:
<4>[ 4172.507230] dhd_bus_watchdog: Enter
<4>[ 4172.507297] dhdsdio_clkctl: Enter
<4>[ 4172.507360] dhdsdio_htclk: Enter
<4>[ 4172.507497] CLKCTL: turned OFF
<4>[ 4172.507574] dhdsdio_sdclk: Enter
<4>[ 4172.507648] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.507743] dhd_rx_frame: Enter
<4>[ 4172.507830] dhd_ifname2idx: return idx 0 for "wl0"
<4>[ 4172.507920] wl_host_event: MAC event 11, flags 0, status 0
<4>[ 4172.508032] EVENT: DISASSOC, event ID = 11
<4>[ 4172.508107] MACEVENT: DISASSOC, MAC 00:1d:7e:bd:45:a2
<4>[ 4172.508198] wl_iw_event: dev=eth0 event=11 
<4>[ 4172.508272] Unknown Event 11: ignoring
<4>[ 4172.508354] Connection status: Conn Disassoc 00 08
<4>[ 4172.508693] Rx Data:
<4>[ 4172.508816]   0000: 5c 00 a3 ff a2 01 00 0e 00 aa 00 00 00 00 20 00 
<4>[ 4172.508959]   0016: 00 00 00 26 37 82 86 b6 02 26 37 82 86 b6 88 6c 
<4>[ 4172.509096]   0032: 80 01 00 68 00 00 10 18 00 01 00 02 00 00 00 00 
<4>[ 4172.509231]   0048: 00 10 00 00 00 00 00 00 00 02 00 00 00 00 00 00 
<4>[ 4172.509434]   0064: 00 00 00 1d 7e bd 45 a2 77 6c 30 00 00 00 00 00 
<4>[ 4172.509573]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.509659] dhd_prot_hdrpull: Enter
<4>[ 4172.509728] dhd_rx_frame: Enter
<4>[ 4172.509806] dhd_ifname2idx: return idx 0 for "wl0"
<4>[ 4172.509894] wl_host_event: MAC event 16, flags 0, status 0
<4>[ 4172.510005] EVENT: LINK, event ID = 16
<4>[ 4172.510076] MACEVENT: LINK DOWN
<4>[ 4172.510145] wl_iw_event: dev=eth0 event=16 
<4>[ 4172.510215] STA_Link Down
<4>[ 4172.510268] Link Down
<4>[ 4172.510508] RxHdr:
<4>[ 4172.510622]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.510717] dhdsdio_readframes: processed 3 frames
<4>[ 4172.510803] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 3
<4>[ 4172.511219] dhdcdc_cmplt: Enter
<4>[ 4172.511314] dhd_bus_rxctl: Enter
<4>[ 4172.511397] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4172.511671] eth0: SIOCGIWMODE
<4>[ 4172.511784] 
<4>[ 4172.511798] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x13, 
buf:c2297ddc, len:4 ,
<4>[ 4172.511961] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.512056] dhd_prot_ioctl: Enter
<4>[ 4172.512125] dhdcdc_query_ioctl: Enter
<4>[ 4172.512196] dhdcdc_query_ioctl: cmd 19 len 4
<4>[ 4172.512270] dhdcdc_msg: Enter
<4>[ 4172.512329] dhd_bus_txctl: Enter
<4>[ 4172.512394] dhdsdio_clkctl: Enter
<4>[ 4172.512458] dhdsdio_sdclk: Enter
<4>[ 4172.512518] dhdsdio_htclk: Enter
<4>[ 4172.514365] CLKCTL: turned ON
<4>[ 4172.514474] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.514549] Tx Frame:
<4>[ 4172.514645]   0000: 2c 00 d3 ff 9e 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.514781]   0016: 00 00 00 00 00 00 00 00 13 00 00 00 04 00 00 00 
<4>[ 4172.514914]   0032: 00 00 95 00 00 00 00 00 00 00 00 00 00 1d 7e bd 
<4>[ 4172.515046]   0048: 45 a2 30 c6 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.515405] dhdsdio_isr: Enter
<4>[ 4172.515497] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.515583] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.515665] dhdsdio_dpc: Enter
<4>[ 4172.515779] dhdsdio_clkctl: Enter
<4>[ 4172.516051] dhdsdio_readframes: Enter
<4>[ 4172.516250] RxHdr:
<4>[ 4172.516360]   0000: 20 00 df ff a3 00 00 0c 00 ab 00 00 
<4>[ 4172.516450] dhdsdio_read_control: Enter
<4>[ 4172.516521] RxCtrl:
<4>[ 4172.516616]   0000: 20 00 df ff a3 00 00 0c 00 ab 00 00 13 00 00 00 
<4>[ 4172.516750]   0016: 04 00 00 00 00 00 95 00 00 00 00 00 01 00 00 00 
<4>[ 4172.516953] RxHdr:
<4>[ 4172.517057]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.517149] dhdsdio_readframes: processed 1 frames
<4>[ 4172.517235] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.517385] dhdcdc_cmplt: Enter
<4>[ 4172.517462] dhd_bus_rxctl: Enter
<4>[ 4172.517539] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4172.517687] 
<4>[ 4172.517701] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x75, 
buf:c2297dd8, len:4 ,
<4>[ 4172.517867] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.517959] dhd_prot_ioctl: Enter
<4>[ 4172.518025] dhdcdc_query_ioctl: Enter
<4>[ 4172.518096] dhdcdc_query_ioctl: cmd 117 len 4
<4>[ 4172.518170] dhdcdc_msg: Enter
<4>[ 4172.518228] dhd_bus_txctl: Enter
<4>[ 4172.518291] dhdsdio_clkctl: Enter
<4>[ 4172.518357] Tx Frame:
<4>[ 4172.518454]   0000: 2c 00 d3 ff 9f 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.518589]   0016: 00 00 00 00 00 00 00 00 75 00 00 00 04 00 00 00 
<4>[ 4172.518723]   0032: 00 00 96 00 00 00 00 00 00 00 00 00 00 1d 7e bd 
<4>[ 4172.518856]   0048: 45 a2 30 c6 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.521818] dhdsdio_isr: Enter
<4>[ 4172.521918] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.522006] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.522089] dhdsdio_dpc: Enter
<4>[ 4172.522207] dhdsdio_clkctl: Enter
<4>[ 4172.522520] dhdsdio_readframes: Enter
<4>[ 4172.522722] RxHdr:
<4>[ 4172.522830]   0000: 20 00 df ff a4 00 00 0c 00 ac 00 00 
<4>[ 4172.522921] dhdsdio_read_control: Enter
<4>[ 4172.522994] RxCtrl:
<4>[ 4172.523085]   0000: 20 00 df ff a4 00 00 0c 00 ac 00 00 75 00 00 00 
<4>[ 4172.523219]   0016: 04 00 00 00 00 00 96 00 00 00 00 00 00 00 00 00 
<4>[ 4172.523426] RxHdr:
<4>[ 4172.523527]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.523616] dhdsdio_readframes: processed 1 frames
<4>[ 4172.523701] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.523848] dhdcdc_cmplt: Enter
<4>[ 4172.523925] dhd_bus_rxctl: Enter
<4>[ 4172.523999] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4172.524171] eth0: SIOCSIWAP
<4>[ 4172.524381] dhd_watchdog_thread:
<4>[ 4172.524469] dhd_bus_watchdog: Enter
<4>[ 4172.524540] dhdsdio_clkctl: Enter
<4>[ 4172.524606] dhdsdio_htclk: Enter
<4>[ 4172.524756] CLKCTL: turned OFF
<4>[ 4172.524836] dhdsdio_sdclk: Enter
<4>[ 4172.524909] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.527999] 
<4>[ 4172.528014] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x34, 
buf:c2297d8c, len:12 ,
<4>[ 4172.533329] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.540284] dhd_prot_ioctl: Enter
<4>[ 4172.540387] dhdcdc_query_ioctl: Enter
<4>[ 4172.540468] dhdcdc_query_ioctl: cmd 52 len 12
<4>[ 4172.540543] dhdcdc_msg: Enter
<4>[ 4172.540604] dhd_bus_txctl: Enter
<4>[ 4172.540668] dhdsdio_clkctl: Enter
<4>[ 4172.540732] dhdsdio_sdclk: Enter
<4>[ 4172.540794] dhdsdio_htclk: Enter
<4>[ 4172.544051] CLKCTL: turned ON
<4>[ 4172.544162] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.545539] Tx Frame:
<4>[ 4172.545676]   0000: 34 00 cb ff a0 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.545816]   0016: 00 00 00 00 00 00 00 00 34 00 00 00 0c 00 00 00 
<4>[ 4172.545952]   0032: 00 00 97 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.546084]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.550177] dhdsdio_isr: Enter
<4>[ 4172.550279] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.550366] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.550448] dhdsdio_dpc: Enter
<4>[ 4172.550667] dhd_watchdog_thread:
<4>[ 4172.550754] dhd_bus_watchdog: Enter
<4>[ 4172.550824] dhdsdio_clkctl: Enter
<4>[ 4172.550887] dhdsdio_htclk: Enter
<4>[ 4172.551042] CLKCTL: turned OFF
<4>[ 4172.551121] dhdsdio_sdclk: Enter
<4>[ 4172.551195] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.551293] dhdsdio_clkctl: Enter
<4>[ 4172.551367] dhdsdio_sdclk: Enter
<4>[ 4172.551432] dhdsdio_htclk: Enter
<4>[ 4172.551657] CLKCTL: turned ON
<4>[ 4172.551751] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.552044] dhdsdio_readframes: Enter
<4>[ 4172.552247] RxHdr:
<4>[ 4172.552354]   0000: 28 00 d7 ff a5 00 00 0c 00 ad 00 00 
<4>[ 4172.552445] dhdsdio_read_control: Enter
<4>[ 4172.552517] RxCtrl:
<4>[ 4172.552610]   0000: 28 00 d7 ff a5 00 00 0c 00 ad 00 00 34 00 00 00 
<4>[ 4172.552744]   0016: 0c 00 00 00 00 00 97 00 00 00 00 00 00 00 00 00 
<4>[ 4172.552857]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4172.553041] RxHdr:
<4>[ 4172.553142]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.553236] dhdsdio_readframes: processed 1 frames
<4>[ 4172.553320] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.553577] dhdcdc_cmplt: Enter
<4>[ 4172.553665] dhd_bus_rxctl: Enter
<4>[ 4172.553746] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4172.553949] eth0: SIOCSIWENCODEEXT
<4>[ 4172.554065] 
<4>[ 4172.554077] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4172.554360] dhd_watchdog_thread:
<4>[ 4172.554447] dhd_bus_watchdog: Enter
<4>[ 4172.554520] dhdsdio_clkctl: Enter
<4>[ 4172.554585] dhdsdio_htclk: Enter
<4>[ 4172.554733] CLKCTL: turned OFF
<4>[ 4172.554813] dhdsdio_sdclk: Enter
<4>[ 4172.554885] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.566137] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.566266] dhd_prot_ioctl: Enter
<4>[ 4172.566341] dhdcdc_query_ioctl: Enter
<4>[ 4172.566415] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4172.566491] dhdcdc_msg: Enter
<4>[ 4172.566551] dhd_bus_txctl: Enter
<4>[ 4172.566618] dhdsdio_clkctl: Enter
<4>[ 4172.566681] dhdsdio_sdclk: Enter
<4>[ 4172.566743] dhdsdio_htclk: Enter
<4>[ 4172.570285] CLKCTL: turned ON
<4>[ 4172.570396] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.570469] Tx Frame:
<4>[ 4172.570566]   0000: cc 00 33 ff a1 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.570701]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4172.570833]   0032: 00 00 98 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.570965]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.571095]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.571226]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.571358]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.571490]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.571621]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.571753]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.571885]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.572016]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.572148]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.572279]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.581661] dhdsdio_isr: Enter
<4>[ 4172.581760] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.581844] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.581926] dhdsdio_dpc: Enter
<4>[ 4172.582136] dhd_watchdog_thread:
<4>[ 4172.582224] dhd_bus_watchdog: Enter
<4>[ 4172.582295] dhdsdio_clkctl: Enter
<4>[ 4172.582361] dhdsdio_htclk: Enter
<4>[ 4172.582515] CLKCTL: turned OFF
<4>[ 4172.582595] dhdsdio_sdclk: Enter
<4>[ 4172.582666] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.582760] dhdsdio_clkctl: Enter
<4>[ 4172.582834] dhdsdio_sdclk: Enter
<4>[ 4172.582899] dhdsdio_htclk: Enter
<4>[ 4172.583122] CLKCTL: turned ON
<4>[ 4172.583216] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.583506] dhdsdio_readframes: Enter
<4>[ 4172.583710] RxHdr:
<4>[ 4172.583816]   0000: c0 00 3f ff a6 00 00 0c 00 ae 00 00 
<4>[ 4172.583909] dhdsdio_read_control: Enter
<4>[ 4172.584188] RxCtrl:
<4>[ 4172.584456]   0000: c0 00 3f ff a6 00 00 0c 00 ae 00 00 2d 00 00 00 
<4>[ 4172.584613]   0016: a4 00 00 00 00 00 98 00 00 00 00 00 00 00 00 00 
<4>[ 4172.584749]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.584885]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.585021]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.585153]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.585285]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.585415]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.585547]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.585679]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.585810]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.585941]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.586159] RxHdr:
<4>[ 4172.586260]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.586353] dhdsdio_readframes: processed 1 frames
<4>[ 4172.586438] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.586568] dhd_watchdog_thread:
<4>[ 4172.586642] dhd_bus_watchdog: Enter
<4>[ 4172.586710] dhdsdio_clkctl: Enter
<4>[ 4172.586774] dhdsdio_htclk: Enter
<4>[ 4172.586935] CLKCTL: turned OFF
<4>[ 4172.587018] dhdsdio_sdclk: Enter
<4>[ 4172.587088] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.587619] dhdcdc_cmplt: Enter
<4>[ 4172.587706] dhd_bus_rxctl: Enter
<4>[ 4172.587788] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4172.587997] eth0: SIOCSIWENCODEEXT
<4>[ 4172.588109] 
<4>[ 4172.588122] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4172.588286] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.588379] dhd_prot_ioctl: Enter
<4>[ 4172.588446] dhdcdc_query_ioctl: Enter
<4>[ 4172.588519] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4172.588594] dhdcdc_msg: Enter
<4>[ 4172.588654] dhd_bus_txctl: Enter
<4>[ 4172.588718] dhdsdio_clkctl: Enter
<4>[ 4172.588781] dhdsdio_sdclk: Enter
<4>[ 4172.588841] dhdsdio_htclk: Enter
<4>[ 4172.595624] CLKCTL: turned ON
<4>[ 4172.595736] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.595810] Tx Frame:
<4>[ 4172.595909]   0000: cc 00 33 ff a2 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.596045]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4172.596179]   0032: 00 00 99 00 00 00 00 00 01 00 00 00 00 00 00 00 
<4>[ 4172.596311]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.596441]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.596572]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.596704]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.596835]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.596966]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.597098]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.597230]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.597361]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.597492]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.597623]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.617180] dhdsdio_isr: Enter
<4>[ 4172.617283] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.617371] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.617455] dhdsdio_dpc: Enter
<4>[ 4172.617662] dhd_watchdog_thread:
<4>[ 4172.617749] dhd_bus_watchdog: Enter
<4>[ 4172.617817] dhdsdio_clkctl: Enter
<4>[ 4172.617882] dhdsdio_htclk: Enter
<4>[ 4172.618035] CLKCTL: turned OFF
<4>[ 4172.618117] dhdsdio_sdclk: Enter
<4>[ 4172.618187] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.618283] dhdsdio_clkctl: Enter
<4>[ 4172.618358] dhdsdio_sdclk: Enter
<4>[ 4172.618423] dhdsdio_htclk: Enter
<4>[ 4172.618643] CLKCTL: turned ON
<4>[ 4172.618735] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.619031] dhdsdio_readframes: Enter
<4>[ 4172.619234] RxHdr:
<4>[ 4172.619340]   0000: c0 00 3f ff a7 00 00 0c 00 af 00 00 
<4>[ 4172.619432] dhdsdio_read_control: Enter
<4>[ 4172.619716] RxCtrl:
<4>[ 4172.619838]   0000: c0 00 3f ff a7 00 00 0c 00 af 00 00 2d 00 00 00 
<4>[ 4172.619977]   0016: a4 00 00 00 00 00 99 00 00 00 00 00 01 00 00 00 
<4>[ 4172.620111]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.620243]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.620377]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.620511]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.620643]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.620774]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.620905]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.621036]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.621167]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.621298]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.621509] RxHdr:
<4>[ 4172.621611]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.621702] dhdsdio_readframes: processed 1 frames
<4>[ 4172.621789] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.621941] dhdcdc_cmplt: Enter
<4>[ 4172.622015] dhd_bus_rxctl: Enter
<4>[ 4172.622092] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4172.622304] eth0: SIOCSIWENCODEEXT
<4>[ 4172.622418] 
<4>[ 4172.622430] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4172.622595] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.622688] dhd_prot_ioctl: Enter
<4>[ 4172.622757] dhdcdc_query_ioctl: Enter
<4>[ 4172.622827] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4172.622903] dhdcdc_msg: Enter
<4>[ 4172.622962] dhd_bus_txctl: Enter
<4>[ 4172.623025] dhdsdio_clkctl: Enter
<4>[ 4172.623092] Tx Frame:
<4>[ 4172.623188]   0000: cc 00 33 ff a3 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.623322]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4172.623455]   0032: 00 00 9a 00 00 00 00 00 02 00 00 00 00 00 00 00 
<4>[ 4172.623586]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.623718]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.623849]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.623980]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.624111]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.633931]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.634103]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.634342]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.634494]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.634632]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.634765]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.640358] dhdsdio_isr: Enter
<4>[ 4172.640459] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.640547] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.640630] dhdsdio_dpc: Enter
<4>[ 4172.640750] dhd_watchdog_thread:
<4>[ 4172.640826] dhd_bus_watchdog: Enter
<4>[ 4172.640893] dhdsdio_clkctl: Enter
<4>[ 4172.640956] dhdsdio_htclk: Enter
<4>[ 4172.641105] CLKCTL: turned OFF
<4>[ 4172.641187] dhdsdio_sdclk: Enter
<4>[ 4172.641260] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.641355] dhdsdio_clkctl: Enter
<4>[ 4172.641427] dhdsdio_sdclk: Enter
<4>[ 4172.641491] dhdsdio_htclk: Enter
<4>[ 4172.641716] CLKCTL: turned ON
<4>[ 4172.641807] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.642095] dhdsdio_readframes: Enter
<4>[ 4172.642298] RxHdr:
<4>[ 4172.642406]   0000: c0 00 3f ff a8 00 00 0c 00 b0 00 00 
<4>[ 4172.642498] dhdsdio_read_control: Enter
<4>[ 4172.642773] RxCtrl:
<4>[ 4172.642893]   0000: c0 00 3f ff a8 00 00 0c 00 b0 00 00 2d 00 00 00 
<4>[ 4172.643033]   0016: a4 00 00 00 00 00 9a 00 00 00 00 00 02 00 00 00 
<4>[ 4172.643167]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.643301]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.643433]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.643565]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.643695]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.643827]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.643957]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.644088]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.644358]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.644515]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.644735] RxHdr:
<4>[ 4172.644837]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.644929] dhdsdio_readframes: processed 1 frames
<4>[ 4172.645016] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.645147] dhd_watchdog_thread:
<4>[ 4172.645221] dhd_bus_watchdog: Enter
<4>[ 4172.645290] dhdsdio_clkctl: Enter
<4>[ 4172.645354] dhdsdio_htclk: Enter
<4>[ 4172.645495] CLKCTL: turned OFF
<4>[ 4172.645574] dhdsdio_sdclk: Enter
<4>[ 4172.645646] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.646332] dhdcdc_cmplt: Enter
<4>[ 4172.646791] dhd_bus_rxctl: Enter
<4>[ 4172.646900] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4172.647115] eth0: SIOCSIWENCODEEXT
<4>[ 4172.647229] 
<4>[ 4172.647242] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4172.647408] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.647499] dhd_prot_ioctl: Enter
<4>[ 4172.647566] dhdcdc_query_ioctl: Enter
<4>[ 4172.647636] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4172.647713] dhdcdc_msg: Enter
<4>[ 4172.647771] dhd_bus_txctl: Enter
<4>[ 4172.647835] dhdsdio_clkctl: Enter
<4>[ 4172.647897] dhdsdio_sdclk: Enter
<4>[ 4172.647959] dhdsdio_htclk: Enter
<4>[ 4172.653480] CLKCTL: turned ON
<4>[ 4172.653590] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.653664] Tx Frame:
<4>[ 4172.653760]   0000: cc 00 33 ff a4 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.653895]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4172.654029]   0032: 00 00 9b 00 00 00 00 00 03 00 00 00 00 00 00 00 
<4>[ 4172.654160]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.658510]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.658681]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.658822]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.658956]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.659090]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.659222]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.659355]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.659486]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.659617]   0192: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.659748]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.666790] dhd_watchdog_thread:
<4>[ 4172.666891] dhd_bus_watchdog: Enter
<4>[ 4172.666965] dhdsdio_clkctl: Enter
<4>[ 4172.667030] dhdsdio_htclk: Enter
<4>[ 4172.667177] CLKCTL: turned OFF
<4>[ 4172.667258] dhdsdio_sdclk: Enter
<4>[ 4172.667333] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.667532] dhdsdio_isr: Enter
<4>[ 4172.667618] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.667701] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.667782] dhdsdio_dpc: Enter
<4>[ 4172.667844] dhdsdio_clkctl: Enter
<4>[ 4172.667906] dhdsdio_sdclk: Enter
<4>[ 4172.667967] dhdsdio_htclk: Enter
<4>[ 4172.668185] CLKCTL: turned ON
<4>[ 4172.668278] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.668570] dhdsdio_readframes: Enter
<4>[ 4172.668773] RxHdr:
<4>[ 4172.668878]   0000: c0 00 3f ff a9 00 00 0c 00 b1 00 00 
<4>[ 4172.668973] dhdsdio_read_control: Enter
<4>[ 4172.669257] RxCtrl:
<4>[ 4172.669378]   0000: c0 00 3f ff a9 00 00 0c 00 b1 00 00 2d 00 00 00 
<4>[ 4172.669518]   0016: a4 00 00 00 00 00 9b 00 00 00 00 00 03 00 00 00 
<4>[ 4172.669653]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.669786]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.669918]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.670050]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.670181]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.670312]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.670443]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.670574]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.670705]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.670837]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.671044] RxHdr:
<4>[ 4172.671146]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.671240] dhdsdio_readframes: processed 1 frames
<4>[ 4172.671326] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.671586] dhdcdc_cmplt: Enter
<4>[ 4172.671673] dhd_bus_rxctl: Enter
<4>[ 4172.671757] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4172.671967] eth0: SIOCSIWENCODEEXT
<4>[ 4172.672079] 
<4>[ 4172.672090] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x2d, 
buf:c2297d18, len:164 ,
<4>[ 4172.672259] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.672352] dhd_prot_ioctl: Enter
<4>[ 4172.672420] dhdcdc_query_ioctl: Enter
<4>[ 4172.672492] dhdcdc_query_ioctl: cmd 45 len 164
<4>[ 4172.672569] dhdcdc_msg: Enter
<4>[ 4172.672629] dhd_bus_txctl: Enter
<4>[ 4172.672692] dhdsdio_clkctl: Enter
<4>[ 4172.672760] Tx Frame:
<4>[ 4172.672858]   0000: cc 00 33 ff a5 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.672991]   0016: 00 00 00 00 00 00 00 00 2d 00 00 00 a4 00 00 00 
<4>[ 4172.673124]   0032: 00 00 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.673255]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.673386]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.673518]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.673649]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.673780]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.673912]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.674043]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.674174]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.688159]   0176: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.688333]   0192: 00 00 00 00 00 1d 7e bd 45 a2 00 00 00 00 00 00 
<4>[ 4172.688474]   0208: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.688976] dhd_watchdog_thread:
<4>[ 4172.689093] dhd_bus_watchdog: Enter
<4>[ 4172.689173] dhdsdio_clkctl: Enter
<4>[ 4172.689241] dhdsdio_htclk: Enter
<4>[ 4172.689382] CLKCTL: turned OFF
<4>[ 4172.689463] dhdsdio_sdclk: Enter
<4>[ 4172.689537] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.689729] dhdsdio_isr: Enter
<4>[ 4172.689809] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.689892] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.689975] dhdsdio_dpc: Enter
<4>[ 4172.690037] dhdsdio_clkctl: Enter
<4>[ 4172.690100] dhdsdio_sdclk: Enter
<4>[ 4172.690160] dhdsdio_htclk: Enter
<4>[ 4172.690377] CLKCTL: turned ON
<4>[ 4172.690468] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.690754] dhdsdio_readframes: Enter
<4>[ 4172.690955] RxHdr:
<4>[ 4172.691061]   0000: c0 00 3f ff aa 00 00 0c 00 b2 00 00 
<4>[ 4172.691152] dhdsdio_read_control: Enter
<4>[ 4172.691427] RxCtrl:
<4>[ 4172.691547]   0000: c0 00 3f ff aa 00 00 0c 00 b2 00 00 2d 00 00 00 
<4>[ 4172.691686]   0016: a4 00 00 00 00 00 9c 00 00 00 00 00 00 00 00 00 
<4>[ 4172.691821]   0032: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.691953]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.692085]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.692218]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.692349]   0096: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.692481]   0112: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.692666]   0128: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.692811]   0144: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.692946]   0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.693080]   0176: 00 00 00 00 00 00 00 00 00 1d 7e bd 45 a2 00 00 
<4>[ 4172.693291] RxHdr:
<4>[ 4172.693393]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.693486] dhdsdio_readframes: processed 1 frames
<4>[ 4172.693571] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.693805] dhdcdc_cmplt: Enter
<4>[ 4172.693892] dhd_bus_rxctl: Enter
<4>[ 4172.693972] dhd_bus_rxctl: resumed on rxctl frame, got 180 expected 180
<4>[ 4172.694365] dhd_watchdog_thread:
<4>[ 4172.694460] dhd_bus_watchdog: Enter
<4>[ 4172.694533] dhdsdio_clkctl: Enter
<4>[ 4172.694598] dhdsdio_htclk: Enter
<4>[ 4172.694744] CLKCTL: turned OFF
<4>[ 4172.694821] dhdsdio_sdclk: Enter
<4>[ 4172.694895] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.695593] dhd_get_stats: Enter
<4>[ 4172.695847] eth0: SIOCSIWAUTH
<4>[ 4172.695940] eth0: SIOCSIWAUTH, paramid = 0x7, paramval = 0x0
<4>[ 4172.696075] 
<4>[ 4172.696087] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x106, 
buf:c2297cac, len:5 ,
<4>[ 4172.696252] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.696345] dhd_prot_ioctl: Enter
<4>[ 4172.696413] dhdcdc_query_ioctl: Enter
<4>[ 4172.696484] dhdcdc_query_ioctl: cmd 262 len 5
<4>[ 4172.696557] dhdcdc_msg: Enter
<4>[ 4172.696616] dhd_bus_txctl: Enter
<4>[ 4172.696679] dhdsdio_clkctl: Enter
<4>[ 4172.696744] dhdsdio_sdclk: Enter
<4>[ 4172.696805] dhdsdio_htclk: Enter
<4>[ 4172.704415] CLKCTL: turned ON
<4>[ 4172.704527] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.704603] Tx Frame:
<4>[ 4172.704700]   0000: 2d 00 d2 ff a6 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.704835]   0016: 00 00 00 00 00 00 00 00 06 01 00 00 05 00 00 00 
<4>[ 4172.704972]   0032: 00 00 9d 00 00 00 00 00 77 73 65 63 00 00 00 00 
<4>[ 4172.705104]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.705329] dhdcdc_cmplt: Enter
<4>[ 4172.705529] dhdsdio_isr: Enter
<4>[ 4172.705613] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.705699] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.705781] dhdsdio_dpc: Enter
<4>[ 4172.705842] dhdsdio_clkctl: Enter
<4>[ 4172.706129] dhdsdio_readframes: Enter
<4>[ 4172.706331] RxHdr:
<4>[ 4172.706433]   0000: 21 00 de ff ab 00 00 0c 00 b3 00 00 
<4>[ 4172.706525] dhdsdio_read_control: Enter
<4>[ 4172.706599] RxCtrl:
<4>[ 4172.706692]   0000: 21 00 de ff ab 00 00 0c 00 b3 00 00 06 01 00 00 
<4>[ 4172.706824]   0016: 05 00 00 00 00 00 9d 00 00 00 00 00 02 00 00 00 
<4>[ 4172.706921]   0032: 00 
<4>[ 4172.707084] RxHdr:
<4>[ 4172.707186]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.707279] dhdsdio_readframes: processed 1 frames
<4>[ 4172.707364] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.707512] dhd_bus_rxctl: Enter
<4>[ 4172.707600] dhd_bus_rxctl: resumed on rxctl frame, got 21 expected 21
<4>[ 4172.707764] 
<4>[ 4172.707776] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:9 ,
<4>[ 4172.707944] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.708039] dhd_prot_ioctl: Enter
<4>[ 4172.708107] dhdcdc_query_ioctl: Enter
<4>[ 4172.708178] dhdcdc_query_ioctl: cmd 263 len 9
<4>[ 4172.708252] dhdcdc_msg: Enter
<4>[ 4172.708310] dhd_bus_txctl: Enter
<4>[ 4172.708372] dhdsdio_clkctl: Enter
<4>[ 4172.708438] Tx Frame:
<4>[ 4172.708534]   0000: 31 00 ce ff a7 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.708670]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 09 00 00 00 
<4>[ 4172.708803]   0032: 00 00 9e 00 00 00 00 00 77 73 65 63 00 00 00 00 
<4>[ 4172.708935]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.709154] dhdcdc_cmplt: Enter
<4>[ 4172.709368] dhdsdio_isr: Enter
<4>[ 4172.709449] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.709533] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.709614] dhdsdio_dpc: Enter
<4>[ 4172.709677] dhdsdio_clkctl: Enter
<4>[ 4172.709968] dhdsdio_readframes: Enter
<4>[ 4172.710170] RxHdr:
<4>[ 4172.710274]   0000: 25 00 da ff ac 00 00 0c 00 b4 00 00 
<4>[ 4172.710366] dhdsdio_read_control: Enter
<4>[ 4172.710438] RxCtrl:
<4>[ 4172.710532]   0000: 25 00 da ff ac 00 00 0c 00 b4 00 00 07 01 00 00 
<4>[ 4172.710666]   0016: 09 00 00 00 00 00 9e 00 00 00 00 00 77 73 65 63 
<4>[ 4172.710772]   0032: 00 00 00 00 00 
<4>[ 4172.710946] RxHdr:
<4>[ 4172.711046]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.711136] dhdsdio_readframes: processed 1 frames
<4>[ 4172.711222] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.711369] dhd_bus_rxctl: Enter
<4>[ 4172.711454] dhd_bus_rxctl: resumed on rxctl frame, got 25 expected 25
<4>[ 4172.711591] wl_iw_set_wpaauth: 5377: setting wpa_auth to 0
<4>[ 4172.711720] 
<4>[ 4172.711732] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:c2297cb4, len:13 ,
<4>[ 4172.711894] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.711989] dhd_prot_ioctl: Enter
<4>[ 4172.712055] dhdcdc_query_ioctl: Enter
<4>[ 4172.712126] dhdcdc_query_ioctl: cmd 263 len 13
<4>[ 4172.712200] dhdcdc_msg: Enter
<4>[ 4172.712258] dhd_bus_txctl: Enter
<4>[ 4172.712321] dhdsdio_clkctl: Enter
<4>[ 4172.712387] Tx Frame:
<4>[ 4172.712483]   0000: 35 00 ca ff a8 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.712615]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 0d 00 00 00 
<4>[ 4172.712749]   0032: 00 00 9f 00 00 00 00 00 77 70 61 5f 61 75 74 68 
<4>[ 4172.712880]   0048: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.713101] dhdcdc_cmplt: Enter
<4>[ 4172.713318] dhdsdio_isr: Enter
<4>[ 4172.713403] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.713486] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.713566] dhdsdio_dpc: Enter
<4>[ 4172.713629] dhdsdio_clkctl: Enter
<4>[ 4172.713914] dhdsdio_readframes: Enter
<4>[ 4172.714140] RxHdr:
<4>[ 4172.714388]   0000: 29 00 d6 ff ad 00 00 0c 00 b5 00 00 
<4>[ 4172.714496] dhdsdio_read_control: Enter
<4>[ 4172.714572] RxCtrl:
<4>[ 4172.714665]   0000: 29 00 d6 ff ad 00 00 0c 00 b5 00 00 07 01 00 00 
<4>[ 4172.714800]   0016: 0d 00 00 00 00 00 9f 00 00 00 00 00 77 70 61 5f 
<4>[ 4172.714917]   0032: 61 75 74 68 00 00 00 00 00 
<4>[ 4172.715113] RxHdr:
<4>[ 4172.715221]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.715315] dhdsdio_readframes: processed 1 frames
<4>[ 4172.715400] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.715531] dhd_watchdog_thread:
<4>[ 4172.715603] dhd_bus_watchdog: Enter
<4>[ 4172.715670] dhdsdio_clkctl: Enter
<4>[ 4172.715733] dhdsdio_htclk: Enter
<4>[ 4172.715873] CLKCTL: turned OFF
<4>[ 4172.715952] dhdsdio_sdclk: Enter
<4>[ 4172.716024] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.716165] dhd_bus_rxctl: Enter
<4>[ 4172.716255] dhd_bus_rxctl: resumed on rxctl frame, got 29 expected 29
<4>[ 4172.716427] eth0: SIOCSIWAUTH
<4>[ 4172.716508] eth0: SIOCSIWAUTH, paramid = 0x5, paramval = 0x0
<4>[ 4172.716673] 
<4>[ 4172.716684] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:bf26e82c, len:18 ,
<4>[ 4172.716849] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.716941] dhd_prot_ioctl: Enter
<4>[ 4172.717010] dhdcdc_query_ioctl: Enter
<4>[ 4172.717083] dhdcdc_query_ioctl: cmd 263 len 18
<4>[ 4172.717158] dhdcdc_msg: Enter
<4>[ 4172.717217] dhd_bus_txctl: Enter
<4>[ 4172.717281] dhdsdio_clkctl: Enter
<4>[ 4172.717344] dhdsdio_sdclk: Enter
<4>[ 4172.717404] dhdsdio_htclk: Enter
<4>[ 4172.717646] CLKCTL: turned ON
<4>[ 4172.717742] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.717813] Tx Frame:
<4>[ 4172.717910]   0000: 3a 00 c5 ff a9 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.718044]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 12 00 00 00 
<4>[ 4172.718179]   0032: 00 00 a0 00 00 00 00 00 77 73 65 63 5f 72 65 73 
<4>[ 4172.718313]   0048: 74 72 69 63 74 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.718527] dhdcdc_cmplt: Enter
<4>[ 4172.718744] dhdsdio_isr: Enter
<4>[ 4172.718827] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.718911] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.718993] dhdsdio_dpc: Enter
<4>[ 4172.719054] dhdsdio_clkctl: Enter
<4>[ 4172.719339] dhdsdio_readframes: Enter
<4>[ 4172.719541] RxHdr:
<4>[ 4172.719647]   0000: 2e 00 d1 ff ae 00 00 0c 00 b6 00 00 
<4>[ 4172.719738] dhdsdio_read_control: Enter
<4>[ 4172.719811] RxCtrl:
<4>[ 4172.719905]   0000: 2e 00 d1 ff ae 00 00 0c 00 b6 00 00 07 01 00 00 
<4>[ 4172.720040]   0016: 12 00 00 00 00 00 a0 00 00 00 00 00 77 73 65 63 
<4>[ 4172.720170]   0032: 5f 72 65 73 74 72 69 63 74 00 00 00 00 00 
<4>[ 4172.720373] RxHdr:
<4>[ 4172.720476]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.720566] dhdsdio_readframes: processed 1 frames
<4>[ 4172.720652] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.720799] dhd_bus_rxctl: Enter
<4>[ 4172.720886] dhd_bus_rxctl: resumed on rxctl frame, got 34 expected 34
<4>[ 4172.721055] eth0: SIOCSIWAUTH
<4>[ 4172.721137] eth0: SIOCSIWAUTH, paramid = 0x4, paramval = 0x0
<4>[ 4172.721302] 
<4>[ 4172.721314] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x107, 
buf:bf26e82c, len:25 ,
<4>[ 4172.721477] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4172.721570] dhd_prot_ioctl: Enter
<4>[ 4172.721637] dhdcdc_query_ioctl: Enter
<4>[ 4172.721708] dhdcdc_query_ioctl: cmd 263 len 25
<4>[ 4172.721782] dhdcdc_msg: Enter
<4>[ 4172.721841] dhd_bus_txctl: Enter
<4>[ 4172.721902] dhdsdio_clkctl: Enter
<4>[ 4172.721969] Tx Frame:
<4>[ 4172.722065]   0000: 41 00 be ff aa 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4172.722198]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 19 00 00 00 
<4>[ 4172.722332]   0032: 00 00 a1 00 00 00 00 00 74 6b 69 70 5f 63 6f 75 
<4>[ 4172.722468]   0048: 6e 74 65 72 6d 65 61 73 75 72 65 73 00 00 00 00 
<4>[ 4172.722599]   0064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.722730]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.732022] dhd_watchdog_thread:
<4>[ 4172.732148] dhd_bus_watchdog: Enter
<4>[ 4172.732226] dhdsdio_clkctl: Enter
<4>[ 4172.732292] dhdsdio_htclk: Enter
<4>[ 4172.732434] CLKCTL: turned OFF
<4>[ 4172.732514] dhdsdio_sdclk: Enter
<4>[ 4172.732584] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.732773] dhdsdio_isr: Enter
<4>[ 4172.732855] dhdsdio_isr: disable SDIO interrupts
<4>[ 4172.732940] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4172.733021] dhdsdio_dpc: Enter
<4>[ 4172.733081] dhdsdio_clkctl: Enter
<4>[ 4172.733145] dhdsdio_sdclk: Enter
<4>[ 4172.733207] dhdsdio_htclk: Enter
<4>[ 4172.733425] CLKCTL: turned ON
<4>[ 4172.733518] dhdsdio_clkctl: 0 -> 3
<4>[ 4172.733803] dhdsdio_readframes: Enter
<4>[ 4172.734006] RxHdr:
<4>[ 4172.734111]   0000: 35 00 ca ff af 00 00 0c 00 b7 00 00 
<4>[ 4172.734202] dhdsdio_read_control: Enter
<4>[ 4172.734410] RxCtrl:
<4>[ 4172.734533]   0000: 35 00 ca ff af 00 00 0c 00 b7 00 00 07 01 00 00 
<4>[ 4172.734672]   0016: 00 00 00 00 01 00 a1 00 e9 ff ff ff 74 6b 69 70 
<4>[ 4172.734811]   0032: 5f 63 6f 75 6e 74 65 72 6d 65 61 73 75 72 65 73 
<4>[ 4172.734916]   0048: 00 00 00 00 00 
<4>[ 4172.735105] RxHdr:
<4>[ 4172.735211]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4172.735303] dhdsdio_readframes: processed 1 frames
<4>[ 4172.735390] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4172.735522] dhd_watchdog_thread:
<4>[ 4172.735595] dhd_bus_watchdog: Enter
<4>[ 4172.735662] dhdsdio_clkctl: Enter
<4>[ 4172.735727] dhdsdio_htclk: Enter
<4>[ 4172.735867] CLKCTL: turned OFF
<4>[ 4172.735945] dhdsdio_sdclk: Enter
<4>[ 4172.736016] dhdsdio_clkctl: 3 -> 0
<4>[ 4172.736174] dhdcdc_cmplt: Enter
<4>[ 4172.736256] dhd_bus_rxctl: Enter
<4>[ 4172.736335] dhd_bus_rxctl: resumed on rxctl frame, got 41 expected 41
<4>[ 4172.736464] wl_iw_set_wpaauth: tkip_countermeasures failed -95
<4>[ 4173.742984] eth0: SIOCGIWMODE
<4>[ 4173.743113] 
<4>[ 4173.743126] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x13, 
buf:c2297ddc, len:4 ,
<4>[ 4173.743293] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4173.743389] dhd_prot_ioctl: Enter
<4>[ 4173.743460] dhdcdc_query_ioctl: Enter
<4>[ 4173.743531] dhdcdc_query_ioctl: cmd 19 len 4
<4>[ 4173.743604] dhdcdc_msg: Enter
<4>[ 4173.743665] dhd_bus_txctl: Enter
<4>[ 4173.743731] dhdsdio_clkctl: Enter
<4>[ 4173.743793] dhdsdio_sdclk: Enter
<4>[ 4173.743854] dhdsdio_htclk: Enter
<4>[ 4173.746888] dhdsdio_isr: Enter
<4>[ 4173.746985] dhdsdio_isr: disable SDIO interrupts
<4>[ 4173.747069] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4173.747151] dhdsdio_dpc: Enter
<4>[ 4173.754493] CLKCTL: turned ON
<4>[ 4173.754605] dhdsdio_clkctl: 0 -> 3
<4>[ 4173.754679] Tx Frame:
<4>[ 4173.754778]   0000: 2c 00 d3 ff ab 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4173.754913]   0016: 00 00 00 00 00 00 00 00 13 00 00 00 04 00 00 00 
<4>[ 4173.755047]   0032: 00 00 a2 00 00 00 00 00 00 00 00 00 5f 63 6f 75 
<4>[ 4173.755183]   0048: 6e 74 65 72 6d 65 61 73 75 72 65 73 00 00 00 00 
<4>[ 4173.755448] dhdsdio_clkctl: Enter
<4>[ 4173.755760] Dongle reports CHIPACTIVE
<4>[ 4173.755855] dhdsdio_readframes: Enter
<4>[ 4173.756039] RxHdr:
<4>[ 4173.756145]   0000: 20 00 df ff b0 00 00 0c 00 b8 00 00 
<4>[ 4173.756237] dhdsdio_read_control: Enter
<4>[ 4173.756308] RxCtrl:
<4>[ 4173.756401]   0000: 20 00 df ff b0 00 00 0c 00 b8 00 00 13 00 00 00 
<4>[ 4173.756536]   0016: 04 00 00 00 00 00 a2 00 00 00 00 00 01 00 00 00 
<4>[ 4173.756743] RxHdr:
<4>[ 4173.756844]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.756934] dhdsdio_readframes: processed 1 frames
<4>[ 4173.757019] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4173.757166] dhdcdc_cmplt: Enter
<4>[ 4173.757241] dhd_bus_rxctl: Enter
<4>[ 4173.757316] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4173.757463] 
<4>[ 4173.757475] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x75, 
buf:c2297dd8, len:4 ,
<4>[ 4173.757642] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4173.757736] dhd_prot_ioctl: Enter
<4>[ 4173.757803] dhdcdc_query_ioctl: Enter
<4>[ 4173.757873] dhdcdc_query_ioctl: cmd 117 len 4
<4>[ 4173.757947] dhdcdc_msg: Enter
<4>[ 4173.758004] dhd_bus_txctl: Enter
<4>[ 4173.758067] dhdsdio_clkctl: Enter
<4>[ 4173.758135] Tx Frame:
<4>[ 4173.758231]   0000: 2c 00 d3 ff ac 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4173.758363]   0016: 00 00 00 00 00 00 00 00 75 00 00 00 04 00 00 00 
<4>[ 4173.758496]   0032: 00 00 a3 00 00 00 00 00 00 00 00 00 5f 63 6f 75 
<4>[ 4173.758632]   0048: 6e 74 65 72 6d 65 61 73 75 72 65 73 00 00 00 00 
<4>[ 4173.764538] dhdsdio_isr: Enter
<4>[ 4173.764638] dhdsdio_isr: disable SDIO interrupts
<4>[ 4173.764724] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4173.764807] dhdsdio_dpc: Enter
<4>[ 4173.764926] dhd_watchdog_thread:
<4>[ 4173.765001] dhd_bus_watchdog: Enter
<4>[ 4173.765071] dhdsdio_clkctl: Enter
<4>[ 4173.765134] dhdsdio_htclk: Enter
<4>[ 4173.765285] CLKCTL: turned OFF
<4>[ 4173.765364] dhdsdio_sdclk: Enter
<4>[ 4173.765434] dhdsdio_clkctl: 3 -> 0
<4>[ 4173.765531] dhdsdio_clkctl: Enter
<4>[ 4173.765602] dhdsdio_sdclk: Enter
<4>[ 4173.765666] dhdsdio_htclk: Enter
<4>[ 4173.765888] CLKCTL: turned ON
<4>[ 4173.765978] dhdsdio_clkctl: 0 -> 3
<4>[ 4173.766265] dhdsdio_readframes: Enter
<4>[ 4173.766466] RxHdr:
<4>[ 4173.766573]   0000: 20 00 df ff b1 00 00 0c 00 b9 00 00 
<4>[ 4173.766665] dhdsdio_read_control: Enter
<4>[ 4173.766737] RxCtrl:
<4>[ 4173.766829]   0000: 20 00 df ff b1 00 00 0c 00 b9 00 00 75 00 00 00 
<4>[ 4173.766961]   0016: 04 00 00 00 00 00 a3 00 00 00 00 00 00 00 00 00 
<4>[ 4173.767166] RxHdr:
<4>[ 4173.767269]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.767360] dhdsdio_readframes: processed 1 frames
<4>[ 4173.767446] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4173.767597] dhdcdc_cmplt: Enter
<4>[ 4173.767674] dhd_bus_rxctl: Enter
<4>[ 4173.767749] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4173.767920] eth0: SIOCSIWAP
<4>[ 4173.768023] 
<4>[ 4173.768035] dev_wlc_ioctl, PID:a19: send Local IOCTL -> dhd: cmd:0x34, 
buf:c2297d8c, len:12 ,
<4>[ 4173.768197] dhd_ioctl_entry: ifidx 0, cmd 0x89f0
<4>[ 4173.768290] dhd_prot_ioctl: Enter
<4>[ 4173.768358] dhdcdc_query_ioctl: Enter
<4>[ 4173.768429] dhdcdc_query_ioctl: cmd 52 len 12
<4>[ 4173.768504] dhdcdc_msg: Enter
<4>[ 4173.768562] dhd_bus_txctl: Enter
<4>[ 4173.768626] dhdsdio_clkctl: Enter
<4>[ 4173.768693] Tx Frame:
<4>[ 4173.768789]   0000: 34 00 cb ff ad 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4173.768923]   0016: 00 00 00 00 00 00 00 00 34 00 00 00 0c 00 00 00 
<4>[ 4173.769056]   0032: 00 00 a4 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.769190]   0048: 00 00 00 00 6d 65 61 73 75 72 65 73 00 00 00 00 
<4>[ 4173.769521] dhdsdio_isr: Enter
<4>[ 4173.769612] dhdsdio_isr: disable SDIO interrupts
<4>[ 4173.769698] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4173.769781] dhdsdio_dpc: Enter
<4>[ 4173.769893] dhdsdio_clkctl: Enter
<4>[ 4173.770161] dhdsdio_readframes: Enter
<4>[ 4173.770357] RxHdr:
<4>[ 4173.770461]   0000: 28 00 d7 ff b2 00 00 0c 00 ba 00 00 
<4>[ 4173.770552] dhdsdio_read_control: Enter
<4>[ 4173.770624] RxCtrl:
<4>[ 4173.770718]   0000: 28 00 d7 ff b2 00 00 0c 00 ba 00 00 34 00 00 00 
<4>[ 4173.770853]   0016: 0c 00 00 00 00 00 a4 00 00 00 00 00 00 00 00 00 
<4>[ 4173.770968]   0032: 00 00 00 00 00 00 00 00 
<4>[ 4173.771150] RxHdr:
<4>[ 4173.771251]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.771344] dhdsdio_readframes: processed 1 frames
<4>[ 4173.771430] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4173.771578] dhdcdc_cmplt: Enter
<4>[ 4173.771652] dhd_bus_rxctl: Enter
<4>[ 4173.771728] dhd_bus_rxctl: resumed on rxctl frame, got 28 expected 28
<4>[ 4173.772200] dhd_get_stats: Enter
<4>[ 4173.772438] dhd_set_multicast_list: Enter
<4>[ 4173.772606] _dhd_sysioc_thread: interface 0
<4>[ 4173.772710] dhd_prot_ioctl: Enter
<4>[ 4173.772781] dhdcdc_set_ioctl: Enter
<4>[ 4173.772852] dhdcdc_set_ioctl: cmd 263 len 33
<4>[ 4173.772924] dhdcdc_msg: Enter
<4>[ 4173.772983] dhd_bus_txctl: Enter
<4>[ 4173.773049] dhdsdio_clkctl: Enter
<4>[ 4173.773118] Tx Frame:
<4>[ 4173.773215]   0000: 49 00 b6 ff ae 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4173.773349]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 21 00 00 00 
<4>[ 4173.773484]   0032: 02 00 a5 00 00 00 00 00 6d 63 61 73 74 5f 6c 69 
<4>[ 4173.773617]   0048: 73 74 00 03 00 00 00 33 33 00 00 00 01 01 00 5e 
<4>[ 4173.773750]   0064: 00 00 01 33 33 ff 82 86 b6 00 00 00 00 00 00 00 
<4>[ 4173.773881]   0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.774207] dhdcdc_cmplt: Enter
<4>[ 4173.774433] dhd_watchdog_thread:
<4>[ 4173.774522] dhd_bus_watchdog: Enter
<4>[ 4173.774595] dhdsdio_clkctl: Enter
<4>[ 4173.774660] dhdsdio_htclk: Enter
<4>[ 4173.774805] CLKCTL: turned OFF
<4>[ 4173.774883] dhdsdio_sdclk: Enter
<4>[ 4173.774955] dhdsdio_clkctl: 3 -> 0
<4>[ 4173.775145] dhdsdio_isr: Enter
<4>[ 4173.775227] dhdsdio_isr: disable SDIO interrupts
<4>[ 4173.775311] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4173.775392] dhdsdio_dpc: Enter
<4>[ 4173.775454] dhdsdio_clkctl: Enter
<4>[ 4173.775517] dhdsdio_sdclk: Enter
<4>[ 4173.775579] dhdsdio_htclk: Enter
<4>[ 4173.775798] CLKCTL: turned ON
<4>[ 4173.775890] dhdsdio_clkctl: 0 -> 3
<4>[ 4173.776177] dhdsdio_readframes: Enter
<4>[ 4173.776378] RxHdr:
<4>[ 4173.776484]   0000: 3d 00 c2 ff b3 00 00 0c 00 bb 00 00 
<4>[ 4173.776575] dhdsdio_read_control: Enter
<4>[ 4173.776646] RxCtrl:
<4>[ 4173.776739]   0000: 3d 00 c2 ff b3 00 00 0c 00 bb 00 00 07 01 00 00 
<4>[ 4173.776874]   0016: 21 00 00 00 00 00 a5 00 00 00 00 00 6d 63 61 73 
<4>[ 4173.777008]   0032: 74 5f 6c 69 73 74 00 03 00 00 00 33 33 00 00 00 
<4>[ 4173.777135]   0048: 01 01 00 5e 00 00 01 33 33 ff 82 86 b6 
<4>[ 4173.777331] RxHdr:
<4>[ 4173.777432]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.777523] dhdsdio_readframes: processed 1 frames
<4>[ 4173.777609] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4173.777756] dhd_bus_rxctl: Enter
<4>[ 4173.777845] dhd_bus_rxctl: resumed on rxctl frame, got 49 expected 49
<4>[ 4173.777961] dhd_prot_ioctl: Enter
<4>[ 4173.778031] dhdcdc_set_ioctl: Enter
<4>[ 4173.778100] dhdcdc_set_ioctl: cmd 263 len 13
<4>[ 4173.778173] dhdcdc_msg: Enter
<4>[ 4173.778232] dhd_bus_txctl: Enter
<4>[ 4173.778296] dhdsdio_clkctl: Enter
<4>[ 4173.778364] Tx Frame:
<4>[ 4173.778459]   0000: 35 00 ca ff af 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4173.778594]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 0d 00 00 00 
<4>[ 4173.778730]   0032: 02 00 a6 00 00 00 00 00 61 6c 6c 6d 75 6c 74 69 
<4>[ 4173.778863]   0048: 00 00 00 00 00 00 00 33 33 00 00 00 01 01 00 5e 
<4>[ 4173.779116] dhd_stop: Enter eth0
<4>[ 4173.779382] dhdsdio_isr: Enter
<4>[ 4173.779469] dhdsdio_isr: disable SDIO interrupts
<4>[ 4173.779552] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4173.779635] dhdsdio_dpc: Enter
<4>[ 4173.779749] dhdsdio_clkctl: Enter
<4>[ 4173.780054] dhdsdio_readframes: Enter
<4>[ 4173.780251] RxHdr:
<4>[ 4173.780358]   0000: 29 00 d6 ff b4 00 00 0c 00 bc 00 00 
<4>[ 4173.780450] dhdsdio_read_control: Enter
<4>[ 4173.780523] RxCtrl:
<4>[ 4173.780616]   0000: 29 00 d6 ff b4 00 00 0c 00 bc 00 00 07 01 00 00 
<4>[ 4173.780751]   0016: 0d 00 00 00 00 00 a6 00 00 00 00 00 61 6c 6c 6d 
<4>[ 4173.780868]   0032: 75 6c 74 69 00 00 00 00 00 
<4>[ 4173.781051] RxHdr:
<4>[ 4173.781152]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.781245] dhdsdio_readframes: processed 1 frames
<4>[ 4173.781332] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4173.781478] dhdcdc_cmplt: Enter
<4>[ 4173.781553] dhd_bus_rxctl: Enter
<4>[ 4173.781629] dhd_bus_rxctl: resumed on rxctl frame, got 29 expected 29
<4>[ 4173.781734] dhd_prot_ioctl: Enter
<4>[ 4173.781799] dhdcdc_set_ioctl: Enter
<4>[ 4173.781866] dhdcdc_set_ioctl: cmd 10 len 4
<4>[ 4173.781937] dhdcdc_msg: Enter
<4>[ 4173.781996] dhd_bus_txctl: Enter
<4>[ 4173.782059] dhdsdio_clkctl: Enter
<4>[ 4173.782127] Tx Frame:
<4>[ 4173.782223]   0000: 2c 00 d3 ff b0 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4173.782358]   0016: 00 00 00 00 00 00 00 00 0a 00 00 00 04 00 00 00 
<4>[ 4173.782491]   0032: 02 00 a7 00 00 00 00 00 00 00 00 00 75 6c 74 69 
<4>[ 4173.782624]   0048: 00 00 00 00 00 00 00 33 33 00 00 00 01 01 00 5e 
<4>[ 4173.782921] dhd_get_stats: Enter
<4>[ 4173.794840] dhdsdio_isr: Enter
<4>[ 4173.794943] dhdsdio_isr: disable SDIO interrupts
<4>[ 4173.795033] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4173.795117] dhdsdio_dpc: Enter
<4>[ 4173.795242] dhd_watchdog_thread:
<4>[ 4173.795321] dhd_bus_watchdog: Enter
<4>[ 4173.795390] dhdsdio_clkctl: Enter
<4>[ 4173.795454] dhdsdio_htclk: Enter
<4>[ 4173.795602] CLKCTL: turned OFF
<4>[ 4173.795728] dhdsdio_sdclk: Enter
<4>[ 4173.795813] dhdsdio_clkctl: 3 -> 0
<4>[ 4173.795914] dhdsdio_clkctl: Enter
<4>[ 4173.795988] dhdsdio_sdclk: Enter
<4>[ 4173.796054] dhdsdio_htclk: Enter
<4>[ 4173.796309] CLKCTL: turned ON
<4>[ 4173.796402] dhdsdio_clkctl: 0 -> 3
<4>[ 4173.796690] dhdsdio_readframes: Enter
<4>[ 4173.796891] RxHdr:
<4>[ 4173.796998]   0000: 20 00 df ff b5 00 00 0c 00 bd 00 00 
<4>[ 4173.797090] dhdsdio_read_control: Enter
<4>[ 4173.797161] RxCtrl:
<4>[ 4173.797255]   0000: 20 00 df ff b5 00 00 0c 00 bd 00 00 0a 00 00 00 
<4>[ 4173.797389]   0016: 04 00 00 00 00 00 a7 00 00 00 00 00 00 00 00 00 
<4>[ 4173.797596] RxHdr:
<4>[ 4173.797698]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.797790] dhdsdio_readframes: processed 1 frames
<4>[ 4173.797877] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4173.798110] dhdcdc_cmplt: Enter
<4>[ 4173.798197] dhd_bus_rxctl: Enter
<4>[ 4173.798275] dhd_bus_rxctl: resumed on rxctl frame, got 20 expected 20
<4>[ 4173.804393] dhd_watchdog_thread:
<4>[ 4173.804496] dhd_bus_watchdog: Enter
<4>[ 4173.804570] dhdsdio_clkctl: Enter
<4>[ 4173.804636] dhdsdio_htclk: Enter
<4>[ 4173.804787] CLKCTL: turned OFF
<4>[ 4173.804866] dhdsdio_sdclk: Enter
<4>[ 4173.804936] dhdsdio_clkctl: 3 -> 0
<4>[ 4173.917052] dhd_device_event: [eth0] Down IP: 0x7f01a8c0
<4>[ 4173.917183] dhdcdc_set_ioctl: Enter
<4>[ 4173.917263] dhdcdc_set_ioctl: cmd 263 len 17
<4>[ 4173.917338] dhdcdc_msg: Enter
<4>[ 4173.917407] dhd_bus_txctl: Enter
<4>[ 4173.917477] dhdsdio_clkctl: Enter
<4>[ 4173.917541] dhdsdio_sdclk: Enter
<4>[ 4173.917602] dhdsdio_htclk: Enter
<4>[ 4173.920643] dhdsdio_isr: Enter
<4>[ 4173.920744] dhdsdio_isr: disable SDIO interrupts
<4>[ 4173.920831] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4173.920915] dhdsdio_dpc: Enter
<4>[ 4173.924515] CLKCTL: turned ON
<4>[ 4173.924626] dhdsdio_clkctl: 0 -> 3
<4>[ 4173.924703] Tx Frame:
<4>[ 4173.924801]   0000: 39 00 c6 ff b1 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4173.924937]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 11 00 00 00 
<4>[ 4173.925073]   0032: 02 00 a8 00 00 00 00 00 61 72 70 5f 68 6f 73 74 
<4>[ 4173.925209]   0048: 69 70 5f 63 6c 65 61 72 00 00 00 00 01 01 00 5e 
<4>[ 4173.925477] dhdsdio_clkctl: Enter
<4>[ 4173.925780] Dongle reports CHIPACTIVE
<4>[ 4173.925876] dhdsdio_readframes: Enter
<4>[ 4173.926060] RxHdr:
<4>[ 4173.926161]   0000: 2d 00 d2 ff b6 00 00 0c 00 be 00 00 
<4>[ 4173.926254] dhdsdio_read_control: Enter
<4>[ 4173.926325] RxCtrl:
<4>[ 4173.926420]   0000: 2d 00 d2 ff b6 00 00 0c 00 be 00 00 07 01 00 00 
<4>[ 4173.926556]   0016: 11 00 00 00 00 00 a8 00 00 00 00 00 61 72 70 5f 
<4>[ 4173.926684]   0032: 68 6f 73 74 69 70 5f 63 6c 65 61 72 00 
<4>[ 4173.926883] RxHdr:
<4>[ 4173.926984]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.927073] dhdsdio_readframes: processed 1 frames
<4>[ 4173.927157] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4173.927317] dhdcdc_cmplt: Enter
<4>[ 4173.927395] dhd_bus_rxctl: Enter
<4>[ 4173.927472] dhd_bus_rxctl: resumed on rxctl frame, got 33 expected 33
<4>[ 4173.927579] dhdcdc_set_ioctl: Enter
<4>[ 4173.927648] dhdcdc_set_ioctl: cmd 263 len 16
<4>[ 4173.927722] dhdcdc_msg: Enter
<4>[ 4173.927786] dhd_bus_txctl: Enter
<4>[ 4173.927852] dhdsdio_clkctl: Enter
<4>[ 4173.927921] Tx Frame:
<4>[ 4173.928016]   0000: 38 00 c7 ff b2 00 00 18 00 00 00 00 00 00 00 00 
<4>[ 4173.928149]   0016: 00 00 00 00 00 00 00 00 07 01 00 00 10 00 00 00 
<4>[ 4173.928284]   0032: 02 00 a9 00 00 00 00 00 61 72 70 5f 74 61 62 6c 
<4>[ 4173.928418]   0048: 65 5f 63 6c 65 61 72 00 00 00 00 00 01 01 00 5e 
<4>[ 4173.928640] dhdcdc_cmplt: Enter
<4>[ 4173.928722] dhd_bus_rxctl: Enter
<4>[ 4173.928925] dhdsdio_isr: Enter
<4>[ 4173.929009] dhdsdio_isr: disable SDIO interrupts
<4>[ 4173.929094] Calling dhdsdio_dpc() from dhdsdio_isr
<4>[ 4173.929182] dhdsdio_dpc: Enter
<4>[ 4173.929247] dhdsdio_clkctl: Enter
<4>[ 4173.929533] dhdsdio_readframes: Enter
<4>[ 4173.929730] RxHdr:
<4>[ 4173.929835]   0000: 2c 00 d3 ff b7 00 00 0c 00 bf 00 00 
<4>[ 4173.929928] dhdsdio_read_control: Enter
<4>[ 4173.929998] RxCtrl:
<4>[ 4173.930094]   0000: 2c 00 d3 ff b7 00 00 0c 00 bf 00 00 07 01 00 00 
<4>[ 4173.930229]   0016: 10 00 00 00 00 00 a9 00 00 00 00 00 61 72 70 5f 
<4>[ 4173.930357]   0032: 74 61 62 6c 65 5f 63 6c 65 61 72 00 
<4>[ 4173.930553] RxHdr:
<4>[ 4173.930654]   0000: 00 00 00 00 00 00 00 00 00 00 00 00 
<4>[ 4173.930744] dhdsdio_readframes: processed 1 frames
<4>[ 4173.930830] dhdsdio_dpc: enable SDIO interrupts, rxdone 1 framecnt 1
<4>[ 4173.930998] dhd_bus_rxctl: resumed on rxctl frame, got 32 expected 32
<4>[ 4173.934376] dhd_watchdog_thread:
<4>[ 4173.934478] dhd_bus_watchdog: Enter
<4>[ 4173.934553] dhdsdio_clkctl: Enter
<4>[ 4173.934619] dhdsdio_htclk: Enter
<4>[ 4173.934767] CLKCTL: turned OFF
<4>[ 4173.934851] dhdsdio_sdclk: Enter
<4>[ 4173.934922] dhdsdio_clkctl: 3 -> 0
<4>[ 4174.918690] dhd_module_cleanup: Enter
<4>[ 4174.918798] dhd_bus_unregister: Enter
<4>[ 4174.918939] dhdsdio_disconnect: Enter
<4>[ 4174.919023] dhdsdio_release: Enter
<4>[ 4174.920011] dhdsdio_release_dongle: Enter
<4>[ 4174.920117] dhdsdio_clkctl: Enter
<4>[ 4174.920190] dhdsdio_sdclk: Enter
<4>[ 4174.920257] dhdsdio_htclk: Enter
<4>[ 4174.926836] CLKCTL: turned ON
<4>[ 4174.926946] dhdsdio_clkctl: 0 -> 3
<4>[ 4174.927017] dhdsdio_clkctl: Enter
<4>[ 4174.927081] dhdsdio_htclk: Enter
<4>[ 4174.927220] CLKCTL: turned OFF
<4>[ 4174.927300] dhdsdio_sdclk: Enter
<4>[ 4174.927372] dhdsdio_clkctl: 3 -> 0
<4>[ 4174.927449] dhdsdio_release_dongle: Disconnected
<4>[ 4174.927530] dhd_detach: Enter
<4>[ 4174.928106] _dhd_sysioc_thread: stopped
<4>[ 4174.928386] dhd_stop: Enter eth0
<4>[ 4174.929056] dhd_get_stats: Enter
<4>[ 4174.944865] dhd_bus_detach: Enter
<4>[ 4174.944968] dhd_bus_stop: Enter
<4>[ 4174.945039] dhdsdio_clkctl: Enter
<4>[ 4174.945104] dhdsdio_sdclk: Enter
<4>[ 4174.945168] dhdsdio_htclk: Enter
<4>[ 4174.954524] CLKCTL: turned ON
<4>[ 4174.954632] dhdsdio_clkctl: 0 -> 3
<4>[ 4174.954986] dhd_bus_stop: disable SDIO interrupts
<4>[ 4174.955355] dhdsdio_clkctl: Enter
<4>[ 4174.955443] dhdsdio_htclk: Enter
<4>[ 4174.955582] CLKCTL: turned OFF
<4>[ 4174.955670] dhdsdio_clkctl: 3 -> 1
<4>[ 4174.955802] dhdsdio_release_malloc: Enter
<4>[ 4174.955891] dhdsdio_release: Disconnected
<4>[ 4174.955963] dhdsdio_disconnect: Disconnected
<4>[ 4174.969337] ## Unregister platform_driver_register
<4>[ 4174.969509] ## wifi_remove
<4>[ 4174.969584] wifi_set_power = 0
<4>[ 4174.969648] spica_wlan_set_power = 0
<4>[ 4174.969721] wifi_set_carddetect = 0
<4>[ 4174.969787] spica_wlan_set_carddetect = 0
<6>[ 4175.177757] mmc1: card 0001 removed

