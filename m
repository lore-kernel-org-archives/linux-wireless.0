Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.233]:56896 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYHAPVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 11:21:41 -0400
Received: by qb-out-0506.google.com with SMTP id a16so1091169qbd.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 08:21:40 -0700 (PDT)
Message-ID: <48932A10.8080004@tuffmail.co.uk> (sfid-20080801_172150_071211_2B20AAE9)
Date: Fri, 01 Aug 2008 16:21:52 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>, tomasw@gmail.com,
	Dave Young <hidave.darkstar@gmail.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linville@tuxdriver.com, Pekka Enberg <penberg@cs.helsinki.fi>,
	ath5k-devel@venema.h4ckr.net, johannes@sipsolutions.net,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k : ath5k_config_interface deadlock
 fix
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>		<4892C359.9000304@cs.helsinki.fi>		<20080801011415.ff4821a3.akpm@linux-foundation.org>	<b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com> <4893257C.1020907@gmail.com>
In-Reply-To: <4893257C.1020907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby wrote:
> Bob Copeland napsal(a):
>   
>> On Fri, Aug 1, 2008 at 4:14 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>     
>>> On Fri, 01 Aug 2008 11:03:37 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>>
>>>       
>>>> Jiri Slaby wrote:
>>>>         
>>>>> Dave Young napsal(a):
>>>>>           
>>>>>> In the drivers/net/wireless/ath5k/base.c, there's recursive locking of
>>>>>> sc->lock
>>>>>>             
>>>>> Should be fixed already:
>>>>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97
>>>>>           
>>>> I guess that didn't make it to -stable?
>>>>         
>>> (cc stable!)
>>>       
>> Not to worry, the commit that introduced it was
>> 9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
>> came in after 2.6.26.
>>     
>
> git-describe 9d139c810a2aa17365cc548d0cd2a189d8433c65
> v2.6.26-rc8-1219-g9d139c8
>
>   
Jiri Slaby wrote:
> Bob Copeland napsal(a):
>   
>> On Fri, Aug 1, 2008 at 4:14 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>     
>>> On Fri, 01 Aug 2008 11:03:37 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>>
>>>       
>>>> Jiri Slaby wrote:
>>>>         
>>>>> Dave Young napsal(a):
>>>>>           
>>>>>> In the drivers/net/wireless/ath5k/base.c, there's recursive locking of
>>>>>> sc->lock
>>>>>>             
>>>>> Should be fixed already:
>>>>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97
>>>>>           
>>>> I guess that didn't make it to -stable?
>>>>         
>>> (cc stable!)
>>>       
>> Not to worry, the commit that introduced it was
>> 9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
>> came in after 2.6.26.
>>     
>
> git-describe 9d139c810a2aa17365cc548d0cd2a189d8433c65
> v2.6.26-rc8-1219-g9d139c8
>   
Unfortunately git-describe can be misleading.

All this tells you is that the commit in question was based on (a
descendant of) v2.6.26-rc8.  It doesn't tell you whether the patch is
present in v2.6.26.

There must be a better way (for efficient merges, right?).  But all I
can think of is comparing the files in question against the diff.  I
checked myself and the changes don't appear to have been included in
v2.6.26.

Alan
