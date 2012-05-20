Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:41648 "EHLO kirsi2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab2ETK43 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 May 2012 06:56:29 -0400
Received: from [192.168.1.100] (84.248.88.153) by kirsi2.inet.fi (8.5.140.02)
        id 4FA8B9730021FEF8 for linux-wireless@vger.kernel.org; Sun, 20 May 2012 13:50:02 +0300
Message-ID: <4FB8CC43.9080206@iki.fi> (sfid-20120520_125633_503893_FE00C5DD)
Date: Sun, 20 May 2012 13:49:39 +0300
From: Juho-Mikko Pellinen <juho-mikko.pellinen@iki.fi>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rtlwifi: transmission-gtk
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

After updating and booting to the recent wireless-testing -kernel I got
a bunch of these in my kernel log. This is the first time I see these.
My wireless card is:
Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
802.11b/g/n WiFi Adapter (rev 01)

[kernel] [ 1775.351577] ------------[ cut here ]------------
[kernel] [ 1775.351596] WARNING: at net/ipv4/tcp.c:1335
tcp_cleanup_rbuf+0x4d/0x100()
[kernel] [ 1775.351603] Hardware name: System Product Name
[kernel] [ 1775.351609] cleanup rbuf bug: copied 7BC8EAC6 seq 7BC8EAC6
rcvnxt 7BC8EAC6
[kernel] [ 1775.351613] Modules linked in: fuse xt_LOG pl2303 usbserial
cpufreq_userspace fbcon tileblit font bitblit softcursor radeon ttm
drm_kms_helper drm joydev fb fbdev rtl8192ce i2c_algo_bit pata_via
rtl8192c_common rtlwifi cfbcopyarea cfbimgblt r8169 sp5100_tco mii
firewire_ohci i2c_piix4 firewire_core snd_hda_codec_hdmi cfbfillrect
snd_hda_codec_realtek snd_cmipci xhci_hcd snd_hda_intel mac80211
snd_hda_codec snd_opl3_lib snd_hwdep snd_mpu401_uart asus_atk0110
powernow_k8 snd_pcm cfg80211 snd_timer snd_rawmidi snd_page_alloc
snd_seq_device crc_itu_t rfkill snd
[kernel] [ 1775.351710] Pid: 6218, comm: transmission-gt Not tainted
3.4.0-rc7-wl #9
[kernel] [ 1775.351715] Call Trace:
[kernel] [ 1775.351727]  [<ffffffff8103674b>] ?
warn_slowpath_common+0x7b/0xc0
[kernel] [ 1775.351736]  [<ffffffff81036845>] ? warn_slowpath_fmt+0x45/0x50
[kernel] [ 1775.351747]  [<ffffffff81439dc1>] ?
skb_copy_datagram_iovec+0x51/0x290
[kernel] [ 1775.351756]  [<ffffffff814965ed>] ? tcp_cleanup_rbuf+0x4d/0x100
[kernel] [ 1775.351765]  [<ffffffff81497571>] ? tcp_recvmsg+0x511/0xa40
[kernel] [ 1775.351774]  [<ffffffff814ba85a>] ? inet_recvmsg+0x9a/0xd0
[kernel] [ 1775.351785]  [<ffffffff8142b8ee>] ? sock_aio_read+0x17e/0x190
[kernel] [ 1775.351794]  [<ffffffff8156c582>] ?
_raw_spin_unlock_irq+0x12/0x40
[kernel] [ 1775.351803]  [<ffffffff8142b770>] ? sock_aio_write+0x1a0/0x1a0
[kernel] [ 1775.351812]  [<ffffffff8112fe89>] ?
do_sync_readv_writev+0xa9/0xf0
[kernel] [ 1775.351822]  [<ffffffff81066059>] ? get_parent_ip+0x9/0x20
[kernel] [ 1775.351831]  [<ffffffff811301b6>] ? do_readv_writev+0xe6/0x210
[kernel] [ 1775.351839]  [<ffffffff8142b249>] ? sock_do_ioctl+0x29/0x60
[kernel] [ 1775.351849]  [<ffffffff81140f96>] ? do_vfs_ioctl+0x96/0x4f0
[kernel] [ 1775.351857]  [<ffffffff8125d98b>] ? file_has_perm+0xcb/0xd0
[kernel] [ 1775.351866]  [<ffffffff811303de>] ? sys_readv+0x4e/0xc0
[kernel] [ 1775.351904]  [<ffffffff81573562>] ?
system_call_fastpath+0x16/0x1b
[kernel] [ 1775.351910] ---[ end trace 1e35c980325196a4 ]---
[kernel] [ 1775.463425] ------------[ cut here ]------------
[kernel] [ 1775.463430] WARNING: at net/ipv4/tcp.c:1644
tcp_recvmsg+0x8eb/0xa40()
[kernel] [ 1775.463431] Hardware name: System Product Name
[kernel] [ 1775.463433] recvmsg bug 2: copied 7BC8EB31 seq 7BC8EAC6
rcvnxt 7BC8EB19 fl 0
[kernel] [ 1775.463434] Modules linked in: fuse xt_LOG pl2303 usbserial
cpufreq_userspace fbcon tileblit font bitblit softcursor radeon ttm
drm_kms_helper drm joydev fb fbdev rtl8192ce i2c_algo_bit pata_via
rtl8192c_common rtlwifi cfbcopyarea cfbimgblt r8169 sp5100_tco mii
firewire_ohci i2c_piix4 firewire_core snd_hda_codec_hdmi cfbfillrect
snd_hda_codec_realtek snd_cmipci xhci_hcd snd_hda_intel mac80211
snd_hda_codec snd_opl3_lib snd_hwdep snd_mpu401_uart asus_atk0110
powernow_k8 snd_pcm cfg80211 snd_timer snd_rawmidi snd_page_alloc
snd_seq_device crc_itu_t rfkill snd
[kernel] [ 1775.463460] Pid: 6218, comm: transmission-gt Tainted: G
   W    3.4.0-rc7-wl #9
