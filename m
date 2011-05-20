Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183Ab1ETPKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 11:10:51 -0400
Subject: Re: [PATCH 2/2]: mac80211: report correct MCS information in tx
 status info
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <matteo@openwrt.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTikcBcobbXzjGv4UtD952kHtrSsvNw@mail.gmail.com> (sfid-20110520_011406_423246_1F00C156)
References: <BANLkTikcBcobbXzjGv4UtD952kHtrSsvNw@mail.gmail.com>
	 (sfid-20110520_011406_423246_1F00C156)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 08:13:03 -0700
Message-ID: <1305904383.4640.2.camel@jlt3.sipsolutions.net> (sfid-20110520_171053_487142_3AC99696)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-20 at 01:13 +0200, Matteo Croce wrote:
> Report correct MCS information in tx status info
> 
> Signed-off-by: Matteo Croce <matteo@openwrt.org>
> 
> --- a/net/mac80211/status.c	2011-05-20 00:22:56.220640264 +0200
> +++ b/net/mac80211/status.c	2011-05-20 00:24:14.010640270 +0200
> @@ -405,6 +405,20 @@
>  	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
>  		rthdr->rate = sband->bitrates[
>  				info->status.rates[0].idx].bitrate / 5;
> +	/* HT rates */
> +	if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
> +		rthdr->hdr.it_present |=
> +				cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);

This means the part that I just commented on from the other patch is
wrong. Think about this again, about how radiotap works etc. You're
creating an invalid radiotap header that's too long if MCS rates aren't
used.

johannes

