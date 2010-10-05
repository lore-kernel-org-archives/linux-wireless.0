Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55312 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab0JERAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 13:00:34 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o95H0YU0022973
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 10:00:34 -0700
Message-ID: <4CAB59B2.5050106@candelatech.com>
Date: Tue, 05 Oct 2010 10:00:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: memory clobber in rx path, maybe related to ath9k.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I started seeing this very soon after creating interfaces.

Maybe caused by a write-after-free?

This is on the ath9k system, and I enabled SLUB debugging,
etc.

Oct  5 09:50:18 localhost kernel: =============================================================================
Oct  5 09:50:18 localhost kernel: BUG kmalloc-8192: Poison overwritten
Oct  5 09:50:18 localhost kernel: -----------------------------------------------------------------------------
Oct  5 09:50:18 localhost kernel:
Oct  5 09:50:18 localhost kernel: INFO: 0xf5b18040-0xf5b1812f. First byte 0x80 instead of 0x6b
Oct  5 09:50:18 localhost kernel: INFO: Allocated in ath_rxbuf_alloc+0x1d/0x74 [ath] age=54091 cpu=0 pid=613
Oct  5 09:50:18 localhost kernel: INFO: Freed in skb_release_data+0x8c/0x90 age=89 cpu=0 pid=4029
Oct  5 09:50:18 localhost kernel: INFO: Slab 0xc1fef300 objects=3 used=2 fp=0xf5b18000 flags=0x400040c1
Oct  5 09:50:18 localhost kernel: INFO: Object 0xf5b18000 @offset=0 fp=0x(null)
Oct  5 09:50:18 localhost kernel:
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18040:  80 00 00 00 ff ff ff ff ff ff c8 4c 75 20 e8 fd ....ÿÿÿÿÿÿÈLu.èý
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18050:  c8 4c 75 20 e8 fd d0 88 80 c1 e1 03 00 00 00 00 ÈLu.èýÐ..Áá.....
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18060:  90 01 21 04 00 09 63 69 73 63 6f 73 62 2d 31 01 ..!...ciscosb-1.
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18070:  08 82 84 8b 96 0c 12 18 24 03 01 0b 05 04 00 01 ........$.......
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18080:  00 00 2a 01 00 32 04 30 48 60 6c dd 18 00 50 f2 ..*..2.0H`lÝ..Pò
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18090:  02 01 01 84 00 03 a4 00 00 27 a4 00 00 42 43 5e ......¤..'¤..BC^
Oct  5 09:50:18 localhost kernel:  Object 0xf5b180a0:  00 62 32 2f 00 dd 1e 00 90 4c 33 4c 10 1b ff ff .b2/.Ý...L3L..ÿÿ
Oct  5 09:50:18 localhost kernel:  Object 0xf5b180b0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
Oct  5 09:50:18 localhost kernel:  Object 0xf5b180c0:  00 00 00 00 00 2d 1a 4c 10 1b ff ff 00 00 00 00 .....-.L..ÿÿ....
Oct  5 09:50:18 localhost kernel:  Object 0xf5b180d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
Oct  5 09:50:18 localhost kernel:  Object 0xf5b180e0:  00 dd 1a 00 90 4c 34 0b 08 08 00 00 00 00 00 00 .Ý...L4.........
Oct  5 09:50:18 localhost kernel:  Object 0xf5b180f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 0b .............=..
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18100:  08 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18110:  00 00 00 00 00 dd 09 00 03 7f 01 01 00 00 ff 7f .....Ý........ÿ.
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18120:  dd 0a 00 03 7f 04 01 00 00 00 00 00 c9 74 23 19 Ý...........Ét#.
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b181a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b181b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b181c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b181d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b181e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b181f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b182a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b182b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b182c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b182d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b182e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b182f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b183a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b183b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b183c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b183d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b183e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b183f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b184a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b184b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b184c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b184d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b184e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b184f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b185a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b185b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b185c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b185d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b185e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b185f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b186a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b186b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b186c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b186d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b186e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b186f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b187a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b187b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b187c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b187d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b187e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b187f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b188a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b188b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b188c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b188d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b188e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b188f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b189a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b189b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b189c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b189d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b189e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b189f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18a90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18aa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18af0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18b90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18bb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18bc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18bd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18be0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18bf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18c90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18cb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18cc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18cd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ce0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18cf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18d90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18da0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18db0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18dc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18dd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18de0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18df0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18e90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18eb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ed0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18f90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18fa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18fb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18fc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18fd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18fe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel:  Object 0xf5b18ff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Oct  5 09:50:18 localhost kernel: Redzone 0xf5b1a000:  bb bb bb bb                                     »»»»
Oct  5 09:50:18 localhost kernel: Padding 0xf5b1a028:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
Oct  5 09:50:18 localhost kernel: Pid: 4049, comm: wpa_supplicant Not tainted 2.6.36-rc6-wl+ #5
Oct  5 09:50:18 localhost kernel: Call Trace:
Oct  5 09:50:18 localhost kernel: [<c04ab513>] print_trailer+0xdc/0xe4
Oct  5 09:50:18 localhost kernel: [<c04ab8e9>] check_bytes_and_report+0x96/0xcc
Oct  5 09:50:18 localhost kernel: [<c04ab9c6>] check_object+0xa7/0x15d
Oct  5 09:50:18 localhost kernel: [<c04acc37>] __slab_alloc+0x339/0x3dd
Oct  5 09:50:18 localhost kernel: [<c0455df5>] ? mark_held_locks+0x47/0x5f
Oct  5 09:50:18 localhost kernel: [<c04ad0d2>] ? kmem_cache_alloc+0xa0/0xc5
Oct  5 09:50:18 localhost kernel: [<c04ad6fd>] __kmalloc_track_caller+0xa1/0xf2
Oct  5 09:50:18 localhost kernel: [<c06c7331>] ? skb_copy+0x2e/0x83
Oct  5 09:50:18 localhost kernel: [<c06c7331>] ? skb_copy+0x2e/0x83
Oct  5 09:50:18 localhost kernel: [<c06c6d6a>] __alloc_skb+0x58/0xf4
Oct  5 09:50:18 localhost kernel: [<c06c7331>] skb_copy+0x2e/0x83
Oct  5 09:50:18 localhost kernel: [<f8d706dd>] ieee80211_prepare_and_rx_handle+0x3b1/0x86d [mac80211]
Oct  5 09:50:18 localhost kernel: [<c0455bee>] ? mark_lock+0x1e/0x1de
Oct  5 09:50:18 localhost kernel: [<f8d5f8cf>] ? rcu_read_lock_held+0x1d/0x1f [mac80211]
Oct  5 09:50:18 localhost kernel: [<f8d5facf>] ? sta_info_get_bss+0xcb/0x10c [mac80211]
Oct  5 09:50:18 localhost kernel: [<f8d71352>] ieee80211_rx+0x70f/0x7b5 [mac80211]
Oct  5 09:50:18 localhost kernel: [<c04ad729>] ? __kmalloc_track_caller+0xcd/0xf2
Oct  5 09:50:18 localhost kernel: [<c0456038>] ? trace_hardirqs_on_caller+0xeb/0x125
Oct  5 09:50:18 localhost kernel: [<f8c55836>] ath_rx_send_to_mac80211+0x5a/0x60 [ath9k]
Oct  5 09:50:18 localhost kernel: [<c045607d>] ? trace_hardirqs_on+0xb/0xd
Oct  5 09:50:18 localhost kernel: [<f8c57066>] ath_rx_tasklet+0x1253/0x130e [ath9k]
Oct  5 09:50:18 localhost kernel: [<f8c55232>] ath9k_tasklet+0x9a/0x12a [ath9k]
Oct  5 09:50:18 localhost kernel: [<c0438fd1>] tasklet_action+0x73/0xc6
Oct  5 09:50:18 localhost kernel: [<c043945f>] __do_softirq+0x86/0x111
Oct  5 09:50:18 localhost kernel: [<c0439520>] do_softirq+0x36/0x5a
Oct  5 09:50:18 localhost kernel: [<c0439659>] irq_exit+0x35/0x69
Oct  5 09:50:18 localhost kernel: [<c0403fb9>] do_IRQ+0x86/0x9a
Oct  5 09:50:18 localhost kernel: [<c04034ee>] common_interrupt+0x2e/0x40
Oct  5 09:50:18 localhost kernel: [<c045007b>] ? do_adjtimex+0x217/0x55e
Oct  5 09:50:18 localhost kernel: [<c04ad0d7>] ? kmem_cache_alloc+0xa5/0xc5
Oct  5 09:50:18 localhost kernel: [<c04bfe3a>] ? getname+0x1b/0xb8
Oct  5 09:50:18 localhost kernel: [<c04bfe3a>] getname+0x1b/0xb8
Oct  5 09:50:18 localhost kernel: [<c04b5f3e>] do_sys_open+0x14/0xd0
Oct  5 09:50:18 localhost kernel: [<c04b603c>] sys_open+0x1e/0x26
Oct  5 09:50:18 localhost kernel: [<c0760585>] syscall_call+0x7/0xb
Oct  5 09:50:18 localhost kernel: FIX kmalloc-8192: Restoring 0xf5b18040-0xf5b1812f=0x6b
Oct  5 09:50:18 localhost kernel:
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

