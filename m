Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44650 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab0I3PfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 11:35:20 -0400
Message-ID: <4CA4AE35.3050208@candelatech.com>
Date: Thu, 30 Sep 2010 08:35:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] wireless:  Report noise to /proc/net/wireless
References: <1285804637-5400-1-git-send-email-greearb@candelatech.com>	 <1285804637-5400-2-git-send-email-greearb@candelatech.com> <1285832738.3639.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285832738.3639.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2010 12:45 AM, Johannes Berg wrote:
> On Wed, 2010-09-29 at 16:57 -0700, greearb@candelatech.com wrote:
>
>> This adds noise reports to /proc/net/wireless again.
>
> Same comment applies here really...
>
>> + * @noise: noise, as obtained from dump_survey of index 0.
>
> It's not actually obtained that way, because if it was, cfg80211 could
> just handle it by itself.
>
> Additionally, even within mac80211 there's no guarantee that the
> dump_survey(0) callback will give you the correct channel's noise.
>
> Since you can easily obtain this information from userspace (and with
> the extension that Felix proposed you can figure out which noise belongs
> to the operating channel without really knowing the operating channel),
> I don't think we should be doing this.

Do you have a pointer to Felix's proposal?  Maybe I can use whatever API
he came up with to populate /proc/net/wireless with the noise from the current
channel.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
