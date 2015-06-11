Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35418 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbbFKFet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 01:34:49 -0400
Received: by igbzc4 with SMTP id zc4so49405449igb.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 22:34:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9CFF011E602B7C40B0F8B7D0336B60FC49482EF0@hasmsx108.ger.corp.intel.com>
References: <1433944180-17321-1-git-send-email-emmanuel.grumbach@intel.com>
 <CAGRGNgX6CGEPJj6UGiryYWZ8FjaC6NHSbRNvL=dAJL9Cvw+bpg@mail.gmail.com> <9CFF011E602B7C40B0F8B7D0336B60FC49482EF0@hasmsx108.ger.corp.intel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 11 Jun 2015 15:34:28 +1000
Message-ID: <CAGRGNgVqv47AYuBVCF4oEhckVT1vP8MQb-j1eyTuoSM9eiObFQ@mail.gmail.com> (sfid-20150611_073452_877554_B870B9DA)
Subject: Re: [PATCH] mac80211: Disable U-APSD if connected to a SISO or non-HT AP
To: "Altman, Avri" <avri.altman@intel.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Avri,

On Thu, Jun 11, 2015 at 3:29 PM, Altman, Avri <avri.altman@intel.com> wrote:
>
>
> -----Original Message-----
> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> Sent: Thursday, June 11, 2015 6:55 AM
> To: Grumbach, Emmanuel
> Cc: Johannes Berg; linux-wireless; Altman, Avri
> Subject: Re: [PATCH] mac80211: Disable U-APSD if connected to a SISO or non-HT AP
>
> Hi Emmanuel / Avri,
>
> On Wed, Jun 10, 2015 at 11:49 PM, Emmanuel Grumbach
> <emmanuel.grumbach@intel.com> wrote:
>> From: Avri Altman <avri.altman@intel.com>
>>
>> There are a few APs our there that advertise U-APSD
>> capabilities but don't implement it right which leads to
>> poor traffic. These APs don't support MIMO or don't even
>> support HT. Use this heuristic to detect them and disable
>> U-APSD accordingly.
>>
>> Signed-off-by: Avri Altman <avri.altman@intel.com>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> ---
>>  net/mac80211/scan.c | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
>> index 7bb6a93..3791c8a 100644
>> --- a/net/mac80211/scan.c
>> +++ b/net/mac80211/scan.c
>> @@ -39,6 +39,28 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
>>                          container_of((void *)bss, struct cfg80211_bss, priv));
>>  }
>>
>> +/*
>> + * An incompatible AP workaround:
>> + * if the AP does not advertise MIMO capabilities disable U-APSD.
>> + * iPhones, among others, advertise themselves as U-APSD capable when
>> + * they aren't. Avoid connecting to those devices in U-APSD enabled.
>> + */
>> +static bool broken_uapsd_workarounds(struct ieee802_11_elems *elems)
>
> Would a better name for this function be something like
> is_uapsd_broken()? We're not actually working around anything here,
> just checking whether it's broken or not.
>
> [Altman, Avri] Yeah - well, originally this was not the name, but a previous reviewer asked me to changed it to "workaround something...".
> Actually it is a workaround of, among others, the iPhone 4/4s when SoftAP, they don't raise the
> TIM in its Beacon even if it has data for us, therefore traffic is stuck.
> We would prefer to identify those devices via their OUI, but currently this is not well defined.

Fair enough then.

As I see it, this isn't a workaround, it's just another test to ensure
that uapsd can be supported.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
