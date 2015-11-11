Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:34623 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbbKKXYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 18:24:48 -0500
Received: by ykfs79 with SMTP id s79so76559081ykf.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2015 15:24:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5640CE0E.8040206@candelatech.com>
References: <CADLC3L1xeetwWLn1FbSyzvFYHvPw2z8C3OmQ-w9Bi0U=iLqZiA@mail.gmail.com>
	<5640CE0E.8040206@candelatech.com>
Date: Wed, 11 Nov 2015 17:24:47 -0600
Message-ID: <CADLC3L3JU0iCPMNttyj7J24JkttiuCatd-VMP-yH1Yfxy7HsLg@mail.gmail.com> (sfid-20151112_002452_749181_FE3E50F3)
Subject: Re: ath10k AP "failed to delete peer" errors when using Nexus 5X
From: Robert Hancock <hancockrwd@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2015 at 10:47 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 11/08/2015 10:02 PM, Robert Hancock wrote:
>>
>> I'm using OpenWRT on a TP-Link Archer C7, currently running
>> development rev 47397 which is kernel 4.1.1 and compat-wireless
>> 2015-10-26. Ever since I got a new Nexus 5X phone, it seems like
>> periodically (once a day or so), the 5GHz wireless (using ath10k)
>> craps out and I get a bunch of errors in the kernel log on the router.
>> I have to reboot the router to get the 5GHz working again. Full kernel
>> log from one of these failures is below. Any thoughts on what is going
>> on here?
>>
>> There are reports of a newer Android build (which I don't have yet)
>> which supposedly has some wireless fixes on the Nexus 5X, but I'm not
>> sure what it could be doing that would be causing the router to crap
>> out like this.
>
>
>> [ 2178.931641] ---[ end trace 6751cc6390d26848 ]---
>> [ 2181.926812] ath10k_pci 0000:01:00.0: failed to delete peer
>> 8c:3a:e3:15:29:f3 for vdev 0: -11
>> [ 2184.946721] ath10k_pci 0000:01:00.0: failed to set beacon mode for
>> vdev 0: -11
>> [ 2187.946538] ath10k_pci 0000:01:00.0: failed to set dtim period for
>> vdev 0: -11
>> [ 2190.986373] ath10k_pci 0000:01:00.0: failed to recalculate rts/cts
>> prot for vdev 0: -11
>> [ 2193.986210] ath10k_pci 0000:01:00.0: failed to set protection mode
>> 0 on vdev 0: -11
>> [ 2196.986045] ath10k_pci 0000:01:00.0: failed to set preamble for vdev 0:
>> -11
>
>
> Usually this means firmware has stopped processing WMI messages.
>
> You might try different firmware versions in hopes one of them fixes the
> problem.
>
> Thanks,
> Ben

I tried switching to the 10.2.4.70.10-2 firmware version, which seems
to be the latest version I can find for QCA988X. It seemed like it was
working better (though it's hard to say as it happens sporadically),
but then the failure happened again. Are there any newer versions than
that one, or any other ideas?

[   48.612363] ath10k_pci 0000:01:00.0: qca988x hw2.0 (0x4100016c,
0x043202ff sub 0000:0000) fw 10.2.4.70.10-2 fwapi 5 bdapi 1 htt-ver
2.1 wmi-op 5 htt-op 2 cal file max-sta 128 raw 0 hwcrypto 1 features
no-p2p,raw-mode

..

[72071.328152] ath10k_pci 0000:01:00.0: failed to delete peer
64:bc:0c:46:e4:55 for vdev 0: -145
[72071.336819] ------------[ cut here ]------------
[72071.341644] WARNING: CPU: 0 PID: 2189 at
/home/rob/openwrt/build_dir/target-mips_34kc_musl-1.1.11/linux-ar71xx_generic/compat-wireless-2015-10-26/net/mac80211/sta_info.c:918
sta_set_sinfo+0x938/0x9d0 [mac80211]()
[72071.360803] Modules linked in: pppoe ppp_async iptable_nat ath9k
pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4
ipt_REJECT ipt_MASQUERADE ath9k_common xt_time xt_tcpudp xt_tcpmss
xt_string xt_statistic xt_state xt_recent xt_nat xt_multiport xt_mark
xt_mac xt_limit xt_length xt_id xt_hl xt_helper xt_ecn xt_dscp
xt_conntrack xt_connmark xt_connlimit xt_connbytes xt_comment
xt_TCPMSS xt_REDIRECT xt_LOG xt_HL xt_DSCP xt_CT xt_CLASSIFY usblp
ts_kmp ts_fsm ts_bm slhc nf_reject_ipv4 nf_nat_redirect
nf_nat_masquerade_ipv4 nf_nat_ftp nf_nat nf_log_ipv4 nf_defrag_ipv6
nf_defrag_ipv4 nf_conntrack_rtcache nf_conntrack_ftp iptable_raw
iptable_mangle iptable_filter ipt_ECN ip_tables crc_ccitt ath9k_hw
em_cmp em_nbyte sch_teql sch_dsmark sch_tbf sch_pie act_ipt sch_gred
sch_htb cls_basic sch_prio
[72071.433472]  em_meta act_police em_text sch_codel sch_fq sch_sfq
sch_red act_connmark nf_conntrack act_skbedit act_mirred em_u32
cls_u32 cls_tcindex cls_flow cls_route cls_fw sch_hfsc sch_ingress
ath10k_pci ath10k_core ath mac80211 cfg80211 compat ledtrig_usbdev
xt_set ip_set_list_set ip_set_hash_netiface ip_set_hash_netport
ip_set_hash_netnet ip_set_hash_net ip_set_hash_netportnet
ip_set_hash_mac ip_set_hash_ipportnet ip_set_hash_ipportip
ip_set_hash_ipport ip_set_hash_ipmark ip_set_hash_ip
ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set
nfnetlink ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common
ip6table_raw ip6table_mangle ip6table_filter ip6_tables x_tables msdos
ifb sit tunnel4 ip_tunnel vfat fat usb_storage ohci_platform ohci_hcd
ehci_platform ehci_hcd sd_mod scsi_mod gpio_button_hotplug
[72071.505606]  ext4 jbd2 mbcache usbcore nls_base usb_common crc16 crypto_hash
[72071.511521] CPU: 0 PID: 2189 Comm: hostapd Not tainted 4.1.11 #2
[72071.517609] Stack : 803e42d2 00000034 00000000 00000001 8033cd38
80388723 878f6ab8 0000088d
      803e352c 00000000 00000004 00000008 00000000 800a5d90 00000003 803420ac
      00000396 00000000 803405c0 86a317e4 00000000 800a4418 803e42d2 000000c8
      00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
      00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
      ...
[72071.554023] Call Trace:
[72071.556520] [<80072180>] show_stack+0x50/0x84
[72071.560964] [<80081a48>] warn_slowpath_common+0xa0/0xd0
[72071.566297] [<80081b00>] warn_slowpath_null+0x18/0x24
[72071.571548] [<873869ec>] sta_set_sinfo+0x938/0x9d0 [mac80211]

[72071.578995] ---[ end trace 8a40faa59ba0f534 ]---
[72387.104598] ath10k_pci 0000:01:00.0: failed to install key for vdev
0 peer 8c:3a:e3:15:29:f3: -145
[72387.113708] wlan0: failed to remove key (0, 8c:3a:e3:15:29:f3) from
hardware (-145)
[72387.129423] ath10k_pci 0000:01:00.0: cipher 0 is not supported
[72387.135418] ath10k_pci 0000:01:00.0: failed to remove peer wep key 0: -122
[72387.142395] ath10k_pci 0000:01:00.0: failed to clear all peer wep
keys for vdev 0: -122
[72387.150541] ath10k_pci 0000:01:00.0: failed to disassociate
station: 8c:3a:e3:15:29:f3 vdev 0: -122
