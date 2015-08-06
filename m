Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44407 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbbHFIca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 04:32:30 -0400
Date: Thu, 6 Aug 2015 11:30:04 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/5] net: rfkill: add rfkill_find_type function
Message-ID: <20150806083004.GI7675@kuha.fi.intel.com> (sfid-20150806_103255_542649_F78F3D91)
References: <1438781947-7952-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1438781947-7952-3-git-send-email-heikki.krogerus@linux.intel.com>
 <1438783649.29746.175.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1438783649.29746.175.camel@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 05, 2015 at 05:07:29PM +0300, Andy Shevchenko wrote:
> On Wed, 2015-08-05 at 16:39 +0300, Heikki Krogerus wrote:
> > Helper for finding the type based on name. Useful if the
> > type needs to be determined based on device property.
> > 
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > ---
> >  include/linux/rfkill.h | 15 +++++++++++++
> >  net/rfkill/core.c      | 57 +++++++++++++++++++++++++---------------
> > ----------
> >  2 files changed, 44 insertions(+), 28 deletions(-)
> > 
> > diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> > index d901078..02f563c 100644
> > --- a/include/linux/rfkill.h
> > +++ b/include/linux/rfkill.h
> > @@ -212,6 +212,15 @@ void rfkill_set_states(struct rfkill *rfkill, 
> > bool sw, bool hw);
> >   * @rfkill: rfkill struct to query
> >   */
> >  bool rfkill_blocked(struct rfkill *rfkill);
> > +
> > +/**
> > + * rfkill_find_type - Helpper for finding rfkill type by name
> > + * @name: the name of the type
> > + *
> > + * Returns enum rfkill_type that conrresponds the name.
> > + */
> > +enum rfkill_type rfkill_find_type(const char *name);
> > +
> >  #else /* !RFKILL */
> >  static inline struct rfkill * __must_check
> >  rfkill_alloc(const char *name,
> > @@ -268,6 +277,12 @@ static inline bool rfkill_blocked(struct rfkill 
> > *rfkill)
> >  {
> >  	return false;
> >  }
> > +
> > +static inline enum rfkill_type rfkill_find_type(const char *name)
> > +{
> > +	return 0;
> 
> Hmm… Besides 0 is implicitly casted to enum type the issue with enums
> that you rather have to supply existing enum entry. I would suggest to
> add RFKILL_TYPE_UNKNOWN if _ALL is reserved for some use cases.

Why would you add a new type just for this? You do realize it would
require adding specific handling all over the place? RFKILL_TYPE_ALL
(0) is already handled as an invalid type. Confused?

I'll change this and return RFKILL_TYPE_ALL instead of 0.


Thanks,

-- 
heikki
