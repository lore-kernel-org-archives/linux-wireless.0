Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55267 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752957AbcI1LVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 07:21:06 -0400
Message-ID: <1475061661.4139.40.camel@sipsolutions.net> (sfid-20160928_132110_293900_B2442A53)
Subject: Re: [PATCH v8] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>
Date: Wed, 28 Sep 2016 13:21:01 +0200
In-Reply-To: <0b626d7836be4cce8ea4868538fe66d3@aphydexm01f.ap.qualcomm.com>
References: <1472649972-6649-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1473675843.29016.18.camel@sipsolutions.net>
         <c6f1a958d7f941b5a7dc8564d3f1c371@aphydexm01f.ap.qualcomm.com>
         (sfid-20160916_083438_618523_AC15A50F) <1474981379.5141.37.camel@sipsolutions.net>
         <0b626d7836be4cce8ea4868538fe66d3@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> In PATCH v8 , cfg80211_validate_beacon_int ->
> cfg80211_iter_combinations carries the argument iftype_num , which
> also considers the "new interface" that is getting added. 

Ah, right, I remember now, sorry.

> Thus , in the example you have quoted above , the iftype_num shall
> represent 2 ( AP + AP ) , and thus the min_gcd obtained out of
> cfg80211_iter_combinations (cfg80211_get_beacon_int_min_gcd) shall be
> 50 for the example 1 and 200 for the example 2 . 
> Thus , considering the two examples mentioned above , the second AP
> should succeed for "example 1" vs failure for "example 2" with patch
> V8 , isn't ?  

Yeah, I tried to simplify and did so too much. I believe you are, for
this purpose, ignoring for example radar detection.

Since you're passing 0 for num_different_channels and radar_detect, you
might find a combination isn't actually currently usable, but that
allows the new beacon interval configuration.

So I think overall this will only work right if it's done with all
necessary information, no?

Trying to construct another example ... let's say permitted
combinations are

 * go = 3, channels = 1, min_bcn_gcd = 50
 * go = 3, channels = 2, min_bcn_gcd = 100

(which isn't actually all that far-fetched, since channel hopping takes
time)

For simplification, say you already have two GOs active on different
channels (with BI 100), and want to add another one - with beacon
interval 50 - this isn't possible, but I don't think your code would
detect it?

Or, perhaps I'm reading this wrong, if your code *does* detect it then
changing the scenario a bit to have just a single channel, your code
would prevent it even though it's allowed?


> The current behavior of the kernel is to not allow the configuration
> of different beacon intervals and our expectation is that this new
> patch should be backward compatible with the existing behavior.

Correct, and I agree, we shouldn't break that.

> Now , if we go with this approach of "introducing a new argument to
> cfg80211_iter_combinations which shall be the GCD of all the existing
> combinations to check against the respective
> "diff_beacon_int_gcd_min"" ,  consider the case ( same one which is
> mentioned above ) that we have a single AP interface ( beacon
> interval = 300 ) , and a new AP is getting added ( beacon interval =
> 150 ),  with the following allowed combinations:
> 
> 1) * ap = 2
>         diff_beacon_int_gcd_min = 0 ( rather not specified ) 
> 2)  * ap = 2
>       diff_beacon_int_gcd_min = 100
> 
> The GCD calculated is 150 . cfg80211_iter_combinations shall return
> success for both the scenarios ( 1 and 2 ) (The intention here is to
> compare with only the nonzero " diff_beacon_int_gcd_min" )
> 
> This success from "cfg80211_iter_combinations" does not represent if
> the GCD passed is compared against a 0 / non zero
> "diff_beacon_int_gcd_min" , isn't ?
> 
> Thus , we are trying to solve this problem , by getting the
> "diff_beacon_int_gcd_min" for the respective interface combination ,
> before comparing it with the calculated GCD. 

Oh. I think I finally understand your concern - good point!

Let me see if I understand correctly - you're saying that if I first
calculate 

  g = GCD(all BIs, including the new one)

and then do

  cfg80211_iter_combinations(... existing variables ..., g)

then I cannot accurately determine whether or not I can use a
combination that doesn't specify a min_beacon_interval_gcd, you can't
know if the "all BIs" were the same, or not.

That's actually a very good point.

However, it seems pretty easy to solve by passing another bool that
indicates "all the same"?

johannes
