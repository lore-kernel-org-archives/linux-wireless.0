Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41382 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaK1Nqb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 08:46:31 -0500
Message-ID: <1417182387.27562.8.camel@sipsolutions.net> (sfid-20141128_144634_351100_51642662)
Subject: Re: [PATCH v5 2/4] cfg80211: allow usermode to query wiphy specific
 regdom
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 28 Nov 2014 14:46:27 +0100
In-Reply-To: <1417074298-12254-2-git-send-email-arik@wizery.com> (sfid-20141127_084459_625553_BD50DF4A)
References: <1417074298-12254-1-git-send-email-arik@wizery.com>
	 <1417074298-12254-2-git-send-email-arik@wizery.com>
	 (sfid-20141127_084459_625553_BD50DF4A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-27 at 09:44 +0200, Arik Nemtsov wrote:
> If a wiphy-idx is specified, the kernel will return the wiphy specific
> regdomain, if such exists. Otherwise return the global regdom.
> 
> When no wiphy-idx is specified, return the global regdomain as well as
> all wiphy-specific regulatory domains in the system, via a new nested
> list of attributes.

Is that really a good idea? Seems rather easy to overrun the message
size with that, in which case your current code will not return anything
at all... that'll cause strange errors if somebody plugs in a few
devices or has hwsim open as well or so ...

> Add a new attribute for each wiphy-specific regdomain, for usermode to
> identify it as such.

Shouldn't userspace also *request* this for backward compatibility?
Otherwise older userspace might assume that a returned regd applies to
everything, when it doesn't really?

johannes

