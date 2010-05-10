Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31282 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab0EJEg5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 00:36:57 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 21:36:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19431.36216.198492.247202@gargle.gargle.HOWL>
Date: Mon, 10 May 2010 10:07:12 +0530
To: Dan Carpenter <error27@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ming Lei <tom.leiming@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: [patch 2/9] ath9k: range checking issues in htc_hst.c
In-Reply-To: <20100508162201.GN27064@bicker>
References: <20100508162201.GN27064@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> The original code had ENDPOINT_MAX and HST_ENDPOINT_MAX switched.

Hm, no.

> Also the first loop was off by one, it started past the end of the array
> and went down to 1 instead of going down to 0.  The test at the end of
> the loop to see if we exited via a break wasn't right because
> "tmp_endpoint" is always non-null here.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
> index 7bf6ce1..0c062d0 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -116,7 +116,7 @@ static void htc_process_conn_rsp(struct htc_target *target,
>  		max_msglen = be16_to_cpu(svc_rspmsg->max_msg_len);
>  		endpoint = &target->endpoint[epid];
>  
> -		for (tepid = ENDPOINT_MAX; tepid > ENDPOINT0; tepid--) {
> +		for (tepid = HST_ENDPOINT_MAX - 1; tepid >= ENDPOINT0; tepid--) {

This should be (tepid = (ENDPOINT_MAX - 1); tepid > ENDPOINT0; tepid--),
and the NULL check below can be retained.

This is because ENDPOINT0 is reserved.

>  			tmp_endpoint = &target->endpoint[tepid];
>  			if (tmp_endpoint->service_id == service_id) {
>  				tmp_endpoint->service_id = 0;
> @@ -124,7 +124,7 @@ static void htc_process_conn_rsp(struct htc_target *target,
>  			}
>  		}
>  
> -		if (!tmp_endpoint)
> +		if (tepid < ENDPOINT0)
>  			return;
>  
>  		endpoint->service_id = service_id;
> @@ -297,7 +297,7 @@ void htc_stop(struct htc_target *target)
>  	enum htc_endpoint_id epid;
>  	struct htc_endpoint *endpoint;
>  
> -	for (epid = ENDPOINT0; epid <= ENDPOINT_MAX; epid++) {
> +	for (epid = ENDPOINT0; epid < HST_ENDPOINT_MAX; epid++) {

ENDPOINT_MAX should be used here, but '<=' should be replaced by '<'.

>  		endpoint = &target->endpoint[epid];
>  		if (endpoint->service_id != 0)
>  			target->hif->stop(target->hif_dev, endpoint->ul_pipeid);
> @@ -309,7 +309,7 @@ void htc_start(struct htc_target *target)
>  	enum htc_endpoint_id epid;
>  	struct htc_endpoint *endpoint;
>  
> -	for (epid = ENDPOINT0; epid <= ENDPOINT_MAX; epid++) {
> +	for (epid = ENDPOINT0; epid < HST_ENDPOINT_MAX; epid++) {
>  		endpoint = &target->endpoint[epid];

Same as above.

>  		if (endpoint->service_id != 0)
>  			target->hif->start(target->hif_dev,
> @@ -377,7 +377,7 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
>  	htc_hdr = (struct htc_frame_hdr *) skb->data;
>  	epid = htc_hdr->endpoint_id;
>  
> -	if (epid >= ENDPOINT_MAX) {
> +	if (epid >= HST_ENDPOINT_MAX) {
>  		if (pipe_id != USB_REG_IN_PIPE)
>  			dev_kfree_skb_any(skb);
>  		else

The original check was correct ...

Sujith
