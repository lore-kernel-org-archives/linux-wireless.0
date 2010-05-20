Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:14301 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab0ETVxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 17:53:34 -0400
Subject: Re: How to scan APs with ATH5k?
From: Pavel Roskin <proski@gnu.org>
To: Jaroslav Fojtik <jafojtik@seznam.cz>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
In-Reply-To: <4BF58D72.22852.D1D2D@jafojtik.seznam.cz>
References: <1274296671-13596-1-git-send-email-gwingerde@gmail.com>
	 , <4BF4CFE8.10182.FA668@jafojtik.seznam.cz>
	 , <AANLkTim90zZxvcwT9joVAqO1oDzk-jCaRCQAd0Cfu3N0@mail.gmail.com>
	 <4BF58D72.22852.D1D2D@jafojtik.seznam.cz>
Content-Type: text/plain
Date: Thu, 20 May 2010 17:53:31 -0400
Message-Id: <1274392411.7054.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-20 at 21:28 +0200, Jaroslav Fojtik wrote:
> Dear Bob,
> 
> > $ sudo ifconfig wlan0 up
> > $ sudo iw dev wlan0 scan
> 
> I have typed:
> 
> ifconfig wlan0 down
> ifconfig wlan0 up
> iwlist wlan0 scanning 
>   (I do not have installed iw)

I think you should install iw and use it instead.  Ideally, iwlist
should work as well, but iw would provide a useful datapoint.

> But when an interface wlan0 become associated, it refuses scanning.
> 
> root@dvouramenna:~# iwlist wlan0 scanning
> wlan0     Interface doesn't support scanning : Operation not supported
> 
> 
> Is this bug or feature?

It looks like a bug.  Even if something is preventing scanning, the
error code should be -EBUSY (device busy).

> MadWifi can scan even when interface is associated.
> ipw2200bg can also scan when it is associated.

The same is true for ath9k, but I cannot test ath5k at the moment.
mac80211 does a considerable effort to allow scanning while associated.

-- 
Regards,
Pavel Roskin
