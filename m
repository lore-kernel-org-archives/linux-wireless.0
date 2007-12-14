Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:49426 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760074AbXLNEzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 23:55:06 -0500
Date: Thu, 13 Dec 2007 20:54:04 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: privacy_invoked in AP interfaces?
Message-ID: <20071214045404.GC5698@jm.kir.nu> (sfid-20071214_045511_264567_8DDDC55A)
References: <1197453187.6558.88.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197453187.6558.88.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2007 at 10:53:07AM +0100, Johannes Berg wrote:

> I was just testing hostapd and it told me:
> Could not set PrivacyInvoked for interface wlan0
> 
> This is because we only allow setting that for STA interfaces, but what
> should the setting do for AP interfaces? I don't see any point in it, is
> there?

The only use for it in the AP mode is to support drivers (or well, more
likely firmware designs) that insist on generating the Beacon (and Probe
Response) frames themselves. I would be fine with net/mac80211 not
supporting such designs, but it would probably be better to continue to
support this in hostapd (and make it possible to do this with
cfg/nl80211, too).

-- 
Jouni Malinen                                            PGP id EFC895FA
