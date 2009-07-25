Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:17957 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZGYVmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 17:42:14 -0400
Received: by fg-out-1718.google.com with SMTP id e21so626813fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 14:42:13 -0700 (PDT)
Subject: Re: [PATCH] mac80211: fix receiving deauth
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1248515916.19945.1.camel@johannes.local>
References: <1248515916.19945.1.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 00:42:05 +0300
Message-Id: <1248558125.4753.3.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-07-25 at 11:58 +0200, Johannes Berg wrote:
> Marcel reported a warning, which quite obviously comes
> from an oversight in the code handling deauth frames,
> and which resulted in multiple follow-up warnings due
> to this missing handling. This patch adds the missing
> deauth handling (telling cfg80211 about it) and also
> removes the follow-up warnings since they could happen
> due to races even if nothing is wrong. I've explained
> the races in the comments.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Reported-by: Marcel Holtmann <marcel@holtmann.org>
> ---
>  net/mac80211/mlme.c |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> --- wireless-testing.orig/net/mac80211/mlme.c	2009-07-25 11:03:12.000000000 +0200
> +++ wireless-testing/net/mac80211/mlme.c	2009-07-25 11:55:35.000000000 +0200
> @@ -2003,6 +2003,9 @@ static void ieee80211_sta_rx_queued_mgmt
>  	case RX_MGMT_CFG80211_ASSOC:
>  		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, skb->len);
>  		break;
> +	case RX_MGMT_CFG80211_DEAUTH:
> +		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len, NULL);
> +		break;
>  	default:
>  		WARN(1, "unexpected: %d", rma);
>  	}
> @@ -2498,8 +2501,13 @@ int ieee80211_mgd_deauth(struct ieee8021
>  		}
>  	}
>  
> -	/* cfg80211 should catch this... */
> -	if (WARN_ON(!bssid)) {
> +	/*
> +	 * cfg80211 should catch this ... but it's racy since
> +	 * we can receive a deauth frame, process it, hand it
> +	 * to cfg80211 while that's in a locked section already
> +	 * trying to tell us that the user wants to disconnect.
> +	 */
> +	if (!bssid) {
>  		mutex_unlock(&ifmgd->mtx);
>  		return -ENOLINK;
>  	}
> @@ -2524,8 +2532,13 @@ int ieee80211_mgd_disassoc(struct ieee80
>  
>  	mutex_lock(&ifmgd->mtx);
>  
> -	/* cfg80211 should catch that */
> -	if (WARN_ON(&ifmgd->associated->cbss != req->bss)) {
> +	/*
> +	 * cfg80211 should catch this ... but it's racy since
> +	 * we can receive a disassoc frame, process it, hand it
> +	 * to cfg80211 while that's in a locked section already
> +	 * trying to tell us that the user wants to disconnect.
> +	 */
> +	if (&ifmgd->associated->cbss != req->bss) {
>  		mutex_unlock(&ifmgd->mtx);
>  		return -ENOLINK;
>  	}


Don't know if related, but I see this on latest wireless testing with 2
patches applied:

[PATCH]_nl80211:_add_missing_parameter_clearing
[PATCH]_mac80211:_fix_an_oops_in_ieee80211_scan_state_set_channel


<1>[  315.219232] BUG: unable to handle kernel NULL pointer dereference a 0000000000000048
<1>[  315.219242] IP: [<ffffffffa0a467c8>] cfg80211_mlme_disassoc+0x98/0x110 [cfg80211]
<4>[  315.219271] PGD 7061b067 PUD 7e9c0067 PMD 0 
<0>[  315.219280] Oops: 0000 [#1] PREEMPT SMP 
<0>[  315.219287] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
<4>[  315.219293] CPU 0 
<4>[  315.219297] Modules linked in: af_packet sco bridge stp llc bnep l2cap bluetooth nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc usb_storage usb_libusual cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi_cpufreq coretemp joydev sbp2 snd_hda_codec_realtek iwl3945 iwlcore snd_hda_intel snd_hda_codec uvcvideo mac80211 videodev snd_hwdep psmouse v4l1_compat v4l2_compat_ioctl32 snd_pcm acer_wmi backlight cfg80211 serio_raw snd_timer tg3 iTCO_wdt uhci_hcd rfkill nvidia(P) ohci1394 snd_page_alloc ehci_hcd sdhci_pci sdhci libphy iTCO_vendor_support usbcore wmi evdev fuse
<6>[  315.219383] Pid: 4078, comm: wpa_supplicant Tainted: P           2.6.31-rc4-wl #32 Aspire 5720     
<6>[  315.219388] RIP: 0010:[<ffffffffa0a467c8>]  [<ffffffffa0a467c8>] cfg80211_mlme_disassoc+0x98/0x110 [cfg80211]
<6>[  315.219411] RSP: 0018:ffff880070611988  EFLAGS: 00010296
<6>[  315.219415] RAX: 0000000000000000 RBX: 00000000ffffff95 RCX: 0000000000000006
<6>[  315.219420] RDX: ffff880067e61828 RSI: 0000000000000048 RDI: ffff880067e61828
<6>[  315.219425] RBP: ffff8800706119f8 R08: ffff8800706119a8 R09: 0000000000000000
<6>[  315.219430] R10: ffff88007f8df000 R11: 0000000000000000 R12: ffff88007f8df590
<6>[  315.219435] R13: ffff88007f8df000 R14: 0000000000000000 R15: 0000000000000000
<6>[  315.219441] FS:  00007fd2a264f6f0(0000) GS:ffff8800016a3000(0000) knlGS:0000000000000000
<6>[  315.219446] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<6>[  315.219450] CR2: 0000000000000048 CR3: 00000000704e1000 CR4: 00000000000006f0
<6>[  315.219455] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<6>[  315.219460] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[  315.219465] Process wpa_supplicant (pid: 4078, threadinfo ffff880070610000, task ffff88007056c230)
<0>[  315.219469] Stack:
<4>[  315.219472]  ffff8800706119a8 ffff880067e61828 ffff88007f330000 ffff88007f8df5b8
<4>[  315.219480] <0> 0000000000000000 0000000000000000 0000000000000000 0000000000000003
<4>[  315.219489] <0> ffff8800706119f8 00000000ffffffea ffff880070611a58 ffff880067e61800
<0>[  315.219499] Call Trace:
<4>[  315.219522]  [<ffffffffa0a3f287>] nl80211_disassociate+0x127/0x140 [cfg80211]
<4>[  315.219533]  [<ffffffff81340b06>] genl_rcv_msg+0x1b6/0x1f0
<4>[  315.219541]  [<ffffffff81340950>] ? genl_rcv_msg+0x0/0x1f0
<4>[  315.219547]  [<ffffffff813408e9>] netlink_rcv_skb+0x89/0xb0
<4>[  315.219553]  [<ffffffff81340937>] genl_rcv+0x27/0x40
<4>[  315.219559]  [<ffffffff81340449>] ? netlink_sendmsg+0x159/0x300
<4>[  315.219566]  [<ffffffff813402da>] netlink_unicast+0x2da/0x2f0
<4>[  315.219574]  [<ffffffff8131fefe>] ? __alloc_skb+0x6e/0x170
<4>[  315.219581]  [<ffffffff813404ee>] netlink_sendmsg+0x1fe/0x300
<4>[  315.219591]  [<ffffffff810ac158>] ? generic_file_buffered_write+0x128/0x340
<4>[  315.219600]  [<ffffffff81316ed7>] sock_sendmsg+0x127/0x140
<4>[  315.219608]  [<ffffffff81063ee0>] ? autoremove_wake_function+0x0/0x40
<4>[  315.219616]  [<ffffffff810ad382>] ? generic_file_aio_write+0x72/0xd0
<4>[  315.219623]  [<ffffffff81315b1b>] ? move_addr_to_kernel+0x2b/0x40
<4>[  315.219629]  [<ffffffff8132151c>] ? verify_iovec+0x3c/0xd0
<4>[  315.219636]  [<ffffffff81317079>] sys_sendmsg+0x189/0x320
<4>[  315.219643]  [<ffffffff81063ee0>] ? autoremove_wake_function+0x0/0x40
<4>[  315.219651]  [<ffffffff810c4d28>] ? handle_mm_fault+0x1d8/0x830
<4>[  315.219660]  [<ffffffff810e194f>] ? vfs_write+0x13f/0x1a0
<4>[  315.219669]  [<ffffffff8100beeb>] system_call_fastpath+0x16/0x1b
<0>[  315.219673] Code: 5d c8 4c 89 75 b8 49 63 c7 b9 06 00 00 00 48 89 45 c0 48 8b 7d 98 4d 8b 8c 24 d8 00 00 00 4c 8d 45 b0 49 8d 71 48 bb 95 ff ff ff <f3> a6 0f 97 c2 0f 92 c0 38 c2 75 2a 48 8b 55 a0 49 8d 41 40 48 
<1>[  315.219743] RIP  [<ffffffffa0a467c8>] cfg80211_mlme_disassoc+0x98/0x110 [cfg80211]
<4>[  315.219764]  RSP <ffff880070611988>
<0>[  315.219767] CR2: 0000000000000048
<4>[  315.219772] ---[ end trace f7733b1bb80b3185 ]---


NM associates, but then if I manually ask  it to associate again, this happens. I use nl80211 in wpa_supplicant


Best regards,
	Maxim Levitsky



