Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:39646 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZLTSoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 13:44:00 -0500
Received: by ewy1 with SMTP id 1so5573213ewy.28
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 10:43:58 -0800 (PST)
To: andreamrl@tiscali.it
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Florian Zumbiehl <florz@florz.de>, herton@mandriva.com.br,
	htl10@users.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for  low-power USB 802.11 adapter?
References: <20091218180205.GD2512@florz.florz.dyndns.org>
	<4B2BC7E3.2050907@lwfinger.net>
	<20091218185916.GE2512@florz.florz.dyndns.org>
	<4B2C100A.9000507@lwfinger.net>
	<c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 20 Dec 2009 20:43:56 +0200
In-Reply-To: <c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com> (Andrea Merello's message of "Sat\, 19 Dec 2009 01\:15\:15 +0100")
Message-ID: <878wcxzdsj.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrea Merello <andreamrl@tiscali.it> writes:

> Even if potentially the 802.11 protocol can probably work even without
> beacons (even it might seems a contraddiction, I think it is true if
> you are NOT using powersave functionality), currently I suspect the
> mac80211 wants them in order to calculate network quality (missed
> beacon rate) and it might even send more probes (TX is other power
> burnt out) if it cannot detect beacons.

mac80211 does support beacon filtering, see IEEE80211_HW_BEACON_FILTER
for more.

> Even worse, even if one will modify the mac80211 in order to live
> without beacons, I think it can't be told to the rtl8187 to filter out
> beacons. The HW can filter out all management frames, but not only
> beacons.

Yeah, HW support is needed for this feature.

-- 
Kalle Valo
