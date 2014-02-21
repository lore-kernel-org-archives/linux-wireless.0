Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33534 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaBUXcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 18:32:08 -0500
Received: by mail-la0-f51.google.com with SMTP id c6so2941353lan.10
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 15:32:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A033383EED@HASMSX106.ger.corp.intel.com>
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-7-git-send-email-ilan.peer@intel.com> <20140219001458.GF14296@garbanzo.do-not-panic.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A03338353E@HASMSX106.ger.corp.intel.com>
 <20140219160301.GH14296@garbanzo.do-not-panic.com> <CB3B3D4774441E42AA3EA0E1BA8230A033383EED@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 15:31:46 -0800
Message-ID: <CAB=NE6WD93GCtsKpXUJB8pZ-+9wOcF1E4QxNX4rRyed26JCHoQ@mail.gmail.com> (sfid-20140222_003227_531459_ED1BC4A0)
Subject: Re: [PATCH v3 6/6] mac80211: Enable initiating radiation on indoor channels
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 11:58 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
>>
>> On Wed, Feb 19, 2014 at 03:28:29PM +0000, Peer, Ilan wrote:
>> > I'll abandon this change ...
>>
>> Wait lets talk about this.
>>
>> > > I don't see why being indoor should allow to override the NO-IR
>> > > flag. I do see however why being indoor should enable to IR if you
>> > > are IR if you have the indoor flag. Enabling to IR if you are indoor
>> > > for all NO-IR channels is... pretty permissive I do not see the correlation.
>> > >
>> >
>> > Make sense. I did not have such relaxations defined, just thought that
>> > similar relaxations could also be used in cases of scanning etc. but I
>> > guess this is not always true.
>>
>> The original beacon hint mechanism is very expansive to all beacons on non 5
>> GHz DFS channels and non 2.4 channel
>> 12 or 13. If a vendor can possibly not like that beacon hint implementation as
>> its too permissive (and I don't think it is) but they do want to trust beacon
>> hints from APs in the case you are describing then you can enable a new
>> feature flag to distinguish this. The beacon infrastructure code would then
>> ignore the regular beacon hints on devices that don't have the old flag, but
>> would trust this new form of beacon hint. If a device supported the old all
>> inclusive flag they'd trust both. You'd have to update the kdocs for the old
>> one, and likely add a new routine similar to regulatory_hint_found_beacon().
>>
>
> This make sense (also got a direct answer from our regulatory folks on this ... finally ;))

Oh wow, are they on the wireless-regdb list?

>> I'm not sure its worth it though, I'd rather push vendors to consider first using
>> the regular becaon hint mechanism and trusting it. Maybe devices that want
>> this new functionality you are trusting should implicate revising trusting
>> beacon hint mechanism ?
>>
>
> Our regulatory people said that a similar approach is WIP in the FCC where they are willing to use a similar relaxation as the beacons hints but with some limitations such as having at least a number of APs operating on the channel etc.

That seems to be biased towards populated spectrum areas. I suspect
the conflict here would be not wanting to trust GO's, but consider
this: why not? GO's won't IR unless they have some heuristics like the
one you are adding to determine its OK to IR. Furthermore our own
beacon hint infrastructure in the kernel does check to ensure we don't
trust mesh or IBSS, we ensure its from an ESS, ie WLAN_CAPABILITY_ESS:

if (res->pub.capability & WLAN_CAPABILITY_ESS)
  regulatory_hint_found_beacon(wiphy, channel, gfp);

BTW I just updated our documentation for this, here:

http://wireless.kernel.org/en/developers/Regulatory/processing_rules#Beacon_hints

Please feel free to socialize this algorithm with the FCC PHBs and
other regulatory folks to see if they can see any loopholes or would
prefer any other considerations or APIs to be extended. I think this
is pretty safe and I'd love to know of issues that people could be
concerned over this.

> If its ok with you I prefer to leave things as is for now.

You mean you'll drop this patch for sure then while we hope a
socialization of our algorithm can be proven as reasonable for Intel
to embrace :) ?

  Luis
