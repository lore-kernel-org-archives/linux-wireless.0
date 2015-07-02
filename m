Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33918 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbbGBMpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 08:45:05 -0400
Received: by iebmu5 with SMTP id mu5so55393228ieb.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 05:45:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQkbmJxS32BwKZSbMxVruKzzRjOSpsTa39ySSownqLAcQg@mail.gmail.com>
References: <CA+BoTQm==AM3F2Fxq6T_+uY+jq0yXc9JHFT0iwpe2XJrmxkSsg@mail.gmail.com>
	<1435826335.2285.6.camel@sipsolutions.net>
	<CAB3XZEf4jC6-au4KQ7SrBtUAyq1LmOqFrT_PLrDZ8ER8ZpR1SA@mail.gmail.com>
	<CA+BoTQkbmJxS32BwKZSbMxVruKzzRjOSpsTa39ySSownqLAcQg@mail.gmail.com>
Date: Thu, 2 Jul 2015 15:45:04 +0300
Message-ID: <CAB3XZEcsA16aWbMazdz0hCKqkfbj45+6366m_u913bfkO-Ti7Q@mail.gmail.com> (sfid-20150702_144509_307819_05D3644B)
Subject: Re: Association race when acting as AP?
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 2, 2015 at 1:39 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 2 July 2015 at 10:43, Eliad Peller <eliad@wizery.com> wrote:
>> On Thu, Jul 2, 2015 at 11:38 AM, Johannes Berg <johannes@sipsolutions.net>
>> wrote:
>>>
>>> [please try to send w/o html if you're CC'ing the linux-wireless list]
>>>
>>> > To me this looks like a race in hostapd. The station should be
>>> > installed to driver _before_ sending Assoc Resp frame, not after. My
>>> > quick-n-dirty hack seems to help:
>>> >
>>> [...]
>>> > Is anyone aware of this problem already? Anyone working on it? Any
>>> > gotchas I should be aware of before I go into fixing this in a proper
>>> > way? Or am I missing something and this isn't actually a problem?
>>>
>>> The TI folks had a similar patch that broke open networks, not sure
>>> what was wrong there.
>>>
>> there was some implementation error. it was fixed later on.
>>
>> also, take a look at this thread:
>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/88421
>
> Thanks! Looks like you guys hit this with EAPOL frames. I'll look into it more.
>
> Is there any particular reason why these TI-OpenLink patches weren't
> submitted/merged to hostap?
>
nothing particular, AFAIR.
they needed further review/cleanup before upstream, and we just didn't
get to it.

Eliad.
