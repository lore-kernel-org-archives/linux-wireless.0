Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbbJTEun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 00:50:43 -0400
Date: Tue, 20 Oct 2015 06:50:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thierry Escande <thierry.escande@linux.intel.com>
Subject: Re: [PATCH] nfc: netlink: avoid NULL pointer dereference on error
Message-ID: <20151020045038.GE9764@zurbaran.home> (sfid-20151020_065110_382667_93EB28E5)
References: <1444210399-3913-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1444210399-3913-1-git-send-email-vincent.stehle@laposte.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vincent,

On Wed, Oct 07, 2015 at 11:33:19AM +0200, Vincent Stehlé wrote:
> The function nfc_genl_llc_sdreq() can dereference the dev pointer while
> it is NULL on its error path. Create a new error handling label to avoid
> that.
> 
> This fixes the following coccinelle error:
> 
>   ./net/nfc/netlink.c:1175:21-24: ERROR: dev is NULL but dereferenced.
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Thierry Escande <thierry.escande@linux.intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  net/nfc/netlink.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> index 853172c..51c48f0 100644
> --- a/net/nfc/netlink.c
> +++ b/net/nfc/netlink.c
> @@ -1111,7 +1111,7 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
>  	dev = nfc_get_device(idx);
>  	if (!dev) {
>  		rc = -ENODEV;
> -		goto exit;
> +		goto exit_nodev;
>  	}
Julia Lawall sent a better fix that I applied:

-       if (!dev) {
-               rc = -ENODEV;
-               goto exit;
-       }
+       if (!dev)
+               return -ENODEV;

Cheers,
Samuel.
