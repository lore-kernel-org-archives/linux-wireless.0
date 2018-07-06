Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbeGFJYD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 05:24:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 06 Jul 2018 14:54:02 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 6/6] ath10k: Add QMI message handshake for wcn3990
 client
In-Reply-To: <877emcnqi0.fsf@kamboji.qca.qualcomm.com>
References: <20180605123732.1993-1-govinds@codeaurora.org>
 <877emcnqi0.fsf@kamboji.qca.qualcomm.com>
Message-ID: <131a437d9693b5ff1b43ffabb9d82d9b@codeaurora.org> (sfid-20180706_112406_778114_F4C69A0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-03 23:36, Kalle Valo wrote:
> Govind Singh <govinds@codeaurora.org> writes:
> 
>> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
>> subsystem. This layer is responsible for communicating qmi control
>> messages to wifi fw QMI service using QMI messaging protocol.
>> 
>> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
>> between components running between application processor and remote
>> processors with underlying transport layer based on integrated
>> chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).
>> 
>> With this patch-set basic functionality(STA/SAP) can be tested
>> with WCN3990 chipset. The changes are verified with the firmware
>> WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1 and SDM845 MTP device.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> 
> [...]
> 
>> +static void ath10k_qmi_driver_event_work(struct work_struct *work)
>> +{
>> +	struct ath10k_qmi *qmi = container_of(work, struct ath10k_qmi,
>> +					      event_work);
>> +	struct ath10k_qmi_driver_event *event;
>> +	struct ath10k *ar = qmi->ar;
>> +
>> +	spin_lock(&qmi->event_lock);
>> +	while (!list_empty(&qmi->event_list)) {
>> +		event = list_first_entry(&qmi->event_list,
>> +					 struct ath10k_qmi_driver_event, list);
>> +		list_del(&event->list);
>> +		spin_unlock(&qmi->event_lock);
>> +
>> +		switch (event->type) {
>> +		case ATH10K_QMI_EVENT_SERVER_ARRIVE:
>> +			ath10k_qmi_event_server_arrive(qmi);
>> +			break;
>> +		case ATH10K_QMI_EVENT_SERVER_EXIT:
>> +			ath10k_qmi_event_server_exit(qmi);
>> +			break;
>> +		case ATH10K_QMI_EVENT_FW_READY_IND:
>> +			ath10k_qmi_event_fw_ready_ind(qmi);
>> +			break;
>> +		case ATH10K_QMI_EVENT_MSA_READY_IND:
>> +			ath10k_qmi_event_msa_ready(qmi);
>> +			break;
>> +		default:
>> +			ath10k_err(ar, "invalid event type: %d", event->type);
>> +			break;
>> +		}
>> +		kfree(event);
>> +		spin_lock(&qmi->event_lock);
>> +	}
>> +	spin_unlock(&qmi->event_lock);
>> +}
> 
> BTW, do you really need this event loop? It's quite awkward, it would 
> be
> much cleaner to call the code directly. Or if you need a work queue for
> a certain function call, create a specific workqueue. Don't add a
> generic loop like this.
> 

This is required for serialization of southbound events(from server to 
clients).
In cases where we have fatal error in server side during early 
handshakes, serialization helps
to process the events in order to handle driver recovery in correct 
state.

> Didn't Bjorn mention something along the lines of that it's not needed
> in earlier review?

Bjorn also suggested to handle them in event driven manner.

Thanks,
Govind
