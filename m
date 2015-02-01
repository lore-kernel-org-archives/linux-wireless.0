Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:62087 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbbBAXSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 18:18:14 -0500
Received: by mail-ie0-f171.google.com with SMTP id tr6so14151317ieb.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 15:18:12 -0800 (PST)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com. [209.85.213.182])
        by mx.google.com with ESMTPSA id m77sm5062935iom.38.2015.02.01.15.18.11
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 01 Feb 2015 15:18:12 -0800 (PST)
Received: by mail-ig0-f182.google.com with SMTP id r10so13440004igi.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 15:18:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <wrfjbnld1bid.fsf@redhat.com>
References: <1422716329-3718-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<wrfjbnld1bid.fsf@redhat.com>
Date: Mon, 2 Feb 2015 00:18:11 +0100
Message-ID: <CAKXHbyOqqCU_A3GbMG5pGSPeSqB5PjMgcWm2Dd7dDP=zVnNyCw@mail.gmail.com> (sfid-20150202_001818_073750_12C4E4B3)
Subject: Re: [PATCH] staging: rtl8723au: core: rtw_mlme: Removed variables
 that is never used
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-02-02 0:02 GMT+01:00 Jes Sorensen <Jes.Sorensen@redhat.com>:
> Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:
>> Variable was assigned a value that was never used.
>> I have also removed all the code that thereby serves no purpose.
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/rtl8723au/core/rtw_mlme.c |   21 ++++++++++-----------
>>  1 file changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
>> index 7299ef0..8b2db4b 100644
>> --- a/drivers/staging/rtl8723au/core/rtw_mlme.c
>> +++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
>> @@ -2123,7 +2123,6 @@ bool rtw_restructure_ht_ie23a(struct rtw_adapter *padapter, u8 *in_ie,
>>  {
>>       u32 out_len;
>>       int max_rx_ampdu_factor;
>> -     unsigned char *pframe;
>>       const u8 *p;
>>       struct ieee80211_ht_cap ht_capie;
>>       u8 WMM_IE[7] = {0x00, 0x50, 0xf2, 0x02, 0x00, 0x01, 0x00};
>> @@ -2139,10 +2138,10 @@ bool rtw_restructure_ht_ie23a(struct rtw_adapter *padapter, u8 *in_ie,
>>
>>               if (pmlmepriv->qos_option == 0) {
>>                       out_len = *pout_len;
>> -                     pframe = rtw_set_ie23a(out_ie + out_len,
>> -                                            WLAN_EID_VENDOR_SPECIFIC,
>> -                                            sizeof(WMM_IE), WMM_IE,
>> -                                            pout_len);
>> +                     rtw_set_ie23a(out_ie + out_len,
>> +                                             WLAN_EID_VENDOR_SPECIFIC,
>> +                                             sizeof(WMM_IE), WMM_IE,
>> +                                             pout_len);
>
> And again here - do it properly, please.
>
> Jes

Hi Jes

I am sorry, please ignore this.
I will not send any more patches.

Kind regards
Rickard Strandqvist
