Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37704 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab2EHTnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 15:43:14 -0400
Received: by werb10 with SMTP id b10so2227725wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 12:43:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH5vBdKNZKBSnUu87X-bCxumjeqbx5Dp8QZa5-K08BhXmOdDkA@mail.gmail.com>
References: <CAH5vBdJaMuYE9N4_LOTW+h3ZV-k_fLbs1KTVzZ74C4WCnoS8tw@mail.gmail.com>
 <CAH5vBdL5AY6V8tHBkBc7z8zvUy-_hs7Okk5W6V3Re6=MWO6wJA@mail.gmail.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD0DD4BC@ORSMSX103.amr.corp.intel.com>
 <CAH5vBdK11qrU4ZhOGt5EBVg7x9HWZhDoq9kY5J1GO3AHS8Exsg@mail.gmail.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD0DEC3D@ORSMSX103.amr.corp.intel.com>
 <CAH5vBdJuJ35aGcZdUD3UAb0WagfsYmBMu_nYrXTR1s1ipPuRfw@mail.gmail.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD0DEE35@ORSMSX103.amr.corp.intel.com>
 <CAH5vBdJcA7-TJgKpmLB=ZA75aqMyPcAyySfW2ebMtjzc0PoZ9w@mail.gmail.com>
 <CAH5vBdJY7Bjxuk0Eqr49L8ODrn-pHFyEYmzJNdE04KcuyDnTkQ@mail.gmail.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD136523@ORSMSX103.amr.corp.intel.com> <CAH5vBdKNZKBSnUu87X-bCxumjeqbx5Dp8QZa5-K08BhXmOdDkA@mail.gmail.com>
From: r ll <crquan@gmail.com>
Date: Tue, 8 May 2012 12:42:52 -0700
Message-ID: <CAH5vBdJuiCc92T-Z3qnu7ZZss16udQd3HB_qT5N2=cGnJHbjuQ@mail.gmail.com> (sfid-20120508_214318_423193_05D07BC3)
Subject: Re: iwlwifi driver's problem (wifi link roaming unstable)
To: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with 3.4.0-rc6 kernel now iwlwifi network drops every a couple of
minutes, at some locations:
(working well at other locations)

In dmesg: it has hundreds lines of this "GF was set with SGI:SISO",
what are these?

[91283.358048] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.370599] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.370614] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.385587] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.395188] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.408905] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.419926] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.419943] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.444590] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.444611] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.454463] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[91283.468404] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
[...]


Saw an Oops in cfg80211:

