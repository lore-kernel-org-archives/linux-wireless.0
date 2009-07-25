Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:28931 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZGYOLA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 10:11:00 -0400
Received: by fg-out-1718.google.com with SMTP id e12so249057fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 07:10:59 -0700 (PDT)
Subject: [BUG] Current head of wireless testing unusable
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 17:10:54 +0300
Message-Id: <1248531054.15242.16.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I probably should work more to did these bugs out myself, but anyway I
want to let you know what I currently see.

First system oopses just after NM starts up, happens always, and after
planting few test points bug happens somewhere in following lines. 

net/mac80211/mlme.c:ieee80211_mgd_assoc:


> 	list_add(&wk->list, &ifmgd->work_list);
> 
> 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
> 
> 	for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
> 		if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||
> 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP ||
> 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104)
> 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
> 
> 

The oops message


Jul 25 15:53:59 maxim-laptop kernel: [   38.087268] PGD 1002063 PUD 8067 PMD 9067 PTE 0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087282] CPU 0 
Jul 25 15:53:59 maxim-laptop kernel: [   38.087285] Modules linked in: af_packet sco bridge stp llc rfcomm bnep l2cap bluetooth nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc usb_storage usb_libusual cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi_cpufreq coretemp sbp2 joydev uvcvideo iwl3945 videodev v4l1_compat v4l2_compat_ioctl32 iwlcore snd_hda_codec_realtek mac80211 snd_hda_intel snd_hda_codec cfg80211 snd_hwdep acer_wmi backlight psmouse snd_pcm snd_timer tg3 sdhci_pci uhci_hcd ehci_hcd rfkill serio_raw snd_page_alloc libphy sdhci usbcore ohci1394 iTCO_wdt iTCO_vendor_support wmi evdev fuse
Jul 25 15:53:59 maxim-laptop kernel: [   38.087337] Pid: 4061, comm: wpa_supplicant Not tainted 2.6.31-rc4-wl #31 Aspire 5720     
Jul 25 15:53:59 maxim-laptop kernel: [   38.087340] RIP: 0010:[<ffffffffa018cbeb>]  [<ffffffffa018cbeb>] ieee80211_mgd_assoc+0x18b/0x320 [mac80211]
Jul 25 15:53:59 maxim-laptop kernel: [   38.087355] RSP: 0018:ffff88007e4bf7b8  EFLAGS: 00010212
Jul 25 15:53:59 maxim-laptop kernel: [   38.087358] RAX: 00000000fff053ff RBX: ffff88007e6d5600 RCX: 0000000000000000
Jul 25 15:53:59 maxim-laptop kernel: [   38.087361] RDX: 000000000066c1e3 RSI: ffff88007fe6ffd4 RDI: ffffffff8161f870
Jul 25 15:53:59 maxim-laptop kernel: [   38.087364] RBP: ffff88007e4bf7e8 R08: 0000000000000000 R09: 0000000000000001
Jul 25 15:53:59 maxim-laptop kernel: [   38.087366] R10: 000000000000000a R11: 0000000000000000 R12: ffff88007e1d7a60
Jul 25 15:53:59 maxim-laptop kernel: [   38.087369] R13: ffff88007e4bf848 R14: ffff88007e1d7580 R15: ffff88007e1d7a38
Jul 25 15:53:59 maxim-laptop kernel: [   38.087372] FS:  00007f2f97d7e6f0(0000) GS:ffff8800016a3000(0000) knlGS:0000000000000000
Jul 25 15:53:59 maxim-laptop kernel: [   38.087375] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul 25 15:53:59 maxim-laptop kernel: [   38.087378] CR2: ffff88007fe70000 CR3: 000000007f273000 CR4: 00000000000006f0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087381] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul 25 15:53:59 maxim-laptop kernel: [   38.087383] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 25 15:53:59 maxim-laptop kernel: [   38.087387] Process wpa_supplicant (pid: 4061, threadinfo ffff88007e4be000, task ffff8800748f4230)
Jul 25 15:53:59 maxim-laptop kernel: [   38.087391]  ffff88007e99d000 00000000fffffffe ffff88007e1d7590 ffff88007e4bf848
Jul 25 15:53:59 maxim-laptop kernel: [   38.087396] <0> ffff88007e820180 ffff88007e1d7000 ffff88007e4bf7f8 ffffffffa0193363
Jul 25 15:53:59 maxim-laptop kernel: [   38.087400] <0> ffff88007e4bf8d8 ffffffffa014aba8 0000000000000001 0000000000000304
Jul 25 15:53:59 maxim-laptop kernel: [   38.087421]  [<ffffffffa0193363>] ieee80211_assoc+0x13/0x20 [mac80211]
Jul 25 15:53:59 maxim-laptop kernel: [   38.087437]  [<ffffffffa014aba8>] __cfg80211_mlme_assoc+0x1a8/0x1b0 [cfg80211]
Jul 25 15:53:59 maxim-laptop kernel: [   38.087449]  [<ffffffffa014ac3a>] cfg80211_mlme_assoc+0x8a/0xb0 [cfg80211]
Jul 25 15:53:59 maxim-laptop kernel: [   38.087461]  [<ffffffffa013b3e9>] ? cfg80211_get_dev_from_ifindex+0x79/0x90 [cfg80211]
Jul 25 15:53:59 maxim-laptop kernel: [   38.087474]  [<ffffffffa0143661>] nl80211_associate+0x221/0x230 [cfg80211]
Jul 25 15:53:59 maxim-laptop kernel: [   38.087481]  [<ffffffff81340b06>] genl_rcv_msg+0x1b6/0x1f0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087485]  [<ffffffff81340950>] ? genl_rcv_msg+0x0/0x1f0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087489]  [<ffffffff813408e9>] netlink_rcv_skb+0x89/0xb0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087493]  [<ffffffff81340937>] genl_rcv+0x27/0x40
Jul 25 15:53:59 maxim-laptop kernel: [   38.087496]  [<ffffffff81340449>] ? netlink_sendmsg+0x159/0x300
Jul 25 15:53:59 maxim-laptop kernel: [   38.087500]  [<ffffffff813402da>] netlink_unicast+0x2da/0x2f0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087505]  [<ffffffff8131fefe>] ? __alloc_skb+0x6e/0x170
Jul 25 15:53:59 maxim-laptop kernel: [   38.087509]  [<ffffffff813404ee>] netlink_sendmsg+0x1fe/0x300
Jul 25 15:53:59 maxim-laptop kernel: [   38.087515]  [<ffffffff810ac158>] ? generic_file_buffered_write+0x128/0x340
Jul 25 15:53:59 maxim-laptop kernel: [   38.087519]  [<ffffffff8134024e>] ? netlink_unicast+0x24e/0x2f0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087524]  [<ffffffff81316ed7>] sock_sendmsg+0x127/0x140
Jul 25 15:53:59 maxim-laptop kernel: [   38.087529]  [<ffffffff81063ee0>] ? autoremove_wake_function+0x0/0x40
Jul 25 15:53:59 maxim-laptop kernel: [   38.087534]  [<ffffffff8132902d>] ? netdev_run_todo+0x4d/0x240
Jul 25 15:53:59 maxim-laptop kernel: [   38.087538]  [<ffffffff81334359>] ? rtnl_unlock+0x9/0x10
Jul 25 15:53:59 maxim-laptop kernel: [   38.087543]  [<ffffffff813a009e>] ? wext_ioctl_dispatch+0xbe/0x200
Jul 25 15:53:59 maxim-laptop kernel: [   38.087547]  [<ffffffff8139fe40>] ? ioctl_standard_call+0x0/0xe0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087552]  [<ffffffff810ad382>] ? generic_file_aio_write+0x72/0xd0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087556]  [<ffffffff81315b1b>] ? move_addr_to_kernel+0x2b/0x40
Jul 25 15:53:59 maxim-laptop kernel: [   38.087559]  [<ffffffff8132151c>] ? verify_iovec+0x3c/0xd0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087563]  [<ffffffff81317079>] sys_sendmsg+0x189/0x320
Jul 25 15:53:59 maxim-laptop kernel: [   38.087567]  [<ffffffff81063ee0>] ? autoremove_wake_function+0x0/0x40
Jul 25 15:53:59 maxim-laptop kernel: [   38.087572]  [<ffffffff810f05d1>] ? vfs_ioctl+0x31/0xa0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087576]  [<ffffffff810f0acb>] ? do_vfs_ioctl+0x3fb/0x580
Jul 25 15:53:59 maxim-laptop kernel: [   38.087581]  [<ffffffff810e194f>] ? vfs_write+0x13f/0x1a0
Jul 25 15:53:59 maxim-laptop kernel: [   38.087587]  [<ffffffff8100beeb>] system_call_fastpath+0x16/0x1b
Jul 25 15:53:59 maxim-laptop kernel: [   38.087645]  RSP <ffff88007e4bf7b8>
Jul 25 15:53:59 maxim-laptop kernel: [   38.087650] ---[ end trace f5ad5d447afd4b36 ]---



