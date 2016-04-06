Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36284 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbcDFJkf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:40:35 -0400
Message-ID: <1459935631.17504.71.camel@sipsolutions.net> (sfid-20160406_114052_698140_E51E93B8)
Subject: Re: [PATCHv3 RESEND 05/11] cfg80211: provide a function to report a
 match for NAN
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 11:40:31 +0200
In-Reply-To: <20160406093851.GB10595@jouni.qca.qualcomm.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-5-git-send-email-emmanuel.grumbach@intel.com>
	 <20160406093851.GB10595@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-04-06 at 09:38 +0000, Malinen, Jouni wrote:
> 
> > +void cfg80211_nan_match(struct wireless_dev *wdev,
> > +			struct cfg80211_nan_match_params *match,
> > gfp_t gfp);
> Looks like this function is common for publish, subscribe and follow
> up. If so, can we please have separate functions for publish,
> subscribe and followup to match the spec primitives?

Is it really worth exporting three functions just for the sake of that?
Perhaps better if we provide inline wrappers though that set the value
correctly?

Would you extend this request also to the nl80211 command value?

johannes
