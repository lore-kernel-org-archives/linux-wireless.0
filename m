Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58894 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2LBBgf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Dec 2012 20:36:35 -0500
Message-ID: <50BAB095.2070103@hauke-m.de> (sfid-20121202_023640_200915_66F79BDA)
Date: Sun, 02 Dec 2012 02:36:21 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: brcmsmac: Data bus error in reading tsf_random
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I am getting a Data bus error when brcmsmac tries to read tsf_random in
brcms_c_wme_setparams. This does not happen when I add a printk
somewhere near that read of tsf_random or when I replace the read with a
constant. In b43 this code works, without this error for me, see
b43_qos_params_upload(). With the BCM4716 I do not have this problem. It
could be that this is caused by the broken PCIe controller in the BCM4716.

I am using brcmsmac from compat-wireless 2012-09-07, but I have also
tried the most recent brcmsmac code from wireless-testing. brcmsmac uses
the normal firmware from linux-firmware and I have also tried the new
firmware posted some days ago with the same result.

I am using a BCM43224 connected to the PCIe controller of the BCM4716.

Are there any special requirements for reading tsf_random under mips?

To make my BCM43224 work I use this patch [0], the "printk("dummy\n");"
is a hack to workaround the problem I am describing here.

Hauke

[0]:
https://dev.openwrt.org/browser/trunk/package/mac80211/patches/850-brcmsmac-add-support-for-BCM43224.patch


root@OpenWrt:/# iw phy phy0 interface add wlan0 type managed
root@OpenWrt:/# ifconfig wlan0 up
[   34.828000] Data bus error, epc == 8014a890, ra == 801ba3c4
[   34.828000] Oops[#1]:
[   34.828000] Cpu 0
[   34.828000] $ 0   : 00000000 1100cc00 00000001 83994800
[   34.828000] $ 4   : a800065a 00000820 00000000 00000002
[   34.828000] $ 8   : 00000020 801392f0 24189612 6c604830
[   34.828000] $12   : 00000000 00000001 00000000 ffffff00
[   34.828000] $16   : 83992e80 0000065a 00000003 00000020
[   34.828000] $20   : 00000000 83992e80 82e3a0e4 82e5b458
[   34.828000] $24   : 00000000 801ba2e8
[   34.828000] $28   : 82e98000 82e99c10 83992e90 801ba3c4
[   34.828000] Hi    : 00004000
[   34.828000] Lo    : 00000000
[   34.828000] epc   : 8014a890 ioread16+0x4/0xc
[   34.828000]     Tainted: G           O
[   34.828000] ra    : 801ba3c4 bcma_host_pci_read16+0x34/0x4c
[   34.828000] Status: 1100cc03    KERNEL EXL IE
[   34.828000] Cause : 8080001c
[   34.828000] PrId  : 00019740 (MIPS 74Kc)
[   34.828000] Modules linked in: nf_nat_irc nf_nat_ftp nf_conntrack_irc
nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat pppoe xt_conntrack
xt_CT xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4
nf_conntrack pppox ipt_REJECT xt_TCPMSS xt_comment xt_multiport xt_mac
xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables
brcmsmac(O) ppp_async ppp_generic slhc brcmutil(O) mac80211(O)
switch_core(O) crc8 crc_ccitt cordic cfg80211(O) compat(O) arc4
aes_generic crypto_blkcipher cryptomgr aead crypto_hash crypto_algapi
[last unloaded: switch_core]
[   34.828000] Process ifconfig (pid: 853, threadinfo=82e98000,
task=83904d30, tls=77a8e440)
[   34.828000] Stack : 0000000c 82e07d80 83992e80 801ba2c0 82dfd400
82dfd400 00000000 82e08e68
        0000000c 0c8b8482 24189612 6c604830 000305e0 00030007 00000002
00000000
        00000000 00000000 00000000 00000000 82e39bf0 82dfd400 00000001
82e39bf0
        00000002 82e0de5c 00000001 82e38874 82e99cb0 82e5a894 0000007f
00000001
        0003002f 00620007 00050011 0000000c 0c8b8482 24189612 6c604830
82e60000
        ...
[   34.828000] Call Trace:
[   34.828000] [<8014a890>] ioread16+0x4/0xc
[   34.828000] [<801ba3c4>] bcma_host_pci_read16+0x34/0x4c
[   34.828000] [<82e08e68>] brcms_c_wme_setparams+0x134/0x1d4 [brcmsmac]
[   34.828000] [<82e0de5c>] brcms_c_init+0xdac/0xe88 [brcmsmac]
[   34.828000] [<82e0bfe4>] brcms_c_up+0x35c/0x478 [brcmsmac]
[   34.828000] [<82e01e00>] brcms_rfkill_set_hw_state+0xec/0x144 [brcmsmac]
[   34.828000] [<82d910ac>] ieee80211_do_open+0x138/0xaf8 [mac80211]
[   34.828000] [<801d4a04>] __dev_open+0x144/0x228
[   34.828000] [<801d4d40>] __dev_change_flags+0xc0/0x160
[   34.828000] [<801d4e88>] dev_change_flags+0x20/0x6c
[   34.828000] [<8022df64>] devinet_ioctl+0x2ac/0x7f8
[   34.828000] [<801bbd80>] sock_ioctl+0x294/0x2f4
[   34.828000] [<800ab1f4>] do_vfs_ioctl+0x5a4/0x5f8
[   34.828000] [<800ab298>] sys_ioctl+0x50/0x98
[   34.828000] [<8000e1d0>] stack_done+0x20/0x40
[   34.828000]
[   34.828000]
Code: 03e00008  304200ff  94820000 <03e00008> 3042ffff  94830000
3063ffff  00031200  00031a02
[   35.104000] ---[ end trace ef9d9b193b014ece ]---


(gdb) l *(brcms_c_wme_setparams+0x134)
0x8e68 is in brcms_c_wme_setparams
(/home/hauke/openwrt/git/build_dir/linux-brcm47xx_uClibc-0.9.33.2/compat-wireless-2012-09-07/drivers/net/wireless/brcm80211/brcmsmac/main.c:4087).
4082				  "aifs %d\n", wlc->pub->unit, acp_shm.aifs);
4083		} else {
4084			acp_shm.cwmin = params->cw_min;
4085			acp_shm.cwmax = params->cw_max;
4086			acp_shm.cwcur = acp_shm.cwmin;
4087			acp_shm.bslots =
4088				bcma_read16(wlc->hw->d11core, D11REGOFFS(tsf_random)) &
4089				acp_shm.cwcur;
4090			acp_shm.reggap = acp_shm.bslots + acp_shm.aifs;
4091			/* Indicate the new params to the ucode */
