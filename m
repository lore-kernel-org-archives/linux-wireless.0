Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44882 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbbBYKee (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 05:34:34 -0500
Message-ID: <1424860462.2050.10.camel@sipsolutions.net> (sfid-20150225_113436_819873_E12ACD8A)
Subject: Re: [PATCH v3] wext: Return -E2BIG when the buffer is too small for
 the full scan results, including IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: James Minor <james.minor@ni.com>
Cc: linville@tuxdriver.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, xander.huff@ni.com, joshc@ni.com,
	joseph.hershberger@ni.com, ben.shelton@ni.com, jaeden.amero@ni.com,
	rich.tollerton@ni.com, brad.mouring@ni.com
Date: Wed, 25 Feb 2015 11:34:22 +0100
In-Reply-To: <1424804300-7469-1-git-send-email-james.minor@ni.com>
References: <1424707044.3075.14.camel@sipsolutions.net>
	 <1424804300-7469-1-git-send-email-james.minor@ni.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-24 at 12:58 -0600, James Minor wrote:
> When using the wext compatibility code in cfg80211, part of the IEs
> can be truncated if the passed user buffer is large enough for the
> BSS but not large enough for all of the IEs.  This can cause an EAP
> network to show up as a PSK network.
> 
> These changes allow the scan to always return -E2BIG in that case.

I've applied a patch similar to this - please check mac80211-next. I
wasn't really happy with the inline either after I looked more closely,
so I created new _check() wrappers in the wext header file and used
those here now.

I did change the control flow, which you seem to have been reluctant to
do, but it ultimately seemed like the better option.

johannes

