Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33376 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbdE3MBv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 08:01:51 -0400
From: Venkateswara Naralasettty <vnaralas@qti.qualcomm.com>
To: Venkateswara Naralasettty <vnaralas@qti.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "nbd@nbd.name" <nbd@nbd.name>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [PATCH] ath10k : Fix channel survey dump
Date: Tue, 30 May 2017 12:01:43 +0000
Message-ID: <dd600e9cc88f4994bd310fb3674d55b7@aphydexm01f.ap.qualcomm.com> (sfid-20170530_140156_085228_D0685B92)
References: <1493217698-22451-1-git-send-email-c_vnaral@qti.qualcomm.com>
 <40f2b7a2-7276-6de6-afc6-407348c92e70@nbd.name>
 <87wp9durwe.fsf@kamboji.qca.qualcomm.com>
 <bf174d49b9be4b3697601f6bef7394d8@APSANEXR01F.ap.qualcomm.com>
In-Reply-To: <bf174d49b9be4b3697601f6bef7394d8@APSANEXR01F.ap.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



-----Original Message-----
From: ath10k [mailto:ath10k-bounces@lists.infradead.org] On Behalf Of Venka=
teswara Naralasettty
Sent: Monday, May 22, 2017 8:48 PM
To: Kalle Valo <kvalo@qca.qualcomm.com>; nbd@nbd.name
Cc: linux-wireless@vger.kernel.org; ath10k@lists.infradead.org
Subject: RE: [PATCH] ath10k : Fix channel survey dump


-----Original Message-----
From: Kalle Valo
Sent: Friday, May 19, 2017 2:48 PM
To: nbd@nbd.name
Cc: Venkateswara Naralasettty <vnaralas@qti.qualcomm.com>; ath10k@lists.inf=
radead.org; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k : Fix channel survey dump

Felix Fietkau <nbd@nbd.name> writes:

> On 2017-04-26 16:41, Venkateswara Rao Naralasetty wrote:
>> Channel active/busy time are showing incorrect (less than previous or=20
>> sometimes zero) for successive survey dump command.
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
>> Signed-off-by: Venkateswara Rao Naralasetty=20
>> <c_vnaral@qti.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
>> b/drivers/net/wireless/ath/ath10k/mac.c
>> index 9977829..87a9b55 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -6621,7 +6621,7 @@ static void ath10k_reconfig_complete(struct ieee80=
211_hw *hw,
>>  				  struct ieee80211_channel *channel)  {
>>  	int ret;
>> -	enum wmi_bss_survey_req_type type =3D WMI_BSS_SURVEY_REQ_TYPE_READ_CLE=
AR;
>> +	enum wmi_bss_survey_req_type type =3D WMI_BSS_SURVEY_REQ_TYPE_READ;
>
> Does the firmware read the registers directly, or does it accumulate=20
> the results in a way that can't overflow? If you don't clear the=20
> counters on reset, the overflow will be problematic for the=20
> current-channel stats. I think a better approach would be to use=20
> READ_CLEAR for in-use channels and store the sum inside the driver.

Venkateswara, any comments?

--
Kalle Valo

Sorry for the delayed response I held up with some other work. Currently I =
am working with firmware team to address your comments.

--
Venkatesh.

> Firmware is not handling the overflow while accumulating the results,  we=
 are looking into some other options to make it in host

-Venkatesh.

_______________________________________________
ath10k mailing list
ath10k@lists.infradead.org
BLOCKEDlists[.]infradead[.]org/mailman/listinfo/ath10kBLOCKED
