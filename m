Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43993 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2HMFfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 01:35:55 -0400
Received: by obbuo13 with SMTP id uo13so6355381obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Aug 2012 22:35:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJwzM1nGny-JBD8hwKXsrERko0cGvuJB_nD2dbPrPmzF-T49Tg@mail.gmail.com>
References: <CAJwzM1nGny-JBD8hwKXsrERko0cGvuJB_nD2dbPrPmzF-T49Tg@mail.gmail.com>
Date: Mon, 13 Aug 2012 11:05:54 +0530
Message-ID: <CAD2nsn11JdqNueAjhGxxvkAJ_BTex5Sropqo93odiOmj1bzpLQ@mail.gmail.com> (sfid-20120813_073637_223558_36263D82)
Subject: Re: [cfg80211] Issue with simultaneous AP-STA operation in mwifiex/cfg80211
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Avinash Patil <avinashapatil@gmail.com>
Cc: linux-wireless@vger.kernel.org, Avinash Patil <patila@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On Fri, Aug 10, 2012 at 11:37 AM, Avinash Patil <avinashapatil@gmail.com> wrote:
> Hi All,
>
> Lately simultaneous AP-STA functionality in mwifiex driver is not
> working. I feel this has something to do with recent changes in
> cfg80211.
>
> If we associate mwifiex STA to external AP first and then try to start
> mwifiex AP using hostapd(on different channel), we get –EBUSY error
> from cfg80211. This happens from path
> nl80211_start_ap->cfg80211_can_use_chan.  cfg80211_can_use_chan
> returns EBUSY error. In our design if mwifiex STA is already
> associated on some different channel, AP follows this channel and BSS
> is started using STA channel settings. If we start hostapd on same
> channel, BSS is successfully started, but association requests from
> external station result in failure.


i got the same EBUSY error when i tried to start a P2P-GO in a different
channel when my other concurrent STA is associated to some other channel.
first cfg80211_can_use_chan ->  cfg80211_can_use_iftype_chan
when driver advertises num_different_channels as 1
it seems to be caught under the following logic

  case CHAN_MODE_SHARED:
1077                         for (i = 0; i <
CFG80211_MAX_NUM_DIFFERENT_CHANNELS; i++)
1078                                 if (!used_channels[i] ||
used_channels[i] == ch)
1079                                         break;
1080
1081                         if (i == CFG80211_MAX_NUM_DIFFERENT_CHANNELS)
1082                                 return -EBUSY;
1083
1084                         if (used_channels[i] == NULL) {
1085                                 used_channels[i] = ch;
1086                                 num_different_channels++;
1087                         }
1088                         break;

used_channels[1] is NULL
num_different_channels becomes '2' when STA vifs is already in some
other channel

the following check in interface_combination for loop seems to cause
the EBUSY error

1111                 if (num_different_channels > c->num_different_channels)
1112                         continue;

not sure why assoc req from external STA fails.


>
> Please let me know if we are missing something while registering
> n_iface and iface combinations. num_different_channels in
> ieee80211_iface_combination has been advertised as 1.
>
> Regards,
> Avinash.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