[91816.112759] ------------[ cut here ]------------
[91816.112787] WARNING: at net/wireless/mlme.c:490
cfg80211_mlme_disassoc+0x16f/0x180 [cfg80211]()
[91816.112793] Hardware name: 2522BF3
[91816.112795] Modules linked in: tun ipv6 aes_generic fuse
snd_hda_codec_hdmi snd_hda_codec_conexant arc4 pcspkr sr_mod cdrom
uvcvideo iwlwifi videobuf2_vmalloc videobuf2_memops videobuf2_core
videodev mac80211 nouveau snd_hda_intel snd_hda_codec cfbfillrect
cfg80211 cfbimgblt snd_hwdep cfbcopyarea drm_kms_helper snd_pcm ttm
snd_page_alloc drm intel_agp snd_timer e1000e intel_gtt agpgart
mxm_wmi thinkpad_acpi snd soundcore led_class rfkill wmi
[91816.112860] Pid: 2041, comm: wpa_supplicant Not tainted 3.4.0-rc6 #4
[91816.112864] Call Trace:
[91816.112874]  [<ffffffff81037a4f>] warn_slowpath_common+0x7f/0xc0
[91816.112881]  [<ffffffff81037aaa>] warn_slowpath_null+0x1a/0x20
[91816.112895]  [<ffffffffa0186cbf>]
cfg80211_mlme_disassoc+0x16f/0x180 [cfg80211]
[91816.112908]  [<ffffffffa0176f7f>] ?
get_rdev_dev_by_ifindex+0x4f/0xa0 [cfg80211]
[91816.112922]  [<ffffffffa0177613>] nl80211_disassociate+0xb3/0xf0 [cfg80211]
[91816.112933]  [<ffffffff8143cf60>] genl_rcv_msg+0x250/0x2d0
[91816.112939]  [<ffffffff8143cd10>] ? genl_rcv+0x40/0x40
[91816.112945]  [<ffffffff8143c881>] netlink_rcv_skb+0xa1/0xb0
[91816.112951]  [<ffffffff8143ccf5>] genl_rcv+0x25/0x40
[91816.112957]  [<ffffffff8143c25d>] netlink_unicast+0x19d/0x1f0
[91816.112963]  [<ffffffff8143c585>] netlink_sendmsg+0x2d5/0x340
[91816.112970]  [<ffffffff814099f0>] ? sock_update_classid+0xa0/0x110
[91816.112975]  [<ffffffff81404ec0>] sock_sendmsg+0xf0/0x130
[91816.112981]  [<ffffffff8106cb85>] ? sched_clock_cpu+0xc5/0x120
[91816.112988]  [<ffffffff8108a5de>] ? __lock_acquire.isra.30+0x29e/0xa00
[91816.112993]  [<ffffffff8106cb85>] ? sched_clock_cpu+0xc5/0x120
[91816.113001]  [<ffffffff8114935b>] ? core_sys_select+0x3b/0x390
[91816.113006]  [<ffffffff814061a0>] ? move_addr_to_kernel+0x40/0x60
[91816.113013]  [<ffffffff81411cf6>] ? verify_iovec+0x56/0xd0
[91816.113018]  [<ffffffff8140536e>] __sys_sendmsg+0x40e/0x420
[91816.113024]  [<ffffffff8114935b>] ? core_sys_select+0x3b/0x390
[91816.113031]  [<ffffffff81152de0>] ? replace_mount_options+0x40/0x40
[91816.113037]  [<ffffffff8108873f>] ? lock_release_holdtime.part.22+0xf/0x160
[91816.113045]  [<ffffffff8107f1c0>] ? ktime_get_ts+0xb0/0xf0
[91816.113051]  [<ffffffff81148933>] ? poll_select_copy_remaining+0xf3/0x140
[91816.113057]  [<ffffffff81406e69>] sys_sendmsg+0x49/0x90
[91816.113066]  [<ffffffff814ff412>] system_call_fastpath+0x16/0x1b
[91816.113070] ---[ end trace 58ac3f715de91989 ]---


Saw these after every wifi drops:

[92888.292163] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[92888.292172] iwlwifi 0000:03:00.0: Current SW read_ptr 150 write_ptr 157
[92888.292230] iwlwifi 0000:03:00.0: Current HW read_ptr 150 write_ptr 157
[92888.292235] iwlwifi 0000:03:00.0: On demand firmware reload
[92888.292804] ieee80211 phy0: Hardware restart was requested
[92888.292977] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[92888.293225] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[92933.761591] wlan0: deauthenticating from 6c:9c:ed:eb:7d:bf by local
choice (reason=3)


And NetworkManager could detect that and recover:


[92953.279495] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[92953.299388] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[93175.940227] iwlwifi 0000:03:00.0: Queue 2 stuck for 2000 ms.
[93175.940239] iwlwifi 0000:03:00.0: Current SW read_ptr 251 write_ptr 0
[93175.940298] iwlwifi 0000:03:00.0: Current HW read_ptr 251 write_ptr 0
[93175.940303] iwlwifi 0000:03:00.0: On demand firmware reload
[93175.940834] ieee80211 phy0: Hardware restart was requested
[93175.940989] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[93175.941189] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[93262.303580] wlan0: deauthenticating from 24:b6:57:34:69:ff by local
choice (reason=3)
[93265.076969] wlan0: authenticate with 6c:9c:ed:eb:7d:bf
[93265.112132] wlan0: direct probe to 6c:9c:ed:eb:7d:bf (try 1/3)
[93265.312137] wlan0: direct probe to 6c:9c:ed:eb:7d:bf (try 2/3)
[93265.512863] wlan0: direct probe to 6c:9c:ed:eb:7d:bf (try 3/3)
[93265.713442] wlan0: authentication with 6c:9c:ed:eb:7d:bf timed out
[93265.724161] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active
station id 0 addr 6c:9c:ed:eb:7d:bf
[93273.620809] wlan0: authenticate with 24:b6:57:34:69:ff
[93273.658688] wlan0: send auth to 24:b6:57:34:69:ff (try 1/3)
[93273.662115] wlan0: authenticated
[93273.662917] wlan0: associate with 24:b6:57:34:69:ff (try 1/3)
[93273.730204] wlan0: RX AssocResp from 24:b6:57:34:69:ff (capab=0x11
status=0 aid=17)
[93273.730211] wlan0: associated
[93273.736656] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[93273.814120] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
