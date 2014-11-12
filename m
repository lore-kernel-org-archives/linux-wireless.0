Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37809 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaKLLwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 06:52:51 -0500
Message-ID: <1415793164.1798.1.camel@sipsolutions.net> (sfid-20141112_125308_704364_F64FF506)
Subject: Re: [PATCH v2 1/2] nl80211: Replace interface socket owner
 attribute with more generic one
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Jukka Rissanen <jukka.rissanen@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 12 Nov 2014 12:52:44 +0100
In-Reply-To: <1415792829.3117.5.camel@coelho.fi> (sfid-20141112_124722_682283_2206FE4A)
References: <1415792197-23080-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1415792197-23080-2-git-send-email-jukka.rissanen@linux.intel.com>
	 <1415792829.3117.5.camel@coelho.fi> (sfid-20141112_124722_682283_2206FE4A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-12 at 13:47 +0200, Luca Coelho wrote:
> On Wed, 2014-11-12 at 13:36 +0200, Jukka Rissanen wrote:
> > @@ -2056,6 +2056,8 @@ enum nl80211_attrs {
> >  #define NL80211_ATTR_KEY NL80211_ATTR_KEY
> >  #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
> >  #define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
> > +#define NL80211_ATTR_IFACE_SOCKET_OWNER NL80211_ATTR_SOCKET_OWNER
> > +#define NL80211_ATTR_SOCKET_OWNER NL80211_ATTR_SOCKET_OWNER
> 
> The second define seems to be a mistake?

Yes, both are wrong here. We played with defining some attributes to
themselves to allow #ifdef feature detection, but that didn't really
work out well and now we just copy nl80211.h to the userspace tools
needing a recent version. I think that's no longer needed now.

There should already be a second block of #ifdefs though that has
renamed ones, so you should add this one there.

Your patch is also missing signed-off-by.

johannes