As a first aid I noticed that if I kill wpa_supplicant (I have modified
dbus settings not to start it automatically)

And start it manually (wpa_supplicant -u) NM will talk to it and
connect.

Then many more surprises:


maxim@maxim-laptop:~$ iwconfig 
lo        no wireless extensions.

eth0      no wireless extensions.

wlan0     IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated   
          Tx-Power=15 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          
pan0      no wireless extensions.


NM doesn't even show that it is connected.

I use nl80211 in wpa_supplicant btw.

On top of that wireless disconnects and reconnects every few minutes
with that in dmesg:



[ 4252.387686] wlan0: associate with AP 00:1b:9e:d8:77:02 (try 1)
[ 4252.391177] wlan0: RX AssocResp from 00:1b:9e:d8:77:02 (capab=0x411 status=0 aid=3)
[ 4252.391182] wlan0: associated
[ 4255.240133] No probe response from AP 00:1b:9e:d8:77:02 after 200ms, disconnecting.
[ 4257.391739] wlan0: direct probe to AP 00:1b:9e:d8:77:02 (try 1)
[ 4257.590128] wlan0: direct probe to AP 00:1b:9e:d8:77:02 (try 2)
[ 4257.790101] wlan0: direct probe to AP 00:1b:9e:d8:77:02 (try 3)
[ 4257.990064] wlan0: direct probe to AP 00:1b:9e:d8:77:02 timed out
[ 4264.031984] wlan0: direct probe to AP 00:1b:9e:d8:77:02 (try 1)
[ 4264.230112] wlan0: direct probe to AP 00:1b:9e:d8:77:02 (try 2)
[ 4264.440100] wlan0: direct probe to AP 00:1b:9e:d8:77:02 (try 3)
[ 4264.640098] wlan0: direct probe to AP 00:1b:9e:d8:77:02 timed out
[ 4270.662053] wlan0: direct probe to AP 00:1b:9e:d8:77:02 (try 1)
[ 4270.665611] wlan0 direct probe responded
[ 4270.665617] wlan0: authenticate with AP 00:1b:9e:d8:77:02 (try 1)
[ 4270.667542] wlan0: authenticated


And this despite me sitting next to my AP.

I have iwl3945, latest wireless testing (pulled a hour ago)

I didn't update anything in more that two months, now I have updated the kernel and wpa_supplicant
(I did wpa_supplicant update first, and it seems not to affect anything, and besides older kernel works just fine)

Best regards,
	Maxim Levitsky

