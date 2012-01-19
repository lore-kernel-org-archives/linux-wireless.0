Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35514 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2ASNJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 08:09:27 -0500
Received: by ggnb1 with SMTP id b1so827190ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2012 05:09:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1326976540.3324.3.camel@jlt3.sipsolutions.net>
References: <20120119082956.486569312@sipsolutions.net>
	<20120119083102.873553392@sipsolutions.net>
	<CAB3XZEd9F+0oOeSmn4UWPZ2iwWdRZ83KcRYRfD4q8ZrGm7m=4Q@mail.gmail.com>
	<1326976540.3324.3.camel@jlt3.sipsolutions.net>
Date: Thu, 19 Jan 2012 15:09:27 +0200
Message-ID: <CAB3XZEc5o5fqPvVUGgN4h3e56kMmm3u3m9gg4FbRG0UbeQ-Rhw@mail.gmail.com> (sfid-20120119_140948_408753_D26B8083)
Subject: Re: [PATCH 2/2] mac80211: make CQM RSSI support per virtual interface
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 19, 2012 at 2:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-01-19 at 13:37 +0200, Eliad Peller wrote:
>> On Thu, Jan 19, 2012 at 10:29 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > Similar to the previous beacon filtering patch,
>> > make CQM RSSI support depend on the flags that
>> > the driver set for virtual interfaces.
>> >
>> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> > ---
>> [...]
>>
>> >
>> > -       if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)) {
>> > -               if (sdata->vif.type != NL80211_IFTYPE_STATION)
>> > -                       return -EOPNOTSUPP;
>> > -               return 0;
>> > -       }
>> > -
>> >        /* tell the driver upon association, unless already associated */
>> > -       if (sdata->u.mgd.associated)
>> > +       if (sdata->u.mgd.associated &&
>> > +           sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
>> >                ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
>> >
>> should you return EOPNOTSUPP if the vif doesn't support it?
>
> No. The code above that checks the type is useless as cfg80211 already
> checks the type, and we do support this in software in mac80211 if
> there's no HW offload for it.
>
right. thanks.

Eliad.
