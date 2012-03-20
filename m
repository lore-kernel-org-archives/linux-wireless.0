Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54570 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab2CTIPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 04:15:25 -0400
Message-ID: <4F683C96.4090807@qca.qualcomm.com> (sfid-20120320_091534_797482_FE9CEBCC)
Date: Tue, 20 Mar 2012 10:15:18 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl_sdio: Initialize sg_sz to fix a compilation
 warning
References: <1331797541-2888-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1331797541-2888-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2012 09:45 AM, Vivek Natarajan wrote:
> Fix uninitialized variable warning on compilation.
> 
> sdio.c:333: warning: 'sg_sz' may be used uninitialized in this function
> 
> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/sdio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
> index 5a03082..fe6c9d8 100644
> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
> @@ -335,7 +335,7 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
>  {
>  	struct hif_scatter_req *s_req;
>  	struct bus_request *bus_req;
> -	int i, scat_req_sz, scat_list_sz, sg_sz, buf_sz;
> +	int i, scat_req_sz, scat_list_sz, sg_sz = 0, buf_sz;
>  	u8 *virt_buf;
>  
>  	scat_list_sz = (n_scat_entry - 1) * sizeof(struct hif_scatter_item);

I also see this false warning on an older arm gcc, but not with
4.4.4-14ubuntu5 for x86.

But initialising variables due to buggy gcc is not a good idea. If you
want to get rid of the warning this would be better as the if clause is
not really necessary:

--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -341,11 +341,8 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct
ath6kl_sdio *ar_sdio,
        scat_list_sz = (n_scat_entry - 1) * sizeof(struct hif_scatter_item);
        scat_req_sz = sizeof(*s_req) + scat_list_sz;

-       if (!virt_scat)
-               sg_sz = sizeof(struct scatterlist) * n_scat_entry;
-       else
-               buf_sz =  2 * L1_CACHE_BYTES +
-                         ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;
+       sg_sz = sizeof(struct scatterlist) * n_scat_entry;
+       buf_sz =  2 * L1_CACHE_BYTES + ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;

        for (i = 0; i < n_scat_req; i++) {
                /* allocate the scatter request */

Kalle
