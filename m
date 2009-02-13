Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65070 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbZBMT3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 14:29:48 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 11:29:48 -0800
Date: Fri, 13 Feb 2009 11:29:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Dan Williams <dcbw@redhat.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jan Schneider <jan@horde.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Automatic/manual regulatory settings
Message-ID: <20090213192904.GB4278@tesla> (sfid-20090213_202952_307005_6193A47C)
References: <20090212181959.11876f8viq636hs0@neo.wg.de> <1234471883.24344.2.camel@localhost> <43e72e890902121443s307163ecide0f40bdc5a5818f@mail.gmail.com> <1234539881.3173.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1234539881.3173.8.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 07:44:41AM -0800, Dan Williams wrote:
> On Thu, 2009-02-12 at 14:43 -0800, Luis R. Rodriguez wrote:
> > On Thu, Feb 12, 2009 at 12:51 PM, Dan Williams <dcbw@redhat.com> wrote:
> > > On Thu, 2009-02-12 at 18:19 +0100, Jan Schneider wrote:
> > >> While looking at logs collected for my microcode crash problem I
> > >> noticed that cfg80211 loads US regulatory settings.
> > >> If I understand the documentation correctly the actual country should
> > >> be set either by the AP or the device using cfg80211. Neither seems to
> > >> happen, so is it the "correct" way to do this through the
> > >> ieee80211_regdom module parameter? And I wonder how this is supposed
> > >> to happen "idiot-proof" in the future?
> > >
> > > In the future it would get set by whatever configures your network
> > > connection.  Either system scripts like ifup/ifdown, or configured
> > > manually in the config files that ifup/ifdown use, or automatically via
> > > NetworkManager based on some setting, or via NetworkManager based on a
> > > user-override.
> > >
> > > One idea I've toyed with for NetworkManager is using the city you select
> > > in the GUI Timezone control panel that all desktop environments for
> > > timezone selection.  Just a thought.  Or, it could come from a
> > > system-wide setting by your sysadmin in /etc, or set on a per-connection
> > > basis when you set up the NetworkManager connection for that AP in the
> > > NM connection editor.
> >
> > I think it'd be nice to leverage all these different possible location
> > based hints to help with your location -- and more. I think GeoClue
> > does such a thing (works with dbus and all), but I have not yet had
> > time to try it.
> >
> > http://www.freedesktop.org/wiki/Software/GeoClue
> 
> Yeah, if there's GPS available on the system we can certainly use that
> too :)

Absolutely, so does this seem to heavy for a distribution to carry? It seems
openhand is working on this which makes me believe it should work on mobile
devices pretty well.

  Luis
