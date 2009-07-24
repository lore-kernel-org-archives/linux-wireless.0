Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39422 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZGXU1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 16:27:51 -0400
Received: from [192.168.1.42] (p5487E45A.dip.t-dialin.net [84.135.228.90])
	by mail.holtmann.org (Postfix) with ESMTP id 7102F8B4DC
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 22:27:49 +0200 (CEST)
Subject: Oopses with wireless-testing from today
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 24 Jul 2009 22:26:59 +0200
Message-Id: <1248467219.28545.153.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

so here are some oopses I have seen while running the latest
wireless-testing tree from today.

Regards

Marcel


[ 2140.094603] ------------[ cut here ]------------
[ 2140.094644] WARNING: at net/mac80211/mlme.c:2007 ieee80211_sta_work+0x4f7/0xe34 [mac80211]()
[ 2140.094651] Hardware name: 7454CTO
[ 2140.094654] unexpected: 3
[ 2140.094658] Modules linked in: iwlagn iwlcore fuse rfcomm bnep sco l2cap cdc_ether usbnet mii cdc_wdm cdc_acm binfmt_misc uinput snd_hda_codec_conexant snd_hda_intel snd_hda_codec uvcvideo snd_pcm videodev snd_timer mac80211 btusb v4l1_compat snd v4l2_compat_ioctl32 bluetooth soundcore cfg80211 snd_page_alloc uhci_hcd ehci_hcd [last unloaded: iwlcore]
[ 2140.094719] Pid: 28084, comm: phy4 Not tainted 2.6.31-rc4-wl #41
[ 2140.094724] Call Trace:
[ 2140.094738]  [<ffffffff8103ad05>] warn_slowpath_common+0x77/0x8f
[ 2140.094747]  [<ffffffff8103ad6a>] warn_slowpath_fmt+0x3c/0x3e
[ 2140.094779]  [<ffffffffa009f9b0>] ? ieee80211_rx_mgmt_deauth+0xa3/0xb0 [mac80211]
[ 2140.094810]  [<ffffffffa00a1f63>] ieee80211_sta_work+0x4f7/0xe34 [mac80211]
[ 2140.094842]  [<ffffffffa00a1a6c>] ? ieee80211_sta_work+0x0/0xe34 [mac80211]
[ 2140.094852]  [<ffffffff81049dc1>] worker_thread+0x147/0x1eb
[ 2140.094860]  [<ffffffff8104d8b9>] ? autoremove_wake_function+0x0/0x34
[ 2140.094869]  [<ffffffff81049c7a>] ? worker_thread+0x0/0x1eb
[ 2140.094876]  [<ffffffff8104d5bb>] kthread+0x85/0x8d
[ 2140.094885]  [<ffffffff8100beca>] child_rip+0xa/0x20
[ 2140.094892]  [<ffffffff8104d536>] ? kthread+0x0/0x8d
[ 2140.094899]  [<ffffffff8100bec0>] ? child_rip+0x0/0x20
[ 2140.094905] ---[ end trace d5f74de670daf4e3 ]---


