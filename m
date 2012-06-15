Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3998 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab2FOLGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 07:06:52 -0400
Message-ID: <4FDB1740.60707@broadcom.com> (sfid-20120615_130738_443698_86A91CA1)
Date: Fri, 15 Jun 2012 13:06:40 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Kalle Valo" <kvalo@qca.qualcomm.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, me@bobcopeland.com,
	mickflemm@gmail.com
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1339228530.4539.0.camel@jlt3.sipsolutions.net>
 <4FD3A936.8070600@broadcom.com>
 <1339399952.4520.13.camel@jlt3.sipsolutions.net>
 <4FD60369.80108@qca.qualcomm.com>
 <1339425944.4520.27.camel@jlt3.sipsolutions.net>
 <20120614193104.GD32257@tux>
 <1339748211.4512.6.camel@jlt3.sipsolutions.net>
 <4FDAF096.200@qca.qualcomm.com>
In-Reply-To: <4FDAF096.200@qca.qualcomm.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2012 10:21 AM, Kalle Valo wrote:
> On 06/15/2012 11:16 AM, Johannes Berg wrote:
>>> As for a name, I thought about it for a while and given that we have different
>>>> "wireless" technologies -- bluetooth, NFC, naming this CONFIG_WIRELESS_EXPERT
>>>> seemed odd, and given that our 802.11 framework is under cfg80211 naming it
>>>> CONFIG_CFG80211_EXPERT seemed appropriate. But even if its under cfg80211
>>>> perhaps something more explicit about the implications may be better, how
>>>> about CONFIG_CFG80211_MAY_BREAK_CERTIFICATION ?
>>
>> Or you could just be explicit about it and call it
>> CONFIG_WIRELESS_REGULATORY_BREAKAGE or something like that :-)
> 
> CONFIG_WIRELESS_CERTIFIED?
> 
> Kalle
> 

Kalle,

That one looks familiar ;-) Although that name makes sense for a feature
like DFS, I think the intended use is also to hide features from unaware
users that will definitely violate with regulatory requirements.

Luis,

Is this flag purely intended for 802.11 device drivers or can it also be
used to hide certain features in stack (ie. cfg80211 or mac80211). If it
is only for device drivers I would suggest to have it depend on
CONFIG_WLAN. Suggestion for the config option:

CONFIG_WLAN_CERTIFIED_OR_SCIENTIFIC_USE

Gr. AvS

