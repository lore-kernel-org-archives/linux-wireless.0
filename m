Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from v094114.home.net.pl ([79.96.170.134]:44341 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1946167AbbHGVlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 17:41:12 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/5] device property: helper macros for property entry creation
Date: Sat, 08 Aug 2015 00:08:19 +0200
Message-ID: <6986422.HLaTehgfKn@vostro.rjw.lan> (sfid-20150807_234136_691305_0572B052)
In-Reply-To: <20150806074848.GH7675@kuha.fi.intel.com>
References: <1438781947-7952-1-git-send-email-heikki.krogerus@linux.intel.com> <1438783338.29746.172.camel@linux.intel.com> <20150806074848.GH7675@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, August 06, 2015 10:48:48 AM Heikki Krogerus wrote:
> On Wed, Aug 05, 2015 at 05:02:18PM +0300, Andy Shevchenko wrote:
> > On Wed, 2015-08-05 at 16:39 +0300, Heikki Krogerus wrote:
> > > Marcos for easier creation of build-in property entries.
> > > 
> > > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > ---
> > >  include/linux/property.h | 35 +++++++++++++++++++++++++++++++++++
> > >  1 file changed, 35 insertions(+)
> > > 
> > > diff --git a/include/linux/property.h b/include/linux/property.h
> > > index 76ebde9..204d899 100644
> > > --- a/include/linux/property.h
> > > +++ b/include/linux/property.h
> > > @@ -152,6 +152,41 @@ struct property_entry {
> > >  	} value;
> > >  };
> > >  
> > > +#define PROP_ENTRY_U8(_name_, _val_) { \
> > 
> > PROP_ prefix is too generic.
> > Maybe DEVPROP_ ? At least for the latter no records in the current
> > sources.
> 
> I disagree with that. IMO this kind of macros should ideally resemble
> the structure name they are used to fill (struct property_entry in
> this case). And there are already definitions for DEV_PROP_* to
> describe the types, so using something like DEVPROP_* here is just
> confusing.
> 
> If PROP_ENTRY_* is really not good enough, we can change them
> PROPERTY_ENTRY_*. But is PROP_ENTRY_* really so bad?
> 
> Rafael, what is your opinion?

I would prefer PROPERTY_ENTRY_ to be honest.  It's not like we need to save
characters here.

Thanks,
Rafael

