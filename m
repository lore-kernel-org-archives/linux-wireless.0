Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:53825 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0AGKlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 05:41:22 -0500
Message-ID: <4B45BA4F.7000206@mandriva.org>
Date: Thu, 07 Jan 2010 12:41:19 +0200
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
References: <1262710858.28653.5.camel@johannes.local>	 <4B450004.9050601@mandriva.org> <1262814684.4437.0.camel@johannes.local>	 <4B4508A5.8050501@openwrt.org> <4B45110E.9010603@mandriva.org>	 <4B451A68.5020102@mandriva.org> <1262847445.3414.0.camel@johannes.local>
In-Reply-To: <1262847445.3414.0.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.01.2010 08:57, Johannes Berg wrote:
> On Thu, 2010-01-07 at 01:19 +0200, Thomas Backlund wrote:
>
>>>> net/mac80211/wme.c: I funktion "ieee80211_select_queue":
>>>> net/mac80211/wme.c:99: varning: skickar argument 1 till
>> "sta_info_get"
>>>> fr?n inkompatibel pekartyp
>>>> net/mac80211/sta_info.h:408: anm: "struct ieee80211_local *"
>>>> f?rv?ntades men argumentet har typ "struct ieee80211_sub_if_data *"
>>>
>>
>> As I cant get it from any log, and dont have a camera available right
>> now, I just wrote some lines to paper wich confirms the breakage in
>> the
>> above build error...
>>
>> The trace shows:
>>
>> RIP: sta_info_get
>
> Well as the message tells you, sta_info_get needs a local argument in
> your tree, rather than 'sdata', so you can just do 'sdata->local'
> there ...... It doesn't need any particular fixups, just a bit of merge
> resolving ...
>

Yeah,
that was it...

Now it works as intended!

Thanks!

--
Thomas
