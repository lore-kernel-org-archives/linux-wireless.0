Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4528 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab1DGL4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 07:56:33 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Question of CSA callback
References: <op.vtkf4iiu3ri7v4@arend-laptop>
 <1302177128.3779.12.camel@jlt3.sipsolutions.net>
Date: Thu, 7 Apr 2011 13:56:20 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vtkgr6op3ri7v4@arend-laptop>
In-Reply-To: <1302177128.3779.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 07 Apr 2011 13:52:08 +0200, Johannes Berg  
<johannes@sipsolutions.net> wrote:

> On Thu, 2011-04-07 at 13:42 +0200, Arend van Spriel wrote:
>> Hi Johannes,
>>
>> Recently I have taken a look at csa switch callback. After looking more
>> closely I decided to let mac80211 handle this itself, but I noticed
>> something strange in the interface so maybe you can clarify this.
>>
>> void (*channel_switch)(struct ieee80211_hw *hw,
>> 		       struct ieee80211_channel_switch *ch_switch);
>>
>> void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success);
>>
>> Basically we get a channel switch callback for iee80211_hw and for the
>> ieee80211_chswitch_done() the driver has to provide a vif. Should the
>> channel switch also operate on a vif?
>
> Ah, well, no, not right now anyway -- mac80211 doesn't support
> multi-channel operation yet.
>
> However, I think this kind of hw offload isn't necessary for your device
> at all.

Indeed I concluded we do not need this, but I just wanted to clarify the  
intended use of the interface.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

