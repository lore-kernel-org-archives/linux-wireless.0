Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3LCPGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 10:06:47 -0500
Message-ID: <1386083203.4393.35.camel@jlt4.sipsolutions.net> (sfid-20131203_160650_897658_2A8A5004)
Subject: Re: [PATCHv3] cfg80211: add support for frequency interference event
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajesh Chauhan <rajeshc@qca.qualcomm.com>
Cc: rodrigue@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	jouni@qca.qualcomm.com, hbahini@qca.qualcomm.com,
	jjohnson@qca.qualcomm.com, schang@qca.qualcomm.com,
	xunl@qca.qualcomm.com, sameert@qca.qualcomm.com,
	c_arifh@qca.qualcomm.com
Date: Tue, 03 Dec 2013 16:06:43 +0100
In-Reply-To: <1386077130.4393.21.camel@jlt4.sipsolutions.net> (sfid-20131203_142537_442351_B9A4DE15)
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
	 <1386077130.4393.21.camel@jlt4.sipsolutions.net>
	 (sfid-20131203_142537_442351_B9A4DE15)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 14:25 +0100, Johannes Berg wrote:

> > +	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
> > +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
> > +		goto nla_put_failure;
> 
> wdev index is missing, however, see above.

Forgot add the "see above" part, so I'll just put it here:

I don't think this API makes sense per netdev.

johannes

