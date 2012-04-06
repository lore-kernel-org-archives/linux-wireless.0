Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60288 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2DFUJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 16:09:34 -0400
Received: by iagz16 with SMTP id z16so3510519iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 13:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFED-jkaA8S6a9qSxF0SgwoexEAQvFUqF1WmVLBx-__GhRaS0g@mail.gmail.com>
References: <CAFED-jmkmF=9egOvvRK49=2HYMg_jiAUdW=5XQ2SyFwYXDb1OQ@mail.gmail.com>
 <1333630881.3494.15.camel@jlt3.sipsolutions.net> <CAFED-j=jReYjht2TazFmYnqzJHkS-=My-_4MDRmbtBfvGz_Txw@mail.gmail.com>
 <CAFED-jnO235WRNT34DN6OAUKPgeT6t0eWdHK+9_gz7dTvdMTgQ@mail.gmail.com> <CAFED-jkaA8S6a9qSxF0SgwoexEAQvFUqF1WmVLBx-__GhRaS0g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 6 Apr 2012 13:09:13 -0700
Message-ID: <CAB=NE6UjODcjwPz02Hmf2WAfrVBhUdM2HyAngDJt4-f7Ln6XBg@mail.gmail.com> (sfid-20120406_220938_030748_DCD28BCF)
Subject: Re: compat-wireless-2012-04-04 - rmmod mac80211 and PC freeze
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/4/5 Janusz Dziedzic <janusz.dziedzic@gmail.com>:
> W dniu 6 kwietnia 2012 07:16 użytkownik Janusz Dziedzic
> <janusz.dziedzic@gmail.com> napisał:
>> W dniu 6 kwietnia 2012 07:00 użytkownik Janusz Dziedzic
>> <janusz.dziedzic@gmail.com> napisał:
>>> W dniu 5 kwietnia 2012 15:01 użytkownik Johannes Berg
>>> <johannes@sipsolutions.net> napisał:
>>>> On Thu, 2012-04-05 at 14:35 +0200, Janusz Dziedzic wrote:
>>>>> Hello,
>>>>>
>>>>> I am using: compat-wireless-2012-04-04
>>>>>
>>>>> I am doing such test:
>>>>> - insmod compat.ko
>>>>> - insmod cfg80211.ko
>>>>> - insmod mac80211.ko
>>>>>
>>>>> After that:
>>>>> - rmmod mac80211
>>>>>
>>>>> And have PC freeze.
>>>>> Linux uw000950 2.6.35-32-generic #67~lucid1-Ubuntu SMP Tue Mar 6
>>>>> 17:48:20 UTC 2012 x86_64 GNU/Linux
>>>>
>>>> Works for me, but on 3.1.0.
>>>>
>>>>> Any idea what could be wrong, how to debug in case of such freeze?
>>>>
>>>> Not really. You could try the same thing from a console, rather than an
>>>> X terminal window (that I'm guessing you're using since you saw no
>>>> further info) and you may see some more details?
>>>>
>>>> johannes
>>>>
>>>
>>> Seems when run from console I see:
>>> Kernel panic - not syncing: Fatal exception in interrupt
>>> BUG: scheduling while atomic: rmmod/15474/0x10008803
>>>
>>> Next a lot of information connected with dump.
>>>
>>>
>>
>> After second try:
>> BUG: unable to handle kernel paging request at ffffffff98d60d20
>> IP: update_curr+0x134/0x1e0
>> Thread overran stack, or stack corrupted
>> Process rmmod
>>
>
> Issue not reproducible with compat-wireless-2012-03-18.
> Seems introduced in compat-wireless-2012-04-03.

Since you are not loading drivers this may be due to new changes in
compat.git. You can bisect there, perhaps either
e4e6f33801d78ad3b71836ce8a3058235fdaa6ef or
80bf8a835893ae35db13e3ea6f5b984352019fbe.

  Luis
