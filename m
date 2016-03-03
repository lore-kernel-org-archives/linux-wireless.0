Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:37858 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751067AbcCCPDx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:03:53 -0500
Subject: Re: [PATCH v2 2/2] mac80211: minstrel_ht: set A-MSDU tx limits based
 on selected max_prob_rate
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1456306140-78485-1-git-send-email-nbd@openwrt.org>
 <1456306140-78485-2-git-send-email-nbd@openwrt.org>
 <1457016949.2044.12.camel@sipsolutions.net>
Cc: egrumbach@gmail.com
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56D85246.8070306@openwrt.org> (sfid-20160303_160355_936410_D5CA588F)
Date: Thu, 3 Mar 2016 16:03:34 +0100
MIME-Version: 1.0
In-Reply-To: <1457016949.2044.12.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-03-03 15:55, Johannes Berg wrote:
> On Wed, 2016-02-24 at 10:29 +0100, Felix Fietkau wrote:
> 
>> +	/*
>> +	 * If the rate is slower than single-stream MCS4, limit A-MSDU to usual
>> +	 * data packet size
>> +	 */
>> +	if (g->duration[rate] > MCS_DURATION(1, 0, 104))
>> +		return 1500;
>> +
>> +	/*
>> +	 * If the rate is slower than single-stream MCS7, limit A-MSDU to twice
>> +	 * the usual data packet size
>> +	 */
>> +	if (g->duration[rate] > MCS_DURATION(1, 0, 260))
>> +		return 3000;
> 
> This isn't *quite* right, since you have to take an 802.11 header (vs.
> an ethernet header) into account, I think?
It's only a rough approximation anyway to prevent very large A-MSDUs
from being created with low rates.

- Felix
