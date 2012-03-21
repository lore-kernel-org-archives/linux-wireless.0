Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56836 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2CUQUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 12:20:19 -0400
Message-ID: <4F69FFBE.9000607@candelatech.com> (sfid-20120321_172028_954867_7AFD67B2)
Date: Wed, 21 Mar 2012 09:20:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 4/4] ath9k:  Support ethtool getstats api.
References: <1332183105-4447-1-git-send-email-greearb@candelatech.com>  <1332183105-4447-4-git-send-email-greearb@candelatech.com>  <4F684301.9040006@openwrt.org> <4F68B4AA.3070306@candelatech.com>  <20329.32334.162938.169995@gargle.gargle.HOWL> <1332346257.3500.9.camel@deadeye>
In-Reply-To: <1332346257.3500.9.camel@deadeye>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2012 09:10 AM, Ben Hutchings wrote:
> On Wed, 2012-03-21 at 12:37 +0530, Sujith Manoharan wrote:
>> Ben Greear wrote:
>>> I'd like to gather at least most stats always, so ethtool can work regardless
>>> of debugfs.  But, that can be follow on patches in my opinion.  If it turns
>>> out that we need another config option for this, then that is fine too.
>>
>> It would be good to have an option to compile this out. The information is
>> available via the debugfs interface, so this is basically duplicating things.
>> On APs using OpenWRT, debugfs is enabled by default, so we can just read
>> the debugfs files.
>
> ethtool is the normal way to expose extended network stats, so the
> debugfs interface should be dropped in favour of this.

No...ath9k debugfs offers a lot of additional info that is not easily
packaged into ethtool stats, and is better formatted for reading
by humans.

So, both should be kept..though we can optionally compile
out both/either/none.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

