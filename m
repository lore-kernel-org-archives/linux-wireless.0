Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46794 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbbFQIrw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:47:52 -0400
Message-ID: <1434530870.1884.12.camel@sipsolutions.net> (sfid-20150617_104812_764234_D44B16FA)
Subject: Re: [PATCH V3] mac80211: wowlan: suspend: Fix power save state
 stuck in ACTIVE caused by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 17 Jun 2015 10:47:50 +0200
In-Reply-To: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150610_154245_778081_DC26490D)
References: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20150610_154245_778081_DC26490D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 19:12 +0530, Chaitanya T K wrote:
> From: Chaitanya T K <chaitanya.mgit@gmail.com>
> 
> Background: When wowlan is enabled, the chipset stays in low
> power state maintaining the connection as per the
> mac80211 power save state.
> 
> If suspended during TX in progress, there can be 
> race where the driver is put of of power-save due
> to TX and during suspend dynamic_ps_time is cancelled
> and TX packet is flushed, leaving the driver in ACTIVE
> even after resuming until dynamic_ps_time puts 
> driver back in DOZE. (Which only happens if there
> is another TX).
> 
> This can lead to high power consumption of chipset 
> during (or) after resuming.

I still don't like it. I also don't believe that what you're writing is
actually true. The only problem I can see is that it leads to higher
power consumption *while the system is suspended* - at resume time we
send a packet and thus kick the timers...

I was going to change it to this:

-------
mac80211: ensure powersave is enabled when going to WoWLAN

If the system suspends while the client powersave mechanism
is waiting to suspend due to a previous TX, the system will 
go to sleep with the NIC being awake (active) rather than
in doze mode. Unless the driver handles this, it leads to
excessive power consumption while sleeping.
-------

but I'm not convinced all of this is right.

johannes

