Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:12221
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060AbYCAL4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 06:56:04 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: FIF_ filter flags
Date: Sat, 1 Mar 2008 11:55:57 +0000
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802292339.27174.linux@baker-net.org.uk> <1204330161.3938.55.camel@johannes.berg>
In-Reply-To: <1204330161.3938.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803011155.57958.linux@baker-net.org.uk> (sfid-20080301_115608_655305_B8A49CB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 March 2008 00:09, Johannes Berg wrote:
> Hi,
>
> > For example rt2x00 devices only have one promiscuous mode that covers
> > traffic in the same and other BSSes therefore if either of
> > FIF_PROMISC_IN_BSS or FIF_OTHER_BSS are set then the driver will set both
> > of them in the returned flags value.
> >
> > It will also for some devices set the FIF_ALLMULTI flag if mc_count is
> > non zero.
> >
> > If this behaviour is considered desirable then I'll keep it working when
> > making the change but if not I'll remove it.
>
> Interesting. I don't think I have an opinion right now. I wanted to be
> strict about clearing the flags so that you don't end up with a flag
> that we never get traffic for, but I can't imagine any check where you'd
> want to know "do I get traffic XY".

The only way I think it might be useful is if it allows mac80211 to not bother 
with checks that it would otherwise do, for example if mac80211 didn't want 
to pass multicast packets that were not for us up to the higher stack layers 
it would know that if FIF_ALLMULTI got set it needed to do some filtering but 
if it wasn't set the hardware had a working multicast address filter.

>
> How do you keep track of that anyway? Say somebody enables
> FIF_PROMISC_IN_BSS and you also set FIF_OTHER_BSS, then when
> FIF_PROMISC_IN_BSS is disabled again FIF_OTHER_BSS should be disabled
> too but how know that it wasn't set in the meantime? I think that says
> that you shouldn't do that...
>

rt2x00 ignores the changed_flags passed from mac80211 and keeps track for 
itself of what filter it is applying so it will always recalculate it's own 
filter based on total_flags and reconfigure the hardware if it changes. This 
does assume that mac80211 recalculates what it wants total_flags to be each 
time configure_filter is called rather than just changing the value it got 
back last time but that appears to be a valid assumption.

Adam 
