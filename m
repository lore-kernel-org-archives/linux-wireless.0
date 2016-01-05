Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38293 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbcAEQFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 11:05:52 -0500
Message-ID: <1452009950.12357.46.camel@sipsolutions.net> (sfid-20160105_170555_662907_31696412)
Subject: Re: warning at net/mac80211/driver-ops.h:647
 ieee80211_sta_wmm_params
From: Johannes Berg <johannes@sipsolutions.net>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Tue, 05 Jan 2016 17:05:50 +0100
In-Reply-To: <567FCB67.1000101@gmx.de> (sfid-20151227_122919_319415_803E9245)
References: <567FCB67.1000101@gmx.de> (sfid-20151227_122919_319415_803E9245)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-12-27 at 12:28 +0100, Toralf Förster wrote:
> Yesterday I got this warning for the first time while using WLAN in a
> train, I'm unsure if this warning is worth to be reported or not :

Definitely worth it, thanks!

> Dec 26 20:26:48 t44 kernel: [45827.647635] cfg80211:   (5490000 KHz -
> 5710000 KHz @ 160000 KHz), (N/A, 2700 mBm), (0 s)
> Dec 26 20:26:48 t44 kernel: [45827.647637] cfg80211:   (57000000 KHz
> - 66000000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
> Dec 26 20:26:48 t44 kernel: [45827.700734] ------------[ cut here ]
> ------------
> Dec 26 20:26:48 t44 kernel: [45827.700762] WARNING: CPU: 0 PID: 1498
> at net/mac80211/driver-ops.h:647 ieee80211_sta_wmm_params+0x3f7/0x410
> [mac80211]()
> Dec 26 20:26:48 t44 kernel: [45827.700764] wlp3s0: invalid
> CW_min/CW_max: 127/3

Ugly. I once met a guy who worked on the train AP network, should dig
up his contact info ...

In the meantime, we should catch this bug at a higher layer and do ...
something. But what exactly? Use default WMM parameters like we usually
do in cases like this?


johannes
