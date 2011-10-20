Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1JTRvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 13:51:22 -0400
Subject: Re: [PATCH 2/3] mac80211: find correct IE offset in mesh beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAG6hwVOVHSN_-vfvVNQsGrZZtipArNs9UoPQb-gy1ZhC0owC=w@mail.gmail.com> (sfid-20111020_194901_127802_6503536C)
References: <1319070203-22097-1-git-send-email-thomas@cozybit.com>
	 <1319070203-22097-2-git-send-email-thomas@cozybit.com>
	 <1319109210.3959.6.camel@jlt3.sipsolutions.net>
	 <CAG6hwVOVHSN_-vfvVNQsGrZZtipArNs9UoPQb-gy1ZhC0owC=w@mail.gmail.com>
	 (sfid-20111020_194901_127802_6503536C)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 19:51:15 +0200
Message-ID: <1319133075.17101.4.camel@jlt3.sipsolutions.net> (sfid-20111020_195125_366272_A65FC7DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-20 at 10:48 -0700, Thomas Pedersen wrote:
> On Thu, Oct 20, 2011 at 4:13 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> -     baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
> >> +     switch (stype) {
> >> +     case IEEE80211_STYPE_PROBE_RESP:
> >> +             ies = (u8 *) mgmt->u.probe_resp.variable;
> >> +             break;
> >> +     case IEEE80211_STYPE_BEACON:
> >> +             ies = (u8 *) mgmt->u.beacon.variable;
> >> +             break;
> >> +     default:
> >> +             return;
> >> +     }
> >> +
> >
> > Does that really make sense? the offset is the same anyway and we don't
> > get here with other frames.
> 
> I don't think so:
> 
>                 struct {
>                         __le64 timestamp;
>                         __le16 beacon_int;
>                         __le16 capab_info;
>                         /* followed by some of SSID, Supported rates,
>                          * FH Params, DS Params, CF Params, IBSS Params, TIM */
>                         u8 variable[0];
>                 } __attribute__ ((packed)) beacon;
>                 struct {
>                         /* only variable items: SSID, Supported rates */
>                         u8 variable[0];
>                 } __attribute__ ((packed)) probe_req;

Err, probe_req != probe_resp.

johannes

