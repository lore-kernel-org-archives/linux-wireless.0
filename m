Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4518 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab3EKQUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 May 2013 12:20:05 -0400
Message-ID: <518E6FA9.3060205@broadcom.com> (sfid-20130511_182012_378860_34212BD5)
Date: Sat, 11 May 2013 18:19:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org, greearb@candelatech.com
Subject: Re: [RFC 4/4] cfg80211/mac80211: use cfg80211 wdev mutex in
 mac80211
References: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net>
 <1368187689-29706-5-git-send-email-johannes@sipsolutions.net>
 <518CE683.2040402@broadcom.com>
 <1368188814.8390.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1368188814.8390.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2013 02:26 PM, Johannes Berg wrote:
> On Fri, 2013-05-10 at 14:22 +0200, Arend van Spriel wrote:
>> On 05/10/2013 02:08 PM, Johannes Berg wrote:
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> Using separate locks in cfg80211 and mac80211 has always
>>> caused issues, for example having to unlock in places in
>>> mac80211 to call cfg80211, which even needed a framework
>>> to make cfg80211 calls after some functions returned etc.
>>>
>>> Additionally, I suspect some issues people have reported
>>> with the cfg80211 state getting confused could be due to
>>> such issues, when cfg80211 is asking mac80211 to change
>>> state but mac80211 is in the process of telling cfg80211
>>> that the state changed (in another way.)
>>
>> I guess this change affects fullmac drivers like brcmfmac, right?
>
> I don't think so.

I am asking because I noticed the following documentation change:

- * @mtx: mutex used to lock data in this struct
+ * @mtx: mutex used to lock data in this struct, may be used by drivers
+ *	and some API functions require it held

I did not look at the individual API functions, but I guess to be sure I 
should check whether we are using any of them.

Gr. AvS

