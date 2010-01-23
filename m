Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frogstar.hit.bme.hu ([152.66.248.44]:36852 "EHLO
	frogstar.hit.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0AWJLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 04:11:14 -0500
Received: from kutfo.hit.bme.hu (kutfo.hit.bme.hu [152.66.248.132])
	by frogstar.hit.bme.hu (8.14.3/8.14.3) with ESMTP id o0N8kWCp017319
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 09:46:33 +0100
Received: from kecsa (helo=localhost)
	by kutfo.hit.bme.hu with local-esmtp (Exim 4.69)
	(envelope-from <kecsa@kutfo.hit.bme.hu>)
	id 1NYbdU-0004C1-Cu
	for linux-wireless@vger.kernel.org; Sat, 23 Jan 2010 09:46:28 +0100
Date: Sat, 23 Jan 2010 09:46:28 +0100 (CET)
From: kecsa@kutfo.hit.bme.hu
To: linux-wireless@vger.kernel.org
Subject: hwtkip hangs on b43
Message-ID: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

when I load b43 with hwtkip=1 system hangs after
' b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac:...'
throwing the below BUG.

This is a non-SMP non-preemtive kernel.  It looks like we are entering
b43_op_update_tkip_key() already holding the wl->mutex. We lock mutex in
b43_interrupt_thread_handler().

This problem is present in stable and also in compat-wireless-2010-01-22
shapshot if I haven't missed something. As a quick and dirty fix I have
removed wl->mutex lock/unlock from b43_op_update_tkip_key(). Box survived
one day (until now) and a ~3GB file transfer over WLAN using hwtkip in
this way.

Jan 22 23:00:29 localhost kernel: [  865.743138] b43-phy0 debug: Using
hardware based encryption for keyidx: 0, mac: ....
Jan 22 23:00:29 localhost kernel: [  865.751462] BUG: scheduling while
atomic: irq/10-b43/1914/0x00000100
Jan 22 23:00:29 localhost kernel: [  865.751646] Modules linked in: b43
ssb mac80211 cfg80211 rfkill snd_via82xx snd_ac97_codec ac97_bus
snd_mpu401_uart snd_seq_midi pcmcia snd_rawmidi 8139too pcmcia_core
firmware_class 8139cp [last unloaded: compat_firmware_class]
Jan 22 23:00:29 localhost kernel: [  865.752866] Pid: 1914, comm:
irq/10-b43 Not tainted 2.6.32.3 #7
Jan 22 23:00:29 localhost kernel: [  865.753014] Call Trace:
Jan 22 23:00:29 localhost kernel: [  865.753191]  [<c13583ee>] ?
schedule+0x3e/0x420
Jan 22 23:00:29 localhost kernel: [  865.753374]  [<c101c41d>] ?
enqueue_entity+0x7d/0x2d0
Jan 22 23:00:29 localhost kernel: [  865.753543]  [<c1358d36>] ?
__mutex_lock_common+0x76/0xc0
Jan 22 23:00:29 localhost kernel: [  865.753823]  [<c4ae1904>] ?
rx_tkip_phase1_write+0x74/0x100 [b43]
Jan 22 23:00:29 localhost kernel: [  865.753998]  [<c1358d8f>] ?
__mutex_lock_slowpath+0xf/0x20
Jan 22 23:00:29 localhost kernel: [  865.754167]  [<c1358c69>] ?
mutex_lock+0x9/0x10
Jan 22 23:00:29 localhost kernel: [  865.754329]  [<c1358c69>] ?
mutex_lock+0x9/0x10
Jan 22 23:00:29 localhost kernel: [  865.754539]  [<c4ae1a12>] ?
b43_op_update_tkip_key+0x82/0x90 [b43]
Jan 22 23:00:29 localhost kernel: [  865.754761]  [<c4ae1990>] ?
b43_op_update_tkip_key+0x0/0x90 [b43]
Jan 22 23:00:29 localhost kernel: [  865.755068]  [<c4a6a17a>] ?
ieee80211_tkip_decrypt_data+0x11a/0x190 [mac80211]
Jan 22 23:00:29 localhost kernel: [  865.755335]  [<c103981d>] ?
getnstimeofday+0x4d/0xd0
Jan 22 23:00:29 localhost kernel: [  865.755555]  [<c4a61a37>] ?
ieee80211_crypto_tkip_decrypt+0xa7/0xf0 [mac80211]
Jan 22 23:00:29 localhost kernel: [  865.755871]  [<c4a6d02e>] ?
ieee80211_invoke_rx_handlers+0x75e/0x18b0 [mac80211]
Jan 22 23:00:29 localhost kernel: [  865.756175]  [<c12da735>] ?
sock_sendmsg+0x95/0xb0
Jan 22 23:00:29 localhost kernel: [  865.756343]  [<c101c41d>] ?
enqueue_entity+0x7d/0x2d0
Jan 22 23:00:29 localhost kernel: [  865.756573]  [<c4a6bff4>] ?
prepare_for_handlers+0x24/0x2f0 [mac80211]
Jan 22 23:00:29 localhost kernel: [  865.756813]  [<c4a6e7af>] ?
ieee80211_rx+0x62f/0x690 [mac80211]
Jan 22 23:00:29 localhost kernel: [  865.757085]  [<c4af1b6e>] ?
b43_rx+0x43e/0x490 [b43]
Jan 22 23:00:29 localhost kernel: [  865.757321]  [<c4af556b>] ?
setup_rx_descbuffer+0x3b/0x160 [b43]
Jan 22 23:00:29 localhost kernel: [  865.757549]  [<c4af0008>] ?
b43_lpphy_op_init+0x668/0xf10 [b43]
Jan 22 23:00:29 localhost kernel: [  865.757776]  [<c4af4f06>] ?
ssb_dma_sync_single_for_device+0x56/0x60 [b43]
Jan 22 23:00:29 localhost kernel: [  865.758020]  [<c4af590d>] ?
b43_dma_rx+0x22d/0x290 [b43]
Jan 22 23:00:29 localhost kernel: [  865.758245]  [<c4ae5910>] ?
b43_do_interrupt_thread+0x5d0/0x750 [b43]
Jan 22 23:00:29 localhost kernel: [  865.758476]  [<c4ae5aa5>] ?
b43_interrupt_thread_handler+0x15/0x30 [b43]
Jan 22 23:00:29 localhost kernel: [  865.758678]  [<c1064bcf>] ?
irq_thread+0x6f/0x140
Jan 22 23:00:29 localhost kernel: [  865.758842]  [<c1064b60>] ?
irq_thread+0x0/0x140
Jan 22 23:00:29 localhost kernel: [  865.759022]  [<c1032b90>] ?
kthread+0x60/0x70
Jan 22 23:00:29 localhost kernel: [  865.759183]  [<c1032b30>] ?
kthread+0x0/0x70
Jan 22 23:00:29 localhost kernel: [  865.759352]  [<c1003177>] ?
kernel_thread_helper+0x7/0x10
Jan 22 23:02:31 localhost kernel: imklog 3.18.6, log source = /proc/kmsg
started.


BR
Csaba

