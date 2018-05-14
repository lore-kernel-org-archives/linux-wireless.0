Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752333AbeENN3L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 09:29:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 14 May 2018 18:59:10 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/12] ath10k: add support to start and stop qmi service
In-Reply-To: <20180511174355.GP2259@tuxbook-pro>
References: <1522042773-25775-1-git-send-email-govinds@codeaurora.org>
 <20180511174355.GP2259@tuxbook-pro>
Message-ID: <c7c6baca45339958d0db94656805d099@codeaurora.org> (sfid-20180514_152915_601085_9125BB26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-11 23:13, Bjorn Andersson wrote:
> On Sun 25 Mar 22:39 PDT 2018, Govind Singh wrote:
> 
>> Add support to start qmi service to configure the wlan
>> firmware component and register event notifier to communicate
>> with the WLAN firmware over qmi communication interface.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/qmi.c | 155 
>> ++++++++++++++++++++++++++++++++--
>>  drivers/net/wireless/ath/ath10k/qmi.h |  13 +++
>>  2 files changed, 160 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c 
>> b/drivers/net/wireless/ath/ath10k/qmi.c
>> index 2235182..3a7fcc6 100644
>> --- a/drivers/net/wireless/ath/ath10k/qmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
>> @@ -31,15 +31,115 @@
>> 
>>  static struct ath10k_qmi *qmi;
>> 
>> +static int ath10k_qmi_event_fw_ready_ind(struct ath10k_qmi *qmi)
>> +{
>> +	pr_debug("fw ready event received\n");
> 
> Please use dev_dbg.
> 

I have migrated from pr_ to dev_ logging for the whole set, will share 
in next version.

>> +	spin_lock(&qmi->event_lock);
>> +	qmi->fw_ready = true;
>> +	spin_unlock(&qmi->event_lock);
> 
> I see no reason for not just putting this code in
> ath10k_qmi_fw_ready_ind().
> 
>> +
> 
> fw_ready isn't used for anything, what purpose does this code have?
> 

fw_ready will be used in later set of changes for qmi client debugfs and
for synchronization.I will decouple this and add as bit mask in 
appropriate change.


>> +	return 0;
>> +}
>> +
>> +static void ath10k_qmi_fw_ready_ind(struct qmi_handle *qmi_hdl,
>> +				    struct sockaddr_qrtr *sq,
>> +				    struct qmi_txn *txn, const void *data)
>> +{
>> +	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, 
>> qmi_hdl);
>> +
>> +	ath10k_qmi_event_fw_ready_ind(qmi);
>> +}
>> +
>> +static void ath10k_qmi_msa_ready_ind(struct qmi_handle *qmi_hdl,
>> +				     struct sockaddr_qrtr *sq,
>> +				     struct qmi_txn *txn, const void *data)
>> +{
>> +	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, 
>> qmi_hdl);
>> +
>> +	qmi->msa_ready = true;
> 
> msa_ready is not only unused in this patch, it's unused after all 11
> patches. Can you drop it?
> 

Sure, will remove in next version.


>> +static void ath10k_qmi_event_server_arrive(struct work_struct *work)
>> +{
>> +	struct ath10k_qmi *qmi = container_of(work, struct ath10k_qmi,
>> +					      work_svc_arrive);
>> +	int ret;
>> +
>> +	ret = ath10k_qmi_connect_to_fw_server(qmi);
>> +	if (ret)
>> +		return;
>> +
>> +	pr_debug("qmi server arrive\n");
>> +}
>> +

