Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:36009 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754494Ab0BOHpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 02:45:44 -0500
Message-ID: <4B78FBA5.7090109@free.fr>
Date: Mon, 15 Feb 2010 08:45:41 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Drop protected data frames that have not
 	been decrypted
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr> <69e28c911002141610q737465b4s1d825d6dcd3aea26@mail.gmail.com>
In-Reply-To: <69e28c911002141610q737465b4s1d825d6dcd3aea26@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik a écrit :
> On Mon, Feb 15, 2010 at 12:37 AM, Benoit Papillault
> <benoit.papillault@free.fr> wrote:
>   
>> Fix for the following issue : a STA connected to a WPA2 AP was showing
>> frames from others STA in tcpdump on wlan0 (promiscuous mode). In fact,
>> those frames are not decrypted and appears as 802.3 junk. This patch
>> just drops any protected data frames that have not been decrypted.
>>
>> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
>> ---
>>  net/mac80211/rx.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>> index c9755f3..22ae6ee 100644
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -1397,6 +1397,14 @@ ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
>>                     ieee80211_is_data(fc) &&
>>                     (rx->key || rx->sdata->drop_unencrypted)))
>>                return -EACCES;
>> +       /*
>> +        * Drop encrypted frames that have not been decrypted. This
>> +        * happens for frames that are sent by an AP to another STA
>> +        */
>> +       if (ieee80211_has_protected(fc) &&
>> +           !(status->flag & RX_FLAG_DECRYPTED)) {
>> +               return -EACCES;
>> +       }
>>        if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
>>                if (unlikely(ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
>>                             rx->key))
>> --
>> 1.5.6.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
> I'm not familiar with this part of the code; but have you tested if
> this doesn't break monitor-while-operating mode (i.e. doesn't remove
> other-STA frames from monitor interfaces)?
>
>   
Yes, it has been tested in this case. In fact, this patch changes RX 
path only in ieee80211_rx_h_data / ieee80211_rx_h_action and 
ieee80211_rx_h_mgmt. In all 3 cases, it returns RX_DROP_MONITOR.

Regards,
Benoit

