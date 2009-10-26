Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25935 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbZJZJxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 05:53:21 -0400
Message-ID: <4AE57165.5060309@nokia.com>
Date: Mon, 26 Oct 2009 11:52:37 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Kalle Valo <kalle.valo@iki.fi>
CC: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>
Subject: Re: [RFC 1/3] mac80211: WIP - add operating BSSID to device configuration
 struct
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>	<1255696042-28413-2-git-send-email-luciano.coelho@nokia.com>	<1256201719.12174.19.camel@johannes.local>	<4AE291DC.3010505@nokia.com> <87pr8ah7pi.fsf@purkki.valot.fi>	<4AE56792.8080401@nokia.com> <87ljiyh5bv.fsf@purkki.valot.fi>
In-Reply-To: <87ljiyh5bv.fsf@purkki.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Kalle Valo wrote:
> Luciano Coelho <luciano.coelho@nokia.com> writes:
> 
>>>> As we discussed on IRC, it is really needed.  We must always provide a
>>>> BSSID when changing channels in preparation for an association.
>>> I'm not sure about the must part here. Maybe we can workaround it by
>>> using ff:ff:ff:ff:ff bssid during authentication and association and
>>> send a new join command after association. But that's not a clean
>>> solution.
>> During one of our camps with TI, they told us that we must send the
>> correct BSSID, otherwise we are going to have some side-effects.  At
>> least BT coext will be affected.  And we have also seen the firmware
>> send probe_reqs to ff:ff:ff:ff:ff:ff, which was causing problems.
>> The firmware is simply not designed to do this. 
> 
> So wl1271 sends a probe request in every join command?

Not for every join command, but we observed some time ago, that the firmware was 
sending broadcast probe_reqs on its own and we figured out that the issue was 
related to the broadcast join commands.  Again, we don't really know how the 
firmware works, because we don't have access to the source, but according to TI 
  we can experience weird side-effects if we try to do it as you propose (and as 
we were doing earlier).


>> You probably also remember that we have recently removed extra joins
>> from the wl1251 code as well, because they were causing some
>> problems.
> 
> I think in wl1251 we would be able to workaround this with a careful
> placement of join and disconnect commands, but it would be really
> complicated. Having proper support in mac80211 is much better choice.

In wl1251 it *may* work.  But not because the firmware supports it, but simply 
because you may be lucky and not trigger any unexpected side-effect.  In any 
case, it would really be a workaround and I think it would be better to have 
support for this on the stack, so we can do things as specified in the WiLink 
firmware APIs.  We probably have a slight chance of convincing TI to fix this in 
future firmwares, but I'm almost sure it won't happen for the wl1251 and it is 
very unlikely to happen for wl1271.

-- 
Cheers,
Luca.
