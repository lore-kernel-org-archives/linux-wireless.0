Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50495 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934694Ab3FSU2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 16:28:43 -0400
Message-ID: <51C21476.2070401@candelatech.com> (sfid-20130619_222858_386253_F2EBD366)
Date: Wed, 19 Jun 2013 13:28:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/2] cfg80211: hold BSS over association process
References: <1371650017-14293-1-git-send-email-johannes@sipsolutions.net> <1371650017-14293-2-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1371650017-14293-2-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 06:53 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> This fixes the potential issue that the BSS struct that we use
> and later assign to wdev->current_bss is removed from the scan
> list while associating.
>
> Also warn when we don't have a BSS struct in connect_result
> unless it's from a driver that only has the connect() API.

I ran these two patches, plus my memory debugging patch
on top of wireless-testing (in relatively light testing).

It appears to fix the leaks I was seeing.

Just to make sure I am not missing something:

mac80211 should never take an additional reference
on the bss related to auth_data now?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

