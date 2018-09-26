Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0839BC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 04:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD6B220833
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 04:57:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hypervisor.org header.i=@hypervisor.org header.b="pQ8J3AmE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD6B220833
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hypervisor.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbeIZLII (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 07:08:08 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:14955 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbeIZLII (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 07:08:08 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2018 07:07:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1537937804;
        s=strato-dkim-0002; d=hypervisor.org;
        h=Message-ID:Subject:Cc:To:From:Date:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=UaYOCPEgknPwpkoNLRL8u6dDjlIUKAZTUs8RPorMRKk=;
        b=pQ8J3AmEcWPN3hJiImW9gje9K8OHdsfObodckS4aQkOkBIGkUvCy08yJh2bC3f14bJ
        7L0YbTCZzOk/nCKL/t6cReSJmroWzZsZalrenkZv25putDplwS69JaOHgYUxHQhRNsgX
        k1T9unyq+in0+ZDCcl2qcsqyIQChYm8aoAVlq2w7iMVEfgiIIIFVWGZzAbwo28SPutA/
        lH0U2a8SzKc2XB0uTHkxlT3E/blUq7xkXmacP+baFLUps/7fmCpEhfijwMVLufH26rfq
        QnpyxC+pKPpaD765ji5iKYh9psis6r5pmR8zt5La0lJEMhnpqSa+TzE9/jWjrv2DcaYs
        MaPA==
X-RZG-AUTH: ":OWgLVUixa/orYEjgByCmMbha6U0z53RZBchi0p8VsT1fAA5ylDfDtYqdhD+B/qtO5Rfvegs="
X-RZG-CLASS-ID: mo00
Received: from X220.hypervisor.org
        by smtp.strato.de (RZmta 44.2 DYNA|AUTH)
        with ESMTPSA id x048d3u8Q4oR42H
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 26 Sep 2018 06:50:27 +0200 (CEST)
Date:   Wed, 26 Sep 2018 06:50:26 +0200
From:   Udo Steinberg <udo@hypervisor.org>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org
Subject: iwlwifi crash with Linux 4.18.9
Message-ID: <20180926065026.029a4eba@X220.hypervisor.org>
X-Mailer: X-Mailer 5.0 Gold
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Qt4obznO8m4quz/GFb3Qj5K"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--MP_/Qt4obznO8m4quz/GFb3Qj5K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello all,

I'm experiencing an iwlwifi crash with Linux 4.18.9 in the following situation:
  1) I'm suspending the laptop (into S3 sleep state)
  2) Sometimes the laptop immediately wakes up again (as if a wake event fires)
  3) In the immediate wakeup case iwlwifi crashes

I'm not sure if in step 2), iwlwifi or something else is causing the immediate
S3 wakeup after suspend.

Full dmesg is attached.

Please CC: me on any replies as I'm not subscribed to the mailing lists.

Thanks,
Udo

[40676.001160] PM: suspend exit
[40678.564050] iwlwifi 0000:03:00.0: Error sending REPLY_SCAN_ABORT_CMD: time out after 2000ms.
[40678.564066] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 24 write_ptr 25
[40678.564106] iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
[40678.564281] iwlwifi 0000:03:00.0: 0x00000000 | OK
[40678.564282] iwlwifi 0000:03:00.0: 0x00000000 | uPc
[40678.564283] iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
[40678.564284] iwlwifi 0000:03:00.0: 0x00000000 | branchlink2
[40678.564285] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[40678.564286] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[40678.564287] iwlwifi 0000:03:00.0: 0x00000000 | data1
[40678.564288] iwlwifi 0000:03:00.0: 0x00000000 | data2
[40678.564289] iwlwifi 0000:03:00.0: 0x00000000 | line
[40678.564290] iwlwifi 0000:03:00.0: 0x00000000 | beacon time
[40678.564291] iwlwifi 0000:03:00.0: 0x00000000 | tsf low
[40678.564292] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[40678.564293] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[40678.564294] iwlwifi 0000:03:00.0: 0x00000000 | time gp2
[40678.564295] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[40678.564296] iwlwifi 0000:03:00.0: 0x00000000 | uCode version
[40678.564297] iwlwifi 0000:03:00.0: 0x00000000 | hw version
[40678.564298] iwlwifi 0000:03:00.0: 0x00000000 | board version
[40678.564299] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[40678.564300] iwlwifi 0000:03:00.0: 0x00000000 | isr0
[40678.564301] iwlwifi 0000:03:00.0: 0x00000000 | isr1
[40678.564302] iwlwifi 0000:03:00.0: 0x00000000 | isr2
[40678.564303] iwlwifi 0000:03:00.0: 0x00000000 | isr3
[40678.564304] iwlwifi 0000:03:00.0: 0x00000000 | isr4
[40678.564305] iwlwifi 0000:03:00.0: 0x00000000 | isr_pref
[40678.564306] iwlwifi 0000:03:00.0: 0x00000000 | wait_event
[40678.564307] iwlwifi 0000:03:00.0: 0x00000000 | l2p_control
[40678.564308] iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration
[40678.564309] iwlwifi 0000:03:00.0: 0x00000000 | l2p_mhvalid
[40678.564310] iwlwifi 0000:03:00.0: 0x00000000 | l2p_addr_match
[40678.564311] iwlwifi 0000:03:00.0: 0x00000000 | lmpm_pmg_sel
[40678.564311] iwlwifi 0000:03:00.0: 0x00000000 | timestamp
[40678.564312] iwlwifi 0000:03:00.0: 0x00000000 | flow_handler
[40678.564398] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: nothing in log
[40678.564406] iwlwifi 0000:03:00.0: Command REPLY_RXON failed: FW Error
[40678.564407] iwlwifi 0000:03:00.0: Error clearing ASSOC_MSK on BSS (-5)
[40678.575927] ieee80211 phy0: Hardware restart was requested
[40678.582344] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40678.876317] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40678.970186] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0

--MP_/Qt4obznO8m4quz/GFb3Qj5K
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.txt

