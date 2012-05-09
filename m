Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45894 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471Ab2EIOTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 10:19:23 -0400
Message-ID: <4FAA7CE4.1060609@candelatech.com> (sfid-20120509_161954_153143_1303F628)
Date: Wed, 09 May 2012 07:19:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: allow low-level drivers to set netdev feature
 bits
References: <1336506821-23709-1-git-send-email-arik@wizery.com>  <1336506821-23709-2-git-send-email-arik@wizery.com>  (sfid-20120508_215421_663017_FEC8F401) <1336543867.4323.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336543867.4323.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2012 11:11 PM, Johannes Berg wrote:
> On Tue, 2012-05-08 at 22:53 +0300, Arik Nemtsov wrote:
>> Allow low-level drivers to change the feature bit for a vif's underlying
>> net_device struct.
>
> What are you planning to use this for? I'm not really sure I see the
> need for an exported function? Is it not going to just be set the same
> for all interfaces?
>
> Out of the many netdev feature bits, we can handle maybe a handful in
> mac80211, so I'm worried this API will suggest to people they can look
> at netdev_features.h...

If the regular ethtool api is implemented, we might could support
some of the features like 'rx-all' that instruct the driver to
pass (more) errored frames up the stack...

But, I have no idea what the original poster was trying to accomplish.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
