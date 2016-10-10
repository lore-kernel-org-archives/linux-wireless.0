Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55168 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751986AbcJJKNK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 06:13:10 -0400
Message-ID: <1476094386.7895.7.camel@sipsolutions.net> (sfid-20161010_121313_307956_4E32F40C)
Subject: Re: [RFC] mac80211: fix A-MSDU outer SA/DA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Mon, 10 Oct 2016 12:13:06 +0200
In-Reply-To: <1475874542-9014-1-git-send-email-michael-dev@fami-braun.de>
References: <1475874542-9014-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  
> +	/* according to IEEE 802.11-2012 8.3.2 table 8-19, the outer
> SA/DA
> +	 * fields needs to be changed to BSSID for A-MSDU frames
> depending
> +	 * on FromDS/ToDS values.
> +	 */
> +	hdr = data;
> +	if (bssid && (hdr->frame_control &
> cpu_to_le16(IEEE80211_FCTL_FROMDS)))
> +		memcpy(amsdu_hdr.h_source, bssid, ETH_ALEN);
> +	if (bssid && (hdr->frame_control &
> cpu_to_le16(IEEE80211_FCTL_TODS)))
> +		memcpy(amsdu_hdr.h_dest, bssid, ETH_ALEN);
> 

You should probably use ieee80211_has_tods() and ieee80211_has_fromds()

johannes
