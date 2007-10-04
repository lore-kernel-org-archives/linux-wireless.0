Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3485 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbXJDTi1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 15:38:27 -0400
Date: Thu, 4 Oct 2007 15:13:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ieee80211_if_set_type: make check for master dev more
	explicit
Message-ID: <20071004191301.GJ6037@tuxdriver.com> (sfid-20071004_203832_603615_C117B8EF)
References: <20071004113343.552139D502B@zog.reactivated.net> <20071004180900.GG6037@tuxdriver.com> <1191523488.7367.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191523488.7367.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 04, 2007 at 08:44:48PM +0200, Johannes Berg wrote:
> On Thu, 2007-10-04 at 14:09 -0400, John W. Linville wrote:
> 
> > --- a/net/mac80211/ieee80211_iface.c
> > +++ b/net/mac80211/ieee80211_iface.c
> > @@ -106,7 +106,7 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
> >  	 * which already has a hard_start_xmit routine assigned
> >  	 * which must not be changed.
> >  	 */
> > -	if (!dev->hard_start_xmit)
> > +	if (dev->type != ARPHRD_IEEE80211)
> >  		dev->hard_start_xmit = ieee80211_subif_start_xmit;
> 
> That should work as well although I think you should update the comment
> above :)

The comment still seem applicable.  How would you word it?

-- 
John W. Linville
linville@tuxdriver.com
