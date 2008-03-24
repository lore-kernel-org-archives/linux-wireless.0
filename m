Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:38885 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbYCXO4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 10:56:25 -0400
Received: by gv-out-0910.google.com with SMTP id s4so384481gve.37
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2008 07:56:23 -0700 (PDT)
Message-ID: <1ba2fa240803240756k4c946158qe9d138e87278f06f@mail.gmail.com> (sfid-20080324_145632_472400_B38DFACC)
Date: Mon, 24 Mar 2008 16:56:22 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH] mac80211: trigger ieee80211_sta_work after opening interface
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Jan Niehusmann" <jan@gondor.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>, "Jiri Benc" <jbenc@suse.cz>
In-Reply-To: <1206369154.23379.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080323192355.GA5773@x61s.gondor.com>
	 <1206310595.16475.190.camel@johannes.berg>
	 <1ba2fa240803231528i4fc38343ifb49d44f5072c882@mail.gmail.com>
	 <1206369154.23379.4.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 24, 2008 at 4:32 PM, Dan Williams <dcbw@redhat.com> wrote:
>
> On Mon, 2008-03-24 at 00:28 +0200, Tomas Winkler wrote:
>  > On Mon, Mar 24, 2008 at 12:16 AM, Johannes Berg
>  > <johannes@sipsolutions.net> wrote:
>  > >
>  > >  On Sun, 2008-03-23 at 20:23 +0100, Jan Niehusmann wrote:
>  > >  > ieee80211_sta_work is disabled while network interface
>  > >  > is down. Therefore, if you configure wireless parameters
>  > >  > before bringing the interface up, these configurations are
>  > >  > not yet effective and association fails.
>  > >  >
>  > >  > A workaround from userspace is calling a command like
>  > >  > 'iwconfig wlan0 ap any' after the interface is brought up.
>  > >  >
>  > >  > To fix this behaviour, trigger execution of ieee80211_sta_work from
>  > >  > ieee80211_open when in STA or IBSS mode.
>  > >
>  > >  What happens with this patch when you haven't set any configuration
>  > >  items before bringing the interface up? We want it to do nothing, if
>  > >  that behaviour is kept the patch should be fine.
>  >
>  > Why should be possible to configure device when it's not up. Shouldn't
>  > be there some order in which things are happening?
>
>  This was the way that wireless-tools/WEXT worked with older fullmac type
>  cards; the driver would usually cache the value until the device came up
>  (and then blast all cached values to the card and try to associate) or
>  the firmware would still accept commands while the interface was down
>  because the firmware was already on the card and didn't have to be
>  loaded at runtime.

I'm stopping to like the idea of having firmware loaded in open, there
is conceptual
problem with this as we've seen in rfkill and now the configuration.
Probe is a problem because the filesystem is not available so there
have to be something in between.


>  These days, of course, with cards that load firmware on open() (ex iwl
>  to save power, and others) this isn't possible unless the driver caches
>  the values until the device is brought up.
>
>  Personally, I don't really think this is an issue.  Things change, some
>  cards don't allow scanning when they are down, etc.  It's a lot of code
>  to cache the values in the driver that isn't really needed if people
>  just start setting the device up before configuring it.  I think the
>  tradeoff of having to modify userspace tool behavior versus having to
>  maintain more code in the drivers/stack is quite clear: less code in
>  mac80211/drivers.

Aggree

Tomas
