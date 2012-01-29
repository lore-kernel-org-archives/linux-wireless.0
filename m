Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50524 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2A2RXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 12:23:06 -0500
Received: by yhoo21 with SMTP id o21so1444779yho.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jan 2012 09:23:05 -0800 (PST)
Message-ID: <4F258074.5090804@lwfinger.net> (sfid-20120129_182312_497898_7FCF73C0)
Date: Sun, 29 Jan 2012 11:23:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Olivier Fabre <off@free.fr>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u regression on kernel 3.2
References: <1327856447.4f257b3f53f66@imp.free.fr>
In-Reply-To: <1327856447.4f257b3f53f66@imp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2012 11:00 AM, Olivier Fabre wrote:
> Hi Larry,
>
> A few Arch Linux users and I noticed that the r8712u driver didn't work
> anymore starting from kernel 3.2.1, while it worked in 3.0 and 3.1.
>
> Here is the Arch Linux bug report:
> https://bugs.archlinux.org/task/27996
>
> I'll list whatever info I can think of about my own case below...
>
> lsusb:
>
> Bus 003 Device 003: ID 0bda:8172 Realtek Semiconductor Corp. RTL8191SU
> 802.11n WLAN Adapter
>
> Partial dmesg:
>
> [    5.347026] r8712u: module is from the staging directory, the quality is
> unknown, you have been warned.
> [    5.348082] r8712u: DriverVersion: v7_0.20100831
> [    5.348096] r8712u: register rtl8712_netdev_ops to netdev_ops
> [    5.348098] r8712u: USB_SPEED_HIGH with 4 endpoints
> [    5.348459] r8712u: Boot from EFUSE: Autoload OK
> [    6.075474] r8712u: CustomerID = 0x0000
> [    6.075479] r8712u: MAC Address from efuse = 80:1f:02:0b:bb:11
> [    6.075770] usbcore: registered new interface driver r8712u
> [    7.132386] r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> [    7.789082] r8712u: 1 RCR=0x153f00e
> [    7.789829] r8712u: 2 RCR=0x553f00e
> [   16.240983] r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> [   16.890571] r8712u: 1 RCR=0x153f00e
> [   16.891427] r8712u: 2 RCR=0x553f00e
> [   17.440436] r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> [   18.086805] r8712u: 1 RCR=0x153f00e
> [   18.087554] r8712u: 2 RCR=0x553f00e
> [   61.003359] r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
>
> In dmesg I see that network applications get stuck, including wpa_supplicant
> and xfce4-netload-plugin:
>
> [  239.934619] INFO: task xfce4-netload-p:766 blocked for more than 120
> seconds.
> [  239.934623] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [  239.934627] xfce4-netload-p D 00000000fffee866     0   766    729
> 0x00000000
> [  239.934633]  ffff88007fec7cd8 0000000000000086 ffffffff00000000
> ffffea000437fd80
> [  239.934639]  ffff8801081bf200 ffff88007fec7fd8 ffff88007fec7fd8
> ffff88007fec7fd8
> [  239.934644]  ffff880110ca4e60 ffff8801081bf200 ffff88007ff193b8
> ffff880104cf4d00
> [  239.934649] Call Trace:
> [  239.934660]  [<ffffffff8110ec10>] ? __pagevec_free+0x60/0x100
> [  239.934667]  [<ffffffff814258bf>] schedule+0x3f/0x60
> [  239.934671]  [<ffffffff81426fa4>] __mutex_lock_slowpath+0x154/0x370
> [  239.934675]  [<ffffffff814271d6>] mutex_lock+0x16/0x30
> [  239.934681]  [<ffffffff81371d15>] rtnl_lock+0x15/0x20
> [  239.934685]  [<ffffffff813c5db7>] devinet_ioctl+0xd7/0x730
> [  239.934689]  [<ffffffff813c6f05>] inet_ioctl+0x75/0x90
> [  239.934694]  [<ffffffff8134a260>] sock_do_ioctl+0x30/0x70
> [  239.934698]  [<ffffffff8134a54d>] sock_ioctl+0x6d/0x2c0
> [  239.934706]  [<ffffffff8116879b>] ? alloc_file+0x2b/0xd0
> [  239.934711]  [<ffffffff811793af>] do_vfs_ioctl+0x8f/0x500
> [  239.934715]  [<ffffffff8134bf64>] ? sock_alloc_file+0xa4/0x120
> [  239.934719]  [<ffffffff811655b2>] ? fd_install+0x62/0x80
> [  239.934724]  [<ffffffff811798b1>] sys_ioctl+0x91/0xa0
> [  239.934727]  [<ffffffff8134d460>] ? sys_socket+0x40/0x70
> [  239.934733]  [<ffffffff814290c2>] system_call_fastpath+0x16/0x1b
>
>
> I'm currently running kernel 3.0.17 (LTS) and the driver works, but if I
> boot under 3.2.2 it doesn't (all other software being equal.)
>
> I'm guessing bisecting might help find the source of the problem, but I've
> never done that. But I could try.

When contacting a maintainer about a problem, always Cc the appropriate mailing 
list, and keep that ML in any replies.

I think the problem is that Arch Linux has switched to a new version of udev, 
which is causing all sorts of problems for drivers that use synchronous loading 
of firmware. Several drivers, including r8712u, need to be converted to an 
asynchronous load mechanism. Until that happens, you should be able to work 
around it by using a "modprobe -r/modprobe" sequence. Once the user-space code 
is fully up and running, the synchronous loading will be OK.

Larry

