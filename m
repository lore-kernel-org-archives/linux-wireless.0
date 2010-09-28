Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0I1Krr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 06:47:47 -0400
Subject: Re: [RFC] mac80211: sets basic rate set parameter for IBSS creator
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CA1B5F3.5090801@atheros.com>
References: <1285662586-31646-1-git-send-email-mshajakhan@atheros.com>
	 <1285664569.3885.7.camel@jlt3.sipsolutions.net>
	 <4CA1B5F3.5090801@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 12:47:45 +0200
Message-ID: <1285670865.3885.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 15:01 +0530, Mohammed Shafi wrote:

> >> +	if (ifibss->basic_rates == 0)
> >> +		ifibss->basic_rates = ieee80211_mandatory_rates(local,
> >> +					local->hw.conf.channel->band);
> >>      
> > Shouldn't cfg80211 do this?

>                        Thank you for your suggestion,just found out ,i 
> think  its already there to configure basic rates (if the user had not 
> expicitly specified the basic rates in user space) in the 
> nl80211_join_ibss(nl80211.c) , but the basic rates does not seems to get 
> set there.I had checked its status in mac80211 in function 
> ieee80211_ibss_join function , its still zero and I thought of calling 
> it there itself , but the basic rate was not properly set for 2Ghz, so 
> called it here and  I had tested it ,and everything working fine.
> Pleas correct me if I am wrong .

Well, I still think cfg80211 should do this, and it looks like it will
except when you use iwconfig. So are you using iw or iwconfig? If
iwconfig latter, you need to fix the wext code in cfg80211, if the
former you need to figure out where the information gets lost.

johannes

