Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:40238 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751623AbZCKO5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 10:57:25 -0400
Date: Wed, 11 Mar 2009 15:52:16 +0100
From: Samuel Ortiz <samuel@sortiz.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: configuring while interface is down
Message-ID: <20090311145216.GB6986@sortiz.org> (sfid-20090311_155803_370987_68CC0FE5)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <1236774973.20266.13.camel@johannes.local> <20090311134329.269810@gmx.net> <1236779314.20266.22.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1236779314.20266.22.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2009 at 02:48:34PM +0100, Johannes Berg wrote:
> On Wed, 2009-03-11 at 14:43 +0100, Alina Friedrichsen wrote:
> > Hello!
> > 
> > > For cfg80211's assoc/ibss calls, I think we should reject them outright
> > > when the interface is down, any objections?
> > 
> > How should assoc in cfg80211 work?
> 
> see Jouni's patches.
> 
> > For WEXT I like collecting all changes while the interface is down and
> > the if it's up again apply them in one step. That is the reason why I
> > want call "*_commit()" on interface up.
> 
> which is what we'll continue doing in cfg80211, but I think we shouldn't
> bother the driver/mac80211 with it until the netdev is up, and thus
> reject things from nl80211.
That is quite reasonable, please go for it.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
