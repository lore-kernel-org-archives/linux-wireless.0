Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:43648 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab3BAJkd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 04:40:33 -0500
Message-ID: <510B8D87.8050604@neratec.com> (sfid-20130201_104037_960370_A8B21C2E)
Date: Fri, 01 Feb 2013 10:40:23 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection command/event
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de> <1359642321.8415.56.camel@jlt4.sipsolutions.net> <20130131161346.GA1387@pandem0nium> <1359650760.8415.91.camel@jlt4.sipsolutions.net> <20130131174443.GB2018@pandem0nium>
In-Reply-To: <20130131174443.GB2018@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2013 06:44 PM, Simon Wunderlich wrote:
> On Thu, Jan 31, 2013 at 05:46:00PM +0100, Johannes Berg wrote:
>> On Thu, 2013-01-31 at 17:13 +0100, Simon Wunderlich wrote:
>> [...]
>>
>> Maybe so, I just don't think you need the time there since it won't be
>> of relevance in the USABLE state. The "state entered" time is only used
>> for UNAVAILABLE.
>>
>> Maybe therefore state_entered should be renamed to "unavailable_until"
>> with the corresponding change in the logic of adding the time when it's
>> set to that state?
> 
> Can do that, if no one is interested in when we, say, change from unavailable
> to usable (after NOP). This is what Zefir asked for. 
> 
My assumption was that the user (or the certification lab engineer) might want to
know how long the device is going to remain in CAC. And since a time-stamp must be
kept anyhow for NOP, with the (channel_state / ts) tuple everything needed to
track the state transition is already there. Otherwise, it is not needed.

> Personally I don't care at all, and we discuss that in the cover letter thread
> anyway. Let's see what Zefir says or if anyone else objects, I put that onto
> the "TODO if nobody objects list". :)
> 
No objections here. The updated concept makes my work already way easier to
handle, and since I need to implement a frequency manager / planner anyhow on
higher layers, there's no need to consider my comments unless they are relevant
for stand-alone operation.

> Thanks!
> 	Simon
> 

