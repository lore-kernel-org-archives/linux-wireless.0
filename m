Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36312 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbcDFJnZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:43:25 -0400
Message-ID: <1459935800.17504.73.camel@sipsolutions.net> (sfid-20160406_114328_318787_54A8C173)
Subject: Re: [PATCHv3 RESEND 01/11] cfg80211: add start / stop NAN commands
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 11:43:20 +0200
In-Reply-To: <20160406093402.GA10595@jouni.qca.qualcomm.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <20160406093402.GA10595@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Why NL80211_ATTR_NAN_MASTER_PREF is mandatory? The spec suggests to
> assume master preference value of 128 if not provided. Please see
> quoted text from NAN 1.0 specification:
> "A NAN Device which out-of-the-box will have a Master Preference
> greater than or equal to 128 with the intention of being a NAN Master
> Device"

I guess the question would be at which level of API this default would
be set? I'm perfectly happy setting it at the nl80211 level, but I
don't expect applications to (be able to) use the nl80211 API, and some
sort of management application could just as well set the default and
always provide the attribute.

johannes
