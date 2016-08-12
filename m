Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59654 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbcHLLmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 07:42:49 -0400
Message-ID: <1471002165.26902.35.camel@sipsolutions.net> (sfid-20160812_134252_572869_96933236)
Subject: Re: [PATCH v6] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
	"Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>,
	"Kumar, Deepak (QCA)" <djindal@qti.qualcomm.com>
Date: Fri, 12 Aug 2016 13:42:45 +0200
In-Reply-To: <ba55eb8a461b41a4b7a592ee567d0fbf@aphydexm01f.ap.qualcomm.com>
References: <1470991178-11024-1-git-send-email-pkushwah@qti.qualcomm.com>
	 <1470995683.26902.31.camel@sipsolutions.net>
	 <ba55eb8a461b41a4b7a592ee567d0fbf@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-12 at 11:34 +0000, Undekari, Sunil Dutt wrote:
> > 
> > The clarification that it also represents the minimum for a single
> > beacon interval would make some sense to me, but at the same time
> > it can't be used only for that, so perhaps separating a minimum out
> > >(rather than using the hard-coded minimum of 10) would make sense.
> Sorry . Could not get your statement above . 
> Are you saying to not check if the beacon interval is < 10 in
> cfg80211_validate_beacon_int rather only consider > 10000 and do the
> validation if the configured beacon interval is less than
> diff_beacon_int_gcd_min , when configured ? 
> If yes , how do you want the validation for the BI ( < 10 ) for the
> first interface to happen ?

I was just thinking out loud :)

Right now we verify that it's >=10, but does that make sense if say
min_gcd is 20? Mathematically, defining gcd(n)=n would make sense, so
if you just had a single interface, applying the min_gcd would mean
that this is also the minimum beacon interval.

We can still leave the <10 check, but if the min_gcd is set treat just
a single interface with beaconing with the above gcd() definition and
check that the beacon interval is >= min_gcd?

Really that just means extending the function to calculate the GCD to
be able to return a value for a single number.

But maybe I'm overdesigning this :)

johannes
