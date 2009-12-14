Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37017 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbZLNHzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 02:55:24 -0500
Subject: Re: [PATCH 1/2] wireless: support internal statically compiled
 regulatory database
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20091214032920.GB4743@tuxdriver.com>
References: <1260755116-3829-1-git-send-email-linville@tuxdriver.com>
	 <1260755719.4041.1.camel@localhost.localdomain>
	 <20091214032920.GB4743@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 08:55:12 +0100
Message-Id: <1260777312.4041.13.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> > > +config CFG80211_INTERNAL_REGDB
> > > +	bool "use statically compiled regulatory rules database"
> > > +	default n
> > > +	depends on CFG80211
> > > +	---help---
> > > +	  This option generates an internal data structure representing
> > > +	  the wireless regulatory rules described in net/wireless/db.txt
> > > +	  and includes code to query that database.  This is an alternative
> > > +	  to using CRDA for defining regulatory rules for the kernel.
> > > +
> > > +	  For details see:
> > > +
> > > +	  http://wireless.kernel.org/en/developers/Regulatory
> > > +
> > > +	  Most distributions have a CRDA package.  So if unsure, say N.
> > 
> > since it is pretty clear that people should be defaulting to CRDA, why
> > not make it depend on CONFIG_EMBEDDED.
> 
> Other than expanding the amount of config options available, what are
> the ramifications of selecting CONFIG_EMBEDDED?  Is it just a way of
> hiding options that "normal" people don't need to see?  Or does it
> have some significant change on the built kernel by itself?

from my understand it is just hiding options, that most people don't
need to see. While you might have the Debian not shipping crda case
here, but mostly this option should only selected by people building
their own special kernel. And lets face it, these are mostly embedded
distros that are building special kernels. Every desktop distro should
be just packaging and installing crda. Just from a pure database update
perspective it makes more sense.

So my personal view on this is that it is an embedded feature and not
something for the general wireless people. My 2 cents.

Regards

Marcel


