Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13150 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab0LPM2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 07:28:01 -0500
Received: from kpbe11.cbf.corp.google.com (kpbe11.cbf.corp.google.com [172.25.105.75])
	by smtp-out.google.com with ESMTP id oBGCS0wQ025284
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 04:28:00 -0800
Received: from iwn39 (iwn39.prod.google.com [10.241.68.103])
	by kpbe11.cbf.corp.google.com with ESMTP id oBGCRwe1002971
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 04:27:59 -0800
Received: by iwn39 with SMTP id 39so3633753iwn.41
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 04:27:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292501047.3612.9.camel@jlt3.sipsolutions.net>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
	<1292482775.3542.8.camel@jlt3.sipsolutions.net>
	<AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
	<1292499024.3612.3.camel@jlt3.sipsolutions.net>
	<AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
	<1292501047.3612.9.camel@jlt3.sipsolutions.net>
Date: Thu, 16 Dec 2010 04:27:58 -0800
Message-ID: <AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 4:04 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-12-16 at 03:51 -0800, Paul Stewart wrote:
>> Fixing the problem in ath9k
>> alone causes a separate problem.  If you stop the driver from mac80211's
>> pm.c, ath9k would set the device ps_idle, when mac80211 does not
>> consider the device to to be idle.  Thus, when we resume from suspend,
>> the device stays quiescent (mac80211 has no reason to believe it needs
>> to do anything special to be able to tx, receive beacons, etc.)
>
> How so? After resume, mac80211 will invoke start(), add interfaces and
> stations back, and then invoke drv_config with all flags in "changed"
> set. Therefore, at this point, the device should be reset. Where's this
> not working?

I haven't dug deep into it, but I can guess at a reason -- ath9k stores idle
state in two different places -- one is meant to mirror mac80211's state,
and the other one is internal, periodically computed from the state of all
wiphys. The ath9k version of the fix modified the
internal state without the mac80211 mirror. The ath9k config() routine
probably does nothing when called with "all changed" on resume because
in fact, if we suspend and resume when non-idle, nothing _has_ changed
from that perspective.  I fear that unless ath9k gets changed more
substantially, it really does need to be informed of IDLE changes.

> I think the problem might be that ath9k is expecting mac80211 to
> perfectly nest calls to idle/non-idle, even across suspend/resume and
> device shutdown. I don't think that's feasible at all.

--
Paul
