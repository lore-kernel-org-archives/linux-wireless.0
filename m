Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37824 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3JXVcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 17:32:18 -0400
Received: by mail-pa0-f48.google.com with SMTP id bj1so3872170pad.35
        for <linux-wireless@vger.kernel.org>; Thu, 24 Oct 2013 14:32:18 -0700 (PDT)
Received: from samsung-9 ([170.173.0.21])
        by mx.google.com with ESMTPSA id ho3sm4778716pbb.23.2013.10.24.14.32.17
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 24 Oct 2013 14:32:17 -0700 (PDT)
Date: Thu, 24 Oct 2013 14:31:53 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: linux-wireless@vger.kernel.org
Subject: Fw: [Bug 63601] New: Since kernel 3.7.0 rfkill switch is no longer
 working on Dell E5530
Message-ID: <20131024143153.3a7a5518@samsung-9> (sfid-20131024_233222_693730_5FED2196)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Begin forwarded message:

Date: Wed, 23 Oct 2013 22:22:21 -0700
From: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>
To: "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: [Bug 63601] New: Since kernel 3.7.0 rfkill switch is no longer working on Dell E5530


https://bugzilla.kernel.org/show_bug.cgi?id=63601

            Bug ID: 63601
           Summary: Since kernel 3.7.0 rfkill switch is no longer working
                    on Dell E5530
           Product: Networking
           Version: 2.5
    Kernel Version: 3.7.0 - 3.11.6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: Other
          Assignee: shemminger@linux-foundation.org
          Reporter: vaclav@bohata.net
        Regression: No

Created attachment 112171
  --> https://bugzilla.kernel.org/attachment.cgi?id=112171&action=edit
.config file

Since kernel 3.7.0 rfkill switch on my Dell E5530 is no longer working. Rfkill
command is working well, but laptop switch not. Even no message in dmesg since
3.7.0 when switching between ON/OFF. Tested on kernel 3.7.0, ubuntu-3.8, 3.10,
3.11.6.


