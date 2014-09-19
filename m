Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:34204 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaISIn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2014 04:43:26 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so1658428wes.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2014 01:43:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87a95wngzt.fsf@kamboji.qca.qualcomm.com>
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
	<1411046487-19544-7-git-send-email-michal.kazior@tieto.com>
	<87a95wngzt.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 19 Sep 2014 10:43:25 +0200
Message-ID: <CA+BoTQmsVqvGgu_fUqKGqhEKXV7E_w0KdcH_GFoPhAvyjtVdDA@mail.gmail.com> (sfid-20140919_104336_678344_E432061D)
Subject: Re: [PATCH 6/9] ath10k: deduplicate wmi service ready logic
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 September 2014 10:37, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> The logic responsible for processing the event is
>> no different across different firmware binaries.
>> The difference that needs to be dealt with is the
>> ABI of data structures.
>>
>> The intermediate structure uses __le32 to avoid
>> extra memory allocations to byteswap
>> variable-length substructures (i.e. host mem
>> chunks).
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> +     if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
>> +             ret = ath10k_wmi_10x_pull_svc_rdy_ev(skb, &arg);
>> +             wmi_10x_svc_map(arg.service_map, svc_bmap);
>> +     } else {
>> +             ret = ath10k_wmi_pull_svc_rdy_ev(skb, &arg);
>> +             wmi_main_svc_map(arg.service_map, svc_bmap);
>> +     }
>
> For consistency shouldn't the latter be
> ath10k_wmi_main_pull_svc_rdy_ev()?

Good point. Makes sense. I'll add the _main to the function name.


>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>> @@ -1394,6 +1394,7 @@ struct wlan_host_mem_req {
>>   * wmi_service_ready_event,e.g., 11ac pass some of the
>>   * device capability to the host.
>>   */
>> +
>>  struct wmi_service_ready_event {
>>       __le32 sw_version;
>>       __le32 sw_version_1;
>
> Isn't this unneeded change?

Good catch. I'll fix that.


Michał
