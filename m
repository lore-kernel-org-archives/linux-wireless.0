Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4177 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1ANOyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 09:54:43 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 14 Jan 2011 06:54:23 -0800
Subject: RE: cfg80211 rfkill interface
Message-ID: <2EFC2EC4C7011444989031FE55348CDA9549080E26@SJEXCHCCR02.corp.ad.broadcom.com>
References: <400C43189542CE41BC0A5B252FC90136952F059529@SJEXCHCCR02.corp.ad.broadcom.com>
 <1294688709.3583.25.camel@jlt3.sipsolutions.net>
In-Reply-To: <1294688709.3583.25.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for you thoughts on this. Especially the last remark was reason for me to verify several usage scenarios. I ran into a issue with unloading the driver module while it was in blocked rfkill state and polling was active. Turns out the call to ieee80211_unregister_hw takes a loooong time before it returns and dmesg shows message from unregister_netdevice which seems related about refcount not being zero. This is only observed in this scenario. Any suggestion on how to handle this?

Gr. AvS

|-----Original Message-----
|From: Johannes Berg [mailto:johannes@sipsolutions.net]
|Sent: Monday, January 10, 2011 8:45 PM
|To: Arend Van Spriel
|Cc: linux-wireless@vger.kernel.org
|Subject: Re: cfg80211 rfkill interface
|
|Hi Arend,
|
|> I am looking into implementing rfkill into our brcm80211 open-source
|> driver. Our driver detects disable switch by an interrupt, but
|> switching back does not give an interrupt.
|
|Interesting, but I guess it makes some sense.
|
|> For the latter I wanted to use the rfkill_poll callback and
|> wiphy_rfkill_start_polling.
|
|Right, makes sense.
|
|> However, I tried a wiphy_rfkill_stop_polling in the rfkill_poll
|> callback when rf is unblocked, and this resulted in a system hang.
|
|Yeah, I'm not surprised. start_polling will work from anywhere, but
|stop_polling needs to actually completely sync the poll stop so it can't
|be done from within the poll or from within any rfkill callbacks.
|
|> So I moved the wiphy_rfkill_stop_polling to the start callback. Does
|> that make sense or is there another way you would recommend?
|
|I think that makes sense.
|
|However, where do you start polling? You have to poll even if the device
|is not start()ed, I guess?
|
|johannes
|


