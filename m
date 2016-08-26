Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47398 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750809AbcHZIHx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 04:07:53 -0400
Message-ID: <1472198868.390.18.camel@sipsolutions.net> (sfid-20160826_100758_886834_45D10821)
Subject: Re: [PATCH v6] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>,
        "Kumar, Deepak (QCA)" <djindal@qti.qualcomm.com>
Date: Fri, 26 Aug 2016 10:07:48 +0200
In-Reply-To: <b13661a358d94e81950f6c4387681bd4@aphydexm01f.ap.qualcomm.com>
References: <1470991178-11024-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1470995683.26902.31.camel@sipsolutions.net>
         <ba55eb8a461b41a4b7a592ee567d0fbf@aphydexm01f.ap.qualcomm.com>
         <1471002165.26902.35.camel@sipsolutions.net>
         <b13661a358d94e81950f6c4387681bd4@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry - missed that mail somehow.

> cfg80211_validate_beacon_int -> cfg80211_iter_combinations shall be
> invoked for the interface combinations , currently.
> diff_beacon_int_gcd_min is applicable for the interface combinations
> and am not sure how can we validate this for a single interface .
> This specific interface can be part of two different groups (
> interface combinations) with different values for
> "diff_beacon_int_gcd_min". 
> I don't think we can get the match for the right set of combination
> here , isn't ? 

Well if you have just a single interface, any combination that contains
it is valid, so you'd just continue?

I *think* the code works by checking if any combination applies to the
currently desired state, and rejects if no combination is possible,
that would still be perfectly reasonable here, no?

> To make things simple , can we ignore the following rule 
> " When >0, any beacon interval must also be bigger than this value." 
> and rather have only the following one ? 
> " When >0, different beacon intervals must have a GCD that's at least
> as big as this value."  (To be more precise , any second interface
> which does not meet this rule , will fail to start ) .

Yeah, I suppose we could, but does that really make sense? If you can
have a smaller BI, then you could as well have a smaller GCD, no?

johannes
