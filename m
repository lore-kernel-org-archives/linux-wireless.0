Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab3BAJ4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 04:56:38 -0500
Message-ID: <1359712620.8528.5.camel@jlt4.sipsolutions.net> (sfid-20130201_105641_868424_FDAC8EF1)
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 01 Feb 2013 10:57:00 +0100
In-Reply-To: <20130131174758.GC2018@pandem0nium>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359643448.8415.62.camel@jlt4.sipsolutions.net>
	 <20130131163126.GB1387@pandem0nium>
	 <1359650902.8415.93.camel@jlt4.sipsolutions.net>
	 <20130131174758.GC2018@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 18:47 +0100, Simon Wunderlich wrote:

> > > What I've tried:
> > >  * configure 2 SSIDs in hostapd, start it
> > >  * both wlan0 and wlan0-1 got created
> > >  * only wlan0 comes up, wlan0-1 was rejected because of missing channel combinations
> > >  * now I've injected a radar - which should be sent to wlan0 and wlan0-1
> > >  * wlan0 could send the event, but wlan0-1 had no bss configured and therefore no chandef
> > > 
> > > I can change this comment to "may happen to devices which have currently no BSS configured",
> > > maybe that it is not so confusing ...
> > 
> > Not sure I understand, how would the radar detected event come to an
> > interface that doesn't really exist for the driver?
> 
> wlan0-1 exists and was created, but no AP was ever started - because hostapd tried
> to start the AP on a DFS channel when wlan0 was already active, and thanks to our
> interface combinations this is not allowed. Therefore, the vif.bss_conf.chandef is empty.
> 
> The interface does exist for the driver (interface add succeeded), but start_ap failed,
> so it is a virgin AP interface.
> 
> I think this behaviour is correct like that ...

So ... starting the AP failed because it was a different channel, it was
added to the driver because multiple AP interfaces were allowed but the
specific channel wasn't allowed (in addition) when it was started? But I
still don't see why that interface should get an event since it doesn't
even have a channel yet, except maybe preset_chan which is really only
for backward compatibility reasons?

What am I missing? Where does the event on wlan0-1 come from anyway?

johannes

