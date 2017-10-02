Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49222 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbdJBP5W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 11:57:22 -0400
Message-ID: <1506959840.10681.0.camel@sipsolutions.net> (sfid-20171002_175725_636303_F99316BB)
Subject: Re: [PATCH] nl80211: look for HT/VHT capabilities in beacon's tail
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Oct 2017 17:57:20 +0200
In-Reply-To: <20171002153428.dhh47qlza7agrru4@bars>
References: <20170830205225.17228-1-igor.mitsyanko.os@quantenna.com>
         <20171002153428.dhh47qlza7agrru4@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-02 at 18:34 +0300, Sergey Matyukevich wrote:
> On Wed, Aug 30, 2017 at 01:52:25PM -0700, igor.mitsyanko.os@quantenna
> .com wrote:
> 
> > There are no HT/VHT capabilities in
> > cfg80211_ap_settings::beacon_ies,
> > these should be looked for in beacon's tail instead.
> > 
> > Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> > ---
> > 
> > This is true for hostapd (at least the one in mainline): it does
> > not
> > include HT/VHT caps and WLAN_EID_SUPP_RATES into beacon_ies.
> > But worth noting that there is no clear documentation that I could
> > find
> > on what IEs could and could not be included into beacon_ies.
> > 
> >  net/wireless/nl80211.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Hello Johannes,
> 
> Any comments on this change ?

It's already in linux.git ...

johannes
