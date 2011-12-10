Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46413 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1LJWMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 17:12:16 -0500
Message-ID: <4EE3D936.4070707@hauke-m.de> (sfid-20111210_231225_793327_DFF3151E)
Date: Sat, 10 Dec 2011 23:12:06 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>
Subject: Re: [PATCH 00/23] brcm80211: fullmac 4430 support and softmac switch
 to bcma
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 12:06 AM, Franky Lin wrote:
> This train contains patches enable the support for bcm4330 for fullmac
> and part of the patch series of switching to bcma bus interface for
> softmac.
> 
> Arend van Spriel (19):
>   bcma: add set/mask macros for 16-bit register access
>   bcma: use static keyword for inline function declaration in bcma.h
>   brcm80211: smac: remove unused fields from struct si_pub definition
>   brcm80211: smac: move fields from struct si_pub to struct si_info
>   brcm80211: smac: use inline access functions for struct si_pub fields
>   brcm80211: smac: change from pci device driver to bcma device driver
>   brcm80211: smac: change attach interfaces in main.c for bcma support
>   brcm80211: smac: rename struct si_info field pbus to pcibus
>   brcm80211: smac: change ai_attach interface taking a bcma_bus object
>   brcm80211: smac: remove enumeration rom parsing function
>   brcm80211: smac: use bcma core register access functions for 802.11
>     core
>   brcm80211: smac: use DMA-API calls for descriptor allocations
>   brcm80211: smac: use bcma function for register access in dma.c
>   brcm80211: smac: use bcma functions for register access in phy code
>   brcm80211: smac: remove SI_FAST() macro usage
>   brcm80211: smac: replace ai_corereg() function with ai_cc_reg()
>   brcm80211: smac: remove unused functions and/or prototypes
>   brcm80211: smac: use bcma core control functions
>   brcm80211: smac: use bcma core access functions in nicpci.c
> 
> Franky Lin (4):
>   brcm80211: fmac: save bus interface structure in function 2 device
>   brcm80211: fmac: fix firmware shared structures version
>   brcm80211: fmac: add bcm4330 support
>   brcm80211: fmac: remove drive strength code for unsupported chips
> 
Hi,

nice patches for brcmsmac. I tried them on my bcm4716 device (wireless
core on the system bus), but brcmsmac does not work there, I am getting
a kernel oops. aiutils.c does does not work for SoCs e.g.
ai_setcoreidx() does not handle that all cores are mapped on SoCs at the
same time, just under different addresses. I hope you are working on
removing aiutils.c and moving the parts missing in bcma into it.

Hauke

CPU 0 Unable to handle kernel paging request at virtual address
00000114, epc == 830bcee8, ra == 801660b4
Oops[#1]:
Cpu 0
$ 0   : 00000000 00000063 00000000 00000001
$ 4   : 83877e80 830e0000 000004bf 00000812
$ 8   : fffffffc 8012b940 00000008 ffffff80
$12   : 00000001 8301af90 00000050 00000eb0
$16   : 83877e90 830e0fb0 83877e80 ffffffed
$20   : 830e0fb0 802b0000 00000028 8004fbb8
$24   : 00000018 830bce90
$28   : 83b32000 83b33ce8 00000124 801660b4
Hi    : 00000019
Lo    : 0000000f
epc   : 830bcee8 pcicore_pci_setup+0x168/0x6c0 [brcmsmac]
    Tainted: G           O
ra    : 801660b4 driver_probe_device+0x124/0x254
Status: 11008403    KERNEL EXL IE
Cause : 00800008
BadVA : 00000114
PrId  : 00019740 (MIPS 74Kc)
Modules linked in: brcmsmac(O+) brcmutil(O) nls_utf8 nls_koi8_r
nls_iso8859_2 nls_iso8859_15 nls_iso8859_13 nls_iso8859_1 nls_cp866
nls_cp852 nls_cp850 nls_cp775 nls_cp437 nls_cp1251 nls_cp1250
mac80211(O) usbcore usb_common switch_core(O) scsi_mod nls_base crc8
crc16 crc_ccitt cordic cfg80211(O) compat(O) ssb_hcd bcma_hcd arc4
aes_generic crypto_algapi [last unloaded: switch_core]
Process insmod (pid: 385, threadinfo=83b32000, task=83a3e0b8, tls=775472d0)
Stack : fffffff4 8301ae00 83877e90 830e0fb0 00000011 00000000 830e0fb0
83877e90
        00000000 83877e98 ffffffed 830e0fb0 802b0000 00000028 83877e90
830e0fb0
        80300000 ffffffed 830e0fb0 802b0000 00000028 8004fbb8 00000124
801660b4
        00000028 8004fbb8 83863780 80233348 8301ae00 83877e90 830e0fb0
83877ec4
        830e0fb0 00000000 802e0000 80166250 830e0fb0 80164d28 11008401
839f6540
        ...
Call Trace:
[<830bcee8>] pcicore_pci_setup+0x168/0x6c0 [brcmsmac]


Code: 3c05830e  8c42000c  00809021 <8c420114> 02002021  24a5f04c
0c05899b  afa20018  3c030812
---[ end trace 1f4714862ccd4ec9 ]---
