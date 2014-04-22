Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stator.leun.net ([85.214.203.199]:35499 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933273AbaDVRbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 13:31:11 -0400
Date: Tue, 22 Apr 2014 19:30:29 +0200
From: Michael Leun <lkml20140418@newton.leun.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>,
	Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
Message-ID: <20140422193029.2d81fac5@xenia.leun.net> (sfid-20140422_193119_207470_FCD75F3E)
In-Reply-To: <CAB=NE6W64b5VS5pTnxrcRRkRdje6h_hQcGmF9jUiXO55b+nHRw@mail.gmail.com>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
	<20140422180003.6438dbb7@xenia.leun.net>
	<CAB=NE6URp2S9rhVr2cqT+4VOj50m+q0o1rVRehCZvcUtNwTVVw@mail.gmail.com>
	<20140422184824.74973bb3@xenia.leun.net>
	<CAB=NE6W64b5VS5pTnxrcRRkRdje6h_hQcGmF9jUiXO55b+nHRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 22 Apr 2014 10:04:19 -0700
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> On Tue, Apr 22, 2014 at 9:48 AM, Michael Leun
> <lkml20140418@newton.leun.net> wrote:
> > 1611                    if (wiphy->regulatory_flags &
> > REGULATORY_COUNTRY_IE_IGNORE) 1612
> > return REG_REQ_IGNORE;
> 
> Interesting -- same line as your regression test had found, wiphy->
> must be NULL. Digging deeper, you can discard that patch now, we can
> rule out the reprocessing of the request.


OK, but if this adds any useful information: Meanwhile I applied the
2nd patch you posted ontop test-ariks-patch-for-314.patch (with some
fuzz), and that did change something:

Does not wait until I try to hibernate to bang, it barfs already during
boot and that seems to look different. Didnt have a chance to copy that
yet, but could, if useful.

-- 
MfG,

Michael Leun

