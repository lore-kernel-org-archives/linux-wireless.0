Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:63828 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755340AbcJLQiT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 12:38:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 12 Oct 2016 18:31:50 +0200
From: michael-dev <michael-dev@fami-braun.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v2] mac80211: fix A-MSDU outer SA/DA
In-Reply-To: <1476275121.5271.28.camel@sipsolutions.net>
References: <1476269870-32007-1-git-send-email-michael-dev@fami-braun.de>
 <1476275121.5271.28.camel@sipsolutions.net>
Message-ID: <fc2162c67f54d0dbbda9f36ca1babdcc@fami-braun.de> (sfid-20161012_183823_945747_A58ED6BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 12.10.2016 14:25, schrieb Johannes Berg:
> So, I actually think my first instinct that you were erroneously
> changing the inner header *was* right.

You're right.

> Seems like this code should be inserted towards the end of
> ieee80211_amsdu_aggregate() instead, where it's adding the RFC 1042
> header?

I'm not convinced.

ieee80211_amsdu_aggregate handles two skbs: the "skb" var and the "head" 
var.
The skb is appended to the frag list of head by setting frag_tail and 
does not appear to have an ieee80211_hdr, as memmove is only 2 * 
ETH_ALEN. Additionally, the rfc1042_header is written after 2 bytes 
containing subframe_len, so it looks like an A-MSDU subframe with 
rfc1042_header is inserted at the beginning of the inner MSDU.

Only the head skb is processed by ieee80211_amsdu_prepare_head and 
appears to have an 802.11 header. So its da/sa address should be 
changed.

Regards,
M. Braun
