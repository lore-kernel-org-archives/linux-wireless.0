Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2CWPBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 11:01:37 -0400
Message-ID: <1332514895.10384.40.camel@jlt3.sipsolutions.net> (sfid-20120323_160141_068030_63DCD1AC)
Subject: Re: [RFC 00/12] multi-channel support
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82?= Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Mar 2012 16:01:35 +0100
In-Reply-To: <4F6C82A5.5080302@tieto.com> (sfid-20120323_150333_004349_1A5648D7)
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>
		 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>
	 <4F6C82A5.5080302@tieto.com> (sfid-20120323_150333_004349_1A5648D7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-23 at 15:03 +0100, Michał Kazior wrote:

> What if we create a new structure that would be a channel 
> stream/reservation? Driver could then report multiple such objects.
> Each such would have a tx queue and it's own locking. Let's assume
> something like:
> 
>    struct ieee80211_channel_stream {
>      struct list_head vif; // list of vifs we're attached to
>      struct ieee80211_channel *ch;
>      struct sk_buff_head pending;
>      int stop_reasons[IEEE80211_MAX_QUEUES];
>      // .. other stuff
>      u8 *drv_priv[0] __attribute__((__aligned__((void *))));
>    };

I'm not sure I see the need to have the driver register these, but it
seems useful to maintain this abstraction somehow in mac80211.

Due to the interface combinations advertising, we already know (*) what
is supported by the driver, so there's no need for the driver to
register this again.

Like I said earlier, I see basically two ways of handling this.

The explicit way would essentially consist of something like this:

struct ieee80211_channel_context {
	struct ieee80211_channel *chan;
	enum nl80211_channel_type type;
};

with API to add/remove such contexts from/to the device:

struct ieee80211_ops {
	...
	void (*add_channel_context)(hw, ctx),
	void (*remove_channel_context)(hw, ctx),
	void (*change_channel_type)(hw, ctx),
	void (*assign_vif_channel_context)(hw, vif, ctx),
};

The assign function would have rather strange semantics though -- it can
be called only when the interface is up (added to the driver), but it
can't be called while the interface is associated, active as an AP, etc.
EXCEPT ... maybe it can in CSA scenarios. But I said that before: CSA is
a bit of a mess to handle.

Now that I think about it, the implicit way I previously thought was
quite a separate mechanism is really very similar: you'd still have to
have the assign_vif_channel_context function, maybe as part of
bss_info_changed, but not have explicit add/remove. I think the
add/remove is useful so let's not consider implicit methods any more :)

The internal handling in mac80211 might have a linked list of the
channel contexts, or just a static array of a handful of them, doesn't
really matter. It would, however, make sure that there aren't more than
the current interface combination advertised as supported (see (*)
again.)

Of course mac80211 would also assign the interfaces to channel contexts
as needed -- if a given interface is already on channel 1, the next one
wouldn't need a new channel context if it also uses channel 1 and the
channel types are compatible. But that reminds me -- when we do that we
may have to update the channel context to change its channel type, so
add an operation for that.


Wrt. off-channel, I'm not sure I've understood you correctly. The
current off-channel is a very short-lived thing that doesn't really use
a "complete" channel context. In fact, in our implementation it is
completely separate since it's temporary (**).

As far as scanning is concerned, I'm not really sure. I haven't spent
much time thinking about it since we have hardware offload for it (and
also off-channel) -- I'm not sure what a good solution would be.

johannes


(*) after we refactor cfg80211_can_change_interface() and export
cfg80211_get_current_combination() that returns the pointer to the
combination that's currently in use, or something like that. We'd have
to figure out if another combination is available that has more channels
though, if needed.

(**) However, we're thinking about implementing a P2P-device context
that would allow offloading things like periodic listen
(discoverability) or find (search + listen). That would probably use a
channel context then.

