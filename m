Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:56707 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab0DIHAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 03:00:37 -0400
Received: by iwn35 with SMTP id 35so2069075iwn.21
        for <linux-wireless@vger.kernel.org>; Fri, 09 Apr 2010 00:00:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <k2ra32f33a41004082354y2bf33919y7f0f476b62612cf6@mail.gmail.com>
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
	<1270763437-29526-5-git-send-email-gwingerde@gmail.com> <201004090032.53842.IvDoorn@gmail.com>
	<j2p646765f41004081653vcb4e0178k374a203da36a9f1@mail.gmail.com>
	<k2ra32f33a41004082354y2bf33919y7f0f476b62612cf6@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 9 Apr 2010 17:00:14 +1000
Message-ID: <h2t646765f41004090000o607f02al34df4b3556019a24@mail.gmail.com>
Subject: Re: [PATCH 4/9] rt2x00: Remove rt2800 version constants.
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 9, 2010 at 16:54, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> On Fri, Apr 9, 2010 at 1:53 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> On Fri, Apr 9, 2010 at 08:32, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>>> On Thursday 08 April 2010, Gertjan van Wingerde wrote:
>>>> The rt2800 version constants are inconsistent, and the version number don't
>>>> mean a lot of things anyway. Use the literal values in the code instead of
>>>> some sort of fabricated version name macro.
>>>>
>>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>>
>>> Perhaps a more elegant way of using and defining needs to be found.
>>> But at least the defined show what the purpose for the values is
>>> rather then having magical values spread around the code.
>>
>> Maybe something like:
>>
>> #define RTDEV_IS_RT2883_R1(dev) (rt2x00_rt(dev, RT2883) && \
>>                                                   rt2x00_rev(dev) < 0x0300)
>
> I considered this as well, but we have many checks which either do
>    rt2x00_rev() < 0xffff
> but also
>    rt2x00_ref() == 0xffff

I assume that there are certain ranges of revisions that correspond to
certain chips with certain ... features. So, you could have:

#define RTDEV_IS_RT2883_R1(dev) (rt2x00_rt(dev, RT2883) && \
                                                  rt2x00_rev(dev) < 0x0300)

for the original chip, then

#define RTDEV_IS_RT2883_R2(dev) (rt2x00_rt(dev, RT2883) && \
                                                  rt2x00_rev(dev) >= 0x0300 && \
                                                  rt2x00_rev(dev) < 0x1000)

for the troubled second version and

#define RTDEV_IS_RT2883_R3(dev) (rt2x00_rt(dev, RT2883) && \
                                                  rt2x00_rev(dev) >= 0x1000)

as a catch all for newer chips.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
