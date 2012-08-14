Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62451 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab2HNL4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 07:56:07 -0400
Received: by yenl14 with SMTP id l14so308666yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2012 04:56:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn11JdqNueAjhGxxvkAJ_BTex5Sropqo93odiOmj1bzpLQ@mail.gmail.com>
References: <CAJwzM1nGny-JBD8hwKXsrERko0cGvuJB_nD2dbPrPmzF-T49Tg@mail.gmail.com>
	<CAD2nsn11JdqNueAjhGxxvkAJ_BTex5Sropqo93odiOmj1bzpLQ@mail.gmail.com>
Date: Tue, 14 Aug 2012 17:26:06 +0530
Message-ID: <CAJwzM1=zzkoRc_oLznpFLeTgKTUaDPqSg9GUxRNHYfv8iL3+Qg@mail.gmail.com> (sfid-20120814_135612_332461_F51D1735)
Subject: Re: [cfg80211] Issue with simultaneous AP-STA operation in mwifiex/cfg80211
From: Avinash Patil <avinashapatil@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

Thanks for confirming regression on your side as well.

I suspect patch from Michal Kazior [PATCH 12/13] cfg80211: add channel
checking for iface combinations - has introduced this regression.

Michal/Johannes,

Can you please help here?

I tried to set software_iftypes to NL80211_IFTYPE_STATION |
NL80211_IFTYPE_AP during wiphy_register(). It didn't work.
One more observation- if I comment  num_different_channels++ statement
inside first switch(chanmode) for CHAN_MODE_SHARED; AP-STA mode works
fine.

Regards,
Avinash



On Mon, Aug 13, 2012 at 11:05 AM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> Hi,
>
>
> On Fri, Aug 10, 2012 at 11:37 AM, Avinash Patil <avinashapatil@gmail.com> wrote:
>> Hi All,
>>
>> Lately simultaneous AP-STA functionality in mwifiex driver is not
>> working. I feel this has something to do with recent changes in
>> cfg80211.
>>
>> If we associate mwifiex STA to external AP first and then try to start
>> mwifiex AP using hostapd(on different channel), we get –EBUSY error
>> from cfg80211. This happens from path
>> nl80211_start_ap->cfg80211_can_use_chan.  cfg80211_can_use_chan
>> returns EBUSY error. In our design if mwifiex STA is already
>> associated on some different channel, AP follows this channel and BSS
>> is started using STA channel settings. If we start hostapd on same
>> channel, BSS is successfully started, but association requests from
>> external station result in failure.
>
>
> i got the same EBUSY error when i tried to start a P2P-GO in a different
> channel when my other concurrent STA is associated to some other channel.
> first cfg80211_can_use_chan ->  cfg80211_can_use_iftype_chan
> when driver advertises num_different_channels as 1
> it seems to be caught under the following logic
>
>   case CHAN_MODE_SHARED:
> 1077                         for (i = 0; i <
> CFG80211_MAX_NUM_DIFFERENT_CHANNELS; i++)
> 1078                                 if (!used_channels[i] ||
> used_channels[i] == ch)
> 1079                                         break;
> 1080
> 1081                         if (i == CFG80211_MAX_NUM_DIFFERENT_CHANNELS)
> 1082                                 return -EBUSY;
> 1083
> 1084                         if (used_channels[i] == NULL) {
> 1085                                 used_channels[i] = ch;
> 1086                                 num_different_channels++;
> 1087                         }
> 1088                         break;
>
> used_channels[1] is NULL
> num_different_channels becomes '2' when STA vifs is already in some
> other channel
>
> the following check in interface_combination for loop seems to cause
> the EBUSY error
>
> 1111                 if (num_different_channels > c->num_different_channels)
> 1112                         continue;
>
> not sure why assoc req from external STA fails.
>
>
>>
>> Please let me know if we are missing something while registering
>> n_iface and iface combinations. num_different_channels in
>> ieee80211_iface_combination has been advertised as 1.
>>
>> Regards,
>> Avinash.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> thanks,
> shafi
