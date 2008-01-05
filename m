Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:39899 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbYAEQn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jan 2008 11:43:57 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: mac80211 "failed to clone multicast frame" crash
Date: Sat, 5 Jan 2008 17:42:32 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200801051742.32865.mb@bu3sch.de> (sfid-20080105_164403_716884_CDE7CD91)
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that after allocation of the skb in ieee80211_deliver_skb() fa=
iled, somebody
dereferenced it.

Note the crap characters before the ": failed to clone multicast frame"=
 message.
There should be the device name "dev->name". This might be a use-after-=
free bug.
Maybe we don't wait for the workqueue to finish on rmmod?

This happened while doing a rmmod, modprobe sequence. I'm not sure if i=
t happened
on rmmod or modprobe.

[ 4245.070779] =DD=8B : failed to clone multicast frame
[ 4245.070802] Unable to handle kernel paging request for data at addre=
ss 0x00000000
[ 4245.071996] Faulting instruction address: 0xc0351cd4
[ 4245.073068] Oops: Kernel access of bad area, sig: 11 [#1]
[ 4245.074117] PREEMPT PowerMac
[ 4245.075132] Modules linked in: ssb mac80211 rfkill_input appletouch =
af_packet rfkill led_class input_polldev ohci_hcd pcmcia unix
[ 4245.076705] NIP: c0351cd4 LR: e2250288 CTR: c0351c8c
[ 4245.077783] REGS: dd895eb0 TRAP: 0300   Not tainted  (2.6.24-rc5-wl2=
6)
[ 4245.078897] MSR: 00009032 <EE,ME,IR,DR>  CR: 24000088  XER: 00000000
[ 4245.080132] DAR: 00000000, DSISR: 40000000
[ 4245.081095] TASK =3D de64ac80[2960] 'ipolldevd' THREAD: dd894000
[ 4245.081296] GPR00: 00000000 dd895f60 de64ac80 dd9a73d4 dd9a73c0 0000=
0000 00000000 00000032=20
[ 4245.082659] GPR08: 00000000 00000001 dd9a73d4 c0351c8c 00321068 0000=
0000 00000000 00000000=20
[ 4245.084008] GPR16: 00000000 00000000 00000000 00000000 00000000 0000=
0000 00d8e5c0 00d8fec4=20
[ 4245.085383] GPR24: 00000000 005c3000 c0587d4c dd9a73d4 e2087130 dd9a=
73c0 dd9a73d4 dd9a73d8=20
[ 4245.087594] NIP [c0351cd4] eth_type_trans+0x48/0x114
[ 4245.088652] LR [e2250288] ieee80211_deliver_skb+0xec/0x154 [mac80211=
]
[ 4245.089777] Call Trace:
[ 4245.090681] [dd895f60] [e2250228] ieee80211_deliver_skb+0x8c/0x154 [=
mac80211] (unreliable)
[ 4245.091857] [dd895f80] [c0041004] run_workqueue+0xa8/0x138
[ 4245.092904] [dd895fa0] [c0041478] worker_thread+0xdc/0xf8
[ 4245.093948] [dd895fd0] [c00458f4] kthread+0x4c/0x88
[ 4245.094976] [dd895ff0] [c0013d08] kernel_thread+0x44/0x60
[ 4245.096022] Instruction dump:
[ 4245.096952] 409d002c 80030058 3929fff2 91230054 7c004810 7c000110 7c=
0000d0 0f000000=20
[ 4245.098248] 812300a0 3929000e 912300a0 810a0090 <88080000> a0e80000 =
70090001 a0c80002=20
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
