Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1A0N3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 08:29:22 -0500
Subject: Re: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTimTASMMUhofp=1o=Z6-dY7v8T8uoNLbqYK4TStv@mail.gmail.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
	 <1295816579-28925-3-git-send-email-arik@wizery.com>
	 <1295868924.3639.2.camel@jlt3.sipsolutions.net>
	 <AANLkTinJo7EV7zr=Z6oN3M2X3=gcv1W8G7cpbHPPNs=0@mail.gmail.com>
	 <1295950325.3650.5.camel@jlt3.sipsolutions.net>
	 <AANLkTin49svPAzuhH-ENdzoa4FnTRyOeizKrTLNYLOeu@mail.gmail.com>
	 <1296030720.3635.14.camel@jlt3.sipsolutions.net>
	 <AANLkTimTASMMUhofp=1o=Z6-dY7v8T8uoNLbqYK4TStv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 14:29:19 +0100
Message-ID: <1296134959.3622.37.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 23:51 +0200, Arik Nemtsov wrote:
> On Wed, Jan 26, 2011 at 10:32, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2011-01-26 at 08:00 +0200, Arik Nemtsov wrote:
> >
> >> >> > Why use a separate command for this, and not do it like the SSID? I also
> >> >>
> >> >> Its only relevant to AP-mode (at least for now) so bss_conf didn't
> >> >> seem appropriate.
> >> >> Also since its a dynamically allocated buffer it should be protected by RCU.
> >> >
> >> > But all that is unrelated to the nl80211 API, no? Also the SSID already
> >> > uses bss_conf too, and it's AP mode too...
> >>
> >> Do you have a preferred alternative?
> >
> > What's wrong with putting it in the same place as the SSID?
> 
> Just put it as a pointer inside ieee80211_bss_conf? (It will still
> have to be RCU managed and all).
> About nl80211 API - I tried making it as similar as possible to the
> way the beacon works, but I guess I can pass it with bss_parameters as
> well.

Wait, no, I don't get it -- what does the nl80211 API have to do with
how mac80211 manages it? I think for the nl80211 API the new command
doesn't make a whole lot of sense. What happens in mac80211 I don't
think matters much.

johannes

