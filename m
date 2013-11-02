Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:50586 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3KBB7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 21:59:15 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
Subject: Re: BUG in rfcomm_sock_getsockopt+0x128/0x200
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1175475492.2023361383354760278.JavaMail.defaultUser@defaultHost>
Date: Sat, 2 Nov 2013 02:59:01 +0100
Cc: "linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development"
	<linux-bluetooth@vger.kernel.org>
Message-Id: <0C59D92B-D434-48B8-B8E7-CFCDFC2524A9@holtmann.org> (sfid-20131102_025934_928871_9DEAC1E7)
References: <1175475492.2023361383354760278.JavaMail.defaultUser@defaultHost>
To: Fabio Rossi <rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fabio,

>> can you quickly test a kernel build from bluetooth-next tree. I would like to 
> see if that crashes as well. Since I have been running that one for weeks and 
> never saw this bug.
> 
> here is the same problem with bluetooth-next.git
> 
> BUG: unable to handle kernel paging request at 00000009dd503502
> IP: [<ffffffff815b1868>] rfcomm_sock_getsockopt+0x128/0x200
> PGD 0
> Oops: 0000 [#1] SMP
> Modules linked in: ath5k ath mac80211 cfg80211
> CPU: 2 PID: 1459 Comm: bluetoothd Not tainted 3.11.0-133163-gcebd830 #2
> Hardware name: System manufacturer System Product Name/P6T DELUXE V2, BIOS 
> 1202    12/22/2010
> task: ffff8803304106a0 ti: ffff88033046a000 task.ti: ffff88033046a000
> RIP: 0010:[<ffffffff815b1868>]  [<ffffffff815b1868>] 
> rfcomm_sock_getsockopt+0x128/0x200
> RSP: 0018:ffff88033046bed8  EFLAGS: 00010246
> RAX: 00000009dd503502 RBX: 0000000000000003 RCX: 00007fffa2ed5548
> RDX: 0000000000000003 RSI: 0000000000000012 RDI: ffff88032fd37480
> RBP: ffff88033046bf28 R08: 00007fffa2ed554c R09: ffff88032f5707d8
> R10: 00007fffa2ed5548 R11: 0000000000000202 R12: ffff880330bbd000
> R13: 00007fffa2ed5548 R14: 0000000000000003 R15: 00007fffa2ed554c
> FS:  00007fc44cfac700(0000) GS:ffff88033fc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000009dd503502 CR3: 00000003304c2000 CR4: 00000000000007e0
> Stack:
> ffff88033046bf28 ffffffff815b0f2f ffff88033046bf18 0002ffff81105ef6
> 0000000600000000 ffff88032fd37480 0000000000000012 00007fffa2ed5548
> 0000000000000003 00007fffa2ed554c ffff88033046bf78 ffffffff814c0380
> Call Trace:
> [<ffffffff815b0f2f>] ? rfcomm_sock_setsockopt+0x5f/0x190
> [<ffffffff814c0380>] SyS_getsockopt+0x60/0xb0
> [<ffffffff815e0852>] system_call_fastpath+0x16/0x1b
> Code: 02 00 00 00 0f 47 d0 4c 89 ef e8 74 13 cd ff 83 f8 01 19 c9 f7 d1 83 e1 
> f2 e9 4b ff ff ff 0f 1f 44 00 00 49 8b 84 24 70 02 00 00 <4c> 8b 30 4c 89 c0 e8 
> 2d 19 cd ff 85 c0 49 89 d7 b9 f2 ff ff ff
> RIP  [<ffffffff815b1868>] rfcomm_sock_getsockopt+0x128/0x200
> RSP <ffff88033046bed8>
> CR2: 00000009dd503502
> ---[ end trace 719ace9ee57b7a58 ]---

I finally managed to reproduce it. It does not always happen. And strangely enough I can only trigger it when enabling experimental features of bluetoothd with -E command line switch.

But I have no idea why your bisecting points to that specific commit. And more important it used to work just fine (see below). However I can tell you what makes the code crash.

0x1313 is in rfcomm_sock_getsockopt (net/bluetooth/rfcomm/sock.c:743).
738	
739	static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __user *optval, int __user *optlen)
740	{
741		struct sock *sk = sock->sk;
742		struct rfcomm_conninfo cinfo;
743		struct l2cap_conn *conn = l2cap_pi(sk)->chan->conn;
744		int len, err = 0;
745		u32 opt;
746	
747		BT_DBG("sk %p", sk);

The l2cap_pi(sk) is fully broken. That is an rfcomm_pi(sk). The commit that broke this is actually from an earlier time. I have this one:

commit 8c1d787be4b62d2d1b6f04953eca4bcf7c839d44
Author: Gustavo F. Padovan <padovan@profusion.mobi>
Date:   Wed Apr 13 20:23:55 2011 -0300

    Bluetooth: Move conn to struct l2cap_chan

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 66cc1f0c3df8..386cfaffd4b7 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -743,6 +743,7 @@ static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __u
        struct sock *sk = sock->sk;
        struct sock *l2cap_sk;
        struct rfcomm_conninfo cinfo;
+       struct l2cap_conn *conn = l2cap_pi(sk)->chan->conn;
        int len, err = 0;
        u32 opt;
 
@@ -787,8 +788,8 @@ static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __u
 
                l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;
 
-               cinfo.hci_handle = l2cap_pi(l2cap_sk)->conn->hcon->handle;
-               memcpy(cinfo.dev_class, l2cap_pi(l2cap_sk)->conn->hcon->dev_class, 3);
+               cinfo.hci_handle = conn->hcon->handle;
+               memcpy(cinfo.dev_class, conn->hcon->dev_class, 3);

The conversion is clearly wrong since we used to have a l2cap_sk that was pointing to the right socket.

This should have blown up month ago and not just with the latest changes we have done to the L2CAP layer. Anyhow, you can try this small change and see if it fixes things for you.

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index c4d3d423f89b..0be7619c5e5e 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -739,8 +739,9 @@ static int rfcomm_sock_setsockopt(struct socket *sock, int level, int optname, c
 static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __user *optval, int __user *optlen)
 {
        struct sock *sk = sock->sk;
+       struct sock *l2cap_sk;
+       struct l2cap_conn *conn;
        struct rfcomm_conninfo cinfo;
-       struct l2cap_conn *conn = l2cap_pi(sk)->chan->conn;
        int len, err = 0;
        u32 opt;
 
@@ -783,6 +784,9 @@ static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __u
                        break;
                }
 
+               l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;
+               conn = l2cap_pi(l2cap_sk)->chan->conn;
+
                memset(&cinfo, 0, sizeof(cinfo));
                cinfo.hci_handle = conn->hcon->handle;
                memcpy(cinfo.dev_class, conn->hcon->dev_class, 3);

Regards

Marcel

