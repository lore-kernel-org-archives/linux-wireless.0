Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:12153 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbcJFLax (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 07:30:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 06 Oct 2016 13:30:17 +0200
From: michael-dev <michael-dev@fami-braun.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Subject: Re: [PATCHv4] mac80211: check A-MSDU inner frame source address on AP
 interfaces
In-Reply-To: <1475679558.5257.7.camel@sipsolutions.net>
References: <1475661751-26262-1-git-send-email-michael-dev@fami-braun.de>
 <1475679558.5257.7.camel@sipsolutions.net>
Message-ID: <bb2ea10f30d2ae8a3cc048974ed148c8@fami-braun.de> (sfid-20161006_133057_475226_2D40D469)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 05.10.2016 16:59, schrieb Johannes Berg:
> So as you can see by my own version of this patch, I'm not super happy
> with the way you did things here :)

I'm happy with your version, so lets just drop mine.

> Instead of adding 4 new arguments, (ta, ra, is_4addr, is_tdls_data), I
> opted to just add two (check_da and check_sa) and make those NULL when
> no checks are desired.
> 
> I *think* that works equivalently, but it'd be great if you could take
> a look.

The rules when to check sa/da should be independent of the driver and 
thus would likely be duplicated by each caller.
This is why I had it in ieee80211_amsdu_to_8023s.

My patch defaulted into not checking sa/da for interface type not 
explicitly given, whereas your code defaults to checking both for those.
This makes a difference for IFTYPE_MONITOR, IFTYPE_P2P_*, IFTYPE_OCB, 
IFTYPE_UNSPECIFIED, IFTYPE_WDS. I don't know if filtering is appropiate 
for those or if they can actually occur there.

> This also conflicts with the earlier patch I sent to just always drop
> when it's multicast.

Dropping multicast A-MSDU frames is fine for me.

michael
