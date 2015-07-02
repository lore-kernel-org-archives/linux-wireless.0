Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbbGBCAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 22:00:55 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Michel von Czettritz <michel.von.czettritz@gmail.com>
Cc: gregkh@linux.com, Larry.Finger@lwfinger.net,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: rtl8723au: fix "incorrect type in assignment"
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
	<d7c0812eedadab3697323bd53aeadba48ecf6d89.1435700714.git.michel.von.czettritz@gmail.com>
	<wrfj7fqj62mh.fsf@redhat.com> <5594797A.3010609@gmail.com>
Date: Wed, 01 Jul 2015 22:00:53 -0400
In-Reply-To: <5594797A.3010609@gmail.com> (Michel von Czettritz's message of
	"Thu, 2 Jul 2015 01:36:26 +0200")
Message-ID: <wrfjmvzf2u96.fsf@redhat.com> (sfid-20150702_040059_131885_51CB31AB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michel von Czettritz <michel.von.czettritz@gmail.com> writes:
> On 07/01/2015 10:31 PM, Jes Sorensen wrote:
>> Michel von Czettritz <michel.von.czettritz@gmail.com> writes:
>>> Writing the output of cpu_to_le32 to an u32 or *(u32*) is an implicit
>>> cast and results in an sparse warning.
>>>
>>> Since param and mask won't be changed, the implicit cast can be avoided
>>> by creating local variables.
>>>
>>> Signed-off-by: Michel von Czettritz <michel.von.czettritz@gmail.com>
>>> ---
>>>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 10 ++++++----
>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
>>> index 1003365..a5e6726 100644
>>> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
>>> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
>>> @@ -115,9 +115,10 @@ exit:
>>>  
>>>  int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
>>>  {
>>> -	*((u32 *)param) = cpu_to_le32(*(param));
>>> +	__le32 param_le;
>>> +	param_le = cpu_to_le32(*(param));
>>>  
>>> -	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)param);
>>> +	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&param_le);
>>>  
>>>  	return _SUCCESS;
>>>  }
>>> @@ -125,10 +126,11 @@ int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
>>>  int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
>>>  {
>>>  	u8 buf[5];
>>> +	__le32 mask_le;
>>>  
>>>  	memset(buf, 0, 5);
>>> -	mask = cpu_to_le32(mask);
>>> -	memcpy(buf, &mask, 4);
>>> +	mask_le = cpu_to_le32(mask);
>>> +	memcpy(buf, &mask_le, 4);
>> 
>> cpu_to_le32() + memcpy() is ugly - put_unaligned_le32() would make more
>> sense.
>> 
>> Jes
> I'm not sure if the fold, changing u32* to u32, and changing this, is
> a bit much.
> Should this be a second patch? Or maybe a patch for each function?

I would change the u32 * in one patch and the conversion and memcpy in
another.

Cheers,
Jes

