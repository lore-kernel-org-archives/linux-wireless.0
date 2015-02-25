Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43741 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbbBYIC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 03:02:56 -0500
Message-ID: <1424851368.2050.8.camel@sipsolutions.net> (sfid-20150225_090318_319715_14031CCE)
Subject: Re: Connection issues with BW Tracking in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 25 Feb 2015 09:02:48 +0100
In-Reply-To: <CABPxzY+Z97Q4JSSaR2GfGnxbbR721qJ-v_AjG4Kc1TGetHF4ng@mail.gmail.com> (sfid-20150224_221135_386626_6E22A752)
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
	 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
	 <1424772587.2192.14.camel@sipsolutions.net>
	 <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com>
	 <1424774105.2192.29.camel@sipsolutions.net>
	 <CABPxzYJkoCWud=yfNHL5m2FUCPOc854i_L+VB4sN+o8Skb-Pnw@mail.gmail.com>
	 <CABPxzYL4Fz+y7dpp650RyqXVWtL5WC4YkvsQ1_=znOmrmUZF5A@mail.gmail.com>
	 <1424810867.2192.60.camel@sipsolutions.net>
	 <CABPxzY+Z97Q4JSSaR2GfGnxbbR721qJ-v_AjG4Kc1TGetHF4ng@mail.gmail.com>
	 (sfid-20150224_221135_386626_6E22A752)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-02-25 at 02:41 +0530, Krishna Chaitanya wrote:
> On Wed, Feb 25, 2015 at 2:17 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2015-02-25 at 02:03 +0530, Krishna Chaitanya wrote:
> >
> >> Use case2: When changing from HT40-VHT80, the connection goes through
> >> but it still connected as HT40 (vht_ie from cfg80211 is returned
> >> null).
> >>
> >> Can you think of any reason why the bss_list is not updated cfg80211?
> >> Note: iwconfig and wpa_supplicant both show same behavior.
> >
> > Well, there's no flushing, only overwriting by new results - but if you
> > previuosly got both beacons and probe responses each one will stick
> > around until you get them again.
> We do have the scan results expiry time of 30secs, that will flush the
> results from bss_list right? Even the get_bss checks for aging?

Yes but if you scan in the meantime the scan result is marked as recent
again, even if some old data might be kept. Perhaps we should split that
into timestamps for probe and beacons separately, but that'd certainly
complicate the code significantly for little gain.

johannes

