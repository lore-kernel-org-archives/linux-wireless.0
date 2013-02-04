Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3BDRbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:31:44 -0500
Message-ID: <1359999125.17993.15.camel@jlt4.sipsolutions.net> (sfid-20130204_183148_095972_6621D648)
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Mon, 04 Feb 2013 18:32:05 +0100
In-Reply-To: <20130202221544.GA22363@pandem0nium>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359643448.8415.62.camel@jlt4.sipsolutions.net>
	 <20130131163126.GB1387@pandem0nium>
	 <1359650902.8415.93.camel@jlt4.sipsolutions.net>
	 <20130131174758.GC2018@pandem0nium>
	 <1359712620.8528.5.camel@jlt4.sipsolutions.net>
	 <20130202221544.GA22363@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-02-02 at 23:15 +0100, Simon Wunderlich wrote:
> On Fri, Feb 01, 2013 at 10:57:00AM +0100, Johannes Berg wrote:
> > On Thu, 2013-01-31 at 18:47 +0100, Simon Wunderlich wrote:
> > 
> > > > > What I've tried:
> > > > >  * configure 2 SSIDs in hostapd, start it
> > > > >  * both wlan0 and wlan0-1 got created
> > > > >  * only wlan0 comes up, wlan0-1 was rejected because of missing channel combinations
> > > > >  * now I've injected a radar - which should be sent to wlan0 and wlan0-1
> > > > >  * wlan0 could send the event, but wlan0-1 had no bss configured and therefore no chandef
> > > > > 
> > > > > I can change this comment to "may happen to devices which have currently no BSS configured",
> > > > > maybe that it is not so confusing ...
> > > > 
> > > > Not sure I understand, how would the radar detected event come to an
> > > > interface that doesn't really exist for the driver?
> > > 
> > > wlan0-1 exists and was created, but no AP was ever started - because hostapd tried
> > > to start the AP on a DFS channel when wlan0 was already active, and thanks to our
> > > interface combinations this is not allowed. Therefore, the vif.bss_conf.chandef is empty.
> > > 
> > > The interface does exist for the driver (interface add succeeded), but start_ap failed,
> > > so it is a virgin AP interface.
> > > 
> > > I think this behaviour is correct like that ...
> > 
> > So ... starting the AP failed because it was a different channel, it was
> > added to the driver because multiple AP interfaces were allowed but the
> > specific channel wasn't allowed (in addition) when it was started? But I
> > still don't see why that interface should get an event since it doesn't
> > even have a channel yet, except maybe preset_chan which is really only
> > for backward compatibility reasons?
> > 
> > What am I missing? Where does the event on wlan0-1 come from anyway?
> 
> In the (dummy) ath9k part I'm handling the radar by simply sending radar events
> to all ieee80211_vifs which are registered on this phy - regardless their
> status, if they are up or not. That's why both wlan0 and wlan0-1 get the
> event in my example. Of course, sending the event to wlan0-1 is pretty
> useless in my case, but we should better check. :)

That sounds strange -- how does ath9k even know about an interface
that's not UP? Maybe you mean it didn't start an AP?

Why does the driver even report it by interface? It seems it should do
it on a channel context, or even on the hw since it can only be a single
channel in that case anyway?

johannes

