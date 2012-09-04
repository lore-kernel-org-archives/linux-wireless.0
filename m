Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2IDJaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 05:30:20 -0400
Message-ID: <1346751037.3737.24.camel@jlt4.sipsolutions.net> (sfid-20120904_113023_802831_13D80A9A)
Subject: Re: [RFC 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 04 Sep 2012 11:30:37 +0200
In-Reply-To: <5045C79A.6050308@qca.qualcomm.com>
References: <1346675037-17858-1-git-send-email-vthiagar@qca.qualcomm.com>
	  <1346675037-17858-2-git-send-email-vthiagar@qca.qualcomm.com>
	 <1346747916.3737.23.camel@jlt4.sipsolutions.net>
	 <5045C79A.6050308@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 14:49 +0530, Vasanthakumar Thiagarajan wrote:

> >> +	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP&&
> >> +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
> >> +		return -EOPNOTSUPP;
> >
> > This also needs to check that the interface is operating already in AP
> > mode.
> 
> Sorry, not sure I get this. Is it not that configuring acl list
> when dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP is already
> taken care.

Well you say that on start_ap the list must be cleared. Therefore,
updating the list only makes sense after start_ap, not before, so you
should refuse it being set before start_ap.

johannes

