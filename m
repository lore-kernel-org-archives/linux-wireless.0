Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:3246 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab2FYRGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 13:06:39 -0400
Date: Mon, 25 Jun 2012 19:17:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linville@tuxdriver.com, davej@redhat.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: only put local on destruction if it was created
 before
Message-ID: <20120625171738.GC16275@sortiz-mobl> (sfid-20120625_190657_889857_DCE694B4)
References: <1339531699-7377-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339531699-7377-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sasha,

On Tue, Jun 12, 2012 at 10:08:19PM +0200, Sasha Levin wrote:
> Not having 'local' is a valid case when a socket was created but never
> bound or connected to anything, so avoid putting 'local' if it was
> never created.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  net/nfc/llcp/sock.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
> index 2c0b317..54daa10 100644
> --- a/net/nfc/llcp/sock.c
> +++ b/net/nfc/llcp/sock.c
> @@ -710,7 +710,8 @@ void nfc_llcp_sock_free(struct nfc_llcp_sock *sock)
>  
>  	sock->parent = NULL;
>  
> -	nfc_llcp_local_put(sock->local);
> +	if (sock->local)
> +		nfc_llcp_local_put(sock->local);
nfc_llcp_local_put() already checks for its argument being NULL or not.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
