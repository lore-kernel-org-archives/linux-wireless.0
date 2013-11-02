Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outrelay01.libero.it ([212.52.84.101]:43593 "EHLO
	outrelay01.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3KBMGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 08:06:22 -0400
Message-ID: <1150558629.1978061383393978285.JavaMail.defaultUser@defaultHost> (sfid-20131102_130639_305972_35C94CEF)
Date: Sat, 2 Nov 2013 13:06:18 +0100 (CET)
From: Fabio Rossi <rossi.f@inwind.it>
Reply-To: Fabio Rossi <rossi.f@inwind.it>
To: <marcel@holtmann.org>
Subject: Re: BUG in rfcomm_sock_getsockopt+0x128/0x200
Cc: "linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development"
	<linux-bluetooth@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

>I finally managed to reproduce it. It does not always happen. And strangely 
enough I can only trigger it when enabling experimental features of bluetoothd 
with -E command line switch.
>
>But I have no idea why your bisecting points to that specific commit. And 
more important it used to work just fine (see below). However I can tell you 
what makes the code crash.
>
>0x1313 is in rfcomm_sock_getsockopt (net/bluetooth/rfcomm/sock.c:743).
>738	
>739	static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, 
char __user *optval, int __user *optlen)
>740	{
>741		struct sock *sk = sock->sk;
>742		struct rfcomm_conninfo cinfo;
>743		struct l2cap_conn *conn = l2cap_pi(sk)->chan->conn;
>744		int len, err = 0;
>745		u32 opt;
>746	
>747		BT_DBG("sk %p", sk);
>
>The l2cap_pi(sk) is fully broken. That is an rfcomm_pi(sk). The commit that 
broke this is actually from an earlier time. I have this one:
>
>commit 8c1d787be4b62d2d1b6f04953eca4bcf7c839d44
>Author: Gustavo F. Padovan <padovan@profusion.mobi>
>Date:   Wed Apr 13 20:23:55 2011 -0300
>
>    Bluetooth: Move conn to struct l2cap_chan
>
>diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
>index 66cc1f0c3df8..386cfaffd4b7 100644
>--- a/net/bluetooth/rfcomm/sock.c
>+++ b/net/bluetooth/rfcomm/sock.c
>@@ -743,6 +743,7 @@ static int rfcomm_sock_getsockopt_old(struct socket 
*sock, int optname, char __u
>        struct sock *sk = sock->sk;
>        struct sock *l2cap_sk;
>        struct rfcomm_conninfo cinfo;
>+       struct l2cap_conn *conn = l2cap_pi(sk)->chan->conn;
>        int len, err = 0;
>        u32 opt;
> 
>@@ -787,8 +788,8 @@ static int rfcomm_sock_getsockopt_old(struct socket 
*sock, int optname, char __u
> 
>                l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;
> 
>-               cinfo.hci_handle = l2cap_pi(l2cap_sk)->conn->hcon->handle;
>-               memcpy(cinfo.dev_class, l2cap_pi(l2cap_sk)->conn->hcon-
>dev_class, 3);
>+               cinfo.hci_handle = conn->hcon->handle;
>+               memcpy(cinfo.dev_class, conn->hcon->dev_class, 3);
>
>The conversion is clearly wrong since we used to have a l2cap_sk that was 
pointing to the right socket.
>
>This should have blown up month ago and not just with the latest changes we 
have done to the L2CAP layer. Anyhow, you can try this small change and see if 
it fixes things for you.
>
>diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
>index c4d3d423f89b..0be7619c5e5e 100644
>--- a/net/bluetooth/rfcomm/sock.c
>+++ b/net/bluetooth/rfcomm/sock.c
>@@ -739,8 +739,9 @@ static int rfcomm_sock_setsockopt(struct socket *sock, 
int level, int optname, c
> static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char 
__user *optval, int __user *optlen)
> {
>        struct sock *sk = sock->sk;
>+       struct sock *l2cap_sk;
>+       struct l2cap_conn *conn;
>        struct rfcomm_conninfo cinfo;
>-       struct l2cap_conn *conn = l2cap_pi(sk)->chan->conn;
>        int len, err = 0;
>        u32 opt;
> 
>@@ -783,6 +784,9 @@ static int rfcomm_sock_getsockopt_old(struct socket 
*sock, int optname, char __u
>                        break;
>                }
> 
>+               l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;
>+               conn = l2cap_pi(l2cap_sk)->chan->conn;
>+
>                memset(&cinfo, 0, sizeof(cinfo));
>                cinfo.hci_handle = conn->hcon->handle;
>                memcpy(cinfo.dev_class, conn->hcon->dev_class, 3);
>
>Regards

This patch solves the issue, I don't see the crash anymore.

Thanks,
Fabio

