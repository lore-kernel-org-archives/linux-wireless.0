Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:32860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaCEPBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 10:01:00 -0500
Message-ID: <1394031651.5275.38.camel@jlt4.sipsolutions.net> (sfid-20140305_160108_744043_5CA7F458)
Subject: Re: [PATCH 1/1] mac80211: fix WPA with VLAN on AP side with ps-sta
 again
From: Johannes Berg <johannes@sipsolutions.net>
To: michael-dev <michael-dev@fami-braun.de>
Cc: linville@tuxdriver.com, projekt-wlan@fem.tu-ilmenau.de,
	linux-wireless@vger.kernel.org
Date: Wed, 05 Mar 2014 16:00:51 +0100
In-Reply-To: <f54e8751cdc525ebc4d0d8abbbc96550@fami-braun.de> (sfid-20140305_144700_435568_A1DD1A4E)
References: <1360686937-17277-1-git-send-email-michael-dev@fami-braun.de>
	 <f54e8751cdc525ebc4d0d8abbbc96550@fami-braun.de>
	 (sfid-20140305_144700_435568_A1DD1A4E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-05 at 14:40 +0100, michael-dev wrote:
> commit de74a1d9032f4d37ea453ad2a647e1aff4cd2591
>    "mac80211: fix WPA with VLAN on AP side with ps-sta"
> fixed an issue.
> commit "7cbf9d017dbb5e3276de7d527925d42d4c11e732"
>    "mac80211: fix oops on mesh PS broadcast forwarding"
> essentially reverted it, because vif.type cannot be AP_VLAN
> due to the check to vif.type in ieee80211_get_buffered_bc before.
> 
> As the 7cbf9 commit intended to fix the MESH case, fix it
> by checking for IFTYPE_AP instead of IFTYPE_AP_VLAN.

This looks fine, but
 * please add a Cc stable and Fixes line
(https://lwn.net/Articles/571980/)
 * is severely whitespace damaged, so I can't apply it
 * is against a backport which has vastly different line numbers, so I'm
not sure
   it'd apply if it wasn't broken

johannes

