Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39951 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760815AbZCSV4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 17:56:01 -0400
Received: by ewy9 with SMTP id 9so550747ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 14:55:57 -0700 (PDT)
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Message-Id: <67857DA5-1808-4477-A13F-5E0C3551CBD7@icix.org> (sfid-20090319_225620_059356_AB223B8B)
From: Antonio Marques <froz@icix.org>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1237383373.5100.24.camel@johannes.local>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: rt2x00 mesh support
Date: Thu, 19 Mar 2009 21:55:54 +0000
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903181348.51609.IvDoorn@gmail.com> <1237381972.5100.21.camel@johannes.local> <200903181431.43048.IvDoorn@gmail.com> (sfid-20090318_143216_017913_36914372) <1237383373.5100.24.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 18, 2009, at 13:36 , Johannes Berg wrote:
> On Wed, 2009-03-18 at 14:31 +0100, Ivo van Doorn wrote:
>
>>> ->config() coming after it makes no sense either but we haven't even
>>> tried to avoid that so far... In fact, it is perfectly legal for
>>> ->config() to be called after ->config_interface() when, for  
>>> example,
>>> you change the channel. Not that I disagree -- we should be  
>>> setting the
>>> beacon interval before enabling beaconing...
>>
>> True, the problem however is that when enabling the radio it is  
>> possible/likely
>> that a lot of settings will be lost. For rt2x00 we must reset  
>> almost all registers
>> to make sure everything is set correctly again.
>
> Yeah, that makes sense... I just don't know how to handle it.
>
>>> What exactly is the problem here? The fact that we don't enable the
>>> radio until after having configured beaconing? I'm not sure how to  
>>> solve
>>> this, to be honest.
>>
>> Neither do I, perhaps we should make sure that a call to config()  
>> when
>> the enabled_radio field has changed should trigger additional  
>> reconfigurations
>> as well. But I don't really like such a solution.. :(
>
> We could do that, but there's no limit to what that would be, up to
> requiring basically a call to __ieee80211_resume() (from pm.c)...
>
>> Perhaps should check if a beacon was provided while the radio was  
>> off,
>> and either request a new beacon or upload the previously provided  
>> beacon when
>> the radio is being enabled.
>
> I'm thinking that will be necessary, imagine we integrate rfkill in
> mac80211 like we should, and set radio_enabled = false while being an
> IBSS member?
>
> OTOH, this problem hitting a number of drivers suggests we should  
> find a
> generic fix.
>
> johannes

Thank you Johannes and Ivo for helping to narrow down this problem.  
Would
storing the beacon configuration in the driver before clearing the  
registers and then
reloading it be an adequate short-term solution for fixing this issue  
on rt2x00? Some
other drivers (b43, ath5k) seem to overcome this shortcoming in the  
way the function
calls are ordered. Although a generic fix would be great, fixing this  
on rt2x00 would
greatly increase the number of devices supporting mesh point mode.

Antonio Marques


