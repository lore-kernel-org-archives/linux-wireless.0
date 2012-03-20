Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CTNoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 09:44:01 -0400
Subject: Re: [RFC 00/11] multi-channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <6c1d5801-97d8-4534-9225-30b493a925b1@FIVLA-EXHUB02.eu.tieto.com>
References: <6c1d5801-97d8-4534-9225-30b493a925b1@FIVLA-EXHUB02.eu.tieto.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 14:44:00 +0100
Message-ID: <1332251040.3329.25.camel@jlt3.sipsolutions.net> (sfid-20120320_144407_042404_8F2C76CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for the code! I've started to work on this as well, and will take
a look at your code soon. I'm currently a bit sick though so it might be
a couple of days.

> Work still needs to be done:
>  * powersave per-vif
>  * queue locking per-vif
>  * offchannel rework (hw_config, work_work)
>  * and a bit more

Have you my thoughts at
http://thread.gmane.org/gmane.linux.kernel.wireless.general/86070
about the queue issue?

> Questions:
> 
>  * monitor interfaces:
>    Currently ieee80211_set_channel gets netdev==NULL when iface is
>    a monitor. Is there a particular reason behind it?

This is my biggest question too. I need to sit down and think through
the different monitor mode use cases to be able to answer it.

>  * ieee80211_hw_config:
>    Should we extend it to take ieee80211_sub_if_data or should we
>    use ieee80211_bss_info_change_notify? If so, is ieee80211_hw_config
>    eventually to be removed?

That's the other question I've asked myself too :-)
I think extending it doesn't make a lot of sense. Most of the parameters
can be moved or removed, if they aren't already dead (like
IEEE80211_CONF_CHANGE_LISTEN_INTERVAL.)

POWER might be an interesting question -- not sure if all devices are
going to support per-vif TX power and if we should require that. Ditto
for SMPS. IDLE is already per interface in addition, and goes together
with MONITOR and how we handle monitor mode in the future (see above.)
That leaves just RETRY_LIMITS which, to be honest, I have no idea about
right now.

johannes

