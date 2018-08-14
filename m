Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43676 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbeHNOCP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 10:02:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 14 Aug 2018 16:45:31 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: niklas.cassel@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, andy.gross@linaro.org, robh@kernel.org,
        devicetree@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 6/6] ath10k: Add QMI message handshake for wcn3990
 client
In-Reply-To: <20180813200633.GA38014@ban.mtv.corp.google.com>
References: <20180723123428.12993-1-govinds@codeaurora.org>
 <20180723123428.12993-7-govinds@codeaurora.org>
 <20180813200633.GA38014@ban.mtv.corp.google.com>
Message-ID: <7658c6c9d8981424cf60a01b3bd5e47d@codeaurora.org> (sfid-20180814_131535_590251_99E20AC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Brian for the review.

On 2018-08-14 01:36, Brian Norris wrote:
> Hi Govind,
> 
> On Mon, Jul 23, 2018 at 06:04:28PM +0530, Govind Singh wrote:
>> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
>> subsystem. This layer is responsible for communicating qmi control
>> messages to wifi fw QMI service using QMI messaging protocol.
>> 
>> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
>> between components running between remote processors with underlying
>> transport layer based on integrated chipset(shared memory) or
>> discrete chipset(PCI/USB/SDIO/UART).
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/Kconfig  |    1 +
>>  drivers/net/wireless/ath/ath10k/Makefile |    4 +-
>>  drivers/net/wireless/ath/ath10k/core.c   |    6 +-
>>  drivers/net/wireless/ath/ath10k/core.h   |    2 +
>>  drivers/net/wireless/ath/ath10k/qmi.c    | 1019 
>> ++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath10k/qmi.h    |  129 +++
>>  drivers/net/wireless/ath/ath10k/snoc.c   |  262 +++++-
>>  drivers/net/wireless/ath/ath10k/snoc.h   |    4 +
>>  8 files changed, 1417 insertions(+), 10 deletions(-)
>>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
>>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h
>> 
> 
>> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c 
>> b/drivers/net/wireless/ath/ath10k/qmi.c
>> new file mode 100644
>> index 000000000000..d91499a7354c
>> --- /dev/null
>> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
>> @@ -0,0 +1,1019 @@
> 
> ...
> 
>> +int ath10k_qmi_deinit(struct ath10k *ar)
>> +{
>> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
>> +	struct ath10k_qmi *qmi = ar_snoc->qmi;
>> +
>> +	cancel_work_sync(&qmi->event_work);
>> +	destroy_workqueue(qmi->event_wq);
> 
> I believe this is incorrect ordering. You should not be destroying the
> work queue that handles QMI event responses before you release the QMI
> handle. As it stands, this means you segfault during 'rmmod'.
> 

Yes, correct. I will correct this in v5 as this is still not merged in 
ath10k-next.

>> +	qmi_handle_release(&qmi->qmi_hdl);
> 
> I think this should be:
> 
> 	qmi_handle_release(&qmi->qmi_hdl);
> 	cancel_work_sync(&qmi->event_work);
> 	destroy_workqueue(qmi->event_wq);
> 
>> +	qmi = NULL;
> 
> This assignment is pointless, as 'qmi' is a local variable. Maybe you
> meant to clear the struct member, as a precaution? So this would be:
> 
> 	ar_snoc->qmi = NULL;
> 

Yes, i will correct this in v5.

> Brian
> 
>> +
>> +	return 0;
>> +}

Thanks,
Govind
