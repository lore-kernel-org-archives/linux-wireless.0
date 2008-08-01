Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:20099 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYHAPVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 11:21:45 -0400
Received: by fk-out-0910.google.com with SMTP id 18so905946fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 08:21:43 -0700 (PDT)
Message-ID: <48932A0A.8020702@gmail.com> (sfid-20080801_172149_579770_51CAAFF7)
Date: Fri, 01 Aug 2008 17:21:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Dave Young <hidave.darkstar@gmail.com>,
	johannes@sipsolutions.net, tomasw@gmail.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	stable@kernel.org
Subject: Re: [PATCH] ath5k : ath5k_config_interface deadlock fix
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>	 <4892C359.9000304@cs.helsinki.fi>	 <20080801011415.ff4821a3.akpm@linux-foundation.org> <b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com> <4893257C.1020907@gmail.com>
In-Reply-To: <4893257C.1020907@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby napsal(a):
> Bob Copeland napsal(a):
>> On Fri, Aug 1, 2008 at 4:14 AM, Andrew Morton 
>> <akpm@linux-foundation.org> wrote:
>>> On Fri, 01 Aug 2008 11:03:37 +0300 Pekka Enberg 
>>> <penberg@cs.helsinki.fi> wrote:
>>>
>>>> Jiri Slaby wrote:
>>>>> Dave Young napsal(a):
>>>>>> In the drivers/net/wireless/ath5k/base.c, there's recursive 
>>>>>> locking of
>>>>>> sc->lock
>>>>> Should be fixed already:
>>>>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97 
>>>>>
>>>> I guess that didn't make it to -stable?
>>> (cc stable!)
>>
>> Not to worry, the commit that introduced it was
>> 9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
>> came in after 2.6.26.
> 
> git-describe 9d139c810a2aa17365cc548d0cd2a189d8433c65
> v2.6.26-rc8-1219-g9d139c8

Fingers faster than brain. Why such a change went into -rc8? How long has 
this been in linux-next? It appeared in mmotm between 2008-07-15-15-39 and 
2008-07-23-02-07 which I think correspond to -next appearance -- isn't it 
way too fast?
