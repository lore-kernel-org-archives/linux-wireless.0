Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53028 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1K2Rpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 12:45:43 -0500
Received: by vbbfc26 with SMTP id fc26so4986652vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 09:45:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322585242.4110.23.camel@jlt3.sipsolutions.net>
References: <CA++WF2O0WjyqU0HEGR1XE9xDFzR+sxRboVWexRCMPi8okOVkkA@mail.gmail.com>
 <1322338254.4283.2.camel@jlt3.sipsolutions.net> <1322338337.4283.3.camel@jlt3.sipsolutions.net>
 <CA++WF2Op0dScq=coD=qkjqE-Q3ncOVjWVfFsF6sWUi0M5To=7g@mail.gmail.com> <1322585242.4110.23.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 29 Nov 2011 12:45:21 -0500
Message-ID: <CAB=NE6Xp7qFgbNqHXEzzjWp-PeuO3OHNA2ycfoQWeKDzfY3giw@mail.gmail.com> (sfid-20111129_184546_292354_82D4D4BE)
Subject: Re: Converting ipw2x00 driver to mac80211 framework
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 29, 2011 at 11:47 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-11-29 at 08:33 -0800, Stanislav Yakovlev wrote:
>> >> It would be much less risky to convert the entire thing to cfg80211, I
>> >> think, basically just replacing the configuration layer in libipw_wx.c
>> >> with a cfg80211 based one.
>> >
>> > It might also be a good idea to do some cleanups first -- e.g. I notice,
>> > just in a random look at the code, that reset_port isn't used anywhere
>> > so all code related to that can be removed...
>>
>> Do I understand correctly that you suggest remove reset_port from
>> libipw_device struct
>> and remove all code like this:
>>
>> -          if (ieee->reset_on_keychange &&
>> -              ieee->iw_mode != IW_MODE_INFRA &&
>> -              ieee->reset_port && ieee->reset_port(dev)) {
>> -                 LIBIPW_DEBUG_WX("%s: reset_port failed\n", dev->name);
>> -                 return -EINVAL;
>> -         }
>>
>> from libipw_wx.c ?
>
> Right. There might be more of this too. That'd just help with converting
> since you wouldn't have to think about converting this at all.

Would you be up to convert prism54 too? :)

  Luis
