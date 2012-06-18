Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36969 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2FRHZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 03:25:53 -0400
Received: by bkcji2 with SMTP id ji2so3717051bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 00:25:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87aa015bj6.fsf@purkki.adurom.net>
References: <1340003971-7037-1-git-send-email-arik@wizery.com> <87aa015bj6.fsf@purkki.adurom.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 18 Jun 2012 10:25:37 +0300
Message-ID: <CA+XVXffspZumrisT181KjSxSFRQJHGEg_01HMuFQ063RHag3Gg@mail.gmail.com> (sfid-20120618_092556_155665_D58A06D8)
Subject: Re: [PATCH] mac80211: set only VO as a U-APSD enabled AC
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 18, 2012 at 10:23 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Arik Nemtsov <arik@wizery.com> writes:
>
>> Some APs experience problems when working with U-APSD. Decrease the
>> probability of that happening by using legacy mode for all ACs but VO.
>>
>> The AP that caused us troubles was a Cisco 4410N. It ignores our
>> setting, and always treats non-VO ACs as legacy.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>
> [...]
>
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -56,10 +56,7 @@ struct ieee80211_local;
>>  #define TU_TO_EXP_TIME(x)    (jiffies + TU_TO_JIFFIES(x))
>>
>>  #define IEEE80211_DEFAULT_UAPSD_QUEUES \
>> -     (IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |   \
>> -      IEEE80211_WMM_IE_STA_QOSINFO_AC_BE |   \
>> -      IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |   \
>> -      IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
>> +     IEEE80211_WMM_IE_STA_QOSINFO_AC_VO
>
> Am I in your kill file now? :)
>
> http://www.spinics.net/lists/linux-wireless/msg92159.html

Oh missed your comment. I'll resend.
