Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59477 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbbCRJq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 05:46:29 -0400
Message-ID: <1426671981.3001.12.camel@sipsolutions.net> (sfid-20150318_104633_085719_81467C4E)
Subject: Re: [PATCH] mac80211: stop scan before connection
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Spinadel <david.spinadel@intel.com>
Date: Wed, 18 Mar 2015 10:46:21 +0100
In-Reply-To: <CAB3XZEd7cQwKm_yLztzeTB0S_-uEp4FwzDUV1O8cG6mNtkiY_A@mail.gmail.com> (sfid-20150318_103655_610322_AA890276)
References: <1426615118-17516-1-git-send-email-emmanuel.grumbach@intel.com>
	 <CAB3XZEd7cQwKm_yLztzeTB0S_-uEp4FwzDUV1O8cG6mNtkiY_A@mail.gmail.com>
	 (sfid-20150318_103655_610322_AA890276)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-18 at 11:36 +0200, Eliad Peller wrote:
> On Tue, Mar 17, 2015 at 7:58 PM, Emmanuel Grumbach
> <emmanuel.grumbach@intel.com> wrote:
> > From: David Spinadel <david.spinadel@intel.com>
> >
> > Stop scan before authentication or association to make sure
> > that nothing interferes with connection flow.
> >
> this makes sense
> 
> > Currently mac80211 defers RX auth and assoc packets (among other ones)
> > until after the scan is complete, so auth during scan is likely to fail
> > if scan took too much time.
> >
> but i don't think deferring the frame handling makes sense in case of
> hw_scan (there was a similar case with BA request handling).
> i should have such (one-liner) patch pending somewhere...

We did consider that, but ultimately I think it's not desirable.

The aggregation case is different, but during auth/assoc the relevant
frames cannot be buffered by the AP. So unless you have a hardware
mechanism that makes the device not continue the scan for say 30-50ms
after the auth/assoc req frame went out, the connection process will be
very unreliable.

So in a sense you could say deferring the handling doesn't make sense,
but I'd still argue you shouldn't start this process while you're in the
middle of scanning, hence this patch.

We may have to do more exclusions (e.g. don't start a scan while
authenticating or associating) here though, and ultimately not
*processing* the frames will be irrelevant as they shouldn't be coming
in anyway.

johannes