[ 2332.961400] ------------[ cut here ]------------
[ 2332.961442] WARNING: at net/mac80211/mlme.c:2502 ieee80211_mgd_deauth+0xc7/0x105 [mac80211]()
[ 2332.961448] Hardware name: 7454CTO
[ 2332.961451] Modules linked in: iwlagn iwlcore fuse rfcomm bnep sco l2cap cdc_ether usbnet mii cdc_wdm cdc_acm binfmt_misc uinput snd_hda_codec_conexant snd_hda_intel snd_hda_codec uvcvideo snd_pcm videodev snd_timer mac80211 btusb v4l1_compat snd v4l2_compat_ioctl32 bluetooth soundcore cfg80211 snd_page_alloc uhci_hcd ehci_hcd [last unloaded: iwlcore]
[ 2332.961512] Pid: 28271, comm: wpa_supplicant Tainted: G        W  2.6.31-rc4-wl #41
[ 2332.961518] Call Trace:
[ 2332.961532]  [<ffffffff8103ad05>] warn_slowpath_common+0x77/0x8f
[ 2332.961540]  [<ffffffff8103ad2c>] warn_slowpath_null+0xf/0x11
[ 2332.961571]  [<ffffffffa009fa84>] ieee80211_mgd_deauth+0xc7/0x105 [mac80211]
[ 2332.961603]  [<ffffffffa00a5344>] ieee80211_deauth+0x19/0x1b [mac80211]
[ 2332.961633]  [<ffffffffa0038a70>] __cfg80211_mlme_deauth+0x12b/0x13a [cfg80211]
[ 2332.961660]  [<ffffffffa003b936>] __cfg80211_disconnect+0xd9/0x145 [cfg80211]
[ 2332.961685]  [<ffffffffa003dce6>] cfg80211_mgd_wext_siwap+0x129/0x1ce [cfg80211]
[ 2332.961714]  [<ffffffffa009927a>] ieee80211_ioctl_siwap+0x23/0x37 [mac80211]
[ 2332.961724]  [<ffffffff8133a6f1>] ioctl_standard_call+0x53/0xa7
[ 2332.961735]  [<ffffffff812ac302>] ? __dev_get_by_name+0x85/0x9c
[ 2332.961743]  [<ffffffff8133a69e>] ? ioctl_standard_call+0x0/0xa7
[ 2332.961751]  [<ffffffff81339be3>] ? ioctl_private_call+0x0/0x77
[ 2332.961758]  [<ffffffff81339d41>] wext_ioctl_dispatch+0xdc/0x154
[ 2332.961766]  [<ffffffff81339e9f>] wext_handle_ioctl+0x39/0x70
[ 2332.961775]  [<ffffffff812b05b5>] dev_ioctl+0x614/0x63d
[ 2332.961785]  [<ffffffff81120df7>] ? avc_has_perm+0x57/0x6c
[ 2332.961795]  [<ffffffff8107ecd3>] ? unlock_page+0x22/0x26
[ 2332.961804]  [<ffffffff8129f878>] sock_ioctl+0x204/0x20f
[ 2332.961813]  [<ffffffff810b1b8d>] vfs_ioctl+0x1d/0x82
[ 2332.961822]  [<ffffffff811b74a3>] ? tty_ldisc_deref+0x6f/0x74
[ 2332.961830]  [<ffffffff81121b65>] ? file_has_perm+0x7e/0x89
[ 2332.961838]  [<ffffffff810b20a1>] do_vfs_ioctl+0x438/0x47e
[ 2332.961846]  [<ffffffff810b2138>] sys_ioctl+0x51/0x74
[ 2332.961855]  [<ffffffff8100ae6b>] system_call_fastpath+0x16/0x1b
[ 2332.961861] ---[ end trace d5f74de670daf4e4 ]---


[ 2332.961986] ------------[ cut here ]------------
[ 2332.962020] WARNING: at net/mac80211/mlme.c:2502 ieee80211_mgd_deauth+0xc7/0x105 [mac80211]()
[ 2332.962026] Hardware name: 7454CTO
[ 2332.962029] Modules linked in: iwlagn iwlcore fuse rfcomm bnep sco l2cap cdc_ether usbnet mii cdc_wdm cdc_acm binfmt_misc uinput snd_hda_codec_conexant snd_hda_intel snd_hda_codec uvcvideo snd_pcm videodev snd_timer mac80211 btusb v4l1_compat snd v4l2_compat_ioctl32 bluetooth soundcore cfg80211 snd_page_alloc uhci_hcd ehci_hcd [last unloaded: iwlcore]
[ 2332.962087] Pid: 28271, comm: wpa_supplicant Tainted: G        W  2.6.31-rc4-wl #41
[ 2332.962092] Call Trace:
[ 2332.962101]  [<ffffffff8103ad05>] warn_slowpath_common+0x77/0x8f
[ 2332.962109]  [<ffffffff8103ad2c>] warn_slowpath_null+0xf/0x11
[ 2332.962139]  [<ffffffffa009fa84>] ieee80211_mgd_deauth+0xc7/0x105 [mac80211]
[ 2332.962171]  [<ffffffffa00a5344>] ieee80211_deauth+0x19/0x1b [mac80211]
[ 2332.962198]  [<ffffffffa0038a70>] __cfg80211_mlme_deauth+0x12b/0x13a [cfg80211]
[ 2332.962224]  [<ffffffffa003b936>] __cfg80211_disconnect+0xd9/0x145 [cfg80211]
[ 2332.962249]  [<ffffffffa003de70>] cfg80211_mgd_wext_siwessid+0xe5/0x17c [cfg80211]
[ 2332.962278]  [<ffffffffa009921e>] ieee80211_ioctl_siwessid+0x28/0x2a [mac80211]
[ 2332.962287]  [<ffffffff8133a60b>] ioctl_standard_iw_point+0x18b/0x21e
[ 2332.962315]  [<ffffffffa00991f6>] ? ieee80211_ioctl_siwessid+0x0/0x2a [mac80211]
[ 2332.962324]  [<ffffffff8133a72b>] ioctl_standard_call+0x8d/0xa7
[ 2332.962333]  [<ffffffff812ac302>] ? __dev_get_by_name+0x85/0x9c
[ 2332.962341]  [<ffffffff8133a69e>] ? ioctl_standard_call+0x0/0xa7
[ 2332.962348]  [<ffffffff81339be3>] ? ioctl_private_call+0x0/0x77
[ 2332.962356]  [<ffffffff81339d41>] wext_ioctl_dispatch+0xdc/0x154
[ 2332.962364]  [<ffffffff81339e9f>] wext_handle_ioctl+0x39/0x70
[ 2332.962372]  [<ffffffff812b05b5>] dev_ioctl+0x614/0x63d
[ 2332.962381]  [<ffffffff81120df7>] ? avc_has_perm+0x57/0x6c
[ 2332.962390]  [<ffffffff8129f878>] sock_ioctl+0x204/0x20f
[ 2332.962399]  [<ffffffff8114e029>] ? cpumask_any_but+0x29/0x36
[ 2332.962407]  [<ffffffff810b1b8d>] vfs_ioctl+0x1d/0x82
[ 2332.962415]  [<ffffffff81121b65>] ? file_has_perm+0x7e/0x89
[ 2332.962423]  [<ffffffff810b20a1>] do_vfs_ioctl+0x438/0x47e
[ 2332.962431]  [<ffffffff810b2138>] sys_ioctl+0x51/0x74
[ 2332.962440]  [<ffffffff81050c0c>] ? up_write+0x9/0xb
[ 2332.962448]  [<ffffffff8100ae6b>] system_call_fastpath+0x16/0x1b
[ 2332.962454] ---[ end trace d5f74de670daf4e5 ]---


