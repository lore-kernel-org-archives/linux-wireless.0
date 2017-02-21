Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35304 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751563AbdBUKkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 05:40:06 -0500
Message-ID: <1487673603.2215.3.camel@sipsolutions.net> (sfid-20170221_114015_410034_B1982C48)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Date: Tue, 21 Feb 2017 11:40:03 +0100
In-Reply-To: <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com> (sfid-20170221_113217_027474_7273A408)
References: <20170221100957.30965-1-johannes@sipsolutions.net>
         <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
         (sfid-20170221_113217_027474_7273A408)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-21 at 11:32 +0100, Arend Van Spriel wrote:
> On 21-2-2017 11:09, Johannes Berg wrote:
> > From: Eliad Peller <eliad@wizery.com>
> > 
> > Let drivers advertise support for station-mode 4-way handshake
> > offloading with a new
> > NL80211_EXT_FEATURE_4WAY_HANDSHAKE_OFFLOAD_STA
> > flag.
> 
> I find use of the term OFFLOAD a bit redundant as it is implied by
> its presence anyway.

Fair enough, we can remove that.

> > Add a new NL80211_ATTR_PMK attribute that might be passed as part
> > of NL80211_CMD_CONNECT command, and contain the PSK (which is the
> > PMK, hence the name.)
> > 
> > The driver/device is assumed to handle the 4-way handshake by
> > itself in this case (including key derivations, etc.), instead
> > of relying on the supplicant.
> > 
> > This patch is somewhat based on this one (by Vladimir Kondratiev):
> > https://patchwork.kernel.org/patch/1309561/.
> 
> It also looks quite like this one we posted a while ago [1]. Our bad
> that we did not follow-up :-p

Indeed, I was looking for the better link (had gmane recorded in the
internal commit log) and found a few that all looked the same ... :)

Would this work for you? We should have wpa_supplicant support too, but
need to ask Andrei to look at that.

johannes
