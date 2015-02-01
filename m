Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35613 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbbBAXQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 18:16:36 -0500
Received: by mail-ig0-f178.google.com with SMTP id hl2so13442151igb.5
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 15:16:35 -0800 (PST)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com. [209.85.223.180])
        by mx.google.com with ESMTPSA id w4sm2459806ioi.10.2015.02.01.15.16.35
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 01 Feb 2015 15:16:35 -0800 (PST)
Received: by mail-ie0-f180.google.com with SMTP id rl12so14130690iec.11
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 15:16:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <wrfjoapd1bpg.fsf@redhat.com>
References: <1422716412-3960-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<wrfjoapd1bpg.fsf@redhat.com>
Date: Mon, 2 Feb 2015 00:16:34 +0100
Message-ID: <CAKXHbyM+2XBM-9s4-tuM024SBKEFoBb7bKG+OcqC0_t8TrCPcg@mail.gmail.com> (sfid-20150202_001653_408096_B2420A35)
Subject: Re: [PATCH] staging: rtl8723au: core: rtw_mlme_ext: Removed variables
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

2015-02-01 23:58 GMT+01:00 Jes Sorensen <Jes.Sorensen@redhat.com>:
> Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:
>> Variable was assigned a value that was never used.
>> I have also removed all the code that thereby serves no purpose.
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c |    7 +------
>>  1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
>> index 0e0f73c..7c60fed 100644
>> --- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
>> +++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
>> @@ -2515,7 +2515,6 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da,
>>       unsigned char *mac, *bssid;
>>       struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
>>  #ifdef CONFIG_8723AU_AP_MODE
>> -     const u8 *pwps_ie;
>>       u8 *ssid_ie;
>>       int ssid_ielen;
>>       int ssid_ielen_diff;
>> @@ -2576,7 +2575,7 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da,
>>
>>  #ifdef CONFIG_8723AU_AP_MODE
>>       if ((pmlmeinfo->state & 0x03) == MSR_AP) {
>> -             pwps_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
>> +             cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
>>                                                 WLAN_OUI_TYPE_MICROSOFT_WPS,
>>                                                 cur_network->IEs,
>>                                                 cur_network->IELength);
>
> If you want to modify this, you need to fix up the formatting to go with
> it.
>
> NACK
>

Hi

I am sorry, please ignore this.
I will not send any more patches.

Kind regards
Rickard Strandqvist
