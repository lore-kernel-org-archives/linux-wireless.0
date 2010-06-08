Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0FHNO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 09:14:29 -0400
Subject: Re: [PATCHv2] mac80211: Fix circular locking dependency in ARP
 filter handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	reinette.chatre@intel.com
In-Reply-To: <1276002335-18600-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1276002335-18600-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 15:14:23 +0200
Message-ID: <1276002863.3706.131.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-08 at 16:05 +0300, Juuso Oikarinen wrote:

> +		promisc = sdata->flags & IEEE80211_SDATA_PROMISC;
> +		if (promisc)
> +			bss_conf->arp_filter_enabled = 0;
> +		else
> +			bss_conf->arp_filter_enabled = sdata->arp_filter_state;

bss_conf->arp_filter_enabled = !promisc && sdata->arp_filter_state;

?

Or if not, use false instead of 0 please.

johannes

