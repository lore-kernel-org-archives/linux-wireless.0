Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36992 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333AbcDLUCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 16:02:15 -0400
Received: by mail-wm0-f46.google.com with SMTP id n3so42354307wmn.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2016 13:02:15 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: remove enum ieee80211_band
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1460469487-21008-1-git-send-email-johannes@sipsolutions.net>
 <570D5243.6070204@broadcom.com> <1460491100.6369.27.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <570D5446.4060609@broadcom.com> (sfid-20160412_220219_150513_D2AAA89C)
Date: Tue, 12 Apr 2016 22:02:14 +0200
MIME-Version: 1.0
In-Reply-To: <1460491100.6369.27.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12-04-16 21:58, Johannes Berg wrote:
> On Tue, 2016-04-12 at 21:53 +0200, Arend van Spriel wrote:
>>
>> On 12-04-16 15:58, Johannes Berg wrote:
>>>
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> This enum is already perfectly aliased to enum nl80211_band, and
>>> the only reason for it is that we get IEEE80211_NUM_BANDS out of
>>> it. There's no really good reason to not declare the number of
>>> bands in nl80211 though, so do that and remove the cfg80211 one.
>> So what if a band is added. That would change the value of
>> IEEE80211_NUM_BANDS in nl80211. Is it not ABI?
> 
> Well, it can't be ABI really since the value is never used. Arguably it
> becomes API, but clearly we have the same with NL80211_CMD_MAX and many
> others like it, so I see no point in treating the bands here specially.
> I even added a comment :)

Ah. Clearly I only read the commit message :-p Sorry for the noise.

Gr. AvS

> johannes
> 
