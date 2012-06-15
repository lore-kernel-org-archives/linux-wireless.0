Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49156 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2FOCDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 22:03:24 -0400
Received: by yenl2 with SMTP id l2so1512756yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 19:03:24 -0700 (PDT)
Message-ID: <4FDA97E5.3090208@lwfinger.net> (sfid-20120615_040354_190001_21204ACC)
Date: Thu, 14 Jun 2012 21:03:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Andre Heider <a.heider@gmail.com>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i]
 >= n_queues))
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>  <CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>  <4FD22727.7000500@lwfinger.net>  <1339180580.5748.32.camel@jlt3.sipsolutions.net>  <1339180948.5748.35.camel@jlt3.sipsolutions.net>  <1339182289.5748.36.camel@jlt3.sipsolutions.net>  <1339576294.4519.17.camel@jlt3.sipsolutions.net>  <CAHsu+b9soGKgZmqWLU=-v0zOG0v_Arf8DFoCn1EQ7-86Mg_CdQ@mail.gmail.com>  <1339602402.4519.48.camel@jlt3.sipsolutions.net>  <20120613204230.474d1b6c@milhouse>  <CAHsu+b_ue7LknbwMCdYsK6pQ8XxwjCL8Ham3xLucaaXZab69-g@mail.gmail.com>  <1339691877.9786.0.camel@jlt3.sipsolutions.net>  <CAHsu+b9XNO5roFZNETAgs8_5OLymCaKNcTU1XUsc2fXBu+4kpg@mail.gmail.com>  <1339693777.9786.6.camel@jlt3.sipsolutions.net>  <1339694227.9786.7.camel@jlt3.sipsolutions.net>  <CAHsu+b85rvSsGBfJQFFjdMhrF=Ycw0+pxxjf=U=xA2Or2q9jXQ@mail.gmail.com>  (sfid-20120614_192302_952190_7ED159EF) <1339694837.9786.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339694837.9786.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/14/2012 12:27 PM, Johannes Berg wrote:
> On Thu, 2012-06-14 at 19:23 +0200, Andre Heider wrote:
>> On Thu, Jun 14, 2012 at 7:17 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Thu, 2012-06-14 at 19:09 +0200, Johannes Berg wrote:
>>>> On Thu, 2012-06-14 at 19:00 +0200, Andre Heider wrote:
>>>>
>>>>>> http://p.sipsolutions.net/9c830800d14f3ff8.txt
>>>>>
>>>>> This still oopses: if (!modparam_qos || wldev->fw.opensource)
>>>>>
>>>>> I do get a working wlan0 if I force "hw->queues = 1;" without that
>>>>> offending line, but just a `dmesg` over wlan+ssh yields another one
>>>>> (prolly the same one I already described on an older patch):
>>>>> http://i.imgur.com/epdRF.jpg
>>>>
>>>> Doh, of course, I still have wldev ... I'm in a meeting now, will check
>>>> again later.
>>>
>>> Let's just move the hw->queues setup ...
>>>
>>> http://p.sipsolutions.net/e45e57bbc9509e69.txt
>>
>> No oops during loading the fw or bringing the device up, but same
>> crash as in the picture above ;)
>
> I guess I shouldn't be doing this right now ...
>
> Can't somebody else help me out? Rafal? Larry? Michael? I clearly don't
> know this code well enough and you should be able to identify the intent
> from the patch ...

I will give it a try. I was in the Canadian wilderness for 5 days fishing, which 
is why I have not responded earlier.

The device does not fail on my hardware, but I can prepare things for Andre to test.

Larry

