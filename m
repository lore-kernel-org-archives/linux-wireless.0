Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934764Ab3FSUgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 16:36:47 -0400
Message-ID: <1371674192.8349.28.camel@jlt4.sipsolutions.net> (sfid-20130619_223650_431239_E1025EE5)
Subject: Re: [PATCH 2/2] cfg80211: hold BSS over association process
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jun 2013 22:36:32 +0200
In-Reply-To: <51C21476.2070401@candelatech.com>
References: <1371650017-14293-1-git-send-email-johannes@sipsolutions.net>
	 <1371650017-14293-2-git-send-email-johannes@sipsolutions.net>
	 <51C21476.2070401@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-19 at 13:28 -0700, Ben Greear wrote:
> On 06/19/2013 06:53 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > This fixes the potential issue that the BSS struct that we use
> > and later assign to wdev->current_bss is removed from the scan
> > list while associating.
> >
> > Also warn when we don't have a BSS struct in connect_result
> > unless it's from a driver that only has the connect() API.
> 
> I ran these two patches, plus my memory debugging patch
> on top of wireless-testing (in relatively light testing).
> 
> It appears to fix the leaks I was seeing.
> 
> Just to make sure I am not missing something:
> 
> mac80211 should never take an additional reference
> on the bss related to auth_data now?

On *auth_data* it takes and (unconditionally) puts one. On *assoc_data*
the reference is only temporarily owned by mac80211 until given back to
cfg80211, and unless mac80211 wanted to have a separate one afterwards
it doesn't need one (it would probably make sense to take one for
"ifmgd->associated" though, but currently it relies on that being the
same as "wdev->current_bss")

johannes

