Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54648 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYJNU7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 16:59:06 -0400
Date: Tue, 14 Oct 2008 16:56:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ieee80211: make it depend on drivers that use it
Message-ID: <20081014205621.GE3349@tuxdriver.com> (sfid-20081014_225916_775484_BE3910C8)
References: <1224004808-20992-1-git-send-email-linville@tuxdriver.com> <1224008257.3027.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224008257.3027.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2008 at 08:17:37PM +0200, Johannes Berg wrote:
> On Tue, 2008-10-14 at 13:20 -0400, John W. Linville wrote:
> > Make IEEE80211 depend on IPW2100, IPW2200, or HOSTAP, which all select
> > it.  This removes the need for users to select it manually.
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  net/ieee80211/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/ieee80211/Kconfig b/net/ieee80211/Kconfig
> > index 94ed7d3..44831db 100644
> > --- a/net/ieee80211/Kconfig
> > +++ b/net/ieee80211/Kconfig
> > @@ -1,5 +1,6 @@
> >  config IEEE80211
> >  	tristate "Generic IEEE 802.11 Networking Stack (DEPRECATED)"
> > +	depends on (IPW2100 || IPW2200 || HOSTAP)
> >  	---help---
> >  	This option enables the hardware independent IEEE 802.11
> >  	networking stack.  This component is deprecated in favor of the
> 
> Users will still have to select the crypto options manually I think.

Yes, your patch is better. :-)

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
