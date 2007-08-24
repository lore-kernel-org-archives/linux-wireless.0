Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:3490 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbXHXNMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 09:12:50 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: include FCS at end of frames
Date: Fri, 24 Aug 2007 15:12:44 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1187953310.24933.19.camel@johannes.berg>
In-Reply-To: <1187953310.24933.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708241512.44463.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> b43_wireless_init(struct ssb_ }
>
>  	/* fill hw info */
> -	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
> +	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
> +		    IEEE80211_HW_RX_INCLUDES_FCS;
>  	hw->max_signal = 100;

You must have a very different tree to wireless-dev, branch everything.
According to git blame, since 2007-08-13 the piece of code there looks
like this:

hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
            IEEE80211_HW_MONITOR_DURING_OPER |
            IEEE80211_HW_DEVICE_HIDES_WEP | IEEE80211_HW_WEP_INCLUDE_IV;

The patch subject in this mailing list was
"[RFC 5/10] Port of bcm43xx from softmac to mac80211"
