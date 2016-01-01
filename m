Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:33281 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbcAAXtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 18:49:01 -0500
MIME-Version: 1.0
In-Reply-To: <CACT4Y+baorktL_dBHEWcz_jHYTzhM_-DJoms81bzVx8FbYk63w@mail.gmail.com>
References: <CACT4Y+baorktL_dBHEWcz_jHYTzhM_-DJoms81bzVx8FbYk63w@mail.gmail.com>
Date: Fri, 1 Jan 2016 15:48:59 -0800
Message-ID: <CAM_iQpWarm-m1ZNZTEJ24i+O_JuaeJyQ--EzFADvuQJdZPJz7Q@mail.gmail.com> (sfid-20160102_005017_470012_5BE583CB)
Subject: Re: net/nfc: GPF in llcp_sock_getname
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 1, 2016 at 5:58 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> GPF seems to be caused by a data race on socket state.

Seems you are right, I think the following patch should work:

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index ecf0a01..5a91997 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -500,7 +500,7 @@ static int llcp_sock_getname(struct socket *sock,
struct sockaddr *uaddr,
        struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
        DECLARE_SOCKADDR(struct sockaddr_nfc_llcp *, llcp_addr, uaddr);

-       if (llcp_sock == NULL || llcp_sock->dev == NULL)
+       if (llcp_sock == NULL || sk->sk_state == LLCP_CLOSED)
                return -EBADFD;

        pr_debug("%p %d %d %d\n", sk, llcp_sock->target_idx,
