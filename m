Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:34177 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab3AXMTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 07:19:10 -0500
Message-ID: <510126B4.4090502@neratec.com> (sfid-20130124_131917_361116_0845C1D9)
Date: Thu, 24 Jan 2013 13:19:00 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 0/6] Add DFS master ability
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1358378574.15012.62.camel@jlt4.sipsolutions.net> <20130117142125.GF19552@pandem0nium> <1358546933.7922.49.camel@jlt4.sipsolutions.net> <50FD1C7C.5050606@neratec.com> <20130123125228.GC23989@pandem0nium>
In-Reply-To: <20130123125228.GC23989@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2013 01:52 PM, Simon Wunderlich wrote:
> On Mon, Jan 21, 2013 at 11:46:20AM +0100, Zefir Kurtisi wrote:
> [...] 
> 
>> Why then bother with CAC at all, one might think. In fact, exploiting given
>> requirements to such extent is mandatory to make operation on DFS channels usable
>> (which btw. is not the scope of the patches discussed here).
>>
> 
> I would actually like to make operation on DFS channels usable by using the implementation
> from these patches. :) Do you imply that we couldn't practically use it? Any suggestions
> what can be improved?
> 
> Cheers,
> 	Simon
> 
Hi Simon,

I realize that my last statement is misleading, given that there are different
levels for being 'usable'. The current DFS master support will allow to certify,
but how usable will those devices will operate? I'll try to explain my concerns
based on what is needed for the products I am currently working on. It got
longish, so here is the short version.

tl;dr: we can't integrate DFS support for managed master devices in Linux
wireless, since that requires breaking the existing regulatory statement.


The long version bases on the fact that in any setup we will face false radar
events that are degrading usability. The inevitability of false detections is
given by the existence of interferences not distinguishable from radar pulses and
the regulatory requirement to detect incomplete patterns with a given probability.
Set up as radar monitor, we measured false detections between once a day and
several per hour. This is the best case, since in master mode the numbers
significantly increase (traffic type dependent). These observations were done with
Atheros hardware, but given their general cause, lets deal with regular false
events we need to handle.

So, who is going to use DFS channels and how? It is maybe not the home user, who
will disable them as soon as he looses connectivity for minutes again - he can do
just fine with non-DFS channels (that's maybe why there are so few consumer
products with working DFS support out there).

Industrial applications however depend on using them for their higher tx power
allowed and to escape the crowded non-DFS channels. At the same time, they do not
tolerate service interruption: our devices are controlling trains over WiFi - and
you do not want them to stop on every CAC ;) Obviously, the only way to achieve
continuous connectivity on DFS channels is to go the managed approach combining
master and sensor nodes. There, on top of what you and Johannes already discussed
(re-use wiphy0's CAC results for wiphy1), you need to be able to re-use the
channel information of nearby nodes.

And that's finally my point: to be able to skip CAC for a DFS channel based on
external information, you need to provide means to override your own channel
states - which in turn allows to bypass regulatory requirements and therefore
breaks the Linux wireless regulatory statement.


I don't see an easy way to expose those mechanisms to manufacturers but prevent
mis-use by the 'common user'. Are there?


Cheers,
Zefir

