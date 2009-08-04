Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-150-144.gdrpmi.dsl-w.verizon.net ([71.115.150.144]:47050
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbZHDGPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 02:15:20 -0400
Message-ID: <4A77D1F5.5050706@erley.org>
Date: Tue, 04 Aug 2009 02:15:17 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [DISCUSS] Implement non standard channel widths
References: <4A74D5F5.8090409@erley.org> <1249201869.2007.45.camel@johannes.local>
In-Reply-To: <1249201869.2007.45.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[resending with reply-all... oops]

Johannes Berg wrote:
> Hi Pat,
> 
> On Sat, 2009-08-01 at 19:55 -0400, Pat Erley wrote:
>> I've been kicking around the idea of attacking the addition of the
>> ability to set non 20MHz channels to the mac80211 stack.  I've come up
>> with 2 potentially un-intrusive ways to do this, but before starting,
>> I'd like to get a touch of discussion on which way would be
>> preferred/acceptable upstream (if any are).
>>
>>
>> 1. Extend nl80211_channel_type to have values for the other channel
>> bandwidths we want to support.  
>>
>> Maybe something like NL80211_CHAN_NO_HT_5 for 5MHz, etc.
>>
>> This is the option I like least and have put the least thought into.
> 
> Personally, it's the option I like most, combined with registering, for
> each channel, which channel widths are supported on it.
> 
>> The upside to this is, it'd be the least intrusive into the actual
>> code, with the downside being, that enum is currently really more
>> aptly named nl80211_ht_channel_type, and as such, pretty much
>> everywhere it's used currently would have to test to see if ht is
>> supported, and if it is, if the current ht mode is supported, but
>> also, if it's not NO_HT, if it's a non-standard channel width.
> 
> You're right that it currently is mostly about HT, but I don't see why
> all this testing should be necessary. I'd just use the managed mode
> interface flag IEEE80211_STA_DISABLE_11N.
> 
>> With this route, setting the channel width would be done something like:
>> iw dev <devname> set width <width in MHz>
>>            or maybe 
>> iw dev <devname> set freq  <freq in MHz>[@<width in MHZ>]
> 
> I don't like the technicalities of this, I think that the channel width
> should be set with the "connect" call. Of course, it has to be supported
> here as well, for monitor purposes, but shouldn't be required here.
> 
>> -- Problems common to both --
>>
>> In the beginning, I think that leaving the supported channels static
>> to whatever operating band the card is in, is fine.  Yes, going to
>> 10MHz channels would double the number of available channels in a
>> band, but with the absolute lack of hardware(AP/Router) that supports
>> it, having a pre-set double sized channel list seems pointless.  I
>> suspect most people who would use this would want to set center
>> frequency anyways, rather than specific channel, but that's another
>> can of worms.  
> 
> Also keep in mind that there _are_ standard uses for smaller bandwidth
> channels, Jouni has helpfully collected them on
> http://wireless.kernel.org/en/developers/Documentation/ChannelList

Yeah, I fully understand that there are other frequency ranges that this
will be useful in.  My actual goal is using it in the 900mhz spectrum.
 
>> Another problem, odd channel width channels.  With a 5MHz channel,
>> would you do center freq +/-2.5MHz, or center freq +2/-3MHz/etc?  Or
>> maybe limit the problem to only even channel widths?
> 
> I don't think even channel widths can work, since we really do need 5
> MHz :) But it shouldn't be that much of a problem, we already use KHz in
> a number of places.
> 
>> Next problem, background scanning.  I think that disabling background
>> scanning when not operating in a standard frequency would be a 'good
>> thing', as all of the applications I can think of that would use this
>> are cases where scanning isn't really necessary.  I could go either
>> way on this topic though.
> 
> We don't have any background scanning.
> 
>> Final problem, HT channels.  I think that channel bonding should be
>> mutually exclusive with non 20MHz channels.  In theory, bonded 10MHz
>> channels could provide better throughput than a single 20MHz channel,
>> due to the ability of a 10MHz channel to get above the noise floor at
>> a distance, but again, this seems like the amount of work to implement
>> would grossly increase the complexity of the problem.  Maybe this is
>> something that should be left up to drivers as to if they can support
>> it.  
> 
> I can agree with this -- I think "HT" should be left reserved for real
> HT, that is 20 or 40 MHz 'channels', where 40 really is bonding as you
> say.
> 
> So let me outline how I'd handling this, by extending the flags instead
> of using a bandwidth number.
> 
> The first thing I'd do is start with some cleanup -- remove the
> 'max_bandwidth' member from struct ieee80211_channel, it's used only
> write-only in a few places afaict. In fact, I'm happy to do that
> unrelated to this work.
> 
> The second thing I'd do is refactor the use of IEEE80211_CHAN_NO_HT40*,
> remove that from the flags field (maybe making the flags field a u16)
> and introducing a new "types" field, which would take a bitmask of
> BIT(NL80211_CHAN_*) values. This would have to be set to default to
> 	BIT(NL80211_CHAN_NO_HT)
> or, if HT is supported,
> 	BIT(NO_HT) | BIT(HT20) | BIT(HT40+) | BIT(HT40-)
> and would also need an orig_types field, and then regulatory code
> removes the bits from "types" as appropriate, leaving them in
> "orig_types" for future regulatory changes. Just like "flags" works.
> 
> Note that the default value for types should be applied if, and only if
> (!), the types field is set to 0 (i.e. unset) by the driver. IOW,
> cfg80211's channel checking loop in wiphy_register() would get this
> code:
> 	if (!sband->channels[i].types) {
> 		sband->channels[i].types = BIT(NL80211_..._NO_HT);
> 		if (sband->ht_cap.ht_supported)
> 			sband->channels[i].types |= ...;
> 	}
> 
> 
> Third, the channel type needs to be a bit more pervasive. As a start,
> I'd start with adding it to connect(), ibss_join() (maybe) and
> set_channel() commands. This mostly involves cfg80211 and mac80211, but
> not all the full-mac drivers since they don't support anything other
> than NO_HT yet (which should probably be renamed to 20MHZ).
> 
> This would already have one good thing: it would give us the ability to
> request, from userspace, to disable HT40 and/or HT40, by passing:
>  - no flags: automatic, use all
>  - HT20: no HT40 permitted (don't think we can _force_ ht20?)
>  - NO_HT: no HT permitted
> 
> This is a little strange though, but at least NO_HT would be easy by
> setting IEEE80211_STA_DISABLE_11N, maybe reject the others for a start.
> 
> This is validated against the channel you're using, of course, in the
> cfg80211 SME etc.
> 
> One other thing that would be necessary is adding channel type to scan
> results, I guess?
> 
> 
> Then, finally, I'd add a new channel type, NL80211_CHANNEL_TYPE_5MHZ.
> Document it to imply that HT is being turned off, of course. Now this
> bit should be really simple.
> 
> 
> I don't think the 'specify bandwidth' instead of using flags really
> gains you much in this process?
> 
> Mind you I'm not nailing down that process now, it's just how I'm
> currently thinking about it.
> 
> johannes

Great, Thanks for the input.  I'm busy tonight, but I'll take a look 
tomorrow and try to start this, at least in a pseudo mock-up.  I have
a basic idea how I'll attack this:

1. add bitfield
2. duplicate all functionality as pertains to bitfield
3. update drivers to use bitfield/export their supported modes
4. remove old functionality, rename bitfield


That of course simplifies the actual amount of work it encompases, but
I believe going with this sort of approach will prevent breaking git
bisection.

Would we want the bitfield sparse, to allow for the insertion of other
modes of operation we hadn't thought of?  Also, should it be used like
how the NL80211_IF_TYPE_* flags are used, in that ALL supported features
should be added if it's to be used?  Specifically, we're going to assume
that if a driver exports it's supported modes, it will include stuff like
NO_HT if it supports operation without HT (which I think ALL devices that
comply with the 802.11{a,b,g,n} specs would support.  It should probably
be a long term goal to then add this to all drivers, period, so that
we won't have to make any assumptions about what a driver supports from
the mac80211 layer.  

Also, would we want to add a log message when switching from/to 
non-standard operating modes?  Something like have a bit that marks the
highest standard mode, then any additional modes(currently 5/10 mhz only
could later be extended to adding HT/bonding/xspan in narrower channels)
would come after that and have something like:


if(mode > MAX_OPMODE)
	printk(some facility, "Switching to opmode %s "
                              "which is not standardized", mode);

(Of course, greatly simplified).

Anyways, you've given me a good starting point, thanks.  As I come up 
with more questions/thoughts, I'll post them.

Pat


