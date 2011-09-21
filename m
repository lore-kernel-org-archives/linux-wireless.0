Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64026 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1IUTzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 15:55:42 -0400
Received: by yxl31 with SMTP id 31so1447337yxl.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 12:55:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7A1868.1040401@adurom.com>
References: <1316623059.3940.54.camel@jlt3.sipsolutions.net> <4E7A1868.1040401@adurom.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 21 Sep 2011 12:55:22 -0700
Message-ID: <CAB=NE6XszMAu2DOiA9qgMjqCSnZ+dBx1PZ9rNBkgeAaT1Y1okA@mail.gmail.com> (sfid-20110921_215550_192514_9B756A9E)
Subject: Re: client powersave is completely broken on ath9k and similar HW
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 10:01 AM, Kalle Valo <kvalo@adurom.com> wrote:
> On 09/21/2011 07:37 PM, Johannes Berg wrote:
>> iwconfig wlan0 power timeout 0
>> iwconfig wlan0 power off
>> iwconfig wlan0 power on
>>
>> => observe that power saving stays disabled forever
>>
>> Last little bit of http://paste.pocoo.org/raw/479987/ seems to make it
>> work somewhat, but is then still completely broken when timeout is >0
>> due to the abuse of the dynps timer/work to process tx status:
>>
>> Clearly this is completely messed up. Somebody is going to need to pay
>> back all the technical debt accumulated here and rewrite it all.
>
> I think we should just remove the client PS support from mac8011 and
> drivers instead should implement power save on their own. The current
> setup simply don't work.
>
> My reasoning:
>
> 1) all power save implementations in hardware are a bit different, which
> makes mac80211 implementation complex (how many different designs do we
> support now, three or four?)
>
> 2) Driver authors care only about their driver and the bugs they are
> trying to fix with zero interest how it might affect other drivers. They
> dump something to mac80211 and then the change is forgotten.
>
> 3) Power save bugs are difficult to notice, test and debug. So
> regressions are easily missed.
>
> 4) If the power save support is implemented in the driver, they can't
> break other drivers and are free to do whatever optimisations/fixes they
> want.
>
> I'm happy to create a patch to remove client PS code from mac80211 if we
> so decide.

Removal of code from mac80211 is not sufficient, an equivalent
replacement for each driver that does use this code is already
required.

  Luis
