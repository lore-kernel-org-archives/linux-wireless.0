Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34375 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753862AbdCPQNQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 12:13:16 -0400
Received: by mail-lf0-f66.google.com with SMTP id y193so3744842lfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 09:13:14 -0700 (PDT)
Subject: Re: [PATCH v6 03/10] ath10k: htc: move htc ctrl ep connect to
 htc_init
To: Ryan Hsu <ryanhsu@qca.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
References: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
 <148959272140.31432.695287262065906036.stgit@potku.adurom.net>
 <c1da558e-21c0-b8d2-4f7b-d67b6c4639d2@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <5e041232-a3eb-7466-b873-19111c092dff@gmail.com> (sfid-20170316_171325_585047_881C6AB4)
Date: Thu, 16 Mar 2017 17:13:11 +0100
MIME-Version: 1.0
In-Reply-To: <c1da558e-21c0-b8d2-4f7b-d67b6c4639d2@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2017-03-16 02:06, Ryan Hsu wrote:
> On 03/15/2017 08:45 AM, Kalle Valo wrote:
>
>> From: Erik Stromdahl <erik.stromdahl@gmail.com>
>>
>> This patch moves the HTC ctrl service connect from
>> htc_wait_target to htc_init.
>>
>> This is done in order to make sure the htc ctrl service
>> is setup properly before hif_start is called.
>>
>> The reason for this is that we want the HTC ctrl service
>> callback to be initialized before the target sends the
>> HTC ready message.
>>
>> The ready message will always be transmitted on endpoint 0
>> (which is always assigned to the HTC control service) so it
>> makes more sense if HTC control has been connected before the
>> ready message is received.
>>
>> Since the service to pipe mapping is done as a part of
>> the service connect, the get_default_pipe call is redundant
>> and was removed.
>>
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/htc.c |   39 ++++++++++++++-------------------
>>  1 file changed, 17 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
>> index fd5be4484984..92d5ac45327a 100644
>> --- a/drivers/net/wireless/ath/ath10k/htc.c
>> +++ b/drivers/net/wireless/ath/ath10k/htc.c
>> @@ -586,8 +586,6 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
>>  	struct ath10k *ar = htc->ar;
>>  	int i, status = 0;
>>  	unsigned long time_left;
>> -	struct ath10k_htc_svc_conn_req conn_req;
>> -	struct ath10k_htc_svc_conn_resp conn_resp;
>>  	struct ath10k_htc_msg *msg;
>>  	u16 message_id;
>>  	u16 credit_count;
>> @@ -650,22 +648,6 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
>>  		return -ECOMM;
>>  	}
>>
>> -	/* setup our pseudo HTC control endpoint connection */
>> -	memset(&conn_req, 0, sizeof(conn_req));
>> -	memset(&conn_resp, 0, sizeof(conn_resp));
>> -	conn_req.ep_ops.ep_tx_complete = ath10k_htc_control_tx_complete;
>> -	conn_req.ep_ops.ep_rx_complete = ath10k_htc_control_rx_complete;
>> -	conn_req.max_send_queue_depth = ATH10K_NUM_CONTROL_TX_BUFFERS;
>> -	conn_req.service_id = ATH10K_HTC_SVC_ID_RSVD_CTRL;
>> -
>> -	/* connect fake service */
>> -	status = ath10k_htc_connect_service(htc, &conn_req, &conn_resp);
>> -	if (status) {
>> -		ath10k_err(ar, "could not connect to htc service (%d)\n",
>> -			   status);
>> -		return status;
>> -	}
>> -
>>  	return 0;
>>  }
>>
>> @@ -875,8 +857,10 @@ int ath10k_htc_start(struct ath10k_htc *htc)
>>  /* registered target arrival callback from the HIF layer */
>>  int ath10k_htc_init(struct ath10k *ar)
>>  {
>> -	struct ath10k_htc_ep *ep = NULL;
>> +	int status;
>>  	struct ath10k_htc *htc = &ar->htc;
>> +	struct ath10k_htc_svc_conn_req conn_req;
>> +	struct ath10k_htc_svc_conn_resp conn_resp;
>>
>>  	spin_lock_init(&htc->tx_lock);
>>
>> @@ -884,10 +868,21 @@ int ath10k_htc_init(struct ath10k *ar)
>>
>>  	htc->ar = ar;
>>
>> -	/* Get HIF default pipe for HTC message exchange */
>> -	ep = &htc->endpoint[ATH10K_HTC_EP_0];
>> +	/* setup our pseudo HTC control endpoint connection */
>> +	memset(&conn_req, 0, sizeof(conn_req));
>> +	memset(&conn_resp, 0, sizeof(conn_resp));
>> +	conn_req.ep_ops.ep_tx_complete = ath10k_htc_control_tx_complete;
>> +	conn_req.ep_ops.ep_rx_complete = ath10k_htc_control_rx_complete;
>> +	conn_req.max_send_queue_depth = ATH10K_NUM_CONTROL_TX_BUFFERS;
>> +	conn_req.service_id = ATH10K_HTC_SVC_ID_RSVD_CTRL;
>>
>> -	ath10k_hif_get_default_pipe(ar, &ep->ul_pipe_id, &ep->dl_pipe_id);
>> +	/* connect fake service */
>> +	status = ath10k_htc_connect_service(htc, &conn_req, &conn_resp);
>> +	if (status) {
>> +		ath10k_err(ar, "could not connect to htc service (%d)\n",
>> +			   status);
>> +		return status;
>> +	}
>>
>
> I haven't tracked down why, but just curious.
> ath10K-htc_connect_service() will use ath10k_htc_send() and ath10k_hif_tx interface to send data down.
> I am not sure if this is proper to just move it before ath10k_hif_init() is called, will have to check further...
>
The service connect of service 1 (ATH10K_HTC_SVC_ID_RSVD_CTRL) will not result in any bus
traffic (no ath10k_htc_send will be invoked).

ath10k_htc_connect_service has a special case for this service that assigns it to endpoint 0
always.

I initially had a comment about this in the commit log, but it "got lost" during some rebase...

>>  	init_completion(&htc->ctl_resp);
>>
>
> ath10k_htc_connect_service() will expect to use htc->ctrl_resp to synchronize.
> Though there is a reinit_completion() call inside that, but logically, you should still do the init_completion() before using it.
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
>
