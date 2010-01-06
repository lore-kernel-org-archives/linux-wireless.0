Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox1.netikka.net ([213.250.81.202]:48060 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab0AFXTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 18:19:08 -0500
Message-ID: <4B451A68.5020102@mandriva.org>
Date: Thu, 07 Jan 2010 01:19:04 +0200
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
References: <1262710858.28653.5.camel@johannes.local>	 <4B450004.9050601@mandriva.org> <1262814684.4437.0.camel@johannes.local> <4B4508A5.8050501@openwrt.org> <4B45110E.9010603@mandriva.org>
In-Reply-To: <4B45110E.9010603@mandriva.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.01.2010 00:39, Thomas Backlund wrote:
> On 07.01.2010 00:03, Felix Fietkau wrote:
>> On 2010-01-06 10:51 PM, Johannes Berg wrote:
>>> On Wed, 2010-01-06 at 23:26 +0200, Thomas Backlund wrote:
>>>
>>>> With this patch applied to 2.6.33-rc3 kernel crashes at boot...
>>>>
>>>> I have a iwl4965 connecting to a wpa2-psk encrypted network, arch is
>>>> x86_64, distro Mandriva Linux and the kernel has preempt enabled.
>>>>
>>>> Am I only missing some patches, or did I hit a real bug ?
>>>
>>> It'd help if you said what crashes and how since nobody else seems to be
>>> having that particular problem with this patch.
>> I have an idea.
>> The patch adds the following chunk of code:
>>> + if (!sta&& ra&& !is_multicast_ether_addr(ra)) {
>>> + sta = sta_info_get(sdata, ra);
>>> + if (sta)
>>> + sta_flags = get_sta_flags(sta);
>> In wireless-testing, sta_info_get takes sdata as first argument, in
>> 2.6.33-rc3 it expects a pointer to local. This should have emitted a
>> compiler warning... I saw the same thing when applying the patch to an
>> older compat-wireless snapshot.
>>
>
> Oh so it did (unfortunately the kernel build does not honour LC_ALL=C
> anymore, so the warning is in swedish):
>
>> net/mac80211/wme.c: I funktion "ieee80211_select_queue":
>> net/mac80211/wme.c:99: varning: skickar argument 1 till "sta_info_get"
>> fr?n inkompatibel pekartyp
>> net/mac80211/sta_info.h:408: anm: "struct ieee80211_local *"
>> f?rv?ntades men argumentet har typ "struct ieee80211_sub_if_data *"
>

As I cant get it from any log, and dont have a camera available right 
now, I just wrote some lines to paper wich confirms the breakage in the 
above build error...

The trace shows:

RIP: sta_info_get
ieee80211_select_queue
ieee80211_netdev_select_queue
...

Now I assume this will work ok when wireless-testing gets merged into 
main, but as this one is also tagged for stable 2.6.32, there is some 
more fixes needed to be queued for stable...

--
Thomas


