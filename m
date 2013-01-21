Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:57048 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab3AUKo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 05:44:27 -0500
Message-ID: <50FD1C06.1050300@neratec.com> (sfid-20130121_114430_423363_3E1CBAFA)
Date: Mon, 21 Jan 2013 11:44:22 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 3/6] nl80211/cfg80211: add radar detection command/event
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>  <1357650251-17425-4-git-send-email-siwu@hrz.tu-chemnitz.de>  <1358376672.15012.37.camel@jlt4.sipsolutions.net>  <20130117134034.GC19552@pandem0nium> <1358546080.7922.36.camel@jlt4.sipsolutions.net>
In-Reply-To: <1358546080.7922.36.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2013 10:54 PM, Johannes Berg wrote:
> On Thu, 2013-01-17 at 14:40 +0100, Simon Wunderlich wrote:
> 
>> Actually there is no limit how long a channel is considered "available", at
>> least in ETSI. ETSI EN 301-893 v1.4.1 had a limit of 24 hours for that,
>> but that was removed in v1.5.1 and didn't re-appear since then (current is
>> v1.7.1).
> 
> Huh indeed, I would have expected that to be there. It does have a
> non-occupancy time though (30 minutes), maybe we should implement that?
> 
No, why be more restrictive than regulatory demands?

With the recent incremental updates, a general note: Victor's initial approach was
to keep all logic in hostapd and minimize the modifications in mac by only
ensuring CAC times there. If NOP handling is also added to mac, we'd have
everything needed to handle DFS channel states available. With hostapd only left
to do the selection of the channel to switch to after a radar detection, it might
make sense to move everything down to mac. I understand that questioning the
design that late is not helpful, at the same time and since the initial path was
left, it might be worth considering.

> I'm also thinking with the next regdb format update we should allow
> specifying these timeouts etc. there.
> 
> Does anyone have the relevant FCC rules? I can't find anything with
> google ...
> 
The FCC 06-96 document (freely available, e.g.
http://hraunfoss.fcc.gov/edocs_public/attachmatch/FCC-06-96A1.pdf) seems to be the
most recent one. Skimming over I did not find a requirement for the validity
period after CAC.

>> But we can move the CAC/timeout in the wdev and have keep a flag field in
>> the channel struct instead, marking the channel as available, unavailable, etc.
>>
>> What do you think?
> 
> I think that would make sense. Probably available/unavailable and
> "non-occupancy until"?
> 
At that stage, we would have half of all potential states (UNKNOWN, AVAILABLE,
OPERATING, UNAVAILABLE, USABLE, SCANNING) covered, so a current state per channel
and the time it was entered would give everything required for the complete state
machine in mac.

> 
> [...]
