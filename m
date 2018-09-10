Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:49350 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbeIJMla (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 08:41:30 -0400
Message-ID: <1536565717.3224.12.camel@sipsolutions.net> (sfid-20180910_094851_792617_A816840C)
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 09:48:37 +0200
In-Reply-To: <153635897010.14170.2992498632345986102.stgit@alrua-x1> (sfid-20180908_002306_367985_5D6D7759)
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897010.14170.2992498632345986102.stgit@alrua-x1>
         (sfid-20180908_002306_367985_5D6D7759)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-09-08 at 00:22 +0200, Toke Høiland-Jørgensen wrote:
> 
> Usage of the new API is optional, so drivers can be ported one at a time.

With the 1:1 hardware queue/txq mapping in iwlwifi (we're close to
getting that patch in, though now the Jewish holidays mean a delay), I'm
not sure we'd be able to do this at all in iwlwifi. So this may not be a
case of porting one at a time until we can get rid of it ...

It would be nice to be able to use it, for better queue behaviour, but
it would mean much more accounting in iwlwifi? Not even sure off the top
of my head how to do that.

johannes
