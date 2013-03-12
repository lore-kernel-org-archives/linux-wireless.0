Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms.dension.com ([195.56.193.33]:48790 "EHLO ms.dension.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab3CLPmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 11:42:03 -0400
Date: Tue, 12 Mar 2013 16:30:20 +0100
From: "Patrik, Kluba" <pkluba@dension.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: bug: deadlock in rtl8192cu
Message-ID: <20130312163020.67f9532b.pkluba@dension.com> (sfid-20130312_164210_439606_AB296090)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi!

After killing a wpa_supplicant which was set up to connect to an
invalid (non-existent) SSID, it goes to 'D' state, and brings down
every process trying to do low-level network operations (anything
involving an rtnl_lock) to their knees. The same happens when instead
of killing wpa_supplicant, I do 'ifconfig wlan0 down'.

See the task state dump at the end. Unfortunately it's not very helpful
as there are a plenty of static functions called, and due to this a
couple of addresses are resolved to incorrect symbol names, which
makes the dump confusing. BTW this is on an ARM system.

The blocking usb_control_msg was actually called from
_usbctrl_vendorreq_sync_read(). See the following fragment:


        do {
                status = usb_control_msg(udev, pipe, request, reqtype, value,
                                         index, pdata, len, 0); /*max. timeout*/
                if (status < 0) {


Seems like the blocking is intentional (max timeout specified in the
comment), but I don't know why the transfer cannot finish.

The caller of _usbctrl_vendorreq_sync_read() is _DisableGPIO().


        /* 1. Disable GPIO[7:0] */
        rtl_write_word(rtlpriv, REG_GPIO_PIN_CTRL+2, 0x0000);
        value32 = rtl_read_dword(rtlpriv, REG_GPIO_PIN_CTRL) & 0xFFFF00FF;


rtl_write_word() completes, and rtl_read_dword() is being blocked.

The caller of _DisableGPIO() is _CardDisableHWSM(), which was called 
from rtl92cu_card_disable(), which was called from rtl_usb_stop().
rtl_usb_stop was called with rtnl_lock held.

This was first observed on a 3.2.34 kernel. Today I have tried
compat-wireless-02-22 on the same kernel, with the patches from OpenWrt,
but nothing changed. I have checked the wireless-next git tree, and
_usbctrl_vendorreq_sync_read() is the same.

I have no idea what can be the actual problem, but can do a bit of debugging and
information gathering if you need more, just tell me what should I do.
usb_control_msg() has not completed for at least 30 minutes now. As a quick
workaround, is it enough to set a timeout of say, 5 seconds in
usbctrl_vendorreq_sync_read() ? Could this cause problems at different places?

Regards,
Patrik

/ # cat /sys/class/net/wlan0/device/modalias 
usb:v0BDAp8176d0200dc00dsc00dp00icFFiscFFipFF

T:  Bus=02 Lev=02 Prnt=02 Port=02 Cnt=02 Dev#=  4 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=8176 Rev= 2.00
S:  Manufacturer=Realtek
S:  Product=802.11n WLAN Adapter
S:  SerialNumber=00e04c000001
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=ff Prot=ff Driver=rtl8192cu
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=84(I) Atr=03(Int.) MxPS=  64 Ivl=1ms

[  707.022567] SysRq : Show Blocked State
[  707.026155]   task                PC stack   pid father
[  707.026218] heartbeat       D c040d5a4     0  1523      1 0x00000000
[  707.026255] Backtrace: 
[  707.026339] [<c040d390>] (__schedule+0x0/0x350) from [<c040d7fc>] (schedule+0x50/0x68)
[  707.026388] [<c040d7ac>] (schedule+0x0/0x68) from [<c040df64>] (__mutex_lock_slowpath+0x88/0xc8)
[  707.026429] [<c040dedc>] (__mutex_lock_slowpath+0x0/0xc8) from [<c040dfec>] (mutex_lock+0x48/0x4c)
[  707.026455]  r8:c64fa900 r7:c78c682c r6:00000014 r5:00000014 r4:c64fa900
[  707.026514] [<c040dfa4>] (mutex_lock+0x0/0x4c) from [<c03af49c>] (rtnetlink_rcv+0x18/0x34)
[  707.026571] [<c03af484>] (rtnetlink_rcv+0x0/0x34) from [<c03b9d00>] (netlink_unicast+0x2c0/0x2d8)
[  707.026595]  r5:00000014 r4:c78c6800
[  707.026632] [<c03b9a40>] (netlink_unicast+0x0/0x2d8) from [<c03ba610>] (netlink_sendmsg+0x2c4/0x314)
[  707.026673] [<c03ba34c>] (netlink_sendmsg+0x0/0x314) from [<c038ecd4>] (sock_sendmsg+0x98/0xb8)
[  707.026712] [<c038ec3c>] (sock_sendmsg+0x0/0xb8) from [<c038f49c>] (sys_sendto+0xc4/0x100)
[  707.026732]  r7:00000000 r6:41dff194 r5:c7115840 r4:00000014
[  707.026807] [<c038f3d8>] (sys_sendto+0x0/0x100) from [<c010c820>] (ret_fast_syscall+0x0/0x30)

[  707.026833] ifplugd         D c040d5a4     0   755      1 0x00000000
[  707.026860] Backtrace: 
[  707.026907] [<c040d390>] (__schedule+0x0/0x350) from [<c040d7fc>] (schedule+0x50/0x68)
[  707.026946] [<c040d7ac>] (schedule+0x0/0x68) from [<c040df64>] (__mutex_lock_slowpath+0x88/0xc8)
[  707.026986] [<c040dedc>] (__mutex_lock_slowpath+0x0/0xc8) from [<c040dfec>] (mutex_lock+0x48/0x4c)
[  707.027008]  r8:c0528008 r7:c05410cc r6:be9c3bc8 r5:c0f70000 r4:00008946
[  707.027061] [<c040dfa4>] (mutex_lock+0x0/0x4c) from [<c03af47c>] (rtnl_lock+0x14/0x1c)
[  707.027119] [<c03af468>] (rtnl_lock+0x0/0x1c) from [<c03a3c08>] (dev_ioctl+0x520/0x600)
[  707.027158] [<c03a36e8>] (dev_ioctl+0x0/0x600) from [<c038e608>] (sock_ioctl+0x94/0x258)
[  707.027190] [<c038e574>] (sock_ioctl+0x0/0x258) from [<c0195bac>] (do_vfs_ioctl+0x8c/0x36c)
[  707.027210]  r7:be9c3bc8 r6:00000003 r5:c6a6d500 r4:00008946
[  707.027251] [<c0195b20>] (do_vfs_ioctl+0x0/0x36c) from [<c0195ecc>] (sys_ioctl+0x40/0x68)
[  707.027270]  r7:c6a6d500 r6:00008946 r5:be9c3bc8 r4:00000003
[  707.027328] [<c0195e8c>] (sys_ioctl+0x0/0x68) from [<c010c820>] (ret_fast_syscall+0x0/0x30)
[  707.027350]  r7:00000036 r6:00000001 r5:0006a677 r4:00000001

[  707.027387] wpa_supplicant  D c040d5a4     0   901      1 0x00000000
[  707.027412] Backtrace: 
[  707.027449] [<c040d390>] (__schedule+0x0/0x350) from [<c040d7fc>] (schedule+0x50/0x68)
[  707.027484] [<c040d7ac>] (schedule+0x0/0x68) from [<c040daf8>] (schedule_timeout+0x154/0x1a0)
[  707.027523] [<c040d9a4>] (schedule_timeout+0x0/0x1a0) from [<c040d214>] (wait_for_common+0x104/0x13c)
[  707.027546]  r7:c65b2000 r6:c65b3c70 r5:7fffffff r4:c65b3c74
[  707.027589] [<c040d110>] (wait_for_common+0x0/0x13c) from [<c040d2d8>] (wait_for_completion_timeout+0x14/0x18)
[  707.027630] [<c040d2c4>] (wait_for_completion_timeout+0x0/0x18) from [<c031f84c>] (usb_start_wait_urb+0x64/0xcc)
[  707.027668] [<c031f7e8>] (usb_start_wait_urb+0x0/0xcc) from [<c031fab0>] (usb_control_msg+0xd4/0xf8)
[  707.027689]  r8:000000c0 r7:00000000 r6:00000044 r5:00000004 r4:c0f9dae0
[  707.027782] [<c031f9dc>] (usb_control_msg+0x0/0xf8) from [<bf14f240>] (_usb_writeN_sync+0x140/0x1bc [rtlwifi])
[  707.027849] [<bf14f190>] (_usb_writeN_sync+0x90/0x1bc [rtlwifi]) from [<bf14f2d0>] (_usb_read32_sync+0x14/0x18 [rtlwifi])
[  707.027923] [<bf14f2bc>] (_usb_read32_sync+0x0/0x18 [rtlwifi]) from [<bf166e70>] (rtl92cu_enable_hw_security_config+0x444/0xbdc [rtl8192cu])
[  707.027983] [<bf166e28>] (rtl92cu_enable_hw_security_config+0x3fc/0xbdc [rtl8192cu]) from [<bf169abc>] (rtl92cu_card_disable+0x8c/0xa44 [rtl8192cu])
[  707.028013]  r5:c0ed8aa0 r4:c0ed9760
[  707.028070] [<bf169a30>] (rtl92cu_card_disable+0x0/0xa44 [rtl8192cu]) from [<bf14db9c>] (rtl_usb_stop+0x44/0x4c [rtlwifi])
[  707.028096]  r7:c0ed8aa0 r6:c0ed9760 r5:c0ed8aa0 r4:c0ed9760
[  707.028154] [<bf14db58>] (rtl_usb_stop+0x0/0x4c [rtlwifi]) from [<bf149960>] (rtl_op_stop+0x7c/0xa4 [rtlwifi])
[  707.028178]  r5:c0ed9794 r4:00000000
[  707.028321] [<bf1498e4>] (rtl_op_stop+0x0/0xa4 [rtlwifi]) from [<bf0c5a50>] (ieee80211_stop_device+0x48/0x80 [mac80211])
[  707.028348]  r7:c78e5340 r6:c78e5968 r5:00000000 r4:c0ed8aa0
[  707.028479] [<bf0c5a08>] (ieee80211_stop_device+0x0/0x80 [mac80211]) from [<bf0b364c>] (ieee80211_recalc_idle+0x448/0x838 [mac80211])
[  707.028507]  r5:00000000 r4:00000060
[  707.028598] [<bf0b333c>] (ieee80211_recalc_idle+0x138/0x838 [mac80211]) from [<bf0b3ab8>] (ieee80211_stop+0x18/0x20 [mac80211])
[  707.028687] [<bf0b3aa0>] (ieee80211_stop+0x0/0x20 [mac80211]) from [<c03a1730>] (__dev_close_many+0x90/0xd8)
[  707.028733] [<c03a16a0>] (__dev_close_many+0x0/0xd8) from [<c03a17a8>] (__dev_close+0x30/0x48)
[  707.028755]  r5:c78e5000 r4:00000001
[  707.028795] [<c03a1778>] (__dev_close+0x0/0x48) from [<c039f3e0>] (__dev_change_flags+0x84/0x148)
[  707.028837] [<c039f35c>] (__dev_change_flags+0x0/0x148) from [<c03a2184>] (dev_change_flags+0x18/0x50)
[  707.028859]  r7:c05410cc r6:bec2abf0 r5:00001003 r4:c78e5000
[  707.028928] [<c03a216c>] (dev_change_flags+0x0/0x50) from [<c03ee03c>] (devinet_ioctl+0x758/0x790)
[  707.028952]  r7:c05410cc r6:bec2abf0 r5:00000000 r4:c65b2000
[  707.029000] [<c03ed8e4>] (devinet_ioctl+0x0/0x790) from [<c03ef0ec>] (inet_ioctl+0x1ac/0x1c4)
[  707.029041] [<c03eef40>] (inet_ioctl+0x0/0x1c4) from [<c038e5e8>] (sock_ioctl+0x74/0x258)
[  707.029078] [<c038e574>] (sock_ioctl+0x0/0x258) from [<c0195bac>] (do_vfs_ioctl+0x8c/0x36c)
[  707.029097]  r7:bec2abf0 r6:00000004 r5:c783d180 r4:00008914
[  707.029136] [<c0195b20>] (do_vfs_ioctl+0x0/0x36c) from [<c0195ecc>] (sys_ioctl+0x40/0x68)
[  707.029155]  r7:c783d180 r6:00008914 r5:bec2abf0 r4:00000004
[  707.029224] [<c0195e8c>] (sys_ioctl+0x0/0x68) from [<c010c820>] (ret_fast_syscall+0x0/0x30)
[  707.029246]  r7:00000036 r6:00000000 r5:018655c8 r4:018655b8

[  707.029277] ifconfig        D c040d5a4     0  1522   1521 0x00000000
[  707.029303] Backtrace: 
[  707.029352] [<c040d390>] (__schedule+0x0/0x350) from [<c040d7fc>] (schedule+0x50/0x68)
[  707.029392] [<c040d7ac>] (schedule+0x0/0x68) from [<c040df64>] (__mutex_lock_slowpath+0x88/0xc8)
[  707.029432] [<c040dedc>] (__mutex_lock_slowpath+0x0/0xc8) from [<c040dfec>] (mutex_lock+0x48/0x4c)
[  707.029455]  r8:00008916 r7:c05410cc r6:bedbbb50 r5:00000000 r4:c78d4000
[  707.029516] [<c040dfa4>] (mutex_lock+0x0/0x4c) from [<c03af47c>] (rtnl_lock+0x14/0x1c)
[  707.029572] [<c03af468>] (rtnl_lock+0x0/0x1c) from [<c03eda08>] (devinet_ioctl+0x124/0x790)
[  707.029616] [<c03ed8e4>] (devinet_ioctl+0x0/0x790) from [<c03ef0ec>] (inet_ioctl+0x1ac/0x1c4)
[  707.029651] [<c03eef40>] (inet_ioctl+0x0/0x1c4) from [<c038e5e8>] (sock_ioctl+0x74/0x258)
[  707.029684] [<c038e574>] (sock_ioctl+0x0/0x258) from [<c0195bac>] (do_vfs_ioctl+0x8c/0x36c)
[  707.029707]  r7:bedbbb50 r6:00000004 r5:c64b0c80 r4:00008916
[  707.029747] [<c0195b20>] (do_vfs_ioctl+0x0/0x36c) from [<c0195ecc>] (sys_ioctl+0x40/0x68)
[  707.029768]  r7:c64b0c80 r6:00008916 r5:bedbbb50 r4:00000004
[  707.029823] [<c0195e8c>] (sys_ioctl+0x0/0x68) from [<c010c820>] (ret_fast_syscall+0x0/0x30)
[  707.029843]  r7:00000036 r6:000001c3 r5:00000015 r4:bedbbb50

-- 
Patrik KLUBA
Software Developer at

DENSION Audio Systems Ltd.
H-1116 Budapest, Sztregova u. 1
Phone: +36 1 463 0470
Fax:   +36 1 463 0479
Web:   www.dension.com
