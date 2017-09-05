Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59422 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750983AbdIEG6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 02:58:30 -0400
Message-ID: <1504594708.6667.1.camel@sipsolutions.net> (sfid-20170905_085833_912319_7A341A2B)
Subject: Re: [PATCH 3/3] mac80211: fix VLAN handling with TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Tue, 05 Sep 2017 08:58:28 +0200
In-Reply-To: <87mv6a35lb.fsf@toke.dk>
References: <20170622102030.9795-1-johannes@sipsolutions.net>
         <20170622102030.9795-3-johannes@sipsolutions.net> <87378lvyfz.fsf@toke.dk>
         <1504517620.9797.3.camel@sipsolutions.net> <87mv6a35lb.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-09-04 at 16:23 +0200, Toke Høiland-Jørgensen wrote:
> 
> Hmm, not apart from agreeing with you that it would be better to not
> drop everything when removing a VLAN. Not sure how often this
> happens, though (and hence how big of a problem it is). What happens
> in scenarios where hostapd is setup to automatically generate a bunch
> of VLANs for every client, for instance?

I'm not sure. However, I think it's less bad than one might guess since
it really should only affect multicast frames, right? All unicast
frames should go directly to the per-STA TXQ.

Right now, with TXQ, encrypted VLANs are completely broken, so surely
it's a step in the right direction?

johannes
