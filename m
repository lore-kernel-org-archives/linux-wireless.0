Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38550 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbcDPGas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 02:30:48 -0400
Date: Sat, 16 Apr 2016 14:30:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, dmitrijs.ivanovs@ubnt.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] netlink: don't send NETLINK_URELEASE for unbound sockets
Message-ID: <20160416063040.GA6380@gondor.apana.org.au> (sfid-20160416_083057_211250_5F806E2E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460014298-30293-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
>
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 215fc08c02ab..330ebd600f25 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -688,7 +688,7 @@ static int netlink_release(struct socket *sock)
> 
>        skb_queue_purge(&sk->sk_write_queue);
> 
> -       if (nlk->portid) {
> +       if (nlk->portid && nlk->bound) {

Any reason why we're still testing portid at all? Isn't testing
bound enough?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
