Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37827 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab2CWK7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 06:59:30 -0400
Date: Fri, 23 Mar 2012 12:07:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: Re: [PATCH] NFC: Fix next target_idx type and rename for clarity
Message-ID: <20120323110733.GB7231@sortiz-mobl> (sfid-20120323_120001_207034_DCD04792)
References: <4F6C547F.50402@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F6C547F.50402@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eric,

On Fri, Mar 23, 2012 at 11:46:23AM +0100, Eric Lapuyade wrote:
> There are many idx in this code, so make it clearer that this one is the base for the next target that will be discoved.
> 

John, I'm queuing this one to my nfc-next branch. It will be part of my next
pull request (After wireless-next is open for business again), unless someone
has some comments about it.

Cheers,
Samuel.

> Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  include/net/nfc/nfc.h |    2 +-
>  net/nfc/core.c        |    2 +-
>  net/nfc/rawsock.c     |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
> index 45f0563..f4f6950 100644
> --- a/include/net/nfc/nfc.h
> +++ b/include/net/nfc/nfc.h
> @@ -89,7 +89,7 @@ struct nfc_genl_data {
>  
>  struct nfc_dev {
>  	unsigned idx;
> -	unsigned target_idx;
> +	u32 target_next_idx;
>  	struct nfc_target *targets;
>  	int n_targets;
>  	int targets_generation;
> diff --git a/net/nfc/core.c b/net/nfc/core.c
> index 2818582..d3a2cfb 100644
> --- a/net/nfc/core.c
> +++ b/net/nfc/core.c
> @@ -435,7 +435,7 @@ int nfc_targets_found(struct nfc_dev *dev,
>  	dev->polling = false;
>  
>  	for (i = 0; i < n_targets; i++)
> -		targets[i].idx = dev->target_idx++;
> +		targets[i].idx = dev->target_next_idx++;
>  
>  	spin_lock_bh(&dev->targets_lock);
>  
> diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
> index b2825aa..ec1134c 100644
> --- a/net/nfc/rawsock.c
> +++ b/net/nfc/rawsock.c
> @@ -92,8 +92,8 @@ static int rawsock_connect(struct socket *sock, struct sockaddr *_addr,
>  		goto error;
>  	}
>  
> -	if (addr->target_idx > dev->target_idx - 1 ||
> -	    addr->target_idx < dev->target_idx - dev->n_targets) {
> +	if (addr->target_idx > dev->target_next_idx - 1 ||
> +	    addr->target_idx < dev->target_next_idx - dev->n_targets) {
>  		rc = -EINVAL;
>  		goto error;
>  	}
> -- 
> 1.7.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
