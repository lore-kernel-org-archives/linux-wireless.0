Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52462 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdKQJpS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2017 04:45:18 -0500
Message-ID: <1510911915.2030.37.camel@sipsolutions.net> (sfid-20171117_104523_632334_6888C554)
Subject: Re: What would it take to get WDS working with channel contexts?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 17 Nov 2017 10:45:15 +0100
In-Reply-To: <24f85baf-5e19-a2c9-517d-9b69a47860d9@candelatech.com> (sfid-20171117_012807_810321_F19CD790)
References: <24f85baf-5e19-a2c9-517d-9b69a47860d9@candelatech.com>
         (sfid-20171117_012807_810321_F19CD790)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-11-16 at 16:28 -0800, Ben Greear wrote:
> I have a user interested in getting WDS working on ath10k, but evidently
> this is not supported since ath10k uses channel-contexts:
> 
>  From net/mac80211/main.c:
> 
> 		/*
> 		 * WDS is currently prohibited when channel contexts are used
> 		 * because there's no clear definition of which channel WDS
> 		 * type interfaces use
> 		 */
> 
> 
> Anyone have any suggestions as to how this could be made to work?

You probably don't want to hear this, but:

WDS isn't even properly working without them right now, since for
example there's absolutely no feature negotiation between the peers as
to which rates and other capabilities, bandwidths, etc. are acceptable
(at any given moment in time).

I therefore don't see any value in WDS mode at all unless these issues
are fixed [*], and as such wouldn't want to take any patches that just
do some minimal patching over to allow it with channel contexts.

If you ask me, WDS is entirely useless without vendor-specific
extensions to allow newer features, and the Linux "vendor-specific"
extension to do that is AP/client 4-addr mode.

johannes

[*] and since the spec doesn't define this, you can't even fix them in
any reasonable way, I think, unless you implement some vendor-specific
things that maybe one vendor happens to do.
