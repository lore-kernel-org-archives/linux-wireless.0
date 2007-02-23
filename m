Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:45122 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643AbXBWUVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 15:21:33 -0500
Date: Fri, 23 Feb 2007 12:19:54 -0800
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, jbenc@suse.cz
Subject: Re: [RFC] convert wiphy to struct device
Message-ID: <20070223201954.GA1609@kroah.com>
References: <20070221005811.GA3875@tuxdriver.com> <1172054717.3705.1.camel@johannes.berg> <20070221133202.GB4978@tuxdriver.com> <1172242788.3870.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1172242788.3870.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 23, 2007 at 03:59:48PM +0100, Johannes Berg wrote:
> Ok so I did the wiphy stuff w/o knowing that class devs are apparently
> deprecated. Below is a patch to convert it.
> 
> However, that patch has a problem. As discussed on netdev in the thread
> "Converting network devices from class devices causes namespace
> pollution" we'll have the same problem here, currently after the patch
> this means that wiphys and netdevs will share the same namespace within
> the device directory.
> 
> I think the generic code Greg promised in that thread will fix it by
> renaming the symlink to "ieee80211:wiphy0" instead of just "wiphy0" but
> I'd like to have confirmation about that.

Yes it will, I'm working on that patch right now...

thanks,

greg k-h
