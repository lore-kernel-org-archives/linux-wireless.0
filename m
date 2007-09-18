Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:24699 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbXIRQvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 12:51:43 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1644996rvb
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2007 09:51:42 -0700 (PDT)
Message-ID: <1ba2fa240709180951v3dc0a98ay11205296fd5768a@mail.gmail.com>
Date: Tue, 18 Sep 2007 18:51:42 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: add sta_notify callback
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1190054680.23521.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1190036530108-git-send-email-tomas.winkler@intel.com>
	 <1190054680.23521.23.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/17/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-09-17 at 15:42 +0200, Tomas Winkler wrote:
>
> > +     void (*sta_notify)(struct ieee80211_hw *hw,
> > +                             sta_notify_cmd cmd, const u8 *addr);
>
> I have plans to make the sta_info structs per-netdev so that we can
> support having the same station associate to multiple virtual APs and
> not hurting WDS links etc. This is not too hard, but needs some thought.
>
> However, for this callback to be correct when the same sta_info struct
> can be present for multiple virtual interfaces, we need to be able to
> distinguish somehow, so this callback should probably get an if_idx that
> allows a driver to map to the right interface because in add_interface
> it was given the same if_idx.
>
> I know this doesn't matter for iwlwifi because it only supports a single
> local MAC address and currently not even WDS/AP mode at the same time
> (nor AP mode at all? haven't checked).

Actually I'm interested in this feature 4965AGN HW supports multiple
MAC addresses.
Need to enabled it also in the driver but this is few month away till
I get there.

> And I wonder if there will ever

AP mode is functional yet not the whole code is  published I want to
roll it in slowly and I need the patch I sent for it.
The legacy AP mode (not 11n) should be functional even on the current code base.

> be any hardware that cares and supports the configuration that would
> require it Should we just leave it and add a comment that when the
> driver supports multiple interfaces this callback is unusable?

It

> Thoughts? Do you have plans to, say, support combined WDS/AP modes?
Yes
If
> so, would the firmware be able to distinguish between the same STA
> sending WDS frames and trying to associate?
Yes it will

I don't know if any current
> software supports that but I see nothing precluding it either. Or say
> you have a WDS interface and also associate with a client interface to
> the same AP; we could easily do that with b43 by allowing WDS interfaces
> with the same MAC address in parallel all the time.
>
> johannes
>
>
