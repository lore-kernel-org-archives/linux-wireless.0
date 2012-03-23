Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab2CWJ3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 05:29:07 -0400
Message-ID: <1332494945.3506.23.camel@jlt3.sipsolutions.net> (sfid-20120323_102911_324314_C5874956)
Subject: Re: [RFC 00/12] multi-channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2012 10:29:05 +0100
In-Reply-To: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154008_038091_B257E507)
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>
	 (sfid-20120320_154008_038091_B257E507)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The following patches prepare mac80211 to support multi-channel capable
> hardware. The patchset prepares to channel per-vif split.
> 
> Work still needs to be done:
>  * powersave per-vif
>  * queue locking per-vif
>  * offchannel rework (hw_config, work_work)
>  * and a bit more
> 
> Questions:
> 
>  * monitor interfaces:
>    Currently ieee80211_set_channel gets netdev==NULL when iface is
>    a monitor. Is there a particular reason behind it?
> 
>  * ieee80211_hw_config:
>    Should we extend it to take ieee80211_sub_if_data or should we
>    use ieee80211_bss_info_change_notify? If so, is ieee80211_hw_config
>    eventually to be removed?
> 
> What do you think of this approach?


So I took a closer look at this now.

I think we should probably apply the first two patches now, and the
third with changes. After that, I'm not so sure.

Overall, I think the approach isn't sufficient. At the very least, the
(unstated!) assumption that one channel per interface can always be done
is bad. Modifying this with the structure you gave it though seems to be
problematic.

We should also handle the queue mapping first I think. This isn't a
feature you can implement overnight :-)

johannes


