Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab3BFWFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 17:05:22 -0500
Date: Wed, 6 Feb 2013 16:05:17 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 3/4] mac80211: Improve error handling for off-channel
 operation
Message-ID: <20130206220517.GC6280@thinkpad-t410> (sfid-20130206_230534_312134_5DEBEE3F)
References: <1360162873-17240-1-git-send-email-seth.forshee@canonical.com>
 <1360162873-17240-4-git-send-email-seth.forshee@canonical.com>
 <1360187077.7910.78.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360187077.7910.78.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2013 at 10:44:37PM +0100, Johannes Berg wrote:
> On Wed, 2013-02-06 at 09:01 -0600, Seth Forshee wrote:
> > Errors in sending the nullfunc frame to set powersave at the AP for
> > off-channel operation can lead to high packet loss. Add error handling
> > to fail going off-channel when this happens, and return an error to
> > userspace.
> 
> With the flushes in place, have you ever seen this fail? This and patch
> ones seems like a lot of churn for only half of what you'd want -- what
> you really want is to know if the AP ACKed the frame...

That's a good point. I've seen iw fail to initiate scans, but I can't
say whether or not any of them was due to the queues being stopped for
some reason. When I was testing NetworkManager was still managing the
interface, so at least some failures were undobtedly because another
scan was ongoing.

I'd considered trying to expand this to check whether or not the frame
was acked -- in fact just today I captured a trace where the AP didn't
ack the frame but the STA went off-channel anyway. I'm not sure how to
implement that yet, and haven't found time to look into it.

Seth

