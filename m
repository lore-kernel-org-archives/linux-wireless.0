Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34980 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbcABIDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:03:40 -0500
Received: by mail-wm0-f50.google.com with SMTP id f206so94396167wmf.0
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2016 00:03:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451694857-21873-2-git-send-email-xiyou.wangcong@gmail.com>
References: <1451694857-21873-1-git-send-email-xiyou.wangcong@gmail.com> <1451694857-21873-2-git-send-email-xiyou.wangcong@gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 2 Jan 2016 09:03:19 +0100
Message-ID: <CACT4Y+Y6YCYA_v=--spYpPDYj3Jo0cXcntFRe8XzYS3NJFUwqQ@mail.gmail.com> (sfid-20160102_090348_868463_CD81A2EE)
Subject: Re: [Patch net] nfc: check sock state in llcp_sock_getname()
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 2, 2016 at 1:34 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> llcp_sock_getname() checks llcp_sock->dev to make sure
> llcp_sock is already connected or bound, however, we could
> be in the middle of llcp_sock_bind() where llcp_sock->dev
> is bound and llcp_sock->service_name_len is set,
> but llcp_sock->service_name is not, in this case we would
> lead to copy some bytes from a NULL pointer.
>
> We should just check if sk->sk_state is still closed since
> both connect() and bind() will update this state at the end.

Hi Cong,

This is still racy. If you want to play lock-free then you also need
proper memory barriers. Stores to sk_state need to be
smp_store_release, while the load needs to be smp_load_acquire.
Otherwise getname still can see partially initialized socket.


> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/nfc/llcp_sock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
> index ecf0a01..5a91997 100644
> --- a/net/nfc/llcp_sock.c
> +++ b/net/nfc/llcp_sock.c
> @@ -500,7 +500,7 @@ static int llcp_sock_getname(struct socket *sock, struct sockaddr *uaddr,
>         struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
>         DECLARE_SOCKADDR(struct sockaddr_nfc_llcp *, llcp_addr, uaddr);
>
> -       if (llcp_sock == NULL || llcp_sock->dev == NULL)
> +       if (llcp_sock == NULL || sk->sk_state == LLCP_CLOSED)
>                 return -EBADFD;
>
>         pr_debug("%p %d %d %d\n", sk, llcp_sock->target_idx,
> --
> 1.8.3.1
>
