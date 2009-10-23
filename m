Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:29408 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZJWPip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 11:38:45 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] libertas: monster-patch to make CFG/WEXT configurable
Date: Fri, 23 Oct 2009 17:38:18 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
References: <200910191449.18915.hs4233@mail.mn-solutions.de> <200910200835.35747.hs4233@mail.mn-solutions.de> <1256200291.12174.14.camel@johannes.local>
In-Reply-To: <1256200291.12174.14.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910231738.18965.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes, 

Little forword: it might be the case that you still have my 
RTF/WIP cfg80211 patch in your head that removes all of 
WEXT/MESH for good. I abandoned that concept.


> On Tue, 2009-10-20 at 08:35 +0200, Holger Schurig wrote:
> > > I really don't understand the point. Can't you just use the
> > > cfg80211 hooks and keep both functional at the same time?
> > > Just like orinoco does it uses cfg80211 only partially.
> > 
> > I think I can't do this in a sane way.
> 
> I don't see why not.

So, from your point of view it's ok if two different code pieces 
to the same and copete for each other?

You think it's ok that two different code paths 
report "connection" lost, once via an 
wireless_send_event(priv->dev, SIOCGIWAP ...) and once via 
cfg80211_disconnected()

You think it's ok to keep a list of scanned APs both in 
cfg80211's bss list and in libertas own bss list?

You think it's okay to have an association worker (which heavily 
relies on libertas' internal bss list) in libertas and at the 
same time a cfg80211_ops' .connect() function that might do the 
same, but quite differently?

Maybe you'll need more japanese tee :-)



> > Oh, and please don't compare libertas all the time with
> > orinoco. Orinoco is FULLMAC, libertas is HALFMAC.
> > 
> > Because libertas firmware doesn't roam, it has to be done in 
> > software. Libertas does this in assoc.c, partly in scan.c,
> > cmd.c and wext.c and even main.c. For example, libertas keeps
> > its own list of BSS entries, has code to select the best
> > matching BSS when it comes to associating ... things like
> > this. 
> 
> None of this code is relevant to mesh.

Right, but where did I say that this.


> > cfg80211 has this code too.
> 
> No, it has no roaming etc.

Did I write that?  Whatever you understood: with the libertas' 
firmware, there's *NO* firmware command where you just 
say "associate to SSID xzy" and then wait till the firmware 
scanned and associated. You've to do this by yourself.

But of course cfg80211 a code-path where you say "iw XXX connect 
ssid BLAH" and it calls the right things behind the scenes. And 
libertas has a similar codepath --- just not in the firmware.



> > Having two competing implementations running in one driver is
> > a way to havoc.
> 
> I'm not saying you should keep the old _station_ code, I'm just 
> saying you should hook it up in a way that doesn't make it
> exclusive with mesh. 

I'm not sure that I understand what you mean. I'm not 
making "station code" (whatever that is) "exclusive with mesh" 
(whatever that means).

Both libertas+WEXT and libertas+CFG80211 have code that allows 
the libertas card to be a station. The code however is *VERY* 
different, and I'm going so far to say this is a necessity. I 
cannot use "one station code" and hook this to both WEXT and 
CFG80211. Or maybe I can, but it would then be far from elegant.

And if you insist on doing that, then you'll have to do it by 
yourself: in that minute I'll stop working on Libertas + 
cfg80211.



> I'm not saying you should do mesh. I'm saying that instead of
> ripping out _all_ wext code you should just redirect/rewrite
> the wext handlers and call the cfg80211 ones, so that for
> _managed_ mode you get the new stuff, but for _mesh_ mode you
> keep the old code. 

If I redirect WEXT handler --- why should I do this in the 
driver, there is net/wireless/wext-compat.c, or?

And if would do it: then I couldn't rip out WEXT, because stuff 
goes via some WEXT handlers. But ripping out WEXT completely out 
of libertas is my long-term goal.


I don't want such a frankenstein in the code for eternity. I want 
to use cfg80211 for everything: Station, Adhoc, Mesh, Monitor. 
That's the end-goal. It's quite do-able, and very much cleaner 
than any WEXT hookiness.


> Otherwise you're not doing the driver any good at all, since
> your patch then just means that both versions need to be
> maintained. 

There's not much maintenance in the WEXT part, isn't it?




Currently we have this situation (with my latest RFC patch):

CONFIG_LIBERTAS_WEXT defined:

* basic cfg80211 handler, if someone wants to add deep-sleep,
  or other functions where we don't want to enhance WEXT
* station via WEXT
* monitor mode via sysfs-file
* mesh via WEXT
* addhoc via WEXT
* scanning via WEXT
* associating via WEXT
* disconnect notification via WEXT

CONFIG_LIBERTAS_CFG80211 defined:

* "full" cfg80211 handler
* station via CFG80211
* monitor mode partly done (no packet injection)
* mesh not done at all, should be implemented via
  .add_virtual_intf() by someone how has mesh-capable
  devices
* adhoc not done, but I'll do that once wireless-testing
  and ath5k can do adhoc again
* scanning via cfg80211
* associating via cfg80211
* disconnect notification via cfg80211_disconnected()

So, functionality-wise Libertas + cfg80211 is inferior, but on 
the same side it's future-proof. And because 
CONFIG_LIBERTAS_WEXT exist, I'm not taking any functionality 
away for people that need them.

On the other side, the implementation for libertas + cfg80211 is 
much cleaner and smaller than the old WEXT stuff.

-- 
http://www.holgerschurig.de
