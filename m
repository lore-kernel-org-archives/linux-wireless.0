Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33441 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759058AbaGXNBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 09:01:31 -0400
Message-ID: <1406206885.14675.19.camel@jlt4.sipsolutions.net> (sfid-20140724_150658_801745_DB9B192F)
Subject: Re: [PATCHv2 1/2] cfg80211: extend coverage_class datatype
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Philippe Duchein <wireless-dev@duchein.net>
Date: Thu, 24 Jul 2014 15:01:25 +0200
In-Reply-To: <CAA2SeN+zR_CUp4S7Vs0THpaMBKJqkwAPJdrDddhsxL4E1hhV3g@mail.gmail.com> (sfid-20140724_142118_544086_356FEDD1)
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406198362-4999-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406200256.14675.17.camel@jlt4.sipsolutions.net>
	 <CAA2SeN+zR_CUp4S7Vs0THpaMBKJqkwAPJdrDddhsxL4E1hhV3g@mail.gmail.com>
	 (sfid-20140724_142118_544086_356FEDD1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-24 at 14:21 +0200, Lorenzo Bianconi wrote:

> Currently iw does not allow to set both attribute at the same time,
> but I can use "if-else if" statement in order to exclude that
> condition.

I think you should explicitly reject the configuration if both
attributes are given, not silently use one of them.

> > You should also have a feature flag that drivers set that you test here
> > and refuse dynamic if it's not supported, I guess?
> >
> 
> I would rely on lower drivers to fail (returning -EOPNOTSUPP to
> set_coverage_class caller) if dynack it is not supported and user is
> trying to enable it. Does it sound good for you?

I imagined you'd want to know in 'iw list' whether or not it's supported
too.

johannes

