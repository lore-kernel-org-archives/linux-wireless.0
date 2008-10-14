Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:1987 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYJNQZM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 12:25:12 -0400
Message-ID: <48F4C7E8.4020201@tpi.com> (sfid-20081014_182519_109984_4FB94716)
Date: Tue, 14 Oct 2008 10:25:12 -0600
From: Tim Gardner <timg@tpi.com>
Reply-To: timg@tpi.com
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ipw2200: Change driver default policies
References: <20081014145708.CAF215A1D8@sepang.rtg.net> <1223998992.3936.28.camel@localhost.localdomain>
In-Reply-To: <1223998992.3936.28.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Tue, 2008-10-14 at 08:57 -0600, Tim Gardner wrote:
>> From 41804698de6f2ce121c1452943b9ad2b8a54988b Mon Sep 17 00:00:00 2001
>> From: Tim Gardner <tim.gardner@canonical.com>
>> Date: Tue, 14 Oct 2008 08:16:09 -0600
>> Subject: [PATCH] ipw2200: change default policies for auto-associate, auto-create, and auto-roaming
>>
>> We now have applications available to set policy. This patch changes the driver defaults to:
>>
>> 1) associate=0 - do not automatically associate to an SSID.
> 
> This one is fine.
> 
>> 2) auto_create=0 - do not automatically create an ad-hoc network
> 
> This will break adhoc network creation, thus NAK.  I think we should
> just remove the module parameter and default to 1 anyway.  This is the
> way adhoc _should_ work in the first place, if the adhoc network you're
> attempting to join does not yet exist, the driver should create that
> network.  This is the way it works for all other drivers as well.
> 
> Disabling this effectively means you can only join existing adhoc
> networks, not start your own.
> 

Agreed - I missed the part where its qualified by IW_MODE_ADHOC.

>> 3) roaming=0 - do not automatically roam to another AP with the same SSID.
> 
> Not really sure why this should be changed?  Were there reported issues
> with this behavior?
> 

Its been my expereince that wireless drivers rarely make the correct
decision about when or where to roam. It also seems like a policy
decision that ought to be made elsewhere.

Frankly, I'm not that concerned about the roaming option. The default
for 'associate' was the one I _really_ wanted changed. I'll submit a v2
patch with just that change.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
