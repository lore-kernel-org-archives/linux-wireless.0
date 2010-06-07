Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36056 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0FGFFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 01:05:08 -0400
Subject: Re: [PATCH] mac80211: Add interface for driver to temporarily
 disable dynamic ps
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1275817484.3615.9.camel@jlt3.sipsolutions.net>
References: <1275561873-21500-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1275817484.3615.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 08:04:46 +0300
Message-ID: <1275887086.5277.29790.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-06-06 at 11:44 +0200, ext Johannes Berg wrote:
> Hi,
> 
> Apologies for the delay in reviewing this.
> 
> On Thu, 2010-06-03 at 13:44 +0300, Juuso Oikarinen wrote:
> 
> > @@ -699,6 +704,8 @@ enum ieee80211_smps_mode {
> >  struct ieee80211_conf {
> >  	u32 flags;
> >  	int power_level, dynamic_ps_timeout, dynamic_ps_forced_timeout;
> > +	int dynamic_ps_user_timeout;
> > +	bool disable_dynamic_ps;
> >  	int max_sleep_period;
> 
> Please don't keep these variables in driver-visible structures, they
> don't belong there as they are implementation details, they should be in
> the ieee80211_local structure somewhere and the driver should see _only_
> dynamic_ps_timeout.
> 
> The same actually applies to dynamic_ps_forced_timeout as well, so
> please also make a separate patch moving that.

Understood. I will make these changes.

-Juuso

> johannes
> 


