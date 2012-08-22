Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59598 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2HVUaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 16:30:08 -0400
Message-ID: <5035414D.2080600@openwrt.org> (sfid-20120822_223011_829114_28D49CA3)
Date: Wed, 22 Aug 2012 22:30:05 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Issue with ath9k and tx/rx chainmask:  3x3 doesn't work with
 mask of 0x1.
References: <50329D11.9030405@candelatech.com>
In-Reply-To: <50329D11.9030405@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-20 10:24 PM, Ben Greear wrote:
> I am trying to test out an attenuator.  For now, I have only a single attenuator,
> so I set tx and rx chainmask to 0x1 on both AP and Station machine.
> 
> I then connected channel 0 on the two machines together through the
> attenuator.
> 
> I have two station interfaces on the station machine.  They both
> seem to associate OK, but they cannot receive dhcp responses.
> 
> It *seems* that broadcast packets may go through fine.
> 
> If I force the rate down to 1x1 or 2x2 MIMO (or force disable /n
> and just use /a), then it appears to work fine.
> 
> Nics are WPEA-127n (AR9380).  Kernel is 3.5.1+ on AP, 3.5.2+ on station
> machine.
> 
> I can see why forcing it down to 1x1 might work around some issue,
> but I find it funny that 2x2 works while 3x3 does not.
Did you set the chainmask manually via debugfs? If so, don't do that!
Use the nl80211 antenna control API (e.g. via iw)

- Felix
