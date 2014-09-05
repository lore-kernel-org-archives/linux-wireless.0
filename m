Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43440 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaIEGeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 02:34:09 -0400
Message-ID: <1409898836.1940.1.camel@jlt4.sipsolutions.net> (sfid-20140905_083413_930922_C31144C2)
Subject: Re: Anyone working on making iw able to specify MAC address at
 station creation time?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	Marcel Holtmann <marcel@holtmann.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 05 Sep 2014 08:33:56 +0200
In-Reply-To: <5408A6BD.6090304@candelatech.com> (sfid-20140904_195201_728073_99DA3C67)
References: <5408A6BD.6090304@candelatech.com>
	 (sfid-20140904_195201_728073_99DA3C67)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-04 at 10:51 -0700, Ben Greear wrote:
> I'm having issues with udev renaming newly created stations when I have
> udev rules for wlanX, when wlanX is not already existing.
> 
> I think specifying MAC on station creation time would solve my problems,
> but haven't looked closely yet.
> 
> My version of 'iw' doesn't support setting the MAC on creation, from
> what I can tel.
> 
> Curious if anyone else is working on this?

I think Marcel mentioned wanting this before. There's even an attribute
in nl80211 already, but it can only be used for P2P_DEVICE I believe, so
a feature flag or so would be needed to be able to know whether or not
this would be expected to take any effect (kernels before those future
changes would ignore the attribute for non-P2P-DEVICE I believe)

Haven't looked at the code right now, this is all I know.

johannes

