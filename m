Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58960 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2LNSKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 13:10:41 -0500
Message-ID: <50CB6B9B.7020508@candelatech.com> (sfid-20121214_191044_206501_77BED70D)
Date: Fri, 14 Dec 2012 10:10:35 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFT 0/3] cfg80211: beacon hint improvements
References: <1355430534-7881-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1355430534-7881-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2012 12:28 PM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> Just a few improvements for beacon hint processing due to
> scheduling considerations and discovered by Ben with a lot of
> stations. For details see:

I added this and Johannes' station cleanup patches to 3.7 and the
600-station tests are running well so far.  I see a few beacon
messages, but no spammage.  (I also backed out my rate-limit
patch on the beacon messages, so if they *were* inclined to spam,
I should have seen it).

So:

Tested-by:  Ben Greear <greearb@candelatech.com>

Thanks,
Ben

>
> http://article.gmane.org/gmane.linux.kernel.wireless.general/101482
>
> Luis R. Rodriguez (3):
>    cfg80211: do not process beacon hints if one is already queued
>    cfg80211: move reg_is_world_roaming()
>    cfg80211: move world roaming check for beacon hints
>
>   net/wireless/reg.c |   48 ++++++++++++++++++++++++++++++++++--------------
>   1 file changed, 34 insertions(+), 14 deletions(-)
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

