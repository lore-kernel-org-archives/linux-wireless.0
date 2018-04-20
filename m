Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37048 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753850AbeDTGz7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 02:55:59 -0400
Message-ID: <1524207356.23123.8.camel@sipsolutions.net> (sfid-20180420_085604_020276_8F60D2D4)
Subject: Re: [PATCH] reg: Rename confusing 'country IE' in log output
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Gabler <Bernhard_Gabler@web.de>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Date: Fri, 20 Apr 2018 08:55:56 +0200
In-Reply-To: <8ced0b02-af10-4d9d-9a68-cc08643a5cda@web.de>
References: <20180419091738.9068-1-toke@toke.dk>
         <8ced0b02-af10-4d9d-9a68-cc08643a5cda@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-04-20 at 00:32 +0200, Bernhard Gabler wrote:

> looking at the patch, I see more occurences of the outdated "IE" in a 
> constant name and function name:
> 
>          case NL80211_REGDOM_SET_BY_COUNTRY_IE:
> or
>          reg_process_hint_country_ie()


Right. I searched for further strings that would show up to the user,
but didn't see any, but the code still refers to it in many places.

> Would it make sense to likewise fix these (and possibly more) 
> occurrences too, to match the spec from 2016?
> For the sake of readability and consistency of code ...

I dunno. Country IE isn't the only place where "IE" is used, it's even
used in struct names (struct ieee80211_tim_ie, and many others), so I
would think that people who actually work on the code will have to be
aware of the previous wording of "Information Element" (and the
abbreviation IE) anyway. Changing *everything* here to be just _element
instead of _ie or then probably the shorter _elem would IMHO be too much
code churn.

johannes
