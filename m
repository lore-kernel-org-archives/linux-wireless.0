Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753281AbeGFJkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 05:40:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 06 Jul 2018 15:10:02 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 6/6] ath10k: Add QMI message handshake for wcn3990
 client
In-Reply-To: <20180619225158.GE1635@centauri.lan>
References: <20180605123732.1993-1-govinds@codeaurora.org>
 <20180619225158.GE1635@centauri.lan>
Message-ID: <f4a54780bb16ea957e010e6bcd371689@codeaurora.org> (sfid-20180706_114010_408797_FA702FD6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Niklas,
Thanks for the review.
I have addressed most of the comments in v3 version.

On 2018-06-20 04:21, Niklas Cassel wrote:
> On Tue, Jun 05, 2018 at 06:07:32PM +0530, Govind Singh wrote:
>> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
>> subsystem. This layer is responsible for communicating qmi control
>> messages to wifi fw QMI service using QMI messaging protocol.
>> 
>>  config ATH10K_SNOC
>> -        tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
>> -        depends on ATH10K && ARCH_QCOM
>> -        ---help---
>> -          This module adds support for integrated WCN3990 chip 
>> connected
>> -          to system NOC(SNOC). Currently work in progress and will 
>> not
>> -          fully work.
>> +	tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
>> +	depends on ATH10K && ARCH_QCOM
>> +	select QCOM_QMI_HELPERS
>> +	---help---
>> +	This module adds support for integrated WCN3990 chip connected
>> +	to system NOC(SNOC). Currently work in progress and will not
>> +	fully work.
> 
> Hello Govind,
> 
> Please do clean ups in separate commits.
> That way is would be easier to see that the only
> functional change here is that you added
> select QCOM_QMI_HELPERS.
> 
> (Also help text should normally be indented by two extra spaces.)
> 
> I've sent a fix for the mixed tabs/spaces when I tried to
> add COMPILE_TEST for this, and Kalle has already picked it up
> in his master branch:
> https://marc.info/?l=linux-wireless&m=152880359200364
> 
> So in your next version of this series, this can be reduced to simply
> select QCOM_QMI_HELPERS.
> 

Addressed the same in v3 version.


>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/debugfs.h>
>> +#include <linux/device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/net.h>
>> +#include <linux/completion.h>
>> +#include <linux/idr.h>
>> +#include <linux/string.h>
>> +#include <net/sock.h>
>> +#include <linux/qcom_scm.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include "debug.h"
>> +#include "snoc.h"
>> +#include "qmi_wlfw_v01.h"
> 
> Sorting these headers by name improves readability.
> 

Fixed in v3 version.


> 
> Sparse tells me that 'ath10k_qmi_bdf_dnld_send_sync' can be static.
> 

Fixed in v3 version for all occurrence.



>> +
>> +	ret = ath10k_core_fetch_board_file(qmi->ar);
>> +
>> +	return ret;
> 
> You can simply return ath10k_core_fetch_board_file() here,
> that way you don't need the variable ret.
> 

Fixed in v3 version.

>> +	if (qmi->fw_ready) {
>> +		ath10k_snoc_fw_indication(ar, ATH10K_QMI_EVENT_FW_READY_IND);
>> +		return;
>> +	}
> 
> if fw_ready, send event and return. Nothing in else clause?
> This might be correct, I'm just asking.

Yes as we discussed this is to handle reload case.
If server state is already fw ready, we skip further handshakes as those 
are not required.

>> +}
>> +
>> +static int
>> +ath10k_qmi_driver_event_post(struct ath10k_qmi *qmi,
>> +			     enum ath10k_qmi_driver_event_type type,
>> +			     void *data)
>> +{
>> +	struct ath10k_qmi_driver_event *event;
>> +	int ret = 0;
>> +
>> +	event = kzalloc(sizeof(*event), GFP_ATOMIC);
>> +	if (!event)
>> +		return -ENOMEM;
>> +
>> +	event->type = type;
>> +	event->data = data;
>> +
>> +	spin_lock(&qmi->event_lock);
>> +	list_add_tail(&event->list, &qmi->event_list);
>> +	spin_unlock(&qmi->event_lock);
>> +
>> +	queue_work(qmi->event_wq, &qmi->event_work);
>> +
>> +	return ret;
> 
> You can simply return 0 here,
> that way you don't need the variable ret.
> 

Addressed the same in v3 version.

>> +	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
>> +			     WLFW_SERVICE_VERS_V01, 0);
>> +	if (ret)
>> +		goto err_release_qmi_handle;
> 
> When you goto err_release_qmi_handle, you will not destroy the 
> workqueue.
> 

Addressed the same in v3 version.

> 
> warning: comparison is always false due to limited range of data type
> [-Wtype-limits]
> if (qmi->msa_pa == OF_BAD_ADDR) {
>                    ^~
> 

Addressed the same in v3 version.


BR,
Govind
