Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2L1Mz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 07:55:56 -0500
Message-ID: <1356699373.9922.2.camel@jlt4.sipsolutions.net> (sfid-20121228_135559_928486_BB771E64)
Subject: Re: [PATCH V4 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 28 Dec 2012 13:56:13 +0100
In-Reply-To: <1356694308.9922.1.camel@jlt4.sipsolutions.net> (sfid-20121228_123135_896103_E2B28BED)
References: <1356690070-26612-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1356690070-26612-2-git-send-email-vthiagar@qca.qualcomm.com>
	 <1356694308.9922.1.camel@jlt4.sipsolutions.net>
	 (sfid-20121228_123135_896103_E2B28BED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-28 at 12:31 +0100, Johannes Berg wrote:
> On Fri, 2012-12-28 at 15:51 +0530, Vasanthakumar Thiagarajan wrote:
> 
> > V4:
> > 	- Change it accordingly so that at any time the driver can
> > 	  support either white or black list not both.
> 
> I was under the impression you needed both. Unless I get confirmation
> from Kalle and/or Jouni I'll not apply this lest it needs to be changed
> in yet again incompatible ways later ...

Actually I just talked to Jouni again and it seems that the best way to
think of the combined black/whitelist is to treat it as a whitelist +
"notification avoidance optimisation list". The key here being
optimisation, we don't really have to worry about it in terms of feature
advertising etc. since it can be ignored/managed by the driver.

johannes