>>  static int ath10k_qmi_new_server(struct qmi_handle *qmi_hdl,
>>  				 struct qmi_service *service)
>>  {
>> +	struct ath10k_qmi *qmi = container_of(qmi_hdl, struct ath10k_qmi, 
>> qmi_hdl);
>> +	struct sockaddr_qrtr *sq = &qmi->sq;
>> +
>> +	sq->sq_family = AF_QIPCRTR;
>> +	sq->sq_node = service->node;
>> +	sq->sq_port = service->port;
>> +
>> +	queue_work(qmi->event_wq, &qmi->work_svc_arrive);
> 
> This is being called in a sleepable context and kernel_connect() will
> not block, so I see no reason for queue work here to invoke
> ath10k_qmi_event_server_arrive() just to call
> ath10k_qmi_connect_to_fw_server().
> 
> Just put the kernel_connect() call here.
> 
> 

In this change it just calls ath10k_qmi_connect_to_fw_server, but most 
of the handshaking is done in server arrive callback.
Successive changes adds the request/response of each handshake.
Is it ok to block new_server callback till all client handshaking gets 
completed. I thought it might block other client
notification overlapped on the same time slot(ex: IPA). Do you see any 
concern here or should be ok.
I have not profiled yet, i will share the approx time it can take.

> This gives the added benefit that you don't need to use qmi->sq as a 
> way
> to pass parameters to ath10k_qmi_connect_to_fw_server().
> 
>> +
>>  	return 0;
>>  }
>> 
>>  static void ath10k_qmi_del_server(struct qmi_handle *qmi_hdl,
>>  				  struct qmi_service *service)
>>  {
>> +	struct ath10k_qmi *qmi =
>> +		container_of(qmi_hdl, struct ath10k_qmi, qmi_hdl);
>> +
>> +	queue_work(qmi->event_wq, &qmi->work_svc_exit);
> 
> I see no reason to queue work to set a boolean to false, just inline 
> the
> code here.
> 

sure, this i can remove.

>> 
>>  static struct qmi_ops ath10k_qmi_ops = {
>> @@ -47,6 +147,51 @@ static void ath10k_qmi_del_server(struct 
>> qmi_handle *qmi_hdl,
>>  	.del_server = ath10k_qmi_del_server,
>>  };
>> 
>> +static int ath10k_alloc_qmi_resources(struct ath10k_qmi *qmi)
>> +{
>> +	int ret;
>> +
>> +	ret = qmi_handle_init(&qmi->qmi_hdl,
>> +			      WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
>> +			      &ath10k_qmi_ops, qmi_msg_handler);
>> +	if (ret)
>> +		goto err;
>> +
>> +	qmi->event_wq = alloc_workqueue("qmi_driver_event",
>> +					WQ_UNBOUND, 1);
>> +	if (!qmi->event_wq) {
>> +		pr_err("workqueue alloc failed\n");
>> +		ret = -EFAULT;
>> +		goto err_qmi_service;
>> +	}
>> +
>> +	spin_lock_init(&qmi->event_lock);
> 
> All calls from the qmi helpers are done from a single context, so
> there's no reason to use this lock.
> 
>> +	INIT_WORK(&qmi->work_svc_arrive, ath10k_qmi_event_server_arrive);
>> +	INIT_WORK(&qmi->work_svc_exit, ath10k_qmi_event_server_exit);
>> +
>> +	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
>> +			     WLFW_SERVICE_VERS_V01, 0);
>> +	if (ret)
>> +		goto err_qmi_service;
>> +
>> +	return 0;
>> +
>> +err_qmi_service:
>> +	qmi_handle_release(&qmi->qmi_hdl);
>> +
>> +err:
>> +	return ret;
>> +}
>> +
>> +static void ath10k_remove_qmi_resources(struct ath10k_qmi *qmi)
>> +{
>> +	cancel_work_sync(&qmi->work_svc_arrive);
>> +	cancel_work_sync(&qmi->work_svc_exit);
>> +	destroy_workqueue(qmi->event_wq);
>> +	qmi_handle_release(&qmi->qmi_hdl);
>> +	qmi = NULL;
>> +}
>> +
>>  static int ath10k_qmi_probe(struct platform_device *pdev)
>>  {
>>  	int ret;
>> @@ -58,14 +203,8 @@ static int ath10k_qmi_probe(struct platform_device 
>> *pdev)
>> 
>>  	qmi->pdev = pdev;
>>  	platform_set_drvdata(pdev, qmi);
>> -	ret = qmi_handle_init(&qmi->qmi_hdl,
>> -			      WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
>> -			      &ath10k_qmi_ops, NULL);
>> -	if (ret < 0)
>> -		goto err;
>> 
>> -	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
>> -			     WLFW_SERVICE_VERS_V01, 0);
> 
> Please plan ahead, there's no reason for adding this here in patch 3 
> and
> then just move it in patch 4. That said, with the removal of the queues
> I don't see a good reason to create a helper for this.
> 

Sure, will do in next version.

>> +	ret = ath10k_alloc_qmi_resources(qmi);
>>  	if (ret < 0)
>>  		goto err;
>> 
>> @@ -81,7 +220,7 @@ static int ath10k_qmi_remove(struct platform_device 
>> *pdev)
>>  {
>>  	struct ath10k_qmi *qmi = platform_get_drvdata(pdev);
>> 
>> -	qmi_handle_release(&qmi->qmi_hdl);
>> +	ath10k_remove_qmi_resources(qmi);
> 
> Just inline ath10k_remove_qmi_resources() here, so one doesn't have to
> jump around to figure out what's actually going on.
> 

Sure, will do in next version.

  	return 0;

> 
> Regards,
> Bjorn
>> 

BR,
Govind
