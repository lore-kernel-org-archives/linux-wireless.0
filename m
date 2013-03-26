Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760108Ab3CZSiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 14:38:54 -0400
Message-ID: <1364323118.8319.13.camel@jlt4.sipsolutions.net> (sfid-20130326_193903_336333_E6353AD0)
Subject: Re: Scanning regression since "cfg80211: use DS or HT operation IEs
 to determine BSS channel"
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Date: Tue, 26 Mar 2013 19:38:38 +0100
In-Reply-To: <CACna6rwdAAsCX76=nwHpj-grVvQznbNCPVnpXL9kP2TkvhR-yw@mail.gmail.com> (sfid-20130326_181054_958567_0E045FFC)
References: <CACna6rwdAAsCX76=nwHpj-grVvQznbNCPVnpXL9kP2TkvhR-yw@mail.gmail.com>
	 (sfid-20130326_181054_958567_0E045FFC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-26 at 18:10 +0100, Rafał Miłecki wrote:

> I've just finished bisecting wireless scanning regression I'm
> experiencing with my 14e4:432b (BCM4322) and b43 driver.

Hmmm.

> The problem is getting my network visible in scanning results (iw dev
> wlan0 scan). I've to repeat scanning dozens of time to notice my AP.
> It's also well visible when using wpa_supplicant. It takes from 20s to
> 100s before I get the "Trying to authenticate with".

That's strange.

> After going back to the kernel before that commit it takes
> wpa_supplicant less than 2 seconds to connect to my WiFi network.

> My network is at channel 13, I still have to verify if it matters.
> 
> Any thought about that?
> 
> 
> The first bad commit (I've verified manually after bisecting) appears to be:

"verified manually" how? By reverting the commit? But anyway the commit
is clearly scanning related, so ...

Can you check your channel list? (iw list or iw phy0 info)

Also can you show the full data including beacon data from the AP (iw
wlan0 scan dump -b) please?

Does reverting just the mac80211 change fix it?

johannes

