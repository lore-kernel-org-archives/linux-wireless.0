Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 8.mo179.mail-out.ovh.net ([46.105.75.26]:42784 "EHLO
        8.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbeC0ABr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 20:01:47 -0400
Received: from player762.ha.ovh.net (unknown [10.109.108.187])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 1012AAC2BE
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 22:24:51 +0200 (CEST)
Subject: Re: [PATCH] mac80211: Fix wlan freezes under load at rekey
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Ben Greear <greearb@candelatech.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20180324102921.9814-1-alexander.wetzel@web.de>
 <7bbb4246-324e-1d6d-245f-2642badb034d@candelatech.com>
 <27aca99e-a521-be4a-9fd4-51c557f9777d@web.de>
 <3e433bd6-d13e-f71c-d3ff-7163c2b59226@candelatech.com>
 <692de5e6-24d8-e1fe-c345-2ba3df91c9da@dd-wrt.com>
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <313d0742-2b61-40cd-4b41-7fe263221321@web.de> (sfid-20180327_020152_054256_5BD93121)
Date: Mon, 26 Mar 2018 22:24:38 +0200
MIME-Version: 1.0
In-Reply-To: <692de5e6-24d8-e1fe-c345-2ba3df91c9da@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> so far i see no regressions with 9984 with that patch
> 
> except that 9984 has a rekeying problem at all. with wds ap -> wds sta
> mode rekeying will fail and it will reauthenticate at each interval. (it
> disconnects and reconnects)
> but this is a long term issue qca never fixed for years. 988x doesnt
> suffer from that issue

Thanks for testing, sounds promising.

If anyone is interested how it looks in my test environment I've
uploaded two sample captures to
https://www.awhome.eu/index.php/s/abxgp9pfi2ssCNy, showing how the
unpatched and patched mac80211 are reacting to the rekey. The WPA
Password is Induction and the AP rekeys all 30s.

The AP is running lede 17.01.4, so it's way off from the current
kernel/mac80211.
The client is a HTC 10 phone running Lineageos. (The phone also has a
WLAN card which has problems when rekeying.)

There are quite many interesting things visible here, not the least one
that ath9k leaks unencrypted frames for both patched and unpatched
mac80211 which at least for my patched variant probably allow to
calculate the TK key and encrypt all frames.

I'm now experimenting now with KEY_FLAG_TAINTED, but it's not as
straight forward as I expected.
