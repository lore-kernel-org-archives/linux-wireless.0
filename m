Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57843 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2IFTFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 15:05:00 -0400
Received: by ieje11 with SMTP id e11so3629416iej.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2012 12:05:00 -0700 (PDT)
Message-ID: <5048F3D8.9030509@lwfinger.net> (sfid-20120906_210508_039964_EB883B19)
Date: Thu, 06 Sep 2012 14:04:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Anisse Astier <anisse@astier.eu>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
Subject: Re: rtl8192ce: activation problem with rtl8188ce pci card
References: <20120905185510.2ab501cd@destiny.ordissimo> <50478E10.6030808@lwfinger.net> <20120905201437.70c008ca@destiny.ordissimo> <5047B508.5030606@lwfinger.net> <20120906161529.016b2202@destiny.ordissimo> <5048D138.1080109@lwfinger.net> <20120906202710.30c4bc8a@destiny.ordissimo>
In-Reply-To: <20120906202710.30c4bc8a@destiny.ordissimo>
Content-Type: multipart/mixed;
 boundary="------------050707000403010301040300"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050707000403010301040300
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/06/2012 01:27 PM, Anisse Astier wrote:
>
> On Thu, 06 Sep 2012 11:37:12 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :
>
>> On 09/06/2012 09:15 AM, Anisse Astier wrote:
>>> On Wed, 05 Sep 2012 15:24:40 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :
>>>
>>>> Note, the RTL8188CE-VL does not work with wireless-next, but does with
>>>> wireless-testing with some patches applied. I will contact the Realtek software
>>>> team to ask questions about your card. I added my contact as a Cc here. In the
>>>> meantime, could you try the wireless-testing tree? If your card still does not
>>>> work, I will send you some patches to see what it takes.
>>>
>>> What patch does wireless-testing have that aren't in wireless-next ? I
>>> failed to find them.
>>
>> The reason I said that I would send them is because there are patches sent to
>> Linville that have not yet been merged, and patches that have not yet been
>> submitted as they are still in testing.
> Okay, sorry for the confusion. I don't know if this email was meant to be
> private, but it is :-)

I did not want to dump that 8 MB file on the list.

>>
>> Attached is a tarball containing the latest Realtek driver. I just got this to
>> build under 3.6 a few minutes ago. It has been tested only a minimal amount, but
>> I would like to know if it handles your card. I'm using it now on the RTL8188CE-VL.
>>
>> Unpack the tar ball with the usual 'tar zxf' command, cd to the new directory,
>> and make. If the make step issues any errors or warnings, send them to me. I
>> built it on an x86_64 system, but have not yet tried it on a 32-bit kernel. Once
>> built, then do the following:
>>
>> sudo modprobe -rv rtl8192ce
>> sudo modprobe -v mac80211
>> sudo insmod rtlwifi.ko
>> sudo insmod rtl8192ce/rtl8192ce.ko
>>
>> This version does not have debug as a module parameter, thus do not try to load
>> with it.
>
> I modified it to always have debug level at 4. Also it needs a #include
> <linux/proc_fs.h> in debug.c .

Strange.

