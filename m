Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58425 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GFVaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 17:30:08 -0400
Message-ID: <4FF758DB.5010206@candelatech.com> (sfid-20120706_233014_251746_57CE4D89)
Date: Fri, 06 Jul 2012 14:30:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] mac80211 scanning restructuring
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2012 02:05 PM, Johannes Berg wrote:
> I decided that with multi-channel coming and thus us using more
> virtual interfaces, the scanning code was going to be the first
> victim of some factoring ;-)
>
> Please review. The only thing that isn't quite clear to me is
> whether or not I can really remove the channel == oper_channel
> check, but it's only applied to probe resp/beacon frames so it
> seems a bit pointless to try to keep it?

For what it's worth, I don't see any problems with the patches.

Another enhancement I was thinking about would be to allow
vifs to piggy-back on other vif's scans.  Instead of
returning EBUSY when another vif is already scanning, just
register to receive the scanning vif's results when it finishes.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com



