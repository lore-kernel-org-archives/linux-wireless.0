Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52207 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032852Ab2CPPG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 11:06:27 -0400
Message-ID: <4F6356F0.5060307@candelatech.com> (sfid-20120316_160631_246052_7AA08EFB)
Date: Fri, 16 Mar 2012 08:06:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] cfg80211:  Add framework to support ethtool stats.
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com> <4F631087.4040509@openwrt.org>
In-Reply-To: <4F631087.4040509@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2012 03:05 AM, Florian Fainelli wrote:
> Hi,
>

> I do not think this is particularly a good idea to make eththool report wireless interfaces statistics:
> - these are 802.11 interfaces and so they have specific statistics to report which are different from pure ethernet adapters
> - people will start adding more statistics to ethtool because this or that wifi-specific counter is not reported, it is abusing the tool imho.

The ethtool stats are designed to display custom driver stats in a somewhat standard manner.  There is no
expectation as to what stats are or should be available..some new wired Intel drivers report great numbers of
stats, and some drivers report none.

But, assuming we do not change the stat names all the time (adding new ones or re-arranging order is fine),
a tool can be written to parse the stats on a per-driver basis without much difficulty.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
