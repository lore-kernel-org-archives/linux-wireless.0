Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:39497 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbCKQPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 12:15:30 -0400
Received: by wevl61 with SMTP id l61so10377950wev.6
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 09:15:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1424851368.2050.8.camel@sipsolutions.net>
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
 <1424772587.2192.14.camel@sipsolutions.net> <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com>
 <1424774105.2192.29.camel@sipsolutions.net> <CABPxzYJkoCWud=yfNHL5m2FUCPOc854i_L+VB4sN+o8Skb-Pnw@mail.gmail.com>
 <CABPxzYL4Fz+y7dpp650RyqXVWtL5WC4YkvsQ1_=znOmrmUZF5A@mail.gmail.com>
 <1424810867.2192.60.camel@sipsolutions.net> <CABPxzY+Z97Q4JSSaR2GfGnxbbR721qJ-v_AjG4Kc1TGetHF4ng@mail.gmail.com>
 <1424851368.2050.8.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 11 Mar 2015 21:45:08 +0530
Message-ID: <CABPxzYKa5eR+UrinkqY99jxOpVR4mTYcW_3xZ5f2kf9hXHCznA@mail.gmail.com> (sfid-20150311_171533_736066_652F2A19)
Subject: Re: Connection issues with BW Tracking in mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2015 at 1:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Wed, 2015-02-25 at 02:41 +0530, Krishna Chaitanya wrote:
> > On Wed, Feb 25, 2015 at 2:17 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > On Wed, 2015-02-25 at 02:03 +0530, Krishna Chaitanya wrote:
> > >
> > >> Use case2: When changing from HT40-VHT80, the connection goes through
> > >> but it still connected as HT40 (vht_ie from cfg80211 is returned
> > >> null).
> > >>
> > >> Can you think of any reason why the bss_list is not updated cfg80211?
> > >> Note: iwconfig and wpa_supplicant both show same behavior.
> > >
> > > Well, there's no flushing, only overwriting by new results - but if you
> > > previuosly got both beacons and probe responses each one will stick
> > > around until you get them again.
> > We do have the scan results expiry time of 30secs, that will flush the
> > results from bss_list right? Even the get_bss checks for aging?
>
> Yes but if you scan in the meantime the scan result is marked as recent
> again, even if some old data might be kept. Perhaps we should split that
> into timestamps for probe and beacons separately, but that'd certainly
> complicate the code significantly for little gain.

I did some experiments on this and found the root cause.

We are using 5GHz in WORLD Mode, so only passive scan is allowed.
So when connecting the very first time, the mac80211 MLME sees that
there are no probe_resp ies (only beacon_ies are present) and it sends
a directed probe and updates the probe_resp ies. (and also the "ies").

But when config is changed and we get disconnected, beacon_ies are updated
with the new config, but the probe_resp ies are not.
cfg80211_bss_update assigns
probe_resp ies to "ies' and mac80211 updates its bss info based on the
probe_resp
ies which have old config causing the issue.

Solution:

1) Make the directed probe mandatory.
2) As you suggested maintain timestamps for probe_resp_ies and beacon_ies
and use the latest.

Any takes?

Regards,
Chaitanya T K.
