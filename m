Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab1LNIWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 03:22:14 -0500
Subject: Re: [RFC 2/4] mac80211: refactor station state transitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <CAG6hwVNNg9bVErL-rnjsAPK3ymVfFg=t+ifparDi9xFnUzN_bg@mail.gmail.com> (sfid-20111214_013052_755018_6A862511)
References: <20111213200717.465896579@sipsolutions.net>
	 <20111213201449.723037139@sipsolutions.net>
	 <CAG6hwVNNg9bVErL-rnjsAPK3ymVfFg=t+ifparDi9xFnUzN_bg@mail.gmail.com>
	 (sfid-20111214_013052_755018_6A862511)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 09:22:11 +0100
Message-ID: <1323850931.3380.4.camel@jlt3.sipsolutions.net> (sfid-20111214_092218_545091_C5A27EFE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-13 at 16:29 -0800, Thomas Pedersen wrote:
> On Tue, Dec 13, 2011 at 12:07 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Station entries can have various states, the most
> > important ones being auth, assoc and authorized.
> > This patch prepares us for telling the driver about
> > these states, we don't want to confuse drivers with
> > strange transitions, so with this we enforce that
> > they move in the right order between them (back and
> > forth); some transitions might happen before the
> > driver even knows about the station, but at least
> > runtime transitions will be ordered correctly.
> >
> > As a consequence, IBSS and MESH stations will now
> > have the ASSOC flag set (so they can transition to
> > AUTHORIZED), and we can get rid of a special case
> > in TX processing.
> >
> > TBD: WLAN_STA_TDLS_PEER_AUTH?
> > TBD: secure mesh AUTH transitions?
> 
> This patch makes it impossible to add a new unauthenticated station,
> AFAICT. Maybe this is not even desirable from mac80211's POV? The
> reason the secure mesh daemon adds a new unauthenticated peer is to
> stop NL80211_NEW_PEER_CANDIDATE notifications while userspace is
> handling the authentication process, and we need a station entry for
> ieee80211_mgmt_tx().

Ah, yes. I had to sleep over this -- now I understand why I was
confused. I'll amend the patch series to properly manage more of this in
cfg80211. I have a feeling we should also allow userspace to manage the
ASSOC state, but can we require it from the secure mesh userspace
daemon? It would break backward compatibility if we do ... I'll try to
find a workaround :)

johannes

