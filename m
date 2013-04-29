Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3D2Nx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 09:53:59 -0400
Message-ID: <1367243626.8289.2.camel@jlt4.sipsolutions.net> (sfid-20130429_155402_865278_78287F12)
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Apr 2013 15:53:46 +0200
In-Reply-To: <517E7ABD.9000505@broadcom.com>
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
	 <517E7ABD.9000505@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-29 at 15:50 +0200, Arend van Spriel wrote:

> > This is a hack to provide it so not only is Android happy
> > but also the current version of wpa_supplicant can work
> > with P2P-Device functionality without needing changes to
> > support the P2P-Device commands, just a little bit to not
> > attempt to change the interface type to station.
> 
> Reading the subject I was going to say it is not only Android 
> workaround, but the commit message also covers non-android use-case.
> 
> I will give it another spin. What changed compared to v3.

The nl80211 events got the ifindex, that got removed when I changed from
wdev->netdev to wdev->p2pdev (for you ;-) ) so the scan and other events
didn't have the right information for a hacked wpa_supplicant that isn't
aware of wdev IDs.

johannes

