Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1ANI0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 03:26:35 -0500
Subject: Re: No beacons generated when you bring ath9k AP interface down
 and up.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4D2FF7A4.3070106@candelatech.com>
References: <4D2FF7A4.3070106@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 09:26:31 +0100
Message-ID: <1294993591.3853.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-13 at 23:13 -0800, Ben Greear wrote:
> Been a long day, but I think I finally see the problem.
> 
> If you have an ath9k AP interface running with hostapd, and you
> run:  ip link set vap0 down; ip link set vap0 up;
> then it will disable beaconing.
> 
> One reason is that the ieee80211_do_open calls the
>   ieee80211_bss_info_change_notify before it sets the RUNNING
> flag, so it would disable beaconing.  A second is that
> it doesn't set the BEACON_CHANGED flag anyway, so even if you
> hack things to set RUNNING first, it still doesn't work right.
> 
> I'm not sure where the problem actually lies:  Should ath9k
> start beaconing automatically on VAP interface add?  Is
> it up to hostapd to detect the ifdown/ifup and re-set everything
> up properly?  Or maybe it's just a very bad idea to bounce
> a VAP interface with 'ip link set'?

Why would that be a good idea? I mean ... why would you want to do
that?!

johannes

