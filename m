Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56673 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0FXRPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 13:15:14 -0400
Date: Thu, 24 Jun 2010 13:07:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] minstrel_ht: mark minstrel_mcs_groups as static
Message-ID: <20100624170710.GB2368@tuxdriver.com>
References: <1277392602-10578-1-git-send-email-linville@tuxdriver.com>
 <4C238C3A.6090905@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C238C3A.6090905@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 24, 2010 at 06:47:54PM +0200, Felix Fietkau wrote:
> On 2010-06-24 5:16 PM, John W. Linville wrote:
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  net/mac80211/rc80211_minstrel_ht.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> > index 7a04951..a8f658c 100644
> > --- a/net/mac80211/rc80211_minstrel_ht.c
> > +++ b/net/mac80211/rc80211_minstrel_ht.c
> > @@ -59,7 +59,7 @@
> >   * groups, based on the number of streams and flags (HT40, SGI) that they
> >   * use.
> >   */
> > -const struct mcs_group minstrel_mcs_groups[] = {
> > +static const struct mcs_group minstrel_mcs_groups[] = {
> NACK. minstrel_ht debugfs needs this. The proper fix for the warning is
> to add this one to a header file instead.

Yup, fair enough.  Replacement patch to follow.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
