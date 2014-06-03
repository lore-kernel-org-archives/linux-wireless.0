Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60143 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbaFCTlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 15:41:05 -0400
Message-ID: <1401824450.4157.33.camel@jlt4.sipsolutions.net> (sfid-20140603_214109_652015_9FAF04AA)
Subject: Re: [PATCH v2 0/2] mac80211: fix csa counters
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Tue, 03 Jun 2014 21:40:50 +0200
In-Reply-To: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com> (sfid-20140529_084615_275117_B8961B0E)
References: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140529_084615_275117_B8961B0E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-29 at 08:38 +0200, Michal Kazior wrote:
> Hi,
> 
> I was seeing strange WARN_ON splat loops and
> crashes while I was testing my multi-vif CSA.
> 
> CSA counters weren't properly reset and on some
> failpaths this caused a mess. There were also
> possible SMP inconsitencies/races.

Thanks. This doesn't seem to apply any more though, something in
ieee80211_csa_is_complete(). I think the fixup is easy, but would prefer
if you'd do it since (hopefully :) ) you can also check the result.

I'm guessing the conflict is with some of Andrei's recent patches.

Thanks,
johannes

