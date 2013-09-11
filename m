Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail05.raumopol.de ([217.11.57.242]:41588 "EHLO
	mail05.raumopol.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3IKXud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 19:50:33 -0400
Message-ID: <5230FF1F.9020609@janno-kaiser.de> (sfid-20130912_015039_541377_7F3DD7C8)
Date: Thu, 12 Sep 2013 01:39:11 +0200
From: Jan-Oliver Kaiser <mail@janno-kaiser.de>
Reply-To: mail@janno-kaiser.de
MIME-Version: 1.0
To: frankyl@broadcom.com
CC: linux-wireless@vger.kernel.org
Subject: Re: brcmfmac, BCM43241
References: <5230D40B.20704@janno-kaiser.de> <5230F19F.2070701@broadcom.com>
In-Reply-To: <5230F19F.2070701@broadcom.com>
Content-Type: multipart/mixed;
 boundary="------------020904010204030203000407"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020904010204030203000407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Franky,

Thank you for your response. I'll attach the full dmesg output. The
device is a Sony Vaio Duo 13 laptop (SVD1321C5E).

The dmesg part I posted in the first mail is (as far as I can tell) the
only part related to the built-in wireless adapter. I have another
wireless adapter attached via USB, which is responsible for earlier
output related to wireless stuff.

The dmesg entries about brcmfmac are triggered simply by `modprobe
brmcfmac`.

Best regards,
Jan-Oliver

P.S.:
I read somewhere that the wireless adapter and the touchscreen, which is
also not working, are both connected via an Intel GPIO Controller but I
can't seem to find the source. I don't know what that means or if it is
true. Maybe somebody here can make use of this information.


On 09/12/2013 12:41 AM, Franky Lin wrote:
> Hi Jan-Oliver,
> 
> Could you please send us the full log? Also please share more details
> about the hardware platform you are using. We need to figure out how to
> get the nvram file.
> 
> Regards,
> Franky
> 
> On 09/11/2013 01:35 PM, Jan-Oliver Kaiser wrote:
>> Hi,
>>
>> I am trying to get a BCM43241 card running on a 3.11-amd64 kernel.
>> [1] lists the device as supported but gives no instructions on how to
>> install it. I managed to extract the firmware from the git binary patch
>> contained in [2].
>>
>> I copied the firmware to /lib/firmware/brcm/brcmfmac-sdio.bin and copied
>> the content of /dev/nvram to /lib/firmware/brcm/brcmfmac-sdio.txt.
>>
>> Previously, `dmesg` would list error that indicated missing files.
>> Currently, the output is as follows:
>>
>> [12865.299503] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO
>> Drive strength init done for chip 4324 rev 5 pmurev 17
>> [12866.393551] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
>> clkctl 0x50
>> [12867.402386] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
>> clkctl 0x50
>> [12867.409143] brcmfmac: brcmf_proto_cdc_query_dcmd: brcmf_proto_cdc_msg
>> failed w/status -5
>> [12867.409149] brcmfmac: brcmf_fil_cmd_data: Failed err=-5
>> [12867.409153] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr
>> failed, -5
>> [12867.409157] brcmfmac: brcmf_bus_start: failed: -5
>> [12867.409167] brcmfmac: brcmf_sdbrcm_probe: dongle is not responding
>> [12868.416890] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
>> clkctl 0x50
>> [12869.426308] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
>> clkctl 0x50
>>
>> I have not been able to find anything to help with debugging this.
>>
>> There was some discussion in response to [2] that I don't understand. Is
>> there something wrong with the firmware itself?
>>
>> I would be very grateful for any help. I can provide all additional
>> information if something is missing from this report. (I can also be
>> reached via IRC, 'Eruquen' on freenode)
>>
>> Thanks in advance,
>> Jan-Oliver
>>
>> [1] http://wireless.kernel.org/en/users/Drivers/brcm80211
>> [2] http://www.spinics.net/lists/linux-wireless/msg107754.html
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 


--------------020904010204030203000407
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11-0.slh.2-aptosid-amd64 (Debian 3.11-2) (s.l-h@gmx.de) (gcc version 4.8.1 (Debian 4.8.1-10) ) #1 SMP PREEMPT Thu Sep 5 20:56:14 UTC 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.11-0.slh.2-aptosid-amd64 root=/dev/mapper/os-base ro quiet acpi_backlight=vendor
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000006efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000006f000-0x000000000006ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000070000-0x0000000000087fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000088000-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000008bc36fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008bc37000-0x000000008d0affff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008d0b0000-0x00000000916befff] usable
[    0.000000] BIOS-e820: [mem 0x00000000916bf000-0x0000000091ebefff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000091ebf000-0x0000000091fbefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000091fbf000-0x0000000091ffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000091fff000-0x0000000091ffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000092000000-0x000000009f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe101000-0x00000000fe112fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feb00000-0x00000000feb0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000025f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by INSYDE Corp.
[    0.000000] efi:  ACPI=0x91ffe000  ACPI 2.0=0x91ffe014  SMBIOS=0x91ebef98 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000001000-0x000000000006f000) (0MB)
[    0.000000] efi: mem02: type=0, attr=0xf, range=[0x000000000006f000-0x0000000000070000) (0MB)
[    0.000000] efi: mem03: type=7, attr=0xf, range=[0x0000000000070000-0x0000000000088000) (0MB)
[    0.000000] efi: mem04: type=6, attr=0x800000000000000f, range=[0x0000000000088000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000000100000-0x0000000000c67000) (11MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000000c67000-0x00000000365ae000) (857MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x00000000365ae000-0x00000000372cf000) (13MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x00000000372cf000-0x000000004cf21000) (348MB)
[    0.000000] efi: mem09: type=2, attr=0xf, range=[0x000000004cf21000-0x000000008a0c0000) (977MB)
[    0.000000] efi: mem10: type=4, attr=0xf, range=[0x000000008a0c0000-0x000000008a0e0000) (0MB)
[    0.000000] efi: mem11: type=7, attr=0xf, range=[0x000000008a0e0000-0x000000008ade3000) (13MB)
[    0.000000] efi: mem12: type=4, attr=0xf, range=[0x000000008ade3000-0x000000008bc37000) (14MB)
[    0.000000] efi: mem13: type=0, attr=0xf, range=[0x000000008bc37000-0x000000008d0b0000) (20MB)
[    0.000000] efi: mem14: type=7, attr=0xf, range=[0x000000008d0b0000-0x000000008d20a000) (1MB)
[    0.000000] efi: mem15: type=1, attr=0xf, range=[0x000000008d20a000-0x000000008d2bf000) (0MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x000000008d2bf000-0x000000008de35000) (11MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x000000008de35000-0x000000008f4f6000) (22MB)
[    0.000000] efi: mem18: type=7, attr=0xf, range=[0x000000008f4f6000-0x000000008f4f9000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x000000008f4f9000-0x000000008f508000) (0MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x000000008f508000-0x000000008f509000) (0MB)
[    0.000000] efi: mem21: type=4, attr=0xf, range=[0x000000008f509000-0x000000008f645000) (1MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x000000008f645000-0x000000008f649000) (0MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x000000008f649000-0x000000008f661000) (0MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x000000008f661000-0x000000008f666000) (0MB)
[    0.000000] efi: mem25: type=4, attr=0xf, range=[0x000000008f666000-0x000000008f667000) (0MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x000000008f667000-0x000000008f668000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x000000008f668000-0x000000008f66d000) (0MB)
[    0.000000] efi: mem28: type=7, attr=0xf, range=[0x000000008f66d000-0x000000008f66e000) (0MB)
[    0.000000] efi: mem29: type=4, attr=0xf, range=[0x000000008f66e000-0x000000008f692000) (0MB)
[    0.000000] efi: mem30: type=7, attr=0xf, range=[0x000000008f692000-0x000000008f693000) (0MB)
[    0.000000] efi: mem31: type=4, attr=0xf, range=[0x000000008f693000-0x000000008f696000) (0MB)
[    0.000000] efi: mem32: type=7, attr=0xf, range=[0x000000008f696000-0x000000008f699000) (0MB)
[    0.000000] efi: mem33: type=4, attr=0xf, range=[0x000000008f699000-0x000000008f69a000) (0MB)
[    0.000000] efi: mem34: type=7, attr=0xf, range=[0x000000008f69a000-0x000000008f69e000) (0MB)
[    0.000000] efi: mem35: type=4, attr=0xf, range=[0x000000008f69e000-0x00000000912bf000) (28MB)
[    0.000000] efi: mem36: type=7, attr=0xf, range=[0x00000000912bf000-0x0000000091385000) (0MB)
[    0.000000] efi: mem37: type=2, attr=0xf, range=[0x0000000091385000-0x000000009138e000) (0MB)
[    0.000000] efi: mem38: type=3, attr=0xf, range=[0x000000009138e000-0x00000000916bf000) (3MB)
[    0.000000] efi: mem39: type=5, attr=0x800000000000000f, range=[0x00000000916bf000-0x00000000918bf000) (2MB)
[    0.000000] efi: mem40: type=6, attr=0x800000000000000f, range=[0x00000000918bf000-0x0000000091abf000) (2MB)
[    0.000000] efi: mem41: type=0, attr=0xf, range=[0x0000000091abf000-0x0000000091ebf000) (4MB)
[    0.000000] efi: mem42: type=10, attr=0xf, range=[0x0000000091ebf000-0x0000000091fbf000) (1MB)
[    0.000000] efi: mem43: type=9, attr=0xf, range=[0x0000000091fbf000-0x0000000091fff000) (0MB)
[    0.000000] efi: mem44: type=4, attr=0xf, range=[0x0000000091fff000-0x0000000092000000) (0MB)
[    0.000000] efi: mem45: type=7, attr=0xf, range=[0x0000000100000000-0x000000025f600000) (5622MB)
[    0.000000] efi: mem46: type=0, attr=0x0, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
[    0.000000] efi: mem47: type=0, attr=0x0, range=[0x0000000092000000-0x000000009fa00000) (218MB)
[    0.000000] efi: mem48: type=11, attr=0x8000000000000001, range=[0x00000000e0000000-0x00000000f0000000) (256MB)
[    0.000000] efi: mem49: type=0, attr=0x0, range=[0x00000000fe101000-0x00000000fe113000) (0MB)
[    0.000000] efi: mem50: type=11, attr=0x8000000000000001, range=[0x00000000feb00000-0x00000000feb10000) (0MB)
[    0.000000] efi: mem51: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem52: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed1c000) (0MB)
[    0.000000] efi: mem53: type=11, attr=0x8000000000000000, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem54: type=11, attr=0x8000000000000001, range=[0x00000000fed20000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem55: type=11, attr=0x8000000000000000, range=[0x00000000ffc00000-0x0000000100000000) (4MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Sony Corporation SVD1321C5E/VAIO, BIOS R0150S7 05/17/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x25f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-protect
[    0.000000]   E8000-EFFFF write-combining
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7F80000000 write-back
[    0.000000]   1 base 0080000000 mask 7FF0000000 write-back
[    0.000000]   2 base 0090000000 mask 7FFE000000 write-back
[    0.000000]   3 base 00FFC00000 mask 7FFFC00000 write-protect
[    0.000000]   4 base 0100000000 mask 7F00000000 write-back
[    0.000000]   5 base 0200000000 mask 7F80000000 write-back
[    0.000000]   6 base 025F600000 mask 7FFFE00000 uncachable
[    0.000000]   7 base 025F800000 mask 7FFF800000 uncachable
[    0.000000]   8 base 0260000000 mask 7FE0000000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x92000 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff88000007e000] 7e000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01745000, 0x01745fff] PGTABLE
[    0.000000] BRK [0x01746000, 0x01746fff] PGTABLE
[    0.000000] BRK [0x01747000, 0x01747fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x25f400000-0x25f5fffff]
[    0.000000]  [mem 0x25f400000-0x25f5fffff] page 2M
[    0.000000] BRK [0x01748000, 0x01748fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x25c000000-0x25f3fffff]
[    0.000000]  [mem 0x25c000000-0x25f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x25bffffff]
[    0.000000]  [mem 0x200000000-0x23fffffff] page 1G
[    0.000000]  [mem 0x240000000-0x25bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x8bc36fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x8bbfffff] page 2M
[    0.000000]  [mem 0x8bc00000-0x8bc36fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8d0b0000-0x916befff]
[    0.000000]  [mem 0x8d0b0000-0x8d1fffff] page 4k
[    0.000000]  [mem 0x8d200000-0x915fffff] page 2M
[    0.000000]  [mem 0x91600000-0x916befff] page 4k
[    0.000000] BRK [0x01749000, 0x01749fff] PGTABLE
[    0.000000] BRK [0x0174a000, 0x0174afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x91fff000-0x91ffffff]
[    0.000000]  [mem 0x91fff000-0x91ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x365ae000-0x372cefff]
[    0.000000] ACPI: RSDP 0000000091ffe014 00024 (v02   Sony)
[    0.000000] ACPI: XSDT 0000000091ffe210 000EC (v01   Sony     VAIO 20130517      01000013)
[    0.000000] ACPI: FACP 0000000091ff5000 0010C (v05   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI Error: Gpe0Block - 32-bit FADT register is too long (32 bytes, 256 bits) to convert to GAS struct - 255 bits max, truncating (20130517/tbfadt-202)
[    0.000000] ACPI: DSDT 0000000091fe8000 09CF8 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: FACS 0000000091fb9000 00040
[    0.000000] ACPI: UEFI 0000000091ffd000 00236 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: FPDT 0000000091ffb000 00044 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: MSDM 0000000091ffa000 00055 (v03   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091ff9000 00496 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091ff8000 0004A (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: TPM2 0000000091ff7000 00038 (v03   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: ASF! 0000000091ff6000 000A5 (v32   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: HPET 0000000091ff4000 00038 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: APIC 0000000091ff3000 0008C (v03   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: MCFG 0000000091ff2000 0003C (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091fe7000 007D9 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: BOOT 0000000091fe6000 00028 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: ASPT 0000000091fe5000 00034 (v07   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: DBGP 0000000091fe4000 00034 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091fe2000 01813 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091fe1000 00473 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091fe0000 00AD8 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091fdf000 00410 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091fdc000 02C30 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091fdb000 00379 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: PCCT 0000000091fda000 0006E (v05   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: SSDT 0000000091fd9000 00AC4 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: CSRT 0000000091fd7000 000C4 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: BGRT 0000000091fd8000 00038 (v01   Sony     VAIO 20130517 ACPI 00040000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000025f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x25f5fffff]
[    0.000000]   NODE_DATA [mem 0x25f5e9000-0x25f5fcfff]
[    0.000000]  [ffffea0000000000-ffffea00097fffff] PMD -> [ffff880256e00000-ffff88025ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x25f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0006efff]
[    0.000000]   node   0: [mem 0x00070000-0x00087fff]
[    0.000000]   node   0: [mem 0x00100000-0x8bc36fff]
[    0.000000]   node   0: [mem 0x8d0b0000-0x916befff]
[    0.000000]   node   0: [mem 0x91fff000-0x91ffffff]
[    0.000000]   node   0: [mem 0x100000000-0x25f5fffff]
[    0.000000] On node 0 totalpages: 2029517
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3974 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 9162 pages used for memmap
[    0.000000]   DMA32 zone: 586311 pages, LIFO batch:31
[    0.000000]   Normal zone: 22488 pages used for memmap
[    0.000000]   Normal zone: 1439232 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 56
[    0.000000] PM: Registered nosave memory: [mem 0x0006f000-0x0006ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x00088000-0x000bffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000c0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x8bc37000-0x8d0affff]
[    0.000000] PM: Registered nosave memory: [mem 0x916bf000-0x91ebefff]
[    0.000000] PM: Registered nosave memory: [mem 0x91ebf000-0x91fbefff]
[    0.000000] PM: Registered nosave memory: [mem 0x91fbf000-0x91ffefff]
[    0.000000] PM: Registered nosave memory: [mem 0x92000000-0x9f9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9fa00000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfe100fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe101000-0xfe112fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe113000-0xfeafffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeb00000-0xfeb0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeb10000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
[    0.000000] e820: [mem 0x9fa00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88025f200000 s80384 r8192 d22016 u262144
[    0.000000] pcpu-alloc: s80384 r8192 d22016 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1997781
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.11-0.slh.2-aptosid-amd64 root=/dev/mapper/os-base ro quiet acpi_backlight=vendor
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7829004K/8118068K available (3514K kernel code, 582K rwdata, 1500K rodata, 972K init, 844K bss, 289064K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:16640 nr_irqs:1016 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33030144 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.002000] tsc: PIT calibration matches HPET. 1 loops
[    0.002000] tsc: Detected 2294.609 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4589.21 BogoMIPS (lpj=2294609)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000023] init_memory_mapping: [mem 0x916bf000-0x918befff]
[    0.000025]  [mem 0x916bf000-0x918befff] page 4k
[    0.000056] init_memory_mapping: [mem 0x918bf000-0x91abefff]
[    0.000058]  [mem 0x918bf000-0x91abefff] page 4k
[    0.030797] Security Framework initialized
[    0.030803] SELinux:  Disabled at boot.
[    0.031508] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.033844] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.034830] Mount-cache hash table entries: 256
[    0.035052] Initializing cgroup subsys memory
[    0.035061] Initializing cgroup subsys devices
[    0.035064] Initializing cgroup subsys freezer
[    0.035066] Initializing cgroup subsys net_cls
[    0.035067] Initializing cgroup subsys blkio
[    0.035069] Initializing cgroup subsys perf_event
[    0.035098] CPU: Physical Processor ID: 0
[    0.035099] CPU: Processor Core ID: 0
[    0.035106] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.035106] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.036406] mce: CPU supports 7 MCE banks
[    0.036423] CPU0: Thermal monitoring enabled (TM1)
[    0.036438] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.036438] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0
[    0.036438] tlb_flushall_shift: 6
[    0.036559] Freeing SMP alternatives memory: 8K (ffffffff8166e000 - ffffffff81670000)
[    0.036971] ACPI: Core revision 20130517
[    0.050345] ACPI: All ACPI Tables successfully acquired
[    0.056536] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066535] smpboot: CPU0: Intel(R) Core(TM) i5-4200U CPU @ 1.60GHz (fam: 06, model: 45, stepping: 01)
[    0.066545] TSC deadline timer enabled
[    0.066558] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.066568] ... version:                3
[    0.066569] ... bit width:              48
[    0.066571] ... generic registers:      4
[    0.066573] ... value mask:             0000ffffffffffff
[    0.066574] ... max period:             0000ffffffffffff
[    0.066576] ... fixed-purpose events:   3
[    0.066577] ... event mask:             000000070000000f
[    0.074687] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.122553] Brought up 4 CPUs
[    0.122557] smpboot: Total of 4 processors activated (18356.87 BogoMIPS)
[    0.127850] devtmpfs: initialized
[    0.131543] PM: Registering ACPI NVS region [mem 0x91ebf000-0x91fbefff] (1048576 bytes)
[    0.131687] NET: Registered protocol family 16
[    0.131837] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.131839] ACPI: bus type PCI registered
[    0.131842] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.131914] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.131917] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.146094] PCI: Using configuration type 1 for base access
[    0.146925] bio: create slab <bio-0> at 0
[    0.147048] ACPI: Added _OSI(Module Device)
[    0.147051] ACPI: Added _OSI(Processor Device)
[    0.147053] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.147055] ACPI: Added _OSI(Processor Aggregator Device)
[    0.149803] ACPI: EC: Look up EC in DSDT
[    0.152667] ACPI: Executed 2 blocks of module-level executable AML code
[    0.157722] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.259463] ACPI: SSDT 0000000091e86c18 003D3 (v01   Sony     VAIO 20130517 INTL 20120913)
[    0.260154] ACPI: Dynamic OEM Table Load:
[    0.260157] ACPI: SSDT           (null) 003D3 (v01   Sony     VAIO 20130517 INTL 20120913)
[    0.266211] ACPI: SSDT 0000000091e86618 005AA (v01   Sony     VAIO 20130517 INTL 20120913)
[    0.266999] ACPI: Dynamic OEM Table Load:
[    0.267002] ACPI: SSDT           (null) 005AA (v01   Sony     VAIO 20130517 INTL 20120913)
[    0.272031] ACPI: SSDT 0000000091e7ed98 00119 (v01   Sony     VAIO 20130517 INTL 20120913)
[    0.272710] ACPI: Dynamic OEM Table Load:
[    0.272713] ACPI: SSDT           (null) 00119 (v01   Sony     VAIO 20130517 INTL 20120913)
[    0.279724] ACPI: Interpreter enabled
[    0.279739] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130517/hwxface-571)
[    0.279748] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[    0.279774] ACPI: (supports S0 S3 S4 S5)
[    0.279776] ACPI: Using IOAPIC for interrupt routing
[    0.279817] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.280004] ACPI: No dock devices found.
[    0.284546] ACPI: Power Resource [PX03] (on)
[    0.301056] ACPI: Power Resource [PX05] (on)
[    0.317241] ACPI: Power Resource [PAUD] (on)
[    0.317827] ACPI: Power Resource [PSEN] (on)
[    0.317902] ACPI: Power Resource [PXTC] (on)
[    0.345434] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.346000] PCI host bridge to bus 0000:00
[    0.346005] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.346008] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.346011] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.346013] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.346016] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.346019] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.346021] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.346023] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    0.346026] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.346028] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.346031] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.346036] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.346038] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.346040] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.346043] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.346045] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.346048] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.346050] pci_bus 0000:00: root bus resource [mem 0x9fa00000-0xfeafffff]
[    0.346062] pci 0000:00:00.0: [8086:0a04] type 00 class 0x060000
[    0.346191] pci 0000:00:02.0: [8086:0a16] type 00 class 0x030000
[    0.346208] pci 0000:00:02.0: reg 0x10: [mem 0xb0000000-0xb03fffff 64bit]
[    0.346218] pci 0000:00:02.0: reg 0x18: [mem 0xa0000000-0xafffffff 64bit pref]
[    0.346225] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
[    0.346337] pci 0000:00:03.0: [8086:0a0c] type 00 class 0x040300
[    0.346349] pci 0000:00:03.0: reg 0x10: [mem 0xb0410000-0xb0413fff 64bit]
[    0.346522] pci 0000:00:14.0: [8086:9c31] type 00 class 0x0c0330
[    0.346571] pci 0000:00:14.0: reg 0x10: [mem 0xb0400000-0xb040ffff 64bit]
[    0.346735] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.346806] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.346863] pci 0000:00:16.0: [8086:9c3a] type 00 class 0x078000
[    0.346912] pci 0000:00:16.0: reg 0x10: [mem 0xb041a000-0xb041a01f 64bit]
[    0.347079] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.347232] pci 0000:00:1b.0: [8086:9c20] type 00 class 0x040300
[    0.347269] pci 0000:00:1b.0: reg 0x10: [mem 0xb0414000-0xb0417fff 64bit]
[    0.347446] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.347524] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.347580] pci 0000:00:1f.0: [8086:9c43] type 00 class 0x060100
[    0.347919] pci 0000:00:1f.2: [8086:9c03] type 00 class 0x010601
[    0.347963] pci 0000:00:1f.2: reg 0x10: [io  0x3088-0x308f]
[    0.347982] pci 0000:00:1f.2: reg 0x14: [io  0x3094-0x3097]
[    0.348001] pci 0000:00:1f.2: reg 0x18: [io  0x3080-0x3087]
[    0.348020] pci 0000:00:1f.2: reg 0x1c: [io  0x3090-0x3093]
[    0.348040] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
[    0.348059] pci 0000:00:1f.2: reg 0x24: [mem 0xb041d000-0xb041d7ff]
[    0.348171] pci 0000:00:1f.2: PME# supported from D3hot
[    0.348277] pci 0000:00:1f.3: [8086:9c22] type 00 class 0x0c0500
[    0.348314] pci 0000:00:1f.3: reg 0x10: [mem 0xb041b000-0xb041b0ff 64bit]
[    0.348368] pci 0000:00:1f.3: reg 0x20: [io  0x3040-0x305f]
[    0.348603] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.348846] acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
[    0.361457] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.361527] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.361593] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.361658] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.361723] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.361787] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.361852] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.361916] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.362532] ACPI: Enabled 4 GPEs in block 00 to 7F
[    0.362542] ACPI: \_SB_.PCI0: notify handler is installed
[    0.362628] Found 1 acpi root devices
[    0.362680] ACPI: EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
[    0.362801] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.362805] vgaarb: loaded
[    0.362807] vgaarb: bridge control possible 0000:00:02.0
[    0.362872] PCI: Using ACPI for IRQ routing
[    0.382054] PCI: pci_cache_line_size set to 64 bytes
[    0.382102] e820: reserve RAM buffer [mem 0x0006f000-0x0006ffff]
[    0.382104] e820: reserve RAM buffer [mem 0x00088000-0x0008ffff]
[    0.382106] e820: reserve RAM buffer [mem 0x8bc37000-0x8bffffff]
[    0.382108] e820: reserve RAM buffer [mem 0x916bf000-0x93ffffff]
[    0.382110] e820: reserve RAM buffer [mem 0x92000000-0x93ffffff]
[    0.382113] e820: reserve RAM buffer [mem 0x25f600000-0x25fffffff]
[    0.382223] NetLabel: Initializing
[    0.382225] NetLabel:  domain hash size = 128
[    0.382227] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.382237] NetLabel:  unlabeled traffic allowed by default
[    0.382298] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.382305] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.384343] Switched to clocksource hpet
[    0.384388] pnp: PnP ACPI init
[    0.384397] ACPI: bus type PNP registered
[    0.384489] pnp 00:00: [dma 4]
[    0.384511] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.384536] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    0.384651] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.384699] system 00:03: [io  0x0680-0x069f] has been reserved
[    0.384702] system 00:03: [io  0xffff] has been reserved
[    0.384705] system 00:03: [io  0xffff] has been reserved
[    0.384707] system 00:03: [io  0xffff] has been reserved
[    0.384712] system 00:03: [io  0x0400-0x0453] has been reserved
[    0.384715] system 00:03: [io  0x0800-0x08fe] has been reserved
[    0.384718] system 00:03: [io  0x0900-0x09fe] has been reserved
[    0.384720] system 00:03: [io  0x0a00-0x0afe] has been reserved
[    0.384725] system 00:03: [io  0x0b00-0x0bfe] has been reserved
[    0.384728] system 00:03: [io  0x1800-0x18fe] could not be reserved
[    0.384730] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.384733] system 00:03: [io  0x2000] has been reserved
[    0.384736] system 00:03: [io  0x2004] has been reserved
[    0.384739] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.384770] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.384820] system 00:05: [io  0x1854-0x1857] has been reserved
[    0.384824] system 00:05: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.384874] pnp 00:06: Plug and Play ACPI device, IDs SNYa009 PNP030b (active)
[    0.385039] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.385042] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.385045] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.385047] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.385050] system 00:07: [mem 0xe0000000-0xefffffff] has been reserved
[    0.385053] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.385056] system 00:07: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.385059] system 00:07: [mem 0xff000000-0xffffffff] could not be reserved
[    0.385062] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.385065] system 00:07: [mem 0x9fa10000-0x9fa10fff] has been reserved
[    0.385068] system 00:07: [mem 0xffffffff-0x100000ffe] could not be reserved
[    0.385071] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.395447] system 00:08: [mem 0xb0425000-0xb0425fff] has been reserved
[    0.395452] system 00:08: [mem 0xfe104000-0xfe104fff] has been reserved
[    0.395455] system 00:08: [mem 0xfe106000-0xfe106fff] has been reserved
[    0.395458] system 00:08: [mem 0xb041f000-0xb041ffff] has been reserved
[    0.395461] system 00:08: [mem 0xb041e000-0xb041efff] has been reserved
[    0.395464] system 00:08: [mem 0xb0419000-0xb0419007] has been reserved
[    0.395466] system 00:08: [mem 0xb0419014-0xb0419fff] has been reserved
[    0.395470] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.395706] pnp 00:09: unknown resource type 19 in _CRS
[    0.395709] pnp 00:09: can't evaluate _CRS: 1
[    0.395738] pnp 00:09: Plug and Play ACPI device, IDs INT33d1 PNP0c50 (active)
[    0.395842] pnp 00:0a: unknown resource type 19 in _CRS
[    0.395844] pnp 00:0a: can't evaluate _CRS: 1
[    0.395876] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c50 (active)
[    0.395939] pnp 00:0b: unknown resource type 19 in _CRS
[    0.395942] pnp 00:0b: can't evaluate _CRS: 1
[    0.395971] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c50 (active)
[    0.396128] pnp 00:0c: unknown resource type 19 in _CRS
[    0.396130] pnp 00:0c: can't evaluate _CRS: 1
[    0.396155] pnp 00:0c: Plug and Play ACPI device, IDs BCM2e47 (active)
[    0.396573] pnp: PnP ACPI: found 13 devices
[    0.396575] ACPI: bus type PNP unregistered
[    0.403988] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.403991] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.403994] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.403997] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.403999] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.404002] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.404004] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    0.404007] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.404009] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.404012] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.404014] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    0.404017] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.404019] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.404022] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.404024] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    0.404026] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
[    0.404029] pci_bus 0000:00: resource 20 [mem 0x9fa00000-0xfeafffff]
[    0.404063] NET: Registered protocol family 2
[    0.404360] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.404615] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.404773] TCP: Hash tables configured (established 65536 bind 65536)
[    0.404798] TCP: reno registered
[    0.404815] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.404852] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.404942] NET: Registered protocol family 1
[    0.404959] pci 0000:00:02.0: Boot video device
[    0.406787] PCI: CLS 64 bytes, default 64
[    0.406834] Unpacking initramfs...
[    0.782864] Freeing initrd memory: 13444K (ffff8800365ae000 - ffff8800372cf000)
[    0.782871] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.782874] software IO TLB [mem 0x860c0000-0x8a0c0000] (64MB) mapped at [ffff8800860c0000-ffff88008a0bffff]
[    0.782934] Simple Boot Flag at 0x44 set to 0x1
[    0.783146] microcode: CPU0 sig=0x40651, pf=0x40, revision=0x10
[    0.783156] microcode: CPU1 sig=0x40651, pf=0x40, revision=0x10
[    0.783167] microcode: CPU2 sig=0x40651, pf=0x40, revision=0x10
[    0.783178] microcode: CPU3 sig=0x40651, pf=0x40, revision=0x10
[    0.783278] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.783547] audit: initializing netlink socket (disabled)
[    0.783558] type=2000 audit(1378915826.761:1): initialized
[    0.784072] bounce pool size: 64 pages
[    0.784085] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.785843] zbud: loaded
[    0.786026] VFS: Disk quotas dquot_6.5.2
[    0.786076] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.786210] msgmni has been set to 15457
[    0.786753] alg: No test for stdrng (krng)
[    0.786765] Key type asymmetric registered
[    0.786769] Asymmetric key parser 'x509' registered
[    0.786807] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.786869] io scheduler noop registered
[    0.786871] io scheduler deadline registered
[    0.786882] io scheduler cfq registered (default)
[    0.786944] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.786960] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.787039] efifb: probing for efifb
[    0.787618] efifb: framebuffer at 0xa0000000, mapped to 0xffffc90021500000, using 8128k, total 8128k
[    0.787621] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    0.787622] efifb: scrolling: redraw
[    0.787625] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.795351] Console: switching to colour frame buffer device 240x67
[    0.802918] fb0: EFI VGA frame buffer device
[    0.802926] intel_idle: MWAIT substates: 0x11142120
[    0.802928] intel_idle: v0.4 model 0x45
[    0.802929] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.802997] GHES: HEST is not enabled!
[    0.803066] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.803821] Linux agpgart interface v0.103
[    0.803892] libphy: Fixed MDIO Bus: probed
[    0.803937] i8042: PNP: PS/2 Controller [PNP030b:PS2K] at 0x60,0x64 irq 1
[    0.803939] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.804912] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.805007] mousedev: PS/2 mouse device common for all mice
[    0.805069] rtc_cmos 00:04: RTC can wake from S4
[    0.805340] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.805398] rtc_cmos 00:04: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.805567] cpuidle: using governor ladder
[    0.805788] cpuidle: using governor menu
[    0.805950] EFI Variables Facility v0.08 2004-May-17
[    0.824001] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.840483] TCP: cubic registered
[    0.840600] NET: Registered protocol family 10
[    0.840842] Key type dns_resolver registered
[    0.841435] registered taskstats version 1
[    0.841725] IMA: No TPM chip found, activating TPM-bypass!
[    0.842346] rtc_cmos 00:04: setting system clock to 2013-09-11 16:10:27 UTC (1378915827)
[    0.843222] Freeing unused kernel memory: 972K (ffffffff8157b000 - ffffffff8166e000)
[    0.918723] udevd[73]: starting version 175
[    0.954566] ACPI: bus type USB registered
[    0.954610] usbcore: registered new interface driver usbfs
[    0.954627] usbcore: registered new interface driver hub
[    0.957324] thermal LNXTHERM:00: registered as thermal_zone0
[    0.957331] ACPI: Thermal Zone [TZ01] (49 C)
[    0.958164] thermal LNXTHERM:01: registered as thermal_zone1
[    0.958169] ACPI: Thermal Zone [TZ02] (51 C)
[    0.958305] SCSI subsystem initialized
[    0.960000] ACPI: bus type ATA registered
[    0.961703] usbcore: registered new device driver usb
[    0.962552] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    0.962561] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.962574] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    0.962781] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.962826] xhci_hcd 0000:00:14.0: irq 56 for MSI/MSI-X
[    0.962940] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.962945] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.962949] usb usb1: Product: xHCI Host Controller
[    0.962953] usb usb1: Manufacturer: Linux 3.11-0.slh.2-aptosid-amd64 xhci_hcd
[    0.962957] usb usb1: SerialNumber: 0000:00:14.0
[    0.964005] xHCI xhci_add_endpoint called for root hub
[    0.964010] xHCI xhci_check_bandwidth called for root hub
[    0.964098] hub 1-0:1.0: USB hub found
[    0.964126] hub 1-0:1.0: 9 ports detected
[    0.968110] libata version 3.00 loaded.
[    0.977813] sdhci: Secure Digital Host Controller Interface driver
[    0.977819] sdhci: Copyright(c) Pierre Ossman
[    0.979104] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.979114] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    0.979173] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    0.979178] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.979182] usb usb2: Product: xHCI Host Controller
[    0.979186] usb usb2: Manufacturer: Linux 3.11-0.slh.2-aptosid-amd64 xhci_hcd
[    0.979189] usb usb2: SerialNumber: 0000:00:14.0
[    0.982343] xHCI xhci_add_endpoint called for root hub
[    0.982349] xHCI xhci_check_bandwidth called for root hub
[    0.982401] hub 2-0:1.0: USB hub found
[    0.982420] hub 2-0:1.0: 4 ports detected
[    0.994965] ahci 0000:00:1f.2: version 3.0
[    0.995253] ahci 0000:00:1f.2: irq 57 for MSI/MSI-X
[    0.995371] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x1 impl SATA mode
[    0.995378] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst 
[    0.995388] ahci 0000:00:1f.2: setting latency timer to 64
[    0.996241] scsi0 : ahci
[    0.996364] scsi1 : ahci
[    0.996460] scsi2 : ahci
[    0.996558] scsi3 : ahci
[    0.996659] ata1: SATA max UDMA/133 abar m2048@0xb041d000 port 0xb041d100 irq 57
[    0.996663] ata2: DUMMY
[    0.996666] ata3: DUMMY
[    0.996668] ata4: DUMMY
[    0.999061] mmc0: SDHCI controller on ACPI [INT33C6:00] using ADMA
[    1.000689] hidraw: raw HID events driver (C) Jiri Kosina
[    1.000836] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    1.008074] alg: No test for crc32 (crc32-pclmul)
[    1.062656] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
[    1.140436] mmc0: new high speed SDIO card at address 0001
[    1.300972] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.303823] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.303937] ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES) succeeded
[    1.304264] ata1.00: ATA-9: SAMSUNG MZNTD256HAGL-00000, DXT2300Q, max UDMA/133
[    1.304269] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.304742] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.304814] ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES) succeeded
[    1.305337] ata1.00: configured for UDMA/133
[    1.305623] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG MZNTD256 DXT2 PQ: 0 ANSI: 5
[    1.309933] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.310054] sd 0:0:0:0: [sda] Write Protect is off
[    1.310060] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.310159] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.312681]  sda: sda1 sda2 sda3 sda4
[    1.313614] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.315610] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.331867] usb 1-1: new high-speed USB device number 2 using xhci_hcd
[    1.360947] usb 1-1: New USB device found, idVendor=148f, idProduct=3070
[    1.360954] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.360957] usb 1-1: Product: 802.11 n WLAN
[    1.360961] usb 1-1: Manufacturer: Ralink
[    1.360963] usb 1-1: SerialNumber: 1.0
[    1.375175] device-mapper: uevent: version 1.0.3
[    1.375269] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
[    1.393327] bio: create slab <bio-1> at 1
[    1.427797] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    1.515769] usb 1-2: new high-speed USB device number 3 using xhci_hcd
[    1.528373] usb 1-2: New USB device found, idVendor=1307, idProduct=0165
[    1.528381] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.528385] usb 1-2: Product: USB Mass Storage Device
[    1.528389] usb 1-2: Manufacturer: USBest Technology
[    1.528392] usb 1-2: SerialNumber: 00000000001516
[    1.592707] udevd[435]: starting version 175
[    1.658992] ACPI: Requesting acpi_cpufreq
[    1.669681] ACPI: AC Adapter [ADP1] (on-line)
[    1.681060] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.681075] ACPI: Power Button [PWRB]
[    1.681696] usb 1-3: new high-speed USB device number 4 using xhci_hcd
[    1.697062] [drm] Initialized drm 1.1.0 20060810
[    1.697377] ACPI Warning: 0x0000000000003040-0x000000000000305f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130517/utaddress-251)
[    1.697399] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.698151] ACPI Warning: 0x0000000000001828-0x000000000000182f SystemIO conflicts with Region \PMIO 1 (20130517/utaddress-251)
[    1.698172] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.698183] ACPI Warning: 0x0000000000000830-0x000000000000083f SystemIO conflicts with Region \GPRL 1 (20130517/utaddress-251)
[    1.698196] ACPI Warning: 0x0000000000000830-0x000000000000083f SystemIO conflicts with Region \GPR_ 2 (20130517/utaddress-251)
[    1.698207] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.698213] ACPI Warning: 0x0000000000000800-0x000000000000082f SystemIO conflicts with Region \GPRL 1 (20130517/utaddress-251)
[    1.698223] ACPI Warning: 0x0000000000000800-0x000000000000082f SystemIO conflicts with Region \GPR_ 2 (20130517/utaddress-251)
[    1.698234] ACPI Warning: 0x0000000000000800-0x000000000000082f SystemIO conflicts with Region \IO_D 3 (20130517/utaddress-251)
[    1.698246] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.698251] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    1.714519] mei_me 0000:00:16.0: setting latency timer to 64
[    1.714683] mei_me 0000:00:16.0: irq 58 for MSI/MSI-X
[    1.733478] mei_me 0000:00:16.0: NFC MEI VERSION: IVN 0x1 Vendor ID 0x1 Type 0x1
[    1.783624] tsc: Refined TSC clocksource calibration: 2294.687 MHz
[    1.785444] usb 1-3: New USB device found, idVendor=0bda, idProduct=5722
[    1.785458] usb 1-3: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    1.785467] usb 1-3: Product: Front Camera
[    1.785474] usb 1-3: Manufacturer: 1458700110E5694S
[    1.785481] usb 1-3: SerialNumber: 200901010001
[    1.796945] [drm] Memory usable by graphics device = 2048M
[    1.796959] checking generic (a0000000 7f0000) vs hw (a0000000 10000000)
[    1.796965] fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing generic driver
[    1.797023] Console: switching to colour dummy device 80x25
[    1.800060] sony_laptop: Sony Notebook Control Driver v0.6
[    1.800350] input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/SNY5001:00/input/input2
[    1.800475] input: Sony Vaio Jogdial as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/SNY5001:00/input/input3
[    1.801292] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    1.811724] ACPI: Battery Slot [BAT1] (battery present)
[    1.813848] i915 0000:00:02.0: setting latency timer to 64
[    1.870364] i915 0000:00:02.0: irq 59 for MSI/MSI-X
[    1.870397] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.870402] [drm] Driver supports precise vblank timestamp query.
[    1.870627] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.877204] iTCO_vendor_support: vendor-support=0
[    1.877973] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    1.878041] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[    1.886702] nfc: nfc_init: NFC Core ver 0.1
[    1.886792] NET: Registered protocol family 39
[    1.895848] Probing NFC pn544
[    1.922737] fbcon: inteldrmfb (fb0) is primary device
[    1.944580] usb 1-4: new high-speed USB device number 5 using xhci_hcd
[    1.958150] usb 1-4: New USB device found, idVendor=12d1, idProduct=1570
[    1.958155] usb 1-4: New USB device strings: Mfr=5, Product=4, SerialNumber=0
[    1.958158] usb 1-4: Product: HUAWEI Mobile Broadband Module
[    1.958161] usb 1-4: Manufacturer: Huawei Technologies Co., Ltd.
[    1.984907] media: Linux media interface: v0.10
[    1.987263] usb-storage 1-2:1.0: USB Mass Storage device detected
[    1.987425] scsi4 : usb-storage 1-2:1.0
[    1.987696] usbcore: registered new interface driver usb-storage
[    1.989255] usbcore: registered new interface driver usbserial
[    1.989289] usbcore: registered new interface driver usbserial_generic
[    1.989314] usbserial: USB Serial support registered for generic
[    1.993947] Linux video capture interface: v2.00
[    1.999907] cfg80211: Calling CRDA to update world regulatory domain
[    2.000484] usbcore: registered new interface driver option
[    2.000518] usbserial: USB Serial support registered for GSM modem (1-port)
[    2.000672] option 1-4:1.0: GSM modem (1-port) converter detected
[    2.000938] usb 1-4: GSM modem (1-port) converter now attached to ttyUSB0
[    2.000995] option 1-4:1.1: GSM modem (1-port) converter detected
[    2.001163] usb 1-4: GSM modem (1-port) converter now attached to ttyUSB1
[    2.001207] option 1-4:1.2: GSM modem (1-port) converter detected
[    2.001356] usb 1-4: GSM modem (1-port) converter now attached to ttyUSB2
[    2.001496] option 1-4:1.5: GSM modem (1-port) converter detected
[    2.001648] usb 1-4: GSM modem (1-port) converter now attached to ttyUSB3
[    2.015187] uvcvideo: Found UVC 1.00 device Front Camera (0bda:5722)
[    2.026805] input: Front Camera as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/input/input5
[    2.027096] usbcore: registered new interface driver uvcvideo
[    2.027098] USB Video Class driver (1.1.1)
[    2.062889] usb 2-4: new SuperSpeed USB device number 2 using xhci_hcd
[    2.163388] usb 2-4: New USB device found, idVendor=0bda, idProduct=58df
[    2.163393] usb 2-4: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    2.163396] usb 2-4: Product: Rear Camera
[    2.163399] usb 2-4: Manufacturer: Generic
[    2.163402] usb 2-4: SerialNumber: 200901010001
[    2.181739] uvcvideo: Found UVC 1.00 device Rear Camera (0bda:58df)
[    2.190316] input: Rear Camera as /devices/pci0000:00/0000:00:14.0/usb2/2-4/2-4:1.0/input/input6
[    2.228829] usb 1-1: reset high-speed USB device number 2 using xhci_hcd
[    2.250922] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88024f8f5240
[    2.250927] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88024f8f5200
[    2.250930] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88024f8f5280
[    2.250934] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88024f8f52c0
[    2.250937] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88024f8f5300
[    2.250941] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88024f8f5340
[    2.250944] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88024f8f5380
[    2.252025] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 3070, rev 0201 detected
[    2.267131] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0005 detected
[    2.276125] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    2.276891] usbcore: registered new interface driver rt2800usb
[    2.783551] Switched to clocksource tsc
[    2.989850] scsi 4:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
[    2.990409] sd 4:0:0:0: Attached scsi generic sg1 type 0
[    2.990816] sd 4:0:0:0: [sdb] 31588352 512-byte logical blocks: (16.1 GB/15.0 GiB)
[    2.991169] sd 4:0:0:0: [sdb] Write Protect is off
[    2.991174] sd 4:0:0:0: [sdb] Mode Sense: 00 00 00 00
[    2.991553] sd 4:0:0:0: [sdb] Asking for cache data failed
[    2.991558] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    2.993916] sd 4:0:0:0: [sdb] Asking for cache data failed
[    2.993919] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    3.134557]  sdb: sdb1
[    3.136477] sd 4:0:0:0: [sdb] Asking for cache data failed
[    3.136481] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    3.136487] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    3.391738] Console: switching to colour frame buffer device 240x67
[    3.421160] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.421167] i915 0000:00:02.0: registered panic notifier
[    3.436846] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    3.437019] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
[    3.437213] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.437507] INT33C5:00: ttyS0 at MMIO 0xb0420000 (irq = 13) is a 16550A
[    3.444075] snd_hda_intel 0000:00:03.0: irq 60 for MSI/MSI-X
[    3.444842] snd_hda_intel 0000:00:1b.0: irq 61 for MSI/MSI-X
[    3.455836] ALSA hda_codec.c:570 hda_codec: invalid CONNECT_LIST verb 5[1]:0
[    3.455918] ALSA hda_codec.c:570 hda_codec: invalid CONNECT_LIST verb 6[1]:0
[    3.455997] ALSA hda_codec.c:570 hda_codec: invalid CONNECT_LIST verb 7[1]:0
[    3.459500] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
[    3.459740] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
[    3.459919] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
[    3.460971] hda_codec: ALC282: SKU not ready 0x411111f0
[    3.477785] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[    3.478014] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[    3.722621] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    4.244851] EXT4-fs (dm-0): re-mounted. Opts: (null)
[    4.492835] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro
[    4.790386] fuse init (API version 7.22)
[   12.664830] sha256_ssse3: Using AVX2 optimized SHA-256 implementation
[   13.227265] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   13.278131] kjournald starting.  Commit interval 5 seconds
[   13.278300] EXT3-fs (dm-1): using internal journal
[   13.278310] EXT3-fs (dm-1): mounted filesystem with writeback data mode
[   13.298636] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   13.300938] XFS (dm-2): Mounting Filesystem
[   13.464055] XFS (dm-2): Ending clean mount
[   13.485641] XFS (dm-3): Mounting Filesystem
[   13.506267] XFS (dm-3): Ending clean mount
[   13.525544] XFS (dm-6): Mounting Filesystem
[   13.567961] XFS (dm-6): Ending clean mount
[   14.383202] ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
[   14.383832] ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.29
[   14.533064] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   14.540920] NET: Registered protocol family 17
[   14.810420] lp: driver loaded but no devices found
[   14.822534] ppdev: user-space parallel port driver
[   14.994045] Bluetooth: Core ver 2.16
[   14.994075] NET: Registered protocol family 31
[   14.994079] Bluetooth: HCI device and connection manager initialized
[   14.994093] Bluetooth: HCI socket layer initialized
[   14.994100] Bluetooth: L2CAP socket layer initialized
[   14.994112] Bluetooth: SCO socket layer initialized
[   15.002398] Bluetooth: RFCOMM TTY layer initialized
[   15.002429] Bluetooth: RFCOMM socket layer initialized
[   15.002435] Bluetooth: RFCOMM ver 1.11
[   15.003830] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.003838] Bluetooth: BNEP filters: protocol multicast
[   15.003856] Bluetooth: BNEP socket layer initialized
[ 1964.925090] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1965.891651] ieee80211 phy0: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 0
[ 1965.891688] ieee80211 phy0: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 0
[ 1965.891694] ieee80211 phy0: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 0
[ 1970.424080] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1971.418582] ieee80211 phy0: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 0
[ 1971.418623] ieee80211 phy0: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 0
[ 1971.418630] ieee80211 phy0: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 0
[ 1971.596362] wlan0: authenticate with 00:1f:1f:5a:a1:30
[ 1971.620326] wlan0: send auth to 00:1f:1f:5a:a1:30 (try 1/3)
[ 1971.722227] wlan0: send auth to 00:1f:1f:5a:a1:30 (try 2/3)
[ 1971.824268] wlan0: send auth to 00:1f:1f:5a:a1:30 (try 3/3)
[ 1971.926190] wlan0: authentication with 00:1f:1f:5a:a1:30 timed out
[ 2309.960008] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2315.822103] usb 1-1: USB disconnect, device number 2
[ 2318.339414] usb 1-1: new high-speed USB device number 6 using xhci_hcd
[ 2318.369118] usb 1-1: New USB device found, idVendor=148f, idProduct=3070
[ 2318.369129] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 2318.369135] usb 1-1: Product: 802.11 n WLAN
[ 2318.369139] usb 1-1: Manufacturer: Ralink
[ 2318.369143] usb 1-1: SerialNumber: 1.0
[ 2318.524672] usb 1-1: reset high-speed USB device number 6 using xhci_hcd
[ 2318.546787] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880250471e40
[ 2318.546799] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880250471e00
[ 2318.546804] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880250471e80
[ 2318.546810] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880250471ec0
[ 2318.546815] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880250471f00
[ 2318.546820] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880250471f40
[ 2318.546825] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880250471f80
[ 2318.547796] ieee80211 phy1: rt2x00_set_rt: Info - RT chipset 3070, rev 0201 detected
[ 2318.560765] ieee80211 phy1: rt2x00_set_rf: Info - RF chipset 0005 detected
[ 2318.561101] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[ 2318.645118] ieee80211 phy1: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
[ 2318.645188] ieee80211 phy1: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.29
[ 2318.786354] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2319.953635] wlan0: authenticate with 00:1f:1f:5a:a1:30
[ 2319.978642] wlan0: send auth to 00:1f:1f:5a:a1:30 (try 1/3)
[ 2319.980163] wlan0: authenticated
[ 2319.980306] rt2800usb 1-1:1.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[ 2319.980313] rt2800usb 1-1:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[ 2319.980386] wlan0: associate with 00:1f:1f:5a:a1:30 (try 1/3)
[ 2319.994660] wlan0: RX AssocResp from 00:1f:1f:5a:a1:30 (capab=0x411 status=0 aid=194)
[ 2319.994673] wlan0: invalid AID value 0xc2; bits 15:14 not set
[ 2319.999527] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 2319.999655] wlan0: associated
[ 2320.417839] wlan0: deauthenticating from 00:1f:1f:5a:a1:30 by local choice (reason=3)
[ 2320.466125] cfg80211: Calling CRDA to update world regulatory domain
[ 2320.478040] cfg80211: World regulatory domain updated:
[ 2320.478074] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 2320.478084] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 2320.478090] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 2320.478096] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 2320.478102] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 2320.478114] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 2327.191895] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2334.019872] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2334.920204] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 10 in queue 0
[ 2334.920245] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 10 in queue 0
[ 2334.920251] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 10 in queue 0
[ 2339.368892] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2340.544115] wlan0: authenticate with 00:1f:1f:5a:a1:30
[ 2340.556515] wlan0: send auth to 00:1f:1f:5a:a1:30 (try 1/3)
[ 2340.558035] wlan0: authenticated
[ 2340.558286] rt2800usb 1-1:1.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[ 2340.558294] rt2800usb 1-1:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[ 2340.558963] wlan0: associate with 00:1f:1f:5a:a1:30 (try 1/3)
[ 2340.572491] wlan0: RX AssocResp from 00:1f:1f:5a:a1:30 (capab=0x411 status=0 aid=194)
[ 2340.572504] wlan0: invalid AID value 0xc2; bits 15:14 not set
[ 2340.577074] wlan0: associated
[ 2340.577135] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[12736.244166] wlan0: deauthenticating from 00:1f:1f:5a:a1:30 by local choice (reason=3)
[12736.295140] cfg80211: Calling CRDA to update world regulatory domain
[12736.303750] cfg80211: World regulatory domain updated:
[12736.303757] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[12736.303763] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[12736.303768] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[12736.303772] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[12736.303776] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[12736.303779] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[12737.878130] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[12743.710943] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[12744.728061] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 0
[12744.728102] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 0
[12744.728111] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 0
[12744.908102] wlan0: authenticate with 00:1f:1f:5a:a1:30
[12744.920602] wlan0: send auth to 00:1f:1f:5a:a1:30 (try 1/3)
[12744.922798] wlan0: authenticated
[12744.922981] rt2800usb 1-1:1.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[12744.922989] rt2800usb 1-1:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[12744.923967] wlan0: associate with 00:1f:1f:5a:a1:30 (try 1/3)
[12744.937837] wlan0: RX AssocResp from 00:1f:1f:5a:a1:30 (capab=0x411 status=0 aid=194)
[12744.937846] wlan0: invalid AID value 0xc2; bits 15:14 not set
[12744.942219] wlan0: associated
[12744.942266] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[12745.044919] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 0 in queue 2
[12745.044952] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 0 in queue 2
[12745.044958] ieee80211 phy1: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 0 in queue 2
[12865.223877] mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
[12865.299503] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength init done for chip 4324 rev 5 pmurev 17
[12866.393551] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000): clkctl 0x50
[12867.402386] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000): clkctl 0x50
[12867.409143] brcmfmac: brcmf_proto_cdc_query_dcmd: brcmf_proto_cdc_msg failed w/status -5
[12867.409149] brcmfmac: brcmf_fil_cmd_data: Failed err=-5
[12867.409153] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -5
[12867.409157] brcmfmac: brcmf_bus_start: failed: -5
[12867.409167] brcmfmac: brcmf_sdbrcm_probe: dongle is not responding
[12868.416890] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000): clkctl 0x50
[12869.426308] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000): clkctl 0x50
[12869.426613] usbcore: registered new interface driver brcmfmac

--------------020904010204030203000407--
