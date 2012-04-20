Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab2DTHga (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 03:36:30 -0400
Date: Fri, 20 Apr 2012 09:36:33 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: add option to disable 5GHz band
Message-ID: <20120420073630.GA2393@redhat.com> (sfid-20120420_093633_626412_B7692256)
References: <1334830280-3019-1-git-send-email-sgruszka@redhat.com>
 <4F901F51.3000704@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F901F51.3000704@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 19, 2012 at 07:21:05AM -0700, Johannes Berg wrote:
> On 4/19/2012 3:11 AM, Stanislaw Gruszka wrote:
> >There are various problems happened on 5GHz band not observed on
> >2.4 GHz (microcode errors, queue stuck, etc... ) . Also roaming
> >between 5GHz AP and 2GHz does not work very well. To workaround
> >the problems add option to disable 5GHz support. This will help
> >on environments where APs are dual-band, and devices will not try
> >to associate on band where issues happen.
> 
> Would it make sense to somehow do this in cfg80211?
It has more sense, but doing this in cfg80211 is a bit more complicated,
at least I do not see an easy way. 

> Today, our
> driver may be the only one having this problem (which I've never
> really heard about?)
I filed bug 2351 on your bugzilla, which explicitly state issue it's
a 5GHz problem.

There are various other bug reports about iwlwifi random malfunction
(with no message in dmesg or queue stuck or microcode error). Some of
them are probably 5GHz problem too, but since nobody work on that
bugzillas nobody figure this out.

Regarding 2GHz <-> 5GHz roaming, I'm seeing lot's of problems with that
on older kernels. Did not test on new kernel though. Perhaps issues are
now mitigated or fixed by your assoc/auth redesign, but I did not check
yet.

Stanislaw

