Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49150 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751689AbcJMHoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 03:44:09 -0400
Message-ID: <1476343431.4904.7.camel@sipsolutions.net> (sfid-20161013_094515_642504_F804A1F6)
Subject: Re: [PATCHv4] mac80211: fix A-MSDU outer SA/DA
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>,
        Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Thu, 13 Oct 2016 09:23:51 +0200
In-Reply-To: <fc2ae46b-f049-41de-3eec-465e83b5ecef@nbd.name>
References: <1476337315-26845-1-git-send-email-michael-dev@fami-braun.de>
         <fc2ae46b-f049-41de-3eec-465e83b5ecef@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > +     /* h_80211_src/dst is addr* field within hdr */
> > +     h_80211_src = data + fast_tx->sa_offs;
> > +     h_80211_dst = data + fast_tx->da_offs;

[...]

> > +	if (bssid && ieee80211_has_fromds(hdr->frame_control))
> > +		memcpy(h_80211_src, bssid, ETH_ALEN);
> > +
> > +	if (bssid && ieee80211_has_tods(hdr->frame_control))
> > +		memcpy(h_80211_dst, bssid, ETH_ALEN);

> I think this is probably wrong for 4-addr, since there both FromDS
> and ToDS are set. Maybe you should use !ieee80211_has_tods instead of
> ieee80211_has_fromds and vice versa.

It helps to look at the spec ;-)

For 4-addr frames, dest/src are addr 3/4 respectively, and in the spec
both *should* actually be set to the BSSID.

It's kinda pointless to be doing that and using a 4-addr frame here,
but I suppose it would be expected by the receiver in 4-addr mode, so
makes some sense.

johannes
