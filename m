Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36308 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbeBAIyt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 03:54:49 -0500
Message-ID: <1517475286.28814.9.camel@sipsolutions.net> (sfid-20180201_095453_036324_4C157FF3)
Subject: Re: [RFC v3 0/6] EAPoL over NL80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Thu, 01 Feb 2018 09:54:46 +0100
In-Reply-To: <97c9744e-0f24-49d1-ed2c-eb4661e97289@gmail.com> (sfid-20180201_020955_112630_B89356C9)
References: <20180131213329.25322-1-denkenz@gmail.com>
         <1517436000.28814.3.camel@sipsolutions.net>
         <97c9744e-0f24-49d1-ed2c-eb4661e97289@gmail.com>
         (sfid-20180201_020955_112630_B89356C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > [1/6] keep
> > [2/6] keep
> > [3/6] introduce TX (now patch 5)
> > [4/6] introduce RX (now patch 3)
> >        modify this to require TX from the driver in order to be able to
> >        set the new flag
> > [5/6] add TX to mac80211
> > [6/6] add RX to mac80211 and set the flag
> > 
> > Ok, you don't really have to do that, since you only set the flag in
> > the last patch anyway, but that'd make it better to add the check that
> > requires TX, so you don't have to do that in the TX patch and modify
> > the RX portion again.
> 
> Err, Johannes Berg presents: Fun with Flags ;) So I re-read this about 
> half a dozen times and I think I figured out what you wanted.  It seems 
> you mean different flags in 4/6 and 6/6.

Err, I didn't think so, but then it was pretty late. I was thinking of
the feature flag that says whether userspace can expect to see this or
not.

> I reordered V4 with my 
> interpretation.  Doesn't quite look like the above, but hopefully I 
> groked what you wanted correctly.

I guess I can always reorder things myself if I really think it
necessary, thanks :-)

> I didn't put in the extra owner check on the tx operation since it 
> wasn't clear whether you wanted that or not.

Yeah I can't make up my mind. I'm tempted to say "let's do the right
thing" and fix the problems we have in userspace ...

johannes
