Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaK1WAW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 17:00:22 -0500
Date: Fri, 28 Nov 2014 23:00:20 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 2/4] cfg80211: allow usermode to query wiphy
	specific regdom
Message-ID: <20141128220020.GX25677@wotan.suse.de> (sfid-20141128_230046_454852_6F9F495A)
References: <1417074298-12254-1-git-send-email-arik@wizery.com> <1417074298-12254-2-git-send-email-arik@wizery.com> <1417182387.27562.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417182387.27562.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 28, 2014 at 02:46:27PM +0100, Johannes Berg wrote:
> On Thu, 2014-11-27 at 09:44 +0200, Arik Nemtsov wrote:
> > If a wiphy-idx is specified, the kernel will return the wiphy specific
> > regdomain, if such exists. Otherwise return the global regdom.
> > 
> > When no wiphy-idx is specified, return the global regdomain as well as
> > all wiphy-specific regulatory domains in the system, via a new nested
> > list of attributes.
> 
> Is that really a good idea? Seems rather easy to overrun the message
> size with that, in which case your current code will not return anything
> at all... that'll cause strange errors if somebody plugs in a few
> devices or has hwsim open as well or so ...

Good point, perhaps require 'iw reg get --all' for all listing then?
This would mean requiring an new optional flag passed on reg get too
then.

> > Add a new attribute for each wiphy-specific regdomain, for usermode to
> > identify it as such.
> 
> Shouldn't userspace also *request* this for backward compatibility?
> Otherwise older userspace might assume that a returned regd applies to
> everything, when it doesn't really?

If the flag --all is used and passed then I see no issue.

  Luis
