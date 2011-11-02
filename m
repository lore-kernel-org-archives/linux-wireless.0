Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52103 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1KBKqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 06:46:19 -0400
Subject: Re: [PATCH] mac80211: disable powersave for broken APs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bill C Riemers <briemers@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1319795987.8931.7.camel@jlt3.sipsolutions.net> (sfid-20111028_115958_723700_DB411019)
References: <1319795987.8931.7.camel@jlt3.sipsolutions.net>
	 (sfid-20111028_115958_723700_DB411019)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 11:46:12 +0100
Message-ID: <1320230772.3950.45.camel@jlt3.sipsolutions.net> (sfid-20111102_114622_535704_75E50520)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 11:59 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Only AID values 1-2007 are valid, but some APs have been
> found to send random bogus values, in the reported case an
> AP that was sending the AID field value 0xffff, an AID of
> 0x3fff (16383).
> 
> There isn't much we can do but disable powersave since
> there's no way it can work properly in this case.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Bill C Riemers <briemers@redhat.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Bill, please test this patch and see if you still see the
> warnings, or you can revert your iwlwifi changes and test
> then, it should work.
> 
> John, please wait for Bill to test before you apply, just
> to confirm it fixes the issue.

https://bugzilla.redhat.com/show_bug.cgi?id=748548

Bill tested it, thanks!

johannes

