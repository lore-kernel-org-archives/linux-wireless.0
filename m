Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39676 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab0GZUlR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 16:41:17 -0400
Message-ID: <4C4DF2E8.7060502@openwrt.org>
Date: Mon, 26 Jul 2010 22:41:12 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: improve aggregation throughput by
 	using only first rate
References: <AANLkTimWoSTAtb0m9V=0CNowhy=KtpiKj-O3vdmV8qxB@mail.gmail.com>	<4C4DC98E.6090002@openwrt.org>	<AANLkTinZ=KDo4aJU6Z93p1DXghF_MzE9CeBN6OuC_LnD@mail.gmail.com>	<4C4DE4F5.3010907@openwrt.org> <AANLkTikcW5Gx6P2-6w_Vmeh7kEDGuEHcY=U_jbH3tYhT@mail.gmail.com>
In-Reply-To: <AANLkTikcW5Gx6P2-6w_Vmeh7kEDGuEHcY=U_jbH3tYhT@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-26 10:37 PM, Björn Smedman wrote:
> 2010/7/26 Felix Fietkau <nbd@openwrt.org>:
>> On 2010-07-26 9:23 PM, Björn Smedman wrote:
>>> 2010/7/26 Felix Fietkau <nbd@openwrt.org>:
>>> * When tx is aggregated most rate control probe frames end up inside
>>> aggregates and are never used for probing (effective probe frequency
>>> is divided by average aggregate length).
>> Nope, a probing frame never ends up inside an aggregate. It's always
>> sent out as a single frame, which is why I had to make the decision
>> about sending a probing frame more complex in minstrel_ht, compared to
>> minstrel - the previous 10% stuff was limiting aggregation size.
> 
> Ok, I must have jumped to conclusions. I looked quickly at the code
> and had the impression that it only cared about the RATE_PROBE flag if
> it was on the first subframe of the aggregate, and then I compared
> debug output from rc and xmit like this:
Oh, wait. It seems that you may be right after all. I think I was
remembering stuff from the wrong codebase again Well, at least what I
described is what I think the code should be doing ;)

- Felix
