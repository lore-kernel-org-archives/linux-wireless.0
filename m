Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965232AbeFZC7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 22:59:41 -0400
Date: Mon, 25 Jun 2018 22:59:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, pmladek@suse.com,
        sergey.senozhatsky@gmail.com, syzkaller-bugs@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: INFO: rcu detected stall in vprintk_emit
Message-ID: <20180625225937.43aee76c@vmware.local.home> (sfid-20180626_050244_058171_03F1925A)
In-Reply-To: <20180626014924.GB11229@jagdpanzerIV>
References: <000000000000720530056f7f9b63@google.com>
        <20180626014924.GB11229@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 26 Jun 2018 10:49:24 +0900
Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:

> So we can try switching to ratelimited error reporting
> [that would be option A]:
> 
> ---
> 
> diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
> index 2ceefa183cee..2f3becb709b8 100644
> --- a/net/nfc/llcp_commands.c
> +++ b/net/nfc/llcp_commands.c
> @@ -755,7 +755,7 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
>  		pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
>  					 frag_len + LLCP_HEADER_SIZE, &err);
>  		if (pdu == NULL) {
> -			pr_err("Could not allocate PDU\n");
> +			pr_err_ratelimited("Could not allocate PDU\n");
>  			continue;
>  		}
>  
> ---
> 
> 
> Or ratelimited error reporting and cond_resched()
> [that would be option B]:

I don't think this is a printk() issue per se, so I think Option B is
the only option. You should not get stuck in an infinite loop if we run
short on memory. Perhaps we could have an Option C which would exit
this loop gracefully with some kind of error. But I haven't looked at
the surrounding code to be sure if that is possible.

-- Steve

> 
> ---
> 
> diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
> index 2ceefa183cee..61741db4c4e6 100644
> --- a/net/nfc/llcp_commands.c
> +++ b/net/nfc/llcp_commands.c
> @@ -755,7 +755,8 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
>  		pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
>  					 frag_len + LLCP_HEADER_SIZE, &err);
>  		if (pdu == NULL) {
> -			pr_err("Could not allocate PDU\n");
> +			pr_err_ratelimited("Could not allocate PDU\n");
> +			cond_resched();
>  			continue;
>  		}
>  
> ---
