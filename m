Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 63.mail-out.ovh.net ([91.121.185.56]:41498 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757609Ab0BEAnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 19:43:43 -0500
Message-ID: <4B6B6826.50208@free.fr>
Date: Fri, 05 Feb 2010 01:36:54 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix rate table choice
References: <1265317566-15372-1-git-send-email-benoit.papillault@free.fr> <43e72e891002041614o3736d56axd41054c295703a76@mail.gmail.com>
In-Reply-To: <43e72e891002041614o3736d56axd41054c295703a76@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez a écrit :
> On Thu, Feb 4, 2010 at 1:06 PM, Benoit Papillault
> <benoit.papillault@free.fr> wrote:
>   
>> ath9k rate control choose the rate table based on the current channel
>> (if it is ht40 or not). However, it happens that at this stage, the
>> channel is still ht20 even if the peer sta capabilities would later
>> allow ht40. So let's use peer sta capabilities directly.
>>     
>
> Can you clarify this commit log entry a little more, I don't think I
> get it yet. Also, is this a stable fix? If so, please Cc:
> stable@kernel.org on the commit log entry.
>
>   Luis
>   
I think it could be Cc:stable@kernel.org, but I'll leave the decision up 
to you.

In fact, I was using ath9k as a STA connected to an HT40 AP. However, 
only HT20 was displayed in ath9k/phy0/rcstat.
After digging for a while, i found that the current channel 
(sc->hw->conf.channel_type) was indeed an HT20 (or no-ht) channel!

In fact, association is handled as a queued work (from what I 
understood). As such, it uses tmp_channel (see mac80211/work.c). In the 
enable_ht() [mac80211/mlme.c], we update oper_channel_type before 
calling ieee80211_hw_config to call the hw_config driver callback that 
upates conf.channel_type. However, since we are using queued work, 
ieee80211_hw_config will use tmp_channel instead. Then enable_ht calls 
rate_control_rate_update that calls ath9k rate control callbacks ... 
where the channel is ... not HT40! I guess that when the queued work is 
done, the channel is switched again to ht40.

I would appreciate Johannes point of view here...

After applying this patch, ath9k/phy0/rcstat shows both ht20 and ht40 rates.

Regards,
Benoit

