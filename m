Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:24350 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967342AbdAILr6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 06:47:58 -0500
Subject: Re: [PATCH net-next] bridge: multicast to unicast
To: Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
 <1483706872.4089.8.camel@sipsolutions.net>
 <8836daaa-9638-4502-d079-fd428595f822@nbd.name>
 <1483710841.12677.1.camel@sipsolutions.net>
 <22fad045-57c6-7789-d19f-f47bd0faf441@fami-braun.de>
 <20170107145516.GE3134@otheros> <1483949336.17582.3.camel@sipsolutions.net>
Cc: Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
From: "M. Braun" <michael-dev@fami-braun.de>
Message-ID: <6f5ec9f1-800a-2bc4-2f41-9d803343bb22@fami-braun.de> (sfid-20170109_125050_403787_A1A45E87)
Date: Mon, 9 Jan 2017 12:44:19 +0100
MIME-Version: 1.0
In-Reply-To: <1483949336.17582.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 09.01.2017 um 09:08 schrieb Johannes Berg:
> Does it make sense to implement the two in separate layers though?
> 
> Clearly, this part needs to be implemented in the bridge layer due to
> the snooping knowledge, but the code is very similar to what mac80211
> has now.

Does the bridge always know about all stations connected?

That is bridge fdb entries (need to) expire so the bridge might "forget"
a still-connected station not sending but only consuming broadcast traffic.

E.g. there is a television broadcast station here that receives a video
stream (via wifi, udp packets) and then airs it (dvb-t) but (on its own)
would not send any data packet on wifi (static ip, etc.).

An other reason to implement this in mac80211 initially was that
mac80211 could encapsulate broacast/multicast ethernet packtes in
unicast A-MSDU packets in a way, so that the receiver would still see
process ethernet packets (after conversion) but have unicast wifi
frames. This cannot be done in bridge easily but one might want to add
this later to mac80211.

Michael
