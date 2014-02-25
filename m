Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:38250 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaBYUaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:30:19 -0500
Received: by mail-lb0-f178.google.com with SMTP id s7so785036lbd.23
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:30:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7F0505E4EE188548B334147800ECD7A6DAD021@ORD2MBX07A.mex05.mlsrvr.com>
References: <mailman.1.1393088401.3120.wireless-regdb@lists.infradead.org> <7F0505E4EE188548B334147800ECD7A6DAD021@ORD2MBX07A.mex05.mlsrvr.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 25 Feb 2014 12:29:57 -0800
Message-ID: <CAB=NE6Uv-7d4uCVOamR=_Pe6=vSgFbUnGE=A9OUPuTmFdPRNWQ@mail.gmail.com> (sfid-20140225_213024_702729_F8C75950)
Subject: Re: FW: wireless-regdb Digest, Vol 34, Issue 5
To: Mike Rex <mrex@tranzeo.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, I meant "lift". Please find the documentation here:

http://wireless.kernel.org/en/developers/Regulatory/processing_rules#Beacon_hints

Also please don't e-mail me privately.

  Luis

On Tue, Feb 25, 2014 at 10:40 AM, Mike Rex <mrex@tranzeo.com> wrote:
> " cfg80211 has a feature called beacon hinting to assist cfg80211 in allowing a card to life passive-scan and no-beaconing flags."
>
> That doesn't make sense in English, specifically the "life" usage.  Did you mean "use"?
>
> Regards,
> Mike
>
> -----Original Message-----
> From: wireless-regdb [mailto:wireless-regdb-bounces@lists.infradead.org] On Behalf Of wireless-regdb-request@lists.infradead.org
> Sent: February 22, 2014 9:00 AM
> To: wireless-regdb@lists.infradead.org
> Subject: wireless-regdb Digest, Vol 34, Issue 5
>
> Send wireless-regdb mailing list submissions to
>         wireless-regdb@lists.infradead.org
>
> To subscribe or unsubscribe via the World Wide Web, visit
>         http://lists.infradead.org/mailman/listinfo/wireless-regdb
> or, via email, send a message with subject or body 'help' to
>         wireless-regdb-request@lists.infradead.org
>
> You can reach the person managing the list at
>         wireless-regdb-owner@lists.infradead.org
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of wireless-regdb digest..."
>
>
> Today's Topics:
>
>    1. Re:  [PATCH v3 6/6] mac80211: Enable initiating   radiation on
>       indoor channels (Luis R. Rodriguez)
>    2. Re:  [PATCH 1/4] cfg80211: regulatory,    introduce DFS CAC time
>       (Luis R. Rodriguez)
>
>
> ----------------------------------------------------------------------
>
> Message: 1
> Date: Fri, 21 Feb 2014 15:31:46 -0800
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> To: "Peer, Ilan" <ilan.peer@intel.com>
> Cc: "wireless-regdb@lists.infradead.org"
>         <wireless-regdb@lists.infradead.org>, "linux-wireless@vger.kernel.org"
>         <linux-wireless@vger.kernel.org>
> Subject: Re: [wireless-regdb] [PATCH v3 6/6] mac80211: Enable
>         initiating      radiation on indoor channels
> Message-ID:
>         <CAB=NE6WD93GCtsKpXUJB8pZ-+9wOcF1E4QxNX4rRyed26JCHoQ@mail.gmail.com>
> Content-Type: text/plain; charset=UTF-8
>
> On Wed, Feb 19, 2014 at 11:58 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
>>>
>>> On Wed, Feb 19, 2014 at 03:28:29PM +0000, Peer, Ilan wrote:
>>> > I'll abandon this change ...
>>>
>>> Wait lets talk about this.
>>>
>>> > > I don't see why being indoor should allow to override the NO-IR
>>> > > flag. I do see however why being indoor should enable to IR if you
>>> > > are IR if you have the indoor flag. Enabling to IR if you are indoor
>>> > > for all NO-IR channels is... pretty permissive I do not see the correlation.
>>> > >
>>> >
>>> > Make sense. I did not have such relaxations defined, just thought that
>>> > similar relaxations could also be used in cases of scanning etc. but I
>>> > guess this is not always true.
>>>
>>> The original beacon hint mechanism is very expansive to all beacons on non 5
>>> GHz DFS channels and non 2.4 channel
>>> 12 or 13. If a vendor can possibly not like that beacon hint implementation as
>>> its too permissive (and I don't think it is) but they do want to trust beacon
>>> hints from APs in the case you are describing then you can enable a new
>>> feature flag to distinguish this. The beacon infrastructure code would then
>>> ignore the regular beacon hints on devices that don't have the old flag, but
>>> would trust this new form of beacon hint. If a device supported the old all
>>> inclusive flag they'd trust both. You'd have to update the kdocs for the old
>>> one, and likely add a new routine similar to regulatory_hint_found_beacon().
>>>
>>
>> This make sense (also got a direct answer from our regulatory folks on this ... finally ;))
>
> Oh wow, are they on the wireless-regdb list?
>
>>> I'm not sure its worth it though, I'd rather push vendors to consider first using
>>> the regular becaon hint mechanism and trusting it. Maybe devices that want
>>> this new functionality you are trusting should implicate revising trusting
>>> beacon hint mechanism ?
>>>
>>
>> Our regulatory people said that a similar approach is WIP in the FCC where they are willing to use a similar relaxation as the beacons hints but with some limitations such as having at least a number of APs operating on the channel etc.
>
> That seems to be biased towards populated spectrum areas. I suspect
> the conflict here would be not wanting to trust GO's, but consider
> this: why not? GO's won't IR unless they have some heuristics like the
> one you are adding to determine its OK to IR. Furthermore our own
> beacon hint infrastructure in the kernel does check to ensure we don't
> trust mesh or IBSS, we ensure its from an ESS, ie WLAN_CAPABILITY_ESS:
>
> if (res->pub.capability & WLAN_CAPABILITY_ESS)
>   regulatory_hint_found_beacon(wiphy, channel, gfp);
>
> BTW I just updated our documentation for this, here:
>
> http://wireless.kernel.org/en/developers/Regulatory/processing_rules#Beacon_hints
>
> Please feel free to socialize this algorithm with the FCC PHBs and
> other regulatory folks to see if they can see any loopholes or would
> prefer any other considerations or APIs to be extended. I think this
> is pretty safe and I'd love to know of issues that people could be
> concerned over this.
>
>> If its ok with you I prefer to leave things as is for now.
>
> You mean you'll drop this patch for sure then while we hope a
> socialization of our algorithm can be proven as reasonable for Intel
> to embrace :) ?
>
>   Luis
>
>
>
> ------------------------------
>
> Message: 2
> Date: Fri, 21 Feb 2014 16:31:14 -0800
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Cc: "wireless-regdb@lists.infradead.org"
>         <wireless-regdb@lists.infradead.org>, Johannes Berg
>         <johannes@sipsolutions.net>, linux-wireless
>         <linux-wireless@vger.kernel.org>, "John W. Linville"
>         <linville@tuxdriver.com>
> Subject: Re: [wireless-regdb] [PATCH 1/4] cfg80211: regulatory,
>         introduce DFS CAC time
> Message-ID:
>         <CAB=NE6UV6QdAK-hz738KHg19KezBzSEun0Zz0zsiDuOnVecj-w@mail.gmail.com>
> Content-Type: text/plain; charset=UTF-8
>
> On Wed, Feb 19, 2014 at 11:12 PM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>> We can allow VERSION=19 and VERSION=20, and handle this in CRDA
>> dynamically. This should be quite easy.
>
> My point was what about older versions of CRDA that get a new
> wireless-regdb tossed onto the system?
>
>   Luis
>
>
>
> ------------------------------
>
> Subject: Digest Footer
>
> _______________________________________________
> wireless-regdb mailing list
> wireless-regdb@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wireless-regdb
>
>
> ------------------------------
>
> End of wireless-regdb Digest, Vol 34, Issue 5
> *********************************************
