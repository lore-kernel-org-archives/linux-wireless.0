Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42226 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2ESTcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 15:32:01 -0400
Received: by yhmm54 with SMTP id m54so3703688yhm.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 May 2012 12:32:00 -0700 (PDT)
Message-ID: <4FB7F52D.7020904@opensuse.org> (sfid-20120519_213238_318198_3A8454AE)
Date: Sat, 19 May 2012 15:31:57 -0400
From: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwlwifi: Driver unmaps unmatched page at PFN ffe70000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On resume, I get the following warning

[43265.744510] ------------[ cut here ]------------
[43265.744516] WARNING: at 
/usr/src/linux-3.4.0-rc7-2/drivers/iommu/intel-iommu.c:2922 
intel_unmap_page+0x15d/0x1c0()
[43265.744518] Hardware name: Dell System XPS 15Z
[43265.744519] Driver unmaps unmatched page at PFN ffe70000
[43265.744520] Modules linked in: fuse rfcomm af_packet bnep arc4 
iwlwifi btusb bluetooth mac80211 snd_hda_codec_hdmi 
snd_hda_codec_realtek dell_laptop dcdbas kvm_intel snd_hda_intel 
snd_hda_codec kvm cfg80211 snd_hwdep uvcvideo snd_pcm snd_timer 
videobuf2_core snd videodev sr_mod mei(C) edd sg cdrom soundcore 
videobuf2_vmalloc coretemp rfkill dell_wmi iTCO_wdt i2c_i801 
videobuf2_memops microcode snd_page_alloc sparse_keymap battery pcspkr 
ac iTCO_vendor_support autofs4 sha256_generic dm_crypt dm_mod linear 
btrfs zlib_deflate libcrc32c nouveau ttm mxm_wmi ghash_clmulni_intel 
crc32c_intel i915 wmi drm_kms_helper drm i2c_algo_bit xhci_hcd button 
video aesni_intel cryptd aes_x86_64 fan thermal processor thermal_sys
[43265.744560] Pid: 2378, comm: NetworkManager Tainted: G         C 
3.4.0-rc7-2-desktop-test #1
[43265.744562] Call Trace:
[43265.744571]  [<ffffffff81004648>] dump_trace+0x88/0x300
[43265.744575]  [<ffffffff8158043b>] dump_stack+0x69/0x6f
[43265.744579]  [<ffffffff8103fdc9>] warn_slowpath_common+0x79/0xc0
[43265.744582]  [<ffffffff8103fec5>] warn_slowpath_fmt+0x45/0x50
[43265.744585]  [<ffffffff8147921d>] intel_unmap_page+0x15d/0x1c0
[43265.744596]  [<ffffffffa06bd2f4>] 
iwl_trans_rxq_free_rx_bufs+0x44/0xf0 [iwlwifi]
[43265.744629]  [<ffffffffa06bf258>] 
iwl_trans_pcie_start_fw+0x158/0x1020 [iwlwifi]
[43265.744652]  [<ffffffffa06a5813>] 
iwl_load_ucode_wait_alive+0x83/0x360 [iwlwifi]
[43265.744662]  [<ffffffffa06a3dca>] iwlagn_mac_start+0x13a/0x240 [iwlwifi]
[43265.744676]  [<ffffffffa05b6dbd>] ieee80211_do_open+0x24d/0xc40 
[mac80211]
[43265.744690]  [<ffffffff81497226>] __dev_open+0x96/0xf0
[43265.744694]  [<ffffffff814974ba>] __dev_change_flags+0x9a/0x180
[43265.744697]  [<ffffffff81497650>] dev_change_flags+0x20/0x70
[43265.744700]  [<ffffffff814a2c79>] do_setlink+0x319/0x990
[43265.744704]  [<ffffffff814a3386>] rtnl_setlink+0x96/0xf0
[43265.744706]  [<ffffffff814a456c>] rtnetlink_rcv_msg+0x10c/0x310
[43265.744709]  [<ffffffff814bdd19>] netlink_rcv_skb+0xa9/0xc0
[43265.744712]  [<ffffffff814a2218>] rtnetlink_rcv+0x18/0x20
[43265.744715]  [<ffffffff814bd6a0>] netlink_unicast+0x1a0/0x1f0
[43265.744719]  [<ffffffff814bd9cf>] netlink_sendmsg+0x2df/0x360
[43265.744723]  [<ffffffff8147ded6>] sock_sendmsg+0x106/0x150
[43265.744726]  [<ffffffff8147f70e>] __sys_sendmsg+0x37e/0x390
[43265.744729]  [<ffffffff814815a4>] sys_sendmsg+0x44/0x80
[43265.744732]  [<ffffffff8159313d>] system_call_fastpath+0x1a/0x1f
[43265.744737]  [<00007f8bb51e97cd>] 0x7f8bb51e97cc
[43265.744739] ---[ end trace a3c6e6a98003726c ]---

Will be cool if someone can take a look at this ;)

(plz cc me your replies)

