Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60491 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZCELpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 06:45:22 -0500
Subject: Re: ath5k master (AP) mode
From: Dan Williams <dcbw@redhat.com>
To: pat-lkml <pat-lkml@erley.org>
Cc: Alexey Yudichev <ayudichev@yahoo.co.uk>,
	"Christoph .J Thompson" <cjsthompson@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <49AF077D.2020408@erley.org>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	 <4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>
	 <20090304232625.cc47eb46.cjsthompson@gmail.com>
	 <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
	 <49AF077D.2020408@erley.org>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 06:43:22 -0500
Message-Id: <1236253402.31456.8.camel@localhost> (sfid-20090305_124532_056280_C2034022)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-04 at 17:58 -0500, pat-lkml wrote:
> Alexey Yudichev wrote:
> >> On Wed, 4 Mar 2009 21:33:21 +0000
> >> Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
> >>> Hello,
> >>>
> >>> I've just joined the list so don't know how to join the same thread so
> >>> to indicate that it's the same matter I use the same subject. I am
> >>> trying to make my "04:01.0 Ethernet controller: Atheros Communications
> >>> Inc. Atheros AR5001X+ Wireless Network Adapter (rev 01)" which is
> >>> identified by ath5k as
> >>> [   10.356742] ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
> >>> [   10.356748] ath5k phy0: RF5112B multiband radio found (0x36)
> >> I have the exact same card (AR5001X+) working in master mode with hostapd. What kernel version and hostapd version do you use?
> > 
> > Hi, I use 2.6.27-11-generic (from ubuntu's
> > linux-backports-modules-intrepid-generic), hostapd v0.5.10.
> 
> I don't know if it's intended, or just not implemented, but iwconfig <iface> mode master
> won't work with mac80211 drivers.  Hostapd knows how to set master mode on it's own. 

Hostapd needs to be used for master mode in *any* case.  So yes, its
intended that you need hostapd for master mode with mac80211 drivers.
Just switching the card to master mode simply won't work, because
there's oh-so-much-more setup required in addition to that, which
hostapd knows how to do.

Dan


