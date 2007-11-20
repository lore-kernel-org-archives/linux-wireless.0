Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761445AbXKTQ3S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 11:29:18 -0500
Subject: Re: [PATCH] mac80211: free ifsta->extra_ie in ieee80211_stop
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1195565876.10920.29.camel@johannes.berg>
References: <11955417361539-git-send-email-yi.zhu@intel.com>
	 <1195565876.10920.29.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 11:25:22 -0500
Message-Id: <1195575922.3389.20.camel@localhost.localdomain> (sfid-20071120_162938_635325_B17BB42B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-11-20 at 14:37 +0100, Johannes Berg wrote:
> On Tue, 2007-11-20 at 14:55 +0800, Zhu Yi wrote:
> > I'm not sure if this is best choice, someone might have better
> > solutions. But this patch fixed the connection problem when switching
> > from a WPA enabled AP (using wpa_supplicant) to an open AP (using
> > iwconfig). The root cause is when we connect to a WPA enabled AP,
> > wpa_supplicant sets the ifsta->extra_ie thru SIOCSIWGENIE. But if we
> > stop wpa_supplicant and connect to an open AP with iwconfig, there is
> > no way to clear the extra_ie so that mac80211 keeps connecting with that.
> 
> Fun.
> 
> > Someone could argue wpa_supplicant should clear the extra_ie during
> > its shutdown. But mac80211 should also handle the unexpected shutdown
> > case (ie. killall -9 wpa_supplicant).
> 
> Yes. But if you do that, the interface won't be down either. Maybe this
> should also be done when removing keys?

That seems better to me; although couldn't it also be cleared when
setting static WEP keys?  Dynamic WEP shouldn't care about the IE bits
either, so any time a WEP key is set and you're _not_ doing WPA the IE
could get cleared.

Though on the other hand, the interface isn't going to work much longer
after wpa_supplicant goes away anyway, depending on how long the
group/multicast rekey interval is.

Dan