[kernel] [ 1775.463462] Call Trace:
[kernel] [ 1775.463465]  [<ffffffff8103674b>] ?
warn_slowpath_common+0x7b/0xc0
[kernel] [ 1775.463467]  [<ffffffff81036845>] ? warn_slowpath_fmt+0x45/0x50
[kernel] [ 1775.463470]  [<ffffffff81066059>] ? get_parent_ip+0x9/0x20
[kernel] [ 1775.463472]  [<ffffffff8149794b>] ? tcp_recvmsg+0x8eb/0xa40
[kernel] [ 1775.463475]  [<ffffffff814ba85a>] ? inet_recvmsg+0x9a/0xd0
[kernel] [ 1775.463478]  [<ffffffff8142b8ee>] ? sock_aio_read+0x17e/0x190
[kernel] [ 1775.463481]  [<ffffffff8142b770>] ? sock_aio_write+0x1a0/0x1a0
[kernel] [ 1775.463483]  [<ffffffff8112fe89>] ?
do_sync_readv_writev+0xa9/0xf0
[kernel] [ 1775.463486]  [<ffffffff81066059>] ? get_parent_ip+0x9/0x20
[kernel] [ 1775.463488]  [<ffffffff811301b6>] ? do_readv_writev+0xe6/0x210
[kernel] [ 1775.463490]  [<ffffffff8142b249>] ? sock_do_ioctl+0x29/0x60
[kernel] [ 1775.463492]  [<ffffffff81140f96>] ? do_vfs_ioctl+0x96/0x4f0
[kernel] [ 1775.463495]  [<ffffffff8125d98b>] ? file_has_perm+0xcb/0xd0
[kernel] [ 1775.463497]  [<ffffffff811303de>] ? sys_readv+0x4e/0xc0
[kernel] [ 1775.463500]  [<ffffffff81573562>] ?
system_call_fastpath+0x16/0x1b
[kernel] [ 1775.463501] ---[ end trace 1e35c980325196a5 ]---