lspci:
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller
(rev 09)
00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor
Graphics Controller (rev 09)
00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family
USB xHCI Host Controller (rev 04)
00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series
Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family
USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family
High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI
Express Root Port 1 (rev c4)
00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI
Express Root Port 2 (rev c4)
00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI
Express Root Port 3 (rev c4)
00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI
Express Root Port 4 (rev c4)
00:1c.5 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI
Express Root Port 6 (rev c4)
00:1c.6 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI
Express Root Port 7 (rev c4)
00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family
USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller (rev
04)
00:1f.2 RAID bus controller: Intel Corporation 82801 Mobile SATA Controller
[RAID mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus
Controller (rev 04)
02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 [Taylor
Peak] (rev 34)
0b:00.0 SD Host controller: O2 Micro, Inc. Device 8221 (rev 05)
0c:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5761 Gigabit
Ethernet PCIe (rev 10)

lsusb:
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 003 Device 002: ID 09da:054f A4 Tech Co., Ltd
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 413c:8197 Dell Computer Corp.
Bus 001 Device 004: ID 0c45:648b Microdia
Bus 001 Device 005: ID 08ff:2810 AuthenTec, Inc. AES2810

lsmod (from 3.7.0):
Module                  Size  Used by
pci_stub               12623  1
vboxpci                23237  0
vboxnetadp             25671  0
vboxnetflt             27613  0
vboxdrv               320275  3 vboxpci,vboxnetadp,vboxnetflt
nfsd                  277655  2
nfs_acl                12838  1 nfsd
auth_rpcgss            45138  1 nfsd
nfs                   180537  0
fscache                61011  1 nfs
lockd                  93923  2 nfsd,nfs
sunrpc                269856  6 nfsd,nfs_acl,auth_rpcgss,nfs,lockd
rfcomm                 42652  12
bnep                   18182  2
arc4                   12574  2
binfmt_misc            17432  1
iwldvm                241721  0
xt_hl                  12522  6
snd_hda_codec_hdmi     36805  1
snd_hda_codec_idt      70197  1
ip6t_rt                12559  3
nf_conntrack_ipv6      14161  7
nf_defrag_ipv6         13231  1 nf_conntrack_ipv6
snd_hda_intel          33817  3
mac80211              558626  1 iwldvm
ipt_REJECT             12542  1
xt_LOG                 17401  9
nls_iso8859_1          12714  1
snd_hda_codec         134873  3
snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel
xt_limit               12712  12
xt_tcpudp              12604  22
xt_addrtype            12636  4
snd_hwdep              13564  1 snd_hda_codec
nf_conntrack_ipv4      14488  7
nf_defrag_ipv4         12730  1 nf_conntrack_ipv4
xt_state               12579  14
snd_pcm                97487  3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
snd_seq_midi           13325  0
iwlwifi               165764  1 iwldvm
snd_rawmidi            30571  1 snd_seq_midi
ip6table_filter        12816  1
snd_seq_midi_event     14900  1 snd_seq_midi
ip6_tables             27165  2 ip6t_rt,ip6table_filter
snd_seq                61555  2 snd_seq_midi,snd_seq_midi_event
coretemp               13358  0
snd_timer              29533  2 snd_pcm,snd_seq
nf_conntrack_netbios_ns    12666  0
snd_seq_device         14498  3 snd_seq_midi,snd_rawmidi,snd_seq
kvm_intel             136540  0
kvm                   428528  1 kvm_intel
i8k                    14301  0
ppdev                  17031  0
nf_conntrack_broadcast    12590  1 nf_conntrack_netbios_ns
nf_conntrack_ftp       13339  0
nf_conntrack           83444  6
nf_conntrack_ipv6,nf_conntrack_ipv4,xt_state,nf_conntrack_netbios_ns,nf_conntrack_broadcast,nf_conntrack_ftp
dell_laptop            17426  0
dell_wmi               12682  0
iptable_filter         12811  1
snd                    78959  16
snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore              15048  1 snd
btusb                  18292  0
ip_tables              26953  1 iptable_filter
bluetooth             206157  24 rfcomm,bnep,btusb
snd_page_alloc         18711  2 snd_hda_intel,snd_pcm
cfg80211              211955  3 iwldvm,mac80211,iwlwifi
x_tables               29758  12
xt_hl,ip6t_rt,ipt_REJECT,xt_LOG,xt_limit,xt_tcpudp,xt_addrtype,xt_state,ip6table_filter,ip6_tables,iptable_filter,ip_tables
psmouse                86392  0
lp                     17760  0
sparse_keymap          13891  1 dell_wmi
joydev                 17378  0
serio_raw              13216  0
lpc_ich                17062  0
dcdbas                 14439  1 dell_laptop
mei                    40696  0
parport_pc             32689  0
parport                46355  3 ppdev,lp,parport_pc
microcode              22894  0
mac_hid                13206  0
dm_crypt               22801  1
hid_generic            12541  0
usbhid                 46983  0
hid                   100136  2 hid_generic,usbhid
ghash_clmulni_intel    13260  0
aesni_intel            55400  5
ablk_helper            13598  1 aesni_intel
cryptd                 20361  4 ghash_clmulni_intel,aesni_intel,ablk_helper
lrw                    13287  1 aesni_intel
aes_x86_64             17256  1 aesni_intel
xts                    12915  1 aesni_intel
gf128mul               14952  2 lrw,xts
wmi                    19071  1 dell_wmi
ahci                   25732  3
libahci                31395  1 ahci
i915                  571649  3
drm_kms_helper         46589  1 i915
drm                   280738  4 i915,drm_kms_helper
i2c_algo_bit           13414  1 i915
sdhci_pci              18621  0
video                  19098  1 i915
sdhci                  32646  1 sdhci_pci
tg3                   149251  0

--
You are receiving this mail because:
You are the assignee for the bug.
