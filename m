Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46241 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0JOSB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 14:01:26 -0400
Received: by ewy20 with SMTP id 20so1322413ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 11:01:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB7F7C7.7030804@gmx.net>
References: <4CB6BE57.8010401@gmx.net> <1287071844.11341.5.camel@gnutoo-laptop>
 <AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>
 <4CB74759.3030807@gmx.net> <AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>
 <4CB7F7C7.7030804@gmx.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 15 Oct 2010 11:01:04 -0700
Message-ID: <AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>
Subject: Re: Compat-wireless N900
To: George <george.news@gmx.net>
Cc: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 11:42 PM, George <george.news@gmx.net> wrote:
> On 14/10/2010 20:03, Luis R. Rodriguez wrote:
>>
>> On Thu, Oct 14, 2010 at 11:09 AM, George<george.news@gmx.net>  wrote:
>>
>>> I have tried using even insmod and the modules load perfectly but the
>>> wlan
>>> device doesn't show up.
>>
>> Then that likely means you are not loading the right module.
>>
>>> In dmesg nothing is displayed except for the cfg80211 and when I rmmod
>>> the
>>> module wl1251 (wl1251: removed or similar)
>>>
>>> I'm still wondering what the hell I have to do.
>>
>> Are you sure you have the right module?
>
> Yes. The driver is the wl1251 family. As I said in previous posts and from
> what some guys in the IRC channel tried to guess, it seems that the problem
> might be in that the spi interface is specific for any device, and in the
> n900 might be different from the one implemented in compat-wireless.

Heh, nope.

> I'm a bit suprised about this fact, but they know more than I.

Or, we had not yet accommodated yet for the fact that the wl1251
driver was split out into its own directory from the original wl12xx/
directory and no one ever sent a patch to fix this on compat-wireless.
I just fixed this on today's compat-wireless, so you can try that
around noon PST time when the new tarball will be generated. Ah but
there are some pcmcia crap compile issues, we just have to remove
pcmcia support, well not now, I have other stuff to do.

I welcome patches if someone gets to it.

  Luis
