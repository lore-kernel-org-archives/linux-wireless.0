Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-150-144.gdrpmi.dsl-w.verizon.net ([71.115.150.144]:50384
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZHAXzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 19:55:43 -0400
Message-ID: <4A74D5F5.8090409@erley.org>
Date: Sat, 01 Aug 2009 19:55:33 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: sidhayn@gmail.com
Subject: [DISCUSS] Implement non standard channel widths
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been kicking around the idea of attacking the addition of the ability to set non 20MHz channels to the mac80211 stack.  I've come up with 2 potentially un-intrusive ways to do this, but before starting, I'd like to get a touch of discussion on which way would be preferred/acceptable upstream (if any are).


1. Extend nl80211_channel_type to have values for the other channel bandwidths we want to support.  

Maybe something like NL80211_CHAN_NO_HT_5 for 5MHz, etc.

This is the option I like least and have put the least thought into.

The upside to this is, it'd be the least intrusive into the actual code, with the downside being, that enum is currently really more aptly named nl80211_ht_channel_type, and as such, pretty much everywhere it's used currently would have to test to see if ht is supported, and if it is, if the current ht mode is supported, but also, if it's not NO_HT, if it's a non-standard channel width.


2. Add channel_width to the ieee80211_conf struct

Either an enum of allow channel widths, or a u16 like the frequency.

This is the option I like, and have spent a lot of time thinking about.

The basic steps would be:

a. add ->channel_width, default it to 20MHz
b. add command to nl80211_commands to set channel width
c. add op to cfg80211_ops to tell driver the desired channel width

then any drivers that support not 20MHz channels could implement it.

I figure, going the u16 route would be best as it allows the functionality to be the most flexible.  

With this route, setting the channel width would be done something like:
iw dev <devname> set width <width in MHz>
           or maybe 
iw dev <devname> set freq  <freq in MHz>[@<width in MHZ>]



-- Problems common to both --

In the beginning, I think that leaving the supported channels static to whatever operating band the card is in, is fine.  Yes, going to 10MHz channels would double the number of available channels in a band, but with the absolute lack of hardware(AP/Router) that supports it, having a pre-set double sized channel list seems pointless.  I suspect most people who would use this would want to set center frequency anyways, rather than specific channel, but that's another can of worms.  

Another problem, odd channel width channels.  With a 5MHz channel, would you do center freq +/-2.5MHz, or center freq +2/-3MHz/etc?  Or maybe limit the problem to only even channel widths?

Next problem, background scanning.  I think that disabling background scanning when not operating in a standard frequency would be a 'good thing', as all of the applications I can think of that would use this are cases where scanning isn't really necessary.  I could go either way on this topic though.

Final problem, HT channels.  I think that channel bonding should be mutually exclusive with non 20MHz channels.  In theory, bonded 10MHz channels could provide better throughput than a single 20MHz channel, due to the ability of a 10MHz channel to get above the noise floor at a distance, but again, this seems like the amount of work to implement would grossly increase the complexity of the problem.  Maybe this is something that should be left up to drivers as to if they can support it.  

---

In the end, I've been spending a bit of time looking at Sam's ATH5k hal, and intend on getting a pair of ath5k devices talking to each other in 5/10MHz channels.  I've already done a gross hack to get ath5k setting non 20MHz channels via a /sys interface, but that's not exactly a mergable solution(in my opinion, anyways).  I need 5MHz channels for a project I'm working on (no line of sight 2mile link with a pair of ath5k cards that have a hardware frequency scalar to 900MHz on them), so I'm going to end up doing something, and I'd rather that something be merged into mainline than a set of patches I have to maintain for eternity.  I'd also like it to be a well thought out solution that someone else has pointed out the errors in my ways as to the actual approach taken.  

Pat Erley
