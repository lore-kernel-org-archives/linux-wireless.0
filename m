Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36173 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbGBKjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 06:39:20 -0400
Received: by wguu7 with SMTP id u7so59427783wgu.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 03:39:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEf4jC6-au4KQ7SrBtUAyq1LmOqFrT_PLrDZ8ER8ZpR1SA@mail.gmail.com>
References: <CA+BoTQm==AM3F2Fxq6T_+uY+jq0yXc9JHFT0iwpe2XJrmxkSsg@mail.gmail.com>
	<1435826335.2285.6.camel@sipsolutions.net>
	<CAB3XZEf4jC6-au4KQ7SrBtUAyq1LmOqFrT_PLrDZ8ER8ZpR1SA@mail.gmail.com>
Date: Thu, 2 Jul 2015 12:39:19 +0200
Message-ID: <CA+BoTQkbmJxS32BwKZSbMxVruKzzRjOSpsTa39ySSownqLAcQg@mail.gmail.com> (sfid-20150702_123924_668324_C290E765)
Subject: Re: Association race when acting as AP?
From: Michal Kazior <michal.kazior@tieto.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 July 2015 at 10:43, Eliad Peller <eliad@wizery.com> wrote:
> On Thu, Jul 2, 2015 at 11:38 AM, Johannes Berg <johannes@sipsolutions.net>
> wrote:
>>
>> [please try to send w/o html if you're CC'ing the linux-wireless list]
>>
>> > To me this looks like a race in hostapd. The station should be
>> > installed to driver _before_ sending Assoc Resp frame, not after. My
>> > quick-n-dirty hack seems to help:
>> >
>> [...]
>> > Is anyone aware of this problem already? Anyone working on it? Any
>> > gotchas I should be aware of before I go into fixing this in a proper
>> > way? Or am I missing something and this isn't actually a problem?
>>
>> The TI folks had a similar patch that broke open networks, not sure
>> what was wrong there.
>>
> there was some implementation error. it was fixed later on.
>
> also, take a look at this thread:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/88421

Thanks! Looks like you guys hit this with EAPOL frames. I'll look into it more.

Is there any particular reason why these TI-OpenLink patches weren't
submitted/merged to hostap?


Michał
