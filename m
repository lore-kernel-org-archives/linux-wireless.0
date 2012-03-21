Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41087 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2CUCMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 22:12:09 -0400
Message-ID: <4F6938EF.3080205@candelatech.com> (sfid-20120321_031213_705706_29DC92DF)
Date: Tue, 20 Mar 2012 19:11:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: avg-signal is weird in ath9k in 3.3.0
References: <4F68DEE8.60506@candelatech.com> <4F690340.5090102@openwrt.org>
In-Reply-To: <4F690340.5090102@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2012 03:22 PM, Felix Fietkau wrote:
> On 2012-03-20 8:47 PM, Ben Greear wrote:
>> I'm testing out some code to get a stations's avg-signal through ethtool-stats,
>> and both it and /proc/net/wireless show ranges bouncing all over
>> (from around -48 to -110) on an interface running heavy traffic.
>>
>> Are there any known bugs in 3.3.0 related to this?
> As far as I know, this bug has always been there (RSSI values for A-MPDU
> subframes are invalid, except for the last subframe).
> I've sent fixes for this, which will show up in 3.4

I found the two patches and they apply cleanly to 3.3.0, and it
does appear to fix the problem.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
