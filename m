Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:58576 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbYKEUQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 15:16:43 -0500
Received: by gxk4 with SMTP id 4so204659gxk.17
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 12:16:42 -0800 (PST)
Message-ID: <43e72e890811051214y6d6886beoa268199d6f52be84@mail.gmail.com> (sfid-20081105_211647_165395_162BB609)
Date: Wed, 5 Nov 2008 12:14:34 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/7] cfg80211: expect different rd in cfg80211 when intersecting
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225915173.3619.161.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225886489.3619.84.camel@johannes.berg>
	 <43e72e890811051155q3cf0a16exa0911675d86959ae@mail.gmail.com>
	 <1225915173.3619.161.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 11:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-05 at 11:55 -0800, Luis R. Rodriguez wrote:
>
>> >>       /* This would make this whole thing pointless */
>> >> -     BUG_ON(rd != cfg80211_regdomain);
>> >> +     if (!last_request->intersect)
>> >> +             BUG_ON(rd != cfg80211_regdomain);
>> >>
>> >>       /* update all wiphys now with the new established regulatory domain */
>> >>       update_all_wiphy_regulatory(last_request->initiator);
>> >>
>> >> -     print_regdomain(rd);
>> >> +     print_regdomain(cfg80211_regdomain);
>> >
>> > Maybe the printing here should be removed? It seems confusing now.
>>
>> Well IMHO its correct to print it here as *this* is after its been set
>> and passed through all wiphys. ACK?
>
> Ah, hmm, rd is intersected before this, right? I think I just got
> confused with the code flow, yeah, seems fine.

Yeap, OK thanks.

  Luis
