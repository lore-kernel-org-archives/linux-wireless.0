Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34741 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbbJSQoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 12:44:21 -0400
Message-ID: <1445273058.30896.6.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20151019_184456_281472_BC25EB95)
Subject: Re: [PATCH] nfc: free skb buffer using skb_free_datagram
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Insu Yun <wuninsu@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, taesoo@gatech.edu,
	yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
Date: Mon, 19 Oct 2015 09:44:18 -0700
In-Reply-To: <1445270357-23785-1-git-send-email-wuninsu@gmail.com>
References: <1445270357-23785-1-git-send-email-wuninsu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-10-19 at 15:59 +0000, Insu Yun wrote:
> Freeing sk_buff genereated by skb_recv_datagram is always by
> skb_free_datagram, not kfree_skb.
> 
> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>  net/nfc/llcp_sock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
> index b7de0da..15e681f 100644
> --- a/net/nfc/llcp_sock.c
> +++ b/net/nfc/llcp_sock.c
> @@ -870,7 +870,7 @@ static int llcp_sock_recvmsg(struct socket *sock, struct msghdr *msg,
>  			}
>  		}
>  
> -		kfree_skb(skb);
> +		skb_free_datagram(sk, skb);
>  	}
>  
>  	/* XXX Queue backlogged skbs */

Nope, you are adding a bug here.

Current code is fine.