[    0.000000] Linux version 4.18.9 (root@X220.hypervisor.org) (gcc version 8.2.0 (GCC)) #1 SMP PREEMPT Mon Aug 13 08:26:13 CEST 2018
[    0.000000] Command line: root=PARTUUID=1751cf38-c398-445c-98ad-601731aff852 rootfstype=ext4 sdhci.debug_quirks=0x40 acpi_osi=
[    0.000000] Disabled fast string operations
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000da59efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da59f000-0x00000000daa9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000daa9f000-0x00000000dab9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dab9f000-0x00000000dabfefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dabff000-0x00000000dabfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0xd462c018-0xd463c057] usable ==> usable
[    0.000000] e820: update [mem 0xd462c018-0xd463c057] usable ==> usable
[    0.000000] e820: update [mem 0xd461c018-0xd462b657] usable ==> usable
[    0.000000] e820: update [mem 0xd461c018-0xd462b657] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000058000-0x0000000000058fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x0000000000059000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000040200000-0x00000000d461c017] usable
[    0.000000] reserve setup_data: [mem 0x00000000d461c018-0x00000000d462b657] usable
[    0.000000] reserve setup_data: [mem 0x00000000d462b658-0x00000000d462c017] usable
[    0.000000] reserve setup_data: [mem 0x00000000d462c018-0x00000000d463c057] usable
[    0.000000] reserve setup_data: [mem 0x00000000d463c058-0x00000000da59efff] usable
[    0.000000] reserve setup_data: [mem 0x00000000da59f000-0x00000000daa9efff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000daa9f000-0x00000000dab9efff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000dab9f000-0x00000000dabfefff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000dabff000-0x00000000dabfffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000021e5fffff] usable
[    0.000000] efi: EFI v2.00 by Lenovo
[    0.000000] efi:  ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000 
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: LENOVO 4290W4H/4290W4H, BIOS 8DET76WW (1.46 ) 06/21/2018
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 0DAC00000 mask FFFC00000 uncachable
[    0.000000]   7 base 100000000 mask F00000000 write-back
[    0.000000]   8 base 200000000 mask FE0000000 write-back
[    0.000000]   9 base 21F000000 mask FFF000000 uncachable
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] last_pfn = 0xdac00 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [(____ptrval____)] 97000 size 24576
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] BRK [0x023e3000, 0x023e3fff] PGTABLE
[    0.000000] BRK [0x023e4000, 0x023e4fff] PGTABLE
[    0.000000] BRK [0x023e5000, 0x023e5fff] PGTABLE
[    0.000000] BRK [0x023e6000, 0x023e6fff] PGTABLE
[    0.000000] BRK [0x023e7000, 0x023e7fff] PGTABLE
[    0.000000] BRK [0x023e8000, 0x023e8fff] PGTABLE
[    0.000000] Secure boot disabled
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DABFE014 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000DABFE120 0000A4 (v01 LENOVO TP-8D    00001460 PTEC 00000002)
[    0.000000] ACPI: FACP 0x00000000DABE8000 0000F4 (v04 LENOVO TP-8D    00001460 PTL  00000002)
[    0.000000] ACPI: DSDT 0x00000000DABEB000 00FA89 (v01 LENOVO TP-8D    00001460 INTL 20061109)
[    0.000000] ACPI: FACS 0x00000000DAB2D000 000040
[    0.000000] ACPI: FACS 0x00000000DAB2D000 000040
[    0.000000] ACPI: SSDT 0x00000000DABFD000 000249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DABFC000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DABFB000 0007D1 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 0x00000000DABE7000 000038 (v01 LENOVO TP-8D    00001460 PTL  00000002)
[    0.000000] ACPI: APIC 0x00000000DABE6000 000098 (v01 LENOVO TP-8D    00001460 PTL  00000002)
[    0.000000] ACPI: MCFG 0x00000000DABE5000 00003C (v01 LENOVO TP-8D    00001460 PTL  00000002)
[    0.000000] ACPI: ECDT 0x00000000DABE4000 000052 (v01 LENOVO TP-8D    00001460 PTL  00000002)
[    0.000000] ACPI: ASF! 0x00000000DABEA000 0000A5 (v32 LENOVO TP-8D    00001460 PTL  00000002)
[    0.000000] ACPI: TCPA 0x00000000DABE3000 000032 (v02 PTL    LENOVO   06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 0x00000000DABE2000 000A69 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DABE1000 000996 (v01 PmRef  CpuPm    00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 0x00000000DABE0000 0000E8 (v01 INTEL  SNB      00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 0x00000000DABDF000 00003E (v01 LENOVO TP-8D    00001460 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000DABDE000 000042 (v01 PTL    COMBUF   00000001 PTL  00000001)
[    0.000000] ACPI: UEFI 0x00000000DABDD000 000292 (v01 LENOVO TP-8D    00001460 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000021e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.000000]   node   0: [mem 0x0000000000059000-0x000000000009ffff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020200000-0x000000003fffffff]
[    0.000000]   node   0: [mem 0x0000000040200000-0x00000000da59efff]
[    0.000000]   node   0: [mem 0x00000000dabff000-0x00000000dabfffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000021e5fffff]
[    0.000000] Reserved but unavailable: 24258 pages
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000021e5fffff]
[    0.000000] On node 0 totalpages: 2066238
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 158 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13895 pages used for memmap
[    0.000000]   DMA32 zone: 889248 pages, LIFO batch:31
[    0.000000]   Normal zone: 18328 pages used for memmap
[    0.000000]   Normal zone: 1172992 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics memory at [mem 0xdba00000-0xdf9fffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd461c000-0xd461cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xd462b000-0xd462bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xd462c000-0xd462cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xd463c000-0xd463cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xda59f000-0xdaa9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdaa9f000-0xdab9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdab9f000-0xdabfefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdac00000-0xdb9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdba00000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf80f7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xf80f8000-0xf80f8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xf80f9000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xffffffff]
[    0.000000] [mem 0xdfa00000-0xf80f7fff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] random: get_random_bytes called from start_kernel+0x88/0x41f with crng_init=0
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] percpu: Embedded 40 pages/cpu @(____ptrval____) s133336 r0 d30504 u262144
[    0.000000] pcpu-alloc: s133336 r0 d30504 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 2033793
[    0.000000] Kernel command line: root=PARTUUID=1751cf38-c398-445c-98ad-601731aff852 rootfstype=ext4 sdhci.debug_quirks=0x40 acpi_osi=
[    0.000000] ACPI: _OSI method disabled
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Memory: 7972628K/8264952K available (10248K kernel code, 500K rwdata, 2764K rodata, 924K init, 488K bss, 292324K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Kernel/User page tables isolation: enabled
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] NR_IRQS: 4352, nr_irqs: 488, preallocated irqs: 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ACPI: Core revision 20180531
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] APIC: Switch to symmetric I/O mode setup
[    0.000000] DMAR: Host address width 36
[    0.000000] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.000000] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.000000] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.000000] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.000000] DMAR: RMRR base: 0x000000da8d5000 end: 0x000000da8ebfff
[    0.000000] DMAR: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.000000] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.000000] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.000000] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.000000] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.000000] x2apic enabled
[    0.000000] Switched APIC routing to cluster x2apic.
[    0.000000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.020000] tsc: Fast TSC calibration using PIT
[    0.024000] tsc: Detected 2691.021 MHz processor
[    0.024000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x26ca1c6f25f, max_idle_ns: 440795326655 ns
[    0.024000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5382.04 BogoMIPS (lpj=10764084)
[    0.024000] pid_max: default: 32768 minimum: 301
[    0.024000] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.024000] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.024000] Disabled fast string operations
[    0.024000] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.024000] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.024000] mce: CPU supports 7 MCE banks
[    0.024000] CPU0: Thermal monitoring enabled (TM1)
[    0.024000] process: using mwait in idle threads
[    0.024000] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.024000] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.024000] Spectre V2 : Mitigation: Full generic retpoline
[    0.024000] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.024000] Spectre V2 : Spectre v2 mitigation: Enabling Indirect Branch Prediction Barrier
[    0.024000] Spectre V2 : Enabling Restricted Speculation for firmware calls
[    0.024000] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
[    0.024000] Freeing SMP alternatives memory: 28K
[    0.029333] TSC deadline timer enabled
[    0.029336] smpboot: CPU0: Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz (family: 0x6, model: 0x2a, stepping: 0x7)
[    0.052019] Performance Events: PEBS fmt1+, SandyBridge events, 16-deep LBR, full-width counters, Intel PMU driver.
[    0.052094] ... version:                3
[    0.052100] ... bit width:              48
[    0.052105] ... generic registers:      4
[    0.052112] ... value mask:             0000ffffffffffff
[    0.052119] ... max period:             00007fffffffffff
[    0.052125] ... fixed-purpose events:   3
[    0.052138] ... event mask:             000000070000000f
[    0.060008] Hierarchical SRCU implementation.
[    0.076007] smp: Bringing up secondary CPUs ...
[    0.108022] x86: Booting SMP configuration:
[    0.108031] .... node  #0, CPUs:      #1
[    0.004000] Disabled fast string operations
[    0.140024]  #2
[    0.004000] Disabled fast string operations
[    0.172024]  #3
[    0.004000] Disabled fast string operations
[    0.174990] smp: Brought up 1 node, 4 CPUs
[    0.174990] smpboot: Max logical packages: 2
[    0.174990] smpboot: Total of 4 processors activated (21528.16 BogoMIPS)
[    0.176185] devtmpfs: initialized
[    0.176190] PM: Registering ACPI NVS region [mem 0x00058000-0x00058fff] (4096 bytes)
[    0.176190] PM: Registering ACPI NVS region [mem 0xdaa9f000-0xdab9efff] (1048576 bytes)
[    0.176190] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.176190] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.176190] NET: Registered protocol family 16
[    0.176316] cpuidle: using governor menu
[    0.176316] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.176316] ACPI: bus type PCI registered
[    0.176316] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.176316] PCI: not using MMCONFIG
[    0.176316] PCI: Using configuration type 1 for base access
[    0.176316] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
[    0.178162] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.178162] cryptd: max_cpu_qlen set to 1000
[    0.178162] ACPI: Added _OSI(Module Device)
[    0.178162] ACPI: Added _OSI(Processor Device)
[    0.178162] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.178162] ACPI: Added _OSI(Processor Aggregator Device)
[    0.178162] ACPI: Added _OSI(Linux-Dell-Video)
[    0.178162] ACPI: EC: EC started
[    0.178162] ACPI: EC: interrupt blocked
[    0.178162] ACPI: \: Used as first EC
[    0.178162] ACPI: \: GPE=0x11, EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.178162] ACPI: \: Used as boot ECDT EC to handle transactions
[    0.189366] ACPI: 6 ACPI AML tables successfully acquired and loaded
[    0.196424] ACPI: Dynamic OEM Table Load:
[    0.196433] ACPI: SSDT 0xFFFF880214A60000 0008C0 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.196827] ACPI: Dynamic OEM Table Load:
[    0.196834] ACPI: SSDT 0xFFFF880215016000 000303 (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.197089] ACPI: Dynamic OEM Table Load:
[    0.197095] ACPI: SSDT 0xFFFF8802148F9C00 000119 (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.197776] ACPI: Interpreter enabled
[    0.197795] ACPI: (supports S0 S3 S4 S5)
[    0.197797] ACPI: Using IOAPIC for interrupt routing
[    0.197820] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.198246] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.198257] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.198467] ACPI: Enabled 6 GPEs in block 00 to 3F
[    0.202499] ACPI: Power Resource [PUBS] (on)
[    0.202627] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.203830] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.206818] acpi IBM0079:00: ACPI dock station (docks/bays count: 3)
[    0.207214] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.207281] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.207346] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.207411] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.207475] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.207540] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.207604] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.207668] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.207747] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.207753] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.207917] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability LTR]
[    0.207996] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.208000] acpi PNP0A08:00: _OSC: OS requested [PME PCIeCapability LTR]
[    0.208003] acpi PNP0A08:00: _OSC: platform willing to grant [PME]
[    0.208006] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.208011] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.208056] PCI host bridge to bus 0000:00
[    0.208059] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.208063] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.208066] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.208069] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff window]
[    0.208073] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff window]
[    0.208077] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.208086] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.208164] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.208174] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.208180] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.208183] pci 0000:00:02.0: reg 0x20: [io  0x5000-0x503f]
[    0.208276] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.208300] pci 0000:00:16.0: reg 0x10: [mem 0xf2625000-0xf262500f 64bit]
[    0.208371] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.208438] pci 0000:00:16.3: [8086:1c3d] type 00 class 0x070002
[    0.208459] pci 0000:00:16.3: reg 0x10: [io  0x50b0-0x50b7]
[    0.208468] pci 0000:00:16.3: reg 0x14: [mem 0xf262c000-0xf262cfff]
[    0.208601] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.208621] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
[    0.208630] pci 0000:00:19.0: reg 0x14: [mem 0xf262b000-0xf262bfff]
[    0.208638] pci 0000:00:19.0: reg 0x18: [io  0x5080-0x509f]
[    0.208696] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.208765] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.208787] pci 0000:00:1a.0: reg 0x10: [mem 0xf262a000-0xf262a3ff]
[    0.208869] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.208941] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.208962] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.209035] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.209107] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.209233] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.209258] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    0.209263] pci 0000:00:1c.0: Intel PCH root port ACS workaround enabled
[    0.209342] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.209481] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.209503] pci 0000:00:1c.1: Enabling MPC IRBNCE
[    0.209508] pci 0000:00:1c.1: Intel PCH root port ACS workaround enabled
[    0.209588] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.209724] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.209746] pci 0000:00:1c.3: Enabling MPC IRBNCE
[    0.209750] pci 0000:00:1c.3: Intel PCH root port ACS workaround enabled
[    0.209821] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.209902] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.209917] pci 0000:00:1c.4: Enabling MPC IRBNCE
[    0.209922] pci 0000:00:1c.4: Intel PCH root port ACS workaround enabled
[    0.209991] pci 0000:00:1c.6: [8086:1c1c] type 01 class 0x060400
[    0.210071] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.210087] pci 0000:00:1c.6: Enabling MPC IRBNCE
[    0.210091] pci 0000:00:1c.6: Intel PCH root port ACS workaround enabled
[    0.210161] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.210182] pci 0000:00:1d.0: reg 0x10: [mem 0xf2629000-0xf26293ff]
[    0.210265] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.210337] pci 0000:00:1f.0: [8086:1c4f] type 00 class 0x060100
[    0.210503] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.210520] pci 0000:00:1f.2: reg 0x10: [io  0x50a8-0x50af]
[    0.210528] pci 0000:00:1f.2: reg 0x14: [io  0x50bc-0x50bf]
[    0.210535] pci 0000:00:1f.2: reg 0x18: [io  0x50a0-0x50a7]
[    0.210543] pci 0000:00:1f.2: reg 0x1c: [io  0x50b8-0x50bb]
[    0.210551] pci 0000:00:1f.2: reg 0x20: [io  0x5060-0x507f]
[    0.210558] pci 0000:00:1f.2: reg 0x24: [mem 0xf2628000-0xf26287ff]
[    0.210598] pci 0000:00:1f.2: PME# supported from D3hot
[    0.210663] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.210682] pci 0000:00:1f.3: reg 0x10: [mem 0xf2624000-0xf26240ff 64bit]
[    0.210703] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.210830] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.211029] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
[    0.211211] pci 0000:03:00.0: reg 0x10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.211881] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.212178] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.212188] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.212251] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.212258] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.212263] pci 0000:00:1c.3:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.212271] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.212396] pci 0000:0d:00.0: [1180:e823] type 00 class 0x088001
[    0.212441] pci 0000:0d:00.0: reg 0x10: [mem 0xf1500000-0xf15000ff]
[    0.212654] pci 0000:0d:00.0: supports D1 D2
[    0.212656] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.212991] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.212997] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.213001] pci 0000:00:1c.4:   bridge window [mem 0xf1500000-0xf1cfffff]
[    0.213006] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.213068] pci 0000:0e:00.0: [1033:0194] type 00 class 0x0c0330
[    0.213109] pci 0000:0e:00.0: reg 0x10: [mem 0xf1400000-0xf1401fff 64bit]
[    0.213255] pci 0000:0e:00.0: PME# supported from D0 D3hot D3cold
[    0.213348] pci 0000:00:1c.6: PCI bridge to [bus 0e]
[    0.213356] pci 0000:00:1c.6:   bridge window [mem 0xf1400000-0xf14fffff]
[    0.213400] pci_bus 0000:00: on NUMA node 0
[    0.215287] ACPI: EC: interrupt unblocked
[    0.215304] ACPI: EC: event unblocked
[    0.215313] ACPI: \_SB_.PCI0.LPC_.EC__: GPE=0x11, EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.215317] ACPI: \_SB_.PCI0.LPC_.EC__: Used as boot DSDT EC to handle transactions and events
[    0.215381] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.215381] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.215381] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.215381] vgaarb: loaded
[    0.215381] SCSI subsystem initialized
[    0.215381] libata version 3.00 loaded.
[    0.215381] ACPI: bus type USB registered
[    0.215381] usbcore: registered new interface driver usbfs
[    0.215381] usbcore: registered new interface driver hub
[    0.215381] usbcore: registered new device driver usb
[    0.215381] Registered efivars operations
[    0.239211] Advanced Linux Sound Architecture Driver Initialized.
[    0.239220] PCI: Using ACPI for IRQ routing
[    0.240861] PCI: pci_cache_line_size set to 64 bytes
[    0.241295] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.241297] e820: reserve RAM buffer [mem 0xd461c018-0xd7ffffff]
[    0.241298] e820: reserve RAM buffer [mem 0xd462c018-0xd7ffffff]
[    0.241299] e820: reserve RAM buffer [mem 0xda59f000-0xdbffffff]
[    0.241300] e820: reserve RAM buffer [mem 0xdac00000-0xdbffffff]
[    0.241301] e820: reserve RAM buffer [mem 0x21e600000-0x21fffffff]
[    0.241404] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.241404] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.242093] clocksource: Switched to clocksource tsc-early
[    0.242150] pnp: PnP ACPI init
[    0.242523] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.242527] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.242530] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.242534] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.242537] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.242541] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.242544] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.242547] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.242551] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.242554] system 00:00: [mem 0x000e0000-0x000e3fff] has been reserved
[    0.242557] system 00:00: [mem 0x000e4000-0x000e7fff] has been reserved
[    0.242560] system 00:00: [mem 0x000e8000-0x000ebfff] has been reserved
[    0.242564] system 00:00: [mem 0x000ec000-0x000effff] has been reserved
[    0.242567] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.242571] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.242574] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.242578] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.242586] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.242586] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.242586] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.242586] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.242586] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.242586] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.242586] system 00:01: [mem 0xf8000000-0xfbffffff] could not be reserved
[    0.242586] system 00:01: [mem 0x00000000-0x00000fff] could not be reserved
[    0.242586] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.242586] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.242586] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.242586] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.242586] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.242586] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.242586] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.242586] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.242586] pnp 00:04: Plug and Play ACPI device, IDs LEN0020 PNP0f13 (active)
[    0.242586] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.242586] pnp: PnP ACPI: found 6 devices
[    0.246935] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.246935] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.246935] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.246935] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000 add_align 100000
[    0.246935] pci 0000:00:1c.0: BAR 8: assigned [mem 0xdfa00000-0xdfbfffff]
[    0.246935] pci 0000:00:1c.0: BAR 9: assigned [mem 0xdfc00000-0xdfdfffff 64bit pref]
[    0.246935] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
[    0.246935] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.246935] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.246935] pci 0000:00:1c.0:   bridge window [mem 0xdfa00000-0xdfbfffff]
[    0.246935] pci 0000:00:1c.0:   bridge window [mem 0xdfc00000-0xdfdfffff 64bit pref]
[    0.246935] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.246935] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.246935] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.246935] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.246935] pci 0000:00:1c.3:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.246935] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.246935] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.246935] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.246935] pci 0000:00:1c.4:   bridge window [mem 0xf1500000-0xf1cfffff]
[    0.246935] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.246935] pci 0000:00:1c.6: PCI bridge to [bus 0e]
[    0.246935] pci 0000:00:1c.6:   bridge window [mem 0xf1400000-0xf14fffff]
[    0.246935] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.246935] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.246935] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.246935] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff window]
[    0.246935] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff window]
[    0.246935] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.246935] pci_bus 0000:02: resource 1 [mem 0xdfa00000-0xdfbfffff]
[    0.246935] pci_bus 0000:02: resource 2 [mem 0xdfc00000-0xdfdfffff 64bit pref]
[    0.246935] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    0.246935] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.246935] pci_bus 0000:05: resource 1 [mem 0xf1d00000-0xf24fffff]
[    0.246935] pci_bus 0000:05: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.246935] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.246935] pci_bus 0000:0d: resource 1 [mem 0xf1500000-0xf1cfffff]
[    0.246935] pci_bus 0000:0d: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.246935] pci_bus 0000:0e: resource 1 [mem 0xf1400000-0xf14fffff]
[    0.246935] NET: Registered protocol family 2
[    0.246935] tcp_listen_portaddr_hash hash table entries: 4096 (order: 4, 65536 bytes)
[    0.246935] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.246935] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.248108] TCP: Hash tables configured (established 65536 bind 65536)
[    0.248144] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.248166] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.248225] NET: Registered protocol family 1
[    0.248332] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.256175] PCI: CLS 64 bytes, default 64
[    0.256200] DMAR: No ATSR found
[    0.256305] DMAR: dmar0: Using Queued invalidation
[    0.256312] DMAR: dmar1: Using Queued invalidation
[    0.256517] DMAR: Setting RMRR:
[    0.256661] DMAR: Setting identity map for device 0000:00:02.0 [0xdb800000 - 0xdf9fffff]
[    0.257176] DMAR: Setting identity map for device 0000:00:1a.0 [0xda8d5000 - 0xda8ebfff]
[    0.257324] DMAR: Setting identity map for device 0000:00:1d.0 [0xda8d5000 - 0xda8ebfff]
[    0.257337] DMAR: Prepare 0-16MiB unity mapping for LPC
[    0.257469] DMAR: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    0.257757] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    0.257801] iommu: Adding device 0000:00:00.0 to group 0
[    0.257811] iommu: Adding device 0000:00:02.0 to group 1
[    0.257827] iommu: Adding device 0000:00:16.0 to group 2
[    0.257835] iommu: Adding device 0000:00:16.3 to group 2
[    0.257844] iommu: Adding device 0000:00:19.0 to group 3
[    0.257854] iommu: Adding device 0000:00:1a.0 to group 4
[    0.257862] iommu: Adding device 0000:00:1b.0 to group 5
[    0.257872] iommu: Adding device 0000:00:1c.0 to group 6
[    0.257882] iommu: Adding device 0000:00:1c.1 to group 7
[    0.257891] iommu: Adding device 0000:00:1c.3 to group 8
[    0.257900] iommu: Adding device 0000:00:1c.4 to group 9
[    0.257910] iommu: Adding device 0000:00:1c.6 to group 10
[    0.257919] iommu: Adding device 0000:00:1d.0 to group 11
[    0.257935] iommu: Adding device 0000:00:1f.0 to group 12
[    0.257944] iommu: Adding device 0000:00:1f.2 to group 12
[    0.257953] iommu: Adding device 0000:00:1f.3 to group 12
[    0.257963] iommu: Adding device 0000:03:00.0 to group 13
[    0.257972] iommu: Adding device 0000:0d:00.0 to group 14
[    0.257981] iommu: Adding device 0000:0e:00.0 to group 15
[    0.259298] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 163840 ms ovfl timer
[    0.259303] RAPL PMU: hw unit of domain pp0-core 2^-16 Joules
[    0.259305] RAPL PMU: hw unit of domain package 2^-16 Joules
[    0.259307] RAPL PMU: hw unit of domain pp1-gpu 2^-16 Joules
[    0.260245] Initialise system trusted keyrings
[    0.260276] workingset: timestamp_bits=62 max_order=21 bucket_order=0
[    0.261875] Key type cifs.idmap registered
[    0.261879] ntfs: driver 2.1.32 [Flags: R/O].
[    0.262788] Key type asymmetric registered
[    0.262792] Asymmetric key parser 'x509' registered
[    0.262798] io scheduler noop registered (default)
[    0.262800] io scheduler deadline registered
[    0.262842] io scheduler cfq registered
[    0.262845] io scheduler mq-deadline registered
[    0.262847] io scheduler kyber registered
[    0.262868] io scheduler bfq registered
[    0.262946] pcieport 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.263460] intel_idle: MWAIT substates: 0x21120
[    0.263460] intel_idle: v0.4.1 model 0x2A
[    0.263609] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.263793] ACPI: AC Adapter [AC] (on-line)
[    0.263852] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.263864] ACPI: Lid Switch [LID]
[    0.263901] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.263910] ACPI: Sleep Button [SLPB]
[    0.263953] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.263960] ACPI: Power Button [PWRF]
[    0.265605] thermal LNXTHERM:00: registered as thermal_zone0
[    0.265609] ACPI: Thermal Zone [THM0] (61 C)
[    0.265794] Non-volatile memory driver v1.3
[    0.276068] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
[    0.279570] ACPI: Battery Slot [BAT0] (battery present)
[    0.317313] [drm] Disabling PPGTT because VT-d is on
[    0.317332] [drm] VT-d active for gfx access
[    0.317334] [drm] Replacing VGA console driver
[    0.317348] [drm] DMAR active, disabling use of stolen memory
[    0.328189] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.328195] [drm] Driver supports precise vblank timestamp query.
[    0.328400] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.439149] [drm] Initialized i915 1.6.0 20180514 for 0000:00:02.0 on minor 0
[    0.439613] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.440789] acpi device:00: registered as cooling_device4
[    0.440858] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    0.442221] loop: module loaded
[    0.442300] ahci 0000:00:1f.2: version 3.0
[    0.442459] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.456087] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x17 impl SATA mode
[    0.456108] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    0.492707] scsi host0: ahci
[    0.492956] scsi host1: ahci
[    0.493178] scsi host2: ahci
[    0.493324] scsi host3: ahci
[    0.493432] scsi host4: ahci
[    0.493528] scsi host5: ahci
[    0.493588] ata1: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628100 irq 28
[    0.493593] ata2: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628180 irq 28
[    0.493597] ata3: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628200 irq 28
[    0.493600] ata4: DUMMY
[    0.493603] ata5: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628300 irq 28
[    0.493606] ata6: DUMMY
[    0.493635] tun: Universal TUN/TAP device driver, 1.6
[    0.493688] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    0.493691] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    0.493827] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.693989] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) f0:de:f1:92:76:91
[    0.694000] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.694035] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[    0.694062] Intel(R) Wireless WiFi driver for Linux
[    0.694064] Copyright(c) 2003- 2015 Intel Corporation
[    0.694229] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    0.695070] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1 op_mode iwldvm
[    0.695088] fbcon: inteldrmfb (fb0) is primary device
[    0.695215] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    0.695216] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    0.695217] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    0.695219] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, REV=0xB0
[    0.728291] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    0.728436] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.728437] ehci-pci: EHCI PCI platform driver
[    0.728555] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.728561] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.728574] ehci-pci 0000:00:1a.0: debug port 2
[    0.732491] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.732508] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf262a000
[    0.748105] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.748192] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 4.18
[    0.748193] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.748195] usb usb1: Product: EHCI Host Controller
[    0.748196] usb usb1: Manufacturer: Linux 4.18.9 ehci_hcd
[    0.748197] usb usb1: SerialNumber: 0000:00:1a.0
[    0.748379] hub 1-0:1.0: USB hub found
[    0.748386] hub 1-0:1.0: 3 ports detected
[    0.748621] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.748626] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.748637] ehci-pci 0000:00:1d.0: debug port 2
[    0.752543] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.752559] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf2629000
[    0.768106] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.768193] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 4.18
[    0.768195] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.768196] usb usb2: Product: EHCI Host Controller
[    0.768198] usb usb2: Manufacturer: Linux 4.18.9 ehci_hcd
[    0.768199] usb usb2: SerialNumber: 0000:00:1d.0
[    0.768383] hub 2-0:1.0: USB hub found
[    0.768391] hub 2-0:1.0: 3 ports detected
[    0.768607] xhci_hcd 0000:0e:00.0: xHCI Host Controller
[    0.768612] xhci_hcd 0000:0e:00.0: new USB bus registered, assigned bus number 3
[    0.768911] xhci_hcd 0000:0e:00.0: hcc params 0x014042cb hci version 0x96 quirks 0x0000000000000004
[    0.769158] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 4.18
[    0.769160] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.769161] usb usb3: Product: xHCI Host Controller
[    0.769162] usb usb3: Manufacturer: Linux 4.18.9 xhci-hcd
[    0.769163] usb usb3: SerialNumber: 0000:0e:00.0
[    0.769305] hub 3-0:1.0: USB hub found
[    0.769315] hub 3-0:1.0: 2 ports detected
[    0.769420] xhci_hcd 0000:0e:00.0: xHCI Host Controller
[    0.769423] xhci_hcd 0000:0e:00.0: new USB bus registered, assigned bus number 4
[    0.769427] xhci_hcd 0000:0e:00.0: Host supports USB 3.0  SuperSpeed
[    0.772188] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    0.772204] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 4.18
[    0.772206] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.772207] usb usb4: Product: xHCI Host Controller
[    0.772208] usb usb4: Manufacturer: Linux 4.18.9 xhci-hcd
[    0.772209] usb usb4: SerialNumber: 0000:0e:00.0
[    0.772353] hub 4-0:1.0: USB hub found
[    0.772364] hub 4-0:1.0: 2 ports detected
[    0.772480] usbcore: registered new interface driver usb-storage
[    0.772505] usbcore: registered new interface driver pl2303
[    0.772511] usbserial: USB Serial support registered for pl2303
[    0.772547] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.775500] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.775524] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.775669] mousedev: PS/2 mouse device common for all mice
[    0.775841] rtc_cmos 00:02: RTC can wake from S4
[    0.775989] rtc_cmos 00:02: registered as rtc0
[    0.776011] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.776122] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    0.777450] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) initialised: dm-devel@redhat.com
[    0.777454] intel_pstate: Intel P-state driver initializing
[    0.778307] EFI Variables Facility v0.08 2004-May-17
[    0.780948] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    0.808082] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.810144] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.810145] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.810147] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.812552] usbcore: registered new interface driver usbhid
[    0.812553] usbhid: USB HID core driver
[    0.812757] NET: Registered protocol family 17
[    0.812923] AVX version of gcm_enc/dec engaged.
[    0.812924] AES CTR mode by8 optimization enabled
[    0.813173] sched_clock: Marking stable (813170321, 0)->(794461335, 18708986)
[    0.813256] Loading compiled-in X.509 certificates
[    0.813390] rtc_cmos 00:02: setting system clock to 2018-09-25 09:43:55 UTC (1537868635)
[    0.813420] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    0.813680] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    0.842333] ata1.00: ATA-8: ST320LT007-9ZV142, 0004LVM1, max UDMA/133
[    0.842339] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 32)
[    0.845789] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.845797] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.845803] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.848672] ata1.00: configured for UDMA/133
[    1.084103] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.104109] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.104158] usb 3-2: new high-speed USB device number 2 using xhci_hcd
[    1.169277] random: fast init done
[    1.244876] usb 1-1: New USB device found, idVendor=8087, idProduct=0024, bcdDevice= 0.00
[    1.244883] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.245548] hub 1-1:1.0: USB hub found
[    1.245959] hub 1-1:1.0: 6 ports detected
[    1.253464] usb 3-2: New USB device found, idVendor=17ef, idProduct=100a, bcdDevice= 0.00
[    1.253471] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.255289] hub 3-2:1.0: USB hub found
[    1.255640] hub 3-2:1.0: 6 ports detected
[    1.260384] usb 2-1: New USB device found, idVendor=8087, idProduct=0024, bcdDevice= 0.00
[    1.260390] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.261092] hub 2-1:1.0: USB hub found
[    1.261225] hub 2-1:1.0: 8 ports detected
[    1.280071] tsc: Refined TSC clocksource calibration: 2691.256 MHz
[    1.280091] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x26caf9f5a53, max_idle_ns: 440795206420 ns
[    1.280128] clocksource: Switched to clocksource tsc
[    1.532109] usb 1-1.3: new full-speed USB device number 3 using ehci-pci
[    1.543443] [drm:intel_cpu_fifo_underrun_irq_handler] *ERROR* CPU pipe A FIFO underrun
[    1.543936] [drm:intel_set_pch_fifo_underrun_reporting] *ERROR* uncleared pch fifo underrun on pch transcoder A
[    1.543942] [drm:cpt_irq_handler] *ERROR* PCH transcoder A FIFO underrun
[    1.548082] usb 3-2.1: new high-speed USB device number 3 using xhci_hcd
[    1.559783] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops 0xffffffff81c7fc00)
[    1.569337] snd_hda_codec_conexant hdaudioC0D0: CX20590: BIOS auto-probing.
[    1.569851] snd_hda_codec_conexant hdaudioC0D0: autoconfig for CX20590: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
[    1.569857] snd_hda_codec_conexant hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    1.569862] snd_hda_codec_conexant hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
[    1.569866] snd_hda_codec_conexant hdaudioC0D0:    mono: mono_out=0x0
[    1.569870] snd_hda_codec_conexant hdaudioC0D0:    inputs:
[    1.569875] snd_hda_codec_conexant hdaudioC0D0:      Internal Mic=0x23
[    1.569880] snd_hda_codec_conexant hdaudioC0D0:      Mic=0x1b
[    1.569884] snd_hda_codec_conexant hdaudioC0D0:      Dock Mic=0x1a
[    1.571364] snd_hda_codec_conexant hdaudioC0D0: Enable sync_write for stable communication
[    1.578304] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    1.578933] Console: switching to colour frame buffer device 170x48
[    1.596817] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input6
[    1.597313] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.642320] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    1.643604] scsi 0:0:0:0: Direct-Access     ATA      ST320LT007-9ZV14 LVM1 PQ: 0 ANSI: 5
[    1.644928] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    1.645663] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.645706] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.646444] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    1.647108] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.647866] input: HDA Intel PCH Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    1.648576] sd 0:0:0:0: [sda] Write Protect is off
[    1.649321] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    1.650024] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.650738] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016, bcdDevice= 0.02
[    1.651464] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.652179] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.680354] usb 1-1.3: Product: Biometric Coprocessor
[    1.681194] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    1.682066] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    1.682933] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    1.683789] usb 1-1.3: Manufacturer: UPEK
[    1.685525] usb 3-2.1: New USB device found, idVendor=0525, idProduct=127a, bcdDevice= 1.01
[    1.686455] usb 3-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.687288] usb 3-2.1: Product: Ajays USB 2.0 Debug Cable
[    1.688103] usb 3-2.1: Manufacturer: Ajays Technology
[    1.688906] usb 3-2.1: SerialNumber: Ajays001
[    1.755120]  sda: sda1 sda2
[    1.756121] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.764088] usb 1-1.4: new full-speed USB device number 4 using ehci-pci
[    1.772113] usb 3-2.2: new full-speed USB device number 4 using xhci_hcd
[    1.877091] usb 3-2.2: New USB device found, idVendor=067b, idProduct=2303, bcdDevice= 3.00
[    1.879529] usb 3-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.881925] usb 3-2.2: Product: USB-Serial Controller
[    1.884289] usb 3-2.2: Manufacturer: Prolific Technology Inc.
[    1.885693] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f, bcdDevice= 7.48
[    1.886608] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.887484] usb 1-1.4: Product: Broadcom Bluetooth Device
[    1.888377] usb 1-1.4: Manufacturer: Broadcom Corp
[    1.889254] usb 1-1.4: SerialNumber: 402CF45418C0
[    1.894396] pl2303 3-2.2:1.0: pl2303 converter detected
[    1.902480] usb 3-2.2: pl2303 converter now attached to ttyUSB0
[    1.958735] ata2: SATA link down (SStatus 0 SControl 300)
[    1.968008] usb 1-1.6: new high-speed USB device number 5 using ehci-pci
[    1.988157] usb 3-2.4: new low-speed USB device number 5 using xhci_hcd
[    2.083258] usb 1-1.6: New USB device found, idVendor=04f2, idProduct=b217, bcdDevice= 8.54
[    2.086085] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.088847] usb 1-1.6: Product: Integrated Camera
[    2.091634] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    2.098079] usb 3-2.4: New USB device found, idVendor=0529, idProduct=0001, bcdDevice= 3.25
[    2.098975] usb 3-2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.099785] usb 3-2.4: Product: HASP HL 3.25
[    2.100579] usb 3-2.4: Manufacturer: AKS
[    2.275791] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.279054] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.279063] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.281641] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.283224] ata3.00: ATA-7: INTEL SSDMAEMC080G2, 2CV102M3, max UDMA/133
[    2.284266] ata3.00: 156301488 sectors, multi 1: LBA48 NCQ (depth 32)
[    2.285938] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.285941] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.286943] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.288389] ata3.00: configured for UDMA/133
[    2.300066] scsi 2:0:0:0: Direct-Access     ATA      INTEL SSDMAEMC08 02M3 PQ: 0 ANSI: 5
[    2.302837] ata3.00: Enabling discard_zeroes_data
[    2.303081] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    2.306677] sd 2:0:0:0: [sdb] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    2.311539] sd 2:0:0:0: [sdb] Write Protect is off
[    2.313492] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.313524] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.315851] ata3.00: Enabling discard_zeroes_data
[    2.320866]  sdb: sdb1 sdb2 sdb3
[    2.321957] ata3.00: Enabling discard_zeroes_data
[    2.322684] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.623915] ata5: SATA link down (SStatus 0 SControl 300)
[    2.627826] ALSA device list:
[    2.630055]   #0: HDA Intel PCH at 0xf2620000 irq 36
[    2.637383] EXT4-fs (sdb3): mounted filesystem with ordered data mode. Opts: (null)
[    2.638295] VFS: Mounted root (ext4 filesystem) readonly on device 8:19.
[    2.640822] devtmpfs: mounted
[    2.642451] Freeing unused kernel image memory: 924K
[    2.643247] Write protecting the kernel read-only data: 16384k
[    2.645198] Freeing unused kernel image memory: 2016K
[    2.646665] Freeing unused kernel image memory: 1332K
[    2.838988] random: udevd: uninitialized urandom read (16 bytes read)
[    2.840854] random: udevd: uninitialized urandom read (16 bytes read)
[    2.842096] random: udevd: uninitialized urandom read (16 bytes read)
[    2.904373] udevd[182]: starting eudev-3.2.6
[    2.947431] udevd[198]: ignoring invalid mode '@GROUP_RENDER_MODE@'
[   28.202629] Adding 8388604k swap on /dev/mapper/swap.  Priority:-2 extents:1 across:8388604k SS
[   29.068449] EXT4-fs (sdb3): re-mounted. Opts: discard
[   32.460665] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   33.342447] random: crng init done
[   33.342449] random: 7 urandom warning(s) missed due to ratelimiting
[   33.943719] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   34.235234] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   34.338915] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   34.630621] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   35.988185] pcieport 0000:00:1c.6: Enabling MPC IRBNCE
[   35.988190] pcieport 0000:00:1c.6: Intel PCH root port ACS workaround enabled
[   38.019084] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   38.313052] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   41.576466] wlan0: authenticate with 34:31:c4:6c:00:74
[   41.579214] wlan0: send auth to 34:31:c4:6c:00:74 (try 1/3)
[   41.619976] wlan0: authenticated
[   41.623989] wlan0: associate with 34:31:c4:6c:00:74 (try 1/3)
[   41.625998] wlan0: RX AssocResp from 34:31:c4:6c:00:74 (capab=0x1511 status=0 aid=4)
[   41.644026] wlan0: associated
[   41.720382] wlan0: Limiting TX power to 23 (23 - 0) dBm as advertised by 34:31:c4:6c:00:74
[   63.176139] ntfs: volume version 3.1.
[29219.230562] usb 3-2: USB disconnect, device number 2
[29219.230574] usb 3-2.1: USB disconnect, device number 3
[29219.231434] usb 3-2.2: USB disconnect, device number 4
[29219.231526] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[29219.231545] pl2303 3-2.2:1.0: device disconnected
[29219.232749] usb 3-2.4: USB disconnect, device number 5
[29219.290698] ACPI: \_SB_.GDCK: undocking
[29266.004858] pcieport 0000:00:1c.6: Enabling MPC IRBNCE
[29266.004862] pcieport 0000:00:1c.6: Intel PCH root port ACS workaround enabled
[33397.945481] pcieport 0000:00:1c.6: Enabling MPC IRBNCE
[33397.945485] pcieport 0000:00:1c.6: Intel PCH root port ACS workaround enabled
[33398.329366] usb 3-2: new high-speed USB device number 6 using xhci_hcd
[33398.478788] usb 3-2: New USB device found, idVendor=17ef, idProduct=100a, bcdDevice= 0.00
[33398.478797] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[33398.480762] hub 3-2:1.0: USB hub found
[33398.481173] hub 3-2:1.0: 6 ports detected
[33398.773366] usb 3-2.1: new high-speed USB device number 7 using xhci_hcd
[33398.880598] usb 3-2.1: New USB device found, idVendor=0525, idProduct=127a, bcdDevice= 1.01
[33398.880607] usb 3-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[33398.880612] usb 3-2.1: Product: Ajays USB 2.0 Debug Cable
[33398.880617] usb 3-2.1: Manufacturer: Ajays Technology
[33398.880621] usb 3-2.1: SerialNumber: Ajays001
[33398.965352] usb 3-2.2: new full-speed USB device number 8 using xhci_hcd
[33399.070524] usb 3-2.2: New USB device found, idVendor=067b, idProduct=2303, bcdDevice= 3.00
[33399.070533] usb 3-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[33399.070538] usb 3-2.2: Product: USB-Serial Controller
[33399.070543] usb 3-2.2: Manufacturer: Prolific Technology Inc.
[33399.075228] pl2303 3-2.2:1.0: pl2303 converter detected
[33399.082403] usb 3-2.2: pl2303 converter now attached to ttyUSB0
[33399.161334] usb 3-2.4: new low-speed USB device number 9 using xhci_hcd
[33399.269322] usb 3-2.4: New USB device found, idVendor=0529, idProduct=0001, bcdDevice= 3.25
[33399.269332] usb 3-2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[33399.269336] usb 3-2.4: Product: HASP HL 3.25
[33399.269341] usb 3-2.4: Manufacturer: AKS
[33643.367596] e1000e: eth0 NIC Link is Up 10 Mbps Full Duplex, Flow Control: None
[33643.367600] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[40673.357888] PM: suspend entry (deep)
[40673.357890] PM: Syncing filesystems ... done.
[40673.635958] Freezing user space processes ... (elapsed 0.001 seconds) done.
[40673.637325] OOM killer disabled.
[40673.637326] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[40673.638556] Suspending console(s) (use no_console_suspend to debug)
[40673.653240] wlan0: deauthenticating from 34:31:c4:6c:00:74 by local choice (Reason: 3=DEAUTH_LEAVING)
[40673.654592] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[40673.654647] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[40673.654874] sd 2:0:0:0: [sdb] Stopping disk
[40673.655028] sd 0:0:0:0: [sda] Stopping disk
[40673.837891] e1000e: EEE TX LPI TIMER: 00000011
[40674.114982] ACPI: EC: interrupt blocked
[40674.154675] ACPI: Preparing to enter system sleep state S3
[40674.163325] ACPI: EC: event blocked
[40674.163325] ACPI: EC: EC stopped
[40674.163326] PM: Saving platform NVS memory
[40674.163330] Disabling non-boot CPUs ...
[40674.187656] smpboot: CPU 1 is now offline
[40674.219649] smpboot: CPU 2 is now offline
[40674.243627] smpboot: CPU 3 is now offline
[40674.245129] ACPI: Low-level resume complete
[40674.245161] ACPI: EC: EC started
[40674.245162] PM: Restoring platform NVS memory
[40674.245477] Enabling non-boot CPUs ...
[40674.245527] x86: Booting SMP configuration:
[40674.245528] smpboot: Booting Node 0 Processor 1 APIC 0x1
[40674.245897] Disabled fast string operations
[40674.248117]  cache: parent cpu1 should not be sleeping
[40674.248219] CPU1 is up
[40674.248236] smpboot: Booting Node 0 Processor 2 APIC 0x2
[40674.248524] Disabled fast string operations
[40674.250722]  cache: parent cpu2 should not be sleeping
[40674.250830] CPU2 is up
[40674.250846] smpboot: Booting Node 0 Processor 3 APIC 0x3
[40674.251133] Disabled fast string operations
[40674.253320]  cache: parent cpu3 should not be sleeping
[40674.253425] CPU3 is up
[40674.256356] ACPI: Waking up from system sleep state S3
[40674.275540] ACPI: EC: interrupt unblocked
[40674.275650] pcieport 0000:00:1c.0: Enabling MPC IRBNCE
[40674.275656] pcieport 0000:00:1c.0: Intel PCH root port ACS workaround enabled
[40674.275700] pcieport 0000:00:1c.3: Enabling MPC IRBNCE
[40674.275705] pcieport 0000:00:1c.3: Intel PCH root port ACS workaround enabled
[40674.275739] pcieport 0000:00:1c.4: Enabling MPC IRBNCE
[40674.275742] pcieport 0000:00:1c.4: Intel PCH root port ACS workaround enabled
[40674.292172] pcieport 0000:00:1c.6: Enabling MPC IRBNCE
[40674.292173] pcieport 0000:00:1c.1: Enabling MPC IRBNCE
[40674.292175] pcieport 0000:00:1c.6: Intel PCH root port ACS workaround enabled
[40674.292179] pcieport 0000:00:1c.1: Intel PCH root port ACS workaround enabled
[40674.324590] ACPI: button: The lid device is not compliant to SW_LID.
[40674.324596] ACPI: EC: event unblocked
[40674.324771] usb usb3: root hub lost power or was reset
[40674.324773] usb usb4: root hub lost power or was reset
[40674.334926] sd 0:0:0:0: [sda] Starting disk
[40674.335961] sd 2:0:0:0: [sdb] Starting disk
[40674.338251] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40674.576086] usb 1-1.4: reset full-speed USB device number 4 using ehci-pci
[40674.632469] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40674.682987] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[40674.683035] ata5: SATA link down (SStatus 0 SControl 300)
[40674.683400] ata2: SATA link down (SStatus 0 SControl 300)
[40674.683416] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[40674.683418] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[40674.683420] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[40674.684065] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[40674.684067] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[40674.684069] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[40674.684412] ata3.00: configured for UDMA/133
[40674.688236] usb 3-2: reset high-speed USB device number 6 using xhci_hcd
[40674.764034] usb 1-1.6: reset high-speed USB device number 5 using ehci-pci
[40675.140255] usb 3-2.1: reset high-speed USB device number 7 using xhci_hcd
[40675.508254] usb 3-2.4: reset low-speed USB device number 9 using xhci_hcd
[40675.628023] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[40675.631032] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[40675.631041] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[40675.631046] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[40675.637373] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[40675.637381] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[40675.637387] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[40675.640323] ata1.00: configured for UDMA/133
[40675.686783] ata3.00: Enabling discard_zeroes_data
[40675.876178] usb 3-2.2: reset full-speed USB device number 8 using xhci_hcd
[40675.983133] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[40675.983157] pl2303 3-2.2:1.0: device disconnected
[40675.983379] pl2303 3-2.2:1.0: pl2303 converter detected
[40675.983506] OOM killer enabled.
[40675.983506] Restarting tasks ... 
[40675.983549] ACPI: \_SB_.PCI0.LPC_.EC__.BAT1: docking
[40675.984595] done.
[40675.985178] ACPI: \_SB_.PCI0.LPC_.EC__.BAT1: Unable to dock!
[40675.991163] usb 3-2.2: pl2303 converter now attached to ttyUSB0
[40676.000758] video LNXVIDEO:00: Restoring backlight state
[40676.001160] PM: suspend exit
[40678.564050] iwlwifi 0000:03:00.0: Error sending REPLY_SCAN_ABORT_CMD: time out after 2000ms.
[40678.564066] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 24 write_ptr 25
[40678.564106] iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
[40678.564281] iwlwifi 0000:03:00.0: 0x00000000 | OK                          
[40678.564282] iwlwifi 0000:03:00.0: 0x00000000 | uPc
[40678.564283] iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
[40678.564284] iwlwifi 0000:03:00.0: 0x00000000 | branchlink2
[40678.564285] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[40678.564286] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[40678.564287] iwlwifi 0000:03:00.0: 0x00000000 | data1
[40678.564288] iwlwifi 0000:03:00.0: 0x00000000 | data2
[40678.564289] iwlwifi 0000:03:00.0: 0x00000000 | line
[40678.564290] iwlwifi 0000:03:00.0: 0x00000000 | beacon time
[40678.564291] iwlwifi 0000:03:00.0: 0x00000000 | tsf low
[40678.564292] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[40678.564293] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[40678.564294] iwlwifi 0000:03:00.0: 0x00000000 | time gp2
[40678.564295] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[40678.564296] iwlwifi 0000:03:00.0: 0x00000000 | uCode version
[40678.564297] iwlwifi 0000:03:00.0: 0x00000000 | hw version
[40678.564298] iwlwifi 0000:03:00.0: 0x00000000 | board version
[40678.564299] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[40678.564300] iwlwifi 0000:03:00.0: 0x00000000 | isr0
[40678.564301] iwlwifi 0000:03:00.0: 0x00000000 | isr1
[40678.564302] iwlwifi 0000:03:00.0: 0x00000000 | isr2
[40678.564303] iwlwifi 0000:03:00.0: 0x00000000 | isr3
[40678.564304] iwlwifi 0000:03:00.0: 0x00000000 | isr4
[40678.564305] iwlwifi 0000:03:00.0: 0x00000000 | isr_pref
[40678.564306] iwlwifi 0000:03:00.0: 0x00000000 | wait_event
[40678.564307] iwlwifi 0000:03:00.0: 0x00000000 | l2p_control
[40678.564308] iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration
[40678.564309] iwlwifi 0000:03:00.0: 0x00000000 | l2p_mhvalid
[40678.564310] iwlwifi 0000:03:00.0: 0x00000000 | l2p_addr_match
[40678.564311] iwlwifi 0000:03:00.0: 0x00000000 | lmpm_pmg_sel
[40678.564311] iwlwifi 0000:03:00.0: 0x00000000 | timestamp
[40678.564312] iwlwifi 0000:03:00.0: 0x00000000 | flow_handler
[40678.564398] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: nothing in log
[40678.564406] iwlwifi 0000:03:00.0: Command REPLY_RXON failed: FW Error
[40678.564407] iwlwifi 0000:03:00.0: Error clearing ASSOC_MSK on BSS (-5)
[40678.575927] ieee80211 phy0: Hardware restart was requested
[40678.582344] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40678.876317] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40678.970186] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40684.163892] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[40684.163901] iwlwifi 0000:03:00.0: iwlwifi transaction failed, dumping registers
[40684.163907] iwlwifi 0000:03:00.0: iwlwifi device config registers:
[40684.163984] iwlwifi 0000:03:00.0: 00000000: 00858086 00100406 02800034 00000010 f2500004 00000000 00000000 00000000
[40684.163985] iwlwifi 0000:03:00.0: 00000020: 00000000 00000000 00000000 13118086 00000000 000000c8 00000000 000001ff
[40684.163986] iwlwifi 0000:03:00.0: iwlwifi device memory mapped registers:
[40684.164038] iwlwifi 0000:03:00.0: 00000000: 00488700 00000040 08000000 00000000 00000001 00000000 00000030 00000000
[40684.164040] iwlwifi 0000:03:00.0: 00000020: 00000001 080403c5 000000b0 00000000 90000001 00030001 80008040 00080046
[40684.164045] iwlwifi 0000:03:00.0: iwlwifi device AER capability structure:
[40684.164077] iwlwifi 0000:03:00.0: 00000000: 14010001 00000000 00000000 00062011 00000000 00002000 00000000 00000000
[40684.164078] iwlwifi 0000:03:00.0: 00000020: 00000000 00000000 00000000
[40684.164079] iwlwifi 0000:03:00.0: iwlwifi parent port (0000:00:1c.1) config registers:
[40684.164096] iwlwifi 0000:00:1c.1: 00000000: 1c128086 00100007 060400b4 00810010 00000000 00000000 00030300 000000f0
[40684.164097] iwlwifi 0000:00:1c.1: 00000020: f250f250 0001fff1 00000000 00000000 00000000 00000040 00000000 000002ff
[40684.164100] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[40684.175933] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
[40684.175982] iwlwifi 0000:03:00.0: Unable to initialize device.
[40684.175983] ------------[ cut here ]------------
[40684.175984] Hardware became unavailable during restart.
[40684.176000] WARNING: CPU: 2 PID: 2341 at net/mac80211/util.c:1908 ieee80211_reconfig+0xf3/0xa0b
[40684.176003] CPU: 2 PID: 2341 Comm: kworker/2:2 Not tainted 4.18.9 #1
[40684.176004] Hardware name: LENOVO 4290W4H/4290W4H, BIOS 8DET76WW (1.46 ) 06/21/2018
[40684.176006] Workqueue: events_freezable ieee80211_restart_work
[40684.176008] RIP: 0010:ieee80211_reconfig+0xf3/0xa0b
[40684.176008] Code: c0 41 89 c4 74 2b 45 84 f6 74 13 48 c7 c7 6e 59 ea 81 e8 12 77 a2 ff 0f 0b e9 75 02 00 00 48 c7 c7 dd 59 ea 81 e8 ff 76 a2 ff <0f> 0b e9 62 02 00 00 48 8b 83 10 01 00 00 48 8b 80 e8 00 00 00 48 
[40684.176026] RSP: 0018:ffffc900037c7e10 EFLAGS: 00010282
[40684.176027] RAX: 0000000000000000 RBX: ffff880213f38740 RCX: 0000000000000007
[40684.176028] RDX: 0000000000000000 RSI: ffff88021e2953b0 RDI: ffff88021e2953b0
[40684.176029] RBP: ffff880213f38740 R08: 0000000000000003 R09: ffffffff82396b00
[40684.176029] R10: 0000000000000406 R11: 0000000000015784 R12: 00000000ffffff92
[40684.176030] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[40684.176031] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
[40684.176032] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[40684.176033] CR2: 0000000000d29460 CR3: 000000000200a002 CR4: 00000000000606e0
[40684.176033] Call Trace:
[40684.176038]  ? _synchronize_rcu_expedited+0x2c2/0x2c2
[40684.176040]  ? try_to_del_timer_sync+0x4f/0x6e
[40684.176042]  ieee80211_restart_work+0xa9/0xb4
[40684.176044]  process_one_work+0x165/0x235
[40684.176045]  ? process_scheduled_works+0x27/0x27
[40684.176046]  worker_thread+0x1c7/0x292
[40684.176048]  kthread+0x10b/0x113
[40684.176050]  ? kthread_flush_work_fn+0x9/0x9
[40684.176052]  ret_from_fork+0x35/0x40
[40684.176054] ---[ end trace 54fdfd0986818b43 ]---
[40684.176224] ------------[ cut here ]------------
[40684.176225] wlan0:  Failed check-sdata-in-driver check, flags: 0x0
[40684.176234] WARNING: CPU: 2 PID: 2341 at net/mac80211/driver-ops.h:19 drv_remove_interface+0x30/0x54
[40684.176236] CPU: 2 PID: 2341 Comm: kworker/2:2 Tainted: G        W         4.18.9 #1
[40684.176236] Hardware name: LENOVO 4290W4H/4290W4H, BIOS 8DET76WW (1.46 ) 06/21/2018
[40684.176238] Workqueue: events_freezable ieee80211_restart_work
[40684.176240] RIP: 0010:drv_remove_interface+0x30/0x54
[40684.176240] Code: 00 48 89 f3 f6 c2 20 75 25 48 8b 86 d8 01 00 00 48 8d b6 f8 01 00 00 48 c7 c7 d4 4b ea 81 48 85 c0 48 0f 45 f0 e8 ea ca a4 ff <0f> 0b eb 1e 48 8b 87 10 01 00 00 48 8d b6 80 08 00 00 48 8b 40 40 
[40684.176258] RSP: 0018:ffffc900037c7cf0 EFLAGS: 00010286
[40684.176259] RAX: 0000000000000000 RBX: ffff88021498a7c0 RCX: 0000000000000007
[40684.176260] RDX: 0000000000000000 RSI: ffff88021e2953b0 RDI: ffff88021e2953b0
[40684.176260] RBP: ffff880213f38740 R08: 0000000000000003 R09: ffffffff82397300
[40684.176261] R10: 0000000000000422 R11: 0000000000015f20 R12: 0000000000000000
[40684.176262] R13: ffff880213f38fd0 R14: 0000000000000001 R15: ffff880213f38b60
[40684.176263] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
[40684.176263] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[40684.176264] CR2: 0000000000d29460 CR3: 000000000200a002 CR4: 00000000000606e0
[40684.176265] Call Trace:
[40684.176268]  ieee80211_do_stop+0x672/0x6e9
[40684.176269]  ieee80211_stop+0x11/0x14
[40684.176272]  __dev_close_many+0x9f/0xb6
[40684.176274]  dev_close_many+0x6c/0xed
[40684.176276]  dev_close+0x48/0x72
[40684.176279]  cfg80211_shutdown_all_interfaces+0x71/0xa7
[40684.176280]  ieee80211_reconfig+0x364/0xa0b
[40684.176282]  ? _synchronize_rcu_expedited+0x2c2/0x2c2
[40684.176283]  ? try_to_del_timer_sync+0x4f/0x6e
[40684.176284]  ieee80211_restart_work+0xa9/0xb4
[40684.176286]  process_one_work+0x165/0x235
[40684.176287]  ? process_scheduled_works+0x27/0x27
[40684.176288]  worker_thread+0x1c7/0x292
[40684.176289]  kthread+0x10b/0x113
[40684.176290]  ? kthread_flush_work_fn+0x9/0x9
[40684.176292]  ret_from_fork+0x35/0x40
[40684.176293] ---[ end trace 54fdfd0986818b44 ]---
[40684.176302] WARNING: CPU: 2 PID: 2341 at net/mac80211/driver-ops.c:39 drv_stop+0xa/0x49
[40684.176304] CPU: 2 PID: 2341 Comm: kworker/2:2 Tainted: G        W         4.18.9 #1
[40684.176304] Hardware name: LENOVO 4290W4H/4290W4H, BIOS 8DET76WW (1.46 ) 06/21/2018
[40684.176305] Workqueue: events_freezable ieee80211_restart_work
[40684.176307] RIP: 0010:drv_stop+0xa/0x49
[40684.176307] Code: 24 fc 00 48 8b 87 10 01 00 00 48 8b 40 08 e8 d7 b9 3d 00 85 c0 74 07 c6 83 94 04 00 00 00 5b c3 80 bf 94 04 00 00 00 53 75 04 <0f> 0b eb 39 48 8b 87 10 01 00 00 48 89 fb 48 8b 40 10 e8 a9 b9 3d 
[40684.176324] RSP: 0018:ffffc900037c7cf0 EFLAGS: 00010246
[40684.176325] RAX: 0000000000000000 RBX: ffff88021498a7c0 RCX: 0000000000000000
[40684.176326] RDX: ffff8801c60cb100 RSI: 0000000000000286 RDI: ffff880213f38740
[40684.176327] RBP: ffff880213f38740 R08: 0000000000000000 R09: 0000000000000000
[40684.176327] R10: ffff880214c000a8 R11: 0000000000000000 R12: 0000000000000000
[40684.176328] R13: ffff880213f38fd0 R14: 0000000000000001 R15: ffff880213f38b60
[40684.176329] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
[40684.176330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[40684.176331] CR2: 0000000000d29460 CR3: 000000000200a002 CR4: 00000000000606e0
[40684.176331] Call Trace:
[40684.176332]  ieee80211_do_stop+0x69d/0x6e9
[40684.176334]  ieee80211_stop+0x11/0x14
[40684.176335]  __dev_close_many+0x9f/0xb6
[40684.176337]  dev_close_many+0x6c/0xed
[40684.176338]  dev_close+0x48/0x72
[40684.176339]  cfg80211_shutdown_all_interfaces+0x71/0xa7
[40684.176341]  ieee80211_reconfig+0x364/0xa0b
[40684.176342]  ? _synchronize_rcu_expedited+0x2c2/0x2c2
[40684.176343]  ? try_to_del_timer_sync+0x4f/0x6e
[40684.176345]  ieee80211_restart_work+0xa9/0xb4
[40684.176346]  process_one_work+0x165/0x235
[40684.176347]  ? process_scheduled_works+0x27/0x27
[40684.176348]  worker_thread+0x1c7/0x292
[40684.176349]  kthread+0x10b/0x113
[40684.176350]  ? kthread_flush_work_fn+0x9/0x9
[40684.176352]  ret_from_fork+0x35/0x40
[40684.176353] ---[ end trace 54fdfd0986818b45 ]---
[40684.197494] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40684.492198] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40687.760235] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40688.065744] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40691.310600] wlan0: authenticate with 34:31:c4:6c:00:74
[40691.312970] wlan0: send auth to 34:31:c4:6c:00:74 (try 1/3)
[40692.195866] wlan0: send auth to 34:31:c4:6c:00:74 (try 2/3)
[40693.220173] wlan0: send auth to 34:31:c4:6c:00:74 (try 3/3)
[40694.211832] wlan0: authentication with 34:31:c4:6c:00:74 timed out
[40694.415356] wlan0: authenticate with 44:4e:6d:3b:2b:f8
[40694.418710] wlan0: send auth to 44:4e:6d:3b:2b:f8 (try 1/3)
[40695.203763] wlan0: send auth to 44:4e:6d:3b:2b:f8 (try 2/3)
[40696.195725] wlan0: send auth to 44:4e:6d:3b:2b:f8 (try 3/3)
[40697.187707] wlan0: authentication with 44:4e:6d:3b:2b:f8 timed out
[40705.441031] wlan0: authenticate with 34:31:c4:6c:00:74
[40705.443858] wlan0: send auth to 34:31:c4:6c:00:74 (try 1/3)
[40706.179498] wlan0: send auth to 34:31:c4:6c:00:74 (try 2/3)
[40707.203537] wlan0: send auth to 34:31:c4:6c:00:74 (try 3/3)
[40708.195462] wlan0: authentication with 34:31:c4:6c:00:74 timed out
[40709.365509] wlan0: authenticate with 44:4e:6d:3b:2b:f8
[40709.367993] wlan0: send auth to 44:4e:6d:3b:2b:f8 (try 1/3)
[40710.211437] wlan0: send auth to 44:4e:6d:3b:2b:f8 (try 2/3)
[40711.235562] wlan0: send auth to 44:4e:6d:3b:2b:f8 (try 3/3)
[40712.195480] wlan0: authentication with 44:4e:6d:3b:2b:f8 timed out
[40713.417676] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40713.712361] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40716.933615] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40717.236023] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[40720.481034] wlan0: authenticate with 34:31:c4:6c:00:74
[40720.483430] wlan0: send auth to 34:31:c4:6c:00:74 (try 1/3)
[40721.219331] wlan0: send auth to 34:31:c4:6c:00:74 (try 2/3)

--MP_/Qt4obznO8m4quz/GFb3Qj5K--