> It requires on of the new firmware to work this time (I didn't check
> which one). But it freezes at load time:
>
> [  479.542811] cfg80211: Calling CRDA to update world regulatory domain
> [  518.692736] rtlwifi-0:rtl_pci_probe():<0-0> mem mapped space: start: 0xf0200000 len:00004000 flags:00140204, after map:0xf85f8000
> [  518.692857] rtlwifi-0:_rtl_pci_find_adapter():<0-0> 8192C PCI-E is found - vid/did=10ec/8176
> [  518.692871] rtlwifi-0:_rtl_pci_find_adapter():<0-0> Pci Bridge Vendor is found index: 2
> [  518.692887] rtlwifi-0:_rtl_pci_find_adapter():<0-0> pcidev busnumber:devnumber:funcnumber:vendor:link_ctl 6:0:0:10ec:0
> [  518.692900] rtlwifi-0:_rtl_pci_find_adapter():<0-0> pci_bridge busnumber:devnumber:funcnumber:vendor:pcie_cap:link_ctl_reg:amd 0:21:1:1022:58:40:0
> [  518.692966] rtl8192ce-0:_rtl92ce_read_chip_version():<0-0> Chip RF Type: RF_1T1R
> [  518.692978] rtl8192ce-0:rtl92ce_read_eeprom_info():<0-0> VersionID = 0x  70
> [  518.692990] rtl8192ce-0:rtl92ce_read_eeprom_info():<0-0> Boot from EFUSE
> [  518.693001] rtl8192ce-0:rtl92ce_read_eeprom_info():<0-0> Autoload OK
> [  518.708350] rtl8192ce:
> [  518.708359] In process "insmod" (pid 3914):MAP
> [  518.708371] 29 81 00 74  ED 00 20 00  FF 00 EC 10  76 81 EC 10
> [  518.708419] 12 82 00 00  00 00 24 EC  99 48 32 88  00 00 00 00
> [  518.708465] 01 40 13 AA  03 02 20 40  01 00 00 13  45 B6 A4 01
> [  518.708511] 00 E0 4C FF  FE 81 91 01  C3 FF 9E C9  40 42 00 00
> [  518.708556] C0 8C 80 02  00 00 11 3C  27 00 10 20  78 5E 00 55
> [  518.708602] 78 12 B0 E9  50 C4 37 54  B8 CC 22 21  26 00 00 00
> [  518.708647] 25 25 29 00  00 00 00 00  00 02 01 02  02 01 02 00
> [  518.708691] 00 00 00 00  00 8A 00 00  10 09 00 00  36 00 81 00
> [  518.708736]
> [  518.708745] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> Autoload OK
> [  518.708755] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROMId = 0x8129
> [  518.708766] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROM VID = 0x10ec
> [  518.708776] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROM DID = 0x8176
> [  518.708787] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROM SVID = 0x10ec
> [  518.708797] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROM SMID = 0x8212
> [  518.708807] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> dev_addr: 24:ec:99:48:32:88
> [  518.708827] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROM Customer ID: 0x 0
> [  518.708839] rtl8192ce-0:_rtl92ce_hal_customized_behavior():<0-0> RT Customized ID: 0x00
> [  518.743949] rtlwifi-0:rtl_pci_enable_aspm():<0-0> PlatformEnableASPM(): Write reg[68] = 42
> [  518.744258] rtlwifi-0:_rtl_init_hw_ht_capab():<0-0> 1T1R
> [  518.744846] rtlwifi-0:_rtl_pci_init_tx_ring():<0-0> queue:0, ring_addr:f30b4000
> [  518.744892] rtlwifi-0:_rtl_pci_init_tx_ring():<0-0> queue:1, ring_addr:f30b8000
> [  518.744939] rtlwifi-0:_rtl_pci_init_tx_ring():<0-0> queue:2, ring_addr:f30b6000
> [  518.744974] rtlwifi-0:_rtl_pci_init_tx_ring():<0-0> queue:3, ring_addr:f30bc000
> [  518.745003] rtlwifi-0:_rtl_pci_init_tx_ring():<0-0> queue:4, ring_addr:f4b81000
> [  518.745025] rtlwifi-0:_rtl_pci_init_tx_ring():<0-0> queue:5, ring_addr:f30be000
> [  518.745059] rtlwifi-0:_rtl_pci_init_tx_ring():<0-0> queue:6, ring_addr:f30c0000
> [  518.745121] rtlwifi-0:_rtl_pci_init_tx_ring():<0-0> queue:7, ring_addr:f30c2000
> [  518.745154] rtlwifi-0:_rtl_pci_init_tx_ring():<0-0> queue:8, ring_addr:f30c4000
> [  518.812595] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
> [  518.822175] rtlwifi: wireless switch is on
>
> That's all I was able to get.

Perhaps Chaoming knows something about this output. All I know is that you now 
have the latest driver.

If you apply the attached patch, it will log the firmware name. That will tell 
us what cut you have. If you have quilt installed, you can "quilt import 
filename" and "quilt push", otherwise just use the patch utility. I checked and 
the version of the firmware files in this driver match those in the 
linux-firmware git repo.

 From your name and E-mail address, I would guess you are in France. If you were 
in the US, I would send you one of my standard cards in exchange for yours so 
that I could sort out the driver for it. Perhaps that would still work.

Larry


--------------050707000403010301040300
Content-Type: text/plain; charset=UTF-8;
 name="output_fw_name"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="output_fw_name"

SW5kZXg6IHJ0bF85MmNlXzkyc2VfOTJkZV84NzIzYWVfbGludXhfbWFjODAyMTFfMDAwNy4w
ODA5LjIwMTIvcnRsODE5MmNlL3N3LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gcnRsXzkyY2VfOTJz
ZV85MmRlXzg3MjNhZV9saW51eF9tYWM4MDIxMV8wMDA3LjA4MDkuMjAxMi5vcmlnL3J0bDgx
OTJjZS9zdy5jCisrKyBydGxfOTJjZV85MnNlXzkyZGVfODcyM2FlX2xpbnV4X21hYzgwMjEx
XzAwMDcuMDgwOS4yMDEyL3J0bDgxOTJjZS9zdy5jCkBAIC0xNjIsNiArMTYyLDcgQEAgaW50
IHJ0bDkyY19pbml0X3N3X3ZhcnMoc3RydWN0IGllZWU4MDIxMQogCQlmd19uYW1lID0gInJ0
bHdpZmkvcnRsODE5MmNmd1VfQi5iaW4iOwogCWVsc2UKIAkJZndfbmFtZSA9IHJ0bHByaXYt
PmNmZy0+ZndfbmFtZTsKKwlwcmludGsoS0VSTl9JTkZPICIJTG9hZGluZyBmaXJtd2FyZSAl
c1xuIiwgZndfbmFtZSk7CiAJZXJyID0gcmVxdWVzdF9maXJtd2FyZSgmZmlybXdhcmUsIGZ3
X25hbWUsIHJ0bHByaXYtPmlvLmRldik7CiAKIAlpZiAoZXJyKSB7Cg==
--------------050707000403010301040300--
