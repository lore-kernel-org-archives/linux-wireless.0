Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33992 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbdCPBGj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 21:06:39 -0400
From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6 03/10] ath10k: htc: move htc ctrl ep connect to
 htc_init
Date: Thu, 16 Mar 2017 01:06:24 +0000
Message-ID: <c1da558e-21c0-b8d2-4f7b-d67b6c4639d2@qca.qualcomm.com> (sfid-20170316_021123_580495_B0BD25DC)
References: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
 <148959272140.31432.695287262065906036.stgit@potku.adurom.net>
In-Reply-To: <148959272140.31432.695287262065906036.stgit@potku.adurom.net>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2017 08:45 AM, Kalle Valo wrote:

> From: Erik Stromdahl <erik.stromdahl@gmail.com>
>
> This patch moves the HTC ctrl service connect from
> htc_wait_target to htc_init.
>
> This is done in order to make sure the htc ctrl service
> is setup properly before hif_start is called.
>
> The reason for this is that we want the HTC ctrl service
> callback to be initialized before the target sends the
> HTC ready message.
>
> The ready message will always be transmitted on endpoint 0
> (which is always assigned to the HTC control service) so it
> makes more sense if HTC control has been connected before the
> ready message is received.
>
> Since the service to pipe mapping is done as a part of
> the service connect, the get_default_pipe call is redundant
> and was removed.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/htc.c |   39 ++++++++++++++-------------=
------
>  1 file changed, 17 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless=
/ath/ath10k/htc.c
> index fd5be4484984..92d5ac45327a 100644
> --- a/drivers/net/wireless/ath/ath10k/htc.c
> +++ b/drivers/net/wireless/ath/ath10k/htc.c
> @@ -586,8 +586,6 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
>  	struct ath10k *ar =3D htc->ar;
>  	int i, status =3D 0;
>  	unsigned long time_left;
> -	struct ath10k_htc_svc_conn_req conn_req;
> -	struct ath10k_htc_svc_conn_resp conn_resp;
>  	struct ath10k_htc_msg *msg;
>  	u16 message_id;
>  	u16 credit_count;
> @@ -650,22 +648,6 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
>  		return -ECOMM;
>  	}
> =20
> -	/* setup our pseudo HTC control endpoint connection */
> -	memset(&conn_req, 0, sizeof(conn_req));
> -	memset(&conn_resp, 0, sizeof(conn_resp));
> -	conn_req.ep_ops.ep_tx_complete =3D ath10k_htc_control_tx_complete;
> -	conn_req.ep_ops.ep_rx_complete =3D ath10k_htc_control_rx_complete;
> -	conn_req.max_send_queue_depth =3D ATH10K_NUM_CONTROL_TX_BUFFERS;
> -	conn_req.service_id =3D ATH10K_HTC_SVC_ID_RSVD_CTRL;
> -
> -	/* connect fake service */
> -	status =3D ath10k_htc_connect_service(htc, &conn_req, &conn_resp);
> -	if (status) {
> -		ath10k_err(ar, "could not connect to htc service (%d)\n",
> -			   status);
> -		return status;
> -	}
> -
>  	return 0;
>  }
> =20
> @@ -875,8 +857,10 @@ int ath10k_htc_start(struct ath10k_htc *htc)
>  /* registered target arrival callback from the HIF layer */
>  int ath10k_htc_init(struct ath10k *ar)
>  {
> -	struct ath10k_htc_ep *ep =3D NULL;
> +	int status;
>  	struct ath10k_htc *htc =3D &ar->htc;
> +	struct ath10k_htc_svc_conn_req conn_req;
> +	struct ath10k_htc_svc_conn_resp conn_resp;
> =20
>  	spin_lock_init(&htc->tx_lock);
> =20
> @@ -884,10 +868,21 @@ int ath10k_htc_init(struct ath10k *ar)
> =20
>  	htc->ar =3D ar;
> =20
> -	/* Get HIF default pipe for HTC message exchange */
> -	ep =3D &htc->endpoint[ATH10K_HTC_EP_0];
> +	/* setup our pseudo HTC control endpoint connection */
> +	memset(&conn_req, 0, sizeof(conn_req));
> +	memset(&conn_resp, 0, sizeof(conn_resp));
> +	conn_req.ep_ops.ep_tx_complete =3D ath10k_htc_control_tx_complete;
> +	conn_req.ep_ops.ep_rx_complete =3D ath10k_htc_control_rx_complete;
> +	conn_req.max_send_queue_depth =3D ATH10K_NUM_CONTROL_TX_BUFFERS;
> +	conn_req.service_id =3D ATH10K_HTC_SVC_ID_RSVD_CTRL;
> =20
> -	ath10k_hif_get_default_pipe(ar, &ep->ul_pipe_id, &ep->dl_pipe_id);
> +	/* connect fake service */
> +	status =3D ath10k_htc_connect_service(htc, &conn_req, &conn_resp);
> +	if (status) {
> +		ath10k_err(ar, "could not connect to htc service (%d)\n",
> +			   status);
> +		return status;
> +	}
> =20

I haven't tracked down why, but just curious.
ath10K-htc_connect_service() will use ath10k_htc_send() and ath10k_hif_tx i=
nterface to send data down.
I am not sure if this is proper to just move it before ath10k_hif_init() is=
 called, will have to check further...

>  	init_completion(&htc->ctl_resp);
> =20

ath10k_htc_connect_service() will expect to use htc->ctrl_resp to synchroni=
ze.
Though there is a reinit_completion() call inside that, but logically, you =
should still do the init_completion() before using it.
