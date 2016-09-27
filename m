Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49242 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbcI0NDE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 09:03:04 -0400
Message-ID: <1474981379.5141.37.camel@sipsolutions.net> (sfid-20160927_150308_348661_03C4210A)
Subject: Re: [PATCH v8] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>
Date: Tue, 27 Sep 2016 15:02:59 +0200
In-Reply-To: <c6f1a958d7f941b5a7dc8564d3f1c371@aphydexm01f.ap.qualcomm.com> (sfid-20160916_083438_618523_AC15A50F)
References: <1472649972-6649-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1473675843.29016.18.camel@sipsolutions.net>
         <c6f1a958d7f941b5a7dc8564d3f1c371@aphydexm01f.ap.qualcomm.com>
         (sfid-20160916_083438_618523_AC15A50F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for the long delay.

> > In order to validate a new beacon interval, you're first looking up
> > the min GCD value of all the combinations that allow the *current*
> > scenario, but doing that matching without the right # of channels
> > or radar detect parameters? And then you're trying to match that to
> > the new beacon interval?

> Yes . Please allow us to explain the rationale for doing so. 

> 1. The intention here is to ensure that the beacon interval
> configured for any single interface is greater than the
> "diff_beacon_int_gcd_min"  specified in the respective
> combinations.  

Sure, ok, so far so good - not that I think it would really be
necessary to validate it this way, but ok.

> 2. Since "diff_beacon_int_gcd_min"  is only specified / advertised in
> the interface combinations , our logic was to get the minimal
> "diff_beacon_int_gcd_min" of all the matching combinations and later 
>     compare with the new beacon interval. (API
> "cfg80211_iter_combinations" has to be invoked to get the
> corresponding "diff_beacon_int_gcd_min")

Yeah, but you get the diff_beacon_int_gcd_min for all combinations that
allow the *current* combination of interfaces, not the combinations
that allow the new *new* combination of interfaces, no?

I mean, consider the case that you have a single AP interface, with
beacon interval 300, and you're adding another AP, with beacon interval
150, and the following allowed combinations:

 * ap = 1
   mesh = 1
   diff_beacon_int_gcd_min = 100
 * ap = 2
   diff_beacon_int_gcd_min = 50

Wouldn't you prevent that, or something?

Or say you have

 * ap = 1
   mesh = 1
   diff_beacon_int_gcd_min = 100
 * ap = 2
   diff_beacon_int_gcd_min = 200

Probably doesn't really make sense, but now if you have an existing AP
interface, you would think the min is 100, when really while adding
another AP it should be 200.

> 3. If the beacon interval configured needs to be ensured to be
> greater than the "diff_beacon_int_gcd_min" configured for both the
> "single interface" and "interface combination" , we have resorted to 
>      "2"  (get the minimal of "diff_beacon_int_gcd_min" among all the
> matched interface combinations and then compare it with the
> configured beacon interval). 

Yeah, I think you're just matching the interface combinations wrong; I
think it needs to take into account the new interfaces and the existing
beacon intervals.

> > If the driver specified diff_beacon_int_gcd_min, then don't do
> > anything in cfg80211_validate_beacon_int(), other than perhaps a
> > minimal range check against the minimum of all
> > >diff_beacon_int_gcd_min values for all combinations.
> > That new argument could be made the GCD of all existing beaconing
> > interfaces (or 0 if no such exists), since that's sufficient for
> > checking against a new min_gcd.

> If I understand this correctly , are you saying that this new
> argument to cfg80211_iter_combinations shall be the GCD of all the
> existing beacon intervals and would be used to match with the
> corresponding "diff_beacon_int_gcd_min" of the interface combinations
> in "cfg80211_iter_combinations". 

Yes, that's what I was thinking.

> If yes , this GCD argument does not represent , if the beacon
> intervals of all the existing interfaces differ or not , isn’t ? If
> the "diff_beacon_int_gcd_min"  of the all the matching interface
> combinations is 0 , such differed beacon intervals would pass the
> check , contradicting the existing logic ( not allowing the differed
> beacon intervals), isn't ? 

Oh, well, ok - if all existing and new beacon intervals are the same
we'd have to do the lookup without the existing beacon interval GCD and
still compare to the min separately.

> Thus, wouldn't it be a better option to first get the
> "diff_beacon_int_gcd_min" advertised by the respective interface
> combinations and then later compare it with the configured /
> calculated beacon interval's GCD . 

As above, I think you might find a combination that no longer applies
after the new interface is added, thus causing a situation that isn't
actually covered by the allowed combinations.

> Also , not quite sure how would your comment " matching without the
> right # of channels or radar detect parameters" get addressed with
> your new proposal ( adding a new argument to
> "cfg80211_iter_combinations" ) 

That's just addressed by not doing the "get min min_gcd" first step,
where you used it wrong, afaict.

johannes
