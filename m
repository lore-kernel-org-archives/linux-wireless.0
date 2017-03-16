Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbdCPLvo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 07:51:44 -0400
Subject: Re: [PATCH v2 2/4] brcmfmac: p2p and normal ap access are not always
 possible at the same time
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170227214539.16422-1-hdegoede@redhat.com>
 <20170227214539.16422-2-hdegoede@redhat.com>
 <33689f32-1bf8-98f8-df65-278de097e435@broadcom.com>
 <738d049d-4e90-8a5d-e5c0-d037085a064c@redhat.com>
 <d0bec61e-4481-42b9-fcdd-d6a8f8f3524e@broadcom.com>
 <edc0f67d-59d7-437c-2588-e895217577cd@broadcom.com>
 <d6e96a5e-863b-5054-f370-117c10c7ce2b@redhat.com>
 <51624320-cbde-65e4-ee24-a4df8c7935d6@redhat.com>
 <f467a979-7a86-127f-4828-30f15dcd5512@broadcom.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <8b2f8c5d-d629-9cad-06e5-d7ab7d2db669@redhat.com> (sfid-20170316_125154_075495_03EF4765)
Date: Thu, 16 Mar 2017 12:51:37 +0100
MIME-Version: 1.0
In-Reply-To: <f467a979-7a86-127f-4828-30f15dcd5512@broadcom.com>
Content-Type: multipart/mixed;
 boundary="------------A5B95BC1306E5751EFD08E82"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------A5B95BC1306E5751EFD08E82
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 10-03-17 10:35, Arend Van Spriel wrote:
> On 10-3-2017 9:08, Hans de Goede wrote:
>> Hi,
>>
>> On 08-03-17 12:16, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 08-03-17 11:15, Arend Van Spriel wrote:
>>>> On 8-3-2017 10:26, Arend Van Spriel wrote:
>>>>> On 8-3-2017 9:24, Hans de Goede wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 07-03-17 11:03, Arend Van Spriel wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 27-2-2017 22:45, Hans de Goede wrote:
>>>>>>>> The firmware responding with -EBUSY when trying to add an extra
>>>>>>>> virtual-if
>>>>>>>> is a normal thing, do not print an error for this.
>>>>>>>
>>>>>>> This may be something we need to look into. It seems to me the
>>>>>>> interface
>>>>>>> combinations needs to be fixed so we do not try to provision
>>>>>>> firmware.
>>>>>>> Can you explain the scenario here?
>>>>>>
>>>>>> I'm not doing anything special just connecting to my isp provided
>>>>>> accesspoint
>>>>>> using NetworkManager.
>>>>>
>>>>> Ok. So it is probably the P2P_DEVICE interface as that is the only
>>>>> interface being created in that scenario. Can you provide a log with
>>>>> brcmfmac driver debug=0x1416.
>>>>
>>>> I guess you are seeing this with 43362. Is that correct?
>>
>> Attached is a dmesg log from the brcmfmac driver build with debugging
>> enabled and brcmfmac.debug set to 0x1416.
>
> I suspect the P2P_DEVICE interface is assigned the same address as
> wlp1s0. Can you apply the change below and create the log again.
>
> Regards,
> Arend
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> b/drivers/ne
> index de19c7c..43fa9f45 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -2158,7 +2158,8 @@ struct wireless_dev *brcmf_p2p_add_vif(struct
> wiphy *wiphy
>         if (brcmf_cfg80211_vif_event_armed(cfg))
>                 return ERR_PTR(-EBUSY);
>
> -       brcmf_dbg(INFO, "adding vif \"%s\" (type=%d)\n", name, type);
> +       brcmf_dbg(INFO, "adding vif \"%s\" (type=%d, addr=%pM)\n", name,
> type,
> +                 params->macaddr);
>
>         switch (type) {
>         case NL80211_IFTYPE_P2P_CLIENT:
>

Ok, new log attached.

Regards,

Hans

--------------A5B95BC1306E5751EFD08E82
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Linux version 4.11.0-rc2+ (hans@shalem.localdomain) (gcc version 6.3.1 20161221 (Red Hat 6.3.1-1) (GCC) ) #11 SMP Wed Mar 15 09:22:00 CET 2017
[    0.000000] Command line: BOOT_IMAGE=/bzImage root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/root rd.luks.uuid=luks-5722a25d-0de7-4d36-be6b-934ab214f820 rd.lvm.lv=fedora/swap rd.lvm.lv=fedora/home rhgb quiet LANG=en_US.UTF-8 fbcon=rotate:1 dmi_product_name=GPD-WINI55 brcmfmac.debug=0x1416
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001effffff] usable
[    0.000000] BIOS-e820: [mem 0x000000001f000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000007b104fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b105000-0x000000007b61afff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007b61b000-0x000000007b63afff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b63b000-0x000000007b722fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b723000-0x000000007ba6efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007ba6f000-0x000000007bffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000e3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fea00000-0x00000000feafffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed03000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed06000-0x00000000fed06fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed09fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fedbffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000017fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.40 by American Megatrends
[    0.000000] efi:  ESRT=0x7b619000  ACPI=0x7b67f000  ACPI 2.0=0x7b67f000  SMBIOS=0x7b8e3000  SMBIOS 3.0=0x7b8e2000 
[    0.000000] SMBIOS 3.0.0 present.
[    0.000000] DMI: Default string GPD-WINI55/Default string, BIOS 5.11 11/18/2016
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x180000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07E000000 mask FFE000000 uncachable
[    0.000000]   2 base 07D000000 mask FFF000000 uncachable
[    0.000000]   3 base 07C800000 mask FFF800000 uncachable
[    0.000000]   4 base 07C400000 mask FFFC00000 uncachable
[    0.000000]   5 base 100000000 mask F80000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] e820: update [mem 0x7c400000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x7c000 max_arch_pfn = 0x400000000
[    0.000000] esrt: ESRT header is not in the memory map.
[    0.000000] Base memory trampoline at [ffff8c78c0098000] 98000 size 24576
[    0.000000] BRK [0x2737e000, 0x2737efff] PGTABLE
[    0.000000] BRK [0x2737f000, 0x2737ffff] PGTABLE
[    0.000000] BRK [0x27380000, 0x27380fff] PGTABLE
[    0.000000] BRK [0x27381000, 0x27381fff] PGTABLE
[    0.000000] BRK [0x27382000, 0x27382fff] PGTABLE
[    0.000000] BRK [0x27383000, 0x27383fff] PGTABLE
[    0.000000] BRK [0x27384000, 0x27384fff] PGTABLE
[    0.000000] BRK [0x27385000, 0x27385fff] PGTABLE
[    0.000000] Secure boot could not be determined
[    0.000000] RAMDISK: [mem 0x3ed10000-0x3fffafff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000000007B67F000 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x000000007B67F0B0 0000E4 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000007B69CD60 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x000000007B67F230 01DB2C (v02 ALASKA A M I    01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x000000007B722F80 000040
[    0.000000] ACPI: APIC 0x000000007B69CE70 000084 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000007B69CEF8 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x000000007B69CF40 00009C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x000000007B69CFE0 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x000000007B69D020 00415C (v01 DptfTb DptfTab  00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000007B6A1180 000645 (v01 CpuDpf CpuDptf  00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000007B6A17C8 000058 (v01 LowPM  LowPwrM  00001000 INTL 20120913)
[    0.000000] ACPI: UEFI 0x000000007B6A1820 000042 (v01 ALASKA A M I    00000000      00000000)
[    0.000000] ACPI: SSDT 0x000000007B6A1868 000269 (v01 UsbCTb UsbCTab  00001000 INTL 20120913)
[    0.000000] ACPI: HPET 0x000000007B6A1AD8 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x000000007B6A1B10 000763 (v01 PmRef  CpuPm    00003000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000007B6A2278 000290 (v01 PmRef  Cpu0Tst  00003000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000007B6A2508 00017A (v01 PmRef  ApTst    00003000 INTL 20120913)
[    0.000000] ACPI: LPIT 0x000000007B6A2688 000104 (v01 ALASKA A M I    00000005 MSFT 0100000D)
[    0.000000] ACPI: BCFG 0x000000007B6A2790 000139 (v01 INTEL  BATTCONF 00000001 INTL 00000000)
[    0.000000] ACPI: PRAM 0x000000007B6A28D0 000030 (v01                 00000001      00000000)
[    0.000000] ACPI: BGRT 0x000000007B6A2900 000038 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: TPM2 0x000000007B6A2938 000034 (v03        Tpm2Tabl 00000001 AMI  00000000)
[    0.000000] ACPI: CSRT 0x000000007B6A2970 00014C (v00 INTEL  LANFORDC 00000005 MSFT 0100000D)
[    0.000000] ACPI: WDAT 0x000000007B6A2AC0 000104 (v01                 00000000      00000000)
[    0.000000] ACPI: SSDT 0x000000007B6A2BC8 00415C (v01 DptfTb DptfTab  00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000007B6A6D28 000645 (v01 CpuDpf CpuDptf  00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000007B6A7370 000058 (v01 LowPM  LowPwrM  00001000 INTL 20120913)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000017fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x17ffd3000-0x17fffdfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000017fffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000008efff]
[    0.000000]   node   0: [mem 0x0000000000090000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001effffff]
[    0.000000]   node   0: [mem 0x0000000020200000-0x000000007b104fff]
[    0.000000]   node   0: [mem 0x000000007b61b000-0x000000007b63afff]
[    0.000000]   node   0: [mem 0x000000007ba6f000-0x000000007bffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000017fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000017fffffff]
[    0.000000] On node 0 totalpages: 1025106
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7763 pages used for memmap
[    0.000000]   DMA32 zone: 496822 pages, LIFO batch:31
[    0.000000]   Normal zone: 8192 pages used for memmap
[    0.000000]   Normal zone: 524288 pages, LIFO batch:31
[    0.000000] tboot: non-0 tboot_addr but it is not of type E820_RESERVED
[    0.000000] Reserving Intel graphics memory at 0x000000007cd00000-0x000000007ecfffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-114
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x1f000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b105000-0x7b61afff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b63b000-0x7b722fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b723000-0x7ba6efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7c000000-0x7ccfffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7cd00000-0x7ecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ed00000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xe3ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe4000000-0xfe9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfea00000-0xfeafffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeb00000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed02000-0xfed02fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed03000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed05fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed06000-0xfed06fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed07000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed09fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed0a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1d000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfedbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfedc0000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
[    0.000000] e820: [mem 0x7ed00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] percpu: Embedded 36 pages/cpu @ffff8c7a3fc00000 s108824 r8192 d30440 u524288
[    0.000000] pcpu-alloc: s108824 r8192 d30440 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1009066
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/bzImage root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/root rd.luks.uuid=luks-5722a25d-0de7-4d36-be6b-934ab214f820 rd.lvm.lv=fedora/swap rd.lvm.lv=fedora/home rhgb quiet LANG=en_US.UTF-8 fbcon=rotate:1 dmi_product_name=GPD-WINI55 brcmfmac.debug=0x1416
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3878220K/4100424K available (8647K kernel code, 1615K rwdata, 3584K rodata, 2148K init, 1816K bss, 222204K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:1024 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 1600.000 MHz processor
[    0.000019] Calibrating delay loop (skipped), value calculated using timer frequency.. 3200.00 BogoMIPS (lpj=1600000)
[    0.000026] pid_max: default: 32768 minimum: 301
[    0.000076] ACPI: Core revision 20170119
[    0.040675] ACPI: 4 ACPI AML tables successfully acquired and loaded
[    0.041577] Security Framework initialized
[    0.041583] Yama: becoming mindful.
[    0.041594] SELinux:  Initializing.
[    0.041643] SELinux:  Starting in permissive mode
[    0.042318] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.044700] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.045803] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.045815] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.046436] CPU: Physical Processor ID: 0
[    0.046439] CPU: Processor Core ID: 0
[    0.046445] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.046447] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.046460] mce: CPU supports 6 MCE banks
[    0.046471] CPU0: Thermal monitoring enabled (TM1)
[    0.046478] process: using mwait in idle threads
[    0.046484] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.046486] Last level dTLB entries: 4KB 256, 2MB 16, 4MB 16, 1GB 0
[    0.046862] Freeing SMP alternatives memory: 32K
[    0.053763] ftrace: allocating 31801 entries in 125 pages
[    0.070245] smpboot: Max logical packages: 1
[    0.072000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.081646] TSC deadline timer enabled
[    0.081656] smpboot: CPU0: Intel(R) Atom(TM) x7-Z8700  CPU @ 1.60GHz (family: 0x6, model: 0x4c, stepping: 0x3)
[    0.081833] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, 8-deep LBR, full-width counters, Intel PMU driver.
[    0.081858] ... version:                3
[    0.081859] ... bit width:              40
[    0.081861] ... generic registers:      2
[    0.081862] ... value mask:             000000ffffffffff
[    0.081864] ... max period:             0000007fffffffff
[    0.081865] ... fixed-purpose events:   3
[    0.081866] ... event mask:             0000000700000003
[    0.083145] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.083217] smp: Bringing up secondary CPUs ...
[    0.083668] x86: Booting SMP configuration:
[    0.083671] .... node  #0, CPUs:      #1 #2 #3
[    0.263144] smp: Brought up 1 node, 4 CPUs
[    0.263144] smpboot: Total of 4 processors activated (12829.47 BogoMIPS)
[    0.264119] sched_clock: Marking stable (264000000, 0)->(280240275, -16240275)
[    0.265212] devtmpfs: initialized
[    0.265347] x86/mm: Memory block size: 128MB
[    0.274608] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] (4096 bytes)
[    0.274611] PM: Registering ACPI NVS region [mem 0x7b63b000-0x7b722fff] (950272 bytes)
[    0.274794] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.274814] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.274992] pinctrl core: initialized pinctrl subsystem
[    0.275117] RTC time: 11:49:08, date: 03/16/17
[    0.275428] NET: Registered protocol family 16
[    0.276089] cpuidle: using governor menu
[    0.276093] PCCT header not found.
[    0.276294] ACPI: bus type PCI registered
[    0.276299] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.276507] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.276625] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.276632] PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000) (size reduced!)
[    0.276648] PCI: Using configuration type 1 for base access
[    0.280613] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.281460] ACPI: Added _OSI(Module Device)
[    0.281463] ACPI: Added _OSI(Processor Device)
[    0.281465] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.281466] ACPI: Added _OSI(Processor Aggregator Device)
[    0.316387] ACPI: Interpreter enabled
[    0.316435] ACPI: (supports S0 S4 S5)
[    0.316440] ACPI: Using IOAPIC for interrupt routing
[    0.316517] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.317552] ACPI: Power Resource [P18W] (off)
[    0.317652] ACPI: Power Resource [P33W] (off)
[    0.319778] ACPI: Power Resource [ID3C] (off)
[    0.322366] ACPI: Power Resource [USBC] (on)
[    0.323511] ACPI: Power Resource [WWPR] (off)
[    0.324250] ACPI: Power Resource [WWPR] (off)
[    0.325563] ACPI: Power Resource [WWPR] (off)
[    0.326268] ACPI: Power Resource [WWPR] (off)
[    0.327129] ACPI: Power Resource [WWPR] (off)
[    0.327939] ACPI: Power Resource [WWPR] (off)
[    0.344129] ACPI: Power Resource [CLK3] (on)
[    0.344238] ACPI: Power Resource [CLK4] (off)
[    0.352827] ACPI: Power Resource [CLK2] (on)
[    0.353510] ACPI: Power Resource [CLK1] (on)
[    0.355800] ACPI: Power Resource [CLK0] (on)
[    0.355903] ACPI: Power Resource [CLK1] (on)
[    0.356187] ACPI: Power Resource [P28W] (off)
[    0.356868] ACPI: Power Resource [P4BW] (off)
[    0.371669] ACPI: Power Resource [P28X] (off)
[    0.371787] ACPI: Power Resource [P18X] (off)
[    0.371893] ACPI: Power Resource [P12X] (off)
[    0.371999] ACPI: Power Resource [P28P] (off)
[    0.372100] ACPI: Power Resource [P18P] (off)
[    0.372198] ACPI: Power Resource [P19X] (off)
[    0.372304] ACPI: Power Resource [P06X] (off)
[    0.372401] ACPI: Power Resource [P12A] (off)
[    0.372507] ACPI: Power Resource [P28T] (off)
[    0.372608] ACPI: Power Resource [P18D] (off)
[    0.372709] ACPI: Power Resource [P18T] (off)
[    0.372818] ACPI: Power Resource [P3P3] (off)
[    0.372921] ACPI: Power Resource [P12T] (off)
[    0.373036] ACPI: Power Resource [P12W] (off)
[    0.373140] ACPI: Power Resource [P33X] (off)
[    0.381696] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.381710] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.382244] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.382275] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.383617] PCI host bridge to bus 0000:00
[    0.383623] pci_bus 0000:00: root bus resource [io  0x0070-0x0077]
[    0.383627] pci_bus 0000:00: root bus resource [io  0x0000-0x006f window]
[    0.383630] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 window]
[    0.383633] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.383636] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.383640] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.383643] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff window]
[    0.383646] pci_bus 0000:00: root bus resource [mem 0x20000000-0x201fffff window]
[    0.383649] pci_bus 0000:00: root bus resource [mem 0x7cd00001-0x7ed00000 window]
[    0.383652] pci_bus 0000:00: root bus resource [mem 0x80000000-0xdfffffff window]
[    0.383657] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.383674] pci 0000:00:00.0: [8086:2280] type 00 class 0x060000
[    0.384220] pci 0000:00:02.0: [8086:22b0] type 00 class 0x030000
[    0.384249] pci 0000:00:02.0: reg 0x10: [mem 0xa0000000-0xa0ffffff 64bit]
[    0.384264] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x9fffffff 64bit pref]
[    0.384275] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.384627] pci 0000:00:0b.0: [8086:22dc] type 00 class 0x118000
[    0.384650] pci 0000:00:0b.0: reg 0x10: [mem 0xa1a3b000-0xa1a3bfff 64bit]
[    0.385051] pci 0000:00:14.0: [8086:22b5] type 00 class 0x0c0330
[    0.385086] pci 0000:00:14.0: reg 0x10: [mem 0xa1a00000-0xa1a0ffff 64bit]
[    0.385194] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.385537] pci 0000:00:1a.0: [8086:2298] type 00 class 0x108000
[    0.385562] pci 0000:00:1a.0: reg 0x10: [mem 0xa1900000-0xa19fffff]
[    0.385576] pci 0000:00:1a.0: reg 0x14: [mem 0xa1800000-0xa18fffff]
[    0.385679] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.386150] pci 0000:00:1c.0: [8086:22c8] type 01 class 0x060400
[    0.387762] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.388398] pci 0000:00:1f.0: [8086:229c] type 00 class 0x060100
[    0.389470] pci 0000:01:00.0: [14e4:43ec] type 00 class 0x028000
[    0.389504] pci 0000:01:00.0: reg 0x10: [mem 0xa1400000-0xa1407fff 64bit]
[    0.389526] pci 0000:01:00.0: reg 0x18: [mem 0xa1000000-0xa13fffff 64bit]
[    0.389729] pci 0000:01:00.0: supports D1 D2
[    0.389732] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.393185] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.393274] pci 0000:00:1c.0:   bridge window [mem 0xa1000000-0xa14fffff]
[    0.407887] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.408056] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.408229] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.408394] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.408556] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.408726] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.408890] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.409050] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.423147] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.423153] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.423159] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.423160] vgaarb: loaded
[    0.423464] SCSI subsystem initialized
[    0.423587] libata version 3.00 loaded.
[    0.423641] ACPI: bus type USB registered
[    0.423697] usbcore: registered new interface driver usbfs
[    0.423717] usbcore: registered new interface driver hub
[    0.423758] usbcore: registered new device driver usb
[    0.423961] Registered efivars operations
[    0.427359] PCI: Using ACPI for IRQ routing
[    0.430089] PCI: pci_cache_line_size set to 64 bytes
[    0.430233] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.430239] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.430244] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.430246] e820: reserve RAM buffer [mem 0x1f000000-0x1fffffff]
[    0.430247] e820: reserve RAM buffer [mem 0x7b105000-0x7bffffff]
[    0.430250] e820: reserve RAM buffer [mem 0x7b63b000-0x7bffffff]
[    0.430501] NetLabel: Initializing
[    0.430504] NetLabel:  domain hash size = 128
[    0.430506] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.430542] NetLabel:  unlabeled traffic allowed by default
[    0.430832] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.430841] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.432910] clocksource: Switched to clocksource hpet
[    0.469238] VFS: Disk quotas dquot_6.6.0
[    0.469291] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.469504] pnp: PnP ACPI init
[    0.469853] system 00:00: [io  0x0680-0x069f] has been reserved
[    0.469858] system 00:00: [io  0x0400-0x047f] could not be reserved
[    0.469862] system 00:00: [io  0x0500-0x05fe] has been reserved
[    0.469874] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.470092] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.477559] system 00:02: [mem 0xa1a39000-0xa1a39fff] has been reserved
[    0.477564] system 00:02: [mem 0xa1a37000-0xa1a37fff] has been reserved
[    0.477568] system 00:02: [mem 0xa1a35000-0xa1a35fff] has been reserved
[    0.477571] system 00:02: [mem 0xa1a24000-0xa1a24fff] has been reserved
[    0.477575] system 00:02: [mem 0xa1a22000-0xa1a22fff] has been reserved
[    0.477579] system 00:02: [mem 0xa1a20000-0xa1a20fff] has been reserved
[    0.477582] system 00:02: [mem 0xa1a1e000-0xa1a1efff] has been reserved
[    0.477586] system 00:02: [mem 0xa1a1c000-0xa1a1cfff] has been reserved
[    0.477589] system 00:02: [mem 0xa1a1a000-0xa1a1afff] has been reserved
[    0.477593] system 00:02: [mem 0xa1a18000-0xa1a18fff] has been reserved
[    0.477597] system 00:02: [mem 0xa1a33000-0xa1a33fff] has been reserved
[    0.477601] system 00:02: [mem 0xa1a31000-0xa1a31fff] has been reserved
[    0.477605] system 00:02: [mem 0xa1a2f000-0xa1a2ffff] has been reserved
[    0.477608] system 00:02: [mem 0xa1a2d000-0xa1a2dfff] has been reserved
[    0.477612] system 00:02: [mem 0xa1a2b000-0xa1a2bfff] has been reserved
[    0.477616] system 00:02: [mem 0xa1a29000-0xa1a29fff] has been reserved
[    0.477619] system 00:02: [mem 0xa1a27000-0xa1a27fff] has been reserved
[    0.477624] system 00:02: [mem 0xa1a25000-0xa1a25fff] has been reserved
[    0.477633] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.477923] system 00:03: [mem 0xe0000000-0xefffffff] could not be reserved
[    0.477928] system 00:03: [mem 0xfea00000-0xfeafffff] has been reserved
[    0.477934] system 00:03: [mem 0xfed01000-0xfed01fff] has been reserved
[    0.477937] system 00:03: [mem 0xfed03000-0xfed03fff] has been reserved
[    0.477941] system 00:03: [mem 0xfed06000-0xfed06fff] has been reserved
[    0.477944] system 00:03: [mem 0xfed08000-0xfed09fff] has been reserved
[    0.477948] system 00:03: [mem 0xfed80000-0xfedbffff] could not be reserved
[    0.477952] system 00:03: [mem 0xfed1c000-0xfed1cfff] has been reserved
[    0.477955] system 00:03: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.477963] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.478367] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.479977] pnp: PnP ACPI: found 5 devices
[    0.490719] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.490873] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.490963] pci 0000:00:1c.0:   bridge window [mem 0xa1000000-0xa14fffff]
[    0.491098] pci_bus 0000:00: resource 4 [io  0x0070-0x0077]
[    0.491101] pci_bus 0000:00: resource 5 [io  0x0000-0x006f window]
[    0.491104] pci_bus 0000:00: resource 6 [io  0x0078-0x0cf7 window]
[    0.491108] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.491112] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.491116] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.491120] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000fffff window]
[    0.491124] pci_bus 0000:00: resource 11 [mem 0x20000000-0x201fffff window]
[    0.491128] pci_bus 0000:00: resource 12 [mem 0x7cd00001-0x7ed00000 window]
[    0.491131] pci_bus 0000:00: resource 13 [mem 0x80000000-0xdfffffff window]
[    0.491136] pci_bus 0000:01: resource 1 [mem 0xa1000000-0xa14fffff]
[    0.491703] NET: Registered protocol family 2
[    0.492192] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.492371] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.492562] TCP: Hash tables configured (established 32768 bind 32768)
[    0.492664] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.492720] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.492969] NET: Registered protocol family 1
[    0.493011] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.493564] PCI: CLS 64 bytes, default 64
[    0.493741] Unpacking initramfs...
[    1.180286] Freeing initrd memory: 19372K
[    1.180294] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.180299] software IO TLB [mem 0x7409a000-0x7809a000] (64MB) mapped at [ffff8c793409a000-ffff8c7938099fff]
[    1.180483] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x171024fa93b, max_idle_ns: 440795253189 ns
[    1.180533] clocksource: Switched to clocksource tsc
[    1.182708] audit: initializing netlink subsys (disabled)
[    1.182820] audit: type=2000 audit(1489664949.180:1): state=initialized audit_enabled=0 res=1
[    1.183464] Initialise system trusted keyrings
[    1.183687] workingset: timestamp_bits=36 max_order=20 bucket_order=0
[    1.187261] zbud: loaded
[    1.188773] SELinux:  Registering netfilter hooks
[    1.332510] NET: Registered protocol family 38
[    1.332517] Key type asymmetric registered
[    1.332520] Asymmetric key parser 'x509' registered
[    1.332593] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    1.332689] io scheduler noop registered
[    1.332691] io scheduler deadline registered
[    1.332805] io scheduler cfq registered (default)
[    1.332807] io scheduler mq-deadline registered
[    1.333017] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    1.335161] pcieport 0000:00:1c.0: Signaling PME with IRQ 297
[    1.335309] efifb: probing for efifb
[    1.335344] efifb: framebuffer at 0x80000000, using 3600k, total 3600k
[    1.335347] efifb: mode is 720x1280x32, linelength=2880, pages=1
[    1.335348] efifb: scrolling: redraw
[    1.335352] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.344650] Console: switching to colour frame buffer device 160x45
[    1.352417] fb0: EFI VGA frame buffer device
[    1.352452] intel_idle: MWAIT substates: 0x33000020
[    1.352454] intel_idle: v0.4.1 model 0x4C
[    1.352892] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.353347] ACPI: AC Adapter [ADP1] (on-line)
[    1.353653] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    1.353661] ACPI: Lid Switch [LID0]
[    1.353752] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    1.353768] ACPI: Power Button [PWRB]
[    1.353867] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.353873] ACPI: Power Button [PWRF]
[    1.354794] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    1.354962] thermal LNXTHERM:00: registered as thermal_zone0
[    1.354965] ACPI: Thermal Zone [TZ00] (0 C)
[    1.355130] GHES: HEST is not enabled!
[    1.355464] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.376026] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.384164] 8086228A:00: ttyS4 at MMIO 0xa1a21000 (irq = 39, base_baud = 2764800) is a 16550A
[    1.386110] 8086228A:01: ttyS5 at MMIO 0xa1a1f000 (irq = 40, base_baud = 2764800) is a 16550A
[    1.387153] Non-volatile memory driver v1.3
[    1.387401] Linux agpgart interface v0.103
[    1.388635] libphy: Fixed MDIO Bus: probed
[    1.389001] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.389011] ehci-pci: EHCI PCI platform driver
[    1.389036] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.389042] ohci-pci: OHCI PCI platform driver
[    1.389070] uhci_hcd: USB Universal Host Controller Interface driver
[    1.389449] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.389716] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.390920] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x01509810
[    1.390993] xhci_hcd 0000:00:14.0: Intel Vendor Defined Cap 192 found, added intel_cht_usb_phy pdev
[    1.391006] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.391228] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.391233] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.391236] usb usb1: Product: xHCI Host Controller
[    1.391240] usb usb1: Manufacturer: Linux 4.11.0-rc2+ xhci-hcd
[    1.391243] usb usb1: SerialNumber: 0000:00:14.0
[    1.391775] hub 1-0:1.0: USB hub found
[    1.391806] hub 1-0:1.0: 7 ports detected
[    1.394424] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.394777] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.394924] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    1.394928] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.394932] usb usb2: Product: xHCI Host Controller
[    1.394937] usb usb2: Manufacturer: Linux 4.11.0-rc2+ xhci-hcd
[    1.394939] usb usb2: SerialNumber: 0000:00:14.0
[    1.395369] hub 2-0:1.0: USB hub found
[    1.395399] hub 2-0:1.0: 6 ports detected
[    1.397220] usbcore: registered new interface driver usbserial
[    1.397236] usbcore: registered new interface driver usbserial_generic
[    1.397249] usbserial: USB Serial support registered for generic
[    1.397318] i8042: PNP: No PS/2 controller found.
[    1.397691] mousedev: PS/2 mouse device common for all mice
[    1.398965] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.399032] rtc_cmos 00:04: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.399206] device-mapper: uevent: version 1.0.3
[    1.399409] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[    1.399744] intel_pstate: Intel P-state driver initializing
[    1.402169] hidraw: raw HID events driver (C) Jiri Kosina
[    1.402460] usbcore: registered new interface driver usbhid
[    1.402466] usbhid: USB HID core driver
[    1.403609] drop_monitor: Initializing network drop monitor service
[    1.404040] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.404814] Initializing XFRM netlink socket
[    1.405922] NET: Registered protocol family 10
[    1.426689] Segment Routing with IPv6
[    1.426813] mip6: Mobile IPv6
[    1.426827] NET: Registered protocol family 17
[    1.429737] microcode: sig=0x406c3, pf=0x1, revision=0x362
[    1.430593] microcode: Microcode Update Driver: v2.2.
[    1.430649] SSE version of gcm_enc/dec engaged.
[    1.500440] registered taskstats version 1
[    1.500475] Loading compiled-in X.509 certificates
[    1.509073] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    1.512564] Loaded X.509 cert 'Build time autogenerated kernel key: 864ea72a40ea0de9983f61fb15ab3b4600acc55c'
[    1.512696] zswap: loaded using pool lzo/zbud
[    1.539058] Key type big_key registered
[    1.545611] Key type encrypted registered
[    1.546583]   Magic number: 9:137:833
[    1.546956] rtc_cmos 00:04: setting system clock to 2017-03-16 11:49:10 UTC (1489664950)
[    1.547063] PM: Hibernation image not present or could not be loaded.
[    1.552113] Freeing unused kernel memory: 2148K
[    1.552117] Write protecting the kernel read-only data: 14336k
[    1.554331] Freeing unused kernel memory: 1576K
[    1.558051] Freeing unused kernel memory: 512K
[    1.562409] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    1.562418] rodata_test: all tests were successful
[    1.577631] random: systemd: uninitialized urandom read (16 bytes read)
[    1.578147] random: systemd: uninitialized urandom read (16 bytes read)
[    1.578177] random: systemd: uninitialized urandom read (16 bytes read)
[    1.581616] systemd[1]: systemd 231 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    1.581967] systemd[1]: Detected architecture x86-64.
[    1.581972] systemd[1]: Running in initial RAM disk.
[    1.582008] systemd[1]: Set hostname to <localhost.localdomain>.
[    1.599780] random: systemd-cryptse: uninitialized urandom read (16 bytes read)
[    1.697663] random: systemd: uninitialized urandom read (16 bytes read)
[    1.698030] random: systemd: uninitialized urandom read (16 bytes read)
[    1.698245] random: systemd: uninitialized urandom read (16 bytes read)
[    1.698565] random: systemd: uninitialized urandom read (16 bytes read)
[    1.701521] random: systemd: uninitialized urandom read (16 bytes read)
[    1.702199] random: systemd: uninitialized urandom read (16 bytes read)
[    1.714848] systemd[1]: Reached target Timers.
[    1.715102] systemd[1]: Listening on Journal Audit Socket.
[    1.715127] systemd[1]: Reached target Swap.
[    1.715147] systemd[1]: Reached target Local File Systems.
[    1.715232] systemd[1]: Listening on Journal Socket (/dev/log).
[    1.715317] systemd[1]: Listening on Journal Socket.
[    1.730168] i2c_dev: module verification failed: signature and/or required key missing - tainting kernel
[    1.730396] i2c /dev entries driver
[    1.735932] audit: type=1130 audit(1489664950.686:2): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-modules-load comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    1.735939] audit: type=1130 audit(1489664950.687:3): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=kmod-static-nodes comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    1.747563] audit: type=1130 audit(1489664950.700:4): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    1.748251] audit: type=1130 audit(1489664950.701:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    1.755927] usb 1-2: new low-speed USB device number 2 using xhci_hcd
[    1.774966] audit: type=1130 audit(1489664950.728:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    1.915300] audit: type=1130 audit(1489664950.868:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    1.936850] usb 1-2: New USB device found, idVendor=0603, idProduct=0002
[    1.936855] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.936857] usb 1-2: Product: USB Composite Device
[    1.936859] usb 1-2: Manufacturer: SIPODEV
[    1.936861] usb 1-2: SerialNumber: S10030-SFD-US-160412
[    1.944679] input: SIPODEV USB Composite Device as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:0603:0002.0001/input/input3
[    1.997048] hid-generic 0003:0603:0002.0001: input,hidraw0: USB HID v1.10 Keyboard [SIPODEV USB Composite Device] on usb-0000:00:14.0-2/input0
[    2.011912] input: SIPODEV USB Composite Device as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/0003:0603:0002.0002/input/input4
[    2.064872] hid-generic 0003:0603:0002.0002: input,hiddev0,hidraw1: USB HID v1.10 Mouse [SIPODEV USB Composite Device] on usb-0000:00:14.0-2/input1
[    2.220935] usb 1-3: new full-speed USB device number 3 using xhci_hcd
[    2.332297] audit: type=1130 audit(1489664951.284:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-cmdline comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.393673] usb 1-3: New USB device found, idVendor=0079, idProduct=1a00
[    2.393681] usb 1-3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    2.393686] usb 1-3: Product: Mouce for Android
[    2.396459] input: Mouce for Android as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/0003:0079:1A00.0003/input/input5
[    2.397299] hid-generic 0003:0079:1A00.0003: input,hidraw2: USB HID v1.10 Mouse [Mouce for Android] on usb-0000:00:14.0-3/input0
[    2.399775] input: Mouce for Android as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.1/0003:0079:1A00.0004/input/input6
[    2.442390] audit: type=1130 audit(1489664951.394:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-udev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.451658] hid-generic 0003:0079:1A00.0004: input,hidraw3: USB HID v1.10 Keyboard [Mouce for Android] on usb-0000:00:14.0-3/input1
[    2.459579] audit: type=1130 audit(1489664951.412:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.668253] sdhci: loading out-of-tree module taints kernel.
[    2.668636] sdhci: Secure Digital Host Controller Interface driver
[    2.668637] sdhci: Copyright(c) Pierre Ossman
[    2.683485] mmc0: SDHCI controller on ACPI [80860F14:00] using ADMA
[    2.693294] FUJITSU Extended Socket Network Device Driver - version 1.2 - Copyright (c) 2015 FUJITSU LIMITED
[    2.801201] mmc0: new HS200 MMC card at address 0001
[    3.762063] mmc1: SDHCI controller on ACPI [80860F14:02] using ADMA
[    3.766802] [drm] Memory usable by graphics device = 4096M
[    3.766815] checking generic (80000000 384000) vs hw (80000000 20000000)
[    3.766821] fb: switching to inteldrmfb from EFI VGA
[    3.767086] Console: switching to colour dummy device 80x25
[    3.768785] [drm] Replacing VGA console driver
[    3.769513] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.769519] [drm] Driver supports precise vblank timestamp query.
[    3.774940] mmcblk0: mmc0:0001 CGND3R 58.2 GiB 
[    3.775281] mmcblk0boot0: mmc0:0001 CGND3R partition 1 4.00 MiB
[    3.775481] mmcblk0boot1: mmc0:0001 CGND3R partition 2 4.00 MiB
[    3.775634] mmcblk0rpmb: mmc0:0001 CGND3R partition 3 4.00 MiB
[    3.787923] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    3.795989]  mmcblk0: p1 p2 p3
[    3.808091] [drm] Initialized i915 1.6.0 20170123 for 0000:00:02.0 on minor 0
[    3.810493] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    3.812510] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input7
[    3.812705] [drm] HDaudio controller not detected, using LPE audio instead

