Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753615AbeGFJS6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 05:18:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 06 Jul 2018 14:48:56 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        Niklas Cassel <niklas.cassel@linaro.org>
Cc: andy.gross@linaro.org, david.brown@linaro.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH v2 6/6] ath10k: Add QMI message handshake for wcn3990
 client
In-Reply-To: <871sckpcyp.fsf@kamboji.qca.qualcomm.com>
References: <20180605123732.1993-1-govinds@codeaurora.org>
 <20180619225158.GE1635@centauri.lan>
 <871sckpcyp.fsf@kamboji.qca.qualcomm.com>
Message-ID: <a109c5c9ce936cabadb1b006c79b9746@codeaurora.org> (sfid-20180706_111902_462497_A4F69866)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-03 20:45, Kalle Valo wrote:
> Niklas Cassel <niklas.cassel@linaro.org> writes:
> 
>> On Tue, Jun 05, 2018 at 06:07:32PM +0530, Govind Singh wrote:
>>> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
>>> subsystem. This layer is responsible for communicating qmi control
>>> messages to wifi fw QMI service using QMI messaging protocol.
>>> 
>>> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
>>> between components running between application processor and remote
>>> processors with underlying transport layer based on integrated
>>> chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).
>>> 
>>> With this patch-set basic functionality(STA/SAP) can be tested
>>> with WCN3990 chipset. The changes are verified with the firmware
>>> WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1 and SDM845 MTP device.
>>> 
>>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> 
> [...]
> 
>>> --- a/drivers/net/wireless/ath/ath10k/Kconfig
>>> +++ b/drivers/net/wireless/ath/ath10k/Kconfig
>>> @@ -41,12 +41,13 @@ config ATH10K_USB
>>>  	  work in progress and will not fully work.
>>> 
>>>  config ATH10K_SNOC
>>> -        tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
>>> -        depends on ATH10K && ARCH_QCOM
>>> -        ---help---
>>> -          This module adds support for integrated WCN3990 chip 
>>> connected
>>> -          to system NOC(SNOC). Currently work in progress and will 
>>> not
>>> -          fully work.
>>> +	tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
>>> +	depends on ATH10K && ARCH_QCOM
>>> +	select QCOM_QMI_HELPERS
>>> +	---help---
>>> +	This module adds support for integrated WCN3990 chip connected
>>> +	to system NOC(SNOC). Currently work in progress and will not
>>> +	fully work.
>> 
>> Hello Govind,
>> 
>> Please do clean ups in separate commits.
>> That way is would be easier to see that the only
>> functional change here is that you added
>> select QCOM_QMI_HELPERS.
>> 
>> (Also help text should normally be indented by two extra spaces.)
>> 
>> I've sent a fix for the mixed tabs/spaces when I tried to
>> add COMPILE_TEST for this, and Kalle has already picked it up
>> in his master branch:
>> https://marc.info/?l=linux-wireless&m=152880359200364
>> 
>> So in your next version of this series, this can be reduced to simply
>> select QCOM_QMI_HELPERS.
> 
> BTW, I actually already did this on the pending branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=0caef5beefb85e6a5aa2a4b60d78253bbe453d7c
> 
>> There are some checkpatch warnings on this patch:
>> 
>> drivers/net/wireless/ath/ath10k/qmi.c and
>> drivers/net/wireless/ath/ath10k/qmi.h
>> is missing SPDX-License-Identifier tag.
>> 
>> Several lines in drivers/net/wireless/ath/ath10k/qmi.c
>> and one line in drivers/net/wireless/ath/ath10k/snoc.c
>> is over 80 characters.
> 
> Yeah, but these can be ignored.
> 
>> This patch is quite big, I think that it makes sense to split your 
>> patch in two.
>> One that adds the ath10k_qmi_* functions, and a follow up patch
>> that actually adds the function calls to snoc.c
> 
> Yeah, it's big but IMHO not too big. And splitting it up makes
> functinonal review harder, that's why I prefer it like this.
> 
>>> +int ath10k_qmi_wlan_enable(struct ath10k *ar,
>>> +			   struct ath10k_qmi_wlan_enable_cfg *config,
>>> +			   enum ath10k_qmi_driver_mode mode,
>>> +			   const char *version)
>>> +{
>>> +	int ret;
>>> +
>>> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "mode: %d, config: %p:\n",
>>> +		   mode, config);
>>> +
>>> +	ret = ath10k_qmi_cfg_send_sync_msg(ar, config, version);
>>> +	if (ret) {
>>> +		ath10k_err(ar, "wlan qmi config send failed\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	ret = ath10k_qmi_mode_send_sync_msg(ar, mode);
>> 
>> Sparse tells me that you are mixing enum types.
>> If this is really what you want, do an explicit cast.
>> 
>> drivers/net/wireless/ath/ath10k//qmi.c:504:49: warning: mixing 
>> different enum types
>> drivers/net/wireless/ath/ath10k//qmi.c:504:49:     int enum 
>> ath10k_qmi_driver_mode  versus
>> drivers/net/wireless/ath/ath10k//qmi.c:504:49:     int enum 
>> wlfw_driver_mode_enum_v01
> 
> Good catch, that can cause subtle bugs. If you really want this, I
> prefer having a separate helper function with a switch statement making
> the conversion. This way it's super clear what's happening.
> 

Addressed in v3 version.

>>> +int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
>>> +{
>>> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
>>> +	int ret;
>>> +
>>> +	switch (type) {
>>> +	case ATH10K_QMI_EVENT_FW_READY_IND:
>>> +		ret = ath10k_core_register(ar,
>>> +					   ar_snoc->target_info.soc_version);
>>> +		if (ret) {
>>> +			ath10k_err(ar, "Failed to register driver core: %d\n",
>>> +				   ret);
>>> +		}
>>> +		break;
>>> +	case ATH10K_QMI_EVENT_FW_DOWN_IND:
>>> +		break;
>> 
>> Perhaps this switch statement should have a default label?
> 
> Good idea. And add a warning so that we know there was an unknown event
> which should be added to ath10k.

Addressed in v3 version.

Thanks,
Govind