[ 2332.962599] ------------[ cut here ]------------
[ 2332.962633] WARNING: at net/mac80211/mlme.c:2502 ieee80211_mgd_deauth+0xc7/0x105 [mac80211]()
[ 2332.962638] Hardware name: 7454CTO
[ 2332.962642] Modules linked in: iwlagn iwlcore fuse rfcomm bnep sco l2cap cdc_ether usbnet mii cdc_wdm cdc_acm binfmt_misc uinput snd_hda_codec_conexant snd_hda_intel snd_hda_codec uvcvideo snd_pcm videodev snd_timer mac80211 btusb v4l1_compat snd v4l2_compat_ioctl32 bluetooth soundcore cfg80211 snd_page_alloc uhci_hcd ehci_hcd [last unloaded: iwlcore]
[ 2332.962700] Pid: 28271, comm: wpa_supplicant Tainted: G        W  2.6.31-rc4-wl #41
[ 2332.962705] Call Trace:
[ 2332.962716]  [<ffffffff8103ad05>] warn_slowpath_common+0x77/0x8f
[ 2332.962723]  [<ffffffff8103ad2c>] warn_slowpath_null+0xf/0x11
[ 2332.962753]  [<ffffffffa009fa84>] ieee80211_mgd_deauth+0xc7/0x105 [mac80211]
[ 2332.962785]  [<ffffffffa00a5344>] ieee80211_deauth+0x19/0x1b [mac80211]
[ 2332.962813]  [<ffffffffa0038a70>] __cfg80211_mlme_deauth+0x12b/0x13a [cfg80211]
[ 2332.962839]  [<ffffffffa003b936>] __cfg80211_disconnect+0xd9/0x145 [cfg80211]
[ 2332.962861]  [<ffffffffa002b2f6>] cfg80211_netdev_notifier_call+0x1f2/0x2fc [cfg80211]
[ 2332.962873]  [<ffffffff810512c2>] notifier_call_chain+0x32/0x5e
[ 2332.962882]  [<ffffffff8105135e>] raw_notifier_call_chain+0xf/0x11
[ 2332.962891]  [<ffffffff812ae9de>] call_netdevice_notifiers+0x16/0x18
[ 2332.962899]  [<ffffffff812af32f>] dev_close+0x4d/0x84
[ 2332.962907]  [<ffffffff812aed35>] dev_change_flags+0xa8/0x168
[ 2332.962918]  [<ffffffff812ea669>] devinet_ioctl+0x265/0x58b
[ 2332.962927]  [<ffffffff812eb9e8>] inet_ioctl+0x92/0xaa
[ 2332.962934]  [<ffffffff8129f860>] sock_ioctl+0x1ec/0x20f
[ 2332.962942]  [<ffffffff812a0ff1>] ? sys_sendto+0xdb/0x103
[ 2332.962950]  [<ffffffff810b1b8d>] vfs_ioctl+0x1d/0x82
[ 2332.962959]  [<ffffffff811b74a3>] ? tty_ldisc_deref+0x6f/0x74
[ 2332.962968]  [<ffffffff81121b65>] ? file_has_perm+0x7e/0x89
[ 2332.962975]  [<ffffffff810b20a1>] do_vfs_ioctl+0x438/0x47e
[ 2332.962984]  [<ffffffff810b2138>] sys_ioctl+0x51/0x74
[ 2332.962991]  [<ffffffff8100ae6b>] system_call_fastpath+0x16/0x1b
[ 2332.962997] ---[ end trace d5f74de670daf4e6 ]---