[    3.812784] [drm] Initialized i915 1.6.0 20170123 for 0000:00:02.0 on minor 0
[    3.818316] random: fast init done
[    4.295760] fbcon: inteldrmfb (fb0) is primary device
[    4.335291] usb 1-3: USB disconnect, device number 3
[    4.970600] Console: switching to colour frame buffer device 160x45
[    5.011901] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    5.650474] usb 1-3: new full-speed USB device number 4 using xhci_hcd
[    5.825799] usb 1-3: New USB device found, idVendor=0079, idProduct=1a00
[    5.825817] usb 1-3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    5.825828] usb 1-3: Product: Mouce for Android
[    5.832262] input: Mouce for Android as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/0003:0079:1A00.0005/input/input8
[    5.833681] hid-generic 0003:0079:1A00.0005: input,hidraw2: USB HID v1.10 Mouse [Mouce for Android] on usb-0000:00:14.0-3/input0
[    5.836677] input: Mouce for Android as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.1/0003:0079:1A00.0006/input/input9
[    5.889656] hid-generic 0003:0079:1A00.0006: input,hidraw3: USB HID v1.10 Keyboard [Mouce for Android] on usb-0000:00:14.0-3/input1
[   11.855041] kauditd_printk_skb: 12 callbacks suppressed
[   11.855050] audit: type=1130 audit(1489664960.803:15): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-cryptsetup@luks\x2d5722a25d\x2d0de7\x2d4d36\x2dbe6b\x2d934ab214f820 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.488450] audit: type=1130 audit(1489664961.440:16): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-initqueue comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.527723] random: crng init done
[   12.583097] audit: type=1130 audit(1489664961.536:17): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-fsck-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.618140] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   12.840269] audit: type=1130 audit(1489664961.792:18): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-parse-etc comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.840279] audit: type=1131 audit(1489664961.792:19): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-parse-etc comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   13.114347] audit: type=1130 audit(1489664962.066:20): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-pivot comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   13.140581] audit: type=1130 audit(1489664962.093:21): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-ask-password-plymouth comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   13.142185] audit: type=1131 audit(1489664962.094:22): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-ask-password-plymouth comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   13.142758] audit: type=1130 audit(1489664962.095:23): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-cleanup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   13.142786] audit: type=1131 audit(1489664962.095:24): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-cleanup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   13.225073] systemd-journald[195]: Received SIGTERM from PID 1 (systemd).
[   13.284467] systemd: 18 output lines suppressed due to ratelimiting
[   13.599772] SELinux: 32768 avtab hash slots, 106774 rules.
[   13.640603] SELinux: 32768 avtab hash slots, 106774 rules.
[   13.740082] SELinux:  8 users, 14 roles, 5069 types, 305 bools, 1 sens, 1024 cats
[   13.740088] SELinux:  94 classes, 106774 rules
[   13.748014] SELinux:  Permission validate_trans in class security not defined in policy.
[   13.748036] SELinux:  Permission module_load in class system not defined in policy.
[   13.748223] SELinux:  Class sctp_socket not defined in policy.
[   13.748224] SELinux:  Class icmp_socket not defined in policy.
[   13.748225] SELinux:  Class ax25_socket not defined in policy.
[   13.748226] SELinux:  Class ipx_socket not defined in policy.
[   13.748227] SELinux:  Class netrom_socket not defined in policy.
[   13.748228] SELinux:  Class atmpvc_socket not defined in policy.
[   13.748229] SELinux:  Class x25_socket not defined in policy.
[   13.748230] SELinux:  Class rose_socket not defined in policy.
[   13.748231] SELinux:  Class decnet_socket not defined in policy.
[   13.748232] SELinux:  Class atmsvc_socket not defined in policy.
[   13.748233] SELinux:  Class rds_socket not defined in policy.
[   13.748234] SELinux:  Class irda_socket not defined in policy.
[   13.748235] SELinux:  Class pppox_socket not defined in policy.
[   13.748236] SELinux:  Class llc_socket not defined in policy.
[   13.748237] SELinux:  Class can_socket not defined in policy.
[   13.748238] SELinux:  Class tipc_socket not defined in policy.
[   13.748238] SELinux:  Class bluetooth_socket not defined in policy.
[   13.748239] SELinux:  Class iucv_socket not defined in policy.
[   13.748240] SELinux:  Class rxrpc_socket not defined in policy.
[   13.748241] SELinux:  Class isdn_socket not defined in policy.
[   13.748242] SELinux:  Class phonet_socket not defined in policy.
[   13.748243] SELinux:  Class ieee802154_socket not defined in policy.
[   13.748244] SELinux:  Class caif_socket not defined in policy.
[   13.748245] SELinux:  Class alg_socket not defined in policy.
[   13.748246] SELinux:  Class nfc_socket not defined in policy.
[   13.748247] SELinux:  Class vsock_socket not defined in policy.
[   13.748248] SELinux:  Class kcm_socket not defined in policy.
[   13.748249] SELinux:  Class qipcrtr_socket not defined in policy.
[   13.748250] SELinux:  Class smc_socket not defined in policy.
[   13.748251] SELinux: the above unknown classes and permissions will be allowed
[   13.748270] SELinux:  Completing initialization.
[   13.748271] SELinux:  Setting up existing superblocks.
[   13.802119] systemd[1]: Successfully loaded SELinux policy in 302.505ms.
[   13.942116] systemd[1]: Relabelled /dev and /run in 98.544ms.
[   14.419834] EXT4-fs (dm-1): re-mounted. Opts: discard
[   14.476506] systemd-journald[794]: Received request to flush runtime journal from PID 1
[   14.928094] Bluetooth: Core ver 2.22
[   14.928554] NET: Registered protocol family 31
[   14.928557] Bluetooth: HCI device and connection manager initialized
[   14.928564] Bluetooth: HCI socket layer initialized
[   14.928568] Bluetooth: L2CAP socket layer initialized
[   14.928588] Bluetooth: SCO socket layer initialized
[   14.945475] Bluetooth: HCI UART driver ver 2.3
[   14.945478] Bluetooth: HCI UART protocol H4 registered
[   14.945480] Bluetooth: HCI UART protocol BCSP registered
[   14.945481] Bluetooth: HCI UART protocol LL registered
[   14.945482] Bluetooth: HCI UART protocol ATH3K registered
[   14.945483] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   14.945597] Bluetooth: HCI UART protocol Intel registered
[   14.945632] Bluetooth: HCI UART protocol Broadcom registered
[   14.945633] Bluetooth: HCI UART protocol QCA registered
[   14.945634] Bluetooth: HCI UART protocol AG6XX registered
[   14.945635] Bluetooth: HCI UART protocol Marvell registered
[   14.990509] input: Intel HID events as /devices/pci0000:00/INT33D5:00/input/input10
[   15.015947] dw_dmac INTL9C60:00: DesignWare DMA Controller, 8 channels
[   15.040291] dw_dmac INTL9C60:01: DesignWare DMA Controller, 8 channels
[   15.079369] intel_sst_acpi 808622A8:00: LPE base: 0xa1600000 size:0x200000
[   15.079373] intel_sst_acpi 808622A8:00: IRAM base: 0xa16c0000
[   15.079415] intel_sst_acpi 808622A8:00: DRAM base: 0xa1700000
[   15.079424] intel_sst_acpi 808622A8:00: SHIM base: 0xa1740000
[   15.079447] intel_sst_acpi 808622A8:00: Mailbox base: 0xa1744000
[   15.079452] intel_sst_acpi 808622A8:00: DDR base: 0x20000000
[   15.079564] intel_sst_acpi 808622A8:00: Got drv data max stream 25
[   15.123098] proc_thermal 0000:00:0b.0: enabling device (0000 -> 0002)
[   15.123580] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[   15.123661] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[   15.124741] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   15.279971] Goodix-TS i2c-GDIX1001:00: ID 911, version: 1060
[   15.285278] input: Goodix Capacitive TouchScreen as /devices/pci0000:00/808622C1:05/i2c-13/i2c-GDIX1001:00/input/input11
[   15.296473] brcmfmac: brcmfmac_module_init No platform data available.
[   15.296548] usbcore: registered new interface driver brcmfmac
[   15.296633] brcmfmac 0000:01:00.0: enabling device (0000 -> 0002)
[   15.296942] brcmfmac: brcmf_chip_recognition found AXI chip: BCM4356, rev=2
[   15.297374] brcmfmac: brcmf_chip_cores_check  [1 ] core 0x800:47 base 0x18000000 wrap 0x18100000
[   15.297377] brcmfmac: brcmf_chip_cores_check  [2 ] core 0x812:48 base 0x18001000 wrap 0x18101000
[   15.297379] brcmfmac: brcmf_chip_cores_check  [3 ] core 0x83e:6  base 0x18002000 wrap 0x18102000
[   15.297381] brcmfmac: brcmf_chip_cores_check  [4 ] core 0x83c:11 base 0x18003000 wrap 0x18103000
[   15.297383] brcmfmac: brcmf_chip_cores_check  [5 ] core 0x81a:22 base 0x18004000 wrap 0x18104000
[   15.297385] brcmfmac: brcmf_chip_cores_check  [6 ] core 0x829:21 base 0x18005000 wrap 0x18105000
[   15.297387] brcmfmac: brcmf_chip_cores_check  [7 ] core 0x83d:2  base 0x18006000 wrap 0x18106000
[   15.297389] brcmfmac: brcmf_chip_cores_check  [8 ] core 0x135:0  base 0x00000000 wrap 0x1810a000
[   15.297391] brcmfmac: brcmf_chip_cores_check  [9 ] core 0x240:0  base 0x00000000 wrap 0x00000000
[   15.297393] brcmfmac: brcmf_chip_set_passive Enter
[   15.395698] input: PC Speaker as /devices/platform/pcspkr/input/input12
[   15.400012] brcmfmac: brcmf_chip_set_passive Enter
[   15.400417] brcmfmac: brcmf_chip_get_raminfo RAM: base=0x180000 size=786432 (0xc0000) sr=0 (0x0)
[   15.400441] brcmfmac: brcmf_chip_setup ccrev=47, pmurev=24, pmucaps=0x420e5f18
[   15.400443] brcmfmac: brcmf_get_module_param Enter, bus=2, chip=17238, rev=2
[   15.400447] brcmfmac: brcmf_fw_get_firmwares_pcie enter: dev=0000:01:00.0
[   15.415015] brcmfmac: brcmf_fw_request_code_done enter: dev=0000:01:00.0
[   15.417273] brcmfmac: brcmf_fw_request_nvram_done enter: dev=0000:01:00.0
[   15.481650] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: discard
[   15.607825] brcmfmac: brcmf_chip_set_active Enter
[   15.691964] input: gpio-keys as /devices/platform/gpio-keys.1.auto/input/input13
[   15.693409] input: gpio-keys as /devices/platform/gpio-keys.2.auto/input/input14
[   15.714569] brcmfmac: brcmf_attach Enter
[   15.714756] brcmfmac: brcmf_fweh_register event handler registered for PSM_WATCHDOG
[   15.714757] brcmfmac: brcmf_proto_attach Enter
[   15.716598] brcmfmac: brcmf_bus_started 
[   15.716603] brcmfmac: brcmf_add_if Enter, bsscfgidx=0, ifidx=0
[   15.716604] brcmfmac: brcmf_add_if allocate netdev interface
[   15.716622] brcmfmac: brcmf_add_if  ==== pid:2a, if:wlan%d (00:00:00:00:00:00) created ===
[   15.716624] brcmfmac: brcmf_bus_change_state 0 -> 1
[   15.717841] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=cur_etheraddr, len=6
[   15.717843] brcmutil: data
[   15.717847] 00000000: 44 2c 05 9e c9 02                                D,....
[   15.718084] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=98, len=68
[   15.718086] brcmutil: data
[   15.718087] 00000000: e4 14 00 00 a3 43 00 00 69 20 29 00 02 00 00 00  .....C..i ).....
[   15.718089] 00000010: 30 00 00 00 3e 07 00 00 e4 14 00 00 21 11 00 00  0...>.......!...
[   15.718090] 00000020: 77 b4 23 07 00 00 00 00 00 00 00 00 56 43 00 00  w.#.........VC..
[   15.718091] 00000030: 0b 00 00 00 11 00 00 00 00 00 00 00 02 00 00 00  ................
[   15.718537] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=ver, len=256
[   15.718539] brcmutil: data
[   15.718542] 00000000: 77 6c 30 3a 20 4f 63 74 20 32 32 20 32 30 31 35  wl0: Oct 22 2015
[   15.718544] 00000010: 20 30 36 3a 31 36 3a 34 31 20 76 65 72 73 69 6f   06:16:41 versio
[   15.718545] 00000020: 6e 20 37 2e 33 35 2e 31 38 30 2e 31 31 39 20 28  n 7.35.180.119 (
[   15.718546] 00000030: 72 35 39 34 35 33 35 29 20 46 57 49 44 20 30 31  r594535) FWID 01
[   15.718548] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Oct 22 2015 06:16:41 version 7.35.180.119 (r594535) FWID 01-1a5c4016
[   15.718550] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mpc, len=4
[   15.718551] brcmutil: data
[   15.718552] 00000000: 01 00 00 00                                      ....
[   15.718877] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=join_pref, len=8
[   15.718900] brcmutil: data
[   15.718903] 00000000: 04 02 08 01 01 02 00 00                          ........
[   15.720092] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=event_msgs, len=18
[   15.720094] brcmutil: data
[   15.720098] 00000000: 00 00 00 00 00 00 40 00 00 00 00 00 00 00 00 00  ......@.........
[   15.720099] 00000010: 00 00                                            ..
[   15.720102] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=event_msgs, len=18
[   15.720103] brcmutil: data
[   15.720104] 00000000: 00 00 00 00 00 00 40 00 00 00 00 00 00 00 00 00  ......@.........
[   15.720105] 00000010: 00 00                                            ..
[   15.720499] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=185, value=40
[   15.720839] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=187, value=40
[   15.721167] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=txbf, len=4
[   15.721168] brcmutil: data
[   15.721172] 00000000: 01 00 00 00                                      ....
[   15.721474] brcmfmac: brcmf_bus_started firmware revinfo: chip 4356 (17238) rev 2
[   15.721869] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=cap, len=256
[   15.721871] brcmutil: data
[   15.721874] 00000000: 61 70 20 73 74 61 20 6c 65 64 20 77 6d 65 20 38  ap sta led wme 8
[   15.721876] 00000010: 30 32 2e 31 31 64 20 38 30 32 2e 31 31 68 20 72  02.11d 802.11h r
[   15.721877] 00000020: 6d 20 63 71 61 20 63 61 63 20 64 75 61 6c 62 61  m cqa cac dualba
[   15.721878] 00000030: 6e 64 20 61 6d 70 64 75 20 61 6d 70 64 75 5f 74  nd ampdu ampdu_t
[   15.721908] brcmfmac: brcmf_feat_firmware_capabilities [ ap sta led wme 802.11d 802.11h rm cqa cac dualband ampdu ampdu_tx ampdu_rx amsdurx amsdutx radio_pwrsave p2p proptxstatus mchan wds p2po anqpo vht-prop-rates dfrts txpwrcache awdl stbc-tx stbc-rx-1ss epno pfnx wnm bsstrans mfp ndoe ]
[   15.721910] brcmfmac: brcmf_feat_firmware_capabilities enabling feature: MCHAN
[   15.721912] brcmfmac: brcmf_feat_firmware_capabilities enabling feature: P2P
[   15.722192] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=pfn, len=4
[   15.722193] brcmutil: data
[   15.722195] 00000000: 00 00 00 00                                      ....
[   15.722196] brcmfmac: brcmf_feat_iovar_int_get enabling feature: PNO
[   15.722494] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=wowl, len=4
[   15.722495] brcmutil: data
[   15.722497] 00000000: 00 00 00 00                                      ....
[   15.722498] brcmfmac: brcmf_feat_iovar_int_get enabling feature: WOWL
[   15.722846] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   15.722848] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=wowl_cap, len=4
[   15.722849] brcmutil: data
[   15.722851] 00000000: 00 00 00 00                                      ....
[   15.723286] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   15.723288] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=rsdb_mode, len=4
[   15.723290] brcmutil: data
[   15.723291] 00000000: ff ff ff ff                                      ....
[   15.723293] brcmfmac: brcmf_feat_iovar_int_get RSDB feature check failed: -23
[   15.723702] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   15.723704] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_enable, len=4
[   15.723706] brcmutil: data
[   15.723707] 00000000: ff ff ff ff                                      ....
[   15.723709] brcmfmac: brcmf_feat_iovar_int_get TDLS feature check failed: -23
[   15.724093] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=mfp, len=4
[   15.724094] brcmutil: data
[   15.724096] 00000000: 01 00 00 00                                      ....
[   15.724097] brcmfmac: brcmf_feat_iovar_int_get enabling feature: MFP
[   15.724470] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   15.724472] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=pfn_macaddr, len=8
[   15.724473] brcmutil: data
[   15.724474] 00000000: 01 68 4a 37 7a 8c ff ff                          .hJ7z...
[   15.724536] brcmfmac: brcmf_fws_init FWS queueing will be avoided
[   15.724539] brcmfmac: brcmf_fws_macdesc_init enter: desc ffff8c7a395688c0 ea=44:2c:05:9e:c9:02, ifidx=0
[   15.724542] brcmfmac: brcmf_fws_add_interface added MACIF:0
[   15.724558] brcmfmac: brcmf_alloc_vif allocating virtual interface (size=3920)
[   15.724585] brcmfmac: brcmf_fweh_register event handler registered for LINK
[   15.724587] brcmfmac: brcmf_fweh_register event handler registered for DEAUTH_IND
[   15.724588] brcmfmac: brcmf_fweh_register event handler registered for DEAUTH
[   15.724589] brcmfmac: brcmf_fweh_register event handler registered for DISASSOC_IND
[   15.724590] brcmfmac: brcmf_fweh_register event handler registered for ASSOC_IND
[   15.724592] brcmfmac: brcmf_fweh_register event handler registered for REASSOC_IND
[   15.724593] brcmfmac: brcmf_fweh_register event handler registered for ROAM
[   15.724594] brcmfmac: brcmf_fweh_register event handler registered for MIC_ERROR
[   15.724595] brcmfmac: brcmf_fweh_register event handler registered for SET_SSID
[   15.724596] brcmfmac: brcmf_fweh_register event handler registered for PFN_NET_FOUND
[   15.724598] brcmfmac: brcmf_fweh_register event handler registered for IF
[   15.724599] brcmfmac: brcmf_fweh_register event handler registered for P2P_PROBEREQ_MSG
[   15.724600] brcmfmac: brcmf_fweh_register event handler registered for P2P_DISC_LISTEN_COMPLETE
[   15.724602] brcmfmac: brcmf_fweh_register event handler registered for ACTION_FRAME_RX
[   15.724603] brcmfmac: brcmf_fweh_register event handler registered for ACTION_FRAME_COMPLETE
[   15.724604] brcmfmac: brcmf_fweh_register event handler registered for ACTION_FRAME_OFF_CHAN_COMPLETE
[   15.724605] brcmfmac: brcmf_fweh_register event handler registered for ESCAN_RESULT
[   15.725218] brcmfmac: brcmf_fil_cmd_int_get ifidx=0, cmd=1, value=2
[   15.725549] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=140, len=12
[   15.725551] brcmutil: data
[   15.725554] 00000000: 02 00 00 00 01 00 00 00 02 00 00 00              ............
[   15.725558] brcmfmac: brcmf_cfg80211_attach Registering custom regulatory
[   15.726371] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=vhtmode, len=4
[   15.726373] brcmutil: data
[   15.726376] 00000000: 01 00 00 00                                      ....
[   15.727148] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=nmode, len=4
[   15.727150] brcmutil: data
[   15.727152] 00000000: 01 00 00 00                                      ....
[   15.728001] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=bw_cap, len=4
[   15.728003] brcmutil: data
[   15.728006] 00000000: 01 00 00 00                                      ....
[   15.728692] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=bw_cap, len=4
[   15.728694] brcmutil: data
[   15.728696] 00000000: 07 00 00 00                                      ....
[   15.728699] brcmfmac: brcmf_setup_wiphybands nmode=1, vhtmode=1, bw_cap=(1, 7)
[   15.729418] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=rxchain, len=4
[   15.729420] brcmutil: data
[   15.729423] 00000000: 03 00 00 00                                      ....
[   15.729425] brcmfmac: brcmf_setup_wiphybands nchain=2
[   15.731964] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspecs, len=1536
[   15.731967] brcmutil: data
[   15.731971] 00000000: 62 00 00 00 01 10 00 00 02 10 00 00 03 10 00 00  b...............
[   15.731972] 00000010: 04 10 00 00 05 10 00 00 06 10 00 00 07 10 00 00  ................
[   15.731973] 00000020: 08 10 00 00 09 10 00 00 0a 10 00 00 0b 10 00 00  ................
[   15.731974] 00000030: 03 19 00 00 04 19 00 00 05 19 00 00 06 19 00 00  ................
[   15.732245] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.732247] brcmutil: data
[   15.732248] 00000000: 03 00 00 00                                      ....
[   15.732647] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.732649] brcmutil: data
[   15.732651] 00000000: 03 00 00 00                                      ....
[   15.733093] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.733095] brcmutil: data
[   15.733099] 00000000: 03 00 00 00                                      ....
[   15.733548] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.733549] brcmutil: data
[   15.733551] 00000000: 03 00 00 00                                      ....
[   15.734081] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.734083] brcmutil: data
[   15.734086] 00000000: 03 00 00 00                                      ....
[   15.734982] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.734985] brcmutil: data
[   15.734987] 00000000: 03 00 00 00                                      ....
[   15.735403] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.735405] brcmutil: data
[   15.735407] 00000000: 03 00 00 00                                      ....
[   15.735801] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.735802] brcmutil: data
[   15.735804] 00000000: 03 00 00 00                                      ....
[   15.736204] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.736206] brcmutil: data
[   15.736208] 00000000: 03 00 00 00                                      ....
[   15.736579] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.736580] brcmutil: data
[   15.736582] 00000000: 03 00 00 00                                      ....
[   15.737046] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.737047] brcmutil: data
[   15.737050] 00000000: 03 00 00 00                                      ....
[   15.737465] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.737467] brcmutil: data
[   15.737469] 00000000: 07 00 00 00                                      ....
[   15.737989] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.737991] brcmutil: data
[   15.737993] 00000000: 07 00 00 00                                      ....
[   15.738402] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.738403] brcmutil: data
[   15.738405] 00000000: 07 00 00 00                                      ....
[   15.738838] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.738840] brcmutil: data
[   15.738842] 00000000: 07 00 00 00                                      ....
[   15.739298] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.739300] brcmutil: data
[   15.739302] 00000000: 2f 00 00 00                                      /...
[   15.739675] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.739676] brcmutil: data
[   15.739678] 00000000: 2f 00 00 00                                      /...
[   15.739990] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.739991] brcmutil: data
[   15.739993] 00000000: 2f 00 00 00                                      /...
[   15.740308] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.740309] brcmutil: data
[   15.740311] 00000000: 2f 00 00 00                                      /...
[   15.740621] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.740622] brcmutil: data
[   15.740624] 00000000: 2f 00 00 00                                      /...
[   15.740940] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.740941] brcmutil: data
[   15.740943] 00000000: 2f 00 00 00                                      /...
[   15.741257] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.741258] brcmutil: data
[   15.741260] 00000000: 2f 00 00 00                                      /...
[   15.741571] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.741572] brcmutil: data
[   15.741574] 00000000: 2f 00 00 00                                      /...
[   15.741933] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.741935] brcmutil: data
[   15.741936] 00000000: 2f 00 00 00                                      /...
[   15.742291] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.742292] brcmutil: data
[   15.742295] 00000000: 2f 00 00 00                                      /...
[   15.742617] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.742618] brcmutil: data
[   15.742621] 00000000: 2f 00 00 00                                      /...
[   15.743034] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.743035] brcmutil: data
[   15.743036] 00000000: 2f 00 00 00                                      /...
[   15.743376] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.743377] brcmutil: data
[   15.743379] 00000000: 2f 00 00 00                                      /...
[   15.743761] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.743762] brcmutil: data
[   15.743764] 00000000: 2f 00 00 00                                      /...
[   15.744157] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.744159] brcmutil: data
[   15.744161] 00000000: 2f 00 00 00                                      /...
[   15.744624] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.744625] brcmutil: data
[   15.744627] 00000000: 2f 00 00 00                                      /...
[   15.745005] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.745007] brcmutil: data
[   15.745009] 00000000: 07 00 00 00                                      ....
[   15.745339] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.745340] brcmutil: data
[   15.745342] 00000000: 07 00 00 00                                      ....
[   15.745657] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.745658] brcmutil: data
[   15.745660] 00000000: 07 00 00 00                                      ....
[   15.745970] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.745971] brcmutil: data
[   15.745973] 00000000: 07 00 00 00                                      ....
[   15.746287] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[   15.746288] brcmutil: data
[   15.746290] 00000000: 07 00 00 00                                      ....
[   15.746736] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=txstreams, len=4
[   15.746737] brcmutil: data
[   15.746739] 00000000: 02 00 00 00                                      ....
[   15.747022] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=txbf_bfe_cap, len=4
[   15.747023] brcmutil: data
[   15.747025] 00000000: 01 00 00 00                                      ....
[   15.747307] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=txbf_bfr_cap, len=4
[   15.747308] brcmutil: data
[   15.747310] 00000000: 01 00 00 00                                      ....
[   15.747528] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=bw_cap, len=4
[   15.747529] brcmutil: data
[   15.747530] 00000000: 07 00 00 00                                      ....
[   15.747533] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=bw_cap, len=8
[   15.747534] brcmutil: data
[   15.747535] 00000000: 02 00 00 00 03 00 00 00                          ........
[   15.748350] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspecs, len=1536
[   15.748352] brcmutil: data
[   15.748360] 00000000: 0e 00 00 00 03 19 00 00 04 19 00 00 05 19 00 00  ................
[   15.748361] 00000010: 06 19 00 00 07 19 00 00 08 19 00 00 09 19 00 00  ................
[   15.748362] 00000020: 03 18 00 00 04 18 00 00 05 18 00 00 06 18 00 00  ................
[   15.748363] 00000030: 07 18 00 00 08 18 00 00 09 18 00 00 00 00 00 00  ................
[   15.748369] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=obss_coex, len=4
[   15.748372] brcmutil: data
[   15.748373] 00000000: ff ff ff ff                                      ....
[   15.748795] brcmfmac: brcmf_fweh_activate_events enable event SET_SSID
[   15.748797] brcmfmac: brcmf_fweh_activate_events enable event DEAUTH
[   15.748798] brcmfmac: brcmf_fweh_activate_events enable event DEAUTH_IND
[   15.748799] brcmfmac: brcmf_fweh_activate_events enable event ASSOC_IND
[   15.748800] brcmfmac: brcmf_fweh_activate_events enable event REASSOC_IND
[   15.748801] brcmfmac: brcmf_fweh_activate_events enable event DISASSOC_IND
[   15.748803] brcmfmac: brcmf_fweh_activate_events enable event LINK
[   15.748804] brcmfmac: brcmf_fweh_activate_events enable event MIC_ERROR
[   15.748805] brcmfmac: brcmf_fweh_activate_events enable event ROAM
[   15.748807] brcmfmac: brcmf_fweh_activate_events enable event PFN_NET_FOUND
[   15.748808] brcmfmac: brcmf_fweh_activate_events enable event PSM_WATCHDOG
[   15.748809] brcmfmac: brcmf_fweh_activate_events enable event IF
[   15.748810] brcmfmac: brcmf_fweh_activate_events enable event P2P_DISC_LISTEN_COMPLETE
[   15.748812] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_COMPLETE
[   15.748813] brcmfmac: brcmf_fweh_activate_events enable event ESCAN_RESULT
[   15.748814] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_OFF_CHAN_COMPLETE
[   15.748815] brcmfmac: brcmf_fweh_activate_events enable event P2P_PROBEREQ_MSG
[   15.748817] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_RX
[   15.748818] brcmfmac: brcmf_fweh_activate_events enable event IF
[   15.748821] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=event_msgs, len=18
[   15.748822] brcmutil: data
[   15.748824] 00000000: 61 15 0b 00 02 02 c0 10 60 09 00 00 00 00 00 00  a.......`.......
[   15.748826] 00000010: 00 00                                            ..
[   15.749177] brcmfmac: brcmf_btcoex_attach enter
[   15.749181] brcmfmac: brcmf_fweh_activate_events enable event SET_SSID
[   15.749182] brcmfmac: brcmf_fweh_activate_events enable event DEAUTH
[   15.749183] brcmfmac: brcmf_fweh_activate_events enable event DEAUTH_IND
[   15.749184] brcmfmac: brcmf_fweh_activate_events enable event ASSOC_IND
[   15.749186] brcmfmac: brcmf_fweh_activate_events enable event REASSOC_IND
[   15.749189] brcmfmac: brcmf_fweh_activate_events enable event DISASSOC_IND
[   15.749191] brcmfmac: brcmf_fweh_activate_events enable event LINK
[   15.749192] brcmfmac: brcmf_fweh_activate_events enable event MIC_ERROR
[   15.749193] brcmfmac: brcmf_fweh_activate_events enable event ROAM
[   15.749195] brcmfmac: brcmf_fweh_activate_events enable event PFN_NET_FOUND
[   15.749196] brcmfmac: brcmf_fweh_activate_events enable event PSM_WATCHDOG
[   15.749198] brcmfmac: brcmf_fweh_activate_events enable event IF
[   15.749199] brcmfmac: brcmf_fweh_activate_events enable event P2P_DISC_LISTEN_COMPLETE
[   15.749200] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_COMPLETE
[   15.749201] brcmfmac: brcmf_fweh_activate_events enable event ESCAN_RESULT
[   15.749203] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_OFF_CHAN_COMPLETE
[   15.749204] brcmfmac: brcmf_fweh_activate_events enable event P2P_PROBEREQ_MSG
[   15.749205] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_RX
[   15.749207] brcmfmac: brcmf_fweh_activate_events enable event IF
[   15.749209] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=event_msgs, len=18
[   15.749210] brcmutil: data
[   15.749211] 00000000: 61 15 0b 00 02 02 c0 10 60 09 00 00 00 00 00 00  a.......`.......
[   15.749213] 00000010: 00 00                                            ..
[   15.749509] brcmfmac: brcmf_net_attach Enter, bsscfgidx=0 mac=44:2c:05:9e:c9:02
[   15.750642] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspec, len=4
[   15.750645] brcmutil: data
[   15.750649] 00000000: 01 10 00 00                                      ....
[   15.750656] brcmfmac: brcmf_cfg80211_get_tx_power Enter
[   15.750658] brcmfmac: check_vif_up device is not ready : status (0)
[   15.750688] brcmfmac: brcmf_net_attach wlan0: Broadcom Dongle Host Driver
[   15.897987] cht-bsw-rt5645 cht-bsw-rt5645: snd-soc-dummy-dai <-> media-cpu-dai mapping ok
[   15.898056] cht-bsw-rt5645 cht-bsw-rt5645: snd-soc-dummy-dai <-> deepbuffer-cpu-dai mapping ok
[   15.898082] compress asoc: snd-soc-dummy-dai <-> compress-cpu-dai mapping ok
[   15.914306] intel_rapl: Found RAPL domain package
[   15.914309] intel_rapl: Found RAPL domain core
[   15.927384] cht-bsw-rt5645 cht-bsw-rt5645: rt5645-aif1 <-> ssp2-port mapping ok
[   15.982446] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: discard
[   15.995009] input: chtrt5645 Headset as /devices/pci0000:00/808622A8:00/cht-bsw-rt5645/sound/card0/input15
[   16.074404] brcmfmac 0000:01:00.0 wlp1s0: renamed from wlan0
[   17.256205] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspec, len=4
[   17.256209] brcmutil: data
[   17.256212] 00000000: 01 10 00 00                                      ....
[   17.256218] brcmfmac: brcmf_cfg80211_get_tx_power Enter
[   17.256221] brcmfmac: check_vif_up device is not ready : status (0)
[   17.269587] IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
[   17.269696] brcmfmac: brcmf_netdev_open Enter, bsscfgidx=0
[   17.270638] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   17.270641] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=toe_ol, len=4
[   17.270642] brcmutil: data
[   17.270646] 00000000: a6 a2 ff ff                                      ....
[   17.270649] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=2, value=0
[   17.307049] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=185, value=40
[   17.307347] brcmfmac: brcmf_fweh_event_worker event IF (54) ifidx 0 bsscfg 0 addr 44:2c:05:9e:c9:02
[   17.307351] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 0 reason 0
[   17.307353] brcmutil: event payload, len=5
[   17.307356] 00000000: 00 01 00 00 08                                   .....
[   17.307358] brcmfmac: brcmf_fweh_handle_if_event action: 1 ifidx: 0 bsscfgidx: 0 flags: 0 role: 8
[   17.307360] brcmfmac: brcmf_fweh_handle_if_event adding wl0 (44:2c:05:9e:c9:02)
[   17.307364] brcmfmac: brcmf_add_if Enter, bsscfgidx=0, ifidx=0
[   17.307365] brcmfmac: brcmf_add_if netdev:wlp1s0 ignore IF event
[   17.307467] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=187, value=40
[   17.307802] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=258, value=120
[   17.308040] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=86, value=2
[   17.308281] brcmfmac: brcmf_config_dongle power save set to enabled
[   17.308284] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=bcn_timeout, len=4
[   17.308286] brcmutil: data
[   17.308289] 00000000: 02 00 00 00                                      ....
[   17.308617] brcmfmac: brcmf_dongle_roam Internal Roaming = On
[   17.308620] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=roam_off, len=4
[   17.308621] brcmutil: data
[   17.308623] 00000000: 00 00 00 00                                      ....
[   17.309055] brcmfmac: brcmf_fil_cmd_data_set ifidx=0, cmd=55, len=8
[   17.309058] brcmutil: data
[   17.309060] 00000000: b5 ff ff ff 03 00 00 00                          ........
[   17.309315] brcmfmac: brcmf_fil_cmd_data_set ifidx=0, cmd=57, len=8
[   17.309317] brcmutil: data
[   17.309319] 00000000: 14 00 00 00 03 00 00 00                          ........
[   17.309570] brcmfmac: brcmf_cfg80211_change_iface Enter, bsscfgidx=0, type=2
[   17.309573] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=20, value=1
[   17.309816] brcmfmac: brcmf_cfg80211_change_iface IF Type = Infra
[   17.309819] brcmfmac: brcmf_cfg80211_change_iface Exit
[   17.309822] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=arp_ol, len=4
[   17.309823] brcmutil: data
[   17.309825] 00000000: 09 00 00 00                                      ....
[   17.309836] brcmfmac: brcmf_fweh_event_worker event IF (54) ifidx 0 bsscfg 0 addr 44:2c:05:9e:c9:02
[   17.309838] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 0 reason 0
[   17.309840] brcmutil: event payload, len=5
[   17.309842] 00000000: 00 03 00 00 00                                   .....
[   17.309844] brcmfmac: brcmf_fweh_handle_if_event action: 3 ifidx: 0 bsscfgidx: 0 flags: 0 role: 0
[   17.309846] brcmfmac: brcmf_fws_reset_interface enter: bsscfgidx=0
[   17.309849] brcmfmac: brcmf_fws_macdesc_init enter: desc ffff8c7a395688c0 ea=44:2c:05:9e:c9:02, ifidx=0
[   17.309852] brcmfmac: brcmf_notify_vif_event Enter: action 3 flags 0 ifidx 0 bsscfgidx 0
[   17.310304] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=arpoe, len=4
[   17.310306] brcmutil: data
[   17.310308] 00000000: 01 00 00 00                                      ....
[   17.310644] brcmfmac: brcmf_configure_arp_nd_offload successfully configured (1) ARP offload to 0x9
[   17.310647] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=ndoe, len=4
[   17.310648] brcmutil: data
[   17.310650] 00000000: 01 00 00 00                                      ....
[   17.310993] brcmfmac: brcmf_configure_arp_nd_offload successfully configured (1) ND offload to 0x9
[   17.311095] IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
[   17.311101] brcmfmac: brcmf_cfg80211_set_power_mgmt Enter
[   17.311103] brcmfmac: brcmf_cfg80211_set_power_mgmt power save enabled
[   17.311106] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=86, value=2
[   17.311124] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   17.311572] brcmfmac: brcmf_cfg80211_set_power_mgmt Exit
[   17.312427] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspec, len=4
[   17.312431] brcmutil: data
[   17.312434] 00000000: 01 10 00 00                                      ....
[   17.312443] brcmfmac: brcmf_cfg80211_get_tx_power Enter
[   17.312450] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=10
[   17.312451] brcmutil: data
[   17.312453] 00000000: 01 00 00 00 01 00 5e 00 00 01                    ......^...
[   17.312832] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   17.312835] brcmutil: data
[   17.312837] 00000000: 00 00 00 00                                      ....
[   17.313587] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=qtxpower, len=4
[   17.313589] brcmutil: data
[   17.313592] 00000000: 7f 00 00 00                                      ....
[   17.313597] brcmfmac: brcmf_cfg80211_get_tx_power Exit (0x7f 31)
[   17.313603] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   17.314152] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   17.314157] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=10
[   17.314159] brcmutil: data
[   17.314161] 00000000: 01 00 00 00 01 00 5e 00 00 01                    ......^...
[   17.314288] brcmfmac: brcmf_netdev_stop Enter, bsscfgidx=0
[   17.314292] brcmfmac: brcmf_link_down Enter
[   17.314295] brcmfmac: brcmf_btcoex_set_mode DHCP session ends
[   17.314296] brcmfmac: brcmf_link_down Exit
[   17.314629] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   17.314631] brcmutil: data
[   17.314633] 00000000: 00 00 00 00                                      ....
[   17.315007] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   17.815946] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=arp_hostip_clear, len=0
[   17.815951] brcmutil: data
[   17.816776] brcmfmac: brcmf_net_setcarrier Enter, bsscfgidx=0 carrier=0
[   17.816785] brcmfmac: brcmf_txflowblock_if enter: bsscfgidx=0 stop=0x0 reason=4 state=1
[   17.819113] brcmfmac: brcmf_netdev_set_mac_address Enter, bsscfgidx=0
[   17.819122] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=cur_etheraddr, len=6
[   17.819127] brcmutil: data
[   17.819135] 00000000: aa 3e 81 77 bc 40                                .>.w.@
[   17.819864] brcmfmac: brcmf_netdev_set_mac_address updated to aa:3e:81:77:bc:40
[   17.823391] brcmfmac: brcmf_netdev_open Enter, bsscfgidx=0
[   17.824288] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   17.824296] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=toe_ol, len=4
[   17.824300] brcmutil: data
[   17.824308] 00000000: a6 a2 ff ff                                      ....
[   17.824399] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   17.824407] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=4
[   17.824411] brcmutil: data
[   17.824417] 00000000: 00 00 00 00                                      ....
[   17.824460] IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
[   17.824486] brcmfmac: brcmf_cfg80211_set_power_mgmt Enter
[   17.824492] brcmfmac: brcmf_cfg80211_set_power_mgmt power save enabled
[   17.825034] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   17.825039] brcmutil: data
[   17.825045] 00000000: 00 00 00 00                                      ....
[   17.825609] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=86, value=2
[   17.826526] brcmfmac: brcmf_cfg80211_set_power_mgmt Exit
[   17.826941] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   17.827679] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   17.827683] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=10
[   17.827685] brcmutil: data
[   17.827688] 00000000: 01 00 00 00 01 00 5e 00 00 01                    ......^...
[   17.828098] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   17.828100] brcmutil: data
[   17.828102] 00000000: 00 00 00 00                                      ....
[   17.828465] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   17.917313] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspec, len=4
[   17.917317] brcmutil: data
[   17.917321] 00000000: 01 10 00 00                                      ....
[   17.917325] brcmfmac: brcmf_cfg80211_get_tx_power Enter
[   17.917575] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=qtxpower, len=4
[   17.917577] brcmutil: data
[   17.917578] 00000000: 7f 00 00 00                                      ....
[   17.917581] brcmfmac: brcmf_cfg80211_get_tx_power Exit (0x7f 31)
[   17.918542] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspec, len=4
[   17.918545] brcmutil: data
[   17.918549] 00000000: 01 10 00 00                                      ....
[   17.918555] brcmfmac: brcmf_cfg80211_get_tx_power Enter
[   17.919186] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=qtxpower, len=4
[   17.919188] brcmutil: data
[   17.919190] 00000000: 7f 00 00 00                                      ....
[   17.919192] brcmfmac: brcmf_cfg80211_get_tx_power Exit (0x7f 31)
[   17.919380] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919405] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919429] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919452] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919476] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919500] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919523] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919547] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919572] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919596] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919620] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919644] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919667] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919691] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919715] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.919739] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   17.920348] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspec, len=4
[   17.920353] brcmutil: data
[   17.920356] 00000000: 01 10 00 00                                      ....
[   17.920364] brcmfmac: brcmf_cfg80211_get_tx_power Enter
[   17.920737] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=qtxpower, len=4
[   17.920739] brcmutil: data
[   17.920741] 00000000: 7f 00 00 00                                      ....
[   17.920743] brcmfmac: brcmf_cfg80211_get_tx_power Exit (0x7f 31)
[   17.936422] brcmfmac: brcmf_cfg80211_flush_pmksa Enter
[   17.936429] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=pmkid_info, len=356
[   17.936431] brcmutil: data
[   17.936435] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   17.936436] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   17.936438] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   17.936439] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   17.936863] brcmfmac: brcmf_cfg80211_flush_pmksa Exit
[   17.947704] brcmfmac: brcmf_cfg80211_add_iface enter: p2p-dev-wlp1s0 type 10
[   17.947714] brcmfmac: brcmf_p2p_add_vif adding vif "p2p-dev-wlp1s0" (type=10, addr=00:00:00:00:00:00)
[   17.947716] brcmfmac: brcmf_alloc_vif allocating virtual interface (size=3920)
[   17.947720] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=3, value=1
[   17.948749] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=apsta, len=4
[   17.948752] brcmutil: data
[   17.948756] 00000000: 01 00 00 00                                      ....
[   17.949620] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=2, value=1
[   17.984420] brcmfmac: brcmf_fweh_event_worker event IF (54) ifidx 0 bsscfg 0 addr aa:3e:81:77:bc:40
[   17.984424] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 0 reason 0
[   17.984427] brcmutil: event payload, len=5
[   17.984430] 00000000: 00 01 00 00 00                                   .....
[   17.984433] brcmfmac: brcmf_fweh_handle_if_event action: 1 ifidx: 0 bsscfgidx: 0 flags: 0 role: 0
[   17.984435] brcmfmac: brcmf_fweh_handle_if_event adding wl0 (aa:3e:81:77:bc:40)
[   17.984437] brcmfmac: brcmf_add_if Enter, bsscfgidx=0, ifidx=0
[   17.984439] brcmfmac: brcmf_add_if netdev:wlp1s0 ignore IF event
[   17.984646] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=p2p_disc, len=4
[   17.984657] brcmutil: data
[   17.984669] 00000000: 00 00 00 00                                      ....
[   17.985123] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=p2p_da_override, len=6
[   17.985131] brcmutil: data
[   17.985140] 00000000: aa 3e 81 77 bc 40                                .>.w.@
[   17.985580] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=p2p_disc, len=4
[   17.985588] brcmutil: data
[   17.985598] 00000000: 01 00 00 00                                      ....
[   17.985975] brcmfmac: brcmf_fil_cmd_data Failed: BCME_BUSY (-16)
[   17.985985] brcmfmac: brcmf_p2p_create_p2pdev set p2p_disc error
[   17.985999] brcmfmac: brcmf_cfg80211_add_iface add iface p2p-dev-wlp1s0 type 10 failed: err=-16
[   18.000057] IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
[   18.002322] brcmfmac: brcmf_cfg80211_scan Enter
[   18.002328] brcmfmac: brcmf_vif_set_mgmt_ie bsscfgidx 0, pktflag : 0x10
[   18.002332] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=49, value=0
[   18.003055] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=escan, len=180
[   18.003058] brcmutil: data
[   18.003062] 00000000: 01 00 00 00 01 00 34 12 00 00 00 00 00 00 00 00  ......4.........
[   18.003063] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.003065] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
[   18.003066] 00000030: ff ff 02 00 ff ff ff ff ff ff ff ff ff ff ff ff  ................
[   18.003832] brcmfmac: brcmf_cfg80211_scan Exit
[   18.007042] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 4c:09:d4:d5:df:92
[   18.007046] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.007048] brcmutil: event payload, len=364
[   18.007051] 00000000: 6c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  l...m...4...m...
[   18.007053] 00000010: 60 01 00 00 4c 09 d4 d5 df 92 64 00 11 14 0c 57  `...L.....d....W
[   18.007054] 00000020: 41 39 31 31 37 44 35 44 46 39 32 00 00 00 00 00  A9117D5DF92.....
[   18.007055] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.016747] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 4c:09:d4:d5:df:92
[   18.016751] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.016753] brcmutil: event payload, len=476
[   18.016757] 00000000: dc 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   18.016759] 00000010: d0 01 00 00 4c 09 d4 d5 df 92 64 00 11 14 0c 57  ....L.....d....W
[   18.016760] 00000020: 41 39 31 31 37 44 35 44 46 39 32 00 00 00 00 00  A9117D5DF92.....
[   18.016761] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.022614] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 48:f8:b3:94:ba:7c
[   18.022618] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.022621] brcmutil: event payload, len=428
[   18.022624] 00000000: ac 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   18.022626] 00000010: a0 01 00 00 48 f8 b3 94 ba 7c 64 00 11 04 0a 5a  ....H....|d....Z
[   18.022628] 00000020: 69 67 67 6f 46 44 34 35 38 00 00 00 00 00 00 00  iggoFD458.......
[   18.022630] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.032244] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 4c:09:d4:d5:df:92
[   18.032248] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.032251] brcmutil: event payload, len=476
[   18.032256] 00000000: dc 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   18.032258] 00000010: d0 01 00 00 4c 09 d4 d5 df 92 64 00 11 14 0c 57  ....L.....d....W
[   18.032260] 00000020: 41 39 31 31 37 44 35 44 46 39 32 00 00 00 00 00  A9117D5DF92.....
[   18.032261] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.105769] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   18.157428] Ebtables v2.0 registered
[   18.218968] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 82:56:f2:8b:7f:2f
[   18.218972] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.218975] brcmutil: event payload, len=308
[   18.218979] 00000000: 34 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  4...m...4...m...
[   18.218981] 00000010: 28 01 00 00 82 56 f2 8b 7f 2f 64 00 11 04 05 5a  (....V.../d....Z
[   18.218982] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   18.218984] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.223032] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   18.223038] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.223041] brcmutil: event payload, len=432
[   18.223046] 00000000: b0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   18.223049] 00000010: a4 01 00 00 80 56 f2 8b 7f 2e 64 00 11 04 10 65  .....V....d....e
[   18.223051] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 00  miratenstraat15.
[   18.223053] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.225165] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 82:56:f2:8b:7f:2f
[   18.225170] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.225173] brcmutil: event payload, len=300
[   18.225177] 00000000: 2c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ,...m...4...m...
[   18.225180] 00000010: 20 01 00 00 82 56 f2 8b 7f 2f 64 00 11 04 05 5a   ....V.../d....Z
[   18.225183] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   18.225185] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.236720] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c0:f8:da:26:fd:e8
[   18.236725] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.236727] brcmutil: event payload, len=356
[   18.236731] 00000000: 64 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  d...m...4...m...
[   18.236733] 00000010: 58 01 00 00 c0 f8 da 26 fd e8 64 00 11 05 0a 5a  X......&..d....Z
[   18.236734] 00000020: 69 67 67 6f 30 33 32 36 34 00 00 00 00 00 00 00  iggo03264.......
[   18.236735] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.238741] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c2:f8:da:26:fd:e9
[   18.238746] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.238748] brcmutil: event payload, len=324
[   18.238750] 00000000: 44 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  D...m...4...m...
[   18.238752] 00000010: 38 01 00 00 c2 f8 da 26 fd e9 64 00 11 05 05 5a  8......&..d....Z
[   18.238753] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   18.238754] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.249918] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   18.249923] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.249926] brcmutil: event payload, len=432
[   18.249931] 00000000: b0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   18.249933] 00000010: a4 01 00 00 80 56 f2 8b 7f 2e 64 00 11 04 10 65  .....V....d....e
[   18.249936] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 00  miratenstraat15.
[   18.249938] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.253221] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c0:f8:da:26:fd:e8
[   18.253226] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.253228] brcmutil: event payload, len=448
[   18.253232] 00000000: c0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   18.253235] 00000010: b4 01 00 00 c0 f8 da 26 fd e8 64 00 11 05 0a 5a  .......&..d....Z
[   18.253237] 00000020: 69 67 67 6f 30 33 32 36 34 00 00 00 00 00 00 00  iggo03264.......
[   18.253239] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.255604] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c2:f8:da:26:fd:e9
[   18.255610] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.255613] brcmutil: event payload, len=316
[   18.255618] 00000000: 3c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  <...m...4...m...
[   18.255620] 00000010: 30 01 00 00 c2 f8 da 26 fd e9 64 00 11 05 05 5a  0......&..d....Z
[   18.255623] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   18.255625] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.257801] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 82:56:f2:8b:7f:2f
[   18.257806] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.257809] brcmutil: event payload, len=300
[   18.257814] 00000000: 2c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ,...m...4...m...
[   18.257816] 00000010: 20 01 00 00 82 56 f2 8b 7f 2f 64 00 11 04 05 5a   ....V.../d....Z
[   18.257819] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   18.257821] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.419208] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr e4:95:6e:40:2c:5d
[   18.419212] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.419214] brcmutil: event payload, len=308
[   18.419218] 00000000: 34 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  4...m...4...m...
[   18.419220] 00000010: 28 01 00 00 e4 95 6e 40 2c 5d 64 00 31 04 12 65  (.....n@,]d.1..e
[   18.419221] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 5f  miratenstraat15_
[   18.419223] 00000030: 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  2...............
[   18.435854] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr fa:8f:ca:57:00:90
[   18.435858] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.435861] brcmutil: event payload, len=248
[   18.435866] 00000000: f8 00 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   18.435868] 00000010: ec 00 00 00 fa 8f ca 57 00 90 64 00 21 04 00 00  .......W..d.!...
[   18.435895] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.435898] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.437761] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr e4:95:6e:40:2c:5d
[   18.437765] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.437767] brcmutil: event payload, len=300
[   18.437771] 00000000: 2c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ,...m...4...m...
[   18.437773] 00000010: 20 01 00 00 e4 95 6e 40 2c 5d 64 00 31 04 12 65   .....n@,]d.1..e
[   18.437775] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 5f  miratenstraat15_
[   18.437776] 00000030: 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  2...............
[   18.460280] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 90:5c:44:2d:78:53
[   18.460285] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.460288] brcmutil: event payload, len=500
[   18.460293] 00000000: f4 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   18.460296] 00000010: e8 01 00 00 90 5c 44 2d 78 53 64 00 11 04 0c 5a  .....\D-xSd....Z
[   18.460298] 00000020: 69 67 67 6f 37 31 39 35 43 31 41 00 00 00 00 00  iggo7195C1A.....
[   18.460300] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.464205] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 90:5c:44:2d:78:53
[   18.464211] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.464214] brcmutil: event payload, len=500
[   18.464219] 00000000: f4 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   18.464222] 00000010: e8 01 00 00 90 5c 44 2d 78 53 64 00 11 04 0c 5a  .....\D-xSd....Z
[   18.464224] 00000020: 69 67 67 6f 37 31 39 35 43 31 41 00 00 00 00 00  iggo7195C1A.....
[   18.464227] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   18.471361] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 00:4a:77:69:ca:c7
[   18.471367] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   18.471370] brcmutil: event payload, len=328
[   18.471375] 00000000: 48 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  H...m...4...m...
[   18.471378] 00000010: 3c 01 00 00 00 4a 77 69 ca c7 64 00 11 14 11 54  <....Jwi..d....T
[   18.471381] 00000020: 45 4c 45 32 2d 36 39 43 41 43 36 5f 32 2e 34 47  ELE2-69CAC6_2.4G
[   18.471384] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   20.269069] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:90:50:ba
[   20.269073] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   20.269075] brcmutil: event payload, len=356
[   20.269079] 00000000: 64 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  d...m...4...m...
[   20.269081] 00000010: 58 01 00 00 80 56 f2 90 50 ba 64 00 11 00 13 65  X....V..P.d....e
[   20.269082] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 2d  miratenstraat15-
[   20.269083] 00000030: 35 67 00 00 00 00 00 00 00 00 00 00 00 00 00 00  5g..............
[   20.269632] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:90:50:ba
[   20.269634] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   20.269636] brcmutil: event payload, len=420
[   20.269638] 00000000: a4 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   20.269639] 00000010: 98 01 00 00 80 56 f2 90 50 ba 64 00 11 00 13 65  .....V..P.d....e
[   20.269640] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 2d  miratenstraat15-
[   20.269642] 00000030: 35 67 00 00 00 00 00 00 00 00 00 00 00 00 00 00  5g..............
[   20.773498] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 00:00:00:00:00:00
[   20.773504] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 0 reason 0
[   20.773509] brcmutil: event payload, len=12
[   20.773515] 00000000: 0c 00 00 00 6d 00 00 00 34 12 00 00              ....m...4...
[   20.796740] brcmfmac: brcmf_cfg80211_scan Enter
[   20.796748] brcmfmac: brcmf_vif_set_mgmt_ie bsscfgidx 0, pktflag : 0x10
[   20.796754] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=49, value=0
[   20.797104] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=escan, len=196
[   20.797107] brcmutil: data
[   20.797111] 00000000: 01 00 00 00 01 00 34 12 00 00 00 00 00 00 00 00  ......4.........
[   20.797112] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   20.797113] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
[   20.797115] 00000030: ff ff 02 00 ff ff ff ff ff ff ff ff ff ff ff ff  ................
[   20.797829] brcmfmac: brcmf_cfg80211_scan Exit
[   20.821489] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   20.821496] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=10
[   20.821499] brcmutil: data
[   20.821502] 00000000: 01 00 00 00 01 00 5e 00 00 01                    ......^...
[   20.821576] brcmfmac: brcmf_netdev_stop Enter, bsscfgidx=0
[   20.821579] brcmfmac: brcmf_link_down Enter
[   20.821582] brcmfmac: brcmf_btcoex_set_mode DHCP session ends
[   20.821584] brcmfmac: brcmf_link_down Exit
[   20.822091] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   20.822093] brcmutil: data
[   20.822095] 00000000: 00 00 00 00                                      ....
[   20.822640] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   20.834007] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 48:f8:b3:94:ba:7c
[   20.834010] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   20.834012] brcmutil: event payload, len=428
[   20.834016] 00000000: ac 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   20.834017] 00000010: a0 01 00 00 48 f8 b3 94 ba 7c 64 00 11 04 0a 5a  ....H....|d....Z
[   20.834019] 00000020: 69 67 67 6f 46 44 34 35 38 00 00 00 00 00 00 00  iggoFD458.......
[   20.834020] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   20.865819] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 4c:09:d4:d5:df:92
[   20.865825] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   20.865829] brcmutil: event payload, len=476
[   20.865835] 00000000: dc 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   20.865839] 00000010: d0 01 00 00 4c 09 d4 d5 df 92 64 00 11 14 0c 57  ....L.....d....W
[   20.865842] 00000020: 41 39 31 31 37 44 35 44 46 39 32 00 00 00 00 00  A9117D5DF92.....
[   20.865845] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   20.973434] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   20.973441] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   20.973445] brcmutil: event payload, len=432
[   20.973451] 00000000: b0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   20.973455] 00000010: a4 01 00 00 80 56 f2 8b 7f 2e 64 00 11 04 10 65  .....V....d....e
[   20.973458] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 00  miratenstraat15.
[   20.973461] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   20.991522] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   20.991526] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   20.991528] brcmutil: event payload, len=432
[   20.991532] 00000000: b0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   20.991533] 00000010: a4 01 00 00 80 56 f2 8b 7f 2e 64 00 11 04 10 65  .....V....d....e
[   20.991535] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 00  miratenstraat15.
[   20.991536] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   20.998108] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 82:56:f2:8b:7f:2f
[   20.998113] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   20.998116] brcmutil: event payload, len=300
[   20.998120] 00000000: 2c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ,...m...4...m...
[   20.998123] 00000010: 20 01 00 00 82 56 f2 8b 7f 2f 64 00 11 04 05 5a   ....V.../d....Z
[   20.998125] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   20.998127] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.007289] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c2:f8:da:26:fd:e9
[   21.007295] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.007307] brcmutil: event payload, len=324
[   21.007313] 00000000: 44 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  D...m...4...m...
[   21.007317] 00000010: 38 01 00 00 c2 f8 da 26 fd e9 64 00 11 05 05 5a  8......&..d....Z
[   21.007320] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   21.007323] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.014405] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c0:f8:da:26:fd:e8
[   21.014412] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.014416] brcmutil: event payload, len=448
[   21.014423] 00000000: c0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   21.014427] 00000010: b4 01 00 00 c0 f8 da 26 fd e8 64 00 11 05 0a 5a  .......&..d....Z
[   21.014430] 00000020: 69 67 67 6f 30 33 32 36 34 00 00 00 00 00 00 00  iggo03264.......
[   21.014433] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.018551] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c2:f8:da:26:fd:e9
[   21.018559] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.018563] brcmutil: event payload, len=316
[   21.018577] 00000000: 3c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  <...m...4...m...
[   21.018581] 00000010: 30 01 00 00 c2 f8 da 26 fd e9 64 00 11 05 05 5a  0......&..d....Z
[   21.018584] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   21.018587] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.025627] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c0:f8:da:26:fd:e8
[   21.025634] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.025638] brcmutil: event payload, len=448
[   21.025644] 00000000: c0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   21.025648] 00000010: b4 01 00 00 c0 f8 da 26 fd e8 64 00 11 05 0a 5a  .......&..d....Z
[   21.025651] 00000020: 69 67 67 6f 30 33 32 36 34 00 00 00 00 00 00 00  iggo03264.......
[   21.025654] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.029003] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   21.029010] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.029015] brcmutil: event payload, len=432
[   21.029022] 00000000: b0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   21.029026] 00000010: a4 01 00 00 80 56 f2 8b 7f 2e 64 00 11 04 10 65  .....V....d....e
[   21.029030] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 00  miratenstraat15.
[   21.029033] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.030983] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c2:f8:da:26:fd:e9
[   21.030989] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.030993] brcmutil: event payload, len=316
[   21.030999] 00000000: 3c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  <...m...4...m...
[   21.031003] 00000010: 30 01 00 00 c2 f8 da 26 fd e9 64 00 11 05 05 5a  0......&..d....Z
[   21.031006] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   21.031010] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.033248] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 82:56:f2:8b:7f:2f
[   21.033255] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.033259] brcmutil: event payload, len=300
[   21.033264] 00000000: 2c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ,...m...4...m...
[   21.033268] 00000010: 20 01 00 00 82 56 f2 8b 7f 2f 64 00 11 04 05 5a   ....V.../d....Z
[   21.033272] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   21.033276] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.038369] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   21.038376] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.038381] brcmutil: event payload, len=432
[   21.038387] 00000000: b0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   21.038391] 00000010: a4 01 00 00 80 56 f2 8b 7f 2e 64 00 11 04 10 65  .....V....d....e
[   21.038395] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 00  miratenstraat15.
[   21.038398] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.047259] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c0:f8:da:26:fd:e8
[   21.047264] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.047267] brcmutil: event payload, len=448
[   21.047272] 00000000: c0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   21.047274] 00000010: b4 01 00 00 c0 f8 da 26 fd e8 64 00 11 05 0a 5a  .......&..d....Z
[   21.047276] 00000020: 69 67 67 6f 30 33 32 36 34 00 00 00 00 00 00 00  iggo03264.......
[   21.047278] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.049931] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 82:56:f2:8b:7f:2f
[   21.049936] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.049939] brcmutil: event payload, len=300
[   21.049944] 00000000: 2c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ,...m...4...m...
[   21.049946] 00000010: 20 01 00 00 82 56 f2 8b 7f 2f 64 00 11 04 05 5a   ....V.../d....Z
[   21.049948] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   21.049950] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.051668] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c2:f8:da:26:fd:e9
[   21.051675] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.051680] brcmutil: event payload, len=316
[   21.051687] 00000000: 3c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  <...m...4...m...
[   21.051691] 00000010: 30 01 00 00 c2 f8 da 26 fd e9 64 00 11 05 05 5a  0......&..d....Z
[   21.051694] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   21.051698] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.061259] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   21.061275] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.061281] brcmutil: event payload, len=432
[   21.061289] 00000000: b0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   21.061294] 00000010: a4 01 00 00 80 56 f2 8b 7f 2e 64 00 11 04 10 65  .....V....d....e
[   21.061298] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 00  miratenstraat15.
[   21.061303] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.064631] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c0:f8:da:26:fd:e8
[   21.064641] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.064646] brcmutil: event payload, len=448
[   21.064654] 00000000: c0 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ....m...4...m...
[   21.064659] 00000010: b4 01 00 00 c0 f8 da 26 fd e8 64 00 11 05 0a 5a  .......&..d....Z
[   21.064664] 00000020: 69 67 67 6f 30 33 32 36 34 00 00 00 00 00 00 00  iggo03264.......
[   21.064668] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.069756] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 82:56:f2:8b:7f:2f
[   21.069765] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.069770] brcmutil: event payload, len=300
[   21.069778] 00000000: 2c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ,...m...4...m...
[   21.069783] 00000010: 20 01 00 00 82 56 f2 8b 7f 2f 64 00 11 04 05 5a   ....V.../d....Z
[   21.069787] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   21.069792] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.083592] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr c2:f8:da:26:fd:e9
[   21.083599] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.083604] brcmutil: event payload, len=316
[   21.083610] 00000000: 3c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  <...m...4...m...
[   21.083613] 00000010: 30 01 00 00 c2 f8 da 26 fd e9 64 00 11 05 05 5a  0......&..d....Z
[   21.083616] 00000020: 69 67 67 6f 00 00 00 00 00 00 00 00 00 00 00 00  iggo............
[   21.083619] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.088017] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   21.088024] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.088028] brcmutil: event payload, len=368
[   21.088034] 00000000: 70 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  p...m...4...m...
[   21.088037] 00000010: 64 01 00 00 80 56 f2 8b 7f 2e 64 00 11 04 10 65  d....V....d....e
[   21.088040] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 00  miratenstraat15.
[   21.088043] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.187173] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr e4:95:6e:40:2c:5d
[   21.187181] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.187186] brcmutil: event payload, len=308
[   21.187193] 00000000: 34 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  4...m...4...m...
[   21.187197] 00000010: 28 01 00 00 e4 95 6e 40 2c 5d 64 00 31 04 12 65  (.....n@,]d.1..e
[   21.187200] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 5f  miratenstraat15_
[   21.187204] 00000030: 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  2...............
[   21.236450] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr e4:95:6e:40:2c:5d
[   21.236458] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.236463] brcmutil: event payload, len=300
[   21.236470] 00000000: 2c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ,...m...4...m...
[   21.236475] 00000010: 20 01 00 00 e4 95 6e 40 2c 5d 64 00 31 04 12 65   .....n@,]d.1..e
[   21.236479] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 5f  miratenstraat15_
[   21.236482] 00000030: 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  2...............
[   21.253575] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 00:4a:77:69:ca:c7
[   21.253585] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.253591] brcmutil: event payload, len=328
[   21.253599] 00000000: 48 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  H...m...4...m...
[   21.253605] 00000010: 3c 01 00 00 00 4a 77 69 ca c7 64 00 11 14 11 54  <....Jwi..d....T
[   21.253609] 00000020: 45 4c 45 32 2d 36 39 43 41 43 36 5f 32 2e 34 47  ELE2-69CAC6_2.4G
[   21.253613] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.255262] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr e4:95:6e:40:2c:5d
[   21.255265] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 8 reason 0
[   21.255267] brcmutil: event payload, len=300
[   21.255270] 00000000: 2c 01 00 00 6d 00 00 00 34 12 01 00 6d 00 00 00  ,...m...4...m...
[   21.255272] 00000010: 20 01 00 00 e4 95 6e 40 2c 5d 64 00 31 04 12 65   .....n@,]d.1..e
[   21.255273] 00000020: 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35 5f  miratenstraat15_
[   21.255275] 00000030: 32 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  2...............
[   21.328271] brcmfmac: brcmf_fil_cmd_data_set ifidx=0, cmd=50, len=68
[   21.328277] brcmutil: data
[   21.328284] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.328288] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   21.328292] 00000020: 00 00 00 00 ff ff ff ff ff ff 02 00 01 00 00 00  ................
[   21.328295] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff 01 00 00 00  ................
[   21.332840] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69) ifidx 0 bsscfg 0 addr 7f:08:01:00:00:00
[   21.332849] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 4 reason 0
[   21.332856] brcmutil: event payload, len=12
[   21.332959] 00000000: 0c 00 00 00 6d 00 00 00 34 12 00 00              ....m...4...
[   21.332984] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=arp_hostip_clear, len=0
[   21.332993] brcmutil: data
[   21.333585] brcmfmac: brcmf_net_setcarrier Enter, bsscfgidx=0 carrier=0
[   21.333594] brcmfmac: brcmf_txflowblock_if enter: bsscfgidx=0 stop=0x4 reason=4 state=1
[   21.334602] brcmfmac: brcmf_netdev_set_mac_address Enter, bsscfgidx=0
[   21.334611] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=cur_etheraddr, len=6
[   21.334615] brcmutil: data
[   21.334623] 00000000: 44 2c 05 9e c9 02                                D,....
[   21.335450] brcmfmac: brcmf_netdev_set_mac_address updated to 44:2c:05:9e:c9:02
[   21.336913] brcmfmac: brcmf_netdev_open Enter, bsscfgidx=0
[   21.337537] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   21.337546] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=toe_ol, len=4
[   21.337550] brcmutil: data
[   21.337559] 00000000: a6 a2 ff ff                                      ....
[   21.337671] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   21.337679] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=4
[   21.337682] brcmutil: data
[   21.337688] 00000000: 00 00 00 00                                      ....
[   21.338052] IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
[   21.338219] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   21.338224] brcmutil: data
[   21.338229] 00000000: 00 00 00 00                                      ....
[   21.338266] brcmfmac: brcmf_cfg80211_set_power_mgmt Enter
[   21.338272] brcmfmac: brcmf_cfg80211_set_power_mgmt power save enabled
[   21.338739] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   21.339140] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   21.339149] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=86, value=2
[   21.339625] brcmfmac: brcmf_cfg80211_set_power_mgmt Exit
[   21.339642] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=10
[   21.339644] brcmutil: data
[   21.339648] 00000000: 01 00 00 00 01 00 5e 00 00 01                    ......^...
[   21.340249] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   21.340252] brcmutil: data
[   21.340255] 00000000: 00 00 00 00                                      ....
[   21.340568] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   21.353885] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   21.353892] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=10
[   21.353894] brcmutil: data
[   21.353899] 00000000: 01 00 00 00 01 00 5e 00 00 01                    ......^...
[   21.354343] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   21.354346] brcmutil: data
[   21.354349] 00000000: 00 00 00 00                                      ....
[   21.354848] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   21.364436] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   21.364442] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=10
[   21.364444] brcmutil: data
[   21.364448] 00000000: 01 00 00 00 01 00 5e 00 00 01                    ......^...
[   21.364981] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   21.364985] brcmutil: data
[   21.364988] 00000000: 00 00 00 00                                      ....
[   21.365327] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   21.383651] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383656] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383658] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383660] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383661] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383663] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383664] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383666] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383668] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383669] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383671] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383672] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383674] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383675] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383677] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383679] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=0
[   21.383829] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.383853] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.383898] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.383920] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.383943] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.383965] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.383987] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384008] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384030] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384052] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384073] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384095] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384116] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384137] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384159] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384180] brcmfmac: brcmf_cfg80211_mgmt_frame_register Enter, frame_type 00d0, reg=1
[   21.384217] brcmfmac: brcmf_cfg80211_connect Enter
[   21.384222] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=wpaie, len=22
[   21.384224] brcmutil: data
[   21.384227] 00000000: 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00  0...............
[   21.384229] 00000010: 00 0f ac 02 00 00                                ......
[   21.384834] brcmfmac: brcmf_vif_set_mgmt_ie bsscfgidx 0, pktflag : 0x20
[   21.384839] brcmfmac: brcmf_cfg80211_connect Applied Vndr IEs for Assoc request
[   21.384841] brcmfmac: brcmf_cfg80211_connect ie (ffff8c7a3680fa48), ie_len (22)
[   21.384844] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wpa_auth, len=4
[   21.384846] brcmutil: data
[   21.384848] 00000000: c0 00 00 00                                      ....
[   21.385302] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=auth, len=4
[   21.385304] brcmutil: data
[   21.385306] 00000000: 00 00 00 00                                      ....
[   21.385656] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wsec, len=4
[   21.385658] brcmutil: data
[   21.385659] 00000000: 04 00 00 00                                      ....
[   21.387495] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=wpa_auth, len=4
[   21.387499] brcmutil: data
[   21.387502] 00000000: c0 00 00 00                                      ....
[   21.387506] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=mfp, len=4
[   21.387507] brcmutil: data
[   21.387508] 00000000: 00 00 00 00                                      ....
[   21.388906] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wpa_auth, len=4
[   21.388910] brcmutil: data
[   21.388913] 00000000: 80 00 00 00                                      ....
[   21.389355] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=205, value=0
[   21.389668] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=join_pref, len=8
[   21.389671] brcmutil: data
[   21.389674] 00000000: 04 02 08 01 01 02 00 00                          ........
[   21.390173] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=join, len=68
[   21.390175] brcmutil: data
[   21.390177] 00000000: 10 00 00 00 65 6d 69 72 61 74 65 6e 73 74 72 61  ....emiratenstra
[   21.390179] 00000010: 61 74 31 35 00 00 00 00 00 00 00 00 00 00 00 00  at15............
[   21.390180] 00000020: 00 00 00 00 ff 00 00 00 ff ff ff ff ff ff ff ff  ................
[   21.390182] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 00 00  ................
[   21.391217] brcmfmac: brcmf_cfg80211_connect Exit
[   21.873748] intel_sst_acpi 808622A8:00: FW Version 01.0b.02.02
[   24.212155] brcmfmac: brcmf_fweh_event_worker event LINK (16) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   24.212168] brcmfmac: brcmf_fweh_event_worker   version 2 flags 1 status 0 reason 0
[   24.212175] brcmutil: event payload, len=22
[   24.212187] 00000000: 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00  0...............
[   24.212194] 00000010: 00 0f ac 02 0c 00                                ......
[   24.261041] brcmfmac: brcmf_fweh_event_worker event SET_SSID (0) ifidx 0 bsscfg 0 addr 80:56:f2:8b:7f:2e
[   24.261050] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 0 reason 0
[   24.261056] brcmutil: event payload, len=16
[   24.261064] 00000000: 65 6d 69 72 61 74 65 6e 73 74 72 61 61 74 31 35  emiratenstraat15
[   24.261070] brcmfmac: brcmf_bss_connect_done Enter
[   24.261696] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=assoc_info, len=512
[   24.261702] brcmutil: data
[   24.261708] 00000000: 9e 00 00 00 93 00 00 00 00 00 00 00 31 04 0a 00  ............1...
[   24.261714] 00000010: 00 00 00 00 00 00 11 04 00 00 01 c0 00 00 00 00  ................
[   24.261718] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.261722] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.262141] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=assoc_req_ies, len=512
[   24.262147] brcmutil: data
[   24.262153] 00000000: 00 10 65 6d 69 72 61 74 65 6e 73 74 72 61 61 74  ..emiratenstraat
[   24.262158] 00000010: 31 35 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12  15......$0Hl2...
[   24.262162] 00000020: 18 60 21 02 06 14 24 02 01 0b 30 14 01 00 00 0f  .`!...$...0.....
[   24.262167] 00000030: ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00  ................
[   24.262596] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=assoc_resp_ies, len=512
[   24.262601] brcmutil: data
[   24.262607] 00000000: 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60  ......$0Hl2....`
[   24.262612] 00000010: 2d 1a bc 19 1b ff ff 00 00 00 00 00 00 00 00 00  -...............
[   24.262616] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 06 00  ............=...
[   24.262620] 00000030: 17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.262627] brcmfmac: brcmf_update_bss_info Enter
[   24.263065] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   24.263071] brcmutil: data
[   24.263077] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   24.263081] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   24.263086] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   24.263090] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   24.263115] brcmfmac: brcmf_update_bss_info Exit
[   24.263135] brcmfmac: brcmf_bss_connect_done Exit
[   24.263142] brcmfmac: brcmf_net_setcarrier Enter, bsscfgidx=0 carrier=1
[   24.263148] brcmfmac: brcmf_txflowblock_if enter: bsscfgidx=0 stop=0x4 reason=4 state=0
[   24.263191] IPv6: ADDRCONF(NETDEV_CHANGE): wlp1s0: link becomes ready
[   24.263341] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   24.263350] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=16
[   24.263354] brcmutil: data
[   24.263360] 00000000: 02 00 00 00 01 00 5e 00 00 01 33 33 00 00 00 01  ......^...33....
[   24.263831] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   24.263836] brcmutil: data
[   24.263842] 00000000: 00 00 00 00                                      ....
[   24.264273] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   24.295295] brcmfmac: brcmf_cfg80211_add_key Enter
[   24.295301] brcmfmac: brcmf_cfg80211_add_key Ext key, mac 80:56:f2:8b:7f:2e
[   24.297663] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wsec_key, len=164
[   24.297667] brcmutil: data
[   24.297671] 00000000: 00 00 00 00 10 00 00 00 7e 4e 94 7e 55 68 20 08  ........~N.~Uh .
[   24.297673] 00000010: f8 9d f4 ce 20 f1 ab 43 00 00 00 00 00 00 00 00  .... ..C........
[   24.297674] 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff d0 79 f5 40  .............y.@
[   24.297676] 00000030: a6 a2 ff ff 48 36 3a 38 7a 8c ff ff 1d 07 00 00  ....H6:8z.......
[   24.298294] brcmfmac: brcmf_cfg80211_add_key Exit
[   24.298407] brcmfmac: brcmf_cfg80211_config_default_key Enter
[   24.298934] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=wsec, len=4
[   24.298938] brcmutil: data
[   24.298943] 00000000: 04 00 00 00                                      ....
[   24.298945] brcmfmac: brcmf_cfg80211_config_default_key Exit
[   24.299448] brcmfmac: brcmf_cfg80211_add_key Enter
[   24.299454] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wsec_key, len=164
[   24.299456] brcmutil: data
[   24.299459] 00000000: 01 00 00 00 10 00 00 00 6c be f2 9d 74 8a 6a 64  ........l...t.jd
[   24.299461] 00000010: 25 86 ee 25 02 f9 46 a5 00 00 00 00 00 00 00 00  %..%..F.........
[   24.299463] 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff d0 79 f5 40  .............y.@
[   24.299464] 00000030: a6 a2 ff ff 00 00 00 00 00 00 00 00 a8 7a f5 40  .............z.@
[   24.300953] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=wsec, len=4
[   24.300964] brcmutil: data
[   24.300976] 00000000: 04 00 00 00                                      ....
[   24.300988] brcmfmac: brcmf_fil_bsscfg_data_set ifidx=0, bsscfgidx=0, name=wsec, len=4
[   24.300993] brcmutil: data
[   24.301001] 00000000: 04 00 00 00                                      ....
[   24.301467] brcmfmac: brcmf_cfg80211_add_key Exit
[   24.303673] brcmfmac: brcmf_cfg80211_change_station Enter, MAC 80:56:f2:8b:7f:2e, mask 0x0002 set 0x0002
[   24.303680] brcmfmac: brcmf_fil_cmd_data_set ifidx=0, cmd=121, len=6
[   24.303683] brcmutil: data
[   24.303686] 00000000: 80 56 f2 8b 7f 2e                                .V....
[   24.321111] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   24.321117] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=16
[   24.321119] brcmutil: data
[   24.321124] 00000000: 02 00 00 00 01 00 5e 00 00 01 33 33 00 00 00 01  ......^...33....
[   24.321454] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   24.321456] brcmutil: data
[   24.321458] 00000000: 00 00 00 00                                      ....
[   24.321835] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   24.322222] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   24.322227] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=22
[   24.322229] brcmutil: data
[   24.322233] 00000000: 03 00 00 00 01 00 5e 00 00 01 33 33 00 00 00 01  ......^...33....
[   24.322235] 00000010: 33 33 ff 17 0a 17                                33....
[   24.322673] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=nd_hostip_clear, len=0
[   24.322675] brcmutil: data
[   24.323039] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   24.323046] brcmfmac: _brcmf_update_ndtable fail to clear nd ip table err:-23
[   24.323055] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   24.323057] brcmutil: data
[   24.323060] 00000000: 00 00 00 00                                      ....
[   24.323533] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   25.521145] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=arpoe, len=4
[   25.521149] brcmutil: data
[   25.521153] 00000000: 01 00 00 00                                      ....
[   25.521406] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=arp_version, len=4
[   25.521408] brcmutil: data
[   25.521410] 00000000: 10 09 12 20                                      ... 
[   25.522042] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=arp_hostip, len=32
[   25.522046] brcmutil: data
[   25.522050] 00000000: 00 00 00 00 68 6f 73 74 69 70 00 00 00 00 00 00  ....hostip......
[   25.522052] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   25.522055] brcmfmac: brcmf_inetaddr_changed add 192.168.1.31 to arp table
[   25.522057] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=arp_hostip, len=4
[   25.522058] brcmutil: data
[   25.522059] 00000000: c0 a8 01 1f                                      ....
[   25.566063] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   25.566446] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   25.566450] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   25.566452] brcmutil: data
[   25.566455] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   25.566457] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   25.566458] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   25.566459] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   25.567117] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   25.567120] brcmutil: data
[   25.567124] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   25.567125] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   25.567126] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 02 00 00 00  ...$0H`l........
[   25.567128] 00000030: 00 00 00 00 06 00 00 00 00 00 00 00 04 00 00 00  ................
[   25.567130] brcmfmac: brcmf_cfg80211_get_station version 4
[   25.567131] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   25.567502] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   25.567505] brcmutil: data
[   25.567507] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   25.567509] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   25.567510] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   25.567511] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   25.567514] brcmfmac: brcmf_cfg80211_get_station Exit
[   25.567781] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   25.568332] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   25.568337] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   25.568338] brcmutil: data
[   25.568342] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   25.568343] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   25.568345] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   25.568346] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   25.568988] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   25.568992] brcmutil: data
[   25.568996] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   25.568997] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   25.568998] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 02 00 00 00  ...$0H`l........
[   25.569000] 00000030: 00 00 00 00 06 00 00 00 00 00 00 00 04 00 00 00  ................
[   25.569002] brcmfmac: brcmf_cfg80211_get_station version 4
[   25.569004] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   25.569815] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   25.569818] brcmutil: data
[   25.569821] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   25.569823] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   25.569824] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   25.569825] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   25.569829] brcmfmac: brcmf_cfg80211_get_station Exit
[   26.120987] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=nd_hostip_clear, len=0
[   26.120991] brcmutil: data
[   26.121251] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   26.121329] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   26.121334] brcmfmac: _brcmf_update_ndtable fail to clear nd ip table err:-23
[   26.121339] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=28
[   26.121340] brcmutil: data
[   26.121344] 00000000: 04 00 00 00 01 00 5e 00 00 01 33 33 00 00 00 01  ......^...33....
[   26.121346] 00000010: 33 33 ff 17 0a 17 33 33 ff a8 cb 8a              33....33....
[   26.121917] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   26.121920] brcmutil: data
[   26.121922] 00000000: 00 00 00 00                                      ....
[   26.122147] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   27.851279] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=nd_hostip_clear, len=0
[   27.851283] brcmutil: data
[   27.851327] brcmfmac: _brcmf_set_multicast_list Enter, bsscfgidx=0
[   27.851760] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   27.851767] brcmfmac: _brcmf_update_ndtable fail to clear nd ip table err:-23
[   27.851775] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mcast_list, len=34
[   27.851776] brcmutil: data
[   27.851780] 00000000: 05 00 00 00 01 00 5e 00 00 01 33 33 00 00 00 01  ......^...33....
[   27.851782] 00000010: 33 33 ff 17 0a 17 33 33 ff a8 cb 8a 33 33 ff 00  33....33....33..
[   27.851783] 00000020: 00 09                                            ..
[   27.852361] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=allmulti, len=4
[   27.852364] brcmutil: data
[   27.852368] 00000000: 00 00 00 00                                      ....
[   27.852943] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=10, value=0
[   28.003823] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   28.004538] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   28.004549] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   28.004556] brcmutil: data
[   28.004568] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   28.004575] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   28.004580] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   28.004586] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   28.005339] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   28.005346] brcmutil: data
[   28.005355] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   28.005369] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   28.005374] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 05 00 00 00  ...$0H`l........
[   28.005379] 00000030: 00 00 00 00 35 00 00 00 00 00 00 00 2a 00 00 00  ....5.......*...
[   28.005385] brcmfmac: brcmf_cfg80211_get_station version 4
[   28.005392] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   28.005908] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   28.005915] brcmutil: data
[   28.005923] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   28.005928] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   28.005933] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   28.005938] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   28.005945] brcmfmac: brcmf_cfg80211_get_station Exit
[   28.006529] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   28.007207] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   28.007217] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   28.007222] brcmutil: data
[   28.007232] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   28.007238] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   28.007244] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   28.007250] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   28.007943] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   28.007950] brcmutil: data
[   28.007959] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   28.007966] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   28.007971] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 05 00 00 00  ...$0H`l........
[   28.007977] 00000030: 00 00 00 00 35 00 00 00 00 00 00 00 2a 00 00 00  ....5.......*...
[   28.007985] brcmfmac: brcmf_cfg80211_get_station version 4
[   28.007991] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   28.008441] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   28.008449] brcmutil: data
[   28.008458] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   28.008464] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   28.008470] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   28.008477] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   28.008492] brcmfmac: brcmf_cfg80211_get_station Exit
[   34.297761] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   34.299823] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   34.299838] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   34.299845] brcmutil: data
[   34.299858] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   34.299866] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   34.299873] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   34.299879] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   34.301201] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   34.301211] brcmutil: data
[   34.301221] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   34.301229] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   34.301236] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 0b 00 00 00  ...$0H`l........
[   34.301251] 00000030: 00 00 00 00 43 00 00 00 00 00 00 00 36 00 00 00  ....C.......6...
[   34.301258] brcmfmac: brcmf_cfg80211_get_station version 4
[   34.301266] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   34.302521] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   34.302529] brcmutil: data
[   34.302540] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   34.302548] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   34.302555] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   34.302561] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   34.302570] brcmfmac: brcmf_cfg80211_get_station Exit
[   34.303312] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   34.304981] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   34.304993] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   34.304998] brcmutil: data
[   34.305009] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   34.305016] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   34.305023] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   34.305029] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   34.306137] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   34.306147] brcmutil: data
[   34.306158] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   34.306166] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   34.306172] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 0b 00 00 00  ...$0H`l........
[   34.306179] 00000030: 00 00 00 00 43 00 00 00 00 00 00 00 36 00 00 00  ....C.......6...
[   34.306187] brcmfmac: brcmf_cfg80211_get_station version 4
[   34.306195] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   34.307398] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   34.307407] brcmutil: data
[   34.307418] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   34.307425] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   34.307432] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   34.307438] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   34.307450] brcmfmac: brcmf_cfg80211_get_station Exit
[   35.893410] usb 1-3: USB disconnect, device number 4
[   37.326723] usb 1-3: new full-speed USB device number 5 using xhci_hcd
[   37.501114] usb 1-3: New USB device found, idVendor=0079, idProduct=1a00
[   37.501131] usb 1-3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[   37.501143] usb 1-3: Product: Mouce for Android
[   37.509072] input: Mouce for Android as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/0003:0079:1A00.0007/input/input16
[   37.512436] hid-generic 0003:0079:1A00.0007: input,hidraw2: USB HID v1.10 Mouse [Mouce for Android] on usb-0000:00:14.0-3/input0
[   37.514604] input: Mouce for Android as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.1/0003:0079:1A00.0008/input/input17
[   37.568094] hid-generic 0003:0079:1A00.0008: input,hidraw3: USB HID v1.10 Keyboard [Mouce for Android] on usb-0000:00:14.0-3/input1
[   40.329179] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   40.329588] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   40.329592] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   40.329594] brcmutil: data
[   40.329598] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   40.329599] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   40.329601] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   40.329602] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   40.329793] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   40.329794] brcmutil: data
[   40.329796] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   40.329798] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   40.329799] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 11 00 00 00  ...$0H`l........
[   40.329800] 00000030: 00 00 00 00 53 00 00 00 00 00 00 00 43 00 00 00  ....S.......C...
[   40.329802] brcmfmac: brcmf_cfg80211_get_station version 4
[   40.329804] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   40.330168] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   40.330170] brcmutil: data
[   40.330172] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   40.330173] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   40.330174] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   40.330175] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   40.330178] brcmfmac: brcmf_cfg80211_get_station Exit
[   40.330463] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   40.330827] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   40.330829] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   40.330830] brcmutil: data
[   40.330833] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   40.330835] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   40.330836] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   40.330837] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   40.331064] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   40.331065] brcmutil: data
[   40.331067] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   40.331068] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   40.331070] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 11 00 00 00  ...$0H`l........
[   40.331071] 00000030: 00 00 00 00 53 00 00 00 00 00 00 00 43 00 00 00  ....S.......C...
[   40.331072] brcmfmac: brcmf_cfg80211_get_station version 4
[   40.331074] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   40.331704] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   40.331706] brcmutil: data
[   40.331708] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   40.331710] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   40.331711] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   40.331712] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   40.331715] brcmfmac: brcmf_cfg80211_get_station Exit
[   46.331049] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   46.332626] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   46.332641] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   46.332647] brcmutil: data
[   46.332661] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   46.332668] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   46.332675] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   46.332681] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   46.333982] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   46.333990] brcmutil: data
[   46.334001] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   46.334009] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   46.334029] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 17 00 00 00  ...$0H`l........
[   46.334036] 00000030: 00 00 00 00 76 00 00 00 00 00 00 00 78 00 00 00  ....v.......x...
[   46.334043] brcmfmac: brcmf_cfg80211_get_station version 4
[   46.334051] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   46.335101] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   46.335113] brcmutil: data
[   46.335124] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   46.335131] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   46.335138] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   46.335144] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   46.335157] brcmfmac: brcmf_cfg80211_get_station Exit
[   46.335954] brcmfmac: brcmf_cfg80211_get_station Enter, MAC 80:56:f2:8b:7f:2e
[   46.337326] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[   46.337341] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_sta_info, len=200
[   46.337347] brcmutil: data
[   46.337359] 00000000: 80 56 f2 8b 7f 2e 00 00 00 00 00 00 00 00 00 00  .V..............
[   46.337366] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   46.337373] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   46.337379] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   46.338553] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=sta_info, len=200
[   46.338563] brcmutil: data
[   46.338576] 00000000: 04 00 c8 00 00 00 00 00 3b e0 01 00 00 00 00 00  ........;.......
[   46.338584] 00000010: 80 56 f2 8b 7f 2e 00 00 0c 00 00 00 02 04 0b 0c  .V..............
[   46.338590] 00000020: 12 16 18 24 30 48 60 6c 00 00 00 00 17 00 00 00  ...$0H`l........
[   46.338597] 00000030: 00 00 00 00 76 00 00 00 00 00 00 00 78 00 00 00  ....v.......x...
[   46.338605] brcmfmac: brcmf_cfg80211_get_station version 4
[   46.338612] brcmfmac: brcmf_convert_sta_flags flags 0001e03b
[   46.339604] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=136, len=2048
[   46.339616] brcmutil: data
[   46.339627] 00000000: e8 01 00 00 6d 00 00 00 e4 01 00 00 80 56 f2 8b  ....m........V..
[   46.339635] 00000010: 7f 2e 64 00 11 04 10 65 6d 69 72 61 74 65 6e 73  ..d....emiratens
[   46.339641] 00000020: 74 72 61 61 74 31 35 00 00 00 00 00 00 00 00 00  traat15.........
[   46.339656] 00000030: 00 00 00 00 00 00 00 00 0c 00 00 00 82 84 8b 0c  ................
[   46.339669] brcmfmac: brcmf_cfg80211_get_station Exit

--------------A5B95BC1306E5751EFD08E82--
