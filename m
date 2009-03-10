Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:30625 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZCJIvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 04:51:43 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2479992wfa.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 01:51:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236674791.9658.36.camel@johannes.local>
References: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
	 <1236650699-30538-4-git-send-email-lrodriguez@atheros.com>
	 <1236669329.9658.30.camel@johannes.local>
	 <43e72e890903100143i76015377x31529b26b638275c@mail.gmail.com>
	 <1236674791.9658.36.camel@johannes.local>
Date: Tue, 10 Mar 2009 01:51:41 -0700
Message-ID: <43e72e890903100151y1427c505jc8cace0e378d732e@mail.gmail.com> (sfid-20090310_095146_439158_9783670E)
Subject: Re: [PATCH 3/4] mac80211: disallow HT40 if max channel bandwidth is
	less than 40 MHz
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 1:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-03-10 at 01:43 -0700, Luis R. Rodriguez wrote:
>
>> >> + =C2=A0 =C2=A0 if (conf_is_ht40(&local->hw.conf) && chan->max_ba=
ndwidth < 40)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
>> >> +
>> >
>> > You just made nl80211 check this, why bother adding it here too?
>>
>> Wext crap.
>
> Wext can't set ht40, it'll always reset back to 20mhz when you set
> channel with wext.

Ah, but we can eventually get there with setting the ssid, guess I'll
have to review that path.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
