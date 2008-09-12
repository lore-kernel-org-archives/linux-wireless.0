Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39437 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757547AbYILRkq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 13:40:46 -0400
Date: Fri, 12 Sep 2008 10:40:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: The new regulatory code kills my wireless
Message-ID: <20080912174036.GC6134@tesla> (sfid-20080912_194054_032727_AE1F44A2)
References: <48CAA8D6.1030605@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48CAA8D6.1030605@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2008 at 10:37:26AM -0700, Larry Finger wrote:
> After pulling the latest git from wireless-testing, my wireless
> failed. I bisected this to be commit
> 544ec9a11fdef5142a76a8eb4b186a80a272c035, "cfg80211: Add new wireless
> regulatory infrastructure". I have not yet implemented CRDA, thus I
> selected the CONFIG_WIRELESS_OLD_REGULATORY option.
> 
> The symptoms are that my devices (b43 and p54usb) receive no scan
> information.
> 
> The pertinent dmesg output follows:
> 
> cfg80211: Using old static regulatory domain:
> cfg80211: Regulatory domain: US
>          (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>          (239200 KHz - 248200 KHz @ 4000 KHz), (600 mBi, 2700 mBm)
>          (516000 KHz - 520000 KHz @ 4000 KHz), (600 mBi, 2300 mBm)
>          (518000 KHz - 522000 KHz @ 4000 KHz), (600 mBi, 2300 mBm)
>          (520000 KHz - 524000 KHz @ 4000 KHz), (600 mBi, 2300 mBm)
>          (522000 KHz - 534000 KHz @ 4000 KHz), (600 mBi, 2300 mBm)
>          (572500 KHz - 584500 KHz @ 4000 KHz), (600 mBi, 3000 mBm)
> cfg80211: Calling CRDA for country: US

Please apply johill's patch, "[PATCH] cfg80211: fix regdomain macro"

  Luis
