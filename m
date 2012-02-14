Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39730 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab2BNB5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 20:57:10 -0500
Message-ID: <4F39BF5F.3030408@candelatech.com> (sfid-20120214_025719_614852_39343947)
Date: Mon, 13 Feb 2012 17:56:47 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 3/7] ath9k: Merge wiphy and misc debugfs files
References: <20280.43962.403799.188541@gargle.gargle.HOWL> <4F3947A1.2060103@candelatech.com> <20281.48485.409968.741657@gargle.gargle.HOWL>
In-Reply-To: <20281.48485.409968.741657@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2012 05:48 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> It is nice to be able to see what the driver/NIC thinks
>> it is set to as well.  It is always possible that the
>> stack and the NIC are out of sync for some reason.
>> I'd rather those values be left in the debugfs unless
>> there is a good reason for getting rid of them.
>
> The 'wiphy' file is a remnant from the old virtual HW code.
> To know the channel parameters of multiple, virtual PHYs, it
> was useful. Since the operating parameters, channel type, HT
> capabilites etc. are all exposed by mac80211's debugfs, we might

What if there is some bug that causes the NIC to be in a
state different than mac80211 thinks it is?  If you leave
this in, then maybe someone will notice.

Ath9k is a tricky beast to debug, and I think you should
not remove anything that is remotely useful to debugging
unless removing it has a real benefit other than just
decreasing lines of (conditionally compiled) code.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

