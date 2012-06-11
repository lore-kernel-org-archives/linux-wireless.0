Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39027 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2FKOku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 10:40:50 -0400
Message-ID: <4FD60369.80108@qca.qualcomm.com> (sfid-20120611_164106_295809_3866D61C)
Date: Mon, 11 Jun 2012 17:40:41 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <me@bobcopeland.com>,
	<mickflemm@gmail.com>
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>  <1339228530.4539.0.camel@jlt3.sipsolutions.net>  <4FD3A936.8070600@broadcom.com> <1339399952.4520.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339399952.4520.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2012 10:32 AM, Johannes Berg wrote:
> On Sat, 2012-06-09 at 21:51 +0200, Arend van Spriel wrote:
>> On 06/09/2012 09:55 AM, Johannes Berg wrote:
>>> On Fri, 2012-06-08 at 17:51 -0700, Luis R. Rodriguez wrote:
>>>> From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
>>>> 
>>>> Turns out that standard Linux distributions leave
>>>> CONFIG_EXPERT enabled. This makes this option useless for
>>>> wireless testing / research purposes as we don't want certain
>>>> features enabled on all kernel builds. This adds a new
>>>> CONFIG_CFG80211_EXPERT and makes a few features depend on
>>>> them.
>>> 
>>> I'm not sure I see the point in CFG80211_EXPERT. All the features
>>> you're putting in there have nothing to do with cfg80211 at all
>>> anyway.
>> 
>> My understanding of this is that CFG80211_EXPERT was chosen
>> because cfg80211 provides the kernel side of the regulatory
>> framework.
> 
> It just happens though that the two options are related to regulatory
> -- maybe then this should have a different name?

It could be more than that, for example we could also add nl80211
testmode under CFG80211_EXPERT.

> I still don't see the need. What would you put under it in
> brcm[sf]mac? I certainly wouldn't see any reason to put anything
> under it in our driver since it's much simpler to .

Looks like something is missing here?

> Also, the argument about distros doesn't really work that way, if
> there are users interested in something then the distros will
> certainly enable this (CFG80211_EXPERT) option to get something
> hidden behind it.

I would compare this with NL80211_TESTMODE, we don't want distributions
to enable that either. Of course nothing prevents distros to enable
CFG80211_EXPERT but we need to be active to make sure it's not enabled
(ie. check the distro configs and file bugs etc).

Kalle