[ 2332.963008] ------------[ cut here ]------------
[ 2332.963037] WARNING: at net/mac80211/mlme.c:2502 ieee80211_mgd_deauth+0xc7/0x105 [mac80211]()
[ 2332.963043] Hardware name: 7454CTO
[ 2332.963046] Modules linked in: iwlagn iwlcore fuse rfcomm bnep sco l2cap cdc_ether usbnet mii cdc_wdm cdc_acm binfmt_misc uinput snd_hda_codec_conexant snd_hda_intel snd_hda_codec uvcvideo snd_pcm videodev snd_timer mac80211 btusb v4l1_compat snd v4l2_compat_ioctl32 bluetooth soundcore cfg80211 snd_page_alloc uhci_hcd ehci_hcd [last unloaded: iwlcore]
[ 2332.963102] Pid: 28271, comm: wpa_supplicant Tainted: G        W  2.6.31-rc4-wl #41
[ 2332.963106] Call Trace:
[ 2332.963114]  [<ffffffff8103ad05>] warn_slowpath_common+0x77/0x8f
[ 2332.963122]  [<ffffffff8103ad2c>] warn_slowpath_null+0xf/0x11
[ 2332.963152]  [<ffffffffa009fa84>] ieee80211_mgd_deauth+0xc7/0x105 [mac80211]
[ 2332.963184]  [<ffffffffa00a5344>] ieee80211_deauth+0x19/0x1b [mac80211]
[ 2332.963210]  [<ffffffffa0038875>] cfg80211_mlme_down+0x10d/0x1dd [cfg80211]
[ 2332.963232]  [<ffffffffa002b301>] cfg80211_netdev_notifier_call+0x1fd/0x2fc [cfg80211]
[ 2332.963242]  [<ffffffff810512c2>] notifier_call_chain+0x32/0x5e
[ 2332.963251]  [<ffffffff8105135e>] raw_notifier_call_chain+0xf/0x11
[ 2332.963260]  [<ffffffff812ae9de>] call_netdevice_notifiers+0x16/0x18
[ 2332.963268]  [<ffffffff812af32f>] dev_close+0x4d/0x84
[ 2332.963275]  [<ffffffff812aed35>] dev_change_flags+0xa8/0x168
[ 2332.963284]  [<ffffffff812ea669>] devinet_ioctl+0x265/0x58b
[ 2332.963293]  [<ffffffff812eb9e8>] inet_ioctl+0x92/0xaa
[ 2332.963300]  [<ffffffff8129f860>] sock_ioctl+0x1ec/0x20f
[ 2332.963308]  [<ffffffff812a0ff1>] ? sys_sendto+0xdb/0x103
[ 2332.963315]  [<ffffffff810b1b8d>] vfs_ioctl+0x1d/0x82
[ 2332.963323]  [<ffffffff811b74a3>] ? tty_ldisc_deref+0x6f/0x74
[ 2332.963332]  [<ffffffff81121b65>] ? file_has_perm+0x7e/0x89
[ 2332.963340]  [<ffffffff810b20a1>] do_vfs_ioctl+0x438/0x47e
[ 2332.963348]  [<ffffffff810b2138>] sys_ioctl+0x51/0x74
[ 2332.963355]  [<ffffffff8100ae6b>] system_call_fastpath+0x16/0x1b
[ 2332.963361] ---[ end trace d5f74de670daf4e7 ]---


