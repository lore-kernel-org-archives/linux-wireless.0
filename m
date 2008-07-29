Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:29976 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbYG2VSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 17:18:37 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	<48874F09.7060400@lwfinger.net>
	<3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	<200807290021.45400.herton@mandriva.com.br>
	<1217314430.15381.11.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 30 Jul 2008 00:17:36 +0300
In-Reply-To: <1217314430.15381.11.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 29 Jul 2008 08\:53\:50 +0200")
Message-ID: <878wvkl79r.fsf@nokia.com> (sfid-20080729_231840_323876_81D6220E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2008-07-29 at 00:21 -0300, Herton Ronaldo Krzesinski wrote:
>
>> [3] /sbin/iwconfig wlan0 power on
>
> I don't think turning on power management (yes, this command is
> completely misnamed, it turns on power _management_ not the power, you
> may want "txpower auto") does anything on this chip, does it?

There isn't any driver yet in wireless-testing which supports
IEEE80211_CONF_PS:

$ git grep -l IEEE80211_CONF_PS
include/net/mac80211.h
net/mac80211/wext.c
$

So yes, currently 'iwconfig wlan0 power' shouldn't change any
behavious, expect an extra call to config() op.

-- 
Kalle Valo
