Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10137 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdESJSI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 05:18:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "nbd@nbd.name" <nbd@nbd.name>
CC: Venkateswara Naralasettty <vnaralas@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k : Fix channel survey dump
Date: Fri, 19 May 2017 09:17:56 +0000
Message-ID: <87wp9durwe.fsf@kamboji.qca.qualcomm.com> (sfid-20170519_111817_721137_073FA305)
References: <1493217698-22451-1-git-send-email-c_vnaral@qti.qualcomm.com>
        <40f2b7a2-7276-6de6-afc6-407348c92e70@nbd.name>
In-Reply-To: <40f2b7a2-7276-6de6-afc6-407348c92e70@nbd.name> (Felix Fietkau's
        message of "Wed, 26 Apr 2017 17:29:16 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2017-04-26 16:41, Venkateswara Rao Naralasetty wrote:
>> Channel active/busy time are showing incorrect
>> (less than previous or sometimes zero) for
>> successive survey dump command.
>>=20
>> example:
>> Survey data from wlan0
>>         frequency:                      5180 MHz [in use]
>>         channel active time:            54995 ms
>>         channel busy time:              432 ms
>>         channel receive time:           0 ms
>>         channel transmit time:          59 ms
>> Survey data from wlan0
>>         frequency:                      5180 MHz [in use]
>>         channel active time:            32592 ms
>>         channel busy time:              254 ms
>>         channel receive time:           0 ms
>>         channel transmit time:          0 ms
>>=20
>> This patch fix this issue by assigning 'wmi_bss_survey_req_type'
>> as 'WMI_BSS_SURVEY_REQ_TYPE_READ'.
>>=20
>> Firmware ver 10.4-3.4-00082
>> Hardware QCA4019
>>=20
>> Signed-off-by: Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireles=
s/ath/ath10k/mac.c
>> index 9977829..87a9b55 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -6621,7 +6621,7 @@ static void ath10k_reconfig_complete(struct ieee80=
211_hw *hw,
>>  				  struct ieee80211_channel *channel)
>>  {
>>  	int ret;
>> -	enum wmi_bss_survey_req_type type =3D WMI_BSS_SURVEY_REQ_TYPE_READ_CLE=
AR;
>> +	enum wmi_bss_survey_req_type type =3D WMI_BSS_SURVEY_REQ_TYPE_READ;
>
> Does the firmware read the registers directly, or does it accumulate
> the results in a way that can't overflow? If you don't clear the
> counters on reset, the overflow will be problematic for the
> current-channel stats. I think a better approach would be to use
> READ_CLEAR for in-use channels and store the sum inside the driver.

Venkateswara, any comments?

--=20
Kalle Valo=
