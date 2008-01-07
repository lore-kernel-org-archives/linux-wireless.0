Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.238]:56388 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbYAGRo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 12:44:59 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1617551nze.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2008 09:44:58 -0800 (PST)
Message-ID: <43e72e890801070944k5248be94me816452ab12a1a83@mail.gmail.com> (sfid-20080107_174505_717119_93D5F9F7)
Date: Mon, 7 Jan 2008 12:44:57 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Atheros driver
Cc: "Ralph Spitzner" <rasp@spitzner.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080106212155.GA3149@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47813432.2010208@spitzner.org>
	 <20080106212155.GA3149@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 6, 2008 4:21 PM, John W. Linville <linville@tuxdriver.com> wrote:
>
> On Sun, Jan 06, 2008 at 09:04:02PM +0100, Ralph Spitzner wrote:
> > With Kernel 2.6.23.12 && ath5k I get this:
> > ------------------------------------------------------------------
> >
> > Jan  6 20:42:44 meepmeep kernel: CPU:    0
> > Jan  6 20:42:44 meepmeep kernel: EIP:    0060:[<d0d98e61>]    Not tainted
> > VLI
> > Jan  6 20:42:44 meepmeep kernel: EFLAGS: 00010246   (2.6.23.12 #1)
> > Jan  6 20:42:44 meepmeep kernel: EIP is at
> > ieee80211_generic_frame_duration+0x21/0x70 [mac80211]
> > Jan  6 20:42:44 meepmeep kernel: eax: c2c68180   ebx: c2c68180   ecx:
> > 0000000a   edx: 00000000
> > Jan  6 20:42:44 meepmeep kernel: esi: 00000000   edi: 0000000a   ebp:
> > 000003e8   esp: c3a03dd8
> > Jan  6 20:42:44 meepmeep kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033
> > ss: 0068
> > Jan  6 20:42:44 meepmeep kernel: Process ifconfig (pid: 5119, ti=c3a02000
> > task=c363c570 task.ti=c3a02000)
> > Jan  6 20:42:44 meepmeep kernel: Stack: d0e7539b 00000002 0000876c 00000000
> > c4555000 d0e71c67 0000000a 1fb748ed
> > Jan  6 20:42:44 meepmeep kernel:        0000006b c2c68180 00000000 d0e76e44
> > c2c68eec 00000000 00000000 00000003
> > Jan  6 20:42:44 meepmeep kernel:        00000002 00000002 00000014 00000000
> > d0e76e20 c2c68de0 00000001 00000003
> > Jan  6 20:42:44 meepmeep kernel: Call Trace:
> > Jan  6 20:42:44 meepmeep kernel:  [<d0e7539b>] ath5k_hw_rfgain+0x4b/0x80
> > [ath5k]
> > Jan  6 20:42:44 meepmeep kernel:  [<d0e71c67>] ath5k_hw_reset+0xaa7/0xeb0
> > [ath5k]
> > Jan  6 20:42:44 meepmeep kernel:  [<d0e6a766>] ath5k_init+0x46/0x110 [ath5k]
> > Jan  6 20:42:44 meepmeep kernel:  [<d0d86b7c>] ieee80211_open+0x19c/0x4c0
> > [mac80211]
> > Jan  6 20:42:44 meepmeep kernel:  [<c0142235>] filemap_fault+0x1c5/0x3e0
> > Jan  6 20:42:44 meepmeep kernel:  [<c06a1353>] dev_open+0x33/0x80
> > Jan  6 20:42:44 meepmeep kernel:  [<c069f1a9>] dev_change_flags+0x149/0x1c0
> > Jan  6 20:42:44 meepmeep kernel:  [<c06e7261>] devinet_ioctl+0x521/0x6c0
> > Jan  6 20:42:44 meepmeep kernel:  [<c069efbf>] __dev_get_by_name+0x6f/0x90
> > Jan  6 20:42:44 meepmeep kernel:  [<c0693f4f>] sock_ioctl+0xbf/0x230
> > Jan  6 20:42:44 meepmeep kernel:  [<c0113b2b>] do_page_fault+0x18b/0x6d0
> > Jan  6 20:42:44 meepmeep kernel:  [<c0693e90>] sock_ioctl+0x0/0x230
> > Jan  6 20:42:44 meepmeep kernel:  [<c01682cf>] do_ioctl+0x1f/0x70
> > Jan  6 20:42:44 meepmeep kernel:  [<c016837c>] vfs_ioctl+0x5c/0x260
> > Jan  6 20:42:44 meepmeep kernel:  [<c01685f2>] sys_ioctl+0x72/0x90
> > Jan  6 20:42:44 meepmeep kernel:  [<c0104012>] syscall_call+0x7/0xb
> > Jan  6 20:42:44 meepmeep kernel:  [<c0710000>] __svc_create+0x1c0/0x1d0
> > Jan  6 20:42:44 meepmeep kernel:  =======================
> > Jan  6 20:42:44 meepmeep kernel: Code: 5d c3 90 8d b4 26 00 00 00 00 83 ec
> > 14 89 5c 24 08 89 c3 89 74 24 0c 89 d6 89 7c 24 10
> > 89 cf 8b 4c 24 18 83 78 0c 02 74 31 31 d2 <8b> 86 d0 fd ff ff 89 14 24 89
> > fa 83 e0 08 89 44 24 04 89 d8 e8
> > Jan  6 20:42:44 meepmeep kernel: EIP: [<d0d98e61>]
> > ieee80211_generic_frame_duration+0x21/0x70 [mac80211] SS:ESP 0068:c3a03dd8
> > Jan  6 20:47:27 meepmeep kernel: ACPI: RTC can wake from S4
> >
> > ------------------------------------------------------------------
> >
> >
> > Just in case someone is interested in this......
>
> I'm sure someone is interested

This is fixed by the patch titled: "[PATCH] ath5k: Fix frame duration
oops" posted on January 4rth.

  Luis
