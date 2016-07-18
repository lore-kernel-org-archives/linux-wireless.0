Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49257 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbcGRTOH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:14:07 -0400
Message-ID: <1468869244.2944.3.camel@sipsolutions.net> (sfid-20160718_211412_268346_01E3F286)
Subject: Re: [PATCH v2] cfg80211: Allow differnt beacon interval if driver
 supports
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Date: Mon, 18 Jul 2016 21:14:04 +0200
In-Reply-To: <578D2846.5060600@candelatech.com>
References: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com>
	 <1468868209.2944.1.camel@sipsolutions.net>
	 <578D2846.5060600@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-07-18 at 12:04 -0700, Ben Greear wrote:
> 
> On 07/18/2016 11:56 AM, Johannes Berg wrote:
> > On Mon, 2016-07-18 at 19:23 +0530, Purushottam Kushwaha wrote:
> > > Driver may allow support for different beacon interval on virtual
> > > interfaces.
> > > Allow if such support is advertised by driver. This adds new
> > > ext_feature as NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.
> > 
> > We have NL80211_IFACE_COMB_STA_AP_BI_MATCH in interface
> > combinations,
> > perhaps it would make sense to also put this flag there?
> 
> I was under impression that ath9k had supported this for years,
> but I guess I haven't tested it lately....
> 

It may very well have, but if userspace can't rely on it because other
drivers don't then it's pretty pointless.

johannes
