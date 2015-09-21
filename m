Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33360 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbbIUAwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 20:52:47 -0400
Received: by vkgd64 with SMTP id d64so56400750vkg.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2015 17:52:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXmKdpqT=rO=fPaT2fa6oW07ZTpFHsU5z48kNd9Pk-r=g@mail.gmail.com>
References: <1442795132-19660-1-git-send-email-chaehyun.lim@gmail.com>
	<CAGRGNgXmKdpqT=rO=fPaT2fa6oW07ZTpFHsU5z48kNd9Pk-r=g@mail.gmail.com>
Date: Mon, 21 Sep 2015 09:52:46 +0900
Message-ID: <CAKV=istt72EuHZm1G8dQkzQcgxyzjfqCBZQgWWPyyumfB_JY3g@mail.gmail.com> (sfid-20150921_025252_739841_162A6198)
Subject: Re: [PATCH 1/2] staging: wilc1000: replace s32Error with result
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, glen.lee@atmel.com,
	leo.kim@atmel.com, linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 21, 2015 at 9:40 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Chaehyun,
>
>
> On Mon, Sep 21, 2015 at 10:25 AM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
>> Most of functions use s32Error variable to check error and return its value.
>> This patch replaces s32Error with result to avoid CamelCase.
>>
>> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
>> ---
>>  drivers/staging/wilc1000/coreconfigurator.c       |  40 +-
>>  drivers/staging/wilc1000/host_interface.c         | 900 +++++++++++-----------
>>  drivers/staging/wilc1000/linux_wlan.c             |  12 +-
>>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 230 +++---
>>  4 files changed, 591 insertions(+), 591 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
>> index 14e8efc..ad3b546 100644
>> --- a/drivers/staging/wilc1000/coreconfigurator.c
>> +++ b/drivers/staging/wilc1000/coreconfigurator.c
>> @@ -339,11 +339,11 @@ static inline u16 get_asoc_id(u8 *data)
>>
>>  s32 CoreConfiguratorInit(void)
>>  {
>> -       s32 s32Error = 0;
>> +       s32 result = 0;
>>
>>         PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
>>
>> -       return s32Error;
>> +       return result;
>
> This variable is never changed from 0 in this function, so why not
> just get rid of it? (Perhaps in a separate patch?)
>
>> @@ -414,7 +414,7 @@ u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
>>   */
>>  s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
>>  {
>> -       s32 s32Error = 0;
>> +       s32 result = 0;
>>         tstrNetworkInfo *pstrNetworkInfo = NULL;
>>         u8 u8MsgType = 0;
>>         u8 u8MsgID = 0;
>> @@ -523,7 +523,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
>>
>>         *ppstrNetworkInfo = pstrNetworkInfo;
>>
>> -       return s32Error;
>> +       return result;
>
> Same here.
>
>> @@ -538,24 +538,24 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
>>   */
>>  s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
>>  {
>> -       s32 s32Error = 0;
>> +       s32 result = 0;
>>
>>         if (pstrNetworkInfo != NULL) {
>>                 if (pstrNetworkInfo->pu8IEs != NULL) {
>>                         kfree(pstrNetworkInfo->pu8IEs);
>>                         pstrNetworkInfo->pu8IEs = NULL;
>>                 } else {
>> -                       s32Error = -EFAULT;
>> +                       result = -EFAULT;
>
> Stupid question: why is it an error if it's already deallocated?
>
>>                 }
>>
>>                 kfree(pstrNetworkInfo);
>>                 pstrNetworkInfo = NULL;
>>
>>         } else {
>> -               s32Error = -EFAULT;
>> +               result = -EFAULT;
>
> And again.
>
>>         }
>>
>> -       return s32Error;
>> +       return result;
>>  }
>>
>>  /**
>> @@ -572,7 +572,7 @@ s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
>>  s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
>>                                tstrConnectRespInfo **ppstrConnectRespInfo)
>>  {
>> -       s32 s32Error = 0;
>> +       s32 result = 0;
>>         tstrConnectRespInfo *pstrConnectRespInfo = NULL;
>>         u16 u16AssocRespLen = 0;
>>         u8 *pu8IEs = NULL;
>> @@ -614,7 +614,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
>>         *ppstrConnectRespInfo = pstrConnectRespInfo;
>>
>>
>> -       return s32Error;
>> +       return result;
>
> Another useless variable.
>
>>  }
>>
>>  /**
>> @@ -629,24 +629,24 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
>>   */
>>  s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
>>  {
>> -       s32 s32Error = 0;
>> +       s32 result = 0;
>>
>>         if (pstrConnectRespInfo != NULL) {
>>                 if (pstrConnectRespInfo->pu8RespIEs != NULL) {
>>                         kfree(pstrConnectRespInfo->pu8RespIEs);
>>                         pstrConnectRespInfo->pu8RespIEs = NULL;
>>                 } else {
>> -                       s32Error = -EFAULT;
>> +                       result = -EFAULT;
>
> and again, why return an error if it's already deallocated?
>
>>                 }
>>
>>                 kfree(pstrConnectRespInfo);
>>                 pstrConnectRespInfo = NULL;
>>
>>         } else {
>> -               s32Error = -EFAULT;
>> +               result = -EFAULT;
>>         }
>>
>> -       return s32Error;
>> +       return result;
>>  }
>>
>>  #ifndef CONNECT_DIRECT
>> @@ -654,7 +654,7 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
>>                                wid_site_survey_reslts_s **ppstrSurveyResults,
>>                                u32 *pu32SurveyResultsCount)
>>  {
>> -       s32 s32Error = 0;
>> +       s32 result = 0;
>>         wid_site_survey_reslts_s *pstrSurveyResults = NULL;
>>         u32 u32SurveyResultsCount = 0;
>>         u32 u32SurveyBytesLength = 0;
>> @@ -703,19 +703,19 @@ ERRORHANDLER:
>>         *ppstrSurveyResults = pstrSurveyResults;
>>         *pu32SurveyResultsCount = u32SurveyResultsCount;
>>
>> -       return s32Error;
>> +       return result;
>
> Another useless variable.
>
>>  }
>>
>>
>>  s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
>>  {
>> -       s32 s32Error = 0;
>> +       s32 result = 0;
>>
>>         if (pstrSurveyResults != NULL) {
>>                 kfree(pstrSurveyResults);
>>         }
>>
>> -       return s32Error;
>> +       return result;
>
> Ditto.
>
>>  }
>>  #endif
>>
>> @@ -731,12 +731,12 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
>>
>>  s32 CoreConfiguratorDeInit(void)
>>  {
>> -       s32 s32Error = 0;
>> +       s32 result = 0;
>>
>>         PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit()\n");
>>
>>
>> -       return s32Error;
>> +       return result;
>
> Ditto.
>
>>  }
>>
>>  /*Using the global handle of the driver*/
>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>> index 0546f7a..f997628 100644
>> --- a/drivers/staging/wilc1000/host_interface.c
>> +++ b/drivers/staging/wilc1000/host_interface.c
>> @@ -1266,11 +1266,11 @@ ERRORHANDLER:
>>   */
>>  static s32 Handle_wait_msg_q_empty(void)
>>  {
>> -       s32 s32Error = 0;
>> +       s32 result = 0;
>>
>>         g_wilc_initialized = 0;
>>         up(&hWaitResponse);
>> -       return s32Error;
>> +       return result;
>
> Another useless variable.
>
> And I'm stopping here.
>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
