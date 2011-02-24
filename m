Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab1BXRFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 12:05:07 -0500
From: "Ferraton, Jean RegisX" <jean.regisx.ferraton@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 24 Feb 2011 17:04:51 +0000
Subject: [Bluetooth] Rfcomm - possible circular locking dependency - Is it a
 bug???
Message-ID: <6E42A1B4DD2F7B4D80A1F26BB498BF9F8C9F79CB73@irsmsx501.ger.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I've found a problem of "possible circular locking dependency" related to rfcomm.
I'm not sure if it's really a bug or just a warning.
I've inserted the trace below.

This problem occurs in 2 cases:
1- When initiating a connection from the remote device
2- When browsing my BT device from my PC

My analysis is the following:
1- We call the function rfcomm_sock_shutdown() which locks a socket, an after calls __rfcomm_sock_close()
     	lock_sock(sk);
    	if (!sk->sk_shutdown) {
    		sk->sk_shutdown = SHUTDOWN_MASK;
    		__rfcomm_sock_close(sk);
2- In the function __rfcomm_sock_close(), we call rfcomm_dlc_close()
	case BT_CONNECTED:
    		rfcomm_dlc_close(d, 0);
3- In the function rfcomm_dlc_close(), we call rfcomm_lock() which locks a mutex on rfcomm, and this second lock causes the problem.
	rfcomm_lock();
	r = __rfcomm_dlc_close(d, err);

After this quick analysis, I'm not sure if it's a real bug which needs to be solved or if it's only a warning.
Anyone could help?

My message trace is the following (for remote connect):
[  113.995511] =======================================================
[  114.001897] [ INFO: possible circular locking dependency detected ]
[  114.008157] 2.6.35.3jrf_fix #1
[  114.011196] -------------------------------------------------------
[  114.017457] bluetoothd/511 is trying to acquire lock:
[  114.022499]  (rfcomm_mutex){+.+.+.}, at: [<c14f281a>] rfcomm_dlc_close+0x15/0x30
[  114.029887]
[  114.029892] but task is already holding lock:
[  114.035713]  (sk_lock-AF_BLUETOOTH){+.+.+.}, at: [<c14f4cfe>] rfcomm_sock_shutdown+0x17/0x5d
[  114.044147]
[  114.044152] which lock already depends on the new lock.
[  114.044158]
[  114.052319]
[  114.052324] the existing dependency chain (in reverse order) is:
[  114.059796]
[  114.059801] -> #1 (sk_lock-AF_BLUETOOTH){+.+.+.}:
[  114.065967]        [<c105d660>] lock_acquire+0xf9/0x135
[  114.071184]        [<c1445cf3>] lock_sock_nested+0x55/0x65
[  114.076662]        [<c14ed17d>] l2cap_sock_sendmsg+0x3f/0x606
[  114.082400]        [<c1443775>] sock_sendmsg+0xc9/0xe0
[  114.087530]        [<c14437b4>] kernel_sendmsg+0x28/0x37
[  114.092833]        [<c14f2278>] rfcomm_send_frame+0x2f/0x37
[  114.098398]        [<c14f232c>] rfcomm_send_ua+0x57/0x59
[  114.103701]        [<c14f3884>] rfcomm_run+0x431/0xb06
[  114.108830]        [<c104bc8f>] kthread+0x5f/0x64
[  114.113525]        [<c1002b7a>] kernel_thread_helper+0x6/0x1a
[  114.119265]
[  114.119270] -> #0 (rfcomm_mutex){+.+.+.}:
[  114.124739]        [<c105cff1>] __lock_acquire+0xe03/0x1379
[  114.130304]        [<c105d660>] lock_acquire+0xf9/0x135
[  114.135522]        [<c1522bf3>] mutex_lock_nested+0x45/0x286
[  114.141171]        [<c14f281a>] rfcomm_dlc_close+0x15/0x30
[  114.146650]        [<c14f4cdb>] __rfcomm_sock_close+0x5e/0x6a
[  114.152388]        [<c14f4d12>] rfcomm_sock_shutdown+0x2b/0x5d
[  114.158212]        [<c14f4d5d>] rfcomm_sock_release+0x19/0x60
[  114.163951]        [<c14445da>] sock_release+0x14/0x5b
[  114.169080]        [<c144463d>] sock_close+0x1c/0x20
[  114.174037]        [<c10bdd19>] fput+0xfa/0x19e
[  114.178557]        [<c10bb3c5>] filp_close+0x51/0x5b
[  114.183512]        [<c10bb488>] sys_close+0xb9/0xee
[  114.188381]        [<c1002650>] sysenter_do_call+0x12/0x36
[  114.193858]
[  114.193863] other info that might help us debug this:
[  114.193870]
[  114.201860] 1 lock held by bluetoothd/511:
[  114.205945]  #0:  (sk_lock-AF_BLUETOOTH){+.+.+.}, at: [<c14f4cfe>] rfcomm_sock_shutdown

+0x17/0x5d
[  114.214811]
[  114.214816] stack backtrace:
[  114.219167] Pid: 511, comm: bluetoothd Tainted: G        WC  2.6.35.3jrf_fix #1
[  114.226463] Call Trace:
[  114.228913]  [<c152108a>] ? printk+0xf/0x11
[  114.233086]  [<c105bc3b>] print_circular_bug+0x90/0x9c
[  114.238211]  [<c105cff1>] __lock_acquire+0xe03/0x1379
[  114.243260]  [<c14f281a>] ? rfcomm_dlc_close+0x15/0x30
[  114.248382]  [<c105d660>] lock_acquire+0xf9/0x135
[  114.253079]  [<c14f281a>] ? rfcomm_dlc_close+0x15/0x30
[  114.258208]  [<c1522bf3>] mutex_lock_nested+0x45/0x286
[  114.263338]  [<c14f281a>] ? rfcomm_dlc_close+0x15/0x30
[  114.268469]  [<c105b68d>] ? trace_hardirqs_on_caller+0x100/0x121
[  114.274467]  [<c1445cf8>] ? lock_sock_nested+0x5a/0x65
[  114.279597]  [<c105b6b9>] ? trace_hardirqs_on+0xb/0xd
[  114.284639]  [<c14f281a>] rfcomm_dlc_close+0x15/0x30
[  114.289594]  [<c14f4cdb>] __rfcomm_sock_close+0x5e/0x6a
[  114.294811]  [<c14f4d12>] rfcomm_sock_shutdown+0x2b/0x5d
[  114.300115]  [<c14f4d5d>] rfcomm_sock_release+0x19/0x60
[  114.305331]  [<c14445da>] sock_release+0x14/0x5b
[  114.309937]  [<c144463d>] sock_close+0x1c/0x20
[  114.314373]  [<c10bdd19>] fput+0xfa/0x19e
[  114.318371]  [<c10bb3c5>] filp_close+0x51/0x5b
[  114.322804]  [<c10bb488>] sys_close+0xb9/0xee
[  114.327151]  [<c1002650>] sysenter_do_call+0x12/0x36

Thanks for any help
Regards

Jean Ferraton

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

