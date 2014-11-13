Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844AbaKMNmY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 08:42:24 -0500
Date: Thu, 13 Nov 2014 14:39:28 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: remove net-pf-16-proto-16-family-nl80211
 module alias
Message-ID: <20141113133928.GC1926@redhat.com> (sfid-20141113_144227_815239_A481DC7D)
References: <20141113123313.GA1926@redhat.com>
 <1415882683.2021.3.camel@sipsolutions.net>
 <20141113132252.GB1926@redhat.com>
 <252AB6B9-9D33-4932-B75F-D3B2B057D3C0@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <252AB6B9-9D33-4932-B75F-D3B2B057D3C0@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thu, Nov 13, 2014 at 10:36:17PM +0900, Marcel Holtmann wrote:
> > With the alias cfg80211 module is loaded on systems without the wireless
> > hardware when user-space use nl80211 to discover if there are wireless
> > devices, what is considered as resources wastage. On systems with
> > wireless hardware cfg80211 module will be loaded anyway.
> > 
> > Cc: Marcel Holtmann <marcel@holtmann.org>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> > net/wireless/core.c | 1 -
> > 1 file changed, 1 deletion(-)
> > 
> > diff --git a/net/wireless/core.c b/net/wireless/core.c
> > index a4d2792..badcabe 100644
> > --- a/net/wireless/core.c
> > +++ b/net/wireless/core.c
> > @@ -34,7 +34,6 @@
> > MODULE_AUTHOR("Johannes Berg");
> > MODULE_LICENSE("GPL");
> > MODULE_DESCRIPTION("wireless configuration support");
> > -MODULE_ALIAS_GENL_FAMILY(NL80211_GENL_NAME);
> 
> NAK.
> 
> We want to auto-load cfg80211 when userspace asked for nl80211 netlink family.

Could you elaborate more why?

Stanislaw
