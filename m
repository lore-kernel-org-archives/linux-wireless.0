Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48094 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbZI3WN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 18:13:59 -0400
Date: Thu, 1 Oct 2009 01:13:53 +0300
From: Jouni Malinen <j@w1.fi>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: driver_nl80211 broken again
Message-ID: <20090930221353.GB11052@jm.kir.nu>
References: <1251117161.22951.4.camel@maxim-laptop> <1251122885.12007.12.camel@johannes.local> <1251144381.9374.4.camel@maxim-laptop> <1251147515.20161.3.camel@johannes.local> <1252116503.2398.26.camel@maxim-laptop> <1252423769.3806.4.camel@johannes.local> <1252443260.16422.5.camel@maxim-laptop> <1254273569.4499.8.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254273569.4499.8.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 03:19:28AM +0200, Maxim Levitsky wrote:

> So I didn't do the testing that soon...
> Got swamped by many bugs present in ubuntu 9.10.
> 
> Now I have attempted same patch on top of wpa_supplicant, and it works.

Depends on your definition of working, I'd guess.. ;-)

> @@ -1302,8 +1302,10 @@ void wpa_supplicant_disassociate(struct wpa_supplicant *wpa_s,
>                         wpa_drv_disassociate(wpa_s, wpa_s->bssid, reason_code);
> +                       wpa_drv_deauthenticate(wpa_s, wpa_s->bssid, reason_code);

To me, this looks broken. When wpa_supplicant requests a
disassociastion, it is _only_ asking for disassociation, not
deauthentication. cfg80211/mac80211 may not currently handle that, but
as far as I can tell, it sounds like an issue there and not in
wpa_supplicant. Johannes may disagree with this, though.

> Would that be enough, or this is too hacky, and we need to audit each callsite of wpa_supplicant_disassociate
> and see if we need to send deauth frame too?

I don't think either of those options would be acceptable for
wpa_supplicant and the correct fix is to make cfg80211/mac80211 be able
to handle authentication to a STA that is already authenticated. If
that is not acceptable, this hack needs to be hidden in driver_nl80211.c
instead of polluting core wpa_supplicant code which is supposed to be
driver independent. In other words, make driver_nl80211.c deauth if auth
fails and then try auth again. I don't really like that much, but if
this needs to be worked around in wpa_supplicant, that is the most
likely place where such a change could be considered.

-- 
Jouni Malinen                                            PGP id EFC895FA
