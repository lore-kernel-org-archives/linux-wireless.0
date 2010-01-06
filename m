Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox1.netikka.net ([213.250.81.202]:52648 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab0AFWjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 17:39:13 -0500
Message-ID: <4B45110E.9010603@mandriva.org>
Date: Thu, 07 Jan 2010 00:39:10 +0200
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
References: <1262710858.28653.5.camel@johannes.local>	 <4B450004.9050601@mandriva.org> <1262814684.4437.0.camel@johannes.local> <4B4508A5.8050501@openwrt.org>
In-Reply-To: <4B4508A5.8050501@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.01.2010 00:03, Felix Fietkau wrote:
> On 2010-01-06 10:51 PM, Johannes Berg wrote:
>> On Wed, 2010-01-06 at 23:26 +0200, Thomas Backlund wrote:
>>
>>> With this patch applied to 2.6.33-rc3 kernel crashes at boot...
>>>
>>> I have a iwl4965 connecting to a wpa2-psk encrypted network, arch is
>>> x86_64, distro Mandriva Linux and the kernel has preempt enabled.
>>>
>>> Am I only missing some patches, or did I hit a real bug ?
>>
>> It'd help if you said what crashes and how since nobody else seems to be
>> having that particular problem with this patch.
> I have an idea.
> The patch adds the following chunk of code:
>> +	if (!sta&&  ra&&  !is_multicast_ether_addr(ra)) {
>> +		sta = sta_info_get(sdata, ra);
>> +		if (sta)
>> +			sta_flags = get_sta_flags(sta);
> In wireless-testing, sta_info_get takes sdata as first argument, in
> 2.6.33-rc3 it expects a pointer to local. This should have emitted a
> compiler warning... I saw the same thing when applying the patch to an
> older compat-wireless snapshot.
>

Oh so it did (unfortunately the kernel build does not honour LC_ALL=C 
anymore, so the warning is in swedish):

> net/mac80211/wme.c: I funktion "ieee80211_select_queue":
> net/mac80211/wme.c:99: varning: skickar argument 1 till "sta_info_get" fr?n inkompatibel pekartyp
> net/mac80211/sta_info.h:408: anm: "struct ieee80211_local *" f?rv?ntades men argumentet har typ "struct ieee80211_sub_if_data *"

--
Thomas
