Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51436 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357Ab2GLLGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 07:06:21 -0400
Message-ID: <4FFEAFAA.3030601@openwrt.org> (sfid-20120712_130624_771453_AD7C40F8)
Date: Thu, 12 Jul 2012 13:06:18 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 08/12] ath9k: fix aggregate size limit based on queue
 TXOP limit
References: <1342029555-31618-1-git-send-email-nbd@openwrt.org> <1342029555-31618-2-git-send-email-nbd@openwrt.org> <1342029555-31618-3-git-send-email-nbd@openwrt.org> <1342029555-31618-4-git-send-email-nbd@openwrt.org> <1342029555-31618-5-git-send-email-nbd@openwrt.org> <1342029555-31618-6-git-send-email-nbd@openwrt.org> <1342029555-31618-7-git-send-email-nbd@openwrt.org> <1342029555-31618-8-git-send-email-nbd@openwrt.org> <20478.28271.704162.754323@gargle.gargle.HOWL>
In-Reply-To: <20478.28271.704162.754323@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-12 8:27 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> If the aggregate size exceeds the TXOP limit, it leads to lots of unnecessary
>> hardware and software retries.
>> 
>> The previous 4ms frame limit table was completely undocumented, the commit
>> that updated it only vaguely referenced and equation from the standard,
>> but I've been unable to replicate its results.
>> 
>> Fix this by using a formula based on the code in ath_pkt_duration, which is
>> more likely to be correct for this case.
> 
> I think this needs to be verified. The 4ms restriction is for Japanese
> regulatory compliance, IIRC.
I did check the generated tables and also tested that it would not
generate aggregates with a duration of more than 4ms.

- Felix
