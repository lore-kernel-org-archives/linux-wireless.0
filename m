Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:3019 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbbHFJ1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 05:27:14 -0400
Message-ID: <1438853219.29746.184.camel@linux.intel.com> (sfid-20150806_112743_700035_448C587F)
Subject: Re: [PATCH 2/5] net: rfkill: add rfkill_find_type function
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Date: Thu, 06 Aug 2015 12:26:59 +0300
In-Reply-To: <20150806083004.GI7675@kuha.fi.intel.com>
References: <1438781947-7952-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <1438781947-7952-3-git-send-email-heikki.krogerus@linux.intel.com>
	 <1438783649.29746.175.camel@linux.intel.com>
	 <20150806083004.GI7675@kuha.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-06 at 11:30 +0300, Heikki Krogerus wrote:
> > > 
> On Wed, Aug 05, 2015 at 05:07:29PM +0300, Andy Shevchenko wrote:
> > On Wed, 2015-08-05 at 16:39 +0300, Heikki Krogerus wrote:


> > > +static inline enum rfkill_type rfkill_find_type(const char
> > > *name)
> > > +{
> > > +	return 0;
> > 
> > Hmm… Besides 0 is implicitly casted to enum type the issue with 
> > enums
> > that you rather have to supply existing enum entry. I would suggest 
> > to
> > add RFKILL_TYPE_UNKNOWN if _ALL is reserved for some use cases.
> 
> Why would you add a new type just for this? You do realize it would
> require adding specific handling all over the place? RFKILL_TYPE_ALL
> (0) is already handled as an invalid type.

It was my thought as well (see *if* in my previous comment).

>  Confused?

A bit, yes.

> 
> I'll change this and return RFKILL_TYPE_ALL instead of 0.

Excellent!

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
