Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934194AbeGCSGU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 14:06:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 6/6] ath10k: Add QMI message handshake for wcn3990 client
References: <20180605123732.1993-1-govinds@codeaurora.org>
Date: Tue, 03 Jul 2018 21:06:15 +0300
In-Reply-To: <20180605123732.1993-1-govinds@codeaurora.org> (Govind Singh's
        message of "Tue, 5 Jun 2018 18:07:32 +0530")
Message-ID: <877emcnqi0.fsf@kamboji.qca.qualcomm.com> (sfid-20180703_200625_991250_DC3DE6AC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> writes:

> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
> subsystem. This layer is responsible for communicating qmi control
> messages to wifi fw QMI service using QMI messaging protocol.
>
> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
> between components running between application processor and remote
> processors with underlying transport layer based on integrated
> chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).
>
> With this patch-set basic functionality(STA/SAP) can be tested
> with WCN3990 chipset. The changes are verified with the firmware
> WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1 and SDM845 MTP device.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>

[...]

> +static void ath10k_qmi_driver_event_work(struct work_struct *work)
> +{
> +	struct ath10k_qmi *qmi = container_of(work, struct ath10k_qmi,
> +					      event_work);
> +	struct ath10k_qmi_driver_event *event;
> +	struct ath10k *ar = qmi->ar;
> +
> +	spin_lock(&qmi->event_lock);
> +	while (!list_empty(&qmi->event_list)) {
> +		event = list_first_entry(&qmi->event_list,
> +					 struct ath10k_qmi_driver_event, list);
> +		list_del(&event->list);
> +		spin_unlock(&qmi->event_lock);
> +
> +		switch (event->type) {
> +		case ATH10K_QMI_EVENT_SERVER_ARRIVE:
> +			ath10k_qmi_event_server_arrive(qmi);
> +			break;
> +		case ATH10K_QMI_EVENT_SERVER_EXIT:
> +			ath10k_qmi_event_server_exit(qmi);
> +			break;
> +		case ATH10K_QMI_EVENT_FW_READY_IND:
> +			ath10k_qmi_event_fw_ready_ind(qmi);
> +			break;
> +		case ATH10K_QMI_EVENT_MSA_READY_IND:
> +			ath10k_qmi_event_msa_ready(qmi);
> +			break;
> +		default:
> +			ath10k_err(ar, "invalid event type: %d", event->type);
> +			break;
> +		}
> +		kfree(event);
> +		spin_lock(&qmi->event_lock);
> +	}
> +	spin_unlock(&qmi->event_lock);
> +}

BTW, do you really need this event loop? It's quite awkward, it would be
much cleaner to call the code directly. Or if you need a work queue for
a certain function call, create a specific workqueue. Don't add a
generic loop like this.

Didn't Bjorn mention something along the lines of that it's not needed
in earlier review?

-- 
Kalle Valo
