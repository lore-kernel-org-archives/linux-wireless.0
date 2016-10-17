Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:36428 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934300AbcJQKaB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 06:30:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 17 Oct 2016 12:29:40 +0200
From: michael-dev <michael-dev@fami-braun.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: projekt-wlan@fem.tu-ilmenau.de, Fietkau <nbd@openwrt.org>,
        Felix@mail.fem.tu-ilmenau.de, linux-wireless@vger.kernel.org
Subject: Re: [Projekt-wlan] [PATCHv5 2/2] mac80211: fix A-MSDU outer SA/DA
In-Reply-To: <1476697463.19992.18.camel@sipsolutions.net>
References: <1476530899-24241-1-git-send-email-michael-dev@fami-braun.de>
 <1476530899-24241-2-git-send-email-michael-dev@fami-braun.de>
 <1476697463.19992.18.camel@sipsolutions.net>
Message-ID: <d793195b149aebb974dd596632d2ba83@fami-braun.de> (sfid-20161017_123005_513074_9868E411)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 17.10.2016 11:44, schrieb Johannes Berg:
>> +	if (bssid && ieee80211_has_fromds(hdr->frame_control))
>> +		memcpy(h_80211_src, bssid, ETH_ALEN);
>> +
>> +	if (bssid && ieee80211_has_tods(hdr->frame_control))
>> +		memcpy(h_80211_dst, bssid, ETH_ALEN);
> 
> but I also changed these to ether_addr_copy()

ether_addr_copy requires both arguments to be __aligned(2) according to 
include/linux/etherdevice.h.
bssid might be sdata->u.mgd.bssid, which is bssid in struct 
ieee80211_if_managed, but neither sdata->u, sdata->u.mgd nor 
sdata->u.mgd.bssid seem to be declared as __aligned(2).
So ether_addr_copy should not be used.

What am I missing?

Regards,
M. Braun
